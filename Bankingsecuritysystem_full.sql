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

-- 2.2  DEVICE
CREATE TABLE DEVICE (
    device_id INT          PRIMARY KEY AUTO_INCREMENT,
    browser   VARCHAR(100) NOT NULL,
    os        VARCHAR(100) NOT NULL
);

-- 2.3  IP_ADDRESS
CREATE TABLE IP_ADDRESS (
    ip_id      INT         PRIMARY KEY AUTO_INCREMENT,
    ip_address VARCHAR(45) NOT NULL,
    city       VARCHAR(100),
    country    VARCHAR(100)
);

-- 2.4  REFERRER
CREATE TABLE REFERRER (
    referrer_id  INT          PRIMARY KEY AUTO_INCREMENT,
    referrer_url VARCHAR(255) NOT NULL
);

-- 2.5  ADMIN
CREATE TABLE ADMIN (
    admin_id INT         PRIMARY KEY AUTO_INCREMENT,
    name     VARCHAR(100) NOT NULL,
    role     VARCHAR(50)  NOT NULL
        COMMENT 'Security Analyst | System Admin'
);


-- ------------------------------------------------------------
-- 3. DEPENDENT TABLES (with foreign keys)
-- ------------------------------------------------------------

-- 3.1  ACCOUNT  (depends on USER)
CREATE TABLE ACCOUNT (
    account_id   INT            PRIMARY KEY AUTO_INCREMENT,
    account_type VARCHAR(50)    NOT NULL
        COMMENT 'Savings | Current',
    balance      DECIMAL(15, 2) NOT NULL,
    created_at   DATETIME       NOT NULL,
    user_id      INT            NOT NULL,
    CONSTRAINT fk_account_user
        FOREIGN KEY (user_id) REFERENCES USER (user_id)
);
