package com.formbuilder.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import com.formbuilder.db.DBConnection;

@WebServlet("/AddQuestionServlet")  // ✅ this tells Tomcat the URL
public class AddQuestionServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String formId = request.getParameter("form_id");
        String questionText = request.getParameter("question_text");
        String questionType = request.getParameter("question_type");
        String options = request.getParameter("options");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO questions(form_id, question_text, question_type, options) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(formId));
            ps.setString(2, questionText);
            ps.setString(3, questionType);
            ps.setString(4, options);
            ps.executeUpdate();
            response.sendRedirect("index.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
