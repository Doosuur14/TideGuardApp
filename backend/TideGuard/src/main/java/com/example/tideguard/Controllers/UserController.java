package com.example.tideguard.Controllers;


import com.example.tideguard.DTO.LoginRequest;
import com.example.tideguard.DTO.UserDto;
import com.example.tideguard.Models.User;
import com.example.tideguard.Services.FileService;
import com.example.tideguard.Services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Optional;

@RestController
@RequestMapping("/api")

public class UserController {
    @Autowired
    private final UserService userService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private FileService fileService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("register")
    public ResponseEntity<UserDto> createUser(@RequestBody User user) {
        try {
            System.out.println("Received user: " + user);
            UserDto savedUser = userService.registerUser(user);
            System.out.println("Saved user DTO: " + savedUser);
            return ResponseEntity.ok(savedUser);
        } catch (Exception e) {
            System.err.println("Error in createUser: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @PostMapping("/login")
    public ResponseEntity<UserDto> login(@RequestBody LoginRequest loginRequest) {
        Optional<User> userOpt = userService.findByEmail(loginRequest.getEmail());
        if (userOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        User user = userOpt.get();
        if (!passwordEncoder.matches(loginRequest.getPassword(), user.getPassword())) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        return ResponseEntity.ok(UserDto.from(user));
    }

    @GetMapping("/userProfile/{id}")
    public ResponseEntity<User> getUser(@PathVariable Long id) {
        User user = userService.getUserById(id);
        System.out.println("the user profile to be displayed is " + user);
        return ResponseEntity.ok(user);
    }


    @DeleteMapping("/delete")
    @Transactional
    public ResponseEntity<Void> deleteAccount(@RequestHeader("email") String email) {
        Optional<User> user = userService.findByEmail(email);
        if ((user.isPresent())) {
            System.out.println("The user to be deleted is present" + user);
            userService.deleteAccount(user.get().getUserId());
            return ResponseEntity.ok().build();
        } else {
            System.out.println("User can't be deleted because there is no user found!");
            return null;
        }
    }

    @PostMapping("/logout")
    public ResponseEntity<Void> logout(@RequestHeader("email") String email) {
        Optional<User> user = userService.findByEmail(email);
        if (user.isPresent()) {
            System.out.println("the user to be logged out is present" + user);
            userService.logout(email);
            return ResponseEntity.ok().build();
        } else {
            System.out.println("User can't be logged out because there is no user found!");
            return ResponseEntity.notFound().build();
        }
    }


    @PostMapping("/profile")
    public ResponseEntity<User> updateProfile(
            @RequestHeader("email") String email,
            @RequestParam("firstName") String firstName,
            @RequestParam("lastName") String lastName,
            @RequestParam("city") String city,
            @RequestParam(value = "profileImage", required = false) MultipartFile profileImage) throws IOException {
        Optional<User> userOpt = userService.findByEmail(email);
        if (userOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        User user = userOpt.get();
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setCity(city);

        if (profileImage != null && !profileImage.isEmpty()) {
            String imageUrl = fileService.storeFile(profileImage, email);
            user.setProfileImageURL(imageUrl);
        }

        User updatedUser = userService.updateProfile(email, user);
        return ResponseEntity.ok(updatedUser);
    }

    @GetMapping("/files/{fileName}")
    public ResponseEntity<byte[]> serveFile(@PathVariable String fileName) {
        try {
            byte[] fileContent = fileService.getFile(fileName);
            return ResponseEntity.ok()
                    .header("Content-Disposition", "inline; filename=" + fileName)
                    .body(fileContent);
        } catch (IOException e) {
            System.out.println("Error serving file " + fileName + ": " + e.getMessage());
            return ResponseEntity.notFound().build();
        }
    }

}
