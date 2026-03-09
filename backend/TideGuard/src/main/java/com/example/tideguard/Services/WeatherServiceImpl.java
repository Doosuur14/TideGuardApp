package com.example.tideguard.Services;


import com.example.tideguard.Models.EnvData;
import com.example.tideguard.Models.WeatherData;
import com.example.tideguard.Repositories.UserRepository;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.http.HttpEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CompletableFuture;


@Service
public class WeatherServiceImpl implements WeatherService {

    @Autowired
    private final RestTemplate restTemplate;
    @Autowired
    private final UserRepository userRepository;

    public WeatherServiceImpl(RestTemplate restTemplate, UserRepository userRepository) {
        this.restTemplate = restTemplate;
        this.userRepository = userRepository;
    }




    public WeatherData fetchWeatherForCity(String city) {
        try {

            String geocodeUrl = "https://nominatim.openstreetmap.org/search?format=json&q="
                    + city.replace(" ", "+");

            HttpHeaders headers = new HttpHeaders();
            headers.set("User-Agent", "TideGuardApp/1.0 (contact@youremail.com)");
            HttpEntity<String> entity = new HttpEntity<>(headers);

            ResponseEntity<String> geocodeResponse = restTemplate.exchange(
                    geocodeUrl, HttpMethod.GET, entity, String.class);

            if (geocodeResponse.getBody() == null) return createDefaultWeatherData();

            JSONArray geocodeArray = new JSONArray(geocodeResponse.getBody());
            if (geocodeArray.length() == 0) return createDefaultWeatherData();

            JSONObject geocodeResult = geocodeArray.getJSONObject(0);
            double latitude  = geocodeResult.getDouble("lat");
            double longitude = geocodeResult.getDouble("lon");

            String weatherUrl = String.format(
                    "https://api.open-meteo.com/v1/forecast" +
                            "?latitude=%.6f&longitude=%.6f" +
                            "&current_weather=true" +
                            "&hourly=relative_humidity_2m" +
                            "&daily=temperature_2m_max,temperature_2m_min,weathercode,precipitation_sum" +
                            "&forecast_days=7" +
                            "&timezone=auto",
                    latitude, longitude
            );

            String weatherResponse = restTemplate.getForObject(weatherUrl, String.class);
            if (weatherResponse == null) return createDefaultWeatherData();

            JSONObject weatherJson = new JSONObject(weatherResponse);

            JSONObject currentWeather = weatherJson.getJSONObject("current_weather");
            double temperature        = currentWeather.getDouble("temperature");
            int weatherCode           = currentWeather.getInt("weathercode");

            double humidity = 0.0;
            if (weatherJson.has("hourly")) {
                JSONObject hourly = weatherJson.getJSONObject("hourly");
                if (hourly.has("relative_humidity_2m")) {
                    JSONArray humidityArray = hourly.getJSONArray("relative_humidity_2m");
                    humidity = humidityArray.length() > 0 ? humidityArray.getDouble(0) : 0.0;
                }
            }

            List<WeatherData.DailyForecast> forecastList = new ArrayList<>();
            if (weatherJson.has("daily")) {
                JSONObject daily        = weatherJson.getJSONObject("daily");
                JSONArray dates         = daily.getJSONArray("time");
                JSONArray maxTemps      = daily.getJSONArray("temperature_2m_max");
                JSONArray minTemps      = daily.getJSONArray("temperature_2m_min");
                JSONArray weatherCodes  = daily.getJSONArray("weathercode");
                JSONArray precipitation = daily.getJSONArray("precipitation_sum");

                for (int i = 0; i < dates.length(); i++) {
                    WeatherData.DailyForecast day = new WeatherData.DailyForecast();
                    int code = weatherCodes.getInt(i);
                    day.setDate(getDayName(dates.getString(i)));
                    day.setMaxTemp(maxTemps.getDouble(i));
                    day.setMinTemp(minTemps.getDouble(i));
                    day.setWeatherCode(code);
                    day.setPrecipitation(precipitation.getDouble(i));
                    day.setDescription(mapWeatherCodeToDescription(code));
                    day.setIcon(mapWeatherCodeToImageUrl(code));
                    forecastList.add(day);
                }
            }


            WeatherData weatherData = new WeatherData();
            weatherData.setDescription(mapWeatherCodeToDescription(weatherCode));
            weatherData.setTemperature(temperature);
            weatherData.setHumidity(humidity);
            weatherData.setImageUrl(mapWeatherCodeToImageUrl(weatherCode));
            weatherData.setWeeklyForecast(forecastList);
            return weatherData;

        } catch (Exception e) {
            e.printStackTrace();
            return createDefaultWeatherData();
        }
    }


//    public WeatherData fetchWeatherForCity(String city) {
//
//        try {
//            String geocodeUrl = "https://nominatim.openstreetmap.org/search?format=json&q="
//                    + city.replace(" ", "+");
//
//            HttpHeaders headers = new HttpHeaders();
//            headers.set("User-Agent", "TideGuardApp/1.0 (contact@youremail.com)");
//            HttpEntity<String> entity = new HttpEntity<>(headers);
//
//            ResponseEntity<String> geocodeResponse = restTemplate.exchange(
//                    geocodeUrl,
//                    HttpMethod.GET,
//                    entity,
//                    String.class
//            );
//
//            if (geocodeResponse.getBody() == null) {
//                return createDefaultWeatherData();
//            }
//
//            JSONArray geocodeArray = new JSONArray(geocodeResponse.getBody());
//            if (geocodeArray.length() == 0) {
//                return createDefaultWeatherData();
//            }
//
//            JSONObject geocodeResult = geocodeArray.getJSONObject(0);
//            double latitude = geocodeResult.getDouble("lat");
//            double longitude = geocodeResult.getDouble("lon");
//
//            String weatherUrl = String.format(
//                    "https://api.open-meteo.com/v1/forecast" +
//                            "?latitude=%.6f&longitude=%.6f" +
//                            "&current_weather=true" +
//                            "&hourly=relative_humidity_2m",
//                    latitude, longitude
//            );
//
//            String weatherResponse = restTemplate.getForObject(weatherUrl, String.class);
//            if (weatherResponse == null) {
//                return createDefaultWeatherData();
//            }
//
//            JSONObject weatherJson     = new JSONObject(weatherResponse);
//            JSONObject currentWeather  = weatherJson.getJSONObject("current_weather");
//            double temperature         = currentWeather.getDouble("temperature");
//            int weatherCode            = currentWeather.getInt("weathercode");
//
//            double humidity = 0.0;
//            if (weatherJson.has("hourly")) {
//                JSONObject hourly = weatherJson.getJSONObject("hourly");
//                if (hourly.has("relative_humidity_2m")) {
//                    JSONArray humidityArray = hourly.getJSONArray("relative_humidity_2m");
//                    humidity = humidityArray.length() > 0 ? humidityArray.getDouble(0) : 0.0;
//                }
//            }
//
//            String description = mapWeatherCodeToDescription(weatherCode);
//            String imageUrl    = mapWeatherCodeToImageUrl(weatherCode);
//
//            WeatherData weatherData = new WeatherData();
//            weatherData.setDescription(description);
//            weatherData.setTemperature(temperature);
//            weatherData.setHumidity(humidity);
//            weatherData.setImageUrl(imageUrl);
//            return weatherData;
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            return createDefaultWeatherData();
//        }
//    }
//
//
//    public WeatherData fetchWeeklyWeatherForCity(String city) {
//        try {
//
//            String geocodeUrl = "https://nominatim.openstreetmap.org/search?format=json&q="
//                    + city.replace(" ", "+");
//
//            HttpHeaders headers = new HttpHeaders();
//            headers.set("User-Agent", "TideGuardApp/1.0 (contact@youremail.com)");
//            HttpEntity<String> entity = new HttpEntity<>(headers);
//
//            ResponseEntity<String> geocodeResponse = restTemplate.exchange(
//                    geocodeUrl,
//                    HttpMethod.GET,
//                    entity,
//                    String.class
//            );
//
//            if (geocodeResponse.getBody() == null) {
//                return createDefaultWeatherData();
//            }
//
//            JSONArray geocodeArray = new JSONArray(geocodeResponse.getBody());
//            if (geocodeArray.length() == 0) {
//                return createDefaultWeatherData();
//            }
//
//            JSONObject geocodeResult = geocodeArray.getJSONObject(0);
//            double latitude = geocodeResult.getDouble("lat");
//            double longitude = geocodeResult.getDouble("lon");
//
//            String weatherUrl = String.format(
//                    "https://api.open-meteo.com/v1/forecast" +
//                            "?latitude=%.6f&longitude=%.6f" +
//                            "&daily=temperature_2m_max,temperature_2m_min,weathercode,precipitation_sum" +
//                            "&forecast_days=7" +
//                            "&timezone=auto",
//                    latitude, longitude
//            );
//
//            String weatherResponse = restTemplate.getForObject(weatherUrl, String.class);
//            if (weatherResponse == null) {
//                return createDefaultWeatherData();
//            }
//
//            JSONObject weatherJson     = new JSONObject(weatherResponse);
//            JSONObject daily       = weatherJson.getJSONObject("daily");
//
//            JSONArray dates        = daily.getJSONArray("time");
//            JSONArray maxTemps     = daily.getJSONArray("temperature_2m_max");
//            JSONArray minTemps     = daily.getJSONArray("temperature_2m_min");
//            JSONArray weatherCodes = daily.getJSONArray("weathercode");
//            JSONArray precipitation = daily.getJSONArray("precipitation_sum");
//
//            List<WeatherData.DailyForecast> forecastList = new ArrayList<>();
//
//            for (int i = 0; i < dates.length(); i++) {
//                WeatherData.DailyForecast day = new WeatherData.DailyForecast();
//
//                String date    = dates.getString(i);
//                String dayName = getDayName(date);
//
//                int code = weatherCodes.getInt(i);
//
//                day.setDate(dayName);
//                day.setMaxTemp(maxTemps.getDouble(i));
//                day.setMinTemp(minTemps.getDouble(i));
//                day.setWeatherCode(code);
//                day.setPrecipitation(precipitation.getDouble(i));
//                day.setDescription(mapWeatherCodeToDescription(code));
//                day.setIcon(mapWeatherCodeToImageUrl(code));
//
//                forecastList.add(day);
//
//            }
//
//            WeatherData weatherData = new WeatherData();
//            weatherData.setWeeklyForecast(forecastList);
//            return weatherData;
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            return createDefaultWeatherData();
//        }
//    }

