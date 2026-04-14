<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - Bibliothèque</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body class="auth-page">
<div class="auth-container">
    <div class="auth-card">
        <div class="auth-header">
            <div class="logo">
                <i class="fas fa-book-open logo-icon"></i>
                <h1>Bibliothèque</h1>
            </div>
            <p class="subtitle">Connectez-vous à votre espace</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle alert-icon"></i>
                <span class="alert-message">${error}</span>
            </div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle alert-icon"></i>
                <span class="alert-message">${success}</span>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post" class="auth-form">
            <div class="form-group">
                <label for="email">
                    <i class="fas fa-envelope label-icon"></i>
                    Adresse email
                </label>
                <input type="email"
                       id="email"
                       name="email"
                       required
                       placeholder="exemple@email.com"
                       value="${param.email}">
            </div>

            <div class="form-group">
                <label for="password">
                    <i class="fas fa-lock label-icon"></i>
                    Mot de passe
                </label>
                <div class="password-input">
                    <input type="password"
                           id="password"
                           name="password"
                           required
                           placeholder="Votre mot de passe">
                    <button type="button" class="toggle-password" onclick="togglePassword('password')">
                        <i class="fas fa-eye"></i>
                    </button>
                </div>
            </div>

            <div class="form-options">
                <label class="checkbox-label">
                    <input type="checkbox" name="remember-me">
                    <i class="fas fa-check-square checkbox-icon"></i>
                    <span>Se souvenir de moi</span>
                </label>
                <a href="${pageContext.request.contextPath}/forgot-password" class="forgot-password">
                    <i class="fas fa-question-circle"></i> Mot de passe oublié ?
                </a>
            </div>

            <button type="submit" class="btn btn-primary btn-block">
                <i class="fas fa-sign-in-alt"></i>
                <span>Se connecter</span>
            </button>
        </form>

        <div class="auth-footer">
            <p>Pas encore de compte ? <a href="${pageContext.request.contextPath}/register">
                <i class="fas fa-user-plus"></i> S'inscrire
            </a></p>
        </div>
    </div>
</div>

<script>
    function togglePassword(inputId) {
        const passwordInput = document.getElementById(inputId);
        const icon = document.querySelector('.toggle-password i');
        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            icon.classList.remove('fa-eye');
            icon.classList.add('fa-eye-slash');
        } else {
            passwordInput.type = 'password';
            icon.classList.remove('fa-eye-slash');
            icon.classList.add('fa-eye');
        }
    }
</script>
</body>
</html>