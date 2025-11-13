package com.example.tideguard.Services;

import com.example.tideguard.Models.News;
import com.example.tideguard.Repositories.NewsRepository;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

//@Component
//public class NewsServiceImpl implements NewsService {
//
//    @Autowired
//    private NewsRepository newsRepository;
//
//    @Value("${newsapi.key}")
//    private String apiKey;
//    @Override
//    public List<News> getNews() {
//        List<News> cachedNews = newsRepository.findAll();
//        if (!cachedNews.isEmpty() && cachedNews.get(0).getPublishedAt() != null) {
//            LocalDateTime lastUpdate = LocalDateTime.parse(cachedNews.get(0).getPublishedAt());
//            if (lastUpdate.isAfter(LocalDateTime.now().minusHours(24))) { // Changed to 24 hours
//                return cachedNews;
//            }
//        }
//
//        String url = "https://newsapi.org/v2/everything?q=flood+nigeria&apiKey=" + apiKey + "&language=en";
//        RestTemplate restTemplate = new RestTemplate();
//        NewsAPIResponse response = restTemplate.getForObject(url, NewsAPIResponse.class);
//
//        if (response != null && response.getArticles() != null) {
//            newsRepository.deleteAll();
//            List<News> newsList = response.getArticles().stream()
//                    .map(article -> News.builder()
//                            .title(article.getTitle())
//                            .description(article.getDescription())
//                            .url(article.getUrl())
//                            .publishedAt(LocalDateTime.now().toString()) // Use current time as placeholder
//                            .build())
//                    .toList();
//            return newsRepository.saveAll(newsList);
//        }
//        return Collections.emptyList();
//    }
//}
//
//class NewsAPIResponse {
//    private List<Article> articles;
//
//    public List<Article> getArticles() {
//        return articles;
//    }
//
//    public void setArticles(List<Article> articles) {
//        this.articles = articles;
//    }
//}
//
//@Getter
//class Article {
//    private String title;
//    private String description;
//    private String url;
//
//}



@Component
public class NewsServiceImpl implements NewsService {

    private final NewsRepository newsRepository;
    private final RestTemplate restTemplate;

    @Value("${newsapi.key}")
    private String apiKey;

    public NewsServiceImpl(NewsRepository newsRepository, RestTemplate restTemplate) {
        this.newsRepository = newsRepository;
        this.restTemplate = restTemplate;
    }

    @Override
    public List<News> getNews() {
        List<News> cachedNews = newsRepository.findAll();
        if (!cachedNews.isEmpty()) {
            // Uncomment and adjust if you want to enforce 24-hour caching
            // LocalDateTime lastUpdate = LocalDateTime.parse(cachedNews.get(0).getPublishedAt());
            // if (lastUpdate.isAfter(LocalDateTime.now().minusHours(24))) {
            return cachedNews;
            // }
        }

        // Fallback: Fetch from API if cache is empty or outdated
        String url = "https://newsapi.org/v2/everything?q=flood+nigeria&apiKey=" + apiKey + "&language=en";
        String response = restTemplate.getForObject(url, String.class);
        List<News> freshNews = parseAndSaveNews(response);
        return freshNews != null ? freshNews : Collections.emptyList();
    }

    private List<News> parseAndSaveNews(String jsonResponse) {
        try {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(jsonResponse);
            List<News> newsList = new ArrayList<>();
            for (JsonNode article : root.path("articles")) {
                News news = new News();
                news.setTitle(article.path("title").asText());
                news.setPublishedAt(article.path("publishedAt").asText());
                newsList.add(news);
            }
            newsRepository.saveAll(newsList);
            return newsList;
        } catch (Exception e) {
            return null;
        }
    }
}

