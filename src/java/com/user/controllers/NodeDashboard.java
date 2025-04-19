package com.user.controllers;

import com.user.connectivity.UserConnectivity;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Level;
import java.util.logging.Logger;

public class NodeDashboard extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(NodeDashboard.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserConnectivity con = new UserConnectivity();
        response.setContentType("application/json;charset=UTF-8"); 
        response.setHeader("X-XSS-Protection", "1; mode=block"); // Security Header
        PrintWriter out = response.getWriter();

        String resp = "";
        try {
            // Validate and sanitize inputs to prevent malicious input
            String nodeip = request.getParameter("nodeip");
            String interfacename = request.getParameter("interfacename");

            if (nodeip == null || nodeip.isEmpty() || !isValidIP(nodeip)) {
                throw new IllegalArgumentException("Node IP is missing or invalid");
            }

            // Ensure requestType is valid and numerical
            String requestTypeStr = request.getParameter("requestType");
            if (requestTypeStr == null || !requestTypeStr.matches("\\d+")) {
                throw new IllegalArgumentException("Invalid request type");
            }
            
            int reportType = Integer.parseInt(requestTypeStr);

            switch (reportType) {
                case 1:
                    resp = con.getNodeDashboardHealth(nodeip);
                    break;
                case 2:
                    resp = con.getNodeDashboardInterfaceTable(nodeip);
                    break;
                case 3:
                    if (interfacename == null || interfacename.isEmpty()) {
                        throw new IllegalArgumentException("Interface name is missing or invalid");
                    }
                    resp = con.getNodeDashboardPlot(nodeip, interfacename);
                    break;
                case 4:
                    resp = con.getBottomDashboardHealth(nodeip);
                    break;
                default:
                    throw new IllegalArgumentException("Invalid request type");
            }

            // Send response back to client
            out.print(resp);

        } catch (IllegalArgumentException e) {
            // Log the error and send an error message to the client
            LOGGER.log(Level.WARNING, "Invalid input received", e);
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        } catch (Exception e) {
            // Catch any other exceptions
            LOGGER.log(Level.SEVERE, "Unexpected error", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"An unexpected error occurred\"}");
        } finally {
            out.flush();
            out.close();
        }
    }

    // Utility method to validate IP addresses (Basic validation)
    private boolean isValidIP(String ip) {
        String ipRegex = "^([0-9]{1,3}\\.){3}[0-9]{1,3}$";
        return ip.matches(ipRegex);
    }
}
