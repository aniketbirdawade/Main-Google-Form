<%@ page import="java.sql.*, com.formbuilder.db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Questions</title>
    <style>
        body 
        { 
        font-family: Arial, sans-serif; 
        background-color: #f0f2f5; 
        padding: 30px; 
        }
        form 
        { 
        background: #fff; 
        padding: 20px; 
        border-radius: 8px; 
        width: 600px; 
        margin: auto; 
        box-shadow: 0 2px 10px rgba(0,0,0,0.1); 
        }
        h2 
        { 
        text-align: center; 
        color: #333; 
        }
        label 
        { 
        font-weight: bold; 
        display: block; 
        margin-top: 15px; 
        }
        input[type="text"], 
        textarea, 
        select, 
        input[type="number"] 
        { 
        width: 100%; 
        padding: 8px; 
        margin-top: 5px; 
        border-radius: 5px; 
        border: 1px solid #ccc; 
        }
        button 
        { background-color: grey; 
        color: white; 
        padding: 10px 15px; 
        border: none; 
        border-radius: 5px; 
        margin-top: 15px; 
        cursor: pointer; 
        }
        button:hover 
        { 
        background-color: grey; 
        }
        .back 
        { 
        display: inline-block; 
        margin-bottom: 20px; 
        text-decoration: none; 
        color: grey; 
        font-weight: bold; 
        }
        .message 
        { text-align: center; 
        margin-bottom: 15px; 
        font-weight: bold; 
        }
        .success 
        { 
        color: green; 
        }
        .error 
        { 
        color: red; 
        }
    </style>
</head>
<body>

<%
    Object formIdObj = request.getAttribute("formId");
    String formId = null;
    if (formIdObj != null) 
    {
        formId = formIdObj.toString();
    } 
    else 
    {
        formId = request.getParameter("form_id");
    }

    if (formId == null || formId.trim().isEmpty()) 
    {
        out.println("<h3 style='color:red;text-align:center;'>Invalid form ID!</h3>");
        return;
    }

    String successMsg = (String) request.getAttribute("successMsg");
    String errorMsg = (String) request.getAttribute("errorMsg");
%>

<a href="index.jsp" class="back">&larr; Back to Dashboard</a>

<% if (successMsg != null) 
{ %>
    <div class="message success"><%= successMsg %></div>
<% 
} 
%>
<% if (errorMsg != null) 
{ 
%>
    <div class="message error"><%= errorMsg %></div>
<% 
} 
%>

<form action="AddQuestionServlet" method="post">
    <input type="hidden" name="form_id" value="<%= formId %>">

    <h2>Add Question</h2>

    <label>Question Text:</label>
    <input type="text" name="question_text" required>

    <label>Question Type:</label>
    <select name="question_type" required>
        <option value="text">Text</option>
        <option value="radio">Multiple Choice (Single Answer)</option>
        <option value="checkbox">Check Box (Multiple Answers)</option>
    </select>

    <label>Options (comma separated):</label>
    <input type="text" name="options" placeholder="e.g. Yes, No, Maybe">

    <label>Page Number:</label>
    <input type="number" name="page_number" value="1" min="1" required>

    <button type="submit">Add Question</button>
</form>

</body>
</html>
