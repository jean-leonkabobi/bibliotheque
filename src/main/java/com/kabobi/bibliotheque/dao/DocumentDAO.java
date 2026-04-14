package com.kabobi.bibliotheque.dao;

import com.kabobi.bibliotheque.entity.Book;
import com.kabobi.bibliotheque.entity.CD;
import com.kabobi.bibliotheque.entity.DVD;
import com.kabobi.bibliotheque.entity.Document;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import java.util.List;
import java.util.Optional;

public class DocumentDAO {

    private static final EntityManagerFactory emf =
            Persistence.createEntityManagerFactory("bibliothequePU");

    // Sauvegarder un document
    public void save(Document document) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(document);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // Mettre à jour
    public void update(Document document) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(document);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // Supprimer
    public void delete(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            Document document = em.find(Document.class, id);
            if (document != null) {
                em.remove(document);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // Trouver par ID
    public Optional<Document> findById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            Document document = em.find(Document.class, id);
            return Optional.ofNullable(document);
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // Tous les documents
    public List<Document> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Document> query = em.createQuery(
                    "SELECT d FROM Document d ORDER BY d.id", Document.class);
            return query.getResultList();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // Recherche par titre
    public List<Document> searchByTitle(String keyword) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Document> query = em.createQuery(
                    "SELECT d FROM Document d WHERE LOWER(d.title) LIKE LOWER(:keyword)",
                    Document.class);
            query.setParameter("keyword", "%" + keyword + "%");
            return query.getResultList();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // Recherche de livres par auteur
    public List<Book> searchBooksByAuthor(String author) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Book> query = em.createQuery(
                    "SELECT b FROM Book b WHERE LOWER(b.author) LIKE LOWER(:author)",
                    Book.class);
            query.setParameter("author", "%" + author + "%");
            return query.getResultList();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // Tous les livres
    public List<Book> findAllBooks() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Book> query = em.createQuery(
                    "SELECT b FROM Book b ORDER BY b.id", Book.class);
            return query.getResultList();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // Tous les CDs
    public List<CD> findAllCDs() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<CD> query = em.createQuery(
                    "SELECT c FROM CD c ORDER BY c.id", CD.class);
            return query.getResultList();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // Tous les DVDs
    public List<DVD> findAllDVDs() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<DVD> query = em.createQuery(
                    "SELECT d FROM DVD d ORDER BY d.id", DVD.class);
            return query.getResultList();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public static void close() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}