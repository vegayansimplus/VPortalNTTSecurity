package com.admin.controllers;

import com.admin.connectivity.AdminConnectivity;
import com.vegayan.pack.SSHConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * @author lapto
 */
public class DeviceReachability extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // A02: Cryptographic Failures - Ensure HTTPS communication is enforced
        if (!request.isSecure()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "HTTPS is required for secure communication.");
            return;
        }

        // A07: Identification & Authentication Failures - Check user session and role
        Object userSession = request.getSession().getAttribute("user");
        if (userSession == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not authenticated.");
            return;
        }

        String userRole = (String) request.getSession().getAttribute("userRole");
        if (userRole == null || !userRole.equals("admin")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Insufficient permissions.");
            return;
        }

        AdminConnectivity con = new AdminConnectivity();

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        String resp = "";
        int reportType = -1;

        try {
            reportType = Integer.parseInt(request.getParameter("filterType"));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid report type.");
            return;
        }

        String ip = request.getParameter("ip");
        String packet = request.getParameter("packet");
        String byte1 = request.getParameter("byte");

        // A03: Injection - Sanitize and validate inputs to prevent injection attacks
        if (!isValidIp(ip) || !isValidPacket(packet) || !isValidByte(byte1)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid input parameters.");
            return;
        }

        SSHConnection sshc1 = new SSHConnection();
        switch (reportType) {
            case 1:
                resp = sshc1.initiateRequest("sh /home/vegyan/Scripts/Device_Reachability/dash_ping.sh " + sanitize(packet) + " " + sanitize(byte1) + " " + sanitize(ip), "RS");
                break;
            case 2:
                resp = sshc1.initiateRequest("sh /home/vegyan/Scripts/Device_Reachability/dash_tracepath.sh " + sanitize(ip), "RS");
                break;
            case 3:
                // A03: Injection - Sanitize all SNMP parameters
                String nodeip1 = sanitize(request.getParameter("nodeip"));
                String username1 = sanitize(request.getParameter("username"));
                String authid = sanitize(request.getParameter("authid"));
                String secid = sanitize(request.getParameter("secid"));
                String authproto = sanitize(request.getParameter("authproto"));
                String encrypt = sanitize(request.getParameter("encrypt"));
                String community = sanitize(request.getParameter("community"));

                resp = sshc1.initiateRequest("sh /TNWNMS/scripts/dash_snmp_check.sh " + nodeip1 + " " + username1 + " " + authid + " " + secid + " " + authproto + " " + encrypt + " " + community, "RS");
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid report type.");
                return;
        }

        // A05: Security Misconfiguration - Hide detailed errors from users in production
        if (resp == null || resp.isEmpty()) {
            resp = "Error: Unable to process the request.";
        }

        out.print(resp);
        out.flush();
        out.close();
    }

    // A03: Injection - Validate if IP is in a valid format
    private boolean isValidIp(String ip) {
        return ip != null && ip.matches("^(([0-9]{1,3})\\.){3}[0-9]{1,3}$");
    }

    // A03: Injection - Validate packet size to avoid malicious data
    private boolean isValidPacket(String packet) {
        return packet != null && packet.matches("\\d+");
    }

    // A03: Injection - Validate byte size to avoid malicious data
    private boolean isValidByte(String byte1) {
        return byte1 != null && byte1.matches("\\d+");
    }

    // A03: Injection - Sanitize input to prevent injection
    private String sanitize(String input) {
        if (input == null) {
            return "";
        }
        // Basic sanitization to remove harmful characters, you may need more depending on your use case
        return input.replaceAll("[^a-zA-Z0-9_\\-\\.]", "");
    }
}
