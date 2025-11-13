package com.example.tideguard.Models;

import lombok.Data;

@Data
public class WeatherData {
    private String description;
    private Double temperature;
    private Double humidity;
    private String imageUrl;
}
