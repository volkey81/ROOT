<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.efusioni.stone.security.*,
			com.sanghafarm.utils.*,
			org.json.simple.*" %>
<%
	Param param = new Param(request);
%>
<script>
<%
	if("success".equals(param.get("result"))) {
%>
	parent.kakaopay("<%= param.get("pg_token") %>");
<%

	} else if("fail".equals(param.get("result"))) {
%>
	alert("카카오페이 결제준비중 오류가 발생했습니다.");
	parent.kakaopayPopClose();
<%
	} else if("cancel".equals(param.get("result"))) {
%>
	parent.kakaopayPopClose();
<%
	}
%>
</script>
