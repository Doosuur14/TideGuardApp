package com.example.tideguard.Controllers;


import com.example.tideguard.Models.FAQ;
import com.example.tideguard.Services.EvacuationService;
import com.example.tideguard.Services.FAQService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class FAQController {
    @Autowired
    private FAQService faqService;

    public FAQController(FAQService faqService) {
        this.faqService = faqService;
    }

    @GetMapping("/faqs")
    public ResponseEntity<List<FAQ>> getFAQs() {
        List<FAQ> faqs = faqService.getAllFAQs();
        return ResponseEntity.ok(faqs);
    }



}
