package com.example.tideguard.Services;

import com.example.tideguard.Models.Report;
import org.springframework.web.multipart.MultipartFile;

public interface ReportService {
    Report uploadReport(MultipartFile photo, String description, String email);
    byte[] getFile(String fileName);
}
