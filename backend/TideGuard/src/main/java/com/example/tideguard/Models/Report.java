package com.example.tideguard.Models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Entity
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
@Table(name = "reports")
public class Report {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String photoUrl;
    private String description;
    private String fileName;

    @ManyToOne
    @JoinColumn(name = "user_id", referencedColumnName ="userId")
    private User user;
}