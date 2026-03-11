package com.example.tideguard.Services;

import com.example.tideguard.DTO.LgaWithEnvDTO;
import com.example.tideguard.Models.EnvData;
import com.example.tideguard.Models.LgaGeo;
import com.example.tideguard.Repositories.LgaGeoRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;


@Component
public class LgaGeoServiceImpl implements LgaGeoService {

    @Autowired
    private LgaGeoRepository lgaGeoRepository;

    @Autowired
    private WeatherService weatherService;

    @Autowired
    private GeoService geoService;
    private static final Logger logger = LoggerFactory.getLogger(LgaGeoServiceImpl.class);

    private final Map<String, EnvData> stateCache = new ConcurrentHashMap<>();
    @Override
    public List<LgaWithEnvDTO> getLgasWithEnvByState(String state) {
        System.out.println("Fetching LGAs for state: " + state);

        List<LgaGeo> entities = geoService.getLgasByState(state);
        if (entities.isEmpty()) return Collections.emptyList();

        EnvData stateEnvData = stateCache.computeIfAbsent(state, k -> {
            LgaGeo representative = entities.get(0);
            return weatherService.fetchEnvironmentalData(
                    representative.getLatitude(),
                    representative.getLongitude()
            );
        });

        List<LgaWithEnvDTO> result = entities.stream()
                .map(entity -> convertToDtoWithEnvironmentalData(entity, stateEnvData))
                .collect(Collectors.toList());

        System.out.println("Final result: " + result.size() + " DTOs being returned");
        return result;
    }


    public List<LgaWithEnvDTO> getAllLgas() {
        List<LgaGeo> allLgas = lgaGeoRepository.findAll();

        Map<String, LgaGeo> stateReps = new HashMap<>();
        for (LgaGeo lga : allLgas) {
            stateReps.putIfAbsent(lga.getState(), lga);
        }

        Map<String, EnvData> stateWeather = new HashMap<>();
        for (Map.Entry<String, LgaGeo> entry : stateReps.entrySet()) {
            String state    = entry.getKey();
            LgaGeo rep   = entry.getValue();
            EnvData envData = weatherService.fetchEnvironmentalData(
                    rep.getLatitude(),
                    rep.getLongitude()
            );
            stateWeather.put(state, envData);
        }

        return allLgas.stream()
                .map(lga -> {
                    EnvData envData = stateWeather.getOrDefault(
                            lga.getState(),
                            new EnvData()
                    );
                    return convertToDtoWithEnvironmentalData(lga, envData);
                })
                .collect(Collectors.toList());
    }

    @Override
    public LgaGeo getLgaCoordinates(String lgaName) {
        System.out.println("Looking up coordinates for LGA: " + lgaName);
        LgaGeo result = geoService.getLgaByName(lgaName);
        return result;
    }

    private LgaWithEnvDTO convertToDtoWithEnvironmentalData(LgaGeo lga, EnvData envData) {
        LgaWithEnvDTO dto = new LgaWithEnvDTO();
        dto.setLgaName(lga.getLgaName());
        dto.setState(lga.getState());
        dto.setLatitude(lga.getLatitude());
        dto.setLongitude(lga.getLongitude());

        dto.setTp(envData.getTp());
        dto.setRo(envData.getRo());
        dto.setT2m(envData.getT2m());
        dto.setSwvl1(envData.getSwvl1());
        dto.setTp7d(envData.getTp7d());
        dto.setTp14d(envData.getTp14d());
        dto.setTp30d(envData.getTp30d());
        dto.setTp7dMax(envData.getTp7dMax());
        dto.setRo7d(envData.getRo7d());
        dto.setRo14d(envData.getRo14d());
        dto.setSwvl1_3dChange(envData.getSwvl1_3dChange());
        return dto;
    }
}
