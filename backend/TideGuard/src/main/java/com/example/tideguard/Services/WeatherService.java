package com.example.tideguard.Services;

import com.example.tideguard.Models.WeatherData;

public interface WeatherService {
    WeatherData fetchWeatherForCity(String city);
}
