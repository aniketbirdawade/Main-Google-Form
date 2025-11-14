<%@ page import="java.sql.*, com.formbuilder.db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Fill Form (Multi-page)</title>
  <style>
    body
    {
    font-family:Arial; 
    background:white; 
    padding:30px;
    }
    .box
    {
    background:white;
    padding:20px;
    border-radius:8px;
    width:700px;
    margin:auto;
    box-shadow:0 2px 8px rgba(0,0,0,0.1);
    }
    label
    {
    display:block;
    font-weight:bold;
    margin-top:12px;
    }
    input[type=text]
    {
    width:100%;
    padding:8px;
    margin-top:6px;
    border:1px solid #ccc;
    border-radius:4px;
    }
    .btn
    {
    background:grey;
    color:black;
    padding:10px 14px;
    border:none;
    border-radius:4px;
    cursor:pointer;
    margin-top:14px;
    }
  </style>
</head>
<body>
<div class="box">
<%
    Connection conn = null;
    try 
    {
        String formId = request.getParameter("form_id");
        if (formId == null || formId.trim().isEmpty()) 
        {
            out.println("<h3 style='color:red;text-align:center;'>Error: No form ID provided.</h3>");
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
            catch(Exception ex)
            { 
            	currentPage = 1; 
            }
        }

        conn = DBConnection.getConnection();

        PreparedStatement psForm = conn.prepareStatement("SELECT title, description FROM forms WHERE form_id = ?");
        psForm.setInt(1, formIdInt);
        ResultSet rsForm = psForm.executeQuery();
        if (!rsForm.next()) 
        {
            out.println("<h3 style='color:red;text-align:center;'>Form not found.</h3>");
            rsForm.close(); psForm.close();
            return;
        }
        String title = rsForm.getString("title");
        String description = rsForm.getString("description");
        rsForm.close(); psForm.close();

        boolean hasNextPage = false;
        PreparedStatement psNext = conn.prepareStatement(
            "SELECT COUNT(*) AS cnt FROM questions WHERE form_id = ? AND page_number > ?");
        psNext.setInt(1, formIdInt);
        psNext.setInt(2, currentPage);
        ResultSet rsNext = psNext.executeQuery();
        if (rsNext.next()) 
        {
            hasNextPage = rsNext.getInt("cnt") > 0;
        }
        rsNext.close(); psNext.close();

        PreparedStatement psQ = conn.prepareStatement(
            "SELECT question_id, question_text, question_type, options FROM questions WHERE form_id = ? AND page_number = ? ORDER BY question_id"
        );
        psQ.setInt(1, formIdInt);
        psQ.setInt(2, currentPage);
        ResultSet rsQ = psQ.executeQuery();
%>

    <h2 style="text-align:center;"><%= title %></h2>
    <p style="text-align:center;
    color:#666;"><%= description %></p>

    <form action="<%= hasNextPage ? "fill_form.jsp" : "SubmitResponseServlet" %>" method="post">
        <input type="hidden" name="form_id" value="<%= formId %>">
        <input type="hidden" name="page" value="<%= currentPage + 1 %>">

<%
        boolean hasQuestions = false;
        while (rsQ.next()) 
        {
            hasQuestions = true;
            int qid = rsQ.getInt("question_id");
            String qtext = rsQ.getString("question_text");
            String qtype = rsQ.getString("question_type");
            String options = rsQ.getString("options");
%>
        <label><%= qtext %></label>
<%
            if (qtype == null || "text".equalsIgnoreCase(qtype)) 
            {
%>
        <input type="text" name="q_<%= qid %>" />
<%
            } 
            else if ("radio".equalsIgnoreCase(qtype)) 
            {
                if (options != null && !options.trim().isEmpty()) 
                {
                    for (String opt : options.split(",")) 
                    {
%>
        <div><input type="radio" name="q_<%= qid %>" value="<%= opt.trim() %>"> <%= opt.trim() %></div>
<%
                    }
                }
            } 
            else if ("checkbox".equalsIgnoreCase(qtype)) 
            {
                if (options != null && !options.trim().isEmpty()) 
                {
                    for (String opt : options.split(",")) 
                    {
%>
        <div><input type="checkbox" name="q_<%= qid %>" value="<%= opt.trim() %>"> <%= opt.trim() %></div>
<%
                    }
                }
            } 
            else 
            {
%>
        <input type="text" name="q_<%= qid %>" />
<%
            }
        }
        rsQ.close(); psQ.close();

        if (!hasQuestions) 
        {
            out.println("<p style='color:#c00;text-align:center;'>No questions on this page.</p>");
        }
%>

        <div style="text-align:center;">
<%
        if (hasNextPage) 
        {
%>
            <button type="submit" class="btn">Next Page</button>
<%
        } 
        else 
        {
%>
            <button type="submit" class="btn">Submit</button>
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
        catch(Exception ignored)
        {
        	
        }
    }
%>
</div>
</body>
</html>
