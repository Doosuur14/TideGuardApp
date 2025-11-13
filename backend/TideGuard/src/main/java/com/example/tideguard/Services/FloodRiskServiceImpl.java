package com.example.tideguard.Services;

import com.example.tideguard.DTO.FloodRiskResponseDTO;
import com.example.tideguard.DTO.ShelterDTO;
import com.example.tideguard.DTO.SoilAndRainData;
import com.example.tideguard.Models.Shelters;
import com.example.tideguard.Repositories.ShelterRepository;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

@Service
public class FloodRiskServiceImpl implements FloodRiskService {

    @Autowired
    private ShelterRepository shelterRepository;
    @Autowired
    private SoilAndRainService soilAndRainService;
    @Override
    public List<FloodRiskResponseDTO> calculateFRI(String city) {
        List<FloodRiskResponseDTO> responses = new ArrayList<>();

        try {
            ClassPathResource floodResource = new ClassPathResource("Nigeria_Flood_Events_2010_2024.json");
            InputStream floodStream = floodResource.getInputStream();
            String floodJson = new String(floodStream.readAllBytes(), StandardCharsets.UTF_8);
            JSONArray yearlyData = new JSONArray(floodJson);

            for (int i = 0; i < yearlyData.length(); i++) {
                JSONObject yearObj = yearlyData.getJSONObject(i);
                JSONArray eventsArray = yearObj.getJSONArray("events");

                for (int j = 0; j < eventsArray.length(); j++) {
                    JSONObject eventObj = eventsArray.getJSONObject(j);
                    String userCity = eventObj.getString("state");

//                    System.out.println("Comparing userCity=" + userCity + " with requested city=" + city);

                    if (city != null && !userCity.equalsIgnoreCase(city)) continue;

                    FloodRiskResponseDTO response = new FloodRiskResponseDTO();
                    response.setCity(city);

                    double latitude = eventObj.getDouble("latitude");
                    double longitude = eventObj.getDouble("longitude");
                    response.setLatitude(latitude);
                    response.setLongitude(longitude);

                    System.out.println("The user's city's latitude is" + latitude);
                    System.out.println("The user's city's longitude is" + longitude);


                    SoilAndRainData soilAndRainData = soilAndRainService.getSoilAndRainData(latitude, longitude);
                    double rainfall = soilAndRainData.getRainfall();
                    double soilSaturation = soilAndRainData.getSoilSaturation();

                    double floodHistory = eventObj.getDouble("people_affected") / 500000.0;
                    double fri = (0.4 * (rainfall / 60)) + (0.3 * soilSaturation) + (0.3 * floodHistory);

                    response.setFri(fri);
                    response.setRainfall(rainfall);
                    response.setSoilSaturation(soilSaturation);
                    response.setFloodHistory(floodHistory);

                    if (fri < 0.4) response.setRiskLevel("LOW");
                    else if (fri < 0.7) response.setRiskLevel("MEDIUM");
                    else response.setRiskLevel("HIGH");

                    List<Shelters> dbShelters = shelterRepository.findByCity(city);
                    List<ShelterDTO> shelterDTOs = new ArrayList<>();
                    for (Shelters s : dbShelters) {
                        ShelterDTO dto = new ShelterDTO();
                        dto.setName(s.getName());
                        dto.setAddress(s.getAddress());
                        dto.setLatitude(s.getLatitude());
                        dto.setLongitude(s.getLongitude());
                        dto.setRouteDescription(s.getRouteDescription());
                        shelterDTOs.add(dto);
                    }
                    response.setShelters(shelterDTOs);

                    responses.add(response);

                    if (city != null) break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return responses;
    }

    @Override
    public FloodRiskResponseDTO calculateFRIForCity(String city) {
        List<FloodRiskResponseDTO> result = calculateFRI(city);
        return result.isEmpty() ? null : result.get(0);
//        if (result.isEmpty()) {
//            FloodRiskResponseDTO defaultResponse = new FloodRiskResponseDTO();
//            defaultResponse.setCity(city);
//            defaultResponse.setLatitude(0.0);
//            defaultResponse.setLongitude(0.0);
//            defaultResponse.setRainfall(0.0);
//            defaultResponse.setSoilSaturation(0.0);
//            defaultResponse.setFloodHistory(0.0);
//            defaultResponse.setFri(0.0);
//            defaultResponse.setRiskLevel("LOW");
//            defaultResponse.setShelters(new ArrayList<>());
//
//            return defaultResponse;
//        }

//        return result.get(0);
    }


}
