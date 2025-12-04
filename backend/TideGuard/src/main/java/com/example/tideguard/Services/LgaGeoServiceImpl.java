package com.example.tideguard.Services;

import com.example.tideguard.DTO.LgaWithEnvDTO;
import com.example.tideguard.Models.EnvData;
import com.example.tideguard.Models.LgaGeo;
import com.example.tideguard.Repositories.LgaGeoRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Set;
import java.util.concurrent.CompletableFuture;
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

    @Override
    public List<LgaWithEnvDTO> getLgasWithEnvByState(String state) {
        System.out.println("📡 Fetching LGAs for state: " + state);

        List<LgaGeo> entities = geoService.getLgasByState(state);
//
//        List<LgaWithEnvDTO> result = entities.parallelStream()
//                .map(this::convertToDtoWithEnvironmentalData)
//                .collect(Collectors.toList());

        ExecutorService executor = Executors.newFixedThreadPool(5);
        List<CompletableFuture<LgaWithEnvDTO>> futures = entities.stream()
                .map(entity -> CompletableFuture.supplyAsync(() -> convertToDtoWithEnvironmentalData(entity), executor))
                .collect(Collectors.toList());

        List<LgaWithEnvDTO> result = futures.stream()
                .map(CompletableFuture::join)
                .collect(Collectors.toList());

        executor.shutdown();


        System.out.println("🎯 Final result: " + result.size() + " DTOs being returned");

        return result;
    }


    @Override
    public List<LgaWithEnvDTO> getAllLgas() {
        System.out.println("=== START getAllLgas ===");
        List<LgaGeo> entities = geoService.getAllLgas();

        System.out.println("🗃️ Total LGAs from GeoService: " + entities.size());

        List<LgaWithEnvDTO> result = entities.stream()
                .map(this::convertToDtoWithEnvironmentalData)
                .collect(Collectors.toList());

        System.out.println("✅ Returning " + result.size() + " DTOs");
        System.out.println("=== END getAllLgas ===");
        return result;
    }

    @Override
    public LgaGeo getLgaCoordinates(String lgaName) {
        System.out.println("Looking up coordinates for LGA: " + lgaName);
        LgaGeo result = geoService.getLgaByName(lgaName);
        return result;
    }

    private LgaWithEnvDTO convertToDtoWithEnvironmentalData(LgaGeo entity) {
        LgaWithEnvDTO dto = convertToBasicDto(entity);

        try {
            EnvData envData = weatherService.fetchEnvironmentalData(entity.getLgaName());
            mapEnvironmentalDataToDto(dto, envData);
            logger.debug("Successfully fetched environmental data for LGA: {}", entity.getLgaName());
        } catch (Exception e) {
            logger.warn("Failed to fetch environmental data for LGA: {}, using defaults", entity.getLgaName(), e);
            setDefaultEnvironmentalData(dto);
        }

        return dto;
    }

    private LgaWithEnvDTO convertToBasicDto(LgaGeo entity) {
        LgaWithEnvDTO dto = new LgaWithEnvDTO();
        dto.setLgaName(entity.getLgaName());
        dto.setState(entity.getState());
        dto.setLatitude(entity.getLatitude());
        dto.setLongitude(entity.getLongitude());
        return dto;
    }

    private void mapEnvironmentalDataToDto(LgaWithEnvDTO dto, EnvData envData) {
        dto.setRainfall(envData.getRainfall());
        dto.setRainfallLast3Days(envData.getRainfallLast3Days());
        dto.setRainfallLast7Days(envData.getRainfallLast7Days());
        dto.setRunoff(envData.getRunoff());
        dto.setRunoffMaxLast3Days(envData.getRunoffMaxLast3Days());
        dto.setSoilMoisture(envData.getSoilMoisture());
        dto.setSoilMoistureChange7Days(envData.getSoilMoistureChange7Days());
        dto.setAirTemp(envData.getAirTemp());
        dto.setEvaporation(envData.getEvaporation());
    }

    private void setDefaultEnvironmentalData(LgaWithEnvDTO dto) {
        dto.setRainfall(0);
        dto.setRainfallLast3Days(0);
        dto.setRainfallLast7Days(0);
        dto.setRunoff(0);
        dto.setRunoffMaxLast3Days(0);
        dto.setSoilMoisture(50.0);
        dto.setSoilMoistureChange7Days(0);
        dto.setAirTemp(25.0);
        dto.setEvaporation(0);
    }
}
