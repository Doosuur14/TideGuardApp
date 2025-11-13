package com.example.tideguard.Services;

import com.example.tideguard.DTO.UserDto;
import com.example.tideguard.Models.User;

public interface RegisterService {
    UserDto createUser(User user);
}
