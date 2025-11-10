<%@ page import="java.sql.*" %>
<%@ page import="com.formbuilder.db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>View Form Responses</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f4f6f8;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 80%;
            margin: 40px auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            padding: 30px;
        }
        h1 {
            text-align: center;
            color: #333;
        }
        .response-block {
            margin: 20px 0;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background: #fafafa;
        }
        .question {
            font-weight: bold;
            color: #222;
        }
        .answer {
            color: #555;
            margin-left: 10px;
        }
        a.button {
            display: inline-block;
            text-decoration: none;
            background: #0078d7;
            color: white;
            padding: 10px 20px;
            border-radius: 6px;
            margin-bottom: 20px;
        }
        a.button:hover {
            background: #005fa3;
        }
    </style>
</head>
<body>
<div class="container">
    <a href="index.jsp" class="button">← Back to Forms</a>
    <h1>Form Responses</h1>

    <%
        String formIdStr = request.getParameter("form_id");
        if (formIdStr == null || formIdStr.isEmpty()) {
    %>
        <p style="color:red;">No form selected.</p>
    <%
        } else {
            int formId = Integer.parseInt(formIdStr);
            Connection conn = null;
            PreparedStatement psForm = null, psResponses = null, psAnswers = null;
            ResultSet rsForm = null, rsResponses = null, rsAnswers = null;

            try {
                conn = DBConnection.getConnection();

                // Fetch form title
                psForm = conn.prepareStatement("SELECT title FROM forms WHERE form_id=?");
                psForm.setInt(1, formId);
                rsForm = psForm.executeQuery();
                if (rsForm.next()) {
    %>
                    <h2><%= rsForm.getString("title") %></h2>
    <%
                }

                // Fetch responses
                psResponses = conn.prepareStatement("SELECT response_id FROM responses WHERE form_id=? ORDER BY response_id DESC");
                psResponses.setInt(1, formId);
                rsResponses = psResponses.executeQuery();

                boolean hasResponses = false;
                while (rsResponses.next()) {
                    hasResponses = true;
                    int responseId = rsResponses.getInt("response_id");
    %>
                    <div class="response-block">
                        <h3>Response ID: <%= responseId %></h3>
                        <%
                            psAnswers = conn.prepareStatement(
                                "SELECT q.question_text, a.answer_text " +
                                "FROM answers a JOIN questions q ON a.question_id = q.question_id " +
                                "WHERE a.response_id = ?"
                            );
                            psAnswers.setInt(1, responseId);
                            rsAnswers = psAnswers.executeQuery();

                            while (rsAnswers.next()) {
                        %>
                                <p><span class="question"><%= rsAnswers.getString("question_text") %>:</span>
                                   <span class="answer"><%= rsAnswers.getString("answer_text") %></span></p>
                        <%
                            }
                            rsAnswers.close();
                            psAnswers.close();
                        %>
                    </div>
    <%
                }
                if (!hasResponses) {
    %>
                    <p>No responses yet.</p>
    <%
                }

            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p style='color:red;'>Error loading responses: " + e.getMessage() + "</p>");
            } finally {
                try {
                    if (rsForm != null) rsForm.close();
                    if (rsResponses != null) rsResponses.close();
                    if (psForm != null) psForm.close();
                    if (psResponses != null) psResponses.close();
                    if (conn != null) conn.close();
                } catch (Exception ex) { ex.printStackTrace(); }
            }
        }
    %>
</div>
</body>
</html>
