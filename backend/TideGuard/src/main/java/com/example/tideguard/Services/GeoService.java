package com.example.tideguard.Services;

import com.example.tideguard.Models.LgaGeo;

import java.util.List;
import java.util.Set;

public interface GeoService {

    void loadGeoJsonData();
    List<LgaGeo> getLgasByState(String state);

    List<LgaGeo> getAllLgas();

    LgaGeo getLgaByName(String lgaName);

    Set<String> getAllStates();

    int getTotalLgasCount();
}
