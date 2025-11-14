package com.formbuilder.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.formbuilder.db.DBConnection;

@WebServlet("/AddQuestionServlet")
public class AddQuestionServlet extends HttpServlet 
{
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException 
    {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String formIdStr = request.getParameter("form_id");
        String questionText = request.getParameter("question_text");
        String questionType = request.getParameter("question_type");
        String options = request.getParameter("options");
        String pageNumberStr = request.getParameter("page_number");

        if (formIdStr == null || formIdStr.trim().isEmpty()) 
        {
            request.setAttribute("errorMsg", "Invalid Form ID!");
            request.getRequestDispatcher("add_questions.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) 
        {
            int formId = Integer.parseInt(formIdStr);
            int pageNumber = Integer.parseInt(pageNumberStr);

            String sql = "INSERT INTO questions (form_id, question_text, question_type, options, page_number) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, formId);
            ps.setString(2, questionText);
            ps.setString(3, questionType);
            ps.setString(4, options);
            ps.setInt(5, pageNumber);

            int result = ps.executeUpdate();

            if (result > 0) 
            {
                request.setAttribute("successMsg", "Question Added Successfully!");
            } 
            else 
            {
                request.setAttribute("errorMsg", "Failed to Add Question!");
            }

            request.setAttribute("formId", formId);
            request.getRequestDispatcher("add_questions.jsp").forward(request, response);

        } 
        catch (Exception e) 
        {
            e.printStackTrace();
            request.setAttribute("errorMsg", "Error: " + e.getMessage());
            request.setAttribute("formId", formIdStr);
            request.getRequestDispatcher("add_questions.jsp").forward(request, response);
        }
    }
}
