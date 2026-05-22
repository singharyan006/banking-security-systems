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

-- 3.2  SESSION  (depends on USER)
CREATE TABLE SESSION (
    session_id  INT      PRIMARY KEY AUTO_INCREMENT,
    login_time  DATETIME NOT NULL,
    logout_time DATETIME,                  -- NULL until the user logs out
    user_id     INT      NOT NULL,
    CONSTRAINT fk_session_user
        FOREIGN KEY (user_id) REFERENCES USER (user_id)
);

-- 3.3  BANK_TRANSACTION  (depends on ACCOUNT)
--      Named BANK_TRANSACTION to avoid conflict with the SQL keyword TRANSACTION
CREATE TABLE BANK_TRANSACTION (
    transaction_id   INT            PRIMARY KEY AUTO_INCREMENT,
    amount           DECIMAL(15, 2) NOT NULL,
    transaction_time DATETIME       NOT NULL,
    account_id       INT            NOT NULL,
    CONSTRAINT fk_txn_account
        FOREIGN KEY (account_id) REFERENCES ACCOUNT (account_id)
);

-- 3.4  REQUEST_LOG  (weak entity — composite PK; depends on SESSION, DEVICE, IP_ADDRESS, REFERRER)
CREATE TABLE REQUEST_LOG (
    session_id   INT          NOT NULL,
    request_id   INT          NOT NULL,
    request_time DATETIME     NOT NULL,
    url_accessed VARCHAR(255) NOT NULL,
    method       VARCHAR(20)  NOT NULL
        COMMENT 'GET | POST | PUT | DELETE …',
    device_id    INT          NOT NULL,
    ip_id        INT          NOT NULL,
    referrer_id  INT,                      -- nullable: direct traffic has no referrer

    PRIMARY KEY (session_id, request_id),

    CONSTRAINT fk_reqlog_session
        FOREIGN KEY (session_id)  REFERENCES SESSION    (session_id),
    CONSTRAINT fk_reqlog_device
        FOREIGN KEY (device_id)   REFERENCES DEVICE     (device_id),
    CONSTRAINT fk_reqlog_ip
        FOREIGN KEY (ip_id)       REFERENCES IP_ADDRESS (ip_id),
    CONSTRAINT fk_reqlog_referrer
        FOREIGN KEY (referrer_id) REFERENCES REFERRER   (referrer_id)
);

-- 3.5  SECURITY_EVENT  (depends on SESSION, ADMIN)
CREATE TABLE SECURITY_EVENT (
    event_id    INT          PRIMARY KEY AUTO_INCREMENT,
    event_type  VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    risk_level  VARCHAR(20)
        COMMENT 'Low | Medium | High',
    session_id  INT          NOT NULL,
    admin_id    INT          NOT NULL,
    CONSTRAINT fk_secevent_session
        FOREIGN KEY (session_id) REFERENCES SESSION (session_id),
    CONSTRAINT fk_secevent_admin
        FOREIGN KEY (admin_id)   REFERENCES ADMIN   (admin_id)
);


-- ============================================================
--   DONE — all 10 tables created in dependency order.
--   Tables: USER, DEVICE, IP_ADDRESS, REFERRER, ADMIN,
--           ACCOUNT, SESSION, BANK_TRANSACTION,
--           REQUEST_LOG, SECURITY_EVENT
-- ============================================================
-- ============================================================
--   BANKING SECURITY SYSTEM — ALL QUERIES
--   Run BankingSecuritySystem_Complete.sql first (DDL + setup)
-- ============================================================

USE BankingSecuritySystem;


-- ============================================================
-- SECTION 1: DML — INSERT DATA
-- ============================================================

INSERT INTO USER (f_name, l_name, email, phone, password, status)
VALUES
    ('Aryan', 'Singh',  'aryan.singh@gmail.com', 9876543210, 'hashed_pass1', 'Active'),
    ('Riya',  'Sharma', 'riya.sharma@gmail.com', 9123456780, 'hashed_pass2', 'Active'),
    ('Karan', 'Mehta',  'karan.mehta@gmail.com', 9988776655, 'hashed_pass3', 'Blocked');

INSERT INTO DEVICE (browser, os)
VALUES
    ('Chrome',  'Windows'),
    ('Safari',  'iOS'),
    ('Firefox', 'Linux');

INSERT INTO IP_ADDRESS (ip_address, city, country)
VALUES
    ('192.168.1.1', 'Chennai', 'India'),
    ('172.16.0.5',  'Mumbai',  'India'),
    ('10.0.0.2',    'Delhi',   'India');

INSERT INTO REFERRER (referrer_url)
VALUES
    ('https://www.google.com'),
    ('https://www.bankapp.com/login'),
    ('https://mail.google.com');

INSERT INTO ADMIN (name, role)
VALUES
    ('Rahul Verma', 'Security Analyst'),
    ('Neha Kapoor', 'System Administrator');

INSERT INTO ACCOUNT (account_type, balance, created_at, user_id)
VALUES
    ('Savings', 50000.00,  '2025-01-10 10:30:00', 1),
    ('Current', 120000.50, '2025-02-15 14:20:00', 2),
    ('Savings', 30000.75,  '2025-03-05 09:10:00', 3);

INSERT INTO SESSION (login_time, logout_time, user_id)
VALUES
    ('2025-04-01 08:00:00', '2025-04-01 09:15:00', 1),
    ('2025-04-02 10:30:00', '2025-04-02 11:00:00', 2),
    ('2025-04-03 18:45:00', NULL,                  3);

INSERT INTO BANK_TRANSACTION (amount, transaction_time, account_id)
VALUES
    (2500.00,  '2025-04-01 08:30:00', 1),
    (10000.00, '2025-04-02 10:45:00', 2),
    (1500.00,  '2025-04-03 19:00:00', 3);

INSERT INTO REQUEST_LOG (session_id, request_id, request_time, url_accessed, method, device_id, ip_id, referrer_id)
VALUES
    (1, 1, '2025-04-01 08:05:00', '/login',       'POST', 1, 1, 1),
    (1, 2, '2025-04-01 08:10:00', '/viewAccount', 'GET',  1, 1, 2),
    (2, 1, '2025-04-02 10:35:00', '/transfer',    'POST', 2, 2, 1),
    (3, 1, '2025-04-03 18:50:00', '/login',       'POST', 3, 3, 3);

INSERT INTO SECURITY_EVENT (event_type, description, risk_level, session_id, admin_id)
VALUES
    ('Suspicious Login',  'Login detected from unknown device',    'High',   3, 1),
    ('Multiple Requests', 'Unusual number of requests in session', 'Medium', 1, 2);


-- ============================================================
-- SECTION 2: CONSTRAINTS
-- ============================================================

-- Q1: Ensure account balance is non-negative
ALTER TABLE ACCOUNT
ADD CONSTRAINT chk_balance CHECK (balance >= 0);

-- Q2: Ensure email is unique
ALTER TABLE USER
ADD CONSTRAINT unique_email UNIQUE (email);

-- Q3: Restrict risk_level to valid values only
ALTER TABLE SECURITY_EVENT
ADD CONSTRAINT chk_risk CHECK (risk_level IN ('Low', 'Medium', 'High'));

