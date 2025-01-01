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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>博客系统 - 编辑</title>
    <style>
        /* 页面整体样式 */
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 0;
            /* 动态彩色渐变背景 */
            background: linear-gradient(270deg, #ff9a9e, #fad0c4, #fad0c4, #ff9a9e);
            background-size: 800% 800%;
            animation: GradientAnimation 15s ease infinite;
            color: #333;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            position: relative;
        }

        /* 动态渐变动画 */
        @keyframes GradientAnimation {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        /* 高斯模糊效果的背景层 */
        .background-blur {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            background: rgba(255, 255, 255, 0.1);
            z-index: 1;
        }

        /* 表单容器 */
        .form-container {
            position: relative;
            z-index: 2;
            width: 100%;
            max-width: 600px;
            background: rgba(255, 255, 255, 0.4); /* 半透明背景 */
            backdrop-filter: blur(10px);           /* 高斯模糊 */
            -webkit-backdrop-filter: blur(10px);   /* 兼容 Safari */
            padding: 40px;
            border-radius: 20px;
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

        /* 标题样式 */
        h1 {
            text-align: center;
            color: #000;
            margin-bottom: 20px;
            font-size: 2.5rem;
            text-shadow: 0 4px 6px rgba(0, 0, 0, 0.2); /* 添加文字阴影 */
        }

        /* 标签样式 */
        label {
            font-weight: bold;
            display: block;
            margin-bottom: 8px;
            color: #444;
        }

        /* 输入框和编辑器样式 */
        input[type="text"], #content {
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

        input[type="text"]:focus, #content:focus {
            border-color: #6a11cb;
            box-shadow: 0 0 10px rgba(106, 17, 203, 0.3);
            outline: none;
        }

        /* 富文本编辑器样式 */
        #content {
            height: 200px;
            overflow-y: auto;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 10px;
            background-color: #fff;
        }

        /* 工具栏样式 */
        .toolbar {
            display: flex;
            gap: 10px;
            margin-bottom: 10px;
        }

        .toolbar button {
            padding: 8px 12px;
            font-size: 1rem;
            background: #fff;
            color: #333;
            border: 1px solid #ccc;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .toolbar button:hover {
            background-color: #f0f0f0;
        }

        /* 图标按钮 */
        .toolbar button i {
            pointer-events: none;
        }

        /* 按钮样式 */
        button.save-btn {
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
        }

        button.save-btn:hover {
            background-color: #218838;
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(33, 136, 56, 0.4);
        }

        button.save-btn:active {
            transform: translateY(1px);
            box-shadow: 0 2px 8px rgba(33, 136, 56, 0.2);
        }

        button.cancel-btn {
            background-color: #dc3545;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
        }

        button.cancel-btn:hover {
            background-color: #c82333;
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(220, 53, 69, 0.4);
        }

        button.cancel-btn:active {
            transform: translateY(1px);
            box-shadow: 0 2px 8px rgba(220, 53, 69, 0.2);
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

            .toolbar {
                flex-wrap: wrap;
            }

            .toolbar button {
                flex: 1 1 45%;
            }
        }
    </style>
</head>
<body>
<!-- 高斯模糊背景层 -->
<div class="background-blur"></div>

<div class="form-container">
    <h1>编辑博客</h1>
    <form id="editBlogForm" action="edit-blog" method="post">
        <!-- 隐藏输入域用于传递博客ID -->
        <input type="hidden" name="id" value="<%= post.getId() %>">

        <label for="title">标题:</label>
        <input type="text" id="title" name="title" value="<%= post.getTitle() %>" placeholder="请输入博客标题" required>

        <label for="content">内容:</label>
        <!-- 工具栏 -->
        <div class="toolbar">
            <button type="button" onclick="formatText('bold')" title="加粗"><b>B</b></button>
            <button type="button" onclick="formatText('italic')" title="斜体"><i>I</i></button>
            <button type="button" onclick="formatText('underline')" title="下划线"><u>U</u></button>
            <button type="button" onclick="formatText('insertLink')" title="插入链接">🔗</button>
            <button type="button" onclick="formatText('insertImage')" title="插入图片">🖼️</button>
        </div>
        <!-- 富文本编辑器 -->
        <div id="content" name="content" contenteditable="true" placeholder="写下您的博客内容..." required><%= post.getContent() %></div>

        <!-- 隐藏输入域用于提交富文本内容 -->
        <input type="hidden" id="contentInput" name="content">

        <div class="form-actions">
            <button type="submit" class="save-btn">保存</button>
            <button type="button" class="cancel-btn" onclick="window.history.back();">取消</button>
        </div>
    </form>
    <div class="back-link">
        <a href="blogs">返回博客列表</a>
    </div>
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

        // 富文本编辑器工具栏功能
        function formatText(command) {
            const contentDiv = document.getElementById('content');
            contentDiv.focus(); // 确保编辑器获得焦点

            switch(command) {
                case 'bold':
                    document.execCommand('bold', false, null);
                    break;
                case 'italic':
                    document.execCommand('italic', false, null);
                    break;
                case 'underline':
                    document.execCommand('underline', false, null);
                    break;
                case 'insertLink':
                    const url = prompt("请输入链接地址:", "https://");
                    if (url) {
                        // 检查是否有选中的文本
                        if (window.getSelection().toString()) {
                            document.execCommand('createLink', false, url);
                        } else {
                            alert("请先选择要添加链接的文本！");
                        }
                    }
                    break;
                case 'insertImage':
                    const imageUrl = prompt("请输入图片地址:", "https://");
                    if (imageUrl) {
                        document.execCommand('insertImage', false, imageUrl);
                    }
                    break;
                default:
                    break;
            }
        }

        // 提交表单前将富文本内容复制到隐藏输入域
        document.getElementById('editBlogForm').addEventListener('submit', function(e) {
            const contentDiv = document.getElementById('content');
            const contentInput = document.getElementById('contentInput');
            contentInput.value = contentDiv.innerHTML;

            // 简单验证内容是否为空
            if (contentDiv.innerText.trim() === '') {
                e.preventDefault();
                alert('内容不能为空！');
            }
        });
    });
</script>
</body>
</html>
