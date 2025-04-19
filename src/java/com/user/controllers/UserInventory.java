package com.user.controllers;

import com.google.gson.Gson;
import com.user.connectivity.UserConnectivity;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class UserInventory extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserConnectivity con = new UserConnectivity();
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession(false);
        Gson gs = new Gson();
        String resp = "";

        // ✅ Session validation
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("Unauthorized access");
            out.flush();
            return;
        }

        try {
            // ✅ Validate report type
            int reportType = Integer.parseInt(request.getParameter("requestType"));
            if (reportType != 1) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("Invalid report type");
                out.flush();
                return;
            }

            // ✅ Sanitize and validate nodeName
            String nodeName = sanitizeInput(request.getParameter("nodeName"));
            if (nodeName == null || nodeName.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("Missing nodeName parameter");
                out.flush();
                return;
            }

            // ✅ Fetch response from backend
            switch (reportType) {
                case 1:
                    resp = con.getNodeInventory(nodeName);
                    break;
            }

            out.print(resp);
            out.flush();

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("Invalid requestType format");
            out.flush();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("Server error occurred. Please try again later.");
            out.flush();
        } finally {
            out.close();
        }
    }

    // ✅ Input sanitization method
    private String sanitizeInput(String input) {
        if (input == null) {
            return null;
        }
        return input.replaceAll("<", "&lt;")
                .replaceAll(">", "&gt;")
                .replaceAll("\"", "&quot;")
                .replaceAll("'", "&#x27;")
                .replaceAll("&", "&amp;")
                .trim();
    }
}
