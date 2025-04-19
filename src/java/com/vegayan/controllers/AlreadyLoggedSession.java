/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
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

/**
 *
 * @author Abhishek
 */
public class AlreadyLoggedSession extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Connectivity con = new Connectivity();
        try {
            String usr = request.getParameter("username");
            String pwd = request.getParameter("password");
            HttpSession session = (HttpSession) SessionBinding.findSession(usr);
            if (session != null) {
                session.invalidate();
            } else {
                con.logout(usr);
            }
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet alreadyLoggedSession</title>");
            out.println("</head>");
            out.println("<body><center><div style=' border: 2px solid #a1a1a1;'><h3>" + usr + " 's session is already activated. Do you want to Continue same session ?</h3>");
            out.println("<table><tr><td>");
            out.println("<form method='POST' action='Login'><input type=\"text\" name=\"username\" value=" + usr + " hidden='true'><input type=\"password\" name=\"password\" value=" + pwd + " hidden='true'><input type = 'submit' value = \"Continue\"/></form>"
                    + "</td><td><form method='POST' action='/VPortalNTT/login.jsp'><input type = 'submit' value = \"Cancel\"/></form>");
            out.println("</td></tr></table></div></center></body>");
            out.println("</html>");
        } finally {
            out.close();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
