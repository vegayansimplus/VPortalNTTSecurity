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

public class UserFilters extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserConnectivity con = new UserConnectivity();
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession(false);
        Gson gs = new Gson();
        String resp = "";

        // ✅ Check for valid session
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("Unauthorized access");
            out.flush();
            return;
        }

        try {
            // ✅ Parse and validate reportType
            int reportType = Integer.parseInt(request.getParameter("requestType"));
            if (reportType < 1 || reportType > 6) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("Invalid report type");
                out.flush();
                return;
            }

            // ✅ Sanitize input parameters
            String groupName = sanitizeInput(request.getParameter("groupName"));
            String deviceType = sanitizeInput(request.getParameter("deviceType"));
            String nodeName = sanitizeInput(request.getParameter("nodeName"));
            String nodeIP = sanitizeInput(request.getParameter("nodeIP"));

            // ✅ Call respective method
            switch (reportType) {
                case 1:
                    resp = con.getGroupName();
                    break;
                case 2:
                    if (groupName == null) {
                        throw new IllegalArgumentException("groupName is required");
                    }
                    resp = con.getDeviceType(groupName);
                    break;
                case 3:
                    if (groupName == null || deviceType == null) {
                        throw new IllegalArgumentException("groupName and deviceType are required");
                    }
                    resp = con.getNodeName(groupName, deviceType);
                    break;
                case 4:
                    if (groupName == null || deviceType == null) {
                        throw new IllegalArgumentException("groupName and deviceType are required");
                    }
                    resp = con.getNodeIP(groupName, deviceType);
                    break;
                case 5:
                    if (groupName == null || deviceType == null || nodeIP == null) {
                        throw new IllegalArgumentException("groupName, deviceType, and nodeIP are required");
                    }
                    resp = con.getIPWiseNodeName(groupName, deviceType, nodeIP);
                    break;
                case 6:
                    if (groupName == null || deviceType == null || nodeName == null) {
                        throw new IllegalArgumentException("groupName, deviceType, and nodeName are required");
                    }
                    resp = con.getNodeNameWiseNodeIP(groupName, deviceType, nodeName);
                    break;
            }

            out.print(resp);
            out.flush();

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("Invalid requestType format");
            out.flush();
        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("Missing or invalid parameters: " + e.getMessage());
            out.flush();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("Server error occurred. Please try again.");
            out.flush();
        } finally {
            out.close();
        }
    }

    /**
     * Sanitizes input to prevent XSS/injection attacks.
     */
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
