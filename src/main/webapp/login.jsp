<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Đăng nhập - Employee Management</title>
        <style>
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: Arial, sans-serif;
                background-color: #f0f2f5;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
            }

            .login-box {
                background: #ffffff;
                padding: 40px;
                width: 360px;
                border-radius: 8px;
                box-shadow: 0 2px 12px rgba(0, 0, 0, 0.15);
                text-align: center;
            }

            .login-box h2 {
                color: #1a73e8;
                margin-bottom: 24px;
                font-size: 22px;
            }

            .login-box input {
                width: 100%;
                padding: 10px 12px;
                margin-bottom: 14px;
                border: 1px solid #ccc;
                border-radius: 4px;
                font-size: 14px;
            }

            .login-box button {
                width: 100%;
                padding: 10px;
                background-color: #1a73e8;
                color: white;
                border: none;
                border-radius: 4px;
                font-size: 15px;
                cursor: pointer;
            }

            .login-box button:hover {
                background-color: #1558b0;
            }

            .error-msg {
                color: red;
                font-size: 13px;
                margin-bottom: 12px;
            }
        </style>
    </head>

    <body>
        <div class="login-box">
            <h2>Employee Management</h2>
            <% if (request.getAttribute("error") !=null) { %>
                <p class="error-msg">${error}</p>
                <% } %>
                    <form method="post" action="${pageContext.request.contextPath}/login">
                        <input type="text" name="username" placeholder="Tên đăng nhập" required />
                        <input type="password" name="password" placeholder="Mật khẩu" required />
                        <button type="submit">Đăng nhập</button>
                    </form>
        </div>
    </body>

    </html>