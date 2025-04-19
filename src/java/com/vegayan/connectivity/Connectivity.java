/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.vegayan.connectivity;

import com.vegayan.pack.Config;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Connectivity {

    private static final Logger LOGGER = Logger.getLogger(Connectivity.class.getName());

    private static final Config cg = new Config();
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    private static final String URL = "jdbc:mysql://" + cg.getDBSOURCE_IP() + "/" + cg.getDBSOURCE_DBNAME() + "?noAccessToProcedureBodies=true&autoReconnect=true";
    private static final String USER = cg.getDBSOURCE_USER();
    private static final String PASS = cg.getDBSOURCE_PASS();

    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "MySQL JDBC driver not found", e);
        }
    }

    public Connectivity() {
    }

    public String[] userAuthenticate(String username, String password) {
        String[] resp = {"fail", "", ""};

        String query = "SELECT * FROM simplus_web_user WHERE username=?";
        String updateQuery = "UPDATE simplus_web_user SET status='active' WHERE username=?";

        try ( Connection con = DriverManager.getConnection(URL, USER, PASS);  PreparedStatement st = con.prepareStatement(query)) {

            st.setString(1, username);

            try ( ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    String storedPassword = rs.getString("password");
                    String userStatus = rs.getString("status");
                    String role = rs.getString("role");

                    resp[1] = role;

                    String hashedPassword = hashPassword(password);

                    if (hashedPassword.equals(storedPassword)) {
                        if ("active".equalsIgnoreCase(userStatus)) {
                            resp[0] = "AlreadyLogged";
                            return resp;
                        }

                        // Update user status to active
                        try ( PreparedStatement ps = con.prepareStatement(updateQuery)) {
                            ps.setString(1, username);
                            ps.executeUpdate();
                        }

                        resp[0] = "success";
                        return resp;
                    }
                }
            }

        } catch (SQLException | NoSuchAlgorithmException e) {
            LOGGER.log(Level.SEVERE, "Authentication error for user: " + username, e);
        }

        return resp;
    }

    private String hashPassword(String password) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hashedBytes = md.digest(password.getBytes());
        StringBuilder hexString = new StringBuilder();

        for (byte b : hashedBytes) {
            hexString.append(String.format("%02x", b));
        }

        return hexString.toString();
    }

    public void logout(String user) {
        String query = "UPDATE simplus_web_user SET status='inactive' WHERE username=?";

        try ( Connection con = DriverManager.getConnection(URL, USER, PASS);  PreparedStatement st = con.prepareStatement(query)) {

            st.setString(1, user);
            int rowsUpdated = st.executeUpdate();

            LOGGER.log(Level.INFO, "Logout status updated for user: {0}, rows affected: {1}", new Object[]{user, rowsUpdated});

            userActivity(user, "logout");

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error during logout operation for user: " + user, e);
        }
    }

    public void userActivity(String user, String activity) {
        String query = "INSERT INTO simplus_user_activity (username, timestamp, activity) VALUES (?, ?, ?)";
        String currTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date(Calendar.getInstance().getTimeInMillis()));

        try ( Connection con = DriverManager.getConnection(URL, USER, PASS);  PreparedStatement st = con.prepareStatement(query)) {

            st.setString(1, user);
            st.setString(2, currTime);
            st.setString(3, activity);
            st.executeUpdate();

            LOGGER.log(Level.INFO, "User activity recorded: {0} - {1}", new Object[]{user, activity});

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error recording user activity for user: " + user, e);
        }
    }
}
