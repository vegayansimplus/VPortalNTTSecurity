/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.admin.connectivity;

import com.google.gson.Gson;
import com.vegayan.pack.Config;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author lapto
 */
public class AdminConnectivity {

    private Connection con = null;
    private String driver = "com.mysql.jdbc.Driver";
    public static Config cg = new Config();

    private String Url = "jdbc:mysql://" + cg.getDBSOURCE_IP() + "/" + cg.getDBSOURCE_DBNAME() + "?noAccessToProcedureBodies=true&autoReconnect=true";
    private String User = cg.getDBSOURCE_USER();
    private String pass = cg.getDBSOURCE_PASS();

    public String saveSNMPData(String data) throws SQLException {
        String status = "success";
//        System.out.println("Data received === " + data);
        String dataSNMP[] = data.split(":");
        try {

            con = DriverManager.getConnection(Url, User, pass);
            String query = "";
            String query1 = "truncate DISCOVERY_PREREQUISITE_WEB;";
            Statement stmt = con.createStatement();
            stmt.execute(query1);
            PreparedStatement ps = null;
//            System.out.println("rows Length:" + dataSNMP.length);
            for (int i = 1; i < dataSNMP.length; i++) {
//                System.out.println("in loop=================>");
                dataSNMP[i] = dataSNMP[i].trim();
                String cells[] = dataSNMP[i].split(",");
//                System.out.println("cell0 " + cells[0] + " cell1 " + cells[1] + " cell2 " + cells[2]);
                query = "INSERT into DISCOVERY_PREREQUISITE_WEB (node_ip,snmp_version,username,groupname,vendorname,subgroupname,SHAv,AESv)values (?,?,?,?,?,?,?,?);";
                ps = con.prepareStatement(query);
                String firstelement = cells[0].replace("\"", "");
                ps.setString(1, firstelement);
                String secondelement = cells[1].replace("\"", "");
                ps.setString(2, secondelement);
                String thirdelement = cells[2].replace("\"", "");
                ps.setString(3, thirdelement);
                String fourelement = cells[3].replace("\"", "");
                ps.setString(4, fourelement);
                String fifthelement = cells[4].replace("\"", "");
                ps.setString(5, fifthelement);
                String sixelement = cells[5].replace("\"", "");
                ps.setString(6, sixelement);
                String sevenelement = cells[6].replace("\"", "");
                ps.setString(7, sevenelement);
                String eightelement = cells[7].replace("\"", "");
                ps.setString(8, eightelement);

                System.out.println("Statement : " + ps);
                ps.executeUpdate();
            }
            status = "success";
            con.close();

            ps.close();
            //System.out.println("Query Executed");

        } catch (SQLException ex) {
            status = "fail";
            Logger.getLogger(AdminConnectivity.class.getName()).log(Level.SEVERE, null, ex);
//            System.out.println("Error " + ex.getMessage());
        } finally {
            if (con != null) {
                try {
                    con.close();
                } catch (SQLException p) {
//                    System.out.print(p);
                }
            }
        }
        return status;
    }

    public String getSNMPIPCheckDetails() {
        ArrayList result = new ArrayList();
        String resp = "";
        try {
            con = DriverManager.getConnection(Url, User, pass);
            String query = "select node_ip,ping_status,snmp_status,ready_to_discover from DISCOVERY_PREREQUISITE_WEB where ready_to_discover is not NULL;";
            PreparedStatement stmt = con.prepareStatement(query);
            ResultSet rs = stmt.executeQuery();
            int i = 0;
            while (rs.next()) {
                String data[] = {rs.getString(1), rs.getString(2), rs.getString(3), rs.getString(4)};
                result.add(data);
                i++;
            }
            con.close();
            stmt.close();
            rs.close();
            Gson gs = new Gson();
            resp = gs.toJson(result);

        } catch (SQLException ex) {
            Logger.getLogger(AdminConnectivity.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (con != null) {
                try {
                    con.close();
                } catch (SQLException p) {
//                    System.out.print(p);
                }
            }
        }
        return resp;
    }

    public String getProvisionedDevicesList() {
        Gson gson = new Gson();
        List<String[]> deviceList = new ArrayList<>();
        String query = "call provisioned_device_list()";

        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException ex) {

            return gson.toJson(deviceList);
        }

        try ( Connection con = DriverManager.getConnection(Url, User, pass);  CallableStatement st = con.prepareCall(query)) {

            System.out.println("Executing query: " + st);

            try ( ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    deviceList.add(new String[]{rs.getString(1), rs.getString(2), rs.getString(3)});
                }
            }
        } catch (SQLException e) {

        }

