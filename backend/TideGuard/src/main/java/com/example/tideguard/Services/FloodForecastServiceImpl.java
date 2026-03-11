package com.example.tideguard.Services;

import com.example.tideguard.Models.FloodForecast;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Component
public class FloodForecastServiceImpl implements FloodForecastService {

    @Autowired
    private final RestTemplate restTemplate;

    public FloodForecastServiceImpl(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }
    @Override
    public List<FloodForecast> fetchFloodForecast(String state) {

        try {
            String geocodeUrl = "https://nominatim.openstreetmap.org/search?format=json&q="
                    + state.replace(" ", "+") + "+Nigeria";

            HttpHeaders headers = new HttpHeaders();
            headers.set("User-Agent", "TideGuardApp/1.0 (contact@youremail.com)");
            HttpEntity<String> entity = new HttpEntity<>(headers);

            ResponseEntity<String> geocodeResponse = restTemplate.exchange(
                    geocodeUrl, HttpMethod.GET, entity, String.class);

            if (geocodeResponse.getBody() == null) return Collections.emptyList();

            JSONArray geocodeArray = new JSONArray(geocodeResponse.getBody());
            if (geocodeArray.length() == 0) return Collections.emptyList();

            JSONObject geocodeResult = geocodeArray.getJSONObject(0);
            double latitude  = geocodeResult.getDouble("lat");
            double longitude = geocodeResult.getDouble("lon");

            // Step 2 - Fetch past 30 days + 14 day forecast in one call
            String url = String.format(
                    "https://api.open-meteo.com/v1/forecast" +
                            "?latitude=%.6f&longitude=%.6f" +
                            "&daily=precipitation_sum,et0_fao_evapotranspiration,temperature_2m_mean" +
                            "&hourly=soil_moisture_0_to_1cm" +
                            "&past_days=30" +
                            "&forecast_days=14" +
                            "&timezone=auto",
                    latitude, longitude
            );


            String response = restTemplate.getForObject(url, String.class);
            if (response == null) return Collections.emptyList();

            JSONObject json       = new JSONObject(response);
            JSONObject daily      = json.getJSONObject("daily");
            JSONObject hourly     = json.getJSONObject("hourly");

            JSONArray dates       = daily.getJSONArray("time");
            JSONArray rainfall    = daily.getJSONArray("precipitation_sum");
            JSONArray et0         = daily.getJSONArray("et0_fao_evapotranspiration");
            JSONArray tempArray   = daily.getJSONArray("temperature_2m_mean");
            JSONArray soilHourly  = hourly.getJSONArray("soil_moisture_0_to_1cm");

            JSONArray soilDaily   = hourlyToDailyAverage(soilHourly);

            int totalDays     = dates.length();
            int forecastStart = totalDays - 14;

            List<FloodForecast> forecastList = new ArrayList<>();

            for (int i = forecastStart; i < totalDays; i++) {
                FloodForecast day = new FloodForecast();

                String dateStr = dates.getString(i);
                day.setDate(dateStr);
                day.setDayName(getDayName(dateStr));

                java.time.LocalDate localDate = java.time.LocalDate.parse(dateStr);
                day.setMonth(localDate.getMonthValue());
                day.setDayOfYear(localDate.getDayOfYear());

                double tp   = getValueOrZero(rainfall, i);
                double et0v = getValueOrZero(et0, i);
                double temp = getValueOrZero(tempArray, i) + 273.15;
                double soil = getValueOrZero(soilDaily, i);
                double ro   = Math.max(0, tp - et0v);

                day.setTp(tp);
                day.setRo(ro);
                day.setT2m(temp);
                day.setSwvl1(soil);

                day.setTp_7d(sumRange(rainfall, i - 6, i));
                day.setTp_14d(sumRange(rainfall, i - 13, i));
                day.setTp_30d(sumRange(rainfall, i - 29, i));
                day.setTp_7d_max(maxRange(rainfall, i - 6, i));
                day.setRo_7d(Math.max(0, sumRange(rainfall, i - 6, i) - sumRange(et0, i - 6, i)));
                day.setRo_14d(Math.max(0, sumRange(rainfall, i - 13, i) - sumRange(et0, i - 13, i)));

                double soilNow   = getValueOrZero(soilDaily, i);
                double soil3Back = getValueOrZero(soilDaily, Math.max(0, i - 3));
                day.setSwvl1_3d_change(soilNow - soil3Back);

                day.setLatitude(latitude);
                day.setLongitude(longitude);

                forecastList.add(day);
            }

            return forecastList;

        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }


    private double sumRange(JSONArray arr, int from, int to) {
        double sum = 0;
        for (int i = Math.max(0, from); i <= to && i < arr.length(); i++) {
            sum += getValueOrZero(arr, i);
        }
        return sum;
    }

    private double maxRange(JSONArray arr, int from, int to) {
        double max = 0;
        for (int i = Math.max(0, from); i <= to && i < arr.length(); i++) {
            max = Math.max(max, getValueOrZero(arr, i));
        }
        return max;
    }

    private double getValueOrZero(JSONArray arr, int index) {
        try {
            if (index < 0 || index >= arr.length() || arr.isNull(index)) return 0.0;
            return arr.getDouble(index);
        } catch (Exception e) { return 0.0; }
    }

    private JSONArray hourlyToDailyAverage(JSONArray hourly) throws Exception {
        JSONArray daily = new JSONArray();
        int totalDays = hourly.length() / 24;
        for (int d = 0; d < totalDays; d++) {
            double sum = 0; int count = 0;
            for (int h = 0; h < 24; h++) {
                int idx = d * 24 + h;
                if (idx < hourly.length() && !hourly.isNull(idx)) {
                    sum += hourly.getDouble(idx); count++;
                }
            }
            daily.put(count > 0 ? sum / count : 0.0);
        }
        return daily;
    }

    private String getDayName(String dateStr) {
        try {
            return java.time.LocalDate.parse(dateStr)
                    .getDayOfWeek()
                    .getDisplayName(java.time.format.TextStyle.SHORT, java.util.Locale.ENGLISH);
        } catch (Exception e) { return dateStr; }
    }
}
