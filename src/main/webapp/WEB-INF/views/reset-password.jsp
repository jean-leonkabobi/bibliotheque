<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Réinitialisation - Bibliothèque</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .password-strength {
            margin-top: 8px;
        }
        .strength-bar {
            height: 4px;
            background: #E2E8F0;
            border-radius: 2px;
            width: 0;
            transition: all 0.3s ease;
        }
        .strength-text {
            font-size: 11px;
            margin-top: 5px;
            display: block;
        }
        .form-hint {
            font-size: 11px;
            margin-top: 5px;
        }
    </style>
</head>
<body class="auth-page">
<div class="auth-container">
    <div class="auth-card">
        <div class="auth-header">
            <div class="logo">
                <i class="fas fa-book-open logo-icon"></i>
                <h1>Nouveau mot de passe</h1>
            </div>
            <p class="subtitle">Choisissez un nouveau mot de passe</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle alert-icon"></i>
                <span class="alert-message">${error}</span>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/reset-password" method="post" class="auth-form">
            <input type="hidden" name="email" value="${email}">
            <input type="hidden" name="token" value="${token}">

            <div class="form-group">
                <label for="newPassword">
                    <i class="fas fa-lock label-icon"></i>
                    Nouveau mot de passe
                </label>
                <div class="password-input">
                    <input type="password" id="newPassword" name="newPassword" required placeholder="Minimum 6 caractères">
                    <button type="button" class="toggle-password" onclick="togglePassword('newPassword')">
                        <i class="fas fa-eye"></i>
                    </button>
                </div>
                <small><i class="fas fa-info-circle"></i> Minimum 6 caractères</small>
                <div class="password-strength">
                    <div class="strength-bar"></div>
                    <span class="strength-text"></span>
                </div>
            </div>

            <div class="form-group">
                <label for="confirmPassword">
                    <i class="fas fa-check-double label-icon"></i>
                    Confirmer le mot de passe
                </label>
                <div class="password-input">
                    <input type="password" id="confirmPassword" name="confirmPassword" required placeholder="Confirmez votre mot de passe">
                    <button type="button" class="toggle-password" onclick="togglePassword('confirmPassword')">
                        <i class="fas fa-eye"></i>
                    </button>
                </div>
                <div id="passwordMatch" class="form-hint"></div>
            </div>

            <button type="submit" class="btn btn-primary btn-block">
                <i class="fas fa-save"></i>
                <span>Modifier le mot de passe</span>
            </button>
        </form>

        <div class="auth-footer">
            <p><a href="${pageContext.request.contextPath}/login">
                <i class="fas fa-arrow-left"></i> Retour à la connexion
            </a></p>
        </div>
    </div>
</div>

<script>
    function togglePassword(inputId) {
        const passwordInput = document.getElementById(inputId);
        const icon = document.querySelector(`#${inputId} + .toggle-password i`);
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

    const passwordInput = document.getElementById('newPassword');
    const confirmInput = document.getElementById('confirmPassword');
    const strengthBar = document.querySelector('.strength-bar');
    const strengthText = document.querySelector('.strength-text');
    const passwordMatch = document.getElementById('passwordMatch');

    function checkPasswordStrength(password) {
        let strength = 0;
        let message = '';
        let color = '';

        if (password.length >= 6) strength++;
        if (password.length >= 10) strength++;
        if (password.match(/[a-z]+/)) strength++;
        if (password.match(/[A-Z]+/)) strength++;
        if (password.match(/[0-9]+/)) strength++;
        if (password.match(/[$@#&!]+/)) strength++;

        if (password.length === 0) {
            message = '';
            color = '#E2E8F0';
        } else if (strength <= 2) {
            message = 'Mot de passe faible';
            color = '#EF4444';
        } else if (strength <= 4) {
            message = 'Mot de passe moyen';
            color = '#F59E0B';
        } else {
            message = 'Mot de passe fort';
            color = '#10B981';
        }

        strengthBar.style.width = (strength / 6 * 100) + '%';
        strengthBar.style.backgroundColor = color;
        strengthText.textContent = message;
        strengthText.style.color = color;
    }

    function checkPasswordMatch() {
        if (confirmInput.value.length > 0) {
            if (passwordInput.value === confirmInput.value) {
                passwordMatch.textContent = '✓ Les mots de passe correspondent';
                passwordMatch.style.color = '#10B981';
                return true;
            } else {
                passwordMatch.textContent = '✗ Les mots de passe ne correspondent pas';
                passwordMatch.style.color = '#EF4444';
                return false;
            }
        } else {
            passwordMatch.textContent = '';
            return true;
        }
    }

    passwordInput.addEventListener('input', function() {
        checkPasswordStrength(this.value);
        checkPasswordMatch();
    });

    confirmInput.addEventListener('input', function() {
        checkPasswordMatch();
    });
</script>
</body>
</html>