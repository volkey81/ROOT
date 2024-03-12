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
	
	Enumeration _enum = request.getParameterNames();

// 	Param payReqMap = new Param();
	StringBuffer buf = new StringBuffer();

	while (_enum.hasMoreElements()) {
	
		String key = (String) _enum.nextElement();
	
		if(request.getParameterValues(key).length == 1){
// 			payReqMap.set(key, request.getParameter(key)); 
			buf.append("<input type='hidden' name='" + key + "' value='" + Utils.safeHTML(Utils.nvl(request.getParameter(key), "")) + "'>\n" );
		} else {
			if (request.getParameterValues(key) != null) {
				String[] pv = request.getParameterValues(key);
				for(int i=0; i<pv.length; i++){
					buf.append("<input type='hidden' name='" + key + "' value='" + Utils.safeHTML(pv[i]) + "'>\n" );	
				}
// 				payReqMap.set(key, pv);
			}
		}
	}

// 	session.setAttribute("PAYREQ_MAP", payReqMap);	

// 	FrontSession fs = FrontSession.getInstance(request, response);
// 	SanghafarmUtils.setCookie(response, "ORDERID", param.get("orderid"), fs.getDomain(), -1);
	
	Param info = svc.getOrderFormInfo(param.get("orderid"));
	if(info == null || "".equals(info.get("orderid"))) {
		svc.createOrderForm(new Param("orderid", param.get("orderid"), "form", buf.toString()));
	} else {
		svc.modifyOrderForm(new Param("orderid", param.get("orderid"), "form", buf.toString()));
	}

	String naverReturn = request.getScheme() + "://" + request.getServerName() + "/order/naverpay/" + param.get("naver_return") + ".jsp?orderid=" + param.get("orderid");
	String clientId = "mreturn".equals(param.get("naver_return")) ? Config.get("npay.shop.clientid") : Config.get("npay.noshop.clientid");
	
	int payAmt = param.getInt("LGD_AMOUNT");
	int taxFree = param.getInt("LGD_TAXFREEAMOUNT", 0);
	int taxAmt = payAmt - taxFree;
	if(taxAmt < 0) {
		taxAmt = 0;
		taxFree = payAmt;
	}
%>
<!-- 네이버페이 -->
<script src="https://nsp.pay.naver.com/sdk/js/naverpay.min.js"></script>
<script src="/js/jquery-1.10.2.min.js"></script>
<script>
	$(function() {
		var nPay = Naver.Pay.create({
		    "mode" : "<%= SystemChecker.isReal() ? "production" : "development" %>", // development or production
		    "openType" : "page" ,	//layer, page, popup 
		    "clientId": "<%= clientId %>", // clientId
		});

		nPay.open({
            "merchantPayKey": "<%= param.get("orderid") %>",
            "productName": "<%= param.get("LGD_PRODUCTINFO") %>",
            "productCount": "<%= param.get("productCount") %>",
            "totalPayAmount": <%= payAmt %>,
            "taxScopeAmount": <%= taxAmt %>,
            "taxExScopeAmount": <%= taxFree %>,
            "returnUrl": "<%= naverReturn %>",
<%
	if("mreturn_exp".equals(param.get("naver_return"))) {
%>
            "useCfmYmdt": "<%= param.get("reserve_date").replaceAll("\\.", "") %>",
<%
	} else if("mreturn_hotel".equals(param.get("naver_return"))
				|| "mreturn_hotel_offer".equals(param.get("naver_return"))) {
%>
            "useCfmYmdt": "<%= param.get("chot_date").replaceAll("\\.", "") %>",
<%
	}
%>
            "productItems": <%= param.get("productItems") %>
        });
	});
</script>
