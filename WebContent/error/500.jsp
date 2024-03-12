<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" 
	import="java.io.*,
			com.efusioni.stone.common.*" %>
<%
	exception.printStackTrace();
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<title>상하농원</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="/css/default.css">
</head>
<body>
<div style="position:absolute;left:50%;top:50%;width:900px;height:600px;margin:-300px 0 0 -450px"><img src="/images/common/404.jpg" alt=""></div>
<!-- <div style="position:absolute;left:50%;top:50%;width:900px;height:600px;margin:-300px 0 0 -450px"><img src="/images/common/500.jpg" alt=""></div> -->
<%
	if(!SystemChecker.isReal()) {
		out.println("<!--");
		PrintWriter pw = new PrintWriter(out);
		exception.printStackTrace(pw);
		out.println("-->");
	}
%>
</body>
</html>
