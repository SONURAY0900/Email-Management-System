<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.html"); 
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Email Management System !</title>
<link rel="stylesheet" href="home.css">
 <link rel="stylesheet" href="dynamic-styles.css">
 <style>
/* ✅ Stats Section Styling */
.stats-summary {
  padding: 40px;
  background: #f9f9f9;
  text-align: center;
}

.stats-summary h2 {
  font-size: 28px;
  margin-bottom: 25px;
  color: #333;
}

.stats-container {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 20px;
  max-width: 900px;
  margin: auto;
}

.stat-card {
  background: white;
  padding: 25px;
  border-radius: 15px;
  box-shadow: 0px 4px 10px rgba(0,0,0,0.1);
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.stat-card:hover {
  transform: translateY(-5px);
  box-shadow: 0px 6px 14px rgba(0,0,0,0.15);
}

.stat-number {
  font-size: 36px;
  font-weight: bold;
  color: #007bff;
  display: block;
  margin-bottom: 10px;
}

.stat-label {
  font-size: 18px;
  color: #555;
}
</style>
</head>
<body>
<header class="navbar">
   <h1>📧 Email Management System</h1>
     <nav>
       <a href="#home">[ Home ]</a>&nbsp;&nbsp;
       <a href="#about">[ About ]</a>&nbsp;&nbsp; 
       <a href="#features">[ Features ]</a>&nbsp;&nbsp;
       <a href="#reports">[ Reports ]</a>
       <% if(username != null) { %>
           <span style="color:white; font-weight:bold;">Welcome, <%= username %>!</span>&nbsp;&nbsp;
           <a href="logout.jsp">[ Logout ]</a>
       <% } else { %>
           <a href="login.html">[ Login ]</a>
           <a href="register.html">[ Register ]</a>
       <% } %>
     </nav>
</header>

<section class="hero" id="home">
    <h1>Organize Your Emails with Ease 📩</h1>
    <p>
     The Email Management System is a mini DBMS project that helps students and teachers 
      store, view, and analyze emails. It supports features like searching, filtering, 
      and generating useful reports such as emails by sender, date, or keyword.
    </p>
     <button class="btn-primary" onclick="window.location.href='addEmail.html'">➕ Add Email</button>
    <button class="btn-secondary" onclick="window.location.href='view.jsp'">📩 View Emails</button>
     <button class="btn-secondary" onclick="window.location.href='report.html'">📊 Reports</button>
</section>

 <section class="first-section">
      <h1>How It Works (Steps)</h1>
     <div>
      <p>📝 Step 1 ➝ <b>Add Email</b></p>
      <p>📂 Step 2 ➝ <b>Store in Database</b></p>
      <p>🔍 Step 3 ➝ <b>View/Search Emails</b></p>
      <p>📊 Step 4 ➝ <b>Generate Reports</b></p>
      <p>⚡ Step 5 ➝ <b>Filter & Analyze Data</b></p>
      <p>☁️ Step 6 ➝ <b>Export/Download Reports</b></p>
     </div>
   </section>

  <section class="features" id="features">
  <h2>System Features</h2>
    <div class="card-container">
     
     <div class="card">
       <h3>➕ Add Emails</h3>
        <p>Insert new emails with sender, receiver, subject, body, and date using an entry form.</p>
     </div>
      
    <div class="card">
      <h3>📩 View Emails</h3>
      <p>Display all stored emails in tabular format with details like sender, receiver, and date.</p>
      </div>
      
      <div class="card">
        <h3>📊 Reports</h3>
        <p>Generate reports like emails per sender, keyword-based search, and emails between dates.</p>
      </div>
      
    </div>
  </section>

<section class="reports" id="reports">
  <h2>📊 Reports Available</h2>
    <p>The project supports multiple types of reports based on SQL queries:</p>
   <ul>
      <li>📅 Emails between two dates</li>
      <li>👨‍💻 Emails sent by each sender (count)</li>
      <li>🔍 Search emails containing specific keywords (e.g., "Assignment")</li>
      <li>⏳ Find latest and first email</li>
      <li>📊 Total emails sent per day</li>
    </ul>
    <p><i>These reports help in understanding communication patterns and data analysis.</i></p>
  </section>
  
  <section class="stats-summary">
   <h2>📈 Project Stats</h2>
   <div class="stats-container">
      <div class="stat-card">
         <span class="stat-number">120</span>
         <span class="stat-label">Emails Stored</span>
      </div>
      <div class="stat-card">
         <span class="stat-number">45</span>
         <span class="stat-label">Users Registered</span>
      </div>
      <div class="stat-card">
         <span class="stat-number">75</span>
         <span class="stat-label">Reports Generated</span>
      </div>
   </div>
</section>

  <section class="about" id="about">
   <h2>About Projects</h2>
     <p>
      The Email Management System is developed as a database mini-project to practice SQL and Java (JSP/Servlet).  
      It demonstrates CRUD operations, SQL queries, and report generation.  
      It is designed for students, teachers, and administrators to easily manage academic emails.
    </p>
  </section>
  
  <footer class="footer">
     <p>© 2025 Email Management System | All Rights Reserved | Designed by <b>Sonu Ray</b></p>
  </footer>
</body>
</html>
