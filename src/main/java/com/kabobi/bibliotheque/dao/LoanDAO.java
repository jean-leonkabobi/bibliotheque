package com.kabobi.bibliotheque.dao;

import com.kabobi.bibliotheque.entity.Loan;
import com.kabobi.bibliotheque.entity.LoanStatus;
import com.kabobi.bibliotheque.entity.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class LoanDAO {

    private static final EntityManagerFactory emf =
            Persistence.createEntityManagerFactory("bibliothequePU");

    public void save(Loan loan) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(loan);
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

    public void update(Loan loan) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(loan);
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

    public Optional<Loan> findById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            Loan loan = em.find(Loan.class, id);
            return Optional.ofNullable(loan);
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public List<Loan> findByUser(User user) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Loan> query = em.createQuery(
                    "SELECT l FROM Loan l WHERE l.user = :user ORDER BY l.loanDate DESC",
                    Loan.class);
            query.setParameter("user", user);
            return query.getResultList();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public List<Loan> findActiveLoansByUser(User user) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Loan> query = em.createQuery(
                    "SELECT l FROM Loan l WHERE l.user = :user AND l.status = :status ORDER BY l.dueDate ASC",
                    Loan.class);
            query.setParameter("user", user);
            query.setParameter("status", LoanStatus.ACTIVE);
            return query.getResultList();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public List<Loan> findOverdueLoans() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Loan> query = em.createQuery(
                    "SELECT l FROM Loan l WHERE l.status = :status AND l.dueDate < :now ORDER BY l.dueDate ASC",
                    Loan.class);
            query.setParameter("status", LoanStatus.ACTIVE);
            query.setParameter("now", LocalDateTime.now());
            return query.getResultList();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public List<Loan> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Loan> query = em.createQuery(
                    "SELECT l FROM Loan l ORDER BY l.loanDate DESC",
                    Loan.class);
            return query.getResultList();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public List<Loan> findLoansByDateRange(LocalDateTime start, LocalDateTime end) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Loan> query = em.createQuery(
                    "SELECT l FROM Loan l WHERE l.loanDate BETWEEN :start AND :end ORDER BY l.loanDate DESC",
                    Loan.class);
            query.setParameter("start", start);
            query.setParameter("end", end);
            return query.getResultList();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public long countActiveLoansByUser(User user) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(l) FROM Loan l WHERE l.user = :user AND l.status = :status",
                    Long.class);
            query.setParameter("user", user);
            query.setParameter("status", LoanStatus.ACTIVE);
            return query.getSingleResult();
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