    private String getDayName(String dateStr) {
        try {
            java.time.LocalDate date = java.time.LocalDate.parse(dateStr);
            return date.getDayOfWeek()
                    .getDisplayName(java.time.format.TextStyle.SHORT, java.util.Locale.ENGLISH);
        } catch (Exception e) {
            return dateStr;
        }
    }


    @Override
    public WeatherData fetchWeatherForLga(String lgaName) {
        return fetchWeatherForCity(lgaName);
    }

    @Override
    @Cacheable(value = "envDataCache", key = "#state")
    public EnvData fetchEnvironmentalData(double latitude, double longitude) {
        try {

            String dailyUrl = String.format(
                    "https://api.open-meteo.com/v1/forecast" +
                            "?latitude=%.6f&longitude=%.6f" +
                            "&daily=precipitation_sum,temperature_2m_mean,et0_fao_evapotranspiration" +
                            "&past_days=30&forecast_days=1&timezone=auto",
                    latitude, longitude
            );

            String hourlyUrl = String.format(
                    "https://api.open-meteo.com/v1/forecast" +
                            "?latitude=%.6f&longitude=%.6f" +
                            "&hourly=soil_moisture_0_to_1cm" +
                            "&past_days=30&forecast_days=1&timezone=auto",
                    latitude, longitude
            );

            CompletableFuture<String> dailyFuture = CompletableFuture.supplyAsync(() ->
                    restTemplate.getForObject(dailyUrl, String.class));
            CompletableFuture<String> hourlyFuture = CompletableFuture.supplyAsync(() ->
                    restTemplate.getForObject(hourlyUrl, String.class));

            String dailyResponse  = dailyFuture.get();
            String hourlyResponse = hourlyFuture.get();

            System.out.println("Daily URL: " + dailyUrl);
            System.out.println("Hourly URL: " + hourlyUrl);

            if (dailyResponse == null || hourlyResponse == null) {
                return createDefaultEnvData();
            }

            return parseEnvData(dailyResponse, hourlyResponse);

        } catch (Exception e) {
            e.printStackTrace();
            return createDefaultEnvData();
        }
    }

