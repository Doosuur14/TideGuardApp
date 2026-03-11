package com.example.tideguard.Services;

import com.example.tideguard.Models.FloodForecast;

import java.util.List;

public interface FloodForecastService {
    List<FloodForecast> fetchFloodForecast(String state);
}
