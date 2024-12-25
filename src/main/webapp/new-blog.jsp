<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>博客系统 - 新建</title>
  <style>
    /* 通用样式 */
    body {
      font-family: 'Segoe UI', Arial, sans-serif;
      margin: 0;
      padding: 0;
      background: linear-gradient(135deg, #6a11cb, #2575fc); /* 改善背景渐变 */
      color: #333;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
    }

    h1 {
      text-align: center;
      color: #000;
      margin-bottom: 20px;
      font-size: 2.5rem;
      text-shadow: 0 4px 6px rgba(0, 0, 0, 0.2); /* 添加文字阴影 */
    }

    .form-container {
      width: 100%;
      max-width: 550px;
      background: #fff;
      padding: 40px;
      border-radius: 15px;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3); /* 增加阴影 */
      text-align: left;
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

    label {
      font-weight: bold;
      display: block;
      margin-bottom: 8px;
      color: #444;
    }

    input[type="text"], textarea {
      width: 100%;
      padding: 15px;
      margin-bottom: 20px;
      border: 1px solid #ddd;
      border-radius: 8px;
      font-size: 1rem;
      box-sizing: border-box;
      transition: border-color 0.3s ease, box-shadow 0.3s ease;
      background-color: #f9f9f9; /* 提高输入框可读性 */
    }

    input[type="text"]:focus, textarea:focus {
      border-color: #6a11cb;
      box-shadow: 0 0 10px rgba(106, 17, 203, 0.3);
      outline: none;
    }

    textarea {
      resize: none;
      height: 150px; /* 固定高度，提升布局 */
    }

    button {
      width: 100%;
      padding: 15px;
      font-size: 1rem;
      background: linear-gradient(135deg, #6a11cb, #2575fc);
      color: #fff;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      font-weight: bold;
      text-transform: uppercase;
      transition: all 0.3s ease;
    }

    button:hover {
      background: linear-gradient(135deg, #5a0dc5, #1f5fd4);
      transform: translateY(-3px);
      box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
    }

    button:active {
      transform: translateY(1px);
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
    }

    .back-link {
      text-align: center;
      margin-top: 20px;
    }

    .back-link a {
      color: #6a11cb;
      text-decoration: none;
      font-weight: bold;
      font-size: 1rem;
      transition: color 0.3s ease, text-decoration 0.3s ease;
    }

    .back-link a:hover {
      color: #2575fc;
      text-decoration: underline;
    }
  </style>
</head>
<body>
<div class="form-container">
  <h1>创建新博客</h1>
  <form action="/create-blog" method="post">
    <label for="title">标题:</label>
    <input type="text" id="title" name="title" placeholder="请输入博客标题" required>

    <label for="content">内容:</label>
    <textarea id="content" name="content" placeholder="写下您的博客内容..." required></textarea>

    <button type="submit">提交</button>
  </form>
  <div class="back-link">
    <a href="/blogs">返回博客列表</a>
  </div>
</div>
</body>
</html>
