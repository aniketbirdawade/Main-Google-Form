<%@ page import="java.sql.*, com.formbuilder.db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Admin Dashboard - Form Builder</title>
	<style>
	body 
	{ 
	font-family: Arial, sans-serif; 
	background-color: #f0f2f5; 
	margin: 0; 
	padding: 0; 
	}
	header 
	{ 
	background-color: #4CAF50; 
	color: white; 
	padding: 15px; 
	text-align: center; 
	font-size: 24px; 
	}
	.container 
	{ 
	width: 80%; 
	margin: 30px auto; 
	background: white; 
	padding: 20px; 
	border-radius: 10px; 
	box-shadow: 0px 0px 10px rgba(0,0,0,0.1); 
	}
	table 
	{ 
	width: 100%; 
	border-collapse: collapse; 
	margin-top: 20px; 
	}
	th, td 
	{ 
	padding: 12px; 
	border-bottom: 1px solid #ddd; 
	text-align: left; 
	}
	th 
	{ background-color: #4CAF50; 
	color: white; 
	}
	tr:hover 
	{ 
	background-color: #f1f1f1; 
	}
	.actions a 
	{ 
	text-decoration: none; 
	color: white; 
	padding: 6px 10px; 
	border-radius: 5px; 
	margin-right: 5px; 
	}
	.add 
	{ 
	background-color: #2196F3; 
	}
	.view 
	{ 
	background-color: #4CAF50; 
	}
	.create 
	{ 
	background-color: #ff9800; 
	padding: 10px 15px; 
	border-radius: 5px; 
	color: white; 
	text-decoration: none; 
	}
	.top-actions 
	{ 
	text-align: right; 
	}
    </style>
	</head>
<body>
<header> Google Form Builder – Admin Dashboard </header>

<div class="container">
<div class="top-actions">
	<a href="create_form.jsp" class="create">+ Create New Form</a>
	</div>
	
	<h2>All Created Forms</h2>
	
	<table>
	<tr>
	<th>ID</th>
	<th>Title</th>
	<th>Description</th>
	<th>Created By</th>
	<th>Created At</th>
	<th>Actions</th>
</tr>
<%
	try 
	{
		Connection conn = DBConnection.getConnection();
		PreparedStatement ps = conn.prepareStatement("SELECT * FROM forms ORDER BY form_id DESC");
		ResultSet rs = ps.executeQuery();

		boolean hasData = false;
		while (rs.next()) 
		{
			hasData = true;
		
%>
	<tr>
	<td><%= rs.getInt("form_id") %></td>
	<td><%= rs.getString("title") %></td>
	<td><%= rs.getString("description") %></td>
	<td><%= rs.getString("created_by") %></td>
	<td><%= rs.getTimestamp("created_at") %></td>
	<td class="actions">
		<a href="add_questions.jsp?formId=<%=rs.getInt("form_id")%>" class="add">Add Questions</a>
		<a href="fill_form.jsp?formId=<%=rs.getInt("form_id")%>" class="view">Fill Form</a>
		<a href="view_responses.jsp?formId=<%=rs.getInt("form_id")%>" class="view">View Responses</a>
	</td>
	</tr>
	<%
	}
		if (!hasData) 
		{
		%>
		<tr><td colspan="6" style="text-align:center;">No forms created yet.</td></tr>
		<%
		}
		conn.close();
		} 
catch (Exception e) 
{
	out.println("<tr><td colspan='6' style='color:red;text-align:center;'>Error: " + e.getMessage() + "</td></tr>");
}
%>
</table>
</div>

</body>
</html>
