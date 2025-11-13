package com.example.tideguard.Services;

import com.example.tideguard.Models.Shelters;

import java.util.List;

public interface ShelterService {
    List<Shelters> getSheltersByCity(String city);
}

