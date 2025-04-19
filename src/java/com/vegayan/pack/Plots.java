/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.vegayan.pack;

/**
 *
 * @author lapto
 */
public class Plots {

    private String graph;
    private String timeseries;

    // Constructor
    public Plots(String data, String timeseries) {
        this.graph = data;
        this.timeseries = timeseries;
    }

    // Default Constructor
    public Plots() {
    }
   
    public String getGraph() {
        return graph;
    }

    // Getters and Setters
    public void setGraph(String graph) {   
        this.graph = graph;
    }

    public String getTimeseries() {
        return timeseries;
    }

    public void setTimeseries(String timeseries) {
        this.timeseries = timeseries;
    }
}
