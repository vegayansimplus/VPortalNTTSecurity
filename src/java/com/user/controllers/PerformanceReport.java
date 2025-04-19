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

/**
 * Servlet to handle performance report requests.
 */
public class PerformanceReport extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserConnectivity con = new UserConnectivity();
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession(false);
        Gson gs = new Gson();
        String resp = "";

        // Validate session
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("Unauthorized access");
            out.flush();
            return;
        }

        try {
            // Validate and sanitize inputs
            int reportType = Integer.parseInt(request.getParameter("requestType"));
            String nodeName = sanitizeInput(request.getParameter("nodeName"));
            String TrafficScale = sanitizeInput(request.getParameter("TrafficScale"));
            String toTime = sanitizeInput(request.getParameter("toTime"));
            String fromTime = sanitizeInput(request.getParameter("fromTime"));
            String nodeIP = sanitizeInput(request.getParameter("nodeIP"));

            // Ensure valid report type
            if (reportType < 1 || reportType > 5) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("Invalid report type");
                out.flush();
                return;
            }

            // Ensure the required parameters are not empty
            if (nodeName == null || TrafficScale == null || fromTime == null || toTime == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("Missing required parameters");
                out.flush();
                return;
            }

            // Process the report based on the report type
            switch (reportType) {
                case 1:
                    resp = con.getPortTraffic(nodeName, fromTime, toTime, TrafficScale);
                    break;
                case 2:
                    resp = con.getCPUTraffic(nodeName);
                    break;
                case 3:
                    resp = con.getTempTraffic(nodeName);
                    break;
                case 4:
                    resp = con.getStorageTraffic(nodeName, fromTime, toTime);
                    break;
                case 5:
                    resp = con.getOSPFReport(nodeIP);
                    break;
                default:
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("Invalid report type");
                    out.flush();
                    return;
            }

            // Send the response
            out.print(resp);
            out.flush();
        } catch (NumberFormatException e) {
            // Handle invalid number format (e.g., reportType or other numeric fields)
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("Invalid parameter format");
            out.flush();
        } catch (Exception e) {
            // Handle general exceptions and log for troubleshooting
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("Server error, please try again later");
            out.flush();
        } finally {
            out.close();
        }
    }

    /**
     * Sanitizes input to prevent XSS and injection attacks.
     *
     * @param input The input string to sanitize.
     * @return The sanitized string.
     */
    private String sanitizeInput(String input) {
        if (input == null) {
            return null;
        }
        return input.replaceAll("<", "&lt;").replaceAll(">", "&gt;").trim();
    }
}
