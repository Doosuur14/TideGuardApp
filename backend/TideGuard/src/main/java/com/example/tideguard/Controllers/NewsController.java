package com.example.tideguard.Controllers;

import com.example.tideguard.Models.News;
import com.example.tideguard.Repositories.NewsRepository;
import com.example.tideguard.Services.NewsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.CacheControl;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import java.net.URI;
import java.util.List;
import java.util.concurrent.TimeUnit;

@RestController
public class NewsController {

    @Autowired
    private NewsService newsService;

    @Autowired
    private NewsRepository newsRepository;



    @Autowired
    private RestTemplate restTemplate;

    private static final List<String> ALLOWED_HOSTS = List.of(
            "cdn.punchng.com",
            "res.cloudinary.com",
            "media.premiumtimesng.com",
            "environment.yale.edu"
    );

    @GetMapping("/news/image")
    public ResponseEntity<byte[]> proxyImage(@RequestParam String url) {
        try {
            URI uri = new URI(url);
            String host = uri.getHost();
            boolean allowed = host != null &&
                    ALLOWED_HOSTS.stream().anyMatch(host::endsWith);
            if (!allowed) return ResponseEntity.badRequest().build();

            ResponseEntity<byte[]> upstream =
                    restTemplate.getForEntity(url, byte[].class);

            String contentType = "image/jpeg";
            if (url.endsWith(".webp")) contentType = "image/webp";
            else if (url.endsWith(".png")) contentType = "image/png";

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))
                    .cacheControl(CacheControl.maxAge(24, TimeUnit.HOURS))
                    .body(upstream.getBody());

        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }








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
