package com.example.tideguard.Services;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Service
public class FileServiceImpl implements FileService {

    @Value("/Users/doosuur/TideGuardFiles")
    private String uploadDir;
    @Override
    public String storeFile(MultipartFile file, String email) throws IOException {
        if (file == null || file.isEmpty()) {
            throw new IOException("Cannot store empty file");
        }

        String originalFileName = file.getOriginalFilename();
        String fileExtension = originalFileName != null && originalFileName.contains(".")
                ? originalFileName.substring(originalFileName.lastIndexOf("."))
                : ".png";

        String fileName = UUID.randomUUID().toString() + fileExtension;
        Path uploadPath = Paths.get(uploadDir).resolve(fileName);

        Files.createDirectories(uploadPath.getParent());

        Files.copy(file.getInputStream(), uploadPath);
        if (Files.exists(uploadPath)) {
            System.out.println("✅ File saved successfully at: " + uploadPath);
        } else {
            throw new IOException("Failed to save file at: " + uploadPath);
        }

        return "http://localhost:8080/api/files/" + fileName;
    }

    public byte[] getFile(String fileName) throws IOException {
        Path filePath = Paths.get(uploadDir).resolve(fileName);
        if (!Files.exists(filePath)) {
            throw new IOException("File not found: " + fileName);
        }
        return Files.readAllBytes(filePath);
    }
}
