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

@WebServlet("/CreateFormServlet")
public class CreateFormServlet extends HttpServlet
{
	private static final long serialVersionUID = 1L;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		String title = request.getParameter("title");
		String description = request.getParameter("description");
		String createdBy = request.getParameter("created_by");
		
		Connection conn = null;
		PreparedStatement ps = null;
		
		try
		{
			conn = DBConnection.getConnection();
			String sql = "INSERT INTO forms (title, description, created_by) VALUES (?, ?, ?)";
			ps = conn.prepareStatement(sql);
			ps.setString(1, title);
			ps.setString(2, description);
			ps.setString(3, createdBy);
			
			int rows = ps.executeUpdate();
			
			if (rows > 0)
			{
				response.sendRedirect("add_questions.jsp?msg=Form created successfully");
			}
			else
			{
				response.sendRedirect("create_form.jsp?msg=Error while creating form");
			}

		}
		catch (Exception e)
		{
			e.printStackTrace();
			response.sendRedirect("create_form.jsp?msg=Exception occurred");
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
