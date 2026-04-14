package com.kabobi.bibliotheque.service;

import com.kabobi.bibliotheque.dao.DocumentDAO;
import com.kabobi.bibliotheque.entity.Book;
import com.kabobi.bibliotheque.entity.CD;
import com.kabobi.bibliotheque.entity.DVD;
import com.kabobi.bibliotheque.entity.Document;
import java.util.List;
import java.util.Optional;

public class DocumentService {

    private final DocumentDAO documentDAO;

    public DocumentService() {
        this.documentDAO = new DocumentDAO();
    }

    // Récupérer tous les documents
    public List<Document> getAllDocuments() {
        return documentDAO.findAll();
    }

    // Récupérer un document par son ID
    public Optional<Document> getDocumentById(Long id) {
        return documentDAO.findById(id);
    }

    // Créer un livre
    public void createBook(Book book) {
        documentDAO.save(book);
    }

    // Créer un CD
    public void createCD(CD cd) {
        documentDAO.save(cd);
    }

    // Créer un DVD
    public void createDVD(DVD dvd) {
        documentDAO.save(dvd);
    }

    // Mettre à jour un document
    public void updateDocument(Document document) {
        documentDAO.update(document);
    }

    // Supprimer un document
    public boolean deleteDocument(Long id) {
        Optional<Document> docOpt = documentDAO.findById(id);
        if (docOpt.isPresent()) {
            documentDAO.delete(id);
            return true;
        }
        return false;
    }

    // Rechercher par titre
    public List<Document> searchByTitle(String keyword) {
        return documentDAO.searchByTitle(keyword);
    }

    // Rechercher par auteur (livres uniquement)
    public List<Book> searchBooksByAuthor(String author) {
        return documentDAO.searchBooksByAuthor(author);
    }

    // Récupérer tous les livres
    public List<Book> getAllBooks() {
        return documentDAO.findAllBooks();
    }

    // Récupérer tous les CDs
    public List<CD> getAllCDs() {
        return documentDAO.findAllCDs();
    }

    // Récupérer tous les DVDs
    public List<DVD> getAllDVDs() {
        return documentDAO.findAllDVDs();
    }

    public void close() {
        documentDAO.close();
    }
}