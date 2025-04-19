/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.vegayan.controllers;

import com.vegayan.connectivity.Connectivity;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.File;
import java.io.FileWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Calendar;

/**
 *
 * @author lapto
 */
public class Logout extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connectivity con = new Connectivity();
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy_MM_dd");
        LocalDateTime now = LocalDateTime.now();
//        String fileName = "C:\\vegayan\\simplus\\logs\\user_activity_log_" + dtf.format(now) + ".txt";
//        String fileName = "C:\\vegayan\\simplus\\LogFiles\\logged.txt";
//        File logFile = new File(fileName);

        //HttpSession session=request.getSession(true);
        response.setContentType("text/html");
        String user = request.getParameter("user");
        HttpSession session = SessionBinding.findSession(user);
        if (session != null) {
            session.invalidate();
        }
//logout logs
        DateFormat dateFormat1 = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        Calendar cal = Calendar.getInstance();
        String sess_id = session.getId();
        String ipAddress = request.getRemoteAddr();

//        FileWriter fr1 = new FileWriter(logFile, true);
//        fr1.write("TIME :" + dateFormat1.format(cal.getTime()) + "| Portal : VPortal | SESS_ID :" + sess_id + " | " + "USER :" + user + " | " + "IP :" + ipAddress + " | " + "MSG : SUCESSFUL Logout" + "VPortal" + "\n");
//        fr1.write("Time : " + dateFormat1.format(cal.getTime()) + " | Portal : VPortal | SESS_ID :" + sess_id + " | " + "USER : " + user + " | " + "IP : " + ipAddress + " | " + " Message : Successfully logged out \n");
//        fr1.close();

//        con.logout(user);
        response.sendRedirect("/BFL/login.jsp");

    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connectivity con = new Connectivity();
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy_MM_dd");
        LocalDateTime now = LocalDateTime.now();
        String fileName = "C:\\vegayan\\simplus\\logs\\user_activity_log_" + dtf.format(now) + ".txt";
        File logFile = new File(fileName);

        //HttpSession session=request.getSession(true);
        response.setContentType("text/html");
        String user = request.getParameter("user");
        HttpSession session = SessionBinding.findSession(user);
        if (session != null) {
            session.invalidate();
        }
//logout logs
        DateFormat dateFormat1 = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        Calendar cal = Calendar.getInstance();
        String sess_id = session.getId();
        String ipAddress = request.getRemoteAddr();

        FileWriter fr1 = new FileWriter(logFile, true);
        fr1.write("Session id:" + sess_id + " USER:" + user + " IP:" + ipAddress + " MSG:successful logout" + " TIME:" + dateFormat1.format(cal.getTime()));
        fr1.close();

//        con.logout(user);
        response.sendRedirect("/BFL/login.jsp");

    }
}
