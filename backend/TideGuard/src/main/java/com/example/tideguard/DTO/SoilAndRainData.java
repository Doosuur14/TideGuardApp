package com.example.tideguard.DTO;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SoilAndRainData {
    private double rainfall;
    private double soilSaturation;

}
