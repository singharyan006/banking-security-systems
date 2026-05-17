-- ============================================================
--   BANKING SECURITY SYSTEM — COMPLETE SQL SETUP SCRIPT
--   Run this file top-to-bottom on a fresh MySQL instance.
-- ============================================================


-- ------------------------------------------------------------
-- 1. DATABASE
-- ------------------------------------------------------------

CREATE DATABASE IF NOT EXISTS BankingSecuritySystem;
USE BankingSecuritySystem;


-- ------------------------------------------------------------
-- 2. INDEPENDENT TABLES (no foreign keys)
-- ------------------------------------------------------------

-- 2.1  USER
CREATE TABLE USER (
    user_id   INT          PRIMARY KEY AUTO_INCREMENT,
    f_name    VARCHAR(100) NOT NULL,
    l_name    VARCHAR(100) NOT NULL,
    email     VARCHAR(255) NOT NULL UNIQUE,
    phone     BIGINT,
    password  VARCHAR(255) NOT NULL,
    status    VARCHAR(50)  NOT NULL
        COMMENT 'Active | Blocked | Suspended'
);
