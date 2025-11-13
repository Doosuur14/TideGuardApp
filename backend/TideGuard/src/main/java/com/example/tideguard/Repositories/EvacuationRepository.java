package com.example.tideguard.Repositories;

import com.example.tideguard.Models.Evacuation;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface EvacuationRepository extends JpaRepository<Evacuation, Long> {
    Optional<Evacuation> findByCity(String city);
}
