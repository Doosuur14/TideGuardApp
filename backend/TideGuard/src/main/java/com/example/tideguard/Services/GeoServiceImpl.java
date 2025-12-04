package com.example.tideguard.Services;

import com.example.tideguard.Models.LgaGeo;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;


@Component
public class GeoServiceImpl implements GeoService {

    private final Resource geoJsonResource = new ClassPathResource("nigeria_lga.geojson");
    private List<LgaGeo> allLgas = new ArrayList<>();


    @PostConstruct
    @Override
    public void loadGeoJsonData() {
        System.out.println("=== LOADING GEOJSON DATA ===");
        try {
            InputStream inputStream = geoJsonResource.getInputStream();
            String geoJsonContent = new String(inputStream.readAllBytes(), StandardCharsets.UTF_8);

            System.out.println("📄 First 1000 chars of GeoJSON:");
            System.out.println(geoJsonContent.substring(0, Math.min(1000, geoJsonContent.length())));
            System.out.println("...");


            JSONObject geoJson = new JSONObject(geoJsonContent);
            JSONArray features = geoJson.getJSONArray("features");

            System.out.println("📁 Found " + features.length() + " features in GeoJSON");


            if (features.length() > 0) {
                JSONObject firstFeature = features.getJSONObject(0);
                JSONObject firstProperties = firstFeature.getJSONObject("properties");
                System.out.println("🔍 FIRST FEATURE PROPERTIES KEYS: " + firstProperties.keySet());
                System.out.println("🔍 FIRST FEATURE PROPERTIES VALUES: " + firstProperties.toString());

                JSONObject firstGeometry = firstFeature.getJSONObject("geometry");
                System.out.println("🔍 FIRST FEATURE GEOMETRY TYPE: " + firstGeometry.getString("type"));
            }

            int unknownCount = 0;
            int knownCount = 0;

            for (int i = 0; i < features.length(); i++) {
                JSONObject feature = features.getJSONObject(i);
                JSONObject properties = feature.getJSONObject("properties");
                JSONObject geometry = feature.getJSONObject("geometry");

                // Debug: Print all available property keys for first 3 features
                if (i < 3) {
                    System.out.println("🔑 Properties keys for feature " + i + ": " + properties.keySet());
                }

                // Try to get LGA name and state from various possible property names
                String lgaName = "Unknown";
                String state = "Unknown";

                // Check all possible property names for LGA
                String[] lgaNameKeys = {"lga_name", "LGA_Name", "lgaName", "name", "LGA", "lga", "NAME", "admin2Name", "ADM2_EN", "LGA_NAME"};
                for (String key : lgaNameKeys) {
                    if (properties.has(key) && !properties.isNull(key)) {
                        String value = properties.optString(key, "").trim();
                        if (!value.isEmpty() && !value.equals("null")) {
                            lgaName = value;
                            break;
                        }
                    }
                }

                // Check all possible property names for state
                String[] stateKeys = {"state_name", "state", "State", "STATE", "admin1Name", "ADM1_EN", "admin1", "STATE_NAME"};
                for (String key : stateKeys) {
                    if (properties.has(key) && !properties.isNull(key)) {
                        String value = properties.optString(key, "").trim();
                        if (!value.isEmpty() && !value.equals("null")) {
                            state = value;
                            break;
                        }
                    }
                }

                JSONArray coordinates = geometry.getJSONArray("coordinates");
                double[] centroid = calculateCentroid(coordinates);

                LgaGeo lga = new LgaGeo(lgaName, state, centroid[0], centroid[1]);
                allLgas.add(lga);

                if (lgaName.equals("Unknown") || state.equals("Unknown")) {
                    unknownCount++;
                } else {
                    knownCount++;
                }


                if (i < 10) {
                    System.out.println("📍 Loaded LGA: " + lgaName + " | State: " + state +
                            " | Coords: " + centroid[0] + ", " + centroid[1]);
                }
            }

            System.out.println("✅ Successfully loaded " + allLgas.size() + " LGAs from GeoJSON");
            System.out.println("📊 Known LGAs: " + knownCount + ", Unknown LGAs: " + unknownCount);

            Set<String> uniqueStates = allLgas.stream()
                    .map(LgaGeo::getState)
                    .filter(s -> !s.equals("Unknown"))
                    .collect(Collectors.toSet());
            System.out.println("Unique states found: " + uniqueStates);

        } catch (Exception e) {
            System.out.println("Failed to load GeoJSON: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    public List<LgaGeo> getLgasByState(String state) {
        List<LgaGeo> result = allLgas.stream()
                .filter(lga -> lga.getState().equalsIgnoreCase(state))
                .collect(Collectors.toList());

        System.out.println("🔍 Found " + result.size() + " LGAs for state: " + state);
        return result;
    }

    @Override
    public List<LgaGeo> getAllLgas() {
        System.out.println("Returning all " + allLgas.size() + " LGAs");
        return new ArrayList<>(allLgas);
    }

    @Override
    public LgaGeo getLgaByName(String lgaName) {
        LgaGeo result = allLgas.stream()
                .filter(lga -> lga.getLgaName().equalsIgnoreCase(lgaName))
                .findFirst()
                .orElse(null);

        if (result == null) {
            System.out.println("LGA not found: " + lgaName);
        } else {
            System.out.println("Found LGA: " + result.getLgaName());
        }

        return result;
    }

    @Override
    public Set<String> getAllStates() {
        Set<String> states = allLgas.stream()
                .map(LgaGeo::getState)
                .collect(Collectors.toSet());

        System.out.println("Available states: " + states);
        return states;
    }

    @Override
    public int getTotalLgasCount() {
        return allLgas.size();
    }


    private double[] calculateCentroid(JSONArray coordinates) {
        try {
            String geometryType = determineGeometryType(coordinates);

            switch (geometryType) {
                case "Polygon":
                    return calculatePolygonCentroid(coordinates);
                case "MultiPolygon":
                    return calculateMultiPolygonCentroid(coordinates);
                default:
                    System.out.println("Unknown geometry type: " + geometryType);
                    return new double[]{9.0820, 8.6753};
            }
        } catch (Exception e) {
            System.out.println("Failed to calculate centroid: " + e.getMessage());
            return new double[]{9.0820, 8.6753};
        }
    }

    private String determineGeometryType(JSONArray coordinates) {
        try {
            JSONArray firstElement = coordinates.getJSONArray(0);
            JSONArray secondElement = firstElement.getJSONArray(0);
            if (secondElement.get(0) instanceof Number) {
                return "Polygon";
            }
        } catch (Exception e) {

        }

        try {
            JSONArray firstElement = coordinates.getJSONArray(0);
            JSONArray secondElement = firstElement.getJSONArray(0);
            JSONArray thirdElement = secondElement.getJSONArray(0);
            if (thirdElement.get(0) instanceof Number) {
                return "MultiPolygon";
            }
        } catch (Exception e) {
        }

        return "Unknown";
    }

    private double[] calculatePolygonCentroid(JSONArray coordinates) {
        JSONArray firstRing = coordinates.getJSONArray(0);
        JSONArray firstCoordinate = firstRing.getJSONArray(0);
        double lon = firstCoordinate.getDouble(0);
        double lat = firstCoordinate.getDouble(1);
        return new double[]{lat, lon};
    }

    private double[] calculateMultiPolygonCentroid(JSONArray coordinates) {
        JSONArray firstPolygon = coordinates.getJSONArray(0);
        JSONArray firstRing = firstPolygon.getJSONArray(0);
        JSONArray firstCoordinate = firstRing.getJSONArray(0);
        double lon = firstCoordinate.getDouble(0);
        double lat = firstCoordinate.getDouble(1);
        return new double[]{lat, lon};
    }
}
