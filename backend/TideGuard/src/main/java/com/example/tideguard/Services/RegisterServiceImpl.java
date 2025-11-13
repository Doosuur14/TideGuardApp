package com.example.tideguard.Services;


import com.example.tideguard.DTO.UserDto;
import com.example.tideguard.Models.User;
import com.example.tideguard.Repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class RegisterServiceImpl implements RegisterService {

    @Autowired
    private PasswordEncoder passwordEncoder;
    @Autowired
    private UserRepository userRepository;

    @Override
    @Transactional
    public UserDto createUser(User user) {
        if (userRepository.findByEmail(user.getEmail()).isPresent()) {
            throw new RuntimeException("A user with this email already exists");
        }
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        System.out.println("Saving user: " + user);
        User savedUser = userRepository.save(user);
        System.out.println("Saved user: " + savedUser);
        return UserDto.from(savedUser);
    }
}
