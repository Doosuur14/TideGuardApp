package com.example.tideguard.Controllers;


import com.example.tideguard.Models.Shelters;
import com.example.tideguard.Services.ShelterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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
}
