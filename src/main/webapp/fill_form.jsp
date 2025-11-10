<%@ page import="java.sql.*, com.formbuilder.db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Fill Form</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            padding: 30px;
        }
        form {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            width: 600px;
            margin: auto;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            color: #333;
        }
        label {
            font-weight: bold;
            display: block;
            margin-top: 15px;
        }
        input[type="text"], textarea {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }
        input[type="radio"], input[type="checkbox"] {
            margin-right: 8px;
        }
        button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            margin-top: 15px;
            cursor: pointer;
        }
        button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
<%
    String formId = request.getParameter("form_id");
    if (formId == null || formId.isEmpty()) {
        out.println("<h3 style='color:red;text-align:center;'>Error: No form ID provided.</h3>");
    } else {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();

            PreparedStatement psForm = conn.prepareStatement("SELECT title, description FROM forms WHERE form_id = ?");
            psForm.setInt(1, Integer.parseInt(formId));
            ResultSet rsForm = psForm.executeQuery();

            if (rsForm.next()) {
%>
<form action="SubmitResponseServlet" method="post">
    <input type="hidden" name="form_id" value="<%= formId %>">
    <h2><%= rsForm.getString("title") %></h2>
    <p><%= rsForm.getString("description") %></p>

<%
    PreparedStatement psQ = conn.prepareStatement("SELECT * FROM questions WHERE form_id = ?");
    psQ.setInt(1, Integer.parseInt(formId));
    ResultSet rsQ = psQ.executeQuery();

    boolean hasQuestions = false;
    while (rsQ.next()) {
        hasQuestions = true;
        int qid = rsQ.getInt("question_id");
        String qtext = rsQ.getString("question_text");
        String qtype = rsQ.getString("question_type");
        String options = rsQ.getString("options");
%>
    <label><%= qtext %></label>
<%
        if ("text".equalsIgnoreCase(qtype)) {
%>
            <input type="text" name="q_<%=qid%>" placeholder="Your answer">
<%
        } else if ("radio".equalsIgnoreCase(qtype) || "checkbox".equalsIgnoreCase(qtype)) {
            if (options != null && !options.trim().isEmpty()) {
                String[] opts = options.split(",");
                for (String opt : opts) {
%>
                    <input type="<%= qtype %>" name="q_<%=qid%>" value="<%= opt.trim() %>"> <%= opt.trim() %><br>
<%
                }
            }
        }
    }

    if (!hasQuestions) {
        out.println("<p style='color:red;text-align:center;'>No questions available for this form.</p>");
    } else {
%>
    <button type="submit">Submit</button>
<%
    }
%>
</form>
<%
            } else {
                out.println("<h3 style='color:red;text-align:center;'>Form not found.</h3>");
            }

            conn.close();
        } catch (Exception e) {
            out.println("<p style='color:red;text-align:center;'>Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
    }
%>

</body>
</html>
