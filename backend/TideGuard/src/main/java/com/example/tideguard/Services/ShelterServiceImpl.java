package com.example.tideguard.Services;

import com.example.tideguard.Models.Shelters;
import com.example.tideguard.Repositories.ShelterRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ShelterServiceImpl implements ShelterService {

    @Autowired
    private ShelterRepository shelterRepository;

    @Override
    public List<Shelters> getSheltersByCity(String city) {
        return shelterRepository.findByCity(city);
    }
}

