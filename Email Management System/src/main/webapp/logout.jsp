<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
 <link rel="stylesheet" href="dynamic-styles.css">
</head>
<body>
<%
    // Invalidate the session
    session.invalidate();

    // Redirect to public home page
    response.sendRedirect("home.html"); 
%>
 <script src="style.js"></script>
</body>
</html>