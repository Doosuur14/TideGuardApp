package com.example.tideguard.Services;

import com.example.tideguard.Controllers.EvacuationController;
import com.example.tideguard.Models.Evacuation;

public interface EvacuationService {
    Evacuation getEvacuationData(String city);
}
