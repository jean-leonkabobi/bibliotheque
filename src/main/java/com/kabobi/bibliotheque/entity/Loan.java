package com.kabobi.bibliotheque.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "loan")
public class Loan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "document_id", nullable = false)
    private Long documentId;

    @Column(name = "document_type", nullable = false)
    private String documentType;  // BOOK, CD, DVD

    @Column(name = "loan_date", nullable = false)
    private LocalDateTime loanDate;

    @Column(name = "due_date", nullable = false)
    private LocalDateTime dueDate;

    @Column(name = "return_date")
    private LocalDateTime returnDate;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private LoanStatus status;

    @Column(name = "renewal_count", nullable = false)
    private int renewalCount;

    public Loan() {
        this.loanDate = LocalDateTime.now();
        this.dueDate = this.loanDate.plusDays(15); // 15 jours par défaut
        this.status = LoanStatus.ACTIVE;
        this.renewalCount = 0;
    }

    public Loan(User user, Long documentId, String documentType) {
        this();
        this.user = user;
        this.documentId = documentId;
        this.documentType = documentType;
    }

    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public Long getDocumentId() { return documentId; }
    public void setDocumentId(Long documentId) { this.documentId = documentId; }

    public String getDocumentType() { return documentType; }
    public void setDocumentType(String documentType) { this.documentType = documentType; }

    public LocalDateTime getLoanDate() { return loanDate; }
    public void setLoanDate(LocalDateTime loanDate) { this.loanDate = loanDate; }

    public LocalDateTime getDueDate() { return dueDate; }
    public void setDueDate(LocalDateTime dueDate) { this.dueDate = dueDate; }

    public LocalDateTime getReturnDate() { return returnDate; }
    public void setReturnDate(LocalDateTime returnDate) { this.returnDate = returnDate; }

    public LoanStatus getStatus() { return status; }
    public void setStatus(LoanStatus status) { this.status = status; }

    public int getRenewalCount() { return renewalCount; }
    public void setRenewalCount(int renewalCount) { this.renewalCount = renewalCount; }

    // Méthodes utilitaires
    public boolean isOverdue() {
        if (status != LoanStatus.ACTIVE) return false;
        return LocalDateTime.now().isAfter(dueDate);
    }

    public boolean canRenew() {
        return status == LoanStatus.ACTIVE && renewalCount < 1;
    }

    public long getDaysOverdue() {
        if (!isOverdue()) return 0;
        return java.time.Duration.between(dueDate, LocalDateTime.now()).toDays();
    }

    public double calculatePenalty() {
        if (!isOverdue()) return 0;
        return getDaysOverdue() * 0.50; // 0.50€ par jour de retard
    }

    public void renew() {
        if (canRenew()) {
            this.dueDate = this.dueDate.plusDays(7);
            this.renewalCount++;
        }
    }

    // Méthode pour les jours restants (utilisée dans la JSP)
    public long getRemainingDays() {
        if (status != LoanStatus.ACTIVE) return 0;
        long days = java.time.Duration.between(LocalDateTime.now(), dueDate).toDays();
        return days > 0 ? days : 0;
    }

    // Getter pour canRenew (utilisé dans la JSP comme propriété)
    public boolean isCanRenew() {
        return canRenew();
    }

    public void returnLoan() {
        this.returnDate = LocalDateTime.now();
        this.status = LoanStatus.RETURNED;
    }

    public java.util.Date getLoanDateAsDate() {
        if (loanDate == null) return null;
        return java.util.Date.from(loanDate.atZone(java.time.ZoneId.systemDefault()).toInstant());
    }

    public java.util.Date getDueDateAsDate() {
        if (dueDate == null) return null;
        return java.util.Date.from(dueDate.atZone(java.time.ZoneId.systemDefault()).toInstant());
    }

    public java.util.Date getReturnDateAsDate() {
        if (returnDate == null) return null;
        return java.util.Date.from(returnDate.atZone(java.time.ZoneId.systemDefault()).toInstant());
    }
}