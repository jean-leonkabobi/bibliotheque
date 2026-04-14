package com.kabobi.bibliotheque.dao;

import com.kabobi.bibliotheque.entity.Penalty;
import com.kabobi.bibliotheque.entity.PenaltyStatus;
import com.kabobi.bibliotheque.entity.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class PenaltyDAO {

    private static final EntityManagerFactory emf =
            Persistence.createEntityManagerFactory("bibliothequePU");

    public void save(Penalty penalty) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(penalty);
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

    // Récupérer toutes les pénalités
    public List<Penalty> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Penalty> query = em.createQuery(
                    "SELECT p FROM Penalty p ORDER BY p.createdAt DESC", Penalty.class);
            return query.getResultList();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public void update(Penalty penalty) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(penalty);
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

    public Optional<Penalty> findById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            Penalty penalty = em.find(Penalty.class, id);
            return Optional.ofNullable(penalty);
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public List<Penalty> findByUser(User user) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Penalty> query = em.createQuery(
                    "SELECT p FROM Penalty p WHERE p.user = :user ORDER BY p.createdAt DESC",
                    Penalty.class);
            query.setParameter("user", user);
            return query.getResultList();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public List<Penalty> findUnpaidByUser(User user) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Penalty> query = em.createQuery(
                    "SELECT p FROM Penalty p WHERE p.user = :user AND p.status = :status ORDER BY p.createdAt DESC",
                    Penalty.class);
            query.setParameter("user", user);
            query.setParameter("status", PenaltyStatus.UNPAID);
            return query.getResultList();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public List<Penalty> findAllUnpaid() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Penalty> query = em.createQuery(
                    "SELECT p FROM Penalty p WHERE p.status = :status ORDER BY p.createdAt DESC",
                    Penalty.class);
            query.setParameter("status", PenaltyStatus.UNPAID);
            return query.getResultList();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public double getTotalUnpaidByUser(User user) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Double> query = em.createQuery(
                    "SELECT SUM(p.amount) FROM Penalty p WHERE p.user = :user AND p.status = :status",
                    Double.class);
            query.setParameter("user", user);
            query.setParameter("status", PenaltyStatus.UNPAID);
            Double result = query.getSingleResult();
            return result != null ? result : 0.0;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public void payPenalty(Long penaltyId) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            Penalty penalty = em.find(Penalty.class, penaltyId);
            if (penalty != null && penalty.isUnpaid()) {
                penalty.pay();
                em.merge(penalty);
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

    public void cancelPenalty(Long penaltyId) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            Penalty penalty = em.find(Penalty.class, penaltyId);
            if (penalty != null && penalty.isUnpaid()) {
                penalty.setStatus(PenaltyStatus.CANCELLED);
                em.merge(penalty);
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

    public static void close() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}