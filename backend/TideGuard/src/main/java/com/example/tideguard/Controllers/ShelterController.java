package com.example.tideguard.Controllers;


import com.example.tideguard.Models.Shelters;
import com.example.tideguard.Services.ShelterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/shelters")
public class ShelterController {

    @Autowired
    private ShelterService shelterService;

    @GetMapping("/{city}")
    public List<Shelters> getShelters(@PathVariable String city) {
        return shelterService.getSheltersByCity(city);
    }
}
