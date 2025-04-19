/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.vegayan.pack;

/**
 *
 * @author lapto
 */
public class PlotGraph {

    private String in;
    private String out;
    private String timeseries;

    public PlotGraph(String in, String out, String timeseries) {
        this.in = in;
        this.out = out;
        this.timeseries = timeseries;
    }

    public String getIn() {
        return in;
    }

    public void setIn(String in) {
        this.in = in;
    }

    public String getOut() {
        return out;
    }

    public void setOut(String out) {
        this.out = out;
    }

    public String getTimeseries() {
        return timeseries;
    }

    public void setTimeseries(String timeseries) {
        this.timeseries = timeseries;
    }

}
