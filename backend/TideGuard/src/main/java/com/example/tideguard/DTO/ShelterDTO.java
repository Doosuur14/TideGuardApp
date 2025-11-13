package com.example.tideguard.DTO;


import lombok.Data;

@Data
public class ShelterDTO {
    private String name;
    private String address;
    private double latitude;
    private double longitude;
    private String routeDescription;
}
