<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <title>Quản lý nhân viên</title>
                <style>
                    body {
                        font-family: Arial, sans-serif;
                        background: #f5f5f5;
                    }

                    h1 {
                        color: white;
                        background-color: #1a73e8;
                        padding: 12px 20px;
                        margin: 0;
                    }

                    .info {
                        background-color: #1a73e8;
                        color: white;
                        padding: 8px 20px;
                        text-align: right;
                    }

                    .info a {
                        color: white;
                    }

                    .container {
                        padding: 20px;
                    }

                    table {
                        border-collapse: collapse;
                        width: 100%;
                        background: white;
                        margin-bottom: 20px;
                    }

                    th,
                    td {
                        border: 1px solid #ccc;
                        padding: 8px 12px;
                        text-align: left;
                    }

                    th {
                        background-color: #1a73e8;
                        color: white;
                    }

                    input,
                    select {
                        padding: 6px;
                        margin: 4px;
                    }

                    button {
                        padding: 6px 14px;
                        background-color: #1a73e8;
                        color: white;
                        border: none;
                        cursor: pointer;
                    }

                    a.btn-edit {
                        color: orange;
                    }
                </style>
            </head>

            <body>

                <div class="header">
                    <h1>Quản lý nhân viên</h1>
                    <div class="user-info">
                        Xin chào, <strong>${sessionScope.user.username}</strong>
                        <span class="badge ${sessionScope.user.role == 'manager' ? 'badge-manager' : 'badge-staff'}">
                            ${sessionScope.user.role}
                        </span>
                        &nbsp;&nbsp;
                        <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
                    </div>
                </div>

                <div class="container">

                    <%--====================FORM ADD / UPDATE====================--%>
                        <c:choose>
                            <c:when test="${not empty editEmployee}">
                                <%-- UPDATE FORM --%>
                                    <div class="section-title">️Cập nhật nhân viên</div>
                                    <form method="post" action="${pageContext.request.contextPath}/employee">
                                        <input type="hidden" name="action" value="update" />
                                        <input type="hidden" name="id" value="${editEmployee.id}" />
                                        <input type="text" name="name" value="${editEmployee.name}"
                                            placeholder="Tên nhân viên" required />
                                        <select name="gender">
                                            <option value="Male" ${editEmployee.gender=='Male' ? 'selected' : '' }>Nam
                                            </option>
                                            <option value="Female" ${editEmployee.gender=='Female' ? 'selected' : '' }>
                                                Nữ</option>
                                        </select>
                                        <input type="number" name="salary" value="${editEmployee.salary}"
                                            placeholder="Lương" step="0.01" min="0" required />
                                        <select name="deptId">
                                            <c:forEach var="dept" items="${departmentList}">
                                                <option value="${dept.id}" ${dept.id==editEmployee.deptId ? 'selected'
                                                    : '' }>${dept.name}</option>
                                            </c:forEach>
                                        </select>
                                        <button type="submit">Cập nhật</button>
                                        <a href="${pageContext.request.contextPath}/employee"
                                            style="margin-left:10px; color:#c0392b; font-size:13px;">Hủy</a>
                                    </form>
                            </c:when>
                            <c:otherwise>
                                <%-- ADD FORM --%>
                                    <div class="section-title">Thêm nhân viên mới</div>
                                    <form method="post" action="${pageContext.request.contextPath}/employee">
                                        <input type="hidden" name="action" value="add" />
                                        <input type="text" name="name" placeholder="Tên nhân viên" required />
                                        <select name="gender">
                                            <option value="Male">Nam</option>
                                            <option value="Female">Nữ</option>
                                        </select>
                                        <input type="number" name="salary" placeholder="Lương" step="0.01" min="0"
                                            required />
                                        <select name="deptId">
                                            <c:forEach var="dept" items="${departmentList}">
                                                <option value="${dept.id}">${dept.name}</option>
                                            </c:forEach>
                                        </select>
                                        <button type="submit">Thêm</button>
                                    </form>
                            </c:otherwise>
                        </c:choose>

                        <%--====================EMPLOYEE LIST TABLE====================--%>
                            <div class="section-title"> Danh sách nhân viên</div>
                            <table>
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Tên</th>
                                        <th>Giới tính</th>
                                        <th>Lương</th>
                                        <th>Phòng ban</th>
                                        <th>Tạo bởi</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty employeeList}">
                                            <tr>
                                                <td colspan="7" style="text-align:center; color:#999;">Chưa có nhân viên
                                                    nào.</td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="emp" items="${employeeList}" varStatus="status">
                                                <tr>
                                                    <td>${status.index + 1}</td>
                                                    <td>${emp.name}</td>
                                                    <td>${emp.gender}</td>
                                                    <td>
                                                        <fmt:formatNumber value="${emp.salary}" type="number"
                                                            maxFractionDigits="0" /> ₫
                                                    </td>
                                                    <td>${emp.deptName}</td>
                                                    <td>${emp.createdBy}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when
                                                                test="${emp.createdBy == sessionScope.user.username}">
                                                                <a class="btn-edit"
                                                                    href="${pageContext.request.contextPath}/employee?editId=${emp.id}">
                                                                    Sửa
                                                                </a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="no-edit">—</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>

                            <%--====================TOP 5 (MANAGER ONLY)====================--%>
                                <c:if test="${sessionScope.user.role == 'manager'}">
                                    <div class="top5-section">
                                        <div class="section-title">Top 5 nhân viên lương cao nhất</div>
                                        <table>
                                            <thead>
                                                <tr>
                                                    <th>Hạng</th>
                                                    <th>Tên</th>
                                                    <th>Giới tính</th>
                                                    <th>Lương</th>
                                                    <th>Phòng ban</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${empty top5List}">
                                                        <tr>
                                                            <td colspan="5" style="text-align:center; color:#999;">Chưa
                                                                có dữ liệu.</td>
                                                        </tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="emp" items="${top5List}" varStatus="status">
                                                            <tr>
                                                                <td>${status.index + 1}</td>
                                                                <td>${emp.name}</td>
                                                                <td>${emp.gender}</td>
                                                                <td>
                                                                    <fmt:formatNumber value="${emp.salary}"
                                                                        type="number" maxFractionDigits="0" /> ₫
                                                                </td>
                                                                <td>${emp.deptName}</td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:otherwise>
                                                </c:choose>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:if>

                </div>
            </body>

            </html>