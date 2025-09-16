<%@ page import="java.sql.*,Email.DataConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
Connection con = DataConnection.getCon();
Statement stmt = con.createStatement();
ResultSet rs = stmt.executeQuery("SELECT * FROM EMAILS");
%>
<!DOCTYPE html>
<html>
<head>
<title>View Emails</title>
<link rel="stylesheet" href="dynamic-styles.css">
<style>
body {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background: #f9f9f9;
  min-height: 100vh;
  margin: 0;
  padding: 20px;
  color: #333;
}
h2 {
  text-align: center;
  color: #333;
  font-size: 2em;
  margin-bottom: 20px;
}
.table-container {
  overflow-x: auto;
}
table {
  width: 100%;
  max-width: 1200px;
  margin: 0 auto;
  border-collapse: collapse;
  background: #fff;
  border-radius: 10px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.05);
}
th {
  background-color: #4CAF50;
  color: white;
  font-weight: 600;
  padding: 12px 15px;
  text-align: left;
  font-size: 0.95em;
  text-transform: uppercase;
}
td {
  padding: 12px 15px;
  border-bottom: 1px solid #e0e0e0;
  vertical-align: top;
  color: #555;
}
tr:nth-child(even) { background-color: #f5f5f5; }
tr:hover { background-color: #e8f5e9; transition: all 0.3s ease; }
td:nth-child(1) { font-weight: bold; text-align: center; color: #4CAF50; }
td:nth-child(2), td:nth-child(3) {
  font-family: 'Courier New', monospace;
  max-width: 200px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
td:nth-child(4) {
  font-weight: 600;
  max-width: 250px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
td:nth-child(5) {
  max-width: 300px;
  max-height: 60px;
  overflow: hidden;
  text-overflow: ellipsis;
  line-height: 1.4;
}
td:nth-child(6) {
  font-size: 0.9em;
  color: #777;
  min-width: 150px;
}
@media (max-width: 768px) {
  table { font-size: 0.85em; display: block; overflow-x: auto; }
  th, td { padding: 10px; }
  td:nth-child(2), td:nth-child(3) { max-width: 120px; }
  td:nth-child(4) { max-width: 150px; }
  td:nth-child(5) { max-width: 200px; }
}
/* Back button */
.back-btn {
  display: inline-block;
  position: absolute;
  top: 20px;
  left: 20px;
  padding: 12px 25px;
  background-color: #4CAF50;
  color: white;
  text-decoration: none;
  font-weight: bold;
  border-radius: 8px;
  transition: background 0.3s ease;
  z-index: 100;
}
.back-btn:hover { background-color: #45a049; }
/* Search bar */
.table-search {
  max-width: 1200px;
  margin: 0 auto 15px;
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}
.search-input {
  padding: 8px 12px;
  border: 1px solid #ccc;
  border-radius: 6px;
}
.search-filter {
  padding: 8px 12px;
  border: 1px solid #ccc;
  border-radius: 6px;
}
</style>
</head>
<body>
<a href="home.jsp" class="back-btn">⬅ Go Back</a>

<h2>📩 All Emails</h2>
<div class="table-container">
  <table>
    <thead>
      <tr>
        <th>ID</th>
        <th>Sender</th>
        <th>Receiver</th>
        <th>Subject</th>
        <th>Body</th>
        <th>Sent Date</th>
      </tr>
    </thead>
    <tbody>
    <%
      while(rs.next()){
    %>
      <tr>
        <td><%= rs.getInt("EMAIL_ID") %></td>
        <td><%= rs.getString("SENDER") %></td>
        <td><%= rs.getString("RECEIVER") %></td>
        <td><%= rs.getString("SUBJECT") %></td>
        <td><%= rs.getString("BODY") %></td>
        <td><%= rs.getTimestamp("SENT_DATE") %></td>
      </tr>
    <%
      }
      rs.close();
      stmt.close();
      con.close();
    %>
    </tbody>
  </table>
</div>

<script>
// Debounce helper
function debounce(func, delay) {
  let timeout;
  return function(...args) {
    clearTimeout(timeout);
    timeout = setTimeout(() => func.apply(this, args), delay);
  };
}

document.addEventListener('DOMContentLoaded', function() {
  const table = document.querySelector('table');
  const tbody = table.querySelector('tbody');

  if (table) {
    // Create search bar
    const searchContainer = document.createElement('div');
    searchContainer.className = 'table-search';
    searchContainer.innerHTML = `
      <input type="text" placeholder="Search emails..." class="search-input">
      <select class="search-filter">
        <option value="all">All Columns</option>
        <option value="0">ID</option>
