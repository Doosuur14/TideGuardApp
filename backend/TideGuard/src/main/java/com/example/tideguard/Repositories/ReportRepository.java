package com.example.tideguard.Repositories;

import com.example.tideguard.Models.Report;
import com.example.tideguard.Models.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReportRepository  extends JpaRepository<Report, Long> {

}
