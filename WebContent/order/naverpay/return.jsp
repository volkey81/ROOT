<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.efusioni.stone.security.*,
			com.sanghafarm.common.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.service.order.*,
			org.json.simple.*" %>
<%
	Param param = new Param(request);

	if("Success".equals(param.get("resultCode"))) {
		String paymentId = param.get("paymentId");
%>
<script>
	opener.naverpay("<%= paymentId %>");
	self.close();
</script>
<%
	}
%>
