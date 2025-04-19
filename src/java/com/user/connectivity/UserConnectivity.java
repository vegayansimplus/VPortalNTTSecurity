/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.user.connectivity;

import static com.admin.connectivity.AdminConnectivity.cg;
import com.google.gson.Gson;
import com.mysql.jdbc.StringUtils;

import com.vegayan.pack.Config;
import com.vegayan.pack.PlotGraph;
import com.vegayan.pack.Plots;
import com.vegayan.pack.Trap;
import java.sql.*;
import java.text.SimpleDateFormat;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author lapto
 */
public class UserConnectivity {

    private Connection con = null;
    private String driver = "com.mysql.jdbc.Driver";
    public static Config cg = new Config();
    private String Url = "jdbc:mysql://" + cg.getDBSOURCE_IP() + "/" + cg.getDBSOURCE_DBNAME() + "?noAccessToProcedureBodies=true&autoReconnect=true";
    private String User = cg.getDBSOURCE_USER();
    private String Pass = cg.getDBSOURCE_PASS();

    private String url_nms = "jdbc:mysql://" + cg.getDBSOURCE_IP() + "/" + cg.getDBSOURCE_DBNAME() + "?zeroDateTimeBehavior=convertToNull&noAccessToProcedureBodies=true&autoReconnect=true";
    private String user_nms = cg.getDBSOURCE_USER();
    private String pass_nms = cg.getDBSOURCE_PASS();

    public String getGroupName() {
        List<String> locations = new ArrayList<>();
        String query = "SELECT DISTINCT Nodetype FROM NODE_TBL WHERE Nodetype != ''";
        try {
            Class.forName("com.mysql.jdbc.Driver");
            try ( Connection con = DriverManager.getConnection(Url, User, Pass);  PreparedStatement st = con.prepareStatement(query);  ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    locations.add(rs.getString(1));
                }
            }
        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found: " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("Database error: " + e.getMessage());
        }

