<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>博客系统 - 注册</title>
  <style>
    /* 页面整体样式 */
    body {
      font-family: 'Segoe UI', Arial, sans-serif;
      margin: 0;
      padding: 0;
      background: linear-gradient(to bottom right, #a8e063, #56ab2f); /* 渐变背景 */
      color: #333;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      animation: fadeIn 1s ease-in-out;
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

    /* 容器样式 */
    .container {
      text-align: center;
      background-color: rgba(255, 255, 255, 0.95); /* 半透明背景 */
      padding: 40px 50px;
      border-radius: 15px;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2); /* 阴影效果 */
      width: 90%;
      max-width: 400px;
      animation: slideIn 1s ease-in-out;
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
      color: #43a047;
      margin-bottom: 20px;
      font-size: 2rem;
      font-weight: bold;
    }

    /* 表单标签样式 */
    label {
      font-size: 1.1em;
      color: #555;
      display: block;
      text-align: left;
      margin-bottom: 8px;
    }

    /* 输入框样式 */
    input[type="text"], input[type="password"] {
      width: 100%;
      padding: 12px;
      margin-bottom: 20px;
      border: 1px solid #ddd;
      border-radius: 5px;
      box-sizing: border-box;
      font-size: 1rem;
      transition: border-color 0.3s ease, box-shadow 0.3s ease;
    }

    input[type="text"]:focus, input[type="password"]:focus {
      border-color: #43a047;
      box-shadow: 0 0 8px rgba(67, 160, 71, 0.3);
      outline: none;
    }

    /* 按钮样式 */
    button {
      width: 100%;
      padding: 12px;
      font-size: 1rem;
      font-weight: bold;
      background: #56ab2f;
      color: #fff;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      text-transform: uppercase;
      transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
    }

    button:hover {
      background: linear-gradient(to right, #56ab2f, #9bcf5a); /* 按钮悬停效果 */
      transform: translateY(-3px);
      box-shadow: 0 5px 15px rgba(86, 171, 47, 0.3);
    }

    button:active {
      transform: translateY(1px);
    }

    /* 链接返回样式 */
    .back-link {
      display: inline-block;
      margin-top: 20px;
      color: #43a047;
      text-decoration: none;
      font-size: 0.9rem;
      font-weight: bold;
      transition: color 0.3s ease;
    }

    .back-link:hover {
      color: #388e3c;
      text-decoration: underline;
    }
  </style>
</head>
<body>
<div class="container">
  <h1>注册账号</h1>
  <form action="/register" method="post">
    <label for="username">用户名:</label>
    <input type="text" id="username" name="username" placeholder="请输入您的用户名" required>

    <label for="password">密码:</label>
    <input type="password" id="password" name="password" placeholder="请输入您的密码" required>

    <button type="submit">注册</button>
  </form>
  <p>已有账号？<a class="back-link" href="/login.jsp">点击登录</a></p>
</div>
</body>
</html>
