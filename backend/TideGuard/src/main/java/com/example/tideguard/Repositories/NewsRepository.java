package com.example.tideguard.Repositories;

import com.example.tideguard.Models.News;
import org.springframework.data.jpa.repository.JpaRepository;

public interface NewsRepository extends JpaRepository<News, Long> {
}
