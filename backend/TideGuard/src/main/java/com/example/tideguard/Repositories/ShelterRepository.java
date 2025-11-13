package com.example.tideguard.Repositories;

import com.example.tideguard.Models.Shelters;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ShelterRepository extends JpaRepository<Shelters, Long> {
    List<Shelters> findByCity(String city);
}
