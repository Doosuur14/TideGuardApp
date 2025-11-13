package com.example.tideguard.Repositories;

import com.example.tideguard.Models.FloodArea;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface FloodRepository extends JpaRepository<FloodArea, String> {

    Optional<FloodArea> findByCity(String city);

}
