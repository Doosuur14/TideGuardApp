package com.example.tideguard.Services;

import com.example.tideguard.Models.EnvData;
import com.example.tideguard.Models.WeatherData;

public interface WeatherService {
    WeatherData fetchWeatherForCity(String city);
    WeatherData fetchWeatherForLga(String lgaName);
    EnvData fetchEnvironmentalData(double latitude, double longitude);
}
