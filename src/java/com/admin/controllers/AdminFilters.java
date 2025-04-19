package com.admin.controllers;

import com.admin.connectivity.AdminConnectivity;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.logging.Logger;

public class AdminFilters extends HttpServlet {

    private static final Logger logger = Logger.getLogger(AdminFilters.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Ensure secure connection via HTTPS
        if (!request.isSecure()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Secure connection (HTTPS) required.");
            return;
        }

        AdminConnectivity con = new AdminConnectivity();
        response.setContentType("text/html;charset=UTF-8");

        PrintWriter out = response.getWriter();
        String resp = "";

        // Retrieve the session and check user role for authorization
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_role") == null || !session.getAttribute("user_role").equals("admin")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You do not have permission to access this resource.");
            return;
        }

        // Prevent SQL injection and ensure parameterized query usage
        String authproto1 = request.getParameter("authproto");
        String group = request.getParameter("group");

        // Sanitize inputs to prevent malicious data
        if (authproto1 == null || group == null || !isValidInput(authproto1) || !isValidInput(group)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid input detected.");
            return;
        }

        int reportType;
        try {
            reportType = Integer.parseInt(request.getParameter("requestType"));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid report type.");
            return;
        }

        // Handle report types
        switch (reportType) {
            case 1:
                resp = con.getGroupNameFilter();
                break;
            case 2:
                resp = con.getUsernameFilter();
                break;
            case 3:
                resp = con.getAuthProtoFilter();
                break;
            case 4:
                resp = con.getEncryptFilter(authproto1);
                break;
            case 5:
                resp = con.getNodeIPFilter(group);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request type.");
                return;
        }

        // Output response
        out.print(resp);
        out.flush();
        out.close();
    }

    // Input validation to prevent SQL injection or malicious characters
    private boolean isValidInput(String input) {
        // Only allow alphanumeric characters and some basic punctuation (for example, spaces, underscores)
        return input != null && input.matches("[A-Za-z0-9_ ]+");
    }
}
