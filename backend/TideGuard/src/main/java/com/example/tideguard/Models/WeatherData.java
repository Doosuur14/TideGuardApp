package com.example.tideguard.Models;

import lombok.Data;

import java.util.List;

@Data
public class WeatherData {

    private String description;
    private Double temperature;
    private Double humidity;
    private String imageUrl;
    private Double precipitation;

    private List<DailyForecast> weeklyForecast;

    @Data
    public static class DailyForecast {
        private String date;
        private double maxTemp;
        private double minTemp;
        private int weatherCode;
        private double precipitation;
        private String description;
        private String icon;
    }
}
