package com.example.tideguard.Controllers;


import com.example.tideguard.DTO.FloodRiskResponseDTO;
import com.example.tideguard.Models.FloodArea;
import com.example.tideguard.Services.FloodAreaService;
import com.example.tideguard.Services.FloodRiskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Optional;

@RestController
@RequestMapping("/api")
public class FloodAreaController {

    @Autowired
    private FloodAreaService floodAreaService;

    @Autowired
    private FloodRiskService floodRiskService;

    @GetMapping("/flood-areas/{city}")
    public FloodArea getFloodAreas(@PathVariable String city) {
        Optional<FloodArea> floodArea = floodAreaService.findByCity(city);
        return floodArea.orElse(new FloodArea());
    }

    @GetMapping("/risk/{city}")
    public FloodRiskResponseDTO getFloodRiskForCity(@PathVariable String city) {
        return floodRiskService.calculateFRIForCity(city);
    }
}
