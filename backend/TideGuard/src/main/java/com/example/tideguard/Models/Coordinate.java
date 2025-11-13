package com.example.tideguard.Models;

import lombok.Data;

import javax.persistence.Embeddable;

@Embeddable
@Data
public class Coordinate {
    private Double latitude;
    private Double longitude;
}
