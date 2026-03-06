-- ============================
-- DATABASE SETUP SCRIPT
-- Employee Management System
-- ============================

-- 1. Tạo database (chạy lệnh này trước)
CREATE DATABASE PRJ301;
GO

USE PRJ301;
GO

-- 2. Bảng users (tài khoản đăng nhập)
CREATE TABLE users (
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(50),
    role     VARCHAR(20)  -- 'manager' hoặc 'staff'
);

-- 3. Bảng departments (phòng ban)
CREATE TABLE departments (
    id   INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100)
);

-- 4. Bảng employees (nhân viên)
CREATE TABLE employees (
    id         INT PRIMARY KEY IDENTITY(1,1),
    name       VARCHAR(100),
    gender     VARCHAR(10),
    salary     FLOAT,
    dept_id    INT FOREIGN KEY REFERENCES departments(id),
    created_by VARCHAR(50) FOREIGN KEY REFERENCES users(username)
);

-- ============================
-- DỮ LIỆU MẪU
-- ============================

INSERT INTO users (username, password, role) VALUES
('admin',  'admin123', 'manager'),
('staff1', 'staff123', 'staff');

INSERT INTO departments (name) VALUES
('IT'),
('HR'),
('Finance');

INSERT INTO employees (name, gender, salary, dept_id, created_by) VALUES
('Nguyen Van A', 'Male',   15000000, 1, 'admin'),
('Tran Thi B',  'Female', 20000000, 2, 'admin'),
('Le Van C',    'Male',   18000000, 3, 'staff1'),
('Pham Thi D',  'Female', 25000000, 1, 'staff1'),
('Hoang Van E', 'Male',   30000000, 2, 'admin');
GO
