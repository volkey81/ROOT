<%@ page language="java" contentType="text/html; charset=UTF-8" 
	import="java.lang.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.service.board.*" %>
<% 
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	
	if(fs.isLogin()) {
		KeywordService svc = (new KeywordService()).toProxyInstance();
		param.set("unfy_mmb_no", fs.getUserNo());
		svc.removeMemKeyword(param);
	}
%>
{
	"result" : true
}