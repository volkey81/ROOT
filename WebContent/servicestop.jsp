<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
	response.setStatus(HttpServletResponse.SC_OK);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<title>상하농원 - <%= request.getRemoteAddr() %></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="/css/default.css">
</head>
<body>
<!-- 
	<%= request.getRemoteAddr() %>
 -->
<div style="position:absolute; left:50%; top:50%; margin:-250px 0 0 -350px;width:700px; height:500px;">
<!-- 	<img src="/images/common/servicestop.jpg" alt="상하농원. 홈페이지 리뉴얼에 따른 서비스 일시중지 안내. 보다 나은 서비스를 제공해 드리고자  홈페이지 리뉴얼 반영을 위해 웹서비스가 일시 중지 됨을 안내드립니다. 서비스 일시 중지시간 2018년 11월 22일 (목요일)  오후 3 ~ 4시. 이용에 불편을 끼쳐드려 죄송합니다.전화 문의 : 1522-3698. ※ 작업 상황에 따라 변경될 수 있습니다."> -->
	<img src="/images/common/underconstruction.jpg" alt="상하농원. 홈페이지 리뉴얼에 따른 서비스 일시중지 안내. 보다 나은 서비스를 제공해 드리고자  홈페이지 리뉴얼 반영을 위해 웹서비스가 일시 중지 됨을 안내드립니다. 서비스 일시 중지시간 2022년 07월 21일 (목)  23:00 ~ 2022년 07월 22일 (금) 06:00. 이용에 불편을 끼쳐드려 죄송합니다.전화 문의 : 1522-3698. ※ 작업 상황에 따라 변경될 수 있습니다.">
</div>
</body>
</html>
