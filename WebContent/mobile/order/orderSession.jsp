<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.efusioni.stone.common.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.utils.*,
				 com.sanghafarm.service.order.*" %>
<%
	Param param = new Param(request);
	OrderService svc = (new OrderService()).toProxyInstance();
	
	String CST_PLATFORM    = Utils.safeHTML(request.getParameter("CST_PLATFORM"));
	String CST_WINDOW_TYPE = "submit";//수정불가
	
	Enumeration _enum = request.getParameterNames();
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<script language="javascript" src="<%= request.getScheme() %>://xpay.uplus.co.kr/xpay/js/xpay_crossplatform.js" type="text/javascript"></script>
<%-- <script language="javascript" src="<%= SystemChecker.isReal() ? "https" : "http" %>://xpay.uplus.co.kr/xpay/js/xpay_crossplatform.js" type="text/javascript"></script> --%>
<script type="text/javascript">

/*
* 수정불가.
*/
	var LGD_window_type = '<%=CST_WINDOW_TYPE%>';
	
/*
* 수정불가
*/
function launchCrossPlatform(){
    lgdwin = open_paymentwindow(document.getElementById('LGD_PAYINFO'), '<%= CST_PLATFORM %>', LGD_window_type);
}
/*
* FORM 명만  수정 가능
*/
function getFormObject() {
        return document.getElementById("LGD_PAYINFO");
}
</script>
</head>
<body onload="launchCrossPlatform()">
<form name="LGD_PAYINFO" id="LGD_PAYINFO" method="POST">
<%
// 	Param payReqMap = new Param();
	StringBuffer buf = new StringBuffer();
	
	while (_enum.hasMoreElements()) {
	
		String key = (String) _enum.nextElement();
	
		// 일반적인 파라미터를 셋팅
		//super.put(key, nvl(_request.getParameter(key)));
		//if(!"".equals(Utils.nvl(request.getParameter(key), ""))){
			if(request.getParameterValues(key).length == 1){
				buf.append("<input type='hidden' name='" + key + "' value='" + Utils.safeHTML(Utils.nvl(request.getParameter(key), "")) + "'>\n" );
// 				payReqMap.set(key, request.getParameter(key));
			}
		//}
		
		// checkbox 같은 배열 파라미터 셋팅
		String[] pv = null;
		if (request.getParameterValues(key) != null) {
			pv = request.getParameterValues(key);
	
			if (pv.length > 1){
				for(int i=0; i<pv.length; i++){
					buf.append("<input type='hidden' name='" + key + "' value='" + Utils.safeHTML(pv[i]) + "'>\n" );	
// 					payReqMap.set(key+"~"+i, pv[i]);
				}
// 				payReqMap.set(key, pv);
				//super.put(key, pv);
				//out.println("<input type='hidden' name='" + key + "' value='" + pv + "'>" );				
			}
		}
	}

    /*
    ****************************************************
    * 안드로이드폰 신용카드 ISP(국민/BC)결제에만 적용 (시작)*
    ****************************************************

    (주의)LGD_CUSTOM_ROLLBACK 의 값을  "Y"로 넘길 경우, LG U+ 전자결제에서 보낸 ISP(국민/비씨) 승인정보를 고객서버의 note_url에서 수신시  "OK" 리턴이 안되면  해당 트랜잭션은  무조건 롤백(자동취소)처리되고,
    LGD_CUSTOM_ROLLBACK 의 값 을 "C"로 넘길 경우, 고객서버의 note_url에서 "ROLLBACK" 리턴이 될 때만 해당 트랜잭션은  롤백처리되며  그외의 값이 리턴되면 정상 승인완료 처리됩니다.
    만일, LGD_CUSTOM_ROLLBACK 의 값이 "N" 이거나 null 인 경우, 고객서버의 note_url에서  "OK" 리턴이  안될시, "OK" 리턴이 될 때까지 3분간격으로 2시간동안  승인결과를 재전송합니다.
    */
    //payReqMap.put("LGD_CUSTOM_ROLLBACK"         , "");		   	   				   // 비동기 ISP에서 트랜잭션 처리여부
    
  /*Return URL에서 인증 결과 수신 시 셋팅될 파라미터 입니다.*/
// 	payReqMap.put("LGD_RESPCODE"  		 , "" );
// 	payReqMap.put("LGD_RESPMSG"  		 , "" );
// 	payReqMap.put("LGD_PAYKEY"  		 , "" );	
// 	session.setAttribute("PAYREQ_MAP", payReqMap);
	
	out.println(buf.toString());
	
// 	FrontSession fs = FrontSession.getInstance(request, response);
// 	SanghafarmUtils.setCookie(response, "ORDERID", "", fs.getDomain(), -1);
// 	SanghafarmUtils.setCookie(response, "ORDERID", param.get("orderid"), fs.getDomain(), -1);
	
	Param info = svc.getOrderFormInfo(param.get("orderid"));
	if(info == null || "".equals(info.get("orderid"))) {
		svc.createOrderForm(new Param("orderid", param.get("orderid"), "form", buf.toString()));
	} else {
		svc.modifyOrderForm(new Param("orderid", param.get("orderid"), "form", buf.toString()));
	}
%>
</form>
</body>
</html>