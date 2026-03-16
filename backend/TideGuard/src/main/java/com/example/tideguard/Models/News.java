package com.example.tideguard.Models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalDateTime;


//@Entity
//@Data
//@Builder
//@AllArgsConstructor
//@NoArgsConstructor
//public class News {
//    @Id
//    @GeneratedValue(strategy = GenerationType.IDENTITY)
//    private Long id;
//
//    @Column(length = 1000)
//    private String title;
//
//    @Column(length = 2000)
//    private String description;
//
//    @Column(length = 1000)
//    private String url;
//
//    private String publishedAt;
//}



@Entity
@Table(name = "news")
@Data
public class News {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(columnDefinition = "TEXT")
    private String url;

    private String urlToImage;
    private String source;
    private String publishedAt;
    private LocalDateTime fetchedAt;
}