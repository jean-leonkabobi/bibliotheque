<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Mot de passe oublié - Bibliothèque</title>
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
        <h1>Mot de passe oublié</h1>
      </div>
      <p class="subtitle">Entrez votre email pour réinitialiser votre mot de passe</p>
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

    <form action="${pageContext.request.contextPath}/forgot-password" method="post" class="auth-form">
      <div class="form-group">
        <label for="email">
          <i class="fas fa-envelope label-icon"></i>
          Adresse email
        </label>
        <input type="email" id="email" name="email" required placeholder="exemple@email.com">
      </div>

      <button type="submit" class="btn btn-primary btn-block">
        <i class="fas fa-paper-plane"></i>
        <span>Envoyer le lien</span>
      </button>
    </form>

    <div class="auth-footer">
      <p><a href="${pageContext.request.contextPath}/login">
        <i class="fas fa-arrow-left"></i> Retour à la connexion
      </a></p>
    </div>
  </div>
</div>
</body>
</html>