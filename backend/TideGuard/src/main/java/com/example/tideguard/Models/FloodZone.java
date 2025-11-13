package com.example.tideguard.Models;

import com.example.tideguard.Converter.CoordinateConverter;
import lombok.Getter;

import javax.persistence.Convert;
import javax.persistence.ElementCollection;
import javax.persistence.Embeddable;
import java.util.List;

@Embeddable
@Getter
public class FloodZone {

    @Convert(converter = CoordinateConverter.class)
    private List<Coordinate> coordinates;
}
