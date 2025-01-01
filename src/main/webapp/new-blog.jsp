<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN" data-theme="light">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>博客系统 - 新建</title>
  <!-- 引入 Quill 的 CSS -->
  <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
  <!-- 引入 Font Awesome 图标库（可选，用于图标按钮） -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    /* 颜色主题定义 */
    :root {
      --background-gradient-start: #a8e063;
      --background-gradient-end: #56ab2f;
      --text-color: #333;
      --header-bg: rgba(255, 255, 255, 0.8);
      --header-text-color: #333;
      --form-bg: rgba(255, 255, 255, 0.85);
      --form-text-color: #333;
      --button-bg: #3f51b5;
      --button-hover-bg: #5c6bc0;
      --toggle-bg: #333;
      --toggle-color: #fff;
      --blur-amount: 10px; /* 减少模糊量 */
      --overlay-bg: rgba(255, 255, 255, 0.6); /* 调整覆盖层透明度 */
    }

    [data-theme="dark"] {
      --background-gradient-start: #2c3e50;
      --background-gradient-end: #4ca1af;
      --text-color: #ecf0f1;
      --header-bg: rgba(44, 62, 80, 0.9);
      --header-text-color: #ecf0f1;
      --form-bg: rgba(44, 62, 80, 0.9);
      --form-text-color: #ecf0f1;
      --button-bg: #2980b9;
      --button-hover-bg: #3498db;
      --toggle-bg: #ecf0f1;
      --toggle-color: #333;
      --blur-amount: 10px;
      --overlay-bg: rgba(44, 62, 80, 0.6); /* 调整覆盖层透明度 */
    }

    /* 动态彩色渐变背景 */
    body {
      margin: 0;
      padding: 0;
      font-family: 'Segoe UI', Arial, sans-serif;
      background: linear-gradient(270deg, var(--background-gradient-start), var(--background-gradient-end));
      background-size: 600% 600%;
      animation: GradientAnimation 15s ease infinite;
      color: var(--text-color);
      display: flex;
      justify-content: center;
      align-items: flex-start;
      min-height: 100vh;
      position: relative;
      transition: background 0.5s ease, color 0.5s ease;
    }

    @keyframes GradientAnimation {
      0% { background-position: 0% 50%; }
      50% { background-position: 100% 50%; }
      100% { background-position: 0% 50%; }
    }

    /* 高斯模糊背景层 */
    .background-blur {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      backdrop-filter: blur(var(--blur-amount));
      -webkit-backdrop-filter: blur(var(--blur-amount));
      background: var(--overlay-bg);
      z-index: 1;
      transition: background 0.5s ease;
    }

    /* 容器样式 */
    .form-container {
      position: relative;
      z-index: 2;
      width: 100%;
      max-width: 600px;
      background: var(--form-bg);
      padding: 40px;
      border-radius: 20px;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3); /* 增加阴影 */
      text-align: left;
      transition: background 0.5s ease, color 0.5s ease;
      margin-top: 80px; /* 确保内容不被固定头部覆盖 */
    }

    /* 头部样式 */
    header {
      width: 100%;
      padding: 15px 20px;
      background: var(--header-bg);
      border-bottom: 1px solid #ccc;
      display: flex;
      justify-content: space-between;
      align-items: center;
      position: fixed;
      top: 0;
      left: 0;
      z-index: 3;
      transition: background 0.5s ease, color 0.5s ease;
      box-sizing: border-box;
    }

    header .welcome a {
      color: var(--header-text-color);
      text-decoration: none;
      margin: 0 5px;
    }

    header .settings-and-toggle {
      display: flex;
      align-items: center;
      gap: 15px;
    }

    header .settings {
      position: relative;
      cursor: pointer;
      display: flex;
      align-items: center;
      gap: 15px;
    }

    header .settings img {
      width: 30px;
      height: 30px;
      border-radius: 50%;
    }

    header .settings-menu {
      position: absolute;
      top: 40px;
      right: 0;
      background: var(--form-bg);
      border: 1px solid #ccc;
      border-radius: 8px;
      box-shadow: 0 5px 15px rgba(0,0,0,0.3);
      display: none;
      flex-direction: column;
      min-width: 150px;
      transition: background 0.5s ease, color 0.5s ease;
    }

    header .settings-menu a {
      padding: 10px 15px;
      text-decoration: none;
      color: var(--header-text-color);
      transition: background 0.3s ease;
    }

    header .settings-menu a:hover {
      background: rgba(0,0,0,0.1);
    }

    /* 深色模式切换按钮 */
    .dark-mode-toggle {
      background: var(--toggle-bg);
      color: var(--toggle-color);
      border: none;
      border-radius: 50%;
      width: 40px;
      height: 40px;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: background 0.5s ease, color 0.5s ease;
      box-shadow: 0 2px 5px rgba(0,0,0,0.2);
      flex-shrink: 0;
    }

    .dark-mode-toggle:hover {
      background: var(--button-hover-bg);
    }

    /* 标题样式 */
    h1 {
      text-align: center;
      color: var(--text-color);
      margin-bottom: 20px;
      font-size: 2.5rem;
      text-shadow: 0 4px 6px rgba(0, 0, 0, 0.2); /* 添加文字阴影 */
    }

    /* 标签样式 */
    label {
      font-weight: bold;
      display: block;
      margin-bottom: 8px;
      color: var(--form-text-color);
    }

    /* Quill 编辑器容器样式 */
    #editor-container {
      height: 300px;
      background-color: #fff;
      color: var(--text-color);
    }

    /* 提交按钮样式 */
    .submit-btn {
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

    .submit-btn:hover {
      background: linear-gradient(135deg, #5a0dc5, #1f5fd4);
      transform: translateY(-3px);
      box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
    }

    .submit-btn:active {
      transform: translateY(1px);
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
    }

    /* 返回链接样式 */
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

    /* 响应式优化 */
    @media (max-width: 600px) {
      .form-container {
        padding: 30px 20px;
      }

      h1 {
        font-size: 2rem;
      }

      /* 调整头部布局 */
      header .settings-and-toggle {
        gap: 10px;
      }

      .dark-mode-toggle {
        width: 35px;
        height: 35px;
      }
    }

    /* Quill 在深色模式下的样式 */
    [data-theme="dark"] #editor-container {
      background-color: rgba(255, 255, 255, 0.1);
      color: var(--form-text-color);
    }

    [data-theme="dark"] .ql-toolbar.ql-snow {
      background-color: rgba(255, 255, 255, 0.1);
      border: 1px solid #555;
    }

    [data-theme="dark"] .ql-toolbar.ql-snow .ql-formats button {
      color: var(--form-text-color);
    }

    [data-theme="dark"] .ql-toolbar.ql-snow .ql-formats button:hover {
      background-color: rgba(255, 255, 255, 0.2);
    }
  </style>
  <!-- 引入 Quill 的 JS -->
  <script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>
</head>
<body>
<!-- 高斯模糊背景层 -->
<div class="background-blur"></div>

<!-- 头部部分 -->
<header>
  <div class="welcome">
    <%
      // 获取用户名示例代码
      String username = (String) session.getAttribute("username");
      if (username != null) {
    %>
    欢迎您，<span><%= username %></span>!
    <% } else { %>
    <a href="login.jsp">登录</a> | <a href="register.jsp">注册</a>
    <% } %>
  </div>
  <div class="settings-and-toggle">
    <div class="settings">
      <img src="https://cdn-icons-png.flaticon.com/512/847/847969.png" alt="Settings">
      <div class="settings-menu">
        <a href="new-blog.jsp">创建新博文</a>
        <a href="logout">退出</a>
      </div>
    </div>
    <!-- 深色模式切换按钮 -->
    <button class="dark-mode-toggle" title="切换深色模式">
      🌙
    </button>
  </div>
</header>

<!-- 表单容器 -->
<div class="form-container">
  <h1>创建新博客</h1>
  <form id="blogForm" action="create-blog" method="post">
    <label for="title">标题:</label>
    <input type="text" id="title" name="title" placeholder="请输入博客标题" required>

    <label for="editor-container">内容:</label>
    <!-- Quill 编辑器工具栏 -->
    <div id="toolbar">
                <span class="ql-formats">
                    <button class="ql-bold" title="加粗"><b>B</b></button>
                    <button class="ql-italic" title="斜体"><i>I</i></button>
                    <button class="ql-underline" title="下划线"><u>U</u></button>
                </span>
      <span class="ql-formats">
                    <button class="ql-link" title="插入链接"><i class="fa fa-link"></i></button>
                    <button class="ql-image" title="插入图片"><i class="fa fa-image"></i></button>
                </span>
    </div>
    <!-- Quill 编辑器容器 -->
    <div id="editor-container" name="content"><%= request.getAttribute("content") != null ? request.getAttribute("content") : "" %></div>

    <!-- 隐藏输入域用于提交富文本内容 -->
    <input type="hidden" id="contentInput" name="content">

    <button type="submit" class="submit-btn">提交</button>
  </form>
  <div class="back-link">
    <a href="blogs">返回博客列表</a>
  </div>
</div>

<!-- JavaScript 部分 -->
<script>
  document.addEventListener("DOMContentLoaded", function () {
    // 右上角设置菜单的显示和隐藏
    const settingsMenu = document.querySelector('.settings-menu');
    const settingsButton = document.querySelector('.settings');
    let menuTimeout;

    settingsButton.addEventListener('mouseenter', () => {
      clearTimeout(menuTimeout);
      settingsMenu.style.display = 'flex';
      settingsMenu.style.flexDirection = 'column';
    });

    settingsButton.addEventListener('mouseleave', () => {
      menuTimeout = setTimeout(() => {
        settingsMenu.style.display = 'none';
      }, 300);
    });

    settingsMenu.addEventListener('mouseenter', () => {
      clearTimeout(menuTimeout);
    });

    settingsMenu.addEventListener('mouseleave', () => {
      menuTimeout = setTimeout(() => {
        settingsMenu.style.display = 'none';
      }, 300);
    });

    // 深色模式切换
    const darkModeToggle = document.querySelector('.dark-mode-toggle');

    // 检查用户之前的选择
    if (localStorage.getItem('theme') === 'dark') {
      document.documentElement.setAttribute('data-theme', 'dark');
      darkModeToggle.textContent = '☀️'; // 切换到浅色模式的图标
    } else {
      darkModeToggle.textContent = '🌙'; // 切换到深色模式的图标
    }

    darkModeToggle.addEventListener('click', function () {
      const currentTheme = document.documentElement.getAttribute('data-theme');
      const newTheme = currentTheme === 'light' ? 'dark' : 'light';
      document.documentElement.setAttribute('data-theme', newTheme);
      localStorage.setItem('theme', newTheme);
      darkModeToggle.textContent = newTheme === 'dark' ? '☀️' : '🌙';

      // 切换 Quill 的样式
      if (newTheme === 'dark') {
        quill.root.style.backgroundColor = 'rgba(255, 255, 255, 0.1)';
        quill.root.style.color = 'var(--form-text-color)';
        document.querySelector('.ql-toolbar.ql-snow').style.backgroundColor = 'rgba(255, 255, 255, 0.1)';
        document.querySelector('.ql-toolbar.ql-snow').style.border = '1px solid #555';
        document.querySelectorAll('.ql-toolbar.ql-snow .ql-formats button').forEach(button => {
          button.style.color = 'var(--form-text-color)';
        });
      } else {
        quill.root.style.backgroundColor = '#fff';
        quill.root.style.color = 'var(--text-color)';
        document.querySelector('.ql-toolbar.ql-snow').style.backgroundColor = '#fff';
        document.querySelector('.ql-toolbar.ql-snow').style.border = '1px solid #ccc';
        document.querySelectorAll('.ql-toolbar.ql-snow .ql-formats button').forEach(button => {
          button.style.color = '#333';
        });
      }
    });

    // 初始化 Quill 编辑器
    var quill = new Quill('#editor-container', {
      modules: {
        toolbar: '#toolbar'
      },
      theme: 'snow'
    });

    // 提交表单前将富文本内容复制到隐藏输入域
    document.getElementById('blogForm').addEventListener('submit', function(e) {
      const contentInput = document.getElementById('contentInput');
      contentInput.value = quill.root.innerHTML;

      // 简单验证内容是否为空
      if (quill.getText().trim() === '') {
        e.preventDefault();
        alert('内容不能为空！');
      }
    });

    // 确保 Quill 编辑器样式随主题切换
    if (localStorage.getItem('theme') === 'dark') {
      quill.root.style.backgroundColor = 'rgba(255, 255, 255, 0.1)';
      quill.root.style.color = 'var(--form-text-color)';
      document.querySelector('.ql-toolbar.ql-snow').style.backgroundColor = 'rgba(255, 255, 255, 0.1)';
      document.querySelector('.ql-toolbar.ql-snow').style.border = '1px solid #555';
      document.querySelectorAll('.ql-toolbar.ql-snow .ql-formats button').forEach(button => {
        button.style.color = 'var(--form-text-color)';
      });
    } else {
      quill.root.style.backgroundColor = '#fff';
      quill.root.style.color = 'var(--text-color)';
      document.querySelector('.ql-toolbar.ql-snow').style.backgroundColor = '#fff';
      document.querySelector('.ql-toolbar.ql-snow').style.border = '1px solid #ccc';
      document.querySelectorAll('.ql-toolbar.ql-snow .ql-formats button').forEach(button => {
        button.style.color = '#333';
      });
    }
  });
</script>
</body>
</html>
