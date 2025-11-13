package com.example.tideguard.Services;

import com.example.tideguard.Controllers.EvacuationController;
import com.example.tideguard.Models.Evacuation;
import com.example.tideguard.Repositories.EvacuationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class EvacuationServiceImpl implements EvacuationService {
    @Autowired
    private  EvacuationRepository evacuationRepository;

    @Override
    public Evacuation getEvacuationData(String city) {
        Optional<Evacuation> evacuation = evacuationRepository.findByCity(city);
        return evacuation.orElse(new Evacuation());
    }
}
