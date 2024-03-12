<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.utils.*,
				 com.sanghafarm.service.order.*" %>
<%
	Param param = new Param(request);
// 	String orderid = SanghafarmUtils.getCookie(request, "ORDERID");
	String orderid = param.get("orderid");
			
	if(orderid == null || "".equals(orderid)) {
		System.out.println("++++++++++++ parameter orderid is null !!!");
		Utils.sendMessage(out, "세션이 만료 되었거나 유효하지 않은 요청 입니다.", "/");
		return;
	}
	
	OrderService svc = (new OrderService()).toProxyInstance();
	Param info = svc.getOrderFormInfo(orderid);
	
	if(info == null || "".equals(info.get("orderid"))) {
		System.out.println("++++++++++++ order form is null !!!");
		Utils.sendMessage(out, "세션이 만료 되었거나 유효하지 않은 요청 입니다.", "/");
		return;
	}

	String LGD_RESPCODE = request.getParameter("LGD_RESPCODE");
	String LGD_RESPMSG 	= request.getParameter("LGD_RESPMSG");
	String LGD_PAYKEY	= request.getParameter("LGD_PAYKEY");
	String LGD_CARDPREFIX = request.getParameter("LGD_CARDPREFIX");

	System.out.println("@@@@@@@@@@@@@ mreturnurl.jsp - LGD_RESPCODE : " + LGD_RESPCODE);
	System.out.println("@@@@@@@@@@@@@ mreturnurl.jsp - LGD_RESPMSG : " + LGD_RESPMSG);
	System.out.println("@@@@@@@@@@@@@ mreturnurl.jsp - LGD_CARDPREFIX : " + LGD_CARDPREFIX);

	try {
		String ua=request.getHeader("User-Agent");
		System.out.println("@@@@@@@@@@@@@ mreturnurl.jsp - UserAgent : " + ua);
	} catch(Exception e) {}
%>
<html>
<head>
<script src="/js/jquery-1.10.2.min.js"></script>
<script type="text/javascript">
	function setLGDResult() {
<% 
	if("0000".equals(LGD_RESPCODE)) {
%>
// 		document.getElementById('LGD_PAYINFO').submit();
		$("input[name=LGD_RESPCODE]").val("<%= LGD_RESPCODE %>");
		$("input[name=LGD_RESPMSG]").val("<%= LGD_RESPMSG %>");
		$("input[name=LGD_PAYKEY]").val("<%= LGD_PAYKEY %>");
		$("input[name=LGD_CARDPREFIX]").val("<%= LGD_CARDPREFIX %>");
		$("#LGD_PAYINFO").submit();
<%
	} else {
%>
		alert("LGD_RESPCODE:<%= LGD_RESPCODE %>, LGD_RESPMSG:<%= LGD_RESPMSG %>");
// 		history.go(-2);
		history.go(-3);
<%
	}
%>
	}
</script>
</head>
<body onload="setLGDResult()">
<% 
	if("0000".equals(LGD_RESPCODE)){
%>
<form method="post" name="LGD_PAYINFO" id="LGD_PAYINFO" action="<%= Env.getSSLPath() %>/hotel/offer/proc.jsp">
<%= info.get("form") %>
</form>
<%
	} else {
// 		Utils.sendMessage(out, "LGD_RESPCODE:" + LGD_RESPCODE + " ,LGD_RESPMSG:" + LGD_RESPMSG, "/mobile"); //인증 실패에 대한 처리 로직 추가
// 		return;
	}
%>
</body>
</html>