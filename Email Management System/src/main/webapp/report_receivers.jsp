<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
Connection con = null;
Statement stmt = null;
ResultSet rs = null;
List<String> receivers = new ArrayList<>();
List<Integer> counts = new ArrayList<>();

try {
    Class.forName("oracle.jdbc.driver.OracleDriver");
    con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "0900");
    stmt = con.createStatement();

    String sql = "SELECT RECEIVER, COUNT(*) AS EMAIL_COUNT FROM EMAILS GROUP BY RECEIVER ORDER BY EMAIL_COUNT DESC";
    rs = stmt.executeQuery(sql);

    while (rs.next()) {
        receivers.add(rs.getString("RECEIVER"));
        counts.add(rs.getInt("EMAIL_COUNT"));
    }
} catch (Exception e) {
    e.printStackTrace();
} finally {
    try { if (rs != null) rs.close(); } catch (Exception e) {}
    try { if (stmt != null) stmt.close(); } catch (Exception e) {}
    try { if (con != null) con.close(); } catch (Exception e) {}
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>📧 Top Receivers Report</title>
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

h2 {
    text-align: center;
    color: white;
    margin-bottom: 40px;
    font-size: 2.5rem;
    font-weight: 600;
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
}

h3 {
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

/* Stats summary */
.stats-summary {
    display: flex;
    gap: 20px;
    margin-bottom: 20px;
    justify-content: center;
    flex-wrap: wrap;
}

.stat-box {
    background: rgba(255, 255, 255, 0.95);
    padding: 20px 25px;
    border-radius: 15px;
    text-align: center;
    min-width: 150px;
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    backdrop-filter: blur(10px);
}

.stat-box:hover {
    transform: translateY(-5px);
    box-shadow: 0 12px 35px rgba(0, 0, 0, 0.15);
}

.stat-number {
    font-size: 28px;
    font-weight: bold;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    margin-bottom: 8px;
}

.stat-label {
    font-size: 12px;
    color: #666;
    text-transform: uppercase;
    letter-spacing: 1px;
    font-weight: 500;
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
    h2 {
        font-size: 2rem;
    }
    
    .stats-summary {
        flex-direction: column;
        align-items: center;
    }
    
    .stat-box {
        width: 100%;
        max-width: 250px;
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

    <h2>📧 Top Receivers Report</h2>

    <!-- Stats Summary -->
    <div class="stats-summary">
        <div class="stat-box">
            <div class="stat-number"><%= receivers.size() %></div>
            <div class="stat-label">Total Receivers</div>
        </div>
        
        <div class="stat-box">
            <div class="stat-number"><%= counts.isEmpty() ? 0 : counts.get(0) %></div>
            <div class="stat-label">Top Receiver Emails</div>
        </div>
        
        <div class="stat-box">
            <div class="stat-number"><%= counts.stream().mapToInt(Integer::intValue).sum() %></div>
            <div class="stat-label">Total Emails</div>
        </div>
    </div>

    <!-- Table Section -->
    <div class="section">
        <h3>📋 Receivers and Email Count</h3>
        <table>
            <tr>
                <th>Receiver</th>
                <th>Email Count</th>
            </tr>
            <%
            for (int i = 0; i < receivers.size(); i++) {
            %>
            <tr>
                <td><%= receivers.get(i) %></td>
                <td><%= counts.get(i) %></td>
            </tr>
            <% } %>
        </table>
    </div>

</div>

 <script src="style.js"></script>

</body>
</html>