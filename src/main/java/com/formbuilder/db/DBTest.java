package com.formbuilder.db;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBTest {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/form_builder";
        String user = "root";
        String password = "Aniket1773";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, user, password);

            if (conn != null) {
                System.out.println("✅ Connection successful!");
                conn.close();
            } else {
                System.out.println("❌ Connection failed!");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
