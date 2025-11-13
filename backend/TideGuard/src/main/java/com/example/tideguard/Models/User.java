package com.example.tideguard.Models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "users")

public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)

    private Long userId;
    private String firstName;
    private String lastName;
    private String email;
    private String password;
    private String city;
    private String profileImageURL;
}
