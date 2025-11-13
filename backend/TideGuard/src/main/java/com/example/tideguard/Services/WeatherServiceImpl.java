package com.example.tideguard.Services;


import com.example.tideguard.Models.User;
import com.example.tideguard.Models.WeatherData;
import com.example.tideguard.Repositories.UserRepository;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
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

            // Step 3: Fetch weather from Open-Meteo
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

            // Step 4: Map weather code to description and image URL
            String description = mapWeatherCodeToDescription(weatherCode);
            String imageUrl = mapWeatherCodeToImageUrl(weatherCode);

            // Step 5: Return the weather data
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
