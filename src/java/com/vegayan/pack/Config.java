/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.vegayan.pack;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Properties;

/**
 *
 * @author lapto
 */
public class Config {

    private String DBSOURCE_IP;
    private String DBSOURCE_USER;
    private String DBSOURCE_PASS;
    private String DBSOURCE_DBNAME;

    private String CONFIG_FILE_PATH_WIN;
    private String CONFIG_FILE_PATH;
    private String CONFIG_FILE_PATH_LIN;

    private String USER_NAME;
    private String PASSWORD;
    private String CONNECTION_IP;
    private String CONNECTION_PORT;
    private String COMMAND_DEVICE;
    
    private String SNMPUsername;
    private String SNMPPassword;
    private String SNMPIP;


    public String getDBSOURCE_IP() {
        return DBSOURCE_IP;
    }

    public void setDBSOURCE_IP(String DBSOURCE_IP) {
        this.DBSOURCE_IP = DBSOURCE_IP;
    }

    public String getDBSOURCE_USER() {
        return DBSOURCE_USER;
    }

    public void setDBSOURCE_USER(String DBSOURCE_USER) {
        this.DBSOURCE_USER = DBSOURCE_USER;
    }

    public String getDBSOURCE_PASS() {
        return DBSOURCE_PASS;
    }

    public void setDBSOURCE_PASS(String DBSOURCE_PASS) {
        this.DBSOURCE_PASS = DBSOURCE_PASS;
    }

    public String getDBSOURCE_DBNAME() {
        return DBSOURCE_DBNAME;
    }

    public void setDBSOURCE_DBNAME(String DBSOURCE_DBNAME) {
        this.DBSOURCE_DBNAME = DBSOURCE_DBNAME;
    }

    public String getCONFIG_FILE_PATH_WIN() {
        return CONFIG_FILE_PATH_WIN;
    }

    public void setCONFIG_FILE_PATH_WIN(String CONFIG_FILE_PATH_WIN) {
        this.CONFIG_FILE_PATH_WIN = CONFIG_FILE_PATH_WIN;
    }

    public String getCONFIG_FILE_PATH() {
        return CONFIG_FILE_PATH;
    }

    public void setCONFIG_FILE_PATH(String CONFIG_FILE_PATH) {
        this.CONFIG_FILE_PATH = CONFIG_FILE_PATH;
    }

    public String getCONFIG_FILE_PATH_LIN() {
        return CONFIG_FILE_PATH_LIN;
    }

    public void setCONFIG_FILE_PATH_LIN(String CONFIG_FILE_PATH_LIN) {
        this.CONFIG_FILE_PATH_LIN = CONFIG_FILE_PATH_LIN;
    }

    public String getUSER_NAME() {
        return USER_NAME;
    }

    public void setUSER_NAME(String USER_NAME) {
        this.USER_NAME = USER_NAME;
    }

    public String getPASSWORD() {
        return PASSWORD;
    }

    public void setPASSWORD(String PASSWORD) {
        this.PASSWORD = PASSWORD;
    }

    public String getCONNECTION_IP() {
        return CONNECTION_IP;
    }

    public void setCONNECTION_IP(String CONNECTION_IP) {
        this.CONNECTION_IP = CONNECTION_IP;
    }

    public String getCONNECTION_PORT() {
        return CONNECTION_PORT;
    }

    public void setCONNECTION_PORT(String CONNECTION_PORT) {
        this.CONNECTION_PORT = CONNECTION_PORT;
    }

    public String getCOMMAND_DEVICE() {
        return COMMAND_DEVICE;
    }

    public void setCOMMAND_DEVICE(String COMMAND_DEVICE) {
        this.COMMAND_DEVICE = COMMAND_DEVICE;
    }

    public String getSNMPUsername() {
        return SNMPUsername;
    }

    public void setSNMPUsername(String SNMPUsername) {
        this.SNMPUsername = SNMPUsername;
    }

    public String getSNMPPassword() {
        return SNMPPassword;
    }

    public void setSNMPPassword(String SNMPPassword) {
        this.SNMPPassword = SNMPPassword;
    }

    public String getSNMPIP() {
        return SNMPIP;
    }

    public void setSNMPIP(String SNMPIP) {
        this.SNMPIP = SNMPIP;
    }
    
    

    public Config() {
        setCONFIG_FILE_PATH_WIN("C:\\vegayan\\simplus\\Config_NTT.properties");
        setCONFIG_FILE_PATH_LIN("/home/vegyan/simplus/Config_NTT.properties");

        String OS = System.getProperty("os.name").toLowerCase();
        if (OS.contains("win")) {
            setCONFIG_FILE_PATH(CONFIG_FILE_PATH_WIN);
        } else {
            System.out.println("CONFIG_FILE_PATH_LIN:" + CONFIG_FILE_PATH_LIN);
            setCONFIG_FILE_PATH(CONFIG_FILE_PATH_LIN);
        }

        File file = new File(CONFIG_FILE_PATH);
        if (!file.exists()) {
            System.err.println("ERROR: Config file not found at " + CONFIG_FILE_PATH);
            return; // Stop execution if file is missing
        }

        FileInputStream fileInput = null;
        Properties properties = new Properties();

        try {
            fileInput = new FileInputStream(file);
            properties.load(fileInput);
        } catch (FileNotFoundException e1) {
            System.err.println("ERROR: Config file not found - " + CONFIG_FILE_PATH);
            return;
        } catch (IOException e1) {
            System.err.println("ERROR: Unable to load Config file - " + CONFIG_FILE_PATH);
            return;
        } finally {
            if (fileInput != null) {
                try {
                    fileInput.close();
                } catch (IOException e1) {
                    System.err.println("WARNING: Error closing Config file - " + CONFIG_FILE_PATH);
                }
            }
        }

        setDBSOURCE_IP(properties.getProperty("DBSOURCE_IP"));
        setDBSOURCE_USER(properties.getProperty("DBSOURCE_USER"));
        setDBSOURCE_PASS(properties.getProperty("DBSOURCE_PASS"));
        setDBSOURCE_DBNAME(properties.getProperty("DBSOURCE_DBNAME"));

        setUSER_NAME(properties.getProperty("USER_NAME"));
        setPASSWORD(properties.getProperty("PASSWORD"));
        setCONNECTION_IP(properties.getProperty("CONNECTION_IP"));
        setCONNECTION_PORT(properties.getProperty("CONNECTION_PORT"));
        setCOMMAND_DEVICE(properties.getProperty("COMMAND_DEVICE"));
        
         setSNMPUsername(properties.getProperty("SNMPUsername"));
        setSNMPPassword(properties.getProperty("SNMPPassword"));
        setSNMPIP(properties.getProperty("SNMPIP"));
    }

}
