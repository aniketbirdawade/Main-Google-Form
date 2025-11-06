package com.formbuilder.servlets;
import java.io.IOException;
import java.sql.*;
import java.util.Enumeration;

import com.formbuilder.db.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/SubmitResponseServlet")
public class SubmitResponseServlet extends HttpServlet
{
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{

		String formIdStr = request.getParameter("form_id");
		Connection conn = null;
		PreparedStatement psResp = null;
		PreparedStatement psAns = null;
		ResultSet rs = null;

		try
		{
			int formId = Integer.parseInt(formIdStr);
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false);
			
			String insertResponse = "INSERT INTO responses (form_id) VALUES (?)";
			psResp = conn.prepareStatement(insertResponse, Statement.RETURN_GENERATED_KEYS);
			psResp.setInt(1, formId);
			psResp.executeUpdate();
			
			rs = psResp.getGeneratedKeys();
			int responseId = 0;
			if (rs.next())
			{
				responseId = rs.getInt(1);
			}

			String insertAnswer = "INSERT INTO answers (response_id, question_id, answer_text) VALUES (?, ?, ?)";
			psAns = conn.prepareStatement(insertAnswer);
			
			Enumeration<String> params = request.getParameterNames();
			while (params.hasMoreElements())
			{
				String param = params.nextElement();
				if (param.startsWith("q_"))
				{
					int questionId = Integer.parseInt(param.substring(2));
					String answerText = request.getParameter(param);
					
					psAns.setInt(1, responseId);
					psAns.setInt(2, questionId);
					psAns.setString(3, answerText);
					psAns.addBatch();
				}
			}
			psAns.executeBatch();
			conn.commit();
			response.sendRedirect("fill_form.jsp?form_id=" + formId + "&msg=Response submitted successfully");
			}
		catch (Exception e)
		{
			e.printStackTrace();
			try
			{
				if (conn != null) conn.rollback();
				}
			catch (SQLException ex) 
			{
				ex.printStackTrace();
			}
			response.sendRedirect("fill_form.jsp?form_id=" + request.getParameter("form_id") + "&msg=Error saving response");
			}
		finally
		{
			try
			{
				if (rs != null) rs.close();
				if (psResp != null) psResp.close();
				if (psAns != null) psAns.close();
				if (conn != null) conn.close();
				}
			catch (Exception e)
			{
				e.printStackTrace();
				}
			}
		}
}
