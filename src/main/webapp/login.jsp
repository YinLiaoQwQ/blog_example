<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>博客系统 - 登录</title>
  <style>
    /* 页面整体样式 */
    body {
      font-family: 'Segoe UI', Arial, sans-serif;
      margin: 0;
      padding: 0;
      background: linear-gradient(135deg, #74ebd5, #9face6); /* 背景渐变 */
      color: #333;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      animation: fadeIn 1.2s ease-in-out; /* 页面淡入效果 */
    }

    @keyframes fadeIn {
      from {
        opacity: 0;
        transform: scale(0.95);
      }
      to {
        opacity: 1;
        transform: scale(1);
      }
    }

    /* 表单容器 */
    .form-container {
      width: 100%;
      max-width: 400px;
      background: rgba(255, 255, 255, 0.95); /* 半透明背景 */
      padding: 40px;
      border-radius: 15px;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
      text-align: center;
      animation: slideIn 1s ease-out; /* 容器滑入效果 */
    }

    @keyframes slideIn {
      from {
        transform: translateY(-20px);
        opacity: 0;
      }
      to {
        transform: translateY(0);
        opacity: 1;
      }
    }

    /* 标题样式 */
    h1 {
      text-align: center;
      color: #333;
      font-size: 2rem;
      margin-bottom: 20px;
      font-weight: bold;
    }

    /* 标签和输入框样式 */
    label {
      font-weight: bold;
      display: block;
      text-align: left;
      margin-bottom: 5px;
      color: #555;
    }

    input[type="text"], input[type="password"] {
      width: 100%;
      padding: 12px;
      margin-bottom: 20px;
      border: 1px solid #ddd;
      border-radius: 5px;
      font-size: 16px;
      transition: border-color 0.3s ease, box-shadow 0.3s ease;
    }

    input[type="text"]:focus, input[type="password"]:focus {
      border-color: #2196F3;
      box-shadow: 0 0 8px rgba(33, 150, 243, 0.3);
      outline: none;
    }

    /* 按钮样式 */
    button {
      width: 100%;
      padding: 12px;
      background: #2196F3;
      color: #fff;
      border: none;
      border-radius: 5px;
      font-size: 16px;
      cursor: pointer;
      font-weight: bold;
      text-transform: uppercase;
      transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
    }

    button:hover {
      background: #1976D2;
      transform: translateY(-3px);
      box-shadow: 0 5px 15px rgba(33, 150, 243, 0.4);
    }

    /* 错误信息样式 */
    .error-message {
      color: #D8000C;
      background-color: #FFD2D2;
      padding: 12px;
      border-radius: 5px;
      margin-bottom: 20px;
      text-align: center;
      font-size: 14px;
      box-shadow: 0 4px 8px rgba(216, 0, 12, 0.2);
    }

    /* 注册链接样式 */
    .register-link {
      text-align: center;
      margin-top: 20px;
      font-size: 14px;
    }

    .register-link a {
      text-decoration: none;
      color: #2196F3;
      font-weight: bold;
      transition: color 0.3s ease;
    }

    .register-link a:hover {
      color: #1976D2;
      text-decoration: underline;
    }
  </style>
</head>
<body>
<div class="form-container">
  <h1>登录</h1>
  <% if (request.getAttribute("errorMessage") != null) { %>
  <div class="error-message">
    <%= request.getAttribute("errorMessage") %>
  </div>
  <% } %>
  <form action="/login" method="post">
    <label for="username">账号:</label>
    <input type="text" id="username" name="username" placeholder="请输入您的账号" required>

    <label for="password">密码:</label>
    <input type="password" id="password" name="password" placeholder="请输入您的密码" required>

    <button type="submit">登录</button>
  </form>
  <div class="register-link">
    <p>还没有账号？<a href="/register.jsp">立即注册</a></p>
  </div>
</div>
</body>
</html>
