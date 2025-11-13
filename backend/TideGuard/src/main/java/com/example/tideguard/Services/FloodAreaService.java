package com.example.tideguard.Services;

import com.example.tideguard.Models.FloodArea;

import java.util.Optional;

public interface FloodAreaService {

    Optional<FloodArea> findByCity(String city);
}
