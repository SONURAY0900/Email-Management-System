package Email;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/authServlet")
public class authServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String name = request.getParameter("name");      
        String username = request.getParameter("username");
        String email = request.getParameter("email");    
        String password = request.getParameter("password"); 
        String loginPass = request.getParameter("pass"); 

        try (Connection con = DataConnection.getCon()) {
            if (name != null && email != null && password != null) {
                // -------- REGISTER CASE ----------
                String sql = "INSERT INTO EmailData(name, username, email, password) VALUES(?,?,?,?)";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, name);
                ps.setString(2, username);
                ps.setString(3, email);
                ps.setString(4, password);

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    out.println("<h3 style='color:green'>Registered Successfully! <a href='login.html'>Login</a></h3>");
                } else {
                    out.println("<h3 style='color:red'>Registration Failed!</h3>");
                }
            } 
            else if (username != null && loginPass != null) {
                // -------- LOGIN CASE ----------
                String sql = "SELECT * FROM EmailData WHERE username=? AND password=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, username);
                ps.setString(2, loginPass);

                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    HttpSession session = request.getSession();
                    session.setAttribute("username", username);
                    response.sendRedirect("home.jsp");  
                } else {
                    out.println("<h3 style='color:red'>Invalid Username or Password</h3>");
                }
            } 
            else {
                out.println("<h3 style='color:red'>Invalid Request</h3>");
            }
        } 
        catch (Exception e) {
            e.printStackTrace(out);
        }
    }
}
