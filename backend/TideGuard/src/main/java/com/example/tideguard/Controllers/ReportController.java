package com.example.tideguard.Controllers;


import com.example.tideguard.Models.Report;
import com.example.tideguard.Services.ReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
public class ReportController {
    @Autowired
    private ReportService reportService;

    @PostMapping("/report")
    public ResponseEntity<Report> uploadReport(
            @RequestParam("photo") MultipartFile photo,
            @RequestParam("description") String description,
            @RequestParam("latitude") Double latitude,
            @RequestParam("longitude") Double longitude,
            @RequestParam("severity") String severity,
            @RequestHeader("email") String email) {
        Report report = reportService.uploadReport(photo, description, email, latitude, longitude, severity);
        return ResponseEntity.ok(report);
    }

    @GetMapping("/files/{fileName}")
    public ResponseEntity<byte[]> getFile(@PathVariable String fileName) {
        byte[] fileContent = reportService.getFile(fileName);
        return ResponseEntity.ok()
                .header("Content-Type", "image/jpeg")
                .body(fileContent);
    }



    @GetMapping("/reports")
    public ResponseEntity<List<Report>> getAllReports() {
        List<Report> reports = reportService.getAllReports();
        return ResponseEntity.ok(reports);
    }


    @GetMapping("/reports/nearby")
    public ResponseEntity<List<Report>> getNearbyReports(
            @RequestParam Double latitude,
            @RequestParam Double longitude,
            @RequestParam(required = false, defaultValue = "50") Double radiusKm) {
        List<Report> reports = reportService.getNearbyReports(latitude, longitude, radiusKm);
        return ResponseEntity.ok(reports);
    }
}
