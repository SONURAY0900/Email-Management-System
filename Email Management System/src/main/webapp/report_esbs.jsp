<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Email Analytics Dashboard</title>
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

.stats-row {
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

.content-row {
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
    margin-top: 10px;
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
    margin-top: 10px;
}

.chart-section {
    grid-column: 1 / -1;
}

.error {
    background-color: #ffebee;
    color: #c62828;
    padding: 15px;
    border-radius: 5px;
    border-left: 4px solid #f44336;
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
    .stats-row {
        flex-direction: column;
        align-items: center;
    }
    
    .content-row {
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
    
    <h1>📧 Email Analytics Dashboard</h1>

    <%
    // Database logic
    Connection con = null;
    Statement stmt = null;
    ResultSet rs = null;

    StringBuilder senders = new StringBuilder("[");
    StringBuilder counts = new StringBuilder("[");
    int totalEmails = 0;
    int totalSenders = 0;
    %>

    <div class="stats-row">
        <div class="stat-box">
            <div class="stat-number" id="totalEmailCount">0</div>
            <div class="stat-label">Total Emails</div>
        </div>
        
        <div class="stat-box">
            <div class="stat-number" id="totalSenderCount">0</div>
            <div class="stat-label">Unique Senders</div>
        </div>
        
        <div class="stat-box">
            <div class="stat-number" id="avgEmailsPerSender">0</div>
            <div class="stat-label">Average per Sender</div>
        </div>
    </div>

    <div class="content-row">
        <div class="section">
            <h3>📋 Email Statistics by Sender</h3>
            
            <table>
                <tr>
                    <th>Sender</th>
                    <th>Email Count</th>
                    <th>Percentage</th>
                </tr>
                <%
                try {
                    Class.forName("oracle.jdbc.driver.OracleDriver");
                    con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","system","0900");
                    stmt = con.createStatement();
                    rs = stmt.executeQuery("SELECT SENDER, COUNT(*) AS CNT FROM EMAILS GROUP BY SENDER ORDER BY CNT DESC");

                    // First pass to calculate totals
                    while(rs.next()) {
                        totalEmails += rs.getInt("CNT");
                        totalSenders++;
                    }
                    
                    // Second pass to display data
                    rs = stmt.executeQuery("SELECT SENDER, COUNT(*) AS CNT FROM EMAILS GROUP BY SENDER ORDER BY CNT DESC");
                    
                    while(rs.next()) {
                        String sender = rs.getString("SENDER");
                        int cnt = rs.getInt("CNT");
                        double percentage = totalEmails > 0 ? (cnt * 100.0 / totalEmails) : 0;
                %>
                <tr>
                    <td><%= sender %></td>
                    <td><%= cnt %></td>
                    <td><%= String.format("%.1f%%", percentage) %></td>
                </tr>
                <%
                        senders.append("'").append(sender.replace("'", "\\'")).append("',");
                        counts.append(cnt).append(",");
                    }

                    if(senders.length() > 1) senders.setLength(senders.length()-1);
                    if(counts.length() > 1) counts.setLength(counts.length()-1);

                    senders.append("]");
                    counts.append("]");

                } catch(Exception e) {
                %>
                <tr>
                    <td colspan='3'>
                        <div class="error">
                            Error loading data: <%= e.getMessage() %>
                        </div>
                    </td>
                </tr>
                <%
                } finally {
                    if(rs != null) try{ rs.close(); }catch(Exception ex){}
                    if(stmt != null) try{ stmt.close(); }catch(Exception ex){}
                    if(con != null) try{ con.close(); }catch(Exception ex){}
                }
                %>
            </table>
        </div>

        <div class="section">
            <h3>📊 Visual Chart</h3>
            <div class="chart-container">
                <canvas id="senderChart"></canvas>
            </div>
        </div>
    </div>
</div>
 <script src="style.js"></script>
 <script>
document.addEventListener('DOMContentLoaded', function() {
    // Update stats
    const totalEmails = <%= totalEmails %>;
    const totalSenders = <%= totalSenders %>;
    const avgPerSender = totalSenders > 0 ? Math.round(totalEmails / totalSenders) : 0;
    
    document.getElementById('totalEmailCount').textContent = totalEmails;
    document.getElementById('totalSenderCount').textContent = totalSenders;
    document.getElementById('avgEmailsPerSender').textContent = avgPerSender;
    
    // Chart data
    const labels = <%= senders.toString() %>;
    const data = <%= counts.toString() %>;
    
    if (labels.length > 0 && data.length > 0) {
        const ctx = document.getElementById('senderChart').getContext('2d');
        
        // Create gradient
        let gradient = ctx.createLinearGradient(0, 0, 0, 400);
        gradient.addColorStop(0, 'rgba(102, 126, 234, 0.8)');
        gradient.addColorStop(1, 'rgba(118, 75, 162, 0.8)');
        
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Number of Emails',
                    data: data,
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
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: 'Number of Emails',
                            font: {
                                size: 14,
                                weight: 'bold'
                            }
                        },
                        ticks: { 
                            stepSize: 1
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
    }
});
</script> 

</body>
</html>