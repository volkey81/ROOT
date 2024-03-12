<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.service.order.*" %>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	CartService cart = (new CartService()).toProxyInstance();
	
	boolean result = false;
	String msg = "";
	String userid = "";
	if(fs.isLogin()) {
		userid = fs.getUserId();
	} else {
		userid = fs.getTempUserId();
	}
	param.set("userid", userid);
	
	if("CREATE".equals(param.get("mode"))) {
		cart.create(param);
		result = true;

		/*
		int count = 0;
		int sumCount = 0;
		String[] subPid = param.getValues("sub_pid");
		for(int i = 0; i < subPid.length; i++) {
			count = cart.getListCount(new Param("userid", userid, "pid", param.get("pid"), "sub_pid", subPid[i]));
			sumCount += count;
		}
		if (sumCount > 0) { 
			msg = "동일한 상품이 장바구니에 있습니다.\\n장바구니에서 수량을 조절하세요.";
		} else {
			cart.create(param);
			result = true;
		}
		*/
	} else if("MODIFY".equals(param.get("mode"))) {
		cart.modify(param);
		result = true;
	} else if("MODIFY_QTY".equals(param.get("mode"))) {
		cart.modifyQty(param);
		result = true;
		msg = "적용되었습니다.";
	} else if("REMOVE".equals(param.get("mode"))) {
		cart.remove(param);
		result = true;
		msg = "삭제되었습니다.";
	}
%>
{
	"result" : <%= result %>,
	"msg" : "<%= msg %>"
}
