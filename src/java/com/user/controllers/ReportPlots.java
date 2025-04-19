package com.user.controllers;

import com.user.connectivity.UserConnectivity;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ReportPlots extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        // ✅ Session validation
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("Unauthorized access");
            out.flush();
            return;
        }

        String resp = "";
        UserConnectivity con = new UserConnectivity();

        try {
            int reportType = Integer.parseInt(request.getParameter("requestType"));

            // ✅ Common input sanitization
            String nodeName = sanitize(request.getParameter("nodeName"));
            String interfaceName = sanitize(request.getParameter("interfaceName"));
            String fromTime = sanitize(request.getParameter("fromTime"));
            String toTime = sanitize(request.getParameter("toTime"));
            String scale = sanitize(request.getParameter("unit"));
            String interfaceType = sanitize(request.getParameter("interfaceType"));
            String dateflag = sanitize(request.getParameter("dateflag"));
            String kpiName = sanitize(request.getParameter("kpiName"));
            String kpiflag = sanitize(request.getParameter("kpiflag"));

            switch (reportType) {
                case 1:
                    resp = con.getTrafficPlot(nodeName, interfaceName, fromTime, toTime, scale, interfaceType);
                    break;

                case 2:
                    resp = con.getAnalyticPlot(nodeName, interfaceName, fromTime, toTime, scale, interfaceType, dateflag);
                    break;

                case 3:
                    resp = con.getCPUTempReportGraph(nodeName, kpiName, fromTime, toTime, kpiflag);
                    break;

                default:
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("Invalid report type");
                    out.flush();
                    return;
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("Invalid reportType format");
            out.flush();
            Logger.getLogger(ReportPlots.class.getName()).log(Level.WARNING, "Invalid reportType", e);
            return;
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("SQL error occurred");
            out.flush();
            Logger.getLogger(ReportPlots.class.getName()).log(Level.SEVERE, "SQL Exception", e);
            return;
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("Unexpected error occurred");
            out.flush();
            Logger.getLogger(ReportPlots.class.getName()).log(Level.SEVERE, "Unexpected Exception", e);
            return;
        } finally {
            out.print(resp);
            out.flush();
            out.close();
        }
    }

    // ✅ Sanitization helper
    private String sanitize(String input) {
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
