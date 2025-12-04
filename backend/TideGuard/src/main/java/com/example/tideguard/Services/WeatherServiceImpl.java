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
    public EnvData fetchEnvironmentalData(String lgaName) {
        try {

            String geocodeUrl = "https://nominatim.openstreetmap.org/search?format=json&q=" + lgaName.replace(" ", "+");
            String geocodeResponse = restTemplate.getForObject(geocodeUrl, String.class);

            if (geocodeResponse == null || geocodeResponse.trim().isEmpty()) {
                return createDefaultEnvData();
            }

            JSONArray geocodeArray = new JSONArray(geocodeResponse);
            if (geocodeArray.length() == 0) {
                return createDefaultEnvData();
            }

            JSONObject geocodeResult = geocodeArray.getJSONObject(0);
            double latitude = geocodeResult.getDouble("lat");
            double longitude = geocodeResult.getDouble("lon");

            // Fetch comprehensive weather data with historical data
            String weatherUrl = String.format(
                    "https://api.open-meteo.com/v1/forecast?latitude=%.6f&longitude=%.6f&current_weather=true&hourly=precipitation&daily=precipitation_sum&past_days=7&timezone=auto",
                    latitude, longitude
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
        JSONObject weatherJson = new JSONObject(weatherResponse);
        EnvData data = new EnvData();

        try {

            JSONObject currentWeather = weatherJson.getJSONObject("current_weather");
            data.setAirTemp(currentWeather.getDouble("temperature"));


            if (weatherJson.has("daily")) {
                JSONObject daily = weatherJson.getJSONObject("daily");
                JSONArray precipitationSum = daily.getJSONArray("precipitation_sum");

                data.setRainfall(getCurrentRainfall(weatherJson));
                data.setRainfallLast3Days(sumLastNDays(precipitationSum, 3));
                data.setRainfallLast7Days(sumLastNDays(precipitationSum, 7));
            } else {
                setDefaultRainfallData(data);
            }


            data.setRunoff(calculateRunoff(data.getRainfall(), data.getRainfallLast7Days()));
            data.setRunoffMaxLast3Days(calculateMaxRunoff(data.getRainfallLast3Days()));
            data.setSoilMoisture(calculateSoilMoisture(data.getRainfallLast7Days(), data.getAirTemp()));
            data.setSoilMoistureChange7Days(calculateSoilMoistureChange(data));
            data.setEvaporation(calculateEvaporation(data.getAirTemp(), data.getRainfall()));

        } catch (Exception e) {
            e.printStackTrace();
            return createDefaultEnvData();
        }

        return data;
    }

    private double getCurrentRainfall(JSONObject weatherJson) {
        try {
            if (weatherJson.has("hourly")) {
                JSONObject hourly = weatherJson.getJSONObject("hourly");
                JSONArray precipitation = hourly.getJSONArray("precipitation");
                // Sum last 6 hours of precipitation
                return sumLastNHours(precipitation, 6);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    private double sumLastNHours(JSONArray hourlyData, int hours) {
        double sum = 0;
        int actualHours = Math.min(hours, hourlyData.length());
        for (int i = 0; i < actualHours; i++) {
            sum += hourlyData.getDouble(i);
        }
        return sum;
    }

    private double sumLastNDays(JSONArray dailyData, int days) {
        double sum = 0;
        int actualDays = Math.min(days, dailyData.length());
        for (int i = 0; i < actualDays; i++) {
            sum += dailyData.getDouble(i);
        }
        return sum;
    }

    private double calculateRunoff(double currentRainfall, double rainfall7Days) {
        double baseRunoff = currentRainfall * 0.3;
        double antecedentRunoff = rainfall7Days > 50 ? currentRainfall * 0.2 : 0;
        return Math.max(0, baseRunoff + antecedentRunoff);
    }

    private double calculateMaxRunoff(double rainfall3Days) {
        return rainfall3Days * 0.6;
    }

    private double calculateSoilMoisture(double rainfall7Days, double temperature) {
        double baseMoisture = Math.min(100, rainfall7Days * 2);
        double tempEffect = temperature > 30 ? -15 : 0;
        return Math.max(0, Math.min(100, baseMoisture + tempEffect + 30));
    }

    private double calculateSoilMoistureChange(EnvData data) {
        return data.getRainfallLast7Days() - data.getEvaporation();
    }

    private double calculateEvaporation(double temperature, double rainfall) {

        double baseEvap = temperature * 0.1;
        return rainfall > 0 ? baseEvap * 0.5 : baseEvap;
    }

    private void setDefaultRainfallData(EnvData data) {
        data.setRainfall(0);
        data.setRainfallLast3Days(0);
        data.setRainfallLast7Days(0);
    }

    private EnvData createDefaultEnvData() {
        return new EnvData(0, 0, 0, 0, 0, 50, 0, 25, 0);
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
