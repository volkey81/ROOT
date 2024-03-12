<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.service.board.*" %>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	ProductQnaService qna = (new ProductQnaService()).toProxyInstance();
	
	boolean result = false;
	String msg = "";
	
	if(!fs.isLogin()) {
		msg = "로그인이 필요합니다.";	
	} else {
		param.set("userid", fs.getUserId());
		qna.create(param);
		result = true;
		msg = "등록되었습니다.";
	}
%>
{
	"result" : <%= result %>,
	"msg" : "<%= msg %>"
}
