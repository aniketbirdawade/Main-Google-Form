package com.formbuilder.servlets;
import com.formbuilder.db.DBConnection;
import java.io.IOException;
import java.sql.*;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ViewResponsesServlet")
public class ViewResponsesServlet extends HttpServlet
{
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		String formId = request.getParameter("formId");
		
		if (formId == null || formId.isEmpty())
		{
			response.sendRedirect("view_responses.jsp?error=Please+select+a+form");
			return;
		}
		
		request.setAttribute("formId", formId);
		RequestDispatcher rd = request.getRequestDispatcher("view_responses.jsp");
		rd.forward(request, response);
		}
}