/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.vegayan.pack;

import com.google.gson.Gson;
import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelExec;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;
import com.jcraft.jsch.SftpException;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Abhishek
 */
public class ConfigSSHConnection {

    private JSch jschSSHChannel;
    private String strUserName;
    private String strConnectionIP;
    private int intConnectionPort;
    private String strPassword;
    private Session sesConnection;
    private int intTimeOut;
    private ChannelSftp channel_sftp = null;

    public ConfigSSHConnection() {
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

    public ConfigSSHConnection(String userName, String password, String connectionIP, int port) {
        doCommonConstructorActions(userName, password,
                connectionIP);
        intConnectionPort = port;
        intTimeOut = 60000;
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

    private String logError(String errorMessage) {
        if (errorMessage != null) {

        }

        return errorMessage;
    }

    private String logWarning(String warnMessage) {
        if (warnMessage != null) {

        }

        return warnMessage;
    }

    public String sendCommand(String command) {
        StringBuilder outputBuffer = new StringBuilder();
        System.out.println("Command to execute: ");
        System.out.println(command);
        try {
            Channel channel = sesConnection.openChannel("exec");
            ((ChannelExec) channel).setCommand(command);
            InputStream commandOutput = channel.getInputStream();
            channel.connect();
            int readByte = commandOutput.read();

            while (readByte != 0xffffffff) {
                outputBuffer.append((char) readByte);
                readByte = commandOutput.read();
            }

            channel.disconnect();
        } catch (IOException ioX) {
            logWarning(ioX.getMessage());
            return null;
        } catch (JSchException jschX) {
            logWarning(jschX.getMessage());
            return null;
        }

        return outputBuffer.toString();
    }

    public Boolean findFilesExistence(String filepath) {
        Boolean result = false;
        try {
            Channel channel = sesConnection.openChannel("sftp");
            channel.connect();
            channel_sftp = (ChannelSftp) channel;

            String currentDirectory = channel_sftp.pwd();
            System.err.println("CurrentDirectory : *** : " + currentDirectory);
            String dir = filepath;
            System.err.println("Directory is : " + dir);
            channel_sftp.cd(dir);
            currentDirectory = channel_sftp.pwd();
            System.err.println("Current Directory 112:::: " + currentDirectory);
            Vector files = channel_sftp.ls("sptextcommand.txt.1");
            System.err.printf("Found %d files in dir %s%n", files.size(), dir);
            String filedata = "";
            for (Object file : files) {
                System.err.println(" File Name : " + file.toString());
                filedata = file.toString();
                if (filedata.contains("sptextcommand.txt.1")) {
                    result = true;
                    break;
                } else {
                    result = false;
                }
            }
            channel.disconnect();

        } catch (JSchException jschX) {
            System.err.println("Error msg : " + jschX.getMessage());
        } catch (SftpException ex) {
            Logger.getLogger(ConfigSSHConnection.class.getName()).log(Level.SEVERE, null, ex);
        }
        return result;
    }

    public String sendCopyCommand(String fsrc, String fdest) throws SftpException {
        StringBuilder outputBuffer = new StringBuilder();

        try {
            Channel channel = sesConnection.openChannel("sftp");
            channel.connect();
            channel_sftp = (ChannelSftp) channel;
            System.out.println("Starting File Upload:");
            channel_sftp.put(fsrc, fdest);
            channel.disconnect();
        } catch (JSchException jschX) {
            logWarning(jschX.getMessage());
            return null;
        }

        return outputBuffer.toString();
    }

    public String Dos2UnixCommand(String location, String fileName) throws SftpException, IOException {
        StringBuilder outputBuffer = new StringBuilder();

        try {
            String command = "cd " + location + " && dos2Unix " + fileName + "";
            System.out.println("Command : " + command);
            Channel channel = sesConnection.openChannel("exec");
            ((ChannelExec) channel).setCommand(command);
            InputStream commandOutput = channel.getInputStream();
            channel.connect();
            int readByte = commandOutput.read();

            while (readByte != 0xffffffff) {
                outputBuffer.append((char) readByte);
                readByte = commandOutput.read();
            }

            channel.disconnect();
        } catch (JSchException jschX) {
            logWarning(jschX.getMessage());
            return null;
        }

        return outputBuffer.toString();
    }

    public void close() {
        sesConnection.disconnect();
    }

    public String fileReadFormRemoteServer(String token, String VenName) throws JSchException, SftpException, IOException {

        System.out.println("Read fileReadFormRemoteServer start");
        Session sess = null;
        String errorMessage = "";
        try {
            System.out.println("USername ::" + strUserName + "  Password   " + strPassword + "  IP add  " + strConnectionIP + " ConnectionPort  " + intConnectionPort);
            sess = jschSSHChannel.getSession(strUserName,
                    strConnectionIP, intConnectionPort);
            sess.setPassword(strPassword);
            sess.setConfig("StrictHostKeyChecking", "no");
            sess.connect(intTimeOut);
        } catch (JSchException jschX) {
            errorMessage = jschX.getMessage();
            System.out.println("errorMessage : " + errorMessage);
        }
        System.out.println("SSHConnction function Token id : " + token);
        ChannelSftp sftp = (ChannelSftp) sess.openChannel("sftp");
        sftp.connect();
        String fileName = "/home/vegayan/scripts/execute/exec" + VenName + "_All" + token + ".txt";
        System.out.println("File output : " + fileName);
        InputStream stream = sftp.get(fileName);
        System.out.println("Step getInputStream done");
        StringBuilder stringBuffer = new StringBuilder();
        System.out.println("Step 2");
        String line = "";
        try {
            BufferedReader br = new BufferedReader(new InputStreamReader(stream));
            System.out.println("Step 3");
            while ((line = br.readLine()) != null) {
                stringBuffer.append(line);
                stringBuffer.append("\n");
                System.out.println("line read : " + line);
            }

        } catch (IOException io) {
            System.out.println("Exception occurred during reading file from SFTP server due to " + io.getMessage());
            io.getMessage();

        } catch (Exception e) {
            System.out.println("Exception occurred during reading file from SFTP server due to " + e.getMessage());
            e.getMessage();

        } finally {
            sftp.exit();
            sess.disconnect();
        }

        String resp = stringBuffer.toString(); //gs.toJson(arr);
        System.out.println("*****************Actual data********");
        System.out.println(resp);
        System.out.println("*****************Actual data********");
        return resp;
    }
}
