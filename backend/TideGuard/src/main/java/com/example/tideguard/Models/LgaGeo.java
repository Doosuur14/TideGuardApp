package com.example.tideguard.Models;


import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "lga_geo")
public class LgaGeo {

    @Id
    private String lgaName;
    private String state;
    private double latitude;
    private double longitude;


    public LgaGeo() {}

    public LgaGeo(String lgaName, String state, double latitude, double longitude) {
        this.lgaName = lgaName;
        this.state = state;
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public String getLgaName() { return lgaName; }
    public String getState() { return state; }
    public double getLatitude() { return latitude; }
    public double getLongitude() { return longitude; }

    @Override
    public String toString() {
        return "LgaGeo{" +
                "lgaName='" + lgaName + '\'' +
                ", state='" + state + '\'' +
                ", latitude=" + latitude +
                ", longitude=" + longitude +
                '}';
    }
}
