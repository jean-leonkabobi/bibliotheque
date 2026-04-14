package com.kabobi.bibliotheque.entity;

import jakarta.persistence.*;

@Entity
@DiscriminatorValue("BOOK")
public class Book extends Document {

    private String isbn;
    private String author;
    private String publisher;
    private Integer publicationYear;
    private Integer numberOfPages;

    // Getters et Setters
    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }

    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }

    public String getPublisher() { return publisher; }
    public void setPublisher(String publisher) { this.publisher = publisher; }

    public Integer getPublicationYear() { return publicationYear; }
    public void setPublicationYear(Integer publicationYear) { this.publicationYear = publicationYear; }

    public Integer getNumberOfPages() { return numberOfPages; }
    public void setNumberOfPages(Integer numberOfPages) { this.numberOfPages = numberOfPages; }
}