<%@ page import="java.sql.*,java.util.*,java.text.SimpleDateFormat,Email.DataConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
Connection con = DataConnection.getCon();
Statement stmt = con.createStatement();
ResultSet rs = stmt.executeQuery(
    "SELECT SENDER, MAX(SENT_DATE) AS LAST_DATE FROM EMAILS GROUP BY SENDER ORDER BY LAST_DATE DESC"
);

// Store data into lists
List<String> senders = new ArrayList<>();
List<java.sql.Date> dates = new ArrayList<>();
SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy");

while(rs.next()){
    senders.add(rs.getString("SENDER"));
    dates.add(rs.getDate("LAST_DATE"));
}

// Calculate statistics
int totalSenders = senders.size();
java.sql.Date mostRecentDate = dates.isEmpty() ? null : dates.get(0);

rs.close();
stmt.close();
con.close();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Latest Email per Sender</title>
 <link rel="stylesheet" href="dynamic-styles.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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

.back-button:hover{
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

.stats {
    display: flex;
    gap: 25px;
    margin-bottom: 40px;
    justify-content: center;
    flex-wrap: wrap;
}

.stat-box {
    background: rgba(255, 255, 255, 0.95);
    padding: 25px 30px;
    border-radius: 20px;
    text-align: center;
    min-width: 180px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    backdrop-filter: blur(10px);
}

.stat-box:hover {
    transform: translateY(-5px);
    box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
}

.stat-number {
    font-size: 32px;
    font-weight: bold;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    margin-bottom: 8px;
}

.stat-label {
    font-size: 14px;
    color: #666;
    text-transform: uppercase;
    letter-spacing: 1px;
    font-weight: 500;
}

.content {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 25px;
}

.section {
    background: rgba(255, 255, 255, 0.95);
    padding: 30px;
    border-radius: 20px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
    backdrop-filter: blur(10px);
    transition: transform 0.3s ease;
}

.section:hover {
    transform: translateY(-3px);
}

.section h3 {
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

table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0;
    overflow: hidden;
    border-radius: 10px;
}

th {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 15px;
    text-align: left;
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

.chart-container {
    width: 100%;
    height: 350px;
    position: relative;
    padding: 10px;
    background: rgba(255, 255, 255, 0.5);
    border-radius: 10px;
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

/* Table Scroll for Mobile */
.table-wrapper {
    overflow-x: auto;
    border-radius: 10px;
}

/* Badge for days ago */
.days-badge {
    display: inline-block;
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
}

.days-recent {
    background: #d4f4dd;
    color: #22c55e;
}

.days-moderate {
    background: #fef3c7;
    color: #f59e0b;
}

.days-old {
    background: #fee2e2;
    color: #ef4444;
}

@media (max-width: 768px) {
    .content {
        grid-template-columns: 1fr;
    }
    
    h1 {
        font-size: 2rem;
    }
    
    .stat-box {
        min-width: 100%;
    }
    
    .section {
        padding: 20px;
    }
    
    table {
        font-size: 12px;
    }
    
    th, td {
        padding: 10px;
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
    <a href="report.html" class="back-button">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M19 12H5M12 19l-7-7 7-7"/>
        </svg>
        Back to Reports
    </a>
    
    <h1>⏱️ Latest Email per Sender</h1>

    <div class="stats">
        <div class="stat-box">
            <div class="stat-number"><%= totalSenders %></div>
            <div class="stat-label">Total Senders</div>
        </div>
        
        <div class="stat-box">
            <div class="stat-number"><%= mostRecentDate != null ? sdf.format(mostRecentDate) : "N/A" %></div>
            <div class="stat-label">Most Recent Email</div>
        </div>
    </div>

    <div class="content">
        <div class="section">
            <h3>📋 Table View</h3>
            
            <div class="table-wrapper">
                <table>
                    <tr>
                        <th>Sender</th>
                        <th>Latest Email</th>
                        <th>Status</th>
                    </tr>
                    <%
                    java.util.Date today = new java.util.Date();
                    for(int i = 0; i < senders.size(); i++){
                        java.sql.Date emailDate = dates.get(i);
                        long diffInMillies = today.getTime() - emailDate.getTime();
                        long diffInDays = diffInMillies / (1000 * 60 * 60 * 24);
                        
                        String badgeClass = "days-recent";
                        if(diffInDays > 30) badgeClass = "days-old";
                        else if(diffInDays > 7) badgeClass = "days-moderate";
                    %>
                    <tr>
                        <td><strong><%= senders.get(i) %></strong></td>
                        <td><%= sdf.format(emailDate) %></td>
                        <td>
                            <span class="days-badge <%= badgeClass %>">
                                <%= diffInDays %> days ago
                            </span>
                        </td>
                    </tr>
                    <% } %>
                </table>
            </div>
        </div>

        <div class="section">
            <h3>📊 Graph View</h3>
            <div class="chart-container">
                <canvas id="latestChart"></canvas>
            </div>
        </div>
    </div>
</div>

<script>
let ctx = document.getElementById("latestChart").getContext("2d");

// Prepare chart data
let chartLabels = [
    <% for(int i = 0; i < senders.size(); i++){ %>
    "<%= senders.get(i).replace("\"", "\\\"") %>",
    <% } %>
];

let chartDates = [
    <% for(int i = 0; i < dates.size(); i++){ %>
    "<%= dates.get(i) %>",
    <% } %>
];

// Convert dates to days ago
let today = new Date();
let daysAgoData = chartDates.map(dateStr => {
    let emailDate = new Date(dateStr);
    let diffTime = Math.abs(today - emailDate);
    let diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    return diffDays;
});

// Create gradient
let gradient = ctx.createLinearGradient(0, 0, 0, 400);
gradient.addColorStop(0, 'rgba(102, 126, 234, 0.8)');
gradient.addColorStop(1, 'rgba(118, 75, 162, 0.8)');

new Chart(ctx, {
    type: "bar",
    data: {
        labels: chartLabels,
        datasets: [{
            label: "Days Since Last Email",
            data: daysAgoData,
            backgroundColor: gradient,
            borderColor: 'rgba(102, 126, 234, 1)',
            borderWidth: 2,
            borderRadius: 8,
            hoverBackgroundColor: 'rgba(118, 75, 162, 0.9)'
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: {
                display: false
            },
            tooltip: {
                backgroundColor: 'rgba(0, 0, 0, 0.8)',
                padding: 12,
                borderRadius: 8,
                titleFont: {
                    size: 14,
                    weight: 'bold'
                },
                bodyFont: {
                    size: 13
                },
                callbacks: {
                    label: function(context) {
                        return context.parsed.y + ' days since last email';
                    }
                }
            }
        },
        scales: {
            y: {
                beginAtZero: true,
                title: {
                    display: true,
                    text: 'Days Ago',
                    font: {
                        size: 14,
                        weight: 'bold'
                    }
                },
                grid: {
                    color: 'rgba(0, 0, 0, 0.05)',
                    drawBorder: false
                }
            },
            x: {
                grid: {
                    display: false
                },
                ticks: {
                    maxRotation: 45,
                    minRotation: 45
                }
            }
        }
    }
});
</script>
<!--  <script src="style.js"></script>
 --></body>
</html>