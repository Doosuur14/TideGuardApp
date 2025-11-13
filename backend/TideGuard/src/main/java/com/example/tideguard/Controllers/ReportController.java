package com.example.tideguard.Controllers;


import com.example.tideguard.Models.Report;
import com.example.tideguard.Services.ReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
public class ReportController {
    @Autowired
    private ReportService reportService;

    @PostMapping("/report")
    public ResponseEntity<Report> uploadReport(
            @RequestParam("photo") MultipartFile photo,
            @RequestParam("description") String description,
            @RequestHeader("email") String email) {
        Report report = reportService.uploadReport(photo, description, email);
        return ResponseEntity.ok(report);
    }

    @GetMapping("/files/{fileName}")
    public ResponseEntity<byte[]> getFile(@PathVariable String fileName) {
        byte[] fileContent = reportService.getFile(fileName);
        return ResponseEntity.ok()
                .header("Content-Type", "image/jpeg")
                .body(fileContent);
    }
}
