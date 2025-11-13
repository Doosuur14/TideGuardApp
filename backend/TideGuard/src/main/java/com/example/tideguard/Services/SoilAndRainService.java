package com.example.tideguard.Services;

import com.example.tideguard.DTO.SoilAndRainData;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDate;
import java.util.concurrent.ConcurrentHashMap;


@Component
public class SoilAndRainService {
    private final RestTemplate restTemplate = new RestTemplate();

    public SoilAndRainData getSoilAndRainData(double latitude, double longitude) {
        try {

            LocalDate endDate = LocalDate.now();
            LocalDate startDate = endDate.minusDays(30);


            String url = String.format(
                    "https://archive-api.open-meteo.com/v1/era5" +
                            "?latitude=%.4f" +
                            "&longitude=%.4f" +
                            "&daily=precipitation_sum,soil_moisture_0_to_7cm_mean" +
                            "&start_date=%s" +
                            "&end_date=%s" +
                            "&timezone=auto",
                    latitude, longitude, startDate, endDate
            );

            String response = restTemplate.getForObject(url, String.class);
            JSONObject json = new JSONObject(response);

            JSONArray rainArray = json.getJSONObject("daily").getJSONArray("precipitation_sum");
            JSONArray soilArray = json.getJSONObject("daily").getJSONArray("soil_moisture_0_to_7cm_mean");

//            double totalRainfall = 0.0;
//            for (int i = 0; i < rainArray.length(); i++) {
//                totalRainfall += rainArray.getDouble(i);
//            }
//
//            // Average soil moisture for last 7 days
//            double avgSoilMoisture = 0.0;
//            for (int i = 0; i < soilArray.length(); i++) {
//                avgSoilMoisture += soilArray.getDouble(i);
//            }
//            avgSoilMoisture /= soilArray.length();
//
//            SoilAndRainData data = new SoilAndRainData();
//            data.setRainfall(totalRainfall);
//            data.setSoilSaturation(avgSoilMoisture);
//
//            return data;
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            return new SoilAndRainData(0.0, 0.0);
//        }
//    }


            double totalRainfall = 0.0;
            for (int i = 0; i < rainArray.length(); i++) {
                totalRainfall += rainArray.getDouble(i);
            }

            double avgSoilMoisture = 0.0;
            int validSoilEntries = 0;

            for (int i = 0; i < soilArray.length(); i++) {
                if (!soilArray.isNull(i)) { // skip nulls
                    avgSoilMoisture += soilArray.getDouble(i);
                    validSoilEntries++;
                }
            }

            if (validSoilEntries > 0) {
                avgSoilMoisture /= validSoilEntries;
            }


            SoilAndRainData data = new SoilAndRainData();
            data.setRainfall(totalRainfall);
            data.setSoilSaturation(avgSoilMoisture);

//            System.out.println("✅ Fetched soil & rain data for lat: " + latitude + ", lon: " + longitude);
//            System.out.println("🌧️ Rainfall (mm): " + totalRainfall);
//            System.out.println("🌱 Soil moisture: " + avgSoilMoisture);

            return data;

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("⚠️ Failed to fetch soil/rain data for lat/lon: " + latitude + ", " + longitude);
            return new SoilAndRainData(0.0, 0.0);
        }
    }
}
