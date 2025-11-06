<%@ page import="java.sql.*, com.formbuilder.db.DBConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Responses</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f9f9f9; padding: 30px; }
        h2 { color: #333; text-align: center; }
        table { width: 90%; margin: 20px auto; border-collapse: collapse; background: white; }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background: #4CAF50; color: white; }
        tr:nth-child(even) { background: #f2f2f2; }
        .container { text-align: center; margin-bottom: 20px; }
        select, button { padding: 8px; font-size: 14px; }
    </style>
</head>
<body>
    <h2>View Form Responses</h2>

    <div class="container">
        <form action="ViewResponsesServlet" method="get">
            <label for="formId">Select Form: </label>
            <select name="formId" id="formId" required>
                <option value="">-- Choose a form --</option>
                <%
                    try {
                        Connection conn = DBConnection.getConnection();
                        PreparedStatement ps = conn.prepareStatement("SELECT form_id, title FROM forms");
                        ResultSet rs = ps.executeQuery();
                        while (rs.next()) {
                            int id = rs.getInt("form_id");
                            String title = rs.getString("title");
                %>
                            <option value="<%=id%>"><%=title%></option>
                <%
                        }
                        conn.close();
                    } catch (Exception e) {
                        out.println("<option disabled>Error loading forms</option>");
                    }
                %>
            </select>
            <button type="submit">View Responses</button>
        </form>
    </div>

    <%
        String formId = request.getParameter("formId");
        if (formId != null) {
            try {
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(
                    "SELECT question_text, answer_text, user_name, submitted_at " +
                    "FROM responses WHERE form_id = ? ORDER BY user_name"
                );
                ps.setInt(1, Integer.parseInt(formId));
                ResultSet rs = ps.executeQuery();

                boolean hasData = false;
    %>

                <table>
                    <tr>
                        <th>User</th>
                        <th>Question</th>
                        <th>Answer</th>
                        <th>Submitted At</th>
                    </tr>

    <%
                while (rs.next()) {
                    hasData = true;
    %>
                    <tr>
                        <td><%= rs.getString("user_name") %></td>
                        <td><%= rs.getString("question_text") %></td>
                        <td><%= rs.getString("answer_text") %></td>
                        <td><%= rs.getTimestamp("submitted_at") %></td>
                    </tr>
    <%
                }
                if (!hasData) {
    %>
                    <tr><td colspan="4" style="text-align:center;">No responses yet for this form.</td></tr>
    <%
                }
                conn.close();
            } catch (Exception e) {
                out.println("<p style='color:red;text-align:center;'>Error: " + e.getMessage() + "</p>");
            }
        }
    %>

    </table>
</body>
</html>
