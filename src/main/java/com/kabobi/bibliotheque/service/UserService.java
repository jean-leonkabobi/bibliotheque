package com.kabobi.bibliotheque.service;

import com.kabobi.bibliotheque.dao.LoanDAO;
import com.kabobi.bibliotheque.dao.PenaltyDAO;
import com.kabobi.bibliotheque.dao.UserDAO;
import com.kabobi.bibliotheque.entity.*;
import org.mindrot.jbcrypt.BCrypt;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class UserService {

    private final UserDAO userDAO;
    private final LoanDAO loanDAO;
    private final PenaltyDAO penaltyDAO;

    public UserService() {
        this.userDAO = new UserDAO();
        this.loanDAO = new LoanDAO();
        this.penaltyDAO = new PenaltyDAO();
    }

    // ==================== CRUD DE BASE ====================

    public boolean createUser(User user, String rawPassword) {
        if (userDAO.findByEmail(user.getEmail()).isPresent()) {
            return false;
        }
        String hashedPassword = BCrypt.hashpw(rawPassword, BCrypt.gensalt());
        user.setPassword(hashedPassword);
        userDAO.save(user);
        return true;
    }

    public List<User> getAllUsers() {
        return userDAO.findAll();
    }

    public Optional<User> getUserById(Long id) {
        return userDAO.findById(id);
    }

    public Optional<User> getUserByEmail(String email) {
        return userDAO.findByEmail(email);
    }

    public void updateUser(User user) {
        userDAO.update(user);
    }

    public boolean deleteUser(Long id) {
        Optional<User> userOpt = userDAO.findById(id);
        if (userOpt.isPresent()) {
            userDAO.delete(id);
            return true;
        }
        return false;
    }

    // ==================== FILTRES PAR RÔLE ====================

    public List<User> getAllMembers() {
        return userDAO.findAll().stream()
                .filter(u -> u.getRole() == Role.MEMBER)
                .collect(Collectors.toList());
    }

    public List<User> getAllLibrarians() {
        return userDAO.findAll().stream()
                .filter(u -> u.getRole() == Role.LIBRARIAN)
                .collect(Collectors.toList());
    }

    public List<User> getAllAdmins() {
        return userDAO.findAll().stream()
                .filter(u -> u.getRole() == Role.ADMIN)
                .collect(Collectors.toList());
    }

    // ==================== FILTRES PAR STATUT ====================

    public List<User> getPendingUsers() {
        return userDAO.findByStatus(UserStatus.PENDING);
    }

    public List<User> getActiveUsers() {
        return userDAO.findByStatus(UserStatus.ACTIVE);
    }

    public List<User> getSuspendedUsers() {
        return userDAO.findByStatus(UserStatus.SUSPENDED);
    }

    public List<User> getInactiveUsers() {
        return userDAO.findByStatus(UserStatus.INACTIVE);
    }

    // ==================== VALIDATION DES COMPTES ====================

    public boolean validateUser(Long userId) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (user.getStatus() == UserStatus.PENDING) {
                user.setStatus(UserStatus.ACTIVE);
                user.setUpdatedAt(LocalDateTime.now());
                userDAO.update(user);
                return true;
            }
        }
        return false;
    }

    public boolean validateUserWithRole(Long userId, Role role) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (user.getStatus() == UserStatus.PENDING) {
                user.setStatus(UserStatus.ACTIVE);
                user.setRole(role);
                user.setUpdatedAt(LocalDateTime.now());
                userDAO.update(user);
                return true;
            }
        }
        return false;
    }

    // ==================== SUSPENSION / RÉACTIVATION ====================

    public boolean suspendUser(Long userId) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setStatus(UserStatus.SUSPENDED);
            user.setUpdatedAt(LocalDateTime.now());
            userDAO.update(user);
            return true;
        }
        return false;
    }

    public boolean activateUser(Long userId) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (user.getStatus() == UserStatus.SUSPENDED) {
                user.setStatus(UserStatus.ACTIVE);
                user.setUpdatedAt(LocalDateTime.now());
                userDAO.update(user);
                return true;
            }
        }
        return false;
    }

    // ==================== GESTION DES RÔLES ====================

    public boolean changeRole(Long userId, Role newRole) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setRole(newRole);
            user.setUpdatedAt(LocalDateTime.now());
            userDAO.update(user);
            return true;
        }
        return false;
    }

    // ==================== MODIFICATION DES INFORMATIONS ====================

    public boolean updateUserInfo(Long userId, String firstName, String lastName, String email) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setEmail(email);
            user.setUpdatedAt(LocalDateTime.now());
            userDAO.update(user);
            return true;
        }
        return false;
    }

    public boolean changePassword(Long userId, String newPassword) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
            user.setPassword(hashedPassword);
            user.setUpdatedAt(LocalDateTime.now());
            userDAO.update(user);
            return true;
        }
        return false;
    }

    // ==================== HISTORIQUE DES EMPRUNTS ====================

    public List<Loan> getUserLoanHistory(Long userId) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isPresent()) {
            return loanDAO.findByUser(userOpt.get());
        }
        return List.of();
    }

    public List<Loan> getUserActiveLoans(Long userId) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isPresent()) {
            return loanDAO.findActiveLoansByUser(userOpt.get());
        }
        return List.of();
    }

    public long countUserActiveLoans(Long userId) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isPresent()) {
            return loanDAO.countActiveLoansByUser(userOpt.get());
        }
        return 0;
    }

    // ==================== GESTION DES PÉNALITÉS ====================

    public void createPenalty(User user, Loan loan, Double amount, String reason) {
        Penalty penalty = new Penalty(user, loan, amount, reason);
        penaltyDAO.save(penalty);
    }

    public List<Penalty> getUserPenalties(Long userId) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isPresent()) {
            return penaltyDAO.findByUser(userOpt.get());
        }
        return List.of();
    }

    public List<Penalty> getUserUnpaidPenalties(Long userId) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isPresent()) {
            return penaltyDAO.findUnpaidByUser(userOpt.get());
        }
        return List.of();
    }

    public double getUserTotalPenalties(Long userId) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isPresent()) {
            return penaltyDAO.getTotalUnpaidByUser(userOpt.get());
        }
        return 0.0;
    }

    public boolean payPenalty(Long penaltyId) {
        Optional<Penalty> penaltyOpt = penaltyDAO.findById(penaltyId);
        if (penaltyOpt.isPresent() && penaltyOpt.get().isUnpaid()) {
            penaltyDAO.payPenalty(penaltyId);
            return true;
        }
        return false;
    }

    public boolean cancelPenalty(Long penaltyId) {
        Optional<Penalty> penaltyOpt = penaltyDAO.findById(penaltyId);
        if (penaltyOpt.isPresent() && penaltyOpt.get().isUnpaid()) {
            penaltyDAO.cancelPenalty(penaltyId);
            return true;
        }
        return false;
    }

    public boolean canBorrow(Long userId) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isEmpty() || userOpt.get().getStatus() != UserStatus.ACTIVE) {
            return false;
        }

        long activeLoans = countUserActiveLoans(userId);
        if (activeLoans >= 3) {
            return false;
        }

        double totalPenalties = getUserTotalPenalties(userId);
        if (totalPenalties >= 10.0) {
            return false;
        }

        long overdueCount = getUserActiveLoans(userId).stream()
                .filter(Loan::isOverdue)
                .count();
        if (overdueCount >= 3) {
            return false;
        }

        return true;
    }

    // ==================== STATISTIQUES ====================

    public long getTotalUsers() {
        return userDAO.findAll().size();
    }

    public long getTotalMembers() {
        return getAllMembers().size();
    }

    public long getTotalLibrarians() {
        return getAllLibrarians().size();
    }

    public long getTotalAdmins() {
        return getAllAdmins().size();
    }

    public long getActiveUsersCount() {
        return getActiveUsers().size();
    }

    public long getPendingUsersCount() {
        return getPendingUsers().size();
    }

    public long getSuspendedUsersCount() {
        return getSuspendedUsers().size();
    }

    public void close() {
        userDAO.close();
        loanDAO.close();
        penaltyDAO.close();
    }
}