<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.service.order.*" %>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	WishListService wish = (new WishListService()).toProxyInstance();
	
	boolean result = false;
	String msg = "";
	param.set("userid", fs.getUserId());
	
	if(!fs.isLogin()) {
		msg = FrontSession.LOGIN_MSG;
	} else if("CREATE".equals(param.get("mode"))) {
		wish.create(param);
		result = true;
		msg = "등록되었습니다.";
	} else if("CART".equals(param.get("mode"))) {
		wish.createFormCart(param);
		result = true;
		msg = "등록되었습니다.";
	} else if("REMOVE".equals(param.get("mode"))) {
		wish.remove(param);
		result = true;
		msg = "삭제되었습니다.";
	}
%>
{
	"result" : <%= result %>,
	"msg" : "<%= msg %>"
}
