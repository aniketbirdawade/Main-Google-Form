package com.formbuilder.servlets;

import java.io.IOException;
import java.sql.*;
import com.formbuilder.db.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/CreateFormServlet")
public class CreateFormServlet extends HttpServlet 
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException 
    {

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String createdBy = request.getParameter("created_by");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try 
        {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO forms (title, description, created_by, created_at) VALUES (?, ?, ?, NOW())";
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, createdBy);
            ps.executeUpdate();

            rs = ps.getGeneratedKeys();
            if (rs.next()) 
            {
                int formId = rs.getInt(1);
                response.sendRedirect("add_questions.jsp?form_id=" + formId);
            } 
            else 
            {
                response.sendRedirect("admin_dashboard.jsp?msg=Form+creation+failed!");
            }

        } 
        catch (Exception e) 
        {
            e.printStackTrace();
            response.sendRedirect("admin_dashboard.jsp?msg=Error:+Form+creation+failed!");
        } 
        finally 
        {
            try 
            { 
            	if (rs != null) rs.close(); 
            	} 
            catch (Exception ignored) 
            {
            	
            }
            try 
            { 
            	if (ps != null) ps.close(); 
            	} 
            catch (Exception ignored) 
            {
            	
            }
            try 
            { 
            	if (conn != null) conn.close(); 
            	} 
            catch (Exception ignored) 
            {
            	
            }
        }
    }
}
