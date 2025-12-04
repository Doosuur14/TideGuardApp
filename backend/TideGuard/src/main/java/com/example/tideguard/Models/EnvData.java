package com.example.tideguard.Models;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EnvData {
    private double rainfall;
    private double rainfallLast3Days;
    private double rainfallLast7Days;
    private double runoff;
    private double runoffMaxLast3Days;
    private double soilMoisture;
    private double soilMoistureChange7Days;
    private double airTemp;
    private double evaporation;
}
