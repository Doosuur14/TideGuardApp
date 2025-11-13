package com.example.tideguard.Controllers;


import com.example.tideguard.Models.Evacuation;
import com.example.tideguard.Services.EvacuationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class EvacuationController {
    @Autowired
    private EvacuationService evacuationService;


    public EvacuationController(EvacuationService evacuationService) {
        this.evacuationService = evacuationService;
    }

    @GetMapping("/evacuation/{city}")
    public ResponseEntity<Evacuation> getEvacuationData(@PathVariable String city) {
        Evacuation evacuation = evacuationService.getEvacuationData(city);
        if (evacuation.getCity() == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(evacuation);
    }
}
