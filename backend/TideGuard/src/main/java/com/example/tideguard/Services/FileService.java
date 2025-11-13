package com.example.tideguard.Services;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

public interface FileService {
    String storeFile(MultipartFile file, String email) throws IOException;
    byte[] getFile(String fileName) throws IOException;
}
