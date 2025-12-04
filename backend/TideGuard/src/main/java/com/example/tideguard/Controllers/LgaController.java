package com.example.tideguard.Controllers;

import com.example.tideguard.DTO.LgaWithEnvDTO;
import com.example.tideguard.Services.LgaGeoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;


@RestController
public class LgaController {

    @Autowired
    private LgaGeoService lgaGeoService;

    @GetMapping("/lgas/{state}")
    public ResponseEntity<List<LgaWithEnvDTO>> getLgas(@PathVariable String state) {
        List<LgaWithEnvDTO> lgas =lgaGeoService.getLgasWithEnvByState(state);
        System.out.println("🚀 API CALL: /api/lgas/state/" + state);
        return ResponseEntity.ok(lgas);
    }


    @GetMapping("/lgas/all")
    public List<LgaWithEnvDTO> getAll() {
        return lgaGeoService.getAllLgas();
    }

    @GetMapping(value = "/lgas/geojson", produces = "application/json")
    public ResponseEntity<Resource> getAllLgaGeoJson() {
        Resource resource = new ClassPathResource("nigeria_lga.geojson");
        if (!resource.exists()) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(resource);
    }
}
