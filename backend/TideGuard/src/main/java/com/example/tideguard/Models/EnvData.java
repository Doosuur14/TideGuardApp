package com.example.tideguard.Models;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class EnvData {
    private double rainfall1d;
    private double rainfall3dAvg;
    private double rainfall7dAvg;
    private double rainfall7dMax;
    private double rainfall7dCumulative;

    private double soilMoistureCurrent;
    private double soilMoisture7dAvg;

    private double runoffTotal7d;
    private double surfaceRunoff7d;

    private double temperatureCurrent;
    private double temperature7dAvg;

    private double evaporation7d;

}
