package com.kabobi.bibliotheque.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    public static String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }

    public static boolean verifyPassword(String password, String hashedPassword) {
        return BCrypt.checkpw(password, hashedPassword);
    }

    public static void main(String[] args) {
        // Pour générer des mots de passe hashés
        String adminPassword = "admin123";
        String librarianPassword = "lib123";
        String memberPassword = "member123";

        System.out.println("Hash pour admin123: " + hashPassword(adminPassword));
        System.out.println("Hash pour lib123: " + hashPassword(librarianPassword));
        System.out.println("Hash pour member123: " + hashPassword(memberPassword));
    }
}