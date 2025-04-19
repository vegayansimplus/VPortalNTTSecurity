package com.admin.controllers;

import com.admin.connectivity.AdminConnectivity;
import com.google.gson.Gson;
import com.jcraft.jsch.SftpException;
import com.vegayan.pack.Config;
import com.vegayan.pack.ConfigSSHConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Abhishek
 */
public class ConfigSSHServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Security - Ensure HTTPS connection and valid session
        if (!request.isSecure()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "HTTPS required");
            return;
        }

        // Check if user session exists
        Object userSession = request.getSession().getAttribute("user");
        if (userSession == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not authenticated");
            return;
        }

        // Validate user roles (e.g., only admins can perform sensitive actions)
        String userRole = (String) request.getSession().getAttribute("userRole");
        if (userRole == null || !userRole.equals("admin")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        AdminConnectivity con = new AdminConnectivity();
        int requesttype = Integer.parseInt(request.getParameter("requesttype"));

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        String resp = "";
        String result = "";
        boolean result1;
        String input_data = request.getParameter("inputdata");
        Config cg = new Config();

        // Security - Validate input to avoid injection attacks
        if (input_data != null && input_data.matches("[^a-zA-Z0-9 ]")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid input data");
            return;
        }

        try {
            switch (requesttype) {

                case 3:
                    String file_path_linux;
                    String username = cg.getUSER_NAME();
                    String password = cg.getPASSWORD();
                    String connectionip = cg.getCONNECTION_IP();

                    String prerequiste_check_command = cg.getCOMMAND_DEVICE();
                    System.out.println("username:" + username);
                    System.out.println("Password:" + password);
                    System.out.println("connectionip:" + connectionip);
                    System.out.println("prerequiste_check_command:" + prerequiste_check_command);

                    ConfigSSHConnection sshc1 = new ConfigSSHConnection(username, password, connectionip, 22);

                    // Perform SSH connection and command execution securely
                    resp = sshc1.connect();
                    result = sshc1.sendCommand(prerequiste_check_command);
                    if (result == null) {
                        resp = "success";
                    } else {
                        resp = "fail";
                    }
                    break;

                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request type");
                    return;
            }
        } catch (NumberFormatException e) {
            result = "Exception";
        } catch (Exception e) {
            result = "Error: " + e.getMessage();
        }

        out.println(resp);
        out.flush();
        out.close();
    }
}
