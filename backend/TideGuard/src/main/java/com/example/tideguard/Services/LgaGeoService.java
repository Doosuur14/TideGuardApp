package com.example.tideguard.Services;

import com.example.tideguard.DTO.LgaWithEnvDTO;
import com.example.tideguard.Models.LgaGeo;

import java.util.List;

public interface LgaGeoService {
    List<LgaWithEnvDTO> getLgasWithEnvByState(String state);
    List<LgaWithEnvDTO> getAllLgas();

    LgaGeo getLgaCoordinates(String lgaName);


}
