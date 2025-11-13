package com.example.tideguard.Services;

import com.example.tideguard.Models.Report;
import com.example.tideguard.Models.User;
import com.example.tideguard.Repositories.ReportRepository;
import com.example.tideguard.Repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.UUID;

@Component
public class ReportServiceImpl implements ReportService {

    @Value("/Users/doosuur/TideGuardFiles")
    private String reportDir;

    @Autowired
    private ReportRepository reportRepository;
    @Autowired
    private UserRepository userRepository;
    @Override
    public Report uploadReport(MultipartFile photo, String description, String email) {
        try {

            File directory = new File(reportDir);
            if (!directory.exists()) {
                directory.mkdirs();
            }

            String fileName = email + "_" + UUID.randomUUID().toString() + ".jpg";
            File file = new File(reportDir + fileName);
            photo.transferTo(file);

            User user = userRepository.findByEmail(email)
                    .orElseThrow(() -> new RuntimeException("User not found: " + email));

            Report report = new Report();
            report.setFileName(fileName);
            report.setPhotoUrl("http://localhost:8080/api/files/" + fileName);
            report.setDescription(description);
            report.setUser(user);
            return reportRepository.save(report);

        } catch (IOException e) {
            throw new RuntimeException("Failed to upload report: " + e.getMessage());
        }
    }

    @Override
    public byte[] getFile(String fileName) {
        try {
            File file = new File(reportDir+ fileName);
            return Files.readAllBytes(file.toPath());
        } catch (IOException e) {
            throw new RuntimeException("Failed to retrieve file: " + e.getMessage());
        }
    }
}
