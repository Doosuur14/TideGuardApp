package com.example.tideguard.DTO;

import lombok.Data;

@Data
public class LoginRequest {
    private String email;
    private String password;
}
