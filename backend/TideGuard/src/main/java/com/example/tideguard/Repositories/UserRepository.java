package com.example.tideguard.Repositories;

import com.example.tideguard.Models.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long>  {
    User findByUserId(Long userId);
    Optional<User>  findByEmail(String email);
    Optional<User> findUserByCity(String city);
    void deleteUserByUserId(Long userId);
}
