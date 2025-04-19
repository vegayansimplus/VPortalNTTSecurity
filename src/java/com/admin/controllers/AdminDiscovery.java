/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.admin.controllers;

import com.admin.connectivity.AdminConnectivity;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.File;
import java.io.FileWriter;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Calendar;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author lapto
 */
public class AdminDiscovery extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        AdminConnectivity acon = new AdminConnectivity();
        PrintWriter out = response.getWriter();
        String resp = "";

        // Fetching session and user role
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("user");
        String userRole = (String) session.getAttribute("role");

        // Check for proper authorization for access to the resource
        if (userRole == null || !userRole.equals("Admin")) {  // Only allow admins to access this servlet
            response.sendRedirect("/accessDenied.jsp");  // Redirect to access denied page
            return;
        }

        // Proceed with the rest of the logic after role validation
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy_MM_dd");
        LocalDateTime now = LocalDateTime.now();
        DateFormat dateFormat1 = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        String fileName = "/home/vegyan/Logs/user_activity_log_" + dtf.format(now) + ".txt";
        File logFile = new File(fileName);

        Calendar cal = Calendar.getInstance();
        String sess_id = session.getId();
        String ipAddress = request.getRemoteAddr();

        int reportType = Integer.parseInt(request.getParameter("requesttype"));
        switch (reportType) {
            case 2:
                String data = request.getParameter("data");

                // Logging user actions
                FileWriter fr2 = new FileWriter(logFile, true);
                fr2.write("Time : " + dateFormat1.format(cal.getTime()) + "  | SESS_ID :" + sess_id + " | USER : " + username + " | IP : " + ipAddress + " | Message : Discovery Data: " + data + "\n");
                fr2.close();

                // Securely save data with error handling
                try {
                    resp = acon.saveSNMPData(data);
                } catch (SQLException ex) {
                    Logger.getLogger(AdminDiscovery.class.getName()).log(Level.SEVERE, null, ex);
                }
                // Log the response after action
                FileWriter fr3 = new FileWriter(logFile, true);
                fr3.write("Time : " + dateFormat1.format(cal.getTime()) + "  | SESS_ID :" + sess_id + " | USER : " + username + " | IP : " + ipAddress + " | Message : Response From Discovery Data: " + data + " Response :" + resp + "\n");
                fr3.close();
                break;
            case 3:
                resp = acon.getSNMPIPCheckDetails();
                break;
        }
        out.print(resp);
        out.flush();
        out.close();
    }

}
