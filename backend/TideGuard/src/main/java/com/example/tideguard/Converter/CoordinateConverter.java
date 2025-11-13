package com.example.tideguard.Converter;


import com.example.tideguard.Models.Coordinate;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.persistence.AttributeConverter;
import javax.persistence.Converter;
import java.util.List;

@Converter
public class CoordinateConverter implements AttributeConverter<List<Coordinate>, String> {
    private static final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public String convertToDatabaseColumn(List<Coordinate> coordinates) {
        try {
            return objectMapper.writeValueAsString(coordinates);
        } catch (JsonProcessingException e) {
            throw new IllegalArgumentException("Error converting coordinates to JSON", e);
        }
    }

    @Override
    public List<Coordinate> convertToEntityAttribute(String json) {
        try {
            return objectMapper.readValue(json, new TypeReference<List<Coordinate>>() {});
        } catch (JsonProcessingException e) {
            throw new IllegalArgumentException("Error converting JSON to coordinates", e);
        }
    }

}
