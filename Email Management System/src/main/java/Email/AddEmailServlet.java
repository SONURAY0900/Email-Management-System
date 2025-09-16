package Email;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/AddEmailServlet")
public class AddEmailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Get form parameters
        String sender = request.getParameter("sender");
        String receiver = request.getParameter("receiver");
        String subject = request.getParameter("subject");
        String body = request.getParameter("body");
        String date = request.getParameter("date");

        // Server-side validation: check if any field is null or empty
        if (isNullOrEmpty(sender) || isNullOrEmpty(receiver) || isNullOrEmpty(subject)
                || isNullOrEmpty(body) || isNullOrEmpty(date)) {
            out.println("<h3 style='color:red; text-align:center;'>All fields are required!</h3>");
            out.println("<p style='text-align:center;'><a href='addEmail.html'>Go Back</a></p>");
            return;
        }

        // Replace T in datetime-local input for Oracle
        String formattedDate = date.replace("T", " "); // e.g., "2025-09-07 11:30"

        String sql = "INSERT INTO EMAILS(EMAIL_ID, SENDER, RECEIVER, SUBJECT, BODY, SENT_DATE) " +
                     "VALUES(EMAILS_SEQ.NEXTVAL, ?, ?, ?, ?, TO_DATE(?, 'YYYY-MM-DD HH24:MI'))";

        try (Connection con = DataConnection.getCon();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, sender);
            ps.setString(2, receiver);
            ps.setString(3, subject);
            ps.setString(4, body);
            ps.setString(5, formattedDate);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                out.println("<h3 style='color:green; text-align:center;'>✅ Email Added Successfully!</h3>");
                out.println("<div style='text-align:center; margin-top:20px;'>");
                out.println("<a href='home.jsp' " +
                            "style='display:inline-block; padding:10px 20px; " +
                            "background-color:#4CAF50; color:white; text-decoration:none; " +
                            "border-radius:8px; font-weight:bold;'>⬅ Go Back</a>");
                out.println("</div>");
            } else {
                out.println("<h3 style='color:red; text-align:center;'>❌ Failed to send email.</h3>");
                out.println("<div style='text-align:center; margin-top:20px;'>");
                out.println("<a href='addEmail.html' " +
                            "style='display:inline-block; padding:10px 20px; " +
                            "background-color:#f44336; color:white; text-decoration:none; " +
                            "border-radius:8px; font-weight:bold;'>⬅ Try Again</a>");
                out.println("</div>");
            }


        } catch (Exception e) {
            e.printStackTrace(out);
            out.println("<h3 style='color:red; text-align:center;'>Error: " + e.getMessage() + "</h3>");
            out.println("<p style='text-align:center;'><a href='addEmail.html'>Go Back</a></p>");
        }
    }

    // Utility method to check null or empty
    private boolean isNullOrEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }
}
