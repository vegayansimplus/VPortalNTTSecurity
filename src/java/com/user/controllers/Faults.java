/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.user.controllers;

import com.user.connectivity.UserConnectivity;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;

/**
 *
 * @author lapto
 */
public class Faults extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        UserConnectivity con = new UserConnectivity();
        String resp = "";
        HttpSession session = request.getSession(false);
        String user = session.getAttribute("user").toString();
        int requestType = Integer.parseInt(request.getParameter("requestType"));
        String nodeName = request.getParameter("nodeName");
        String trapType = request.getParameter("trapType");
        String startTime = request.getParameter("startTime");
        String endTime = request.getParameter("endTime");
        String trapDetail = request.getParameter("trapDetail");
        String status=request.getParameter("status");
        switch (requestType) {

            case 1:
                try {
                resp = con.getActiveTraps();

            } catch (Exception ex) {
                Logger.getLogger(Faults.class.getName()).log(Level.SEVERE, null, ex);

            }
            break;
            case 2:
            {
                System.out.println("case 2");
                try {
                    resp = con.getHistoricTraps2(nodeName, trapType, startTime, endTime, trapDetail, status);
                } catch (SQLException ex) {
                    Logger.getLogger(Faults.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
                break;


        }
        out.print(resp);
        out.flush();
        out.close();
    }

}
