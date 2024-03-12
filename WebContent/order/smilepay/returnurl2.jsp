<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*"%>
<%
	String message = request.getParameter("message");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="euc-kr" lang="euc-kr">
<head>
<title>SmilePay 결제 응답 샘플 페이지</title>
<meta http-equiv="cache-control" content="no-cache"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />

<script type="text/javascript">
	window.onload = function returnPayResult(){
		window.opener.smilepay_L.t_url('<%=message %>');
	}
</script>
</head>
<body>
</body>
</html>