package com.example.tideguard.Services;

import com.example.tideguard.DTO.UserDto;
import com.example.tideguard.Models.User;
import com.example.tideguard.Repositories.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class UserServiceImpl implements UserService {

    private static final Logger logger = LoggerFactory.getLogger(UserServiceImpl.class);

    @Autowired
    private final UserRepository userRepository;
    @Autowired
    private final RegisterService registerService;

    public UserServiceImpl(UserRepository userRepository, RegisterService registerService) {
        this.userRepository = userRepository;
        this.registerService = registerService;
    }

    @Override
    public User getUserById(Long id) {
        return userRepository.findByUserId(id);
//                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    @Override
    public Optional<User> findByEmail(String email) {
        Optional<User> user = userRepository.findByEmail(email);
        if (user.isPresent()) {
            return user;
        } else {
            logger.error("User not found with this email" + email);
            return Optional.empty();
        }
    }

    @Override
    public UserDto registerUser(User user) {
        System.out.println("In UserServiceImpl, registering user: " + user);
        return registerService.createUser(user);
    }

    @Override
    public Optional<User> findUserByCity(String city) {
        Optional<User> user = userRepository.findUserByCity(city);
        if (user.isPresent()) {
            return user;
        } else {
            logger.error("User not found with this city name");
            return Optional.empty();
        }
    }


    public User updateProfile(String email, User updatedUser) {
        return userRepository.findByEmail(email).map(user -> {
            user.setFirstName(updatedUser.getFirstName());
            user.setLastName(updatedUser.getLastName());
            user.setCity(updatedUser.getCity());
            if (updatedUser.getProfileImageURL() != null) {
                user.setProfileImageURL(updatedUser.getProfileImageURL());
            }
            return userRepository.save(user);
        }).orElse(null);
    }

    @Override
    public void deleteAccount(Long userId) {
        logger.info("Deleting article with ID: {}", userId);
        userRepository.deleteUserByUserId(userId);
        logger.info("Deletion of user successful: {}", userId);
    }

    @Override
    public void logout(String email) {
        logger.info("Logging out user with email: {}", email);
    }

}
