<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nouvel emprunt - Bibliothèque</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .form-card {
            background: white;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            max-width: 700px;
            margin: 0 auto;
            border: 1px solid #E2E8F0;
        }
        .info-card {
            background: #EFF6FF;
            border-radius: 12px;
            padding: 20px;
            margin: 25px 0;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .info-card i {
            font-size: 28px;
            color: #38BDF8;
        }
        .info-card .content h4 {
            margin-bottom: 5px;
            color: #0F172A;
            font-size: 15px;
        }
        .info-card .content p {
            color: #64748B;
            font-size: 13px;
            line-height: 1.5;
        }
        .warning-card {
            background: #FEF2F2;
        }
        .warning-card i {
            color: #EF4444;
        }
        .form-group small {
            color: #64748B;
            font-size: 12px;
            margin-top: 5px;
            display: block;
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
            <a href="${pageContext.request.contextPath}/librarian/dashboard" class="nav-item"><i class="fas fa-chart-line"></i><span>Tableau de bord</span></a>
            <a href="${pageContext.request.contextPath}/librarian/members" class="nav-item"><i class="fas fa-users"></i><span>Membres</span></a>
            <a href="${pageContext.request.contextPath}/librarian/documents" class="nav-item"><i class="fas fa-book"></i><span>Ouvrages</span></a>
            <a href="${pageContext.request.contextPath}/librarian/loans" class="nav-item active"><i class="fas fa-exchange-alt"></i><span>Emprunts</span></a>
            <a href="${pageContext.request.contextPath}/librarian/validate" class="nav-item"><i class="fas fa-check-circle"></i><span>Validations</span></a>
            <a href="${pageContext.request.contextPath}/librarian/penalties" class="nav-item"><i class="fas fa-euro-sign"></i><span>Pénalités</span></a>
        </nav>
    </aside>

    <main class="main-content">
        <header class="top-bar">
            <div class="user-info">
                <div class="user-avatar">${sessionScope.user.firstName.charAt(0)}${sessionScope.user.lastName.charAt(0)}</div>
                <div class="user-details">
                    <span class="user-name">${sessionScope.user.firstName} ${sessionScope.user.lastName}</span>
                    <span class="user-role">Bibliothécaire</span>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Déconnexion</a>
        </header>

        <div class="content">
            <div class="page-header">
                <a href="${pageContext.request.contextPath}/librarian/loans" class="btn-link"><i class="fas fa-arrow-left"></i> Retour à la liste</a>
                <h1><i class="fas fa-plus-circle"></i> Nouvel emprunt</h1>
                <p class="info-text">Enregistrez un emprunt pour un membre de la bibliothèque</p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
            </c:if>

            <div class="form-card">
                <form action="${pageContext.request.contextPath}/librarian/loans/create" method="post">
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

                    <div class="info-card warning-card">
                        <i class="fas fa-shield-alt"></i>
                        <div class="content">
                            <h4>Vérifications automatiques</h4>
                            <p>Le système vérifie que le membre n'a pas déjà 3 emprunts en cours et qu'il n'a pas plus de 10€ de pénalités impayées.</p>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Enregistrer l'emprunt</button>
                        <a href="${pageContext.request.contextPath}/librarian/loans" class="btn-secondary"><i class="fas fa-times"></i> Annuler</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>