package com.example.tideguard.Controllers;

import com.example.tideguard.Models.News;
import com.example.tideguard.Repositories.NewsRepository;
import com.example.tideguard.Services.NewsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class NewsController {

    @Autowired
    private NewsService newsService;

    @Autowired
    private NewsRepository newsRepository;

    @GetMapping("/news")
    public ResponseEntity<List<News>> getNews() {
        List<News> news = newsService.getNews();
        return ResponseEntity.ok(news);
    }

    @GetMapping("/news/clear")
    public ResponseEntity<String> clearNews() {
        newsRepository.deleteAll();
        return ResponseEntity.ok("News cleared successfully");
    }
}
