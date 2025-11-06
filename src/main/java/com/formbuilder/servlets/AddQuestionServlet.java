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
		String formIdStr = request.getParameter("form_id");
		String questionText = request.getParameter("question_text");
		String questionType = request.getParameter("question_type");

		Connection conn = null;
		PreparedStatement ps = null;
		
		try
		{
			int formId = Integer.parseInt(formIdStr);
			conn = DBConnection.getConnection();

			String sql = "INSERT INTO questions (form_id, question_text, question_type) VALUES (?, ?, ?)";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, formId);
			ps.setString(2, questionText);
			ps.setString(3, questionType);

			int rows = ps.executeUpdate();

			if (rows > 0)
			{
				response.sendRedirect("add_questions.jsp?msg=Question added successfully");
				}
			else
			{
				response.sendRedirect("add_questions.jsp?msg=Failed to add question");
			}

		}
		
		catch (Exception e)
		{
			e.printStackTrace();
			response.sendRedirect("add_questions.jsp?msg=Error occurred");
			}
		finally
		{
			try
			{
				if (ps != null) ps.close();
				if (conn != null) conn.close();
			}
			catch (Exception e)
			{
				e.printStackTrace();
            }
        }
    }
}
