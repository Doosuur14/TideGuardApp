package com.example.tideguard.Services;

import com.example.tideguard.Models.FAQ;
import com.example.tideguard.Repositories.FAQRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class FAQServiceImpl implements FAQService {
    @Autowired
    private FAQRepository faqRepository;


    @Override
    public List<FAQ> getAllFAQs() {
        return faqRepository.findAll();
    }
}
