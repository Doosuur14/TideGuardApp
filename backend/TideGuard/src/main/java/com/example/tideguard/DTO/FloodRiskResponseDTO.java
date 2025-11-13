package com.example.tideguard.DTO;

import com.example.tideguard.Models.FloodZone;
import lombok.Data;

import java.util.List;

@Data
public class FloodRiskResponseDTO {
    private String city;
    private double latitude;
    private double longitude;
    private double rainfall;
    private double soilSaturation;
    private double floodHistory;
    private double fri;
    private String riskLevel;
    private List<ShelterDTO> shelters;
}
