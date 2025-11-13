package com.example.tideguard.Services;

import com.example.tideguard.Models.FAQ;
import com.example.tideguard.Repositories.FAQRepository;

import java.util.List;

public interface FAQService {

    List<FAQ> getAllFAQs();

}
