package com.example.tideguard.Models;


import lombok.Data;

@Data
public class FloodForecast {

    private String date;
    private String dayName;
    private double tp;
    private double ro;
    private double t2m;
    private double swvl1;
    private double tp_7d;
    private double tp_14d;
    private double tp_30d;
    private double tp_7d_max;
    private double ro_7d;
    private double ro_14d;
    private double swvl1_3d_change;
    private double latitude;
    private double longitude;
    private int month;
    private int dayOfYear;
    private double stateEncoded;

}
