package com.example.tideguard.Models;


import lombok.Data;
import lombok.Getter;

import javax.persistence.*;
import java.util.List;

@Entity
@Data
public class FloodArea {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String city;

    @ElementCollection
    @CollectionTable(name = "flood_zone", joinColumns = @JoinColumn(name = "flood_area_id"))
    private List<FloodZone> floodAreas;


}

