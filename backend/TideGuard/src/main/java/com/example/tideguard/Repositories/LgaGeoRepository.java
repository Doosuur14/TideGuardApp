package com.example.tideguard.Repositories;

import com.example.tideguard.DTO.LgaWithEnvDTO;
import com.example.tideguard.Models.LgaGeo;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface LgaGeoRepository extends JpaRepository<LgaGeo, String> {
    List<LgaGeo> findByState(String state);
}
