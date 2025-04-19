/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.vegayan.pack;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelExec;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintStream;
import java.util.Properties;

/**
 *
 * @author lapto
 */
public class SSHConnection {
     Config cg = new Config();
    private Session session;
    public String username = "";
    public String password = "";
    public String hostname = "";
    private JSch jschSSHChannel;
    private String strUserName;
    private String strConnectionIP;
    private int intConnectionPort;
    private String strPassword;
    private Session sesConnection;
    private int intTimeOut;

    public SSHConnection() {
    }

    private void doCommonConstructorActions(String userName,
            String password, String connectionIP) {
        jschSSHChannel = new JSch();

//        try {
//            jschSSHChannel.setKnownHosts(knownHostsFileName);
//        } catch (JSchException jschX) {
//            logError(jschX.getMessage());
//        }
        strUserName = userName;
        strPassword = password;
        strConnectionIP = connectionIP;
        System.out.println("USername ::" + strUserName + "  Password   " + strPassword + "  IP add  " + strConnectionIP);
    }

    public SSHConnection(String userName, String password,
            String connectionIP, int port) {
        doCommonConstructorActions(userName, password,
                connectionIP);
        intConnectionPort = port;
        intTimeOut = 60000;
    }

    public void open()
            throws JSchException {
        open(hostname, username, password);
    }

    public void open(String hostname, String username, String password) throws JSchException {
        JSch jSch = new JSch();

        session = jSch.getSession(username, hostname, 22);
        Properties config = new Properties();
        config.put("StrictHostKeyChecking", "no");
        session.setConfig(config);
        session.setPassword(password);

        System.out.println("Connecting SSH to " + hostname + " - Please wait for few seconds... ");
        session.connect();
    }

    public String connect() {
        String errorMessage = null;

        try {
            System.out.println("USername ::" + strUserName + "  Password   " + strPassword + "  IP add  " + strConnectionIP + " ConnectionPort  " + intConnectionPort);
            sesConnection = jschSSHChannel.getSession(strUserName,
                    strConnectionIP, intConnectionPort);
            sesConnection.setPassword(strPassword);
//            Properties config = new Properties();
//            config.put("StrictHostKeyChecking", "no");
            sesConnection.setConfig("StrictHostKeyChecking", "no");
            // UNCOMMENT THIS FOR TESTING PURPOSES, BUT DO NOT USE IN PRODUCTION
            // sesConnection.setConfig("StrictHostKeyChecking", "no");
            sesConnection.connect(intTimeOut);
        } catch (JSchException jschX) {
            errorMessage = jschX.getMessage();
        }

        return errorMessage;
    }

    public String runCommand(String command)
            throws JSchException, IOException {
        String ret = "";

        if (!session.isConnected()) {
            throw new RuntimeException("Not connected to an open session.  Call open() first!");
        }

        ChannelExec channel = null;
        channel = (ChannelExec) session.openChannel("exec");

        channel.setCommand(command);
        channel.setInputStream(null);

        PrintStream out = new PrintStream(channel.getOutputStream());
        InputStream in = channel.getInputStream();

        channel.connect();

        ret = getChannelOutput(channel, in);

        channel.disconnect();

        return ret;
    }

    private String getChannelOutput(Channel channel, InputStream in) throws IOException {
        byte[] buffer = new byte['Ѐ'];
        StringBuilder strBuilder = new StringBuilder();

        String line = "";
        for (;;) {
            if (in.available() > 0) {
                int i = in.read(buffer, 0, 1024);
                if (i >= 0) {

                    strBuilder.append(new String(buffer, 0, i));
                    continue;
                }
            }
            if (line.contains("logout")) {
                break;
            }

            if (channel.isClosed()) {
                break;
            }
            try {
                Thread.sleep(1000L);
            } catch (Exception localException) {
            }
        }

        return strBuilder.toString();
    }

    public void close() {
        session.disconnect();
    }

    public String initiateRequest(String command, String routerType) {
        System.out.println("Command for execution*******************");
        System.out.println(command);
        String ret = "";
        if (routerType.equals("RS")) {
//            username = "DS419@bfl.com";
//            password = "BFL@2025";
//            hostname = "10.147.67.35";
            username = cg.getSNMPUsername();
            password = cg.getSNMPPassword();
            hostname = cg.getSNMPIP();

        }
        System.out.println("Username:" + username);
        System.out.println("Password:" + password);
        System.out.println("Hostname:" + hostname);

        SSHConnection ssh = new SSHConnection();
        try {
            ssh.open(hostname, username, password);
            ret = ssh.runCommand(command);
            ssh.close();

        } catch (Exception e) {
            System.out.println("exception:" + e);
            e.printStackTrace();
        }
        System.out.println("return from script:" + ret);
        return ret;
    }
}