        return new Gson().toJson(locations);
    }

    public String getDeviceType(String groupname) {
        List<String> rlist = new ArrayList<>();
        String query = "call get_routertype_filter(?)";
        try {
            Class.forName("com.mysql.jdbc.Driver");
            try ( Connection con = DriverManager.getConnection(Url, User, Pass);  CallableStatement st = con.prepareCall(query)) {

                st.setString(1, groupname);
                System.out.println("dashboard count query=" + st);
                try ( ResultSet rs = st.executeQuery()) {
                    while (rs.next()) {
                        rlist.add(rs.getString(1));
                    }
                }
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, "JDBC Driver not found", ex);
        } catch (SQLException e) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, "Database error", e);
        }

        return new Gson().toJson(rlist);
    }

    public String getNodeName(String groupname, String devicetype) {
        List<String> rlist = new ArrayList<>();
        String query = "call get_Nodename_groupandtypewises(?,?)";
        try {
            Class.forName("com.mysql.jdbc.Driver");
            try ( Connection con = DriverManager.getConnection(Url, User, Pass);  CallableStatement st = con.prepareCall(query)) {

                st.setString(1, groupname);
                st.setString(2, devicetype);
                System.out.println("dashboard count query=" + st);
                try ( ResultSet rs = st.executeQuery()) {
                    while (rs.next()) {
                        rlist.add(rs.getString(1));
                    }
                }
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, "JDBC Driver not found", ex);
        } catch (SQLException e) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, "Database error", e);
        }

        return new Gson().toJson(rlist);
    }

    public String getIPWiseNodeName(String groupname, String devicetype, String nodeIP) {
        List<String> rlist = new ArrayList<>();
        String query = "call getNodeNodeName(?,?,?)";
        try {
            Class.forName("com.mysql.jdbc.Driver");
            try ( Connection con = DriverManager.getConnection(Url, User, Pass);  CallableStatement st = con.prepareCall(query)) {

                st.setString(1, groupname);
                st.setString(2, devicetype);
                st.setString(3, nodeIP);
                System.out.println("dashboard count query=" + st);
                try ( ResultSet rs = st.executeQuery()) {
                    while (rs.next()) {
                        rlist.add(rs.getString(1));
                    }
                }
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, "JDBC Driver not found", ex);
        } catch (SQLException e) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, "Database error", e);
        }

        return new Gson().toJson(rlist);
    }

    public String getNodeNameWiseNodeIP(String groupname, String devicetype, String nodeName) {
        List<String> rlist = new ArrayList<>();
        String query = "call getNodeIP(?,?,?)";
        try {
            Class.forName("com.mysql.jdbc.Driver");
            try ( Connection con = DriverManager.getConnection(Url, User, Pass);  CallableStatement st = con.prepareCall(query)) {

                st.setString(1, groupname);
                st.setString(2, devicetype);
                st.setString(3, nodeName);
                System.out.println("dashboard count query=" + st);
                try ( ResultSet rs = st.executeQuery()) {
                    while (rs.next()) {
                        rlist.add(rs.getString(1));
                    }
                }
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, "JDBC Driver not found", ex);
        } catch (SQLException e) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, "Database error", e);
        }

        return new Gson().toJson(rlist);
    }

    public String getNodeIP(String groupname, String devicetype) {
        List<String> rlist = new ArrayList<>();
        String query = "call get_NodeIP_groupandtypewises(?,?)";
        try {
            Class.forName("com.mysql.jdbc.Driver");
            try ( Connection con = DriverManager.getConnection(Url, User, Pass);  CallableStatement st = con.prepareCall(query)) {

                st.setString(1, groupname);
                st.setString(2, devicetype);
                System.out.println("dashboard count query=" + st);
                try ( ResultSet rs = st.executeQuery()) {
                    while (rs.next()) {
                        rlist.add(rs.getString(1));
                    }
                }
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, "JDBC Driver not found", ex);
        } catch (SQLException e) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, "Database error", e);
        }

        return new Gson().toJson(rlist);
    }

    public String getNodeInventory(String nodeip) {
        List<String[]> rlist = new ArrayList<>();
        String query = "call GET_INVENTORY_NTT(?)";

        try {
            Class.forName("com.mysql.jdbc.Driver");
            try ( Connection con = DriverManager.getConnection(Url, User, Pass);  CallableStatement st = con.prepareCall(query)) {

                st.setString(1, nodeip);
                System.out.println("query: " + st);
                try ( ResultSet rs = st.executeQuery()) {
                    while (rs.next()) {
                        rlist.add(new String[]{
                            rs.getString(1), rs.getString(2), rs.getString(3),
                            rs.getString(4), rs.getString(5), rs.getString(6),
                            rs.getString(7), rs.getString(8), rs.getString(9),
                            rs.getString(10), rs.getString(11)
                        });
                    }
                }
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, "JDBC Driver not found", ex);
        } catch (SQLException e) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, "Database error", e);
        }

        return new Gson().toJson(rlist);
    }

    /**
     * **************************Port Traffic*******************************
     */
    public String getPortTraffic(String nodename, String fromtime, String totime, String TrafficScale) {
        List<String[]> rlist = new ArrayList<>();
        String query = "call GET_TRAFFIC_DETAILS(?,?,?,?)";

        try {
            Class.forName("com.mysql.jdbc.Driver");
            try ( Connection con = DriverManager.getConnection(Url, User, Pass);  CallableStatement st = con.prepareCall(query)) {
                st.setString(1, nodename);
                st.setString(2, fromtime);
                st.setString(3, totime);
                st.setString(4, TrafficScale);
                System.out.println("query: " + st);
                try ( ResultSet rs = st.executeQuery()) {
                    while (rs.next()) {
                        rlist.add(new String[]{
                            rs.getString(1), rs.getString(2), rs.getString(3),
                            rs.getString(4), rs.getString(5), rs.getString(6),
                            rs.getString(7), rs.getString(8), rs.getString(9),
                            rs.getString(10), rs.getString(11), rs.getString(12),
                            rs.getString(13), rs.getString(14), rs.getString(15),
                            rs.getString(16), rs.getString(17), rs.getString(18),
                            rs.getString(19)
                        });
                    }
                }
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, "JDBC Driver not found", ex);
        } catch (SQLException e) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, "Database error", e);
        }

        return new Gson().toJson(rlist);
    }

    public String getCPUTraffic(String nodename) {
        List<String[]> rlist = new ArrayList<>();
        String query = "call get_CpuUtil_report(?)";

        try {
            Class.forName("com.mysql.jdbc.Driver");
            try ( Connection con = DriverManager.getConnection(Url, User, Pass);  CallableStatement st = con.prepareCall(query)) {
                st.setString(1, nodename);

                System.out.println("query: " + st);
                try ( ResultSet rs = st.executeQuery()) {
                    while (rs.next()) {
                        rlist.add(new String[]{
                            rs.getString(1), rs.getString(2), rs.getString(3),
                            rs.getString(4), rs.getString(5), rs.getString(6)
                        });
                    }
                }
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, "JDBC Driver not found", ex);
        } catch (SQLException e) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, "Database error", e);
        }

        return new Gson().toJson(rlist);
    }

    public String getTempTraffic(String nodename) {
        List<String[]> rlist = new ArrayList<>();
        String query = "call get_TempUtil_report(?)";

        try {
            Class.forName("com.mysql.jdbc.Driver");
            try ( Connection con = DriverManager.getConnection(Url, User, Pass);  CallableStatement st = con.prepareCall(query)) {
                st.setString(1, nodename);

                System.out.println("query: " + st);
                try ( ResultSet rs = st.executeQuery()) {
                    while (rs.next()) {
                        rlist.add(new String[]{
                            rs.getString(1), rs.getString(2), rs.getString(3),
                            rs.getString(4), rs.getString(5), rs.getString(6)
                        });
                    }
                }
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, "JDBC Driver not found", ex);
        } catch (SQLException e) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, "Database error", e);
        }

        return new Gson().toJson(rlist);
    }

    public String getStorageTraffic(String nodename, String fromTime, String toTime) {
        List<String[]> rlist = new ArrayList<>();
        String query = "call get_StorageUtil_report(?,?,?)";

        try {
            Class.forName("com.mysql.jdbc.Driver");
            try ( Connection con = DriverManager.getConnection(Url, User, Pass);  CallableStatement st = con.prepareCall(query)) {
                st.setString(1, nodename);
                st.setString(2, fromTime);
                st.setString(3, toTime);
                System.out.println("query: " + st);
                try ( ResultSet rs = st.executeQuery()) {
                    while (rs.next()) {
                        rlist.add(new String[]{
                            rs.getString(1), rs.getString(2), rs.getString(3),
                            rs.getString(4), rs.getString(5), rs.getString(6),
                            rs.getString(7)
                        });
                    }
                }
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, "JDBC Driver not found", ex);
        } catch (SQLException e) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, "Database error", e);
        }

        return new Gson().toJson(rlist);
    }

    public String getOSPFReport(String nodeIP) {
        List<String[]> rlist = new ArrayList<>();
        String query = "call get_OSPF_Neighbor_report(?)";

        try {
            Class.forName("com.mysql.jdbc.Driver");
            try ( Connection con = DriverManager.getConnection(Url, User, Pass);  CallableStatement st = con.prepareCall(query)) {
                st.setString(1, nodeIP);
                System.out.println("query: " + st);
                try ( ResultSet rs = st.executeQuery()) {
                    while (rs.next()) {
                        rlist.add(new String[]{
                            rs.getString(1), rs.getString(2), rs.getString(3),
                            rs.getString(4)
                        });
                    }
                }
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, "JDBC Driver not found", ex);
        } catch (SQLException e) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, "Database error", e);
        }

        return new Gson().toJson(rlist);
    }

    public String getTrafficPlot(String nodeName, String interfaceName, String fromTime, String toTime, String scale, String interfaceType) throws SQLException {
        List<PlotGraph> plotList = new ArrayList<>();
        Gson gson = new Gson();

        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, null, ex);
            return gson.toJson(plotList);
        }

        String query = "call GET_TRAFFIC_PLOT_BFL(?,?,?,?,5,?);";
        try ( Connection con = DriverManager.getConnection(Url, User, Pass);  CallableStatement cs = con.prepareCall(query)) {

            cs.setString(1, nodeName);
            cs.setString(2, interfaceName);
            cs.setString(3, fromTime);
            cs.setString(4, toTime);
            cs.setString(5, scale);

            try ( ResultSet rs = cs.executeQuery()) {
                while (rs.next()) {
                    plotList.add(new PlotGraph(rs.getString(1), rs.getString(2), rs.getString(3)));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return gson.toJson(plotList);
    }

    public String getAnalyticPlot(String nodeName, String interfaceName, String fromTime, String toTime, String scale, String interfaceType, String dateflag) throws SQLException {
        List<PlotGraph> plotList = new ArrayList<>();
        Gson gson = new Gson();

        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, null, ex);
            return gson.toJson(plotList);
        }

        String query;
        switch (dateflag) {
            case "curr":

                query = "call GET_TRAFFIC_PLOT_BFL(?,?,?,?,5,?)";
                break;
            case "Weekly":

                query = "call Get_Graphical_Analytic_Plot_Weekly(?,?,?,?,5,?)";
                break;
            case "Monthly":

                query = "call Get_Graphical_Analytic_Plot_Monthly(?,?,?,?,5,?)";
                break;
            case "Userdefined":
                query = "call Get_Graphical_Analytic_Plot_UserDefined(?,?,?,?,5,?)";
                break;

            case "user defined 3 days":
            default:

                query = "call Get_Graphical_Analytic_Plot_UserDefined(?,?,?,?,5,?)";
                break;
        }

        try ( Connection con = DriverManager.getConnection(Url, User, Pass);  CallableStatement cs = con.prepareCall(query)) {
            cs.setString(1, nodeName);
            cs.setString(2, interfaceName);
            cs.setString(3, fromTime);
            cs.setString(4, toTime);
            cs.setString(5, scale);
            System.out.println("query:" + cs);
            try ( ResultSet rs = cs.executeQuery()) {
                while (rs.next()) {
                    plotList.add(new PlotGraph(rs.getString(1), rs.getString(2), rs.getString(3)));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return gson.toJson(plotList);
    }

    public String getCPUTempReportGraph(String nodeName, String cpuName, String fromTime, String toTime, String kpiflag) {
        List<Plots> plotList = new ArrayList<>();
        Gson gson = new Gson();
        String query = "";
        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, null, ex);
            return gson.toJson(plotList);
        }
        if (kpiflag.equals("CPU")) {
            query = "{call node_cpuUtil_graph(?,?,?,?)}";
        } else {
            query = "{call node_TempUtil_graph(?,?,?,?)}";
        }

        try ( Connection con = DriverManager.getConnection(Url, User, Pass);  CallableStatement cs = con.prepareCall(query)) {

            cs.setString(1, nodeName);
            cs.setString(2, cpuName);
            cs.setString(3, fromTime);
            cs.setString(4, toTime);

            System.out.println("Executed query MPLS=" + cs);

            try ( ResultSet rs = cs.executeQuery()) {
                while (rs.next()) {
                    plotList.add(new Plots(rs.getString(1), rs.getString(2)));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return gson.toJson(plotList);
    }

    public String getSummaryDashboardCount() {
        List<String[]> rlist = new ArrayList<>();
        String query = "call getdashcount_change()";

        try {
            Class.forName("com.mysql.jdbc.Driver");
            try ( Connection con = DriverManager.getConnection(Url, User, Pass);  CallableStatement st = con.prepareCall(query)) {

                System.out.println("query: " + st);
                try ( ResultSet rs = st.executeQuery()) {
                    while (rs.next()) {
                        rlist.add(new String[]{
                            rs.getString(1), rs.getString(2)

                        });
                    }
                }
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, "JDBC Driver not found", ex);
        } catch (SQLException e) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, "Database error", e);
        }

        return new Gson().toJson(rlist);
    }

    public String getSummaryDashboardCountList(String flag) {
        List<String[]> rlist = new ArrayList<>();
        String query = "call get_pan_dash_cnt_list(?)";

        try {
            Class.forName("com.mysql.jdbc.Driver");
            try ( Connection con = DriverManager.getConnection(Url, User, Pass);  CallableStatement st = con.prepareCall(query)) {
                st.setString(1, flag);
                System.out.println("query: " + st);
                try ( ResultSet rs = st.executeQuery()) {
                    while (rs.next()) {
                        rlist.add(new String[]{
                            rs.getString(1), rs.getString(2),
                            rs.getString(3),
                            rs.getString(4),
                            rs.getString(5)

                        });
                    }
                }
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, "JDBC Driver not found", ex);
        } catch (SQLException e) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, "Database error", e);
        }

        return new Gson().toJson(rlist);
    }

    public String getActiveTraps() throws SQLException, ClassNotFoundException {
        List<Trap> trapList = new ArrayList<>();
        String myjson = "";
        Class.forName("com.mysql.jdbc.Driver");

        String query = "CALL getTrapDetails_Live_router()";

        try ( Connection con = DriverManager.getConnection(Url, User, Pass);  CallableStatement st = con.prepareCall(query);  ResultSet rs = st.executeQuery()) {
            System.out.println("query:" + st);
            while (rs.next()) {
                Trap trap = new Trap();
                trap.setTrapID(rs.getString(1));
                trap.setTrapType(rs.getString(2));
                trap.setSenderIP(rs.getString(3));
                trap.setNodeName(rs.getString(4));
                trap.setDestNodeName(rs.getString(5));
                trap.setNodeType(rs.getString(6));
                trap.setStatus(rs.getString(7));

                trap.setGenerated_Time(formatTimestamp(rs.getString(8)));
                trap.setRcvd_Time1(formatTimestamp(rs.getString(9)));
                trap.setAck_Time_1(rs.getString(10));
                trap.setAck_message(getOrDefault(rs.getString(11), "NA"));
                trap.setAckUserName(getOrDefault(rs.getString(12), "NA"));
                trap.setClear_Time_1(rs.getString(13));
                trap.setClear_message(getOrDefault(rs.getString(14), "NA"));
                trap.setClearUserName(getOrDefault(rs.getString(15), "NA"));

                trap.setIfIndex(rs.getString(16));
                trap.setIfDescription(rs.getString(17));
                trap.setIfDescription2(rs.getString(18));
                trap.setPeerIp(rs.getString(19));
                trap.setParameter1(rs.getString(20));
                trap.setParameter2(rs.getString(21));
                trap.setParameter3(rs.getString(22));
                trap.setParameter4(rs.getString(23));
                trap.setParameter5(rs.getString(24));
                trap.setAlarmValue(rs.getString(25));
                trap.setMiscTrapDesc(rs.getString(26));
                trap.setRelatedTrapId(rs.getString(27));
                trap.setTrapSeverity(rs.getString(28));
                trap.setTrapSource(rs.getString(29));
                trap.setTicketNo(rs.getString(30));

                trapList.add(trap);
            }
            Gson gs = new Gson();
            myjson = gs.toJson(trapList);
        } catch (SQLException e) {

        }

        return myjson;
    }

    public String getHistoricTraps2(String NodeName, String TrapType, String startTime, String endTime, String trapDetail, String status) throws SQLException {
        String myjson = "";
        ArrayList<Trap> trapList = new ArrayList<>();
        Connection con = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        try {
            con = DriverManager.getConnection(url_nms, user_nms, pass_nms);
            st = con.prepareStatement("call getTrapDetails_Live_router_hist(?,?,?,?)");
            st.setString(1, NodeName);
            st.setString(2, TrapType);
            st.setString(3, startTime);
            st.setString(4, endTime);
            System.out.println("Executing query: " + st);

            rs = st.executeQuery();

            int count = 0;
            while (rs.next()) {
                count++;
                Trap trap1 = new Trap();

                trap1.setTrapID(rs.getString(1));
                trap1.setTrapType(rs.getString(2));
                trap1.setSenderIP(rs.getString(3));
                trap1.setNodeName(rs.getString(4));
                trap1.setDestNodeName(rs.getString(5));
                trap1.setNodeType(rs.getString(6));
                trap1.setStatus(rs.getString(7));
                String genTime = rs.getString(8);
                genTime = genTime.indexOf(".") < 0 ? genTime : genTime.replaceAll("0*$", "").replaceAll("\\.$", "");
                trap1.setGenerated_Time(genTime);
                String timeVal = rs.getString(9);
                timeVal = timeVal.indexOf(".") < 0 ? timeVal : timeVal.replaceAll("0*$", "").replaceAll("\\.$", "");
                trap1.setRcvd_Time1(timeVal);

                String ss = rs.getString(10);

                if (ss == null) {
                    ss = "";
                } else if (ss.startsWith("00")) {
                    ss = "";
                }
                trap1.setAck_Time_1(ss);
                if (rs.getString(11) == null) {
                    trap1.setAck_message("NA");
                } else {
                    trap1.setAck_message(rs.getString(11));
                }
                if (rs.getString(12) == null) {
                    trap1.setAckUserName("NA");
                } else {
                    trap1.setAckUserName(rs.getString(12));
                }
                String cc = "";
                if (rs.getString(13) == null) {
                    cc = "NA";
                } else {
                    cc = rs.getString(13);
                    if (cc.contains("NA")) {
                        cc = "";
                    } else if (cc.startsWith("00")) {
                        cc = "";
                    }
                }

                trap1.setClear_Time_1(cc);
                if (rs.getString(14) == null) {
                    trap1.setClear_message("NA");
                } else {
                    trap1.setClear_message(rs.getString(14));
                }
                if (rs.getString(15) == null) {
                    trap1.setClearUserName("NA");
                } else {
                    trap1.setClearUserName(rs.getString(15));
                }
                trap1.setIfIndex(rs.getString(16));
                trap1.setIfDescription(rs.getString(17));
                trap1.setIfDescription2(rs.getString(18));
                trap1.setPeerIp(rs.getString(19));
                trap1.setParameter1(rs.getString(20));
                trap1.setParameter2(rs.getString(21));
                trap1.setParameter3(rs.getString(22));
                trap1.setParameter4(rs.getString(23));
                trap1.setParameter5(rs.getString(24));
                trap1.setAlarmValue(rs.getString(25));
                trap1.setMiscTrapDesc(rs.getString(26));
                trap1.setRelatedTrapId(rs.getString(27));
                trap1.setTrapSeverity(rs.getString(28));
                trap1.setTrapSource(rs.getString(29));
                trap1.setTicketNo(rs.getString(30));
                trap1.setCounter(rs.getString(31));

                trapList.add(trap1);
            }

            Gson gs = new Gson();
            myjson = gs.toJson(trapList);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            if (st != null) try {
                st.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            if (con != null) try {
                con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return myjson;
    }

    private String safeTimestamp(String timeStr) {
        if (timeStr == null || timeStr.startsWith("0000-00-00") || timeStr.equals("null") || timeStr.trim().isEmpty()) {
            return "";
        }
        // Remove milliseconds if present
        return timeStr.indexOf(".") < 0 ? timeStr : timeStr.replaceAll("0*$", "").replaceAll("\\.$", "");
    }

    private String formatTimestamp(String timestamp) {
        return (timestamp == null) ? "NA" : timestamp.replaceAll("0*$", "").replaceAll("\\.$", "");
    }

    /**
     * Returns the value if it's not null; otherwise, returns the default value.
     */
    private String getOrDefault(String value, String defaultValue) {
        return (value == null) ? defaultValue : value;
    }

    private Connection getConnection() {
        try {
            // Updated to the latest MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(Url, User, Pass);
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, "Database connection error", ex);
        }
        return null;
    }

    private <T> List<T> executeQuery(String query, ResultSetProcessor<T> processor, String... params) {
        List<T> result = new ArrayList<>();
        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(query)) {
            // Set parameters if any
            for (int i = 0; i < params.length; i++) {
                ps.setString(i + 1, params[i]);
            }

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(processor.process(rs));
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(UserConnectivity.class.getName()).log(Level.SEVERE, "Database query error", e);
        }
        return result;
    }

    // Processor for fetching node health
    private interface ResultSetProcessor<T> {

        T process(ResultSet rs) throws SQLException;
    }

    // Fetch Node Dashboard Health
    public String getNodeDashboardHealth(String nodeIp) {
        String query = "call get_Node_health(?)";
        List<String> result = executeQuery(query, rs -> rs.getString(1), nodeIp);
        return new Gson().toJson(result);
    }

    // Fetch Node Dashboard Interface Table
    public String getNodeDashboardInterfaceTable(String nodeIp) {
        String query = "call get_Node_Interface_Traffic(?)";
        List<String[]> result = executeQuery(query, rs -> new String[]{
            rs.getString(1), rs.getString(2), rs.getString(3), rs.getString(4)
        }, nodeIp);
        return new Gson().toJson(result);
    }

    // Fetch Node Dashboard Plot
    public String getNodeDashboardPlot(String nodeName, String interfaceName) {
        String query = "call get_Node_Inteface_Plot(?,?)";
        List<PlotGraph> result = executeQuery(query, rs -> new PlotGraph(rs.getString(1), rs.getString(2), rs.getString(3)),
                nodeName, interfaceName);
        return new Gson().toJson(result);
    }

    // Fetch Bottom Dashboard Health
    public String getBottomDashboardHealth(String nodeIp) {
        String query = "call get_Node_Inventory_Details(?)";
        List<String[]> result = executeQuery(query, rs -> new String[]{
            rs.getString(1), rs.getString(2), rs.getString(3),
            rs.getString(4), rs.getString(5), rs.getString(6)
        }, nodeIp);
        return new Gson().toJson(result);
    }

}
