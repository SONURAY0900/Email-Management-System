<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🎯 Email Filter Report</title>
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

        /* Filter Form Styling */
        form {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            justify-content: center;
            margin-bottom: 25px;
            padding: 25px;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 5px;
            min-width: 150px;
        }

        label {
            font-size: 12px;
            color: #666;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 600;
        }

        input, select {
            padding: 12px 15px;
            border-radius: 10px;
            border: 2px solid rgba(102, 126, 234, 0.2);
            font-size: 14px;
            background: white;
            color: #333;
            transition: all 0.3s ease;
            font-family: inherit;
        }

        input:focus, select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            transform: translateY(-2px);
        }

        button {
            padding: 12px 25px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
            align-self: flex-end;
        }

        button:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        button:active {
            transform: translateY(0);
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

        .error {
            color: #e74c3c;
            background: rgba(231, 76, 60, 0.1);
            padding: 15px;
            border-radius: 10px;
            border-left: 4px solid #e74c3c;
            margin: 20px 0;
            text-align: center;
            font-weight: 500;
        }

        .no-results {
            color: #f39c12;
            background: rgba(243, 156, 18, 0.1);
            padding: 15px;
            border-radius: 10px;
            border-left: 4px solid #f39c12;
            text-align: center;
            font-weight: 500;
        }

        /* Filter indicators */
        .filter-indicator {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(102, 126, 234, 0.1);
            padding: 8px 12px;
            border-radius: 20px;
            font-size: 12px;
            color: #667eea;
            font-weight: 600;
            margin: 5px;
        }

        .active-filters {
            margin-bottom: 20px;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: center;
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
            
            form {
                flex-direction: column;
                align-items: stretch;
            }
            
            .form-group {
                min-width: auto;
            }
            
            button {
                align-self: stretch;
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
     <link rel="stylesheet" href="dynamic-styles.css">
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

    <h2>🎯 Email Filter Report</h2>

    <!-- Filter Form -->
    <form method="get">
        <div class="form-group">
            <label>Filter Type</label>
            <select name="filterType" required>
                <option value="">--Select Filter--</option>
                <option value="sender" <%= "sender".equals(request.getParameter("filterType")) ? "selected" : "" %>>Sender</option>
                <option value="receiver" <%= "receiver".equals(request.getParameter("filterType")) ? "selected" : "" %>>Receiver</option>
            </select>
        </div>

        <div class="form-group">
            <label>Email ID</label>
            <input type="text" name="filterValue" placeholder="Enter Email ID" value="<%= request.getParameter("filterValue") != null ? request.getParameter("filterValue") : "" %>" required>
        </div>

        <div class="form-group">
            <label>From Date</label>
            <input type="date" name="startDate" value="<%= request.getParameter("startDate") != null ? request.getParameter("startDate") : "" %>" required>
        </div>

        <div class="form-group">
            <label>To Date</label>
            <input type="date" name="endDate" value="<%= request.getParameter("endDate") != null ? request.getParameter("endDate") : "" %>" required>
        </div>

        <button type="submit">🔍 Apply Filter</button>
    </form>

    <%
    String filterType = request.getParameter("filterType");
    String filterValue = request.getParameter("filterValue");
    String startDate = request.getParameter("startDate");
    String endDate = request.getParameter("endDate");

    if(filterType != null && filterValue != null && startDate != null && endDate != null) {
    %>
        <!-- Active Filters Display -->
        <div class="active-filters">
            <div class="filter-indicator">
                🎯 <%= filterType.equals("sender") ? "Sender" : "Receiver" %>: <%= filterValue %>
            </div>
            <div class="filter-indicator">
                📅 Period: <%= startDate %> to <%= endDate %>
            </div>
        </div>

        <%
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int recordCount = 0;
        boolean hasError = false;
        String errorMessage = "";

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","system","0900");

            String column = filterType.equals("sender") ? "SENDER" : "RECEIVER";
            String sql = "SELECT SENDER, RECEIVER, SUBJECT, SENT_DATE FROM EMAILS WHERE " + column + "=? AND SENT_DATE BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD') ORDER BY SENT_DATE";

            ps = con.prepareStatement(sql);
            ps.setString(1, filterValue);
            ps.setString(2, startDate);
            ps.setString(3, endDate);

            rs = ps.executeQuery();

            // Count records first
            while(rs.next()) {
                recordCount++;
            }
            
            // Re-execute query for display
            rs.close();
            ps.close();
            ps = con.prepareStatement(sql);
            ps.setString(1, filterValue);
            ps.setString(2, startDate);
            ps.setString(3, endDate);
            rs = ps.executeQuery();

        } catch(Exception e) {
            hasError = true;
            errorMessage = e.getMessage();
        }

        if (!hasError) {
        %>
            <!-- Stats Summary -->
            <div class="stats-summary">
                <div class="stat-box">
                    <div class="stat-number"><%= recordCount %></div>
                    <div class="stat-label">Found Records</div>
                </div>
                
                <div class="stat-box">
                    <div class="stat-number">📧</div>
                    <div class="stat-label"><%= filterType.equals("sender") ? "Sent Emails" : "Received Emails" %></div>
                </div>
                
                <div class="stat-box">
                    <div class="stat-number">🗓️</div>
                    <div class="stat-label">Date Range</div>
                </div>
            </div>

            <!-- Results Table -->
            <div class="section">
                <h3>📋 Filtered Email Results</h3>
                
                <% if (recordCount == 0) { %>
                    <div class="no-results">
                        📭 No records found for the given filter criteria.
                    </div>
                <% } else { %>
                    <table>
                        <tr>
                            <th>Sender</th>
                            <th>Receiver</th>
                            <th>Subject</th>
                            <th>Sent Date</th>
                        </tr>
                        <%
                        while(rs.next()) {
                        %>
                        <tr>
                            <td><%= rs.getString("SENDER") %></td>
                            <td><%= rs.getString("RECEIVER") %></td>
                            <td><%= rs.getString("SUBJECT") %></td>
                            <td><%= rs.getDate("SENT_DATE") %></td>
                        </tr>
                        <%
                        }
                        %>
                    </table>
                <% } %>
            </div>
        <% 
        } else {
        %>
            <div class="section">
                <div class="error">
                    ⚠️ Error: <%= errorMessage %>
                </div>
            </div>
        <%
        }

        // Cleanup
        try {
            if(rs != null) rs.close();
            if(ps != null) ps.close();
            if(con != null) con.close();
        } catch(Exception ex) {}
    } else {
    %>
        <!-- Instructions when no filter applied -->
        <div class="section">
            <h3>📋 Filter Instructions</h3>
            <p style="text-align: center; color: #666; font-size: 16px; line-height: 1.6;">
                Use the filter form above to search for specific emails by sender or receiver within a date range. 
                Select your criteria and click "Apply Filter" to see the results.
            </p>
        </div>
    <%
    }
    %>

</div>
<!--  <script src="style.js"></script>
 --></body>
</html>