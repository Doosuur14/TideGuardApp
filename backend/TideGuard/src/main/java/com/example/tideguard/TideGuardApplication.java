package com.example.tideguard;

import com.example.tideguard.Models.Evacuation;
import com.example.tideguard.Models.FAQ;
import com.example.tideguard.Models.FloodArea;
import com.example.tideguard.Models.Shelters;
import com.example.tideguard.Repositories.EvacuationRepository;
import com.example.tideguard.Repositories.FAQRepository;
import com.example.tideguard.Repositories.FloodRepository;
import com.example.tideguard.Repositories.ShelterRepository;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.client.RestTemplate;

import java.util.List;

@SpringBootApplication
public class TideGuardApplication {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
//    @Bean
//    public RestTemplate restTemplate() {
//        return new RestTemplate();
//    }

    public static void main(String[] args) {
        SpringApplication.run(TideGuardApplication.class, args);
    }


    @Bean
    CommandLineRunner init(ShelterRepository shelterRepository, FloodRepository floodAreaRepository, FAQRepository faqRepository ) {
        return args -> {

            if (shelterRepository.count() == 0) {
                ObjectMapper mapper = new ObjectMapper();
                ClassPathResource shelterResource = new ClassPathResource("shelters.json");
                List<Shelters> shelters = mapper.readValue(
                        shelterResource.getInputStream(),
                        new TypeReference<List<Shelters>>() {}
                );
                shelterRepository.saveAll(shelters);
                System.out.println("Loaded " + shelters.size() + " shelter records into the database.");
            } else {
                System.out.println("Shelter data already exists. Skipping initialization.");
            }


            if (floodAreaRepository.count() == 0) {
                ObjectMapper mapper = new ObjectMapper();
                ClassPathResource floodAreaResource = new ClassPathResource("floodareas.json");
                List<FloodArea> floodAreas = mapper.readValue(floodAreaResource.getInputStream(), new TypeReference<List<FloodArea>>() {});
                floodAreaRepository.saveAll(floodAreas);
                System.out.println("Loaded " + floodAreas.size() + " flood area records into the database.");
            } else {
                System.out.println("Flood area data already exists. Skipping initialization.");
            }

            if (faqRepository.count() == 0) {
                ObjectMapper mapper = new ObjectMapper();
                ClassPathResource faqResource = new ClassPathResource("faqs.json");
                List<FAQ> faqs = mapper.readValue(faqResource.getInputStream(), new TypeReference<List<FAQ>>() {});
                faqRepository.saveAll(faqs);
                System.out.println("Loaded " + faqs.size() + " FAQ records into the database.");
            } else {
                System.out.println("FAQ data already exists. Skipping initialization.");
            }
        };
    }


    @Bean
    public RestTemplate restTemplate() {
        SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
        factory.setConnectTimeout(5000);
        factory.setReadTimeout(5000);
        return new RestTemplate(factory);
    }
}
