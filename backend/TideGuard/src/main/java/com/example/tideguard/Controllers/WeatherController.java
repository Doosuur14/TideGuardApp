package com.example.tideguard.Controllers;


import com.example.tideguard.Models.WeatherData;
import com.example.tideguard.Services.WeatherService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class WeatherController {
    @Autowired
    private WeatherService weatherService;

    @GetMapping("/weather/{city}")
    public WeatherData getWeatherForCity(@PathVariable String city) {
        return weatherService.fetchWeatherForCity(city);
    }
}
