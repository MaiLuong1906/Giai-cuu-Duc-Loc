---
description: Workflow toàn bộ dự án Employee Management System (Java Web)
---

# Employee Management System — Project Workflow

## Tổng quan kiến trúc MVC

```
Browser
  │
  ▼
AuthFilter (/employee) ──── nếu chưa login ──► LoginController ──► login.jsp
  │
  ▼
EmployeeController (/employee)
  │          │
  │          ├── gọi EmployeeDAO (getAllEmployees, getTop5HighestPaid)
  │          ├── gọi DepartmentDAO (getAllDepartments)
  │          └── set attributes → forward ► employee.jsp (JSTL/EL)
  │
  └── doPost(action=add/update)
           └── gọi EmployeeDAO (addEmployee / updateEmployee)
                    └── redirect ► /employee
```

---

## Bước 1 — Chuẩn bị Database

Mở **SQL Server Management Studio (SSMS)**, chạy file `setup_database.sql`:

```sql
-- Tạo DB và bảng
CREATE DATABASE PRJ301;
...
-- Chạy toàn bộ file setup_database.sql trong thư mục gốc project
```

**Tài khoản mẫu:**
| Username | Password | Role |
|----------|----------|------|
| admin | admin123 | manager |
| staff1 | staff123 | staff |

---

## Bước 2 — Cấu hình kết nối DB

Mở `src/main/java/com/mycompany/dao/DBContext.java`, kiểm tra/sửa:

```java
private static final String URL  = "jdbc:sqlserver://localhost:1433;databaseName=PRJ301;encrypt=true;trustServerCertificate=true";
private static final String USER = "sa";          // ← sửa nếu khác
private static final String PASS = "Mailuong@2025"; // ← sửa nếu khác
```

---

## Bước 3 — Build & Chạy Project

Trong **NetBeans**:

1. Right-click project → **Clean and Build**
2. Right-click project → **Run**

URL mặc định: `http://localhost:8080/test-prj301-1.0-SNAPSHOT/`

> Nếu lỗi JSTL: đảm bảo `pom.xml` có đủ 2 dependency JSTL:
> ```xml
> <dependency>jakarta.servlet.jsp.jstl-api:3.0.0</dependency>
> <dependency>org.glassfish.web:jakarta.servlet.jsp.jstl:3.0.1</dependency>
> ```

---

## Bước 4 — Luồng sử dụng

### 4.1 Đăng nhập
```
GET /login  →  login.jsp hiển thị form
POST /login →  LoginController.doPost()
               UserDAO.login(username, password)
               Nếu đúng → session.setAttribute("user", user) → redirect /employee
               Nếu sai  → forward login.jsp + error message
```

### 4.2 Xem danh sách nhân viên
```
GET /employee → AuthFilter kiểm tra session
              → EmployeeController.doGet()
              → EmployeeDAO.getAllEmployees()          (JOIN với departments)
              → DepartmentDAO.getAllDepartments()      (cho dropdown)
              → Nếu role=manager: EmployeeDAO.getTop5HighestPaid()
              → forward employee.jsp
```

### 4.3 Thêm nhân viên
```
[Điền form Add] → POST /employee?action=add
→ EmployeeController.doPost()
→ emp.setCreatedBy(session.user.username)   ← gán người tạo
→ EmployeeDAO.addEmployee(emp)
→ redirect /employee
```

### 4.4 Sửa nhân viên (chỉ người tạo)
```
[Click "Sửa"] → GET /employee?editId=X
→ EmployeeController.doGet()
→ EmployeeDAO.getEmployeeById(editId)
→ Kiểm tra: editEmp.createdBy == session.user.username
→ Nếu đúng: request.setAttribute("editEmployee", ...) → form Update hiện lên

[Submit Update] → POST /employee?action=update
→ EmployeeDAO.updateEmployee()
   SQL: WHERE id=? AND created_by=?   ← bảo vệ ownership ở tầng DB
→ redirect /employee
```

### 4.5 Đăng xuất
```
GET /logout → session.invalidate() → redirect /login
```

---

## Bước 5 — Kiểm tra chức năng

| Test case | Kết quả mong đợi |
|-----------|------------------|
| Truy cập `/employee` chưa login | Redirect `/login` |
| Login sai | Hiện thông báo lỗi đỏ |
| Login đúng `admin/admin123` | Vào trang nhân viên |
| Thêm nhân viên | Xuất hiện trong bảng |
| Click "Sửa" nhân viên do mình tạo | Form update hiện ra |
| Nhân viên do người khác tạo | Không có nút Sửa |
| Login `admin` (manager) | Thấy bảng Top 5 lương cao nhất |
| Login `staff1` (staff) | Không thấy bảng Top 5 |
| Click Đăng xuất | Về trang login, session xóa |

---

## Cấu trúc file dự án

```
src/main/java/com/mycompany/
├── model/
│   ├── User.java
│   ├── Department.java
│   └── Employee.java
├── dao/
│   ├── DBContext.java
│   ├── UserDAO.java
│   ├── DepartmentDAO.java
│   └── EmployeeDAO.java
├── controller/
│   ├── LoginController.java    @WebServlet("/login")
│   ├── LogoutController.java   @WebServlet("/logout")
│   └── EmployeeController.java @WebServlet("/employee")
└── filter/
    └── AuthFilter.java         @WebFilter("/employee")

src/main/webapp/
├── index.jsp          → redirect /login
├── login.jsp
├── employee.jsp       → JSTL/EL view
└── WEB-INF/
    └── web.xml

setup_database.sql     → Script tạo DB + dữ liệu mẫu
```
