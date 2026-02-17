package com.example.tideguard.Services;


import com.example.tideguard.Models.EnvData;
import com.example.tideguard.Models.User;
import com.example.tideguard.Models.WeatherData;
import com.example.tideguard.Repositories.UserRepository;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;


import java.util.Optional;

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


    @Override
    public WeatherData fetchWeatherForCity(String city) {
        Optional<User> userOptional = userRepository.findUserByCity(city);
        if (userOptional.isEmpty()) {
            System.out.println("No user found with city: " + city);
        }
        String geocodeUrl = "https://nominatim.openstreetmap.org/search?format=json&q=" + city.replace(" ", "+");
        String geocodeResponse = restTemplate.getForObject(geocodeUrl, String.class);
        if (geocodeResponse == null) {
            return createDefaultWeatherData();
        }

        try {

            JSONArray geocodeArray = new JSONArray(geocodeResponse);
            if (geocodeArray.length() == 0) {
                return createDefaultWeatherData();
            }
            JSONObject geocodeResult = geocodeArray.getJSONObject(0);
            double latitude = geocodeResult.getDouble("lat");
            double longitude = geocodeResult.getDouble("lon");

            String weatherUrl = String.format("https://api.open-meteo.com/v1/forecast?latitude=%.6f&longitude=%.6f&current_weather=true&hourly=relativehumidity_2m", latitude, longitude);
            String weatherResponse = restTemplate.getForObject(weatherUrl, String.class);
            System.out.println("Weather Response: " + weatherResponse); // Debug
            if (weatherResponse == null) {
                return createDefaultWeatherData();
            }

            JSONObject weatherJson = new JSONObject(weatherResponse);
            JSONObject currentWeather = weatherJson.getJSONObject("current_weather");
            double temperature = currentWeather.getDouble("temperature");
            int weatherCode = currentWeather.getInt("weathercode");

            double humidity = 0.0;
            if (weatherJson.has("hourly")) {
                JSONObject hourly = weatherJson.getJSONObject("hourly");
                if (hourly.has("relativehumidity_2m")) {
                    JSONArray humidityArray = hourly.getJSONArray("relativehumidity_2m");
                    humidity = humidityArray.length() > 0 ? humidityArray.getDouble(0) : 0.0;
                }
            }


            String description = mapWeatherCodeToDescription(weatherCode);
            String imageUrl = mapWeatherCodeToImageUrl(weatherCode);


            WeatherData weatherData = new WeatherData();
            weatherData.setDescription(description);
            weatherData.setTemperature(temperature);
            weatherData.setHumidity(humidity);
            weatherData.setImageUrl(imageUrl);
            return weatherData;

        } catch (Exception e) {
            e.printStackTrace();
            return createDefaultWeatherData();
        }
    }

    @Override
    public WeatherData fetchWeatherForLga(String lgaName) {
        return fetchWeatherForCity(lgaName);
    }


    @Override
    @Cacheable(value = "envDataCache", key = "#lgaName")
    public EnvData fetchEnvironmentalData(double latitude, double longitude) {

        try {

//            String geocodeUrl = "https://nominatim.openstreetmap.org/search?format=json&q=" + lgaName.replace(" ", "+");
//            String geocodeResponse = restTemplate.getForObject(geocodeUrl, String.class);
//
//            if (geocodeResponse == null || geocodeResponse.trim().isEmpty()) {
//                return createDefaultEnvData();
//            }
//
//            JSONArray geocodeArray = new JSONArray(geocodeResponse);
//            if (geocodeArray.length() == 0) {
//                return createDefaultEnvData();
//            }
//
//            JSONObject geocodeResult = geocodeArray.getJSONObject(0);
//            double latitude = geocodeResult.getDouble("lat");
//            double longitude = geocodeResult.getDouble("lon");

            LocalDate end = LocalDate.now();
            LocalDate start = end.minusDays(6);

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

            String startDate = start.format(formatter);
            String endDate = end.format(formatter);


            // Fetch comprehensive weather data with historical data
            String weatherUrl = String.format(
                    "https://archive-api.open-meteo.com/v1/era5" +
                            "?latitude=%.6f" +
                            "&longitude=%.6f" +
                            "&start_date=%s" +
                            "&end_date=%s" +
                            "&daily=precipitation_sum,temperature_2m_mean,evapotranspiration_sum,runoff_sum,soil_moisture_0_7cm_mean" +
                            "&timezone=auto",
                    latitude,
                    longitude,
                    startDate,
                    endDate
            );


            String weatherResponse = restTemplate.getForObject(weatherUrl, String.class);
            if (weatherResponse == null || weatherResponse.trim().isEmpty()) {
                return createDefaultEnvData();
            }

            return parseEnvData(weatherResponse);

        } catch (Exception e) {
            e.printStackTrace();
            return createDefaultEnvData();
        }
    }

    private EnvData parseEnvData(String weatherResponse) {
        JSONObject json = new JSONObject(weatherResponse);
        JSONObject daily = json.getJSONObject("daily");

        JSONArray rainfall = daily.getJSONArray("precipitation_sum");
        JSONArray temp = daily.getJSONArray("temperature_2m_mean");
        JSONArray evap = daily.getJSONArray("evapotranspiration_sum");
        JSONArray runoff = daily.getJSONArray("runoff_sum");
        JSONArray soil = daily.getJSONArray("soil_moisture_0_7cm_mean");

        EnvData data = new EnvData();

        // Rainfall
        data.setRainfall1d(rainfall.getDouble(rainfall.length() - 1));
        data.setRainfall3dAvg(avgLastN(rainfall, 3));
        data.setRainfall7dAvg(avgLastN(rainfall, 7));
        data.setRainfall7dMax(maxLastN(rainfall, 7));
        data.setRainfall7dCumulative(sumLastN(rainfall, 7));

        // Soil Moisture
        data.setSoilMoistureCurrent(soil.getDouble(soil.length() - 1));
        data.setSoilMoisture7dAvg(avgLastN(soil, 7));

        // Runoff
        data.setRunoffTotal7d(sumLastN(runoff, 7));
        data.setSurfaceRunoff7d(sumLastN(runoff, 7)); // if separate surface variable not available

        // Temperature
        data.setTemperatureCurrent(temp.getDouble(temp.length() - 1));
        data.setTemperature7dAvg(avgLastN(temp, 7));

        // Evaporation
        data.setEvaporation7d(sumLastN(evap, 7));

        return data;
    }

    private double avgLastN(JSONArray arr, int n) {
        return sumLastN(arr, n) / Math.min(n, arr.length());
    }

    private double maxLastN(JSONArray arr, int n) {
        double max = Double.MIN_VALUE;
        int start = Math.max(0, arr.length() - n);
        for (int i = start; i < arr.length(); i++) {
            max = Math.max(max, arr.getDouble(i));
        }
        return max;
    }

    private double sumLastN(JSONArray arr, int n) {
        double sum = 0;
        int start = Math.max(0, arr.length() - n);
        for (int i = start; i < arr.length(); i++) {
            sum += arr.getDouble(i);
        }
        return sum;
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
            // Showers
            case 80: case 81: case 82: return "https://openweathermap.org/img/wn/09d@2x.png";
            // Thunderstorm
            case 95: case 96: case 99: return "https://openweathermap.org/img/wn/11d@2x.png";
            default: return null;
        }
    }
}
