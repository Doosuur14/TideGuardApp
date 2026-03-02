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
