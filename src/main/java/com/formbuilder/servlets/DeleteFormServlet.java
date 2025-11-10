package com.formbuilder.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import com.formbuilder.db.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/DeleteFormServlet")
public class DeleteFormServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String formIdParam = request.getParameter("form_id");

        if (formIdParam == null || formIdParam.isEmpty()) {
            response.sendRedirect("index.jsp?msg=Invalid+Form+ID");
            return;
        }

        try {
            int formId = Integer.parseInt(formIdParam);
            Connection conn = DBConnection.getConnection();

            // Delete questions first (because of foreign key constraints)
            PreparedStatement ps1 = conn.prepareStatement("DELETE FROM questions WHERE form_id = ?");
            ps1.setInt(1, formId);
            ps1.executeUpdate();

            // Then delete the form itself
            PreparedStatement ps2 = conn.prepareStatement("DELETE FROM forms WHERE form_id = ?");
            ps2.setInt(1, formId);
            int rows = ps2.executeUpdate();

            conn.close();

            if (rows > 0) {
                response.sendRedirect("index.jsp?msg=Form+Deleted+Successfully");
            } else {
                response.sendRedirect("index.jsp?msg=Invalid+Form+ID");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?msg=Error+Deleting+Form");
        }
    }
}
