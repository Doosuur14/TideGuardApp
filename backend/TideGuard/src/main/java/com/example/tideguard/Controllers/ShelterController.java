package com.example.tideguard.Controllers;


import com.example.tideguard.DTO.ShelterDTO;
import com.example.tideguard.Models.Shelters;
import com.example.tideguard.Services.ShelterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
public class ShelterController {

    @Autowired
    private ShelterService shelterService;

    @GetMapping("/shelters/{city}")
    public List<Shelters> getSheltersByCity(@PathVariable String city) {
        return shelterService.getSheltersByState(city);
    }

    @GetMapping("/shelters")
    public ResponseEntity<List<Shelters>> getAllShelters() {
        return ResponseEntity.ok(shelterService.getAllShelters());
    }

    @GetMapping("/shelters/nearest")
    public ResponseEntity<List<ShelterDTO>> getNearestShelters(
            @RequestParam Double latitude,
            @RequestParam Double longitude,
            @RequestParam(required = false, defaultValue = "10") Integer limit) {

        List<ShelterDTO> shelters = shelterService.findNearestShelters(latitude, longitude, limit);
        return ResponseEntity.ok(shelters);
    }
}
