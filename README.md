# 🏦 Banking Security System
### 21CSC205P — Database Management Systems | Mini Project

> A structured relational database solution for managing banking operations alongside advanced security monitoring and activity tracking.

---

## 👥 Team

| Name | Roll Number |
|------|-------------|
| Aryan Singh | RA2411030010159 |
| Harmandeep Singh | RA2411030010150 |

**Guide:** Dr. G. Parimala, Assistant Professor, NWC  
**Department:** Networking and Communications, School of Computing  
**Institution:** SRM Institute of Science and Technology, Kattankulathur – 603 203

---

## 📌 About the Project

Modern banking platforms need to do more than just store account and transaction data — they need to track *who* accessed the system, *from where*, *on what device*, and *when*, so that suspicious behaviour can be detected and investigated.

This project designs a complete relational database that integrates:
- Core banking (users, accounts, transactions)
- Session and activity tracking (logins, HTTP request logs, devices, IP addresses)
- Security monitoring (security events reviewed by admins)

The database is designed using the **Entity–Relationship (ER) model**, mapped to a relational schema, and implemented in **MySQL**.

---

## 🗂️ Repository Structure

```
BankingSecuritySystem/
│
├── BankingSecuritySystem_FULL.sql       ← Run this first — creates DB, all tables, inserts data, and runs all queries
├── BankingSecuritySystem_ViewAll.sql    ← Run after FULL — DESC + SELECT * for every table
└── README.md                            ← You are here
```

---
