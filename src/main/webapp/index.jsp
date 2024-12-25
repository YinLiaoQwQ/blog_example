<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>博客系统 - 首页</title>
    <style>
        /* 页面整体样式 */
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, #74ebd5, #acb6e5); /* 渐变背景 */
            color: #333;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            animation: fadeIn 1.2s ease-in-out;
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
            background: rgba(255, 255, 255, 0.95); /* 半透明背景 */
            padding: 50px 60px;
            border-radius: 20px;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
            width: 90%;
            max-width: 500px;
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
            color: #4CAF50;
            font-size: 2.8rem;
            margin-bottom: 30px;
            font-weight: bold;
        }

        /* 按钮链接样式 */
        .links {
            margin-top: 20px;
        }

        a {
            display: inline-block;
            padding: 15px 35px;
            color: #fff;
            background-color: #4CAF50;
            text-decoration: none;
            border-radius: 10px;
            font-size: 1.2rem;
            margin: 0 15px;
            font-weight: bold;
            transition: background-color 0.3s ease, transform 0.3s ease, box-shadow 0.3s ease;
            box-shadow: 0 5px 10px rgba(76, 175, 80, 0.3);
        }

        a:hover {
            background-color: #388E3C;
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(56, 142, 60, 0.4);
        }

        /* 页脚样式 */
        footer {
            margin-top: 30px;
            font-size: 0.9rem;
            color: #555;
        }

        footer a {
            color: #4CAF50;
            text-decoration: none;
        }

        footer a:hover {
            color: #388E3C;
            text-decoration: underline;
        }

        /* 响应式优化 */
        @media (max-width: 600px) {
            .container {
                padding: 30px 20px;
            }

            h1 {
                font-size: 2rem;
            }

            a {
                padding: 12px 25px;
                font-size: 1rem;
                margin: 0 5px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <h1>欢迎来到博客系统</h1>
    <p class="links">
        <a href="register.jsp">注册</a>
        <a href="login.jsp">登录</a>
    </p>
    <footer>
        <p>计算机2302 钱嘉炜 徐凯杰 &copy; 版权所有</p>
    </footer>
</div>
</body>
</html>
