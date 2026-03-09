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

//    @Override
//    public List<LgaWithEnvDTO> getLgasWithEnvByState(String state) {
//
//        System.out.println("=== START getLgasWithEnvByState ===");
//        System.out.println("📡 Fetching LGAs for state: " + state);
//
//        List<LgaGeo> entities = geoService.getLgasByState(state);
//
//        System.out.println("🗃️ GeoService returned " + entities.size() + " LGAs for state: " + state);
//
//        if (entities.isEmpty()) {
//            System.out.println("NO LGAs found for state: " + state);
//
//
//            Set<String> availableStates = geoService.getAllStates();
//            System.out.println("🏛️ Available states: " + availableStates);
//        }
//
//        List<LgaWithEnvDTO> result = entities.stream()
//                .map(this::convertToDtoWithEnvironmentalData)
//                .collect(Collectors.toList());
//
//        System.out.println("🎯 Final result: " + result.size() + " DTOs being returned");
//        System.out.println("=== END getLgasWithEnvByState ===");
//        return result;
//    }


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

//    private LgaWithEnvDTO convertToBasicDto(LgaGeo entity) {
//        LgaWithEnvDTO dto = new LgaWithEnvDTO();
//        dto.setLgaName(entity.getLgaName());
//        dto.setState(entity.getState());
//        dto.setLatitude(entity.getLatitude());
//        dto.setLongitude(entity.getLongitude());
//        return dto;
//    }
//
//    private void mapEnvironmentalDataToDto(LgaWithEnvDTO dto, EnvData envData) {
//        dto.setTp(envData.getTp());
//        dto.setRo(envData.getRo());
//        dto.setT2m(envData.getT2m());
//        dto.setSwvl1(envData.getSwvl1());
//        dto.setTp7d(envData.getTp7d());
//        dto.setTp14d(envData.getTp14d());
//        dto.setTp30d(envData.getTp30d());
//        dto.setTp7dMax(envData.getTp7dMax());
//        dto.setRo7d(envData.getRo7d());
//        dto.setRo14d(envData.getRo14d());
//        dto.setSwvl1_3dChange(envData.getSwvl1_3dChange());
//    }

//    private void setDefaultEnvironmentalData(LgaWithEnvDTO dto) {
//        dto.setTp(0);
//        dto.setRo(0);
//        dto.setT2m(0);
//        dto.setSwvl1(0);
//        dto.setTp7d(0);
//        dto.setTp14d(0);
//        dto.setTp30d(0);
//        dto.setTp7dMax(0);
//        dto.setRo7d(0);
//        dto.setRo14d(0);
//        dto.setSwvl1_3dChange(0);
//    }
}
