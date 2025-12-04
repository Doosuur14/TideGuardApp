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
