package com.vegayan.controllers;

import com.vegayan.connectivity.Connectivity;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Calendar;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Login extends HttpServlet {

    // Logger to track successful and failed login attempts
    private static final Logger logger = Logger.getLogger(Login.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Connectivity con = new Connectivity();
            response.setContentType("text/html");
            response.setHeader("Cache-control", "no-cache, no-store");
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Expires", "-1");

            PrintWriter out = response.getWriter();
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            DateFormat dateFormat1 = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy_MM_dd");
            LocalDateTime now = LocalDateTime.now();

            // Sanitize and validate input
            if (username == null || password == null || username.isEmpty() || password.isEmpty()) {
                logger.warning("Invalid login attempt: Empty username or password");
                response.sendRedirect("/VPortalNTT/login.jsp");
                return;
            }

            // Sanitize username and password (no special characters)
            if (!username.matches("^[a-zA-Z0-9._-]+$") || password.length() < 6) {
                logger.warning("Invalid login attempt: Invalid characters in username or password");
                response.sendRedirect("/VPortalNTT/login.jsp");
                return;
            }

            String[] authResp;

            try {
                authResp = con.userAuthenticate(username, password);
            } catch (Exception ex) {
                logger.log(Level.SEVERE, "Error during authentication", ex);
                request.setAttribute("exception", ex);
                RequestDispatcher rd = request.getRequestDispatcher("/error.jsp");
                rd.forward(request, response);
                return;
            }

            // Successful login
            if (authResp[0].equals("success")) {

                HttpSession oldSession = request.getSession(false);
                if (oldSession != null) {
                    oldSession.setAttribute("loginAttempts", "0");
                    oldSession.setAttribute("loginStartTime", "0");
                    oldSession.invalidate();
                }

                HttpSession session = request.getSession();
                session.setAttribute("user", username);
                session.setAttribute("role", authResp[1]);
                session.setAttribute(username, new SessionBinding());

                SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy");
                Calendar today1 = Calendar.getInstance();
                today1.add(Calendar.DATE, -1);
                String strDate = dateFormat.format(today1.getTime());
                String today = "";
                try {
                    Date varDate = dateFormat.parse(strDate);
                    dateFormat = new SimpleDateFormat("MM-dd-yyyy");
                    today = dateFormat.format(varDate);
                } catch (Exception e) {
                    e.printStackTrace();
                }

                String sess_id = session.getId();
                String ipAddress = request.getRemoteAddr();

                // Log successful login attempt
                logger.info("Successful login for user: " + username + " from IP: " + ipAddress + " at " + dateFormat1.format(new Date()));

                // Enforce access control based on role
                if (authResp[1].equals("NTT")) {
                    response.sendRedirect("/VPortalNTT/dashboard/summary-dashboard.jsp");
                } else if (authResp[1].equals("NTTAdmin")) {
                    response.sendRedirect("/VPortalNTT/admin/createDiscovery.jsp");
                } else {
                    response.sendRedirect("/VPortalNTT/login.jsp");
                }

            } else if (authResp[0].equals("AlreadyLogged")) {
                HttpSession session = request.getSession(false);
                if (session != null) {
                    session.invalidate();
                }
                RequestDispatcher rd = request.getRequestDispatcher("AlreadyLoggedSession");
                rd.forward(request, response);
            } else {
                HttpSession session = request.getSession();
                String sess_id = session.getId();
                String ipAddress = request.getRemoteAddr();
                DateFormat dateFormat3 = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
                Calendar cal = Calendar.getInstance();

                // Increment login attempts on failed login
                if (session.getAttribute("loginAttempts") == null) {
                    session.setAttribute("loginAttempts", 0);
                    session.setAttribute("initalLoginTime", now);
                    request.setAttribute("loginAttempts", 0);
                    response.sendRedirect("/VPortalNTT/login.jsp");
                } else if (((int) session.getAttribute("loginAttempts")) <= 2) {
                    int loginAttempts = (int) session.getAttribute("loginAttempts") + 1;
                    session.setAttribute("loginAttempts", loginAttempts);
                    logger.warning("Failed login attempt " + loginAttempts + " for user: " + username + " from IP: " + ipAddress + " at " + dateFormat1.format(new Date()));
                    request.setAttribute("loginAttempts", loginAttempts);
                    response.sendRedirect("/VPortalNTT/login.jsp");
                } else {
                    int loginAttempts = (int) session.getAttribute("loginAttempts") + 1;
                    session.setAttribute("loginAttempts", loginAttempts);
                    logger.warning("Suspicious activity: Too many failed login attempts from IP: " + ipAddress + " for user: " + username + " at " + dateFormat1.format(new Date()));
                    // Implement potential blocking mechanism here (e.g., block the IP temporarily)
                    request.setAttribute("loginAttempts", loginAttempts);
                    response.sendRedirect("/VPortalNTT/login.jsp");
                }
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error during login process", e);
            request.setAttribute("exception", e);
            RequestDispatcher rd = request.getRequestDispatcher("/error.jsp");
            rd.forward(request, response);
        }
    }

    // Method to hash passwords securely
    private String hashPassword(String password) throws NoSuchAlgorithmException {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hash = digest.digest(password.getBytes());
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            hexString.append(String.format("%02x", b));
        }
        return hexString.toString();
    }
}
