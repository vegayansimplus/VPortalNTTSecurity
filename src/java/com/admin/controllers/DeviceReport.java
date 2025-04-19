package com.admin.controllers;

import com.admin.connectivity.AdminConnectivity;
import com.google.gson.Gson;
import com.user.connectivity.UserConnectivity;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

/**
 *
 * @author lapto
 */
public class DeviceReport extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AdminConnectivity con = new AdminConnectivity();
        response.setContentType("application/json;charset=UTF-8"); // Ensure JSON response format
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession(false);

        // Ensure session exists and is valid
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401 Unauthorized
            out.print("{\"error\": \"User not logged in\"}");
            out.flush();
            return;
        }

        // Ensure user has the necessary roles (e.g., Admin)
        String userRole = (String) session.getAttribute("role");
        if (userRole == null || !userRole.equals("Admin")) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403 Forbidden
            out.print("{\"error\": \"Access denied\"}");
            out.flush();
            return;
        }

        Gson gs = new Gson();
        String resp = "";
        try {
            // Validate input data (e.g., nodeip, requestType)
            int reportType = Integer.parseInt(request.getParameter("requestType"));
            String nodeip = request.getParameter("nodeip");

            // Sanitize nodeip to prevent potential injection attacks
            if (nodeip != null && !nodeip.matches("^([0-9]{1,3}\\.){3}[0-9]{1,3}$")) { // Basic IP address validation
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400 Bad Request
                out.print("{\"error\": \"Invalid IP address format\"}");
                out.flush();
                return;
            }

            switch (reportType) {
                case 1:
                    resp = con.getProvisionedDevicesList();
                    break;
                case 2:
                    resp = con.getDeProvisionedDevicesList();
                    break;
                case 3:
                    resp = con.deleteDevice(nodeip);
                    System.out.println("resp:" + resp);
                    break;
                default:
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400 Bad Request
                    out.print("{\"error\": \"Invalid report type\"}");
                    out.flush();
                    return;
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400 Bad Request
            out.print("{\"error\": \"Invalid request type\"}");
            out.flush();
            return;
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500 Internal Server Error
            out.print("{\"error\": \"An error occurred\"}");
            out.flush();
            return;
        }

        out.print(resp);
        out.flush();
        out.close();
    }
}
