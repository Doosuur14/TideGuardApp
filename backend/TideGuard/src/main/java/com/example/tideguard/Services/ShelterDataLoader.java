package com.example.tideguard.Services;

import com.example.tideguard.Models.Shelters;
import com.example.tideguard.Repositories.ShelterRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class ShelterDataLoader implements CommandLineRunner {

    @Autowired
    private ShelterRepository shelterRepository;

    @Override
    public void run(String... args) throws Exception {

        if (shelterRepository.count() > 0) return; // only seed once

        List<Shelters> shelters = List.of(

                Shelters.builder()
                        .name("Teslim Balogun Stadium Emergency Shelter")
                        .city("Lagos").lga("Surulere")
                        .latitude(6.4969).longitude(3.3635)
                        .capacity(15000).type("STADIUM").build(),

                Shelters.builder()
                        .name("Onikan Stadium Relief Camp")
                        .city("Lagos").lga("Lagos Island")
                        .latitude(6.4474).longitude(3.3975)
                        .capacity(8000).type("STADIUM").build(),

                Shelters.builder()
                        .name("Agege Stadium Flood Shelter")
                        .city("Lagos").lga("Agege")
                        .latitude(6.6184).longitude(3.3207)
                        .capacity(10000).type("STADIUM").build(),

                Shelters.builder()
                        .name("Ikorodu Emergency Relief Center")
                        .city("Lagos").lga("Ikorodu")
                        .latitude(6.6153).longitude(3.5094)
                        .capacity(5000).type("IDP_CAMP").build(),

                Shelters.builder()
                        .name("Epe Disaster Response Camp")
                        .city("Lagos").lga("Epe")
                        .latitude(6.5833).longitude(3.9833)
                        .capacity(4000).type("IDP_CAMP").build(),

                Shelters.builder()
                        .name("Badagry Coastal Flood Shelter")
                        .city("Lagos").lga("Badagry")
                        .latitude(6.4167).longitude(2.8833)
                        .capacity(6000).type("IDP_CAMP").build(),

                Shelters.builder()
                        .name("Eti-Osa Emergency Center")
                        .city("Lagos").lga("Eti-Osa")
                        .latitude(6.4474).longitude(3.6014)
                        .capacity(7000).type("IDP_CAMP").build(),

                Shelters.builder()
                        .name("Alimosho Relief Camp")
                        .city("Lagos").lga("Alimosho")
                        .latitude(6.5833).longitude(3.2667)
                        .capacity(8500).type("IDP_CAMP").build(),

                Shelters.builder()
                        .name("Sani Abacha Stadium Shelter")
                        .city("Kano").lga("Kano Municipal")
                        .latitude(12.0022).longitude(8.5920)
                        .capacity(20000).type("STADIUM").build(),

                Shelters.builder()
                        .name("Dala Emergency Camp")
                        .city("Kano").lga("Dala")
                        .latitude(11.9833).longitude(8.5167)
                        .capacity(5000).type("IDP_CAMP").build(),

                Shelters.builder()
                        .name("Nassarawa IDP Camp")
                        .city("Kano").lga("Nassarawa")
                        .latitude(12.0167).longitude(8.5333)
                        .capacity(6000).type("IDP_CAMP").build(),


                Shelters.builder()
                        .name("Liberty Stadium Emergency Center")
                        .city("Oyo").lga("Ibadan North")
                        .latitude(7.3889).longitude(3.9167)
                        .capacity(12000).type("STADIUM").build(),

                Shelters.builder()
                        .name("Lekan Salami Stadium Shelter")
                        .city("Oyo").lga("Ibadan South-West")
                        .latitude(7.3775).longitude(3.9470)
                        .capacity(10000).type("STADIUM").build(),

                Shelters.builder()
                        .name("Bodija Relief Camp")
                        .city("Oyo").lga("Ibadan North-West")
                        .latitude(7.4333).longitude(3.9000)
                        .capacity(4500).type("IDP_CAMP").build(),

                Shelters.builder()
                        .name("Ogbomoso Emergency Shelter")
                        .city("Oyo").lga("Ogbomoso North")
                        .latitude(8.1333).longitude(4.2500)
                        .capacity(5000).type("IDP_CAMP").build(),


                Shelters.builder()
                        .name("Teachers Village IDP Camp")
                        .city("Borno").lga("Maiduguri")
                        .latitude(11.8333).longitude(13.1500)
                        .capacity(30000).type("IDP_CAMP").build(),

                Shelters.builder()
                        .name("Mohammed Goni Stadium Camp")
                        .city("Borno").lga("Maiduguri")
                        .latitude(11.8469).longitude(13.1571)
                        .capacity(10000).type("STADIUM").build(),

                Shelters.builder()
                        .name("Bakassi IDP Camp")
                        .city("Borno").lga("Maiduguri")
                        .latitude(11.8219).longitude(13.1411)
                        .capacity(25000).type("IDP_CAMP").build(),

                Shelters.builder()
                        .name("Gubio IDP Camp")
                        .city("Borno").lga("Gubio")
                        .latitude(12.4500).longitude(13.3167)
                        .capacity(8000).type("IDP_CAMP").build(),


                Shelters.builder()
                        .name("North Bank IDP Camp")
                        .city("Benue").lga("Makurdi")
                        .latitude(7.7306).longitude(8.5214)
                        .capacity(5000).type("IDP_CAMP").build(),

                Shelters.builder()
                        .name("Internally Displaced Persons Camp Agatu")
                        .city("Benue").lga("Agatu")
                        .latitude(7.4833).longitude(7.9833)
                        .capacity(3000).type("IDP_CAMP").build(),

                Shelters.builder()
                        .name("Otukpo Emergency Center")
                        .city("Benue").lga("Otukpo")
                        .latitude(7.1833).longitude(8.1333)
                        .capacity(4000).type("IDP_CAMP").build(),


                Shelters.builder()
                        .name("Anambra Flood Relief Camp Ogbaru")
                        .city("Anambra").lga("Ogbaru")
                        .latitude(5.9833).longitude(6.7833)
                        .capacity(2000).type("IDP_CAMP").build(),

                Shelters.builder()
                        .name("Onitsha Emergency Shelter")
                        .city("Anambra").lga("Onitsha North")
                        .latitude(6.1667).longitude(6.7833)
                        .capacity(5000).type("IDP_CAMP").build(),

                Shelters.builder()
                        .name("Awka Relief Center")
                        .city("Anambra").lga("Awka South")
                        .latitude(6.2104).longitude(7.0719)
                        .capacity(3500).type("IDP_CAMP").build(),


                Shelters.builder()
                        .name("Lokoja IDP Flood Shelter")
                        .city("Kogi").lga("Lokoja")
                        .latitude(7.7983).longitude(6.7417)
                        .capacity(3500).type("IDP_CAMP").build(),

                Shelters.builder()
                        .name("Confluence Stadium Shelter")
                        .city("Kogi").lga("Lokoja")
                        .latitude(7.8000).longitude(6.7400)
                        .capacity(8000).type("STADIUM").build(),


                Shelters.builder()
                        .name("Asaba Flood Emergency Shelter")
                        .city("Delta").lga("Oshimili South")
                        .latitude(6.1956).longitude(6.7356)
                        .capacity(2500).type("IDP_CAMP").build(),

                Shelters.builder()
                        .name("Warri Emergency Relief Camp")
                        .city("Delta").lga("Warri South")
                        .latitude(5.5167).longitude(5.7500)
                        .capacity(6000).type("IDP_CAMP").build(),

                Shelters.builder()
                        .name("Ughelli Flood Shelter")
                        .city("Delta").lga("Ughelli North")
                        .latitude(5.4833).longitude(6.0000)
                        .capacity(4000).type("IDP_CAMP").build(),


                Shelters.builder()
                        .name("Port Harcourt IDP Relief Camp")
                        .city("Rivers").lga("Port Harcourt")
                        .latitude(4.8156).longitude(7.0498)
                        .capacity(4000).type("IDP_CAMP").build(),

                Shelters.builder()
                        .name("Liberation Stadium Shelter")
                        .city("Rivers").lga("Port Harcourt")
                        .latitude(4.8104).longitude(7.0417)
                        .capacity(15000).type("STADIUM").build(),

                Shelters.builder()
                        .name("Okrika Emergency Center")
                        .city("Rivers").lga("Okrika")
                        .latitude(4.7500).longitude(7.0833)
                        .capacity(3000).type("IDP_CAMP").build(),

                // ========== ADAMAWA STATE ==========
                Shelters.builder()
                        .name("Yola IDP Camp")
                        .city("Adamawa").lga("Yola North")
                        .latitude(9.2035).longitude(12.4954)
                        .capacity(6000).type("IDP_CAMP").build(),

                Shelters.builder()
                        .name("Mubi Emergency Shelter")
                        .city("Adamawa").lga("Mubi North")
                        .latitude(10.2667).longitude(13.2667)
                        .capacity(4500).type("IDP_CAMP").build(),

                // ========== FCT ABUJA ==========
                Shelters.builder()
                        .name("Area One IDP Camp Abuja")
                        .city("FCT").lga("Municipal Area Council")
                        .latitude(9.0820).longitude(7.4891)
                        .capacity(1500).type("IDP_CAMP").build(),

                Shelters.builder()
                        .name("Gwagwalada Emergency Center")
                        .city("FCT").lga("Gwagwalada")
                        .latitude(8.9333).longitude(7.0833)
                        .capacity(3000).type("IDP_CAMP").build(),

                Shelters.builder()
                        .name("Kubwa Relief Camp")
                        .city("FCT").lga("Bwari")
                        .latitude(9.0833).longitude(7.3500)
                        .capacity(2500).type("IDP_CAMP").build(),

                // ========== BAYELSA STATE ==========
                Shelters.builder()
                        .name("Yenagoa Flood Relief Shelter")
                        .city("Bayelsa").lga("Yenagoa")
                        .latitude(4.9267).longitude(6.2676)
                        .capacity(3000).type("IDP_CAMP").build(),

                Shelters.builder()
                        .name("Brass Emergency Camp")
                        .city("Bayelsa").lga("Brass")
                        .latitude(4.3167).longitude(6.2333)
                        .capacity(2000).type("IDP_CAMP").build(),

                // ========== EDO STATE ==========
                Shelters.builder()
                        .name("Benin City Emergency Shelter")
                        .city("Edo").lga("Oredo")
                        .latitude(6.3350).longitude(5.6270)
                        .capacity(2000).type("IDP_CAMP").build(),

                Shelters.builder()
                        .name("Samuel Ogbemudia Stadium Shelter")
                        .city("Edo").lga("Oredo")
                        .latitude(6.3389).longitude(5.6208)
                        .capacity(12000).type("STADIUM").build(),

                // ========== CROSS RIVER STATE ==========
                Shelters.builder()
                        .name("Calabar Emergency Relief Center")
                        .city("Cross River").lga("Calabar Municipal")
                        .latitude(4.9517).longitude(8.3417)
                        .capacity(5000).type("IDP_CAMP").build(),

                Shelters.builder()
                        .name("U.J. Esuene Stadium Shelter")
                        .city("Cross River").lga("Calabar South")
                        .latitude(4.9608).longitude(8.3444)
                        .capacity(10000).type("STADIUM").build(),

                // ========== AKWA IBOM STATE ==========
                Shelters.builder()
                        .name("Uyo Township Stadium Shelter")
                        .city("Akwa Ibom").lga("Uyo")
                        .latitude(5.0378).longitude(7.9129)
                        .capacity(11000).type("STADIUM").build(),

                Shelters.builder()
                        .name("Ikot Ekpene Relief Camp")
                        .city("Akwa Ibom").lga("Ikot Ekpene")
                        .latitude(5.1833).longitude(7.7167)
                        .capacity(3500).type("IDP_CAMP").build(),

                // ========== ENUGU STATE ==========
                Shelters.builder()
                        .name("Nnamdi Azikiwe Stadium Shelter")
                        .city("Enugu").lga("Enugu North")
                        .latitude(6.4500).longitude(7.5000)
                        .capacity(10000).type("STADIUM").build(),

                Shelters.builder()
                        .name("Enugu Emergency Relief Center")
                        .city("Enugu").lga("Enugu South")
                        .latitude(6.4406).longitude(7.4981)
                        .capacity(4000).type("IDP_CAMP").build(),

                // ========== KADUNA STATE ==========
                Shelters.builder()
                        .name("Ahmadu Bello Stadium Shelter")
                        .city("Kaduna").lga("Kaduna North")
                        .latitude(10.5167).longitude(7.4333)
                        .capacity(18000).type("STADIUM").build(),

                Shelters.builder()
                        .name("Zaria Emergency Camp")
                        .city("Kaduna").lga("Zaria")
                        .latitude(11.0667).longitude(7.7000)
                        .capacity(5000).type("IDP_CAMP").build(),

                Shelters.builder()
                        .name("Kafanchan Relief Center")
                        .city("Kaduna").lga("Jema'a")
                        .latitude(9.5833).longitude(8.3000)
                        .capacity(3000).type("IDP_CAMP").build(),

                // ========== PLATEAU STATE ==========
                Shelters.builder()
                        .name("Jos Township Stadium Shelter")
                        .city("Plateau").lga("Jos North")
                        .latitude(9.9167).longitude(8.8833)
                        .capacity(12000).type("STADIUM").build(),

                Shelters.builder()
                        .name("Rayfield Emergency Camp")
                        .city("Plateau").lga("Jos South")
                        .latitude(9.8333).longitude(8.8667)
                        .capacity(4000).type("IDP_CAMP").build(),

                // ========== NIGER STATE ==========
                Shelters.builder()
                        .name("Minna Emergency Relief Center")
                        .city("Niger").lga("Chanchaga")
                        .latitude(9.6167).longitude(6.5500)
                        .capacity(5000).type("IDP_CAMP").build(),

                Shelters.builder()
                        .name("Bida Flood Shelter")
                        .city("Niger").lga("Bida")
                        .latitude(9.0833).longitude(6.0167)
                        .capacity(3500).type("IDP_CAMP").build(),

                // ========== ONDO STATE ==========
                Shelters.builder()
                        .name("Akure Emergency Center")
                        .city("Ondo").lga("Akure South")
                        .latitude(7.2571).longitude(5.2058)
                        .capacity(4000).type("IDP_CAMP").build(),

                Shelters.builder()
                        .name("Ondo Town Relief Camp")
                        .city("Ondo").lga("Ondo West")
                        .latitude(7.0931).longitude(4.8350)
                        .capacity(3000).type("IDP_CAMP").build()
        );

        shelterRepository.saveAll(shelters);
        System.out.println("Shelters seeded: " + shelters.size() + " locations");

    }
}