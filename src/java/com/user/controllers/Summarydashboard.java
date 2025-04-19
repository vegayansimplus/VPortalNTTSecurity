/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
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
 *
 * @author lapto
 */
public class Summarydashboard extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserConnectivity con = new UserConnectivity();
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession(false);
        Gson gs = new Gson();
        String resp = "";
        int reportType = Integer.parseInt(request.getParameter("requestType"));
        String flag = request.getParameter("flag");
        switch (reportType) {
            case 1:
                resp = con.getSummaryDashboardCount();
                break;
            case 2:
                resp = con.getSummaryDashboardCountList(flag);
                break;

        }
        out.print(resp);
        out.flush();
        out.close();
    }
}
