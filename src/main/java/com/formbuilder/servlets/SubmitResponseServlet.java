package com.formbuilder.servlets;

import java.io.IOException;
import java.sql.*;
import java.util.*;

import com.formbuilder.db.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/SubmitResponseServlet")
public class SubmitResponseServlet extends HttpServlet
{
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException
	{
		String formIdStr = request.getParameter("form_id");

		if (formIdStr == null || formIdStr.isEmpty())
		{
			response.sendRedirect("index.jsp?msg=Invalid+Form+ID");
			return;
		}

		HttpSession session = request.getSession(false);

		if (session == null)
		{
			response.sendRedirect("fill_form.jsp?form_id=" + formIdStr + "&msg=Session+expired");
			return;
		}

		Map<String,String> allAnswers = (Map<String,String>) session.getAttribute("form_answers");

		if (allAnswers == null || allAnswers.isEmpty())
		{
			response.sendRedirect("fill_form.jsp?form_id=" + formIdStr + "&msg=No+answers+found");
			return;
		}

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

			psAns = conn.prepareStatement("INSERT INTO answers (response_id, question_id, answer_text) VALUES (?, ?, ?)");

			for (Map.Entry<String,String> e : allAnswers.entrySet())
			{
				String key = e.getKey();

				if (!key.startsWith("q_"))
				{
					continue;
				}

				String valueJoined = e.getValue();

				if (valueJoined == null || valueJoined.trim().isEmpty())
				{
					continue;
				}

				int qid = Integer.parseInt(key.substring(2));

				String[] parts = valueJoined.split("\\|\\|");

				for (String part : parts)
				{
					String ansText = part.trim();

					if (ansText.isEmpty())
					{
						continue;
					}

					psAns.setInt(1, responseId);
					psAns.setInt(2, qid);
					psAns.setString(3, ansText);
					psAns.addBatch();
				}
			}

			psAns.executeBatch();
			conn.commit();

			session.removeAttribute("form_answers");

			response.sendRedirect("view_responses.jsp?form_id=" + formId);
		}
		catch (Exception ex)
		{
			ex.printStackTrace();

			try
			{
                if (conn != null) conn.rollback();
			}
			catch (SQLException ignored)
			{
			}

			response.sendRedirect("fill_form.jsp?form_id=" + formIdStr + "&msg=Submit+Failed");
		}
		finally
		{
			try 
            { 
                if (rs != null) rs.close(); 
            } 
            catch (Exception ignored) 
            {

            }
			try 
            { 
                if (psResp != null) psResp.close(); 
            } 
            catch (Exception ignored) 
            {

            }
			try 
            { 
                if (psAns != null) psAns.close(); 
            } 
            catch (Exception ignored) 
            {

            }
			try 
            { 
                if (conn != null) conn.close(); 
            } catch (Exception ignored) 
            {
                
            }
		}
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException
	{
		doPost(request, response);
	}
}