    private EnvData parseEnvData(String dailyResponse, String hourlyResponse) {
        try {
            JSONObject dailyJson = new JSONObject(dailyResponse);
            JSONObject daily     = dailyJson.getJSONObject("daily");
            JSONArray rainfall   = daily.getJSONArray("precipitation_sum");
            JSONArray temp       = daily.getJSONArray("temperature_2m_mean");
            JSONArray et0        = daily.getJSONArray("et0_fao_evapotranspiration");

            JSONObject hourlyJson = new JSONObject(hourlyResponse);
            JSONArray soilHourly  = hourlyJson.getJSONObject("hourly")
                    .getJSONArray("soil_moisture_0_to_1cm");
            JSONArray soil = hourlyToDailyAverage(soilHourly);

            EnvData data = new EnvData();

            data.setTp(getLastValue(rainfall));
            data.setT2m(getLastValue(temp));
            data.setSwvl1(getLastValue(soil));

            data.setRo(Math.max(0, getLastValue(rainfall) - getLastValue(et0)));

            data.setTp7d(sumLastN(rainfall, 7));
            data.setTp14d(sumLastN(rainfall, 14));
            data.setTp30d(sumLastN(rainfall, 30));
            data.setTp7dMax(maxLastN(rainfall, 7));

            data.setRo7d(Math.max(0, sumLastN(rainfall, 7)  - sumLastN(et0, 7)));
            data.setRo14d(Math.max(0, sumLastN(rainfall, 14) - sumLastN(et0, 14)));

            data.setSwvl1_3dChange(getLastValue(soil) - getValueAtOffset(soil, 3));

            return data;

        } catch (JSONException e) {
            throw new RuntimeException("Failed to parse weather response", e);
        }
    }

