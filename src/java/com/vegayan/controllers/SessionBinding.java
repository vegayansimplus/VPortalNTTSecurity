/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.vegayan.controllers;

import com.vegayan.connectivity.Connectivity;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpSessionBindingEvent;
import jakarta.servlet.http.HttpSessionBindingListener;
import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author lapto
 */
public class SessionBinding implements Serializable, HttpSessionBindingListener {

    Connectivity con;
//    UserConnectivity usercon;

    private static final Map<String, HttpSession> sessions = new HashMap<String, HttpSession>();

    SessionBinding() {
        con = new Connectivity();
//        usercon = new UserConnectivity();
    }

    @Override
    public void valueBound(HttpSessionBindingEvent event) {
        HttpSession session = event.getSession();
        sessions.put(event.getName(), session);
    }

    @Override
    public void valueUnbound(HttpSessionBindingEvent event) {
        con.logout(event.getName());
        sessions.remove(event.getName());
    }

    public static HttpSession findSession(String user) {
        //System.out.println("user....."+user);
        //System.out.println("session"+sessions.get(user));
        return sessions.get(user);
    }
}