        return gson.toJson(deviceList);
    }

    public String getDeProvisionedDevicesList() {
        Gson gson = new Gson();
        List<String[]> deviceList = new ArrayList<>();
        String query = "call deprovisioned_device_list()";

        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException ex) {

            return gson.toJson(deviceList);
        }

        try ( Connection con = DriverManager.getConnection(Url, User, pass);  CallableStatement st = con.prepareCall(query)) {

            System.out.println("Executing query: " + st);

            try ( ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    deviceList.add(new String[]{rs.getString(1), rs.getString(2), rs.getString(3), rs.getString(4)});
                }
            }
        } catch (SQLException e) {

        }

        return gson.toJson(deviceList);
    }
    public String deleteDevice(String nodeip) {
        String status = "success";
        try {
           Connection con = DriverManager.getConnection(Url, User, pass); 
            PreparedStatement st = con.prepareStatement("call dash_deprovision_node(?);");
            st.setString(1, nodeip);
            System.out.println("query:"+st);
            st.executeUpdate();
            status = "success";
            con.close();
            st.close();
//            rs.close();

        } catch (SQLException e) {
            status = "fail";
            e.printStackTrace();
        } finally {
            if (con != null) {
                try {
                    con.close();
                } catch (SQLException p) {
//                    System.out.print(p);
                }
            }
        }
        return status;

    }


    public String getGroupNameFilter() {
        List<String> nodeTypes = new ArrayList<>();
        String query = "SELECT DISTINCT Nodetype FROM NODE_TBL";

        try {
            Class.forName("com.mysql.jdbc.Driver");
            try ( Connection con = DriverManager.getConnection(Url, User, pass);  PreparedStatement ps = con.prepareStatement(query);  ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    nodeTypes.add(rs.getString(1));
                }

            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new Gson().toJson(nodeTypes);
    }

    public String getUsernameFilter() {
        List<String> usernames = new ArrayList<>();
        String query = "CALL dash_username()";

        try {
            Class.forName("com.mysql.jdbc.Driver");
            try ( Connection con = DriverManager.getConnection(Url, User, pass);  PreparedStatement ps = con.prepareStatement(query);  ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    usernames.add(rs.getString(1));
                }

            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new Gson().toJson(usernames);
    }

    public String getAuthProtoFilter() {
        List<String> authProtos = new ArrayList<>();
        String query = "CALL dash_authproto()";

        try {
            Class.forName("com.mysql.jdbc.Driver");
            try ( Connection con = DriverManager.getConnection(Url, User, pass);  PreparedStatement ps = con.prepareStatement(query);  ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    authProtos.add(rs.getString(1));
                }

            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new Gson().toJson(authProtos);
    }

    public String getEncryptFilter(String authproto) {
        List<String> encryptions = new ArrayList<>();
        String query = "CALL dash_authAes(?)";

        try {
            Class.forName("com.mysql.jdbc.Driver");
            try ( Connection con = DriverManager.getConnection(Url, User, pass);  PreparedStatement ps = con.prepareStatement(query)) {

                ps.setString(1, authproto);
                try ( ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        encryptions.add(rs.getString(1));
                    }
                }

            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new Gson().toJson(encryptions);
    }
    public String getNodeIPFilter(String groupname) {
    List<String> nodeIPs = new ArrayList<>();
    String query = "CALL node_ip(?)";

    try {
        Class.forName("com.mysql.jdbc.Driver");
        try (Connection con = DriverManager.getConnection(Url, User, pass);
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, groupname);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    nodeIPs.add(rs.getString(1));
                }
            }

        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    return new Gson().toJson(nodeIPs);
}


}
