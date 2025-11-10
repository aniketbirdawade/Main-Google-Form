<%@ page import="java.sql.*, com.formbuilder.db.DBConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Questions</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f6fa;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        form {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            width: 420px;
        }
        select, input, textarea {
            width: 100%;
            padding: 10px;
            margin-top: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        button {
            margin-top: 15px;
            padding: 10px 20px;
            background-color: #007bff;
            border: none;
            color: white;
            border-radius: 6px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

<form action="AddQuestionServlet" method="post">
    <h2>Add Question to Form</h2>

    <label>Select Form:</label>
    <select name="form_id" required>
        <option value="">-- Select Form --</option>
        <%
            try {
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement("SELECT form_id, title FROM forms");
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
        %>
                    <option value="<%= rs.getInt("form_id") %>"><%= rs.getString("title") %></option>
        <%
                }
                rs.close();
                ps.close();
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>
    </select>

    <label>Question Text:</label>
    <textarea name="question_text" required></textarea>

    <label>Question Type:</label>
    <select name="question_type" required>
        <option value="text">Text</option>
        <option value="radio">Multiple Choice (Single Answer)</option>
        <option value="checkbox">Checkbox (Multiple Answers)</option>
    </select>

    <label>Options (comma-separated for radio/checkbox):</label>
    <input type="text" name="options" placeholder="e.g. Yes,No,Maybe">

    <button type="submit">Add Question</button>
</form>

</body>
</html>
