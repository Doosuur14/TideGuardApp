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

    private double tp;
    private double ro;
    private double t2m;
    private double swvl1;

    private double tp7d;
    private double tp14d;
    private double tp30d;
    private double tp7dMax;

    private double ro7d;
    private double ro14d;

    private double swvl1_3dChange;
}
