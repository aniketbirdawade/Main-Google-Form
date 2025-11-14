<%@ page import="java.sql.*, java.util.*, com.formbuilder.db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Fill Form</title>

<style>
	body
	{
		font-family: Arial;
		background: white;
		padding: 30px;
	}
	.box
	{
		background: white;
		padding: 20px;
		border-radius: 8px;
		width: 700px;
		margin: auto;
		box-shadow: 0 2px 8px rgba(0,0,0,0.1);
	}
	label
	{
		display: block;
		font-weight: bold;
		margin-top: 12px;
	}
	input[type=text]
	{
		width: 100%;
		padding: 8px;
		margin-top: 6px;
		border: 1px solid #ccc;
		border-radius: 4px;
	}
	.btn
	{
		background: grey;
		color: black;
		padding: 10px 14px;
		border: none;
		border-radius: 4px;
		cursor: pointer;
		margin-top: 14px;
	}
</style>
</head>

<body>
<div class="box">

<%
	String formId = request.getParameter("form_id");

	if (formId == null || formId.isEmpty())
	{
		out.println("<h3 style='color:red;text-align:center;'>Error: No form ID.</h3>");
		return;
	}

	int formIdInt = Integer.parseInt(formId);

	int currentPage = 1;
	String pageParam = request.getParameter("page");

	if (pageParam != null && !pageParam.trim().isEmpty())
	{
		try
		{
			currentPage = Integer.parseInt(pageParam);
		}
		catch (Exception ex)
		{
			currentPage = 1;
		}
	}

	if ("POST".equalsIgnoreCase(request.getMethod()))
	{
		Map<String, String> sessionAnswers = (Map<String,String>) session.getAttribute("form_answers");

		if (sessionAnswers == null)
		{
			sessionAnswers = new HashMap<>();
		}

		Enumeration<String> paramNames = request.getParameterNames();

		while (paramNames.hasMoreElements())
		{
			String p = paramNames.nextElement();

			if (p.startsWith("q_"))
			{
				String[] vals = request.getParameterValues(p);

				if (vals != null)
				{
					String joined = String.join("||", vals);
					sessionAnswers.put(p, joined);
				}
			}
		}

		session.setAttribute("form_answers", sessionAnswers);

		String finalFlag = request.getParameter("final_submit");

		if (finalFlag != null && finalFlag.equals("1"))
		{
			request.getRequestDispatcher("/SubmitResponseServlet").forward(request, response);
			return;
		}
	}

	Connection conn = null;

	try
	{
		conn = DBConnection.getConnection();

		PreparedStatement psForm = conn.prepareStatement("SELECT title, description FROM forms WHERE form_id=?");
		psForm.setInt(1, formIdInt);
		ResultSet rsForm = psForm.executeQuery();

		if (!rsForm.next())
		{
			out.println("<h3 style='color:red'>Form Not Found.</h3>");
			return;
		}

		String title = rsForm.getString("title");
		String description = rsForm.getString("description");

		rsForm.close();
		psForm.close();

		boolean hasNextPage = false;

		PreparedStatement psNext = conn.prepareStatement(
			"SELECT COUNT(*) FROM questions WHERE form_id=? AND page_number>?"
		);

		psNext.setInt(1, formIdInt);
		psNext.setInt(2, currentPage);

		ResultSet rsNext = psNext.executeQuery();

		if (rsNext.next())
		{
			hasNextPage = rsNext.getInt(1) > 0;
		}

		rsNext.close();
		psNext.close();

		PreparedStatement psQ = conn.prepareStatement(
			"SELECT question_id, question_text, question_type, options FROM questions WHERE form_id=? AND page_number=? ORDER BY question_id"
		);

		psQ.setInt(1, formIdInt);
		psQ.setInt(2, currentPage);

		ResultSet rsQ = psQ.executeQuery();

		Map<String,String> saved = (Map<String,String>) session.getAttribute("form_answers");

		if (saved == null)
		{
			saved = new HashMap<>();
		}
%>

<h2 style="text-align:center;"><%= title %></h2>
<p style="text-align:center;color:#666;"><%= description %></p>

<form action="fill_form.jsp" method="post">
	<input type="hidden" name="form_id" value="<%= formId %>">
	<input type="hidden" name="page" value="<%= currentPage + 1 %>">

	<%
		if (!hasNextPage)
		{
	%>
			<input type="hidden" name="final_submit" value="1">
	<%
		}
	%>

	<%
		boolean hasQuestions = false;

		while (rsQ.next())
		{
			hasQuestions = true;

			int qid = rsQ.getInt("question_id");
			String qtext = rsQ.getString("question_text");
			String qtype = rsQ.getString("question_type");
			String options = rsQ.getString("options");

			String key = "q_" + qid;
			String savedVal = saved.get(key);
	%>

	<label><%= qtext %></label>

	<%
			if ("radio".equalsIgnoreCase(qtype))
			{
				if (options != null)
				{
					for (String opt : options.split(","))
					{
						String trimmed = opt.trim();
						String checked = (savedVal != null && savedVal.equals(trimmed)) ? "checked" : "";
	%>
	<div><input type="radio" name="<%= key %>" value="<%= trimmed %>" <%= checked %> > <%= trimmed %></div>
	<%
					}
				}
			}
			else if ("checkbox".equalsIgnoreCase(qtype))
			{
				Set<String> chosen = new HashSet<>();

				if (savedVal != null && !savedVal.isEmpty())
				{
					for (String s : savedVal.split("\\|\\|"))
					{
						chosen.add(s);
					}
				}

				if (options != null)
				{
					for (String opt : options.split(","))
					{
						String trimmed = opt.trim();
						String checked = chosen.contains(trimmed) ? "checked" : "";
	%>
	<div><input type="checkbox" name="<%= key %>" value="<%= trimmed %>" <%= checked %> > <%= trimmed %></div>
	<%
					}
				}
			}
			else
			{
				String valueAttr = (savedVal != null) ? savedVal : "";
	%>
	<input type="text" name="<%= key %>" value="<%= valueAttr %>">
	<%
			}
		}

		rsQ.close();
		psQ.close();

		if (!hasQuestions)
		{
	%>
	<p style="color:red;text-align:center;">No questions on this page.</p>
	<%
		}
	%>

	<div style="text-align:center;">
	<%
		if (hasNextPage)
		{
	%>
		<button class="btn" type="submit">Next Page</button>
	<%
		}
		else
		{
	%>
		<button class="btn" type="submit">Submit</button>
	<%
		}
	%>
	</div>
</form>

<%
	}
	catch (Exception e)
	{
		out.println("<p style='color:red;text-align:center;'>Error: " + e.getMessage() + "</p>");
		e.printStackTrace(new java.io.PrintWriter(out));
	}
	finally
	{
		try
		{
			if (conn != null) conn.close();
		}
		catch (Exception ignored)
		{
		}
	}
%>

</div>
</body>
</html>
