package com.example.tideguard.Services;

import com.example.tideguard.DTO.UserDto;
import com.example.tideguard.Models.User;

import java.util.Optional;

public interface UserService {
    User getUserById(Long id);
    Optional<User> findByEmail(String email);
    UserDto registerUser(User user);

    Optional<User> findUserByCity(String city);

    User updateProfile(String email, User updatedUser);

    void deleteAccount(Long userId);

    void logout(String email);

}
