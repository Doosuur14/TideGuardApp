package com.example.tideguard.DTO;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LgaWithEnvDTO {
    private String lgaName;
    private String state;
    private double latitude;
    private double longitude;

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
