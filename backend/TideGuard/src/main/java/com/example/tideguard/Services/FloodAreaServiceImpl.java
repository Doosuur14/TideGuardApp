package com.example.tideguard.Services;


import com.example.tideguard.Models.FloodArea;
import com.example.tideguard.Models.User;
import com.example.tideguard.Repositories.FloodRepository;
import com.example.tideguard.Repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class FloodAreaServiceImpl implements FloodAreaService {
    @Autowired
    private final UserRepository userRepository;

    @Autowired
    private final FloodRepository floodRepository;

    public FloodAreaServiceImpl(UserRepository userRepository, FloodRepository floodRepository) {
        this.userRepository = userRepository;
        this.floodRepository = floodRepository;
    }


    @Override
    public Optional<FloodArea> findByCity(String city) {
        return floodRepository.findByCity(city);
    }
}
