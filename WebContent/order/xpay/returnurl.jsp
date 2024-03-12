<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.sanghafarm.utils.*" %>
<%
request.setCharacterEncoding("UTF-8");

String LGD_RESPCODE = request.getParameter("LGD_RESPCODE");
String LGD_RESPMSG 	= request.getParameter("LGD_RESPMSG");
String LGD_CARDPREFIX = request.getParameter("LGD_CARDPREFIX");

System.out.println("@@@@@@@@@@@@@ returnurl.jsp - LGD_RESPCODE : " + LGD_RESPCODE);
System.out.println("@@@@@@@@@@@@@ returnurl.jsp - LGD_RESPMSG : " + LGD_RESPMSG);
System.out.println("@@@@@@@@@@@@@ returnurl.jsp - LGD_CARDPREFIX : " + LGD_CARDPREFIX);

try {
	String ua=request.getHeader("User-Agent");
	System.out.println("@@@@@@@@@@@@@ returnurl.jsp - UserAgent : " + ua);
} catch(Exception e) {}

Map payReqMap = request.getParameterMap();
%>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<head>
	<script type="text/javascript">
		function setLGDResult() {
			try {
	  			parent.payment_return();
			} catch (e) {
				alert(e.message);
			}
		}
	</script>
</head>
<body onload="setLGDResult()">
<!-- 
<p><h1>RETURN_URL (인증결과)</h1></p>
<div>
<p>LGD_RESPCODE (결과코드) : <%= LGD_RESPCODE %></p>
<p>LGD_RESPMSG (결과메시지): <%= LGD_RESPMSG %></p>
 -->
	<form method="post" name="LGD_RETURNINFO" id="LGD_RETURNINFO">
	<%
	for (Iterator i = payReqMap.keySet().iterator(); i.hasNext();) {
		Object key = i.next();
		if (payReqMap.get(key) instanceof String[]) {
			String[] valueArr = (String[])payReqMap.get(key);
			for(int k = 0; k < valueArr.length; k++) {
				out.println("<input type='hidden' name='" + key + "' id='"+key+"' value='" + valueArr[k] + "'/>");
				System.out.println("<input type='hidden' name='" + key + "' id='"+key+"' value='" + valueArr[k] + "'/>");
			}
		} else {
			String value = payReqMap.get(key) == null ? "" : (String) payReqMap.get(key);
			out.println("<input type='hidden' name='" + key + "' id='"+key+"' value='" + value + "'/>");
			System.out.println("<input type='hidden' name='" + key + "' id='"+key+"' value='" + value + "'/>");
		}
	}
	%>
	</form>
</body>
</html>