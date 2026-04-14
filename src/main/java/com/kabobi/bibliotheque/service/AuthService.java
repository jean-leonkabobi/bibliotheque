package com.kabobi.bibliotheque.service;

import com.kabobi.bibliotheque.dao.UserDAO;
import com.kabobi.bibliotheque.entity.User;
import com.kabobi.bibliotheque.entity.UserStatus;
import org.mindrot.jbcrypt.BCrypt;

import java.util.Optional;

public class AuthService {

    private final UserDAO userDAO;

    public AuthService() {
        this.userDAO = new UserDAO();
    }

    public boolean register(User user, String rawPassword) {
        try {
            // Vérifier si l'email existe déjà
            if (userDAO.findByEmail(user.getEmail()).isPresent()) {
                return false;
            }

            // Hasher le mot de passe
            String hashedPassword = BCrypt.hashpw(rawPassword, BCrypt.gensalt());
            user.setPassword(hashedPassword);

            // Sauvegarder l'utilisateur
            userDAO.save(user);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Optional<User> login(String email, String password) {
        try {
            Optional<User> userOpt = userDAO.findByEmail(email);

            if (userOpt.isPresent()) {
                User user = userOpt.get();

                // Vérifier le mot de passe
                if (BCrypt.checkpw(password, user.getPassword())) {
                    // Vérifier que le compte est actif
                    if (user.getStatus() == UserStatus.ACTIVE) {
                        return Optional.of(user);
                    }
                }
            }
            return Optional.empty();
        } catch (Exception e) {
            e.printStackTrace();
            return Optional.empty();
        }
    }

    public boolean validateUser(Long userId) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (user.getStatus() == UserStatus.PENDING) {
                user.setStatus(UserStatus.ACTIVE);
                userDAO.update(user);
                return true;
            }
        }
        return false;
    }

    public boolean suspendUser(Long userId) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setStatus(UserStatus.SUSPENDED);
            userDAO.update(user);
            return true;
        }
        return false;
    }

    public boolean activateUser(Long userId) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setStatus(UserStatus.ACTIVE);
            userDAO.update(user);
            return true;
        }
        return false;
    }
}