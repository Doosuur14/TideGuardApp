package com.example.tideguard;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

public class HistoricalDataLoader {
    private static final Map<String, Double> historicalIndex = new HashMap<>();

    static {
        try (InputStream input = HistoricalDataLoader.class.getResourceAsStream("Nigeria_Flood_Events_2010_2024.json")) {
            ObjectMapper mapper = new ObjectMapper();
            Map<String, Object>[] data = mapper.readValue(input, new TypeReference<>() {});
            for (Map<String, Object> item : data) {
                String city = (String) item.get("city");
                Double frequency = Double.parseDouble(item.get("floodFrequency").toString());
                historicalIndex.put(city.toLowerCase(), frequency);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
