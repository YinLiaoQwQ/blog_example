package com.example.blog;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    private static final String URL = "jdbc:mysql://localhost:3306/blog?useSSL=false&serverTimezone=Asia/Shanghai&characterEncoding=UTF-8&useUnicode=true";
    private static final String USER = "root"; // 数据库用户名
    private static final String PASSWORD = "root"; // 数据库密码

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
