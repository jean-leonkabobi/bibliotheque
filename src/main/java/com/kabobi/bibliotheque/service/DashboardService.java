package com.kabobi.bibliotheque.service;

import com.kabobi.bibliotheque.dao.UserDAO;
import com.kabobi.bibliotheque.entity.User;
import com.kabobi.bibliotheque.entity.UserStatus;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DashboardService {

    private final EntityManagerFactory emf;
    private final UserDAO userDAO;
    private final DocumentService documentService;
    private final LoanService loanService;

    public DashboardService() {
        this.emf = Persistence.createEntityManagerFactory("bibliothequePU");
        this.userDAO = new UserDAO();
        this.documentService = new DocumentService();
        this.loanService = new LoanService();
    }

    /**
     * Statistiques pour l'administrateur (avec vraies données)
     */
    public Map<String, Object> getAdminStats() {
        Map<String, Object> stats = new HashMap<>();

        try {
            // ========== STATISTIQUES DES ADHÉRENTS ==========
            long totalMembers = userDAO.findAll().stream()
                    .filter(u -> u.getRole().name().equals("MEMBER"))
                    .count();
            stats.put("totalMembers", totalMembers);

            long totalLibrarians = userDAO.findAll().stream()
                    .filter(u -> u.getRole().name().equals("LIBRARIAN"))
                    .count();
            stats.put("totalLibrarians", totalLibrarians);

            long totalAdmins = userDAO.findAll().stream()
                    .filter(u -> u.getRole().name().equals("ADMIN"))
                    .count();
            stats.put("totalAdmins", totalAdmins);

            long activeMembers = userDAO.findAll().stream()
                    .filter(u -> u.getRole().name().equals("MEMBER") && u.getStatus() == UserStatus.ACTIVE)
                    .count();
            stats.put("activeMembers", activeMembers);

            long pendingMembers = userDAO.findAll().stream()
                    .filter(u -> u.getRole().name().equals("MEMBER") && u.getStatus() == UserStatus.PENDING)
                    .count();
            stats.put("pendingMembers", pendingMembers);

            long suspendedMembers = userDAO.findAll().stream()
                    .filter(u -> u.getRole().name().equals("MEMBER") && u.getStatus() == UserStatus.SUSPENDED)
                    .count();
            stats.put("suspendedMembers", suspendedMembers);

            // ========== STATISTIQUES DES OUVRAGES ==========
            long totalBooks = documentService.getAllDocuments().size();
            stats.put("totalBooks", totalBooks);

            // ========== STATISTIQUES DES EMPRUNTS ==========
            long totalLoans = loanService.getAllLoans().size();
            long activeLoans = loanService.countActiveLoans();
            long overdueLoans = loanService.countOverdueLoans();

            stats.put("totalLoans", totalLoans);
            stats.put("activeLoans", activeLoans);
            stats.put("overdueLoans", overdueLoans);

            System.out.println("=== Dashboard Admin Stats ===");
            System.out.println("Adhérents: " + totalMembers);
            System.out.println("Ouvrages: " + totalBooks);
            System.out.println("Emprunts actifs: " + activeLoans);

        } catch (Exception e) {
            System.err.println("Erreur lors du chargement des stats: " + e.getMessage());
            e.printStackTrace();

            stats.put("totalMembers", 0L);
            stats.put("totalLibrarians", 0L);
            stats.put("totalAdmins", 0L);
            stats.put("activeMembers", 0L);
            stats.put("pendingMembers", 0L);
            stats.put("suspendedMembers", 0L);
            stats.put("totalBooks", 0L);
            stats.put("totalLoans", 0L);
            stats.put("activeLoans", 0L);
            stats.put("overdueLoans", 0L);
        }

        return stats;
    }

    /**
     * Récupérer les bibliothécaires
     */
    public List<User> getLibrarians() {
        return userDAO.findAll().stream()
                .filter(u -> u.getRole().name().equals("LIBRARIAN"))
                .toList();
    }

    /**
     * Récupérer les adhérents en attente
     */
    public List<User> getPendingMembers() {
        return userDAO.findAll().stream()
                .filter(u -> u.getRole().name().equals("MEMBER") && u.getStatus() == UserStatus.PENDING)
                .toList();
    }

    /**
     * Statistiques pour le bibliothécaire (avec vraies données)
     */
    public Map<String, Object> getLibrarianStats() {
        Map<String, Object> stats = new HashMap<>();

        try {
            // Emprunts en retard
            long overdueLoans = loanService.countOverdueLoans();
            stats.put("overdueLoans", overdueLoans);

            // Emprunts du jour (aujourd'hui)
            long todayLoans = loanService.getTodayLoansCount();
            stats.put("todayLoans", todayLoans);

            // Retours attendus aujourd'hui
            long todayReturns = loanService.getTodayReturnsCount();
            stats.put("todayReturns", todayReturns);

            // Adhérents avec pénalités impayées
            long membersWithPenalties = loanService.getMembersWithPenalties();
            stats.put("membersWithPenalties", membersWithPenalties);

            // Inscriptions en attente
            long pendingValidations = getPendingMembers().size();
            stats.put("pendingValidations", pendingValidations);

            // Réservations en attente (à implémenter plus tard)
            stats.put("pendingReservations", 0);

            System.out.println("=== Dashboard Librarian Stats ===");
            System.out.println("Emprunts du jour: " + todayLoans);
            System.out.println("Retours attendus: " + todayReturns);
            System.out.println("En retard: " + overdueLoans);
            System.out.println("Membres avec pénalités: " + membersWithPenalties);
            System.out.println("Validations en attente: " + pendingValidations);

        } catch (Exception e) {
            System.err.println("Erreur lors du chargement des stats bibliothécaire: " + e.getMessage());
            e.printStackTrace();

            stats.put("overdueLoans", 0L);
            stats.put("todayLoans", 0L);
            stats.put("todayReturns", 0L);
            stats.put("membersWithPenalties", 0L);
            stats.put("pendingValidations", 0L);
            stats.put("pendingReservations", 0L);
        }

        return stats;
    }

    /**
     * Données pour le tableau de bord adhérent
     */
    public Map<String, Object> getMemberStats(User member) {
        Map<String, Object> stats = new HashMap<>();

        try {
            long currentLoans = loanService.getUserActiveLoansCount(member.getId());
            double totalPenalties = loanService.getUserTotalPenalties(member.getId());
            long totalLoansHistory = loanService.getUserLoanHistoryCount(member.getId());

            stats.put("currentLoans", currentLoans);
            stats.put("maxLoans", 3);
            stats.put("overdueLoans", 0);
            stats.put("totalPenalties", totalPenalties);
            stats.put("totalLoansHistory", totalLoansHistory);
            stats.put("pendingReservations", 0);

        } catch (Exception e) {
            e.printStackTrace();

            stats.put("currentLoans", 0);
            stats.put("maxLoans", 3);
            stats.put("overdueLoans", 0);
            stats.put("totalPenalties", 0.0);
            stats.put("totalLoansHistory", 0);
            stats.put("pendingReservations", 0);
        }

        return stats;
    }

    public void close() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
        if (documentService != null) {
            documentService.close();
        }
        if (loanService != null) {
            loanService.close();
        }
    }
}