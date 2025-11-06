<%@ page import="java.sql.*, com.formbuilder.db.DBConnection" %>
<html>
<head>
<title>Fill Form</title>
<style>
body 
	{ 
	font-family: Arial; 
	background: #f4f4f4; 
	}
	.container
	{ 
	max-width: 700px; 
	margin: 50px auto; 
	background: #fff; 
	padding: 25px; 
	border-radius: 8px; 
	box-shadow: 0 0 10px 
	rgba(0,0,0,0.1); 
	}
	h2 
	{ 
	text-align: center; 
	color: #333; 
	}
	select, input[type=submit] 
	{ 
	padding: 8px; 
	margin-top: 10px; 
	border-radius: 4px; 
	border: 1px solid #ccc; 
	}
	input[type=submit] 
	{
	background: #007BFF; 
	color: #fff; 
	border: none; 
	cursor: pointer; 
	}
	input[type=submit]:hover 
	{ 
	background: #0056b3; 
	}
	.message 
	{ 
	margin-top: 20px; 
	padding: 10px; 
	border-radius: 4px; 
	}
	.success 
	{ background: #d4edda; 
	color: #155724; 
	}
	.error 
	{ 
	background: #f8d7da; 
	color: #721c24; 
	}
	.question 
	{ 
	margin-bottom: 20px; 
	}
</style>
</head>
	<body>
	<div class="container">
	<h2>Fill a Form</h2>

<%
Connection conn = DBConnection.getConnection();
if(conn != null)
{
	try
	{
		String action = request.getParameter("action");
		String formIdStr = request.getParameter("form_id");
		if(action == null || "Load Form".equals(action) && formIdStr == null)
		{
			PreparedStatement psForms = conn.prepareStatement("SELECT form_id, title FROM forms");
			ResultSet rsForms = psForms.executeQuery();
%>
<form method="post">
Select Form: 
<select name="form_id" required>
<%
	while(rsForms.next()){
%>
<option value="<%= rsForms.getInt("form_id") %>">
<%= rsForms.getString("title") %> (ID: 
<%= rsForms.getInt("form_id") %>)
</option>
<%
	}
%>
</select>
<input type="submit" name="action" value="Load Form">
</form>
<%
}
	else if("Load Form".equals(action) && formIdStr != null)
	{
		int formId = Integer.parseInt(formIdStr);
		PreparedStatement psQ = conn.prepareStatement(
				"SELECT question_id, question_text, question_type FROM questions WHERE form_id=?");
		psQ.setInt(1, formId);
		ResultSet rsQ = psQ.executeQuery();

		if(!rsQ.isBeforeFirst())
		{
			out.println("<div class='message error'>No questions found for this form.</div>");
		} 
		else 
		{
%>
<form method="post">
<input type="hidden" name="submit_form_id" value="<%= formId %>">
<%
	while(rsQ.next())
	{
		int qid = rsQ.getInt("question_id");
		String qtext = rsQ.getString("question_text");
		String qtype = rsQ.getString("question_type");
%>
<div class="question">
<b><%= qtext %></b><br>
<%
	if("Text".equals(qtype)){
%>
<input type="text" name="q_<%= qid %>" required>
<%
} 
	else
	{
		PreparedStatement psOpt = conn.prepareStatement("SELECT option_text FROM options WHERE question_id=?");
		psOpt.setInt(1, qid);
		ResultSet rsOpt = psOpt.executeQuery();
		while(rsOpt.next())
		{
			String opt = rsOpt.getString("option_text");
%>
<input type="radio" name="q_<%= qid %>" value="<%= opt %>" required> <%= opt %><br>
<%
		}
	}
%>
</div>
<%
} 
%>
<input type="submit" name="action" value="Submit Response">
</form>
<%
	}
		} 
	else if("Submit Response".equals(action))
	{
		String submitFormIdStr = request.getParameter("submit_form_id");
		if(submitFormIdStr != null)
		{
			int formId = Integer.parseInt(submitFormIdStr);
			PreparedStatement psResp = conn.prepareStatement("INSERT INTO responses(form_id) VALUES(?)", 
					Statement.RETURN_GENERATED_KEYS);
			psResp.setInt(1, formId);
			psResp.executeUpdate();
			ResultSet rsResp = psResp.getGeneratedKeys();
			int responseId = 0;
			if(rsResp.next()) responseId = rsResp.getInt(1);

			PreparedStatement psQ = conn.prepareStatement("SELECT question_id FROM questions WHERE form_id=?");
                psQ.setInt(1, formId);
                ResultSet rsQ = psQ.executeQuery();
                while(rsQ.next())
                {
                	int qid = rsQ.getInt("question_id");
                	String ans = request.getParameter("q_"+qid);
                	if(ans != null)
                	{
                		PreparedStatement psDetail = conn.prepareStatement("INSERT INTO response_details(response_id, question_id, answer) VALUES(?, ?, ?)");
                		psDetail.setInt(1, responseId);
                		psDetail.setInt(2, qid);
                		psDetail.setString(3, ans);
                		psDetail.executeUpdate();
                		}
                	}
%>
<div class="message success">Response submitted successfully!</div>
<%
}
		}
		conn.close();
		}
	catch(Exception e)
	{
		out.println("<div class='message error'>Error: "+e.getMessage()+"</div>");
	}
}
%>
</div>
</body>
</html>
