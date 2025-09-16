<%@ page import="java.sql.*,java.util.*,Email.DataConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

String keyword = request.getParameter("keyword");
if(keyword == null || keyword.trim().isEmpty()){
    keyword = "Assignment"; // default
}

List<String> senders = new ArrayList<>();
List<String> subjects = new ArrayList<>();
List<String> receivers = new ArrayList<>();
List<String> dates = new ArrayList<>();

int matchCount = 0;

try {
    con = DataConnection.getCon();
    ps = con.prepareStatement(
        "SELECT SENDER, RECEIVER, SUBJECT, SENT_DATE " +
        "FROM EMAILS " +
        "WHERE LOWER(SUBJECT) LIKE ? OR LOWER(BODY) LIKE ? " +
        "ORDER BY SENT_DATE DESC"
    );
    ps.setString(1, "%" + keyword.toLowerCase() + "%");
    ps.setString(2, "%" + keyword.toLowerCase() + "%");
    rs = ps.executeQuery();

    while(rs.next()){
        senders.add(rs.getString("SENDER"));
        receivers.add(rs.getString("RECEIVER"));
        subjects.add(rs.getString("SUBJECT"));
        dates.add(rs.getDate("SENT_DATE").toString());
        matchCount++;
    }

} catch(Exception e) {
    out.println("<p style='color:red'>Error: " + e.getMessage() + "</p>");
} finally {
    if(rs != null) try{rs.close();}catch(Exception ex){}
    if(ps != null) try{ps.close();}catch(Exception ex){}
    if(con != null) try{con.close();}catch(Exception ex){}
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Keyword Report</title>
 <link rel="stylesheet" href="dynamic-styles.css">
<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
    padding: 20px;
}

.container {
    max-width: 1200px;
    margin: 0 auto;
    animation: fadeIn 0.5s ease-in;
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
}

.back-button {
    background: rgba(255, 255, 255, 0.2);
    backdrop-filter: blur(10px);
    color: white;
    border: 1px solid rgba(255, 255, 255, 0.3);
    padding: 12px 24px;
    border-radius: 30px;
    cursor: pointer;
    font-size: 14px;
    font-weight: 500;
    margin-bottom: 30px;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    transition: all 0.3s ease;
}

.back-button:hover {
    background: rgba(255, 255, 255, 0.3);
    transform: translateX(-5px);
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
}

h1 {
    text-align: center;
    color: white;
    margin-bottom: 40px;
    font-size: 2.5rem;
    font-weight: 600;
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
}

h2 {
    color: #333;
    margin-bottom: 20px;
    padding-bottom: 10px;
    border-bottom: 3px solid;
    border-image: linear-gradient(90deg, #667eea, #764ba2) 1;
    font-size: 1.3rem;
    display: flex;
    align-items: center;
    gap: 10px;
}

.search-box {
    text-align: center;
    margin-bottom: 30px;
}

.search-box form {
    display: inline-flex;
    gap: 10px;
    align-items: center;
    background: rgba(255, 255, 255, 0.95);
    padding: 20px 30px;
    border-radius: 50px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
    backdrop-filter: blur(10px);
    transition: transform 0.3s ease;
}

.search-box form:hover {
    transform: translateY(-2px);
    box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
}

.search-box input {
    padding: 12px 20px;
    width: 300px;
    border: 2px solid transparent;
    border-radius: 25px;
    font-size: 16px;
    background: rgba(255, 255, 255, 0.9);
    transition: all 0.3s ease;
    outline: none;
}

.search-box input:focus {
    border-color: #667eea;
    box-shadow: 0 0 20px rgba(102, 126, 234, 0.3);
    transform: scale(1.02);
}

.search-box button {
    padding: 12px 25px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    border: none;
    border-radius: 25px;
    cursor: pointer;
    font-size: 16px;
    font-weight: 600;
    transition: all 0.3s ease;
    box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
}

.search-box button:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
    background: linear-gradient(135deg, #5a67d8 0%, #6b3a8e 100%);
}

.section {
    background: rgba(255, 255, 255, 0.95);
    padding: 30px;
    border-radius: 20px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
    backdrop-filter: blur(10px);
    transition: transform 0.3s ease;
    margin-bottom: 25px;
}

.section:hover {
    transform: translateY(-3px);
}

table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0;
    overflow: hidden;
    border-radius: 10px;
    margin-top: 15px;
}

th {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 15px;
    text-align: center;
    font-weight: 600;
    text-transform: uppercase;
    font-size: 12px;
    letter-spacing: 1px;
}

td {
    padding: 15px;
    border-bottom: 1px solid #e0e0e0;
    color: #333;
    font-size: 14px;
    text-align: center;
}

tr {
    background: white;
    transition: all 0.3s ease;
}

tr:hover {
    background: linear-gradient(90deg, rgba(102, 126, 234, 0.05), rgba(118, 75, 162, 0.05));
    transform: scale(1.01);
}

tr:last-child td {
    border-bottom: none;
}

/* Scrollbar Styling */
::-webkit-scrollbar {
    width: 10px;
    height: 10px;
}

::-webkit-scrollbar-track {
    background: #f1f1f1;
    border-radius: 10px;
}

::-webkit-scrollbar-thumb {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border-radius: 10px;
}

::-webkit-scrollbar-thumb:hover {
    background: linear-gradient(135deg, #5a67d8 0%, #6b3a8e 100%);
}

@media (max-width: 768px) {
    h1 {
        font-size: 2rem;
    }
    
    .search-box input {
        width: 200px;
        font-size: 14px;
    }
    
    .search-box form {
        flex-direction: column;
        gap: 15px;
    }
    
    .section {
        padding: 20px;
    }
    
    table {
        font-size: 12px;
    }
    
    th, td {
        padding: 10px 8px;
    }
}

/* Loading Animation */
.loading {
    display: inline-block;
    width: 20px;
    height: 20px;
    border: 3px solid rgba(102, 126, 234, 0.3);
    border-radius: 50%;
    border-top-color: #667eea;
    animation: spin 1s ease-in-out infinite;
}

@keyframes spin {
    to { transform: rotate(360deg); }
}

/* Match count styling */
.match-count {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    font-weight: bold;
}
</style>
</head>
<body>

<div class="container">
    <!-- Back Button -->
    <a href="report.html" class="back-button">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M19 12H5M12 19l-7-7 7-7"/>
        </svg>
        Back to Reports
    </a>
    <h1>🔍 Emails with Keyword</h1>

    <!-- Search Box -->
    <div class="search-box">
        <form method="get">
            <input type="text" name="keyword" placeholder="Enter keyword..." value="<%= keyword %>">
            <button type="submit">Search</button>
        </form>
    </div>

    <!-- Table Section -->
    <div class="section">
        <h2>📑 Matching Emails (<span class="match-count"><%= matchCount %></span>)</h2>
        <table>
            <tr><th>Sender</th><th>Receiver</th><th>Subject</th><th>Date</th></tr>
            <%
            for(int i=0; i<senders.size(); i++){
            %>
            <tr>
                <td><%= senders.get(i) %></td>
                <td><%= receivers.get(i) %></td>
                <td><%= subjects.get(i) %></td>
                <td><%= dates.get(i) %></td>
            </tr>
            <% } %>
        </table>
    </div>

</div>
<!--  <script src="style.js"></script>
 --></body>
</html>