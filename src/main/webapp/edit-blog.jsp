<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.blog.BlogPost" %>
<%
    BlogPost post = (BlogPost) request.getAttribute("blogPost");
    String username = (String) request.getSession().getAttribute("username");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>博客系统 - 编辑</title>
    <link rel="stylesheet" href="css/blogs_styles.css">
    <style>
        /* 额外样式用于编辑页面 */
        .edit-container {
            max-width: 800px;
            margin: 40px auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 8px;
            background-color: #f9f9f9;
        }

        .edit-container h1 {
            text-align: center;
            margin-bottom: 30px;
            color: #333;
        }

        .edit-form {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
        }

        .form-group input[type="text"],
        .form-group textarea {
            padding: 10px;
            border: 1px solid #bbb;
            border-radius: 4px;
            font-size: 16px;
            resize: vertical;
        }

        .form-group textarea {
            min-height: 200px;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        .form-actions button {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
        }

        .form-actions .save-btn {
            background-color: #28a745;
            color: white;
        }

        .form-actions .cancel-btn {
            background-color: #dc3545;
            color: white;
        }

        /* 响应式设计 */
        @media (max-width: 600px) {
            .edit-container {
                padding: 15px;
            }

            .form-actions {
                flex-direction: column;
                align-items: stretch;
            }

            .form-actions button {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<!-- 头部部分，与博客列表页面保持一致 -->
<header>
    <div class="welcome">
        <% if (username != null) { %>
        欢迎您， <span><%= username %></span>!
        <% } else { %>
        <a href="/login.jsp">登录</a> | <a href="/register.jsp">注册</a>
        <% } %>
    </div>
    <div class="settings">
        <img src="https://cdn-icons-png.flaticon.com/512/847/847969.png" alt="设置" class="settings-icon">
        <div class="settings-menu">
            <a href="/new-blog.jsp">创建新博文</a>
            <a href="/logout">退出</a>
        </div>
    </div>
</header>

<!-- 编辑博客内容 -->
<div class="edit-container">
    <h1>编辑博客</h1>
    <form class="edit-form" action="/edit-blog" method="post" accept-charset="UTF-8">
        <input type="hidden" name="id" value="<%= post.getId() %>">

        <div class="form-group">
            <label for="title">标题：</label>
            <input type="text" id="title" name="title" value="<%= post.getTitle() %>" required>
        </div>

        <div class="form-group">
            <label for="content">内容：</label>
            <textarea id="content" name="content" required><%= post.getContent() %></textarea>
        </div>

        <div class="form-actions">
            <button type="submit" class="save-btn">保存</button>
            <button type="button" class="cancel-btn" onclick="window.history.back();">取消</button>
        </div>
    </form>
</div>

<!-- JavaScript 处理菜单悬停 -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        // 右上角菜单的显示和隐藏
        const settingsMenu = document.querySelector('.settings-menu');
        const settingsButton = document.querySelector('.settings');
        let menuTimeout;

        settingsButton.addEventListener('mouseenter', () => {
            clearTimeout(menuTimeout);
            settingsMenu.style.display = 'block';
        });

        settingsButton.addEventListener('mouseleave', () => {
            menuTimeout = setTimeout(() => {
                settingsMenu.style.display = 'none';
            }, 1000); // 延时1秒隐藏菜单
        });

        settingsMenu.addEventListener('mouseenter', () => {
            clearTimeout(menuTimeout);
        });

        settingsMenu.addEventListener('mouseleave', () => {
            menuTimeout = setTimeout(() => {
                settingsMenu.style.display = 'none';
            }, 1000); // 延时1秒隐藏菜单
        });
    });
</script>
</body>
</html>