    private JSONArray hourlyToDailyAverage(JSONArray hourly) throws JSONException {
        JSONArray daily = new JSONArray();
        int totalDays = hourly.length() / 24;
        for (int day = 0; day < totalDays; day++) {
            double sum = 0;
            int count  = 0;
            for (int hour = 0; hour < 24; hour++) {
                int idx = day * 24 + hour;
                if (idx < hourly.length() && !hourly.isNull(idx)) {
                    sum += hourly.getDouble(idx);
                    count++;
                }
            }
            daily.put(count > 0 ? sum / count : 0.0);
        }
        return daily;
    }

    private double getLastValue(JSONArray arr) {
        try {
            for (int i = arr.length() - 1; i >= 0; i--) {
                if (!arr.isNull(i)) return arr.getDouble(i);
            }
            return 0.0;
        } catch (JSONException e) { return 0.0; }
    }

    private double getValueAtOffset(JSONArray arr, int daysBack) {
        try {
            int idx = arr.length() - 1 - daysBack;
            if (idx >= 0 && !arr.isNull(idx)) return arr.getDouble(idx);
            return 0.0;
        } catch (JSONException e) { return 0.0; }
    }

    private double sumLastN(JSONArray arr, int n) {
        try {
            double sum = 0;
            int start = Math.max(0, arr.length() - n);
            for (int i = start; i < arr.length(); i++) {
                if (!arr.isNull(i)) sum += arr.getDouble(i);
            }
            return sum;
        } catch (JSONException e) { return 0.0; }
    }

    private double maxLastN(JSONArray arr, int n) {
        try {
            double max = 0.0;
            int start = Math.max(0, arr.length() - n);
            for (int i = start; i < arr.length(); i++) {
                if (!arr.isNull(i)) max = Math.max(max, arr.getDouble(i));
            }
            return max;
        } catch (JSONException e) { return 0.0; }
    }

    private EnvData createDefaultEnvData() {
        return new EnvData();
    }

    private WeatherData createDefaultWeatherData() {
        WeatherData weatherData = new WeatherData();
        weatherData.setDescription("N/A");
        weatherData.setTemperature(0.0);
        weatherData.setHumidity(0.0);
        weatherData.setImageUrl(null);
        return weatherData;
    }

    private String mapWeatherCodeToDescription(int code) {
        switch (code) {
            case 0: return "Clear sky";
            case 1: case 2: case 3: return "Partly cloudy";
            case 45: case 48: return "Foggy";
            case 51: case 53: case 55: case 56: case 57:
            case 61: case 63: case 65: case 66: case 67: return "Rainy";
            case 71: case 73: case 75: case 77: case 85: case 86: return "Snowy";
            case 80: case 81: case 82: return "Showers";
            case 95: case 96: case 99: return "Thunderstorm";
            default: return "Unknown";
        }
    }

    private String mapWeatherCodeToImageUrl(int code) {
        switch (code) {
           // Clear sky
            case 0: return "https://openweathermap.org/img/wn/01d@2x.png";
            // Partly cloudy
            case 1: case 2: case 3: return "https://openweathermap.org/img/wn/02d@2x.png";
            // Foggy
            case 45: case 48: return "https://openweathermap.org/img/wn/50d@2x.png";
            case 51: case 53: case 55: case 56: case 57:
            // Rainy
            case 61: case 63: case 65: case 66: case 67: return "https://openweathermap.org/img/wn/10d@2x.png";
            // Snowy
            case 71: case 73: case 75: case 77: case 85: case 86: return "https://openweathermap.org/img/wn/13d@2x.png";

            case 80: case 81: case 82: return "https://openweathermap.org/img/wn/09d@2x.png";

            case 95: case 96: case 99: return "https://openweathermap.org/img/wn/11d@2x.png";

            default: return null;
        }
    }
}
