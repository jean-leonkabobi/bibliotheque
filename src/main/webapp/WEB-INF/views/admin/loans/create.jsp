<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nouvel emprunt - Administration</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .info-card {
            background: #F8FAFC;
            border-radius: 12px;
            padding: 20px;
            margin: 20px 0;
            display: flex;
            gap: 15px;
            align-items: flex-start;
        }
        .info-card i {
            font-size: 24px;
            color: #38BDF8;
        }
        .info-card.warning i {
            color: #F59E0B;
        }
        .info-card .content h4 {
            margin-bottom: 5px;
            color: #0F172A;
        }
        .info-card .content p {
            color: #64748B;
            font-size: 13px;
            line-height: 1.5;
        }
        .form-container {
            max-width: 700px;
            margin: 0 auto;
        }
    </style>
</head>
<body>
<div class="dashboard">
    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="logo">
                <i class="fas fa-book-open logo-icon"></i>
                <h2>Bibliothèque</h2>
            </div>
        </div>
        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item"><i class="fas fa-chart-line"></i><span>Tableau de bord</span></a>
            <a href="${pageContext.request.contextPath}/admin/members" class="nav-item"><i class="fas fa-users"></i><span>Adhérents</span></a>
            <a href="${pageContext.request.contextPath}/admin/documents" class="nav-item"><i class="fas fa-book"></i><span>Ouvrages</span></a>
            <a href="${pageContext.request.contextPath}/admin/loans" class="nav-item active"><i class="fas fa-exchange-alt"></i><span>Emprunts</span></a>
        </nav>
    </aside>

    <main class="main-content">
        <header class="top-bar">
            <div class="user-info">
                <div class="user-avatar">${sessionScope.user.firstName.charAt(0)}${sessionScope.user.lastName.charAt(0)}</div>
                <div class="user-details">
                    <span class="user-name">${sessionScope.user.firstName} ${sessionScope.user.lastName}</span>
                    <span class="user-role">Administrateur</span>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Déconnexion</a>
        </header>

        <div class="content">
            <div class="page-header">
                <div>
                    <a href="${pageContext.request.contextPath}/admin/loans" class="btn-link"><i class="fas fa-arrow-left"></i> Retour à la liste</a>
                    <h1><i class="fas fa-plus-circle"></i> Nouvel emprunt</h1>
                    <p class="info-text">Enregistrez un nouvel emprunt pour un membre</p>
                </div>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
            </c:if>

            <div class="form-container">
                <form action="${pageContext.request.contextPath}/admin/loans/create" method="post" class="form">
                    <div class="form-group">
                        <label><i class="fas fa-user"></i> Membre emprunteur <span class="required">*</span></label>
                        <select name="userId" required>
                            <option value="">-- Sélectionner un membre --</option>
                            <c:forEach items="${members}" var="member">
                                <option value="${member.id}">${member.firstName} ${member.lastName} (${member.email})</option>
                            </c:forEach>
                        </select>
                        <small><i class="fas fa-info-circle"></i> Seuls les membres actifs peuvent emprunter</small>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label><i class="fas fa-tag"></i> Type de document <span class="required">*</span></label>
                            <select name="documentType" required>
                                <option value="BOOK"><i class="fas fa-book"></i> Livre</option>
                                <option value="CD"><i class="fas fa-compact-disc"></i> CD</option>
                                <option value="DVD"><i class="fas fa-film"></i> DVD</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label><i class="fas fa-hashtag"></i> ID du document <span class="required">*</span></label>
                            <input type="number" name="documentId" placeholder="Ex: 1, 2, 3..." required>
                            <small><i class="fas fa-info-circle"></i> Vérifiez l'ID dans la liste des ouvrages</small>
                        </div>
                    </div>

                    <div class="info-card">
                        <i class="fas fa-info-circle"></i>
                        <div class="content">
                            <h4>Conditions d'emprunt</h4>
                            <p>Durée d'emprunt : 15 jours • Un seul renouvellement possible (7 jours supplémentaires)</p>
                        </div>
                    </div>

                    <div class="info-card warning">
                        <i class="fas fa-shield-alt"></i>
                        <div class="content">
                            <h4>Vérifications automatiques</h4>
                            <p>Le système vérifie que le membre n'a pas déjà 3 emprunts en cours et qu'il n'a pas plus de 10€ de pénalités impayées.</p>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Enregistrer l'emprunt</button>
                        <a href="${pageContext.request.contextPath}/admin/loans" class="btn-secondary"><i class="fas fa-times"></i> Annuler</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>