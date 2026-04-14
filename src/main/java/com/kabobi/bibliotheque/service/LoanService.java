package com.kabobi.bibliotheque.service;

import com.kabobi.bibliotheque.dao.LoanDAO;
import com.kabobi.bibliotheque.dao.PenaltyDAO;
import com.kabobi.bibliotheque.dao.UserDAO;
import com.kabobi.bibliotheque.entity.Loan;
import com.kabobi.bibliotheque.entity.LoanStatus;
import com.kabobi.bibliotheque.entity.Penalty;
import com.kabobi.bibliotheque.entity.User;
import com.kabobi.bibliotheque.entity.UserStatus;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class LoanService {

    private final LoanDAO loanDAO;
    private final UserDAO userDAO;
    private final PenaltyDAO penaltyDAO;

    public LoanService() {
        this.loanDAO = new LoanDAO();
        this.userDAO = new UserDAO();
        this.penaltyDAO = new PenaltyDAO();
    }

    // Récupérer tous les emprunts
    public List<Loan> getAllLoans() {
        return loanDAO.findAll();
    }

    // Récupérer les emprunts actifs
    public List<Loan> getActiveLoans() {
        return loanDAO.findAll().stream()
                .filter(l -> l.getStatus() == LoanStatus.ACTIVE)
                .toList();
    }

    // Récupérer les emprunts en retard
    public List<Loan> getOverdueLoans() {
        return loanDAO.findOverdueLoans();
    }

    // Récupérer les emprunts d'un utilisateur
    public List<Loan> getLoansByUser(Long userId) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isPresent()) {
            return loanDAO.findByUser(userOpt.get());
        }
        return List.of();
    }

    // Récupérer un emprunt par ID
    public Optional<Loan> getLoanById(Long id) {
        return loanDAO.findById(id);
    }

    //Pour la mise à jour de la date
    public void updateLoan(Loan loan) {
        loanDAO.update(loan);
    }

    // Créer un emprunt
    public boolean createLoan(Long userId, Long documentId, String documentType) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isEmpty() || userOpt.get().getStatus() != UserStatus.ACTIVE) {
            return false;
        }

        long activeLoans = loanDAO.countActiveLoansByUser(userOpt.get());
        if (activeLoans >= 3) {
            return false;
        }

        double unpaidPenalties = penaltyDAO.getTotalUnpaidByUser(userOpt.get());
        if (unpaidPenalties >= 10.0) {
            return false;
        }

        Loan loan = new Loan(userOpt.get(), documentId, documentType);
        loanDAO.save(loan);
        return true;
    }

    // Enregistrer un retour avec calcul des pénalités
    public boolean returnLoan(Long loanId) {
        Optional<Loan> loanOpt = loanDAO.findById(loanId);
        if (loanOpt.isEmpty() || loanOpt.get().getStatus() != LoanStatus.ACTIVE) {
            return false;
        }

        Loan loan = loanOpt.get();
        long daysOverdue = loan.getDaysOverdue();

        if (daysOverdue > 0) {
            double penaltyAmount = daysOverdue * 0.50;
            Penalty penalty = new Penalty(
                    loan.getUser(),
                    loan,
                    penaltyAmount,
                    "Retard de " + daysOverdue + " jour(s) pour le document #" + loan.getDocumentId()
            );
            penaltyDAO.save(penalty);
        }

        loan.returnLoan();
        loanDAO.update(loan);
        return true;
    }

    // Prolonger un emprunt
    public boolean renewLoan(Long loanId) {
        Optional<Loan> loanOpt = loanDAO.findById(loanId);
        if (loanOpt.isEmpty() || !loanOpt.get().canRenew()) {
            return false;
        }

        Loan loan = loanOpt.get();
        loan.renew();
        loanDAO.update(loan);
        return true;
    }

    // Compter les emprunts actifs
    public long countActiveLoans() {
        return getActiveLoans().size();
    }

    // Compter les emprunts en retard
    public long countOverdueLoans() {
        return getOverdueLoans().size();
    }

    // ========== MÉTHODES POUR LE DASHBOARD BIBLIOTHÉCAIRE ==========

    /**
     * Nombre d'emprunts effectués aujourd'hui
     */
    public long getTodayLoansCount() {
        LocalDateTime startOfDay = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0);
        LocalDateTime endOfDay = LocalDateTime.now().withHour(23).withMinute(59).withSecond(59);

        return loanDAO.findAll().stream()
                .filter(l -> l.getLoanDate() != null)
                .filter(l -> l.getLoanDate().isAfter(startOfDay) && l.getLoanDate().isBefore(endOfDay))
                .count();
    }

    /**
     * Nombre de retours attendus aujourd'hui
     */
    public long getTodayReturnsCount() {
        LocalDateTime startOfDay = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0);
        LocalDateTime endOfDay = LocalDateTime.now().withHour(23).withMinute(59).withSecond(59);

        return loanDAO.findAll().stream()
                .filter(l -> l.getStatus() == LoanStatus.ACTIVE)
                .filter(l -> l.getDueDate() != null)
                .filter(l -> l.getDueDate().isAfter(startOfDay) && l.getDueDate().isBefore(endOfDay))
                .count();
    }

    /**
     * Nombre de membres avec des pénalités impayées
     */
    public long getMembersWithPenalties() {
        return penaltyDAO.findAllUnpaid().stream()
                .map(p -> p.getUser().getId())
                .distinct()
                .count();
    }

    // ========== MÉTHODES POUR LE DASHBOARD MEMBRE ==========

    /**
     * Nombre d'emprunts actifs d'un utilisateur
     */
    public long getUserActiveLoansCount(Long userId) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isPresent()) {
            return loanDAO.countActiveLoansByUser(userOpt.get());
        }
        return 0;
    }

    /**
     * Total des pénalités impayées d'un utilisateur
     */
    public double getUserTotalPenalties(Long userId) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isPresent()) {
            return penaltyDAO.getTotalUnpaidByUser(userOpt.get());
        }
        return 0.0;
    }

    /**
     * Récupérer les emprunts actifs d'un utilisateur
     */
    public List<Loan> getUserActiveLoans(Long userId) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isPresent()) {
            return loanDAO.findActiveLoansByUser(userOpt.get());
        }
        return List.of();
    }

    /**
     * Récupérer l'historique complet des emprunts d'un utilisateur
     */
    public List<Loan> getUserLoanHistory(Long userId) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isPresent()) {
            return loanDAO.findByUser(userOpt.get());
        }
        return List.of();
    }

    /**
     * Nombre total d'emprunts dans l'historique d'un utilisateur
     */
    public long getUserLoanHistoryCount(Long userId) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isPresent()) {
            return loanDAO.findByUser(userOpt.get()).size();
        }
        return 0;
    }

    public void close() {
        loanDAO.close();
        userDAO.close();
        penaltyDAO.close();
    }
}