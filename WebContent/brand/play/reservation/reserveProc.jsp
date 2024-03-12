<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.service.board.*" %>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	
	boolean result = false;
	String msg = "";
	
	if(!fs.isLogin()) {
		msg = FrontSession.LOGIN_MSG;
	} else {
		GroupReserveService svc = (new GroupReserveService()).toProxyInstance();
		param.set("userid", fs.getUserId());
		svc.create(param);
		result = true;
		msg = "단체예약 상담이 접수 되었습니다.\\n담당자 확인 후 연락드리겠습니다.";
	}
%>
{
	"result" : <%= result %>,
	"msg" : "<%= msg %>"
}
