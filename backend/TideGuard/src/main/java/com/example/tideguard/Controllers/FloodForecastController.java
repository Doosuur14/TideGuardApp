package com.example.tideguard.Controllers;


import com.example.tideguard.Models.FloodForecast;
import com.example.tideguard.Services.FloodForecastService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api")
public class FloodForecastController {

    @Autowired
    private FloodForecastService floodForecastService;

    @GetMapping("/flood-forecast/{state}")
    public List<FloodForecast> getFloodForecast(@PathVariable String state) {
        return floodForecastService.fetchFloodForecast(state);
    }
}
