package com.example.tideguard.Services;

import com.example.tideguard.Models.News;
import com.example.tideguard.Repositories.NewsRepository;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

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
            LocalDateTime lastFetched = cachedNews.get(0).getFetchedAt();
            if (lastFetched != null && lastFetched.isAfter(LocalDateTime.now().minusHours(6))) {
                return cachedNews;
            }
        }

        newsRepository.deleteAll();

        String url = "https://newsapi.org/v2/everything"
                + "?q=\"Nigeria\" AND (\"flood\" OR \"flooding\" OR \"climate change\" OR \"rainfall\" OR \"natural disaster\")"
                + "&sortBy=publishedAt"
                + "&language=en"
                + "&pageSize=100"
                + "&apiKey=" + apiKey;

        System.out.println("Fetching from NewsAPI: " + url);

        try {
            String response = restTemplate.getForObject(url, String.class);
            System.out.println("NewsAPI response: " + response); // ← see what came back
            List<News> freshNews = parseAndSaveNews(response);
            System.out.println("Parsed articles: " + (freshNews != null ? freshNews.size() : "null"));
            return freshNews != null && !freshNews.isEmpty() ? freshNews : cachedNews;
        } catch (Exception e) {
            System.out.println("NewsAPI fetch failed: " + e.getMessage()); // ← see the actual error
            return cachedNews;
        }
    }

    private List<News> parseAndSaveNews(String jsonResponse) {
        try {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(jsonResponse);
            List<News> newsList = new ArrayList<>();

            for (JsonNode article : root.path("articles")) {
                String title = article.path("title").asText();
                String description = article.path("description").asText();

                if (title.equals("[Removed]") || title.isBlank()) continue;
                if (description.equals("[Removed]")) continue;

                boolean mentionsNigeria = title.toLowerCase().contains("nigeria")
                        || description.toLowerCase().contains("nigeria");

                if (!mentionsNigeria) continue;

                News news = new News();
                news.setTitle(title);
                news.setDescription(description);
                news.setUrl(article.path("url").asText());
                news.setUrlToImage(article.path("urlToImage").asText());
                news.setSource(article.path("source").path("name").asText());
                news.setPublishedAt(article.path("publishedAt").asText());
                news.setFetchedAt(LocalDateTime.now());

                newsList.add(news);
            }

            newsRepository.saveAll(newsList);
            return newsList;
        } catch (Exception e) {
            return null;
        }
    }














}