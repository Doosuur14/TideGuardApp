package com.example.tideguard.Repositories;

import com.example.tideguard.Models.Evacuation;
import com.example.tideguard.Models.FAQ;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FAQRepository extends JpaRepository<FAQ, Long>  {
    Page<FAQ> findAll(Pageable pageable);

}
