package com.kabobi.bibliotheque.entity;

import jakarta.persistence.*;

@Entity
@DiscriminatorValue("DVD")
public class DVD extends Document {

    private String director;
    private Integer duration; // en minutes
    private String subtitles;

    // Getters et Setters
    public String getDirector() { return director; }
    public void setDirector(String director) { this.director = director; }

    public Integer getDuration() { return duration; }
    public void setDuration(Integer duration) { this.duration = duration; }

    public String getSubtitles() { return subtitles; }
    public void setSubtitles(String subtitles) { this.subtitles = subtitles; }
}