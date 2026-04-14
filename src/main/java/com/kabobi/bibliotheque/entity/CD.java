package com.kabobi.bibliotheque.entity;

import jakarta.persistence.*;

@Entity
@DiscriminatorValue("CD")
public class CD extends Document {

    private String artist;
    private Integer duration; // en minutes
    private String recordCompany;

    // Getters et Setters
    public String getArtist() { return artist; }
    public void setArtist(String artist) { this.artist = artist; }

    public Integer getDuration() { return duration; }
    public void setDuration(Integer duration) { this.duration = duration; }

    public String getRecordCompany() { return recordCompany; }
    public void setRecordCompany(String recordCompany) { this.recordCompany = recordCompany; }
}