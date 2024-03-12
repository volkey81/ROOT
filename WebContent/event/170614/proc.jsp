<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"
	import="java.util.List, 
		 	com.efusioni.stone.common.*,
		 	com.efusioni.stone.utils.*,
		 	com.sanghafarm.common.*,
			com.sanghafarm.service.board.*" %>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	
	String mode = param.get("mode");
	String msg = "잘못된 접근입니다.";
	boolean result = false;

	if(!fs.isLogin()) {
		msg = FrontSession.LOGIN_MSG;
	} else {
		EventService svc = (new EventService()).toProxyInstance();
		param.set("seq", (SystemChecker.isReal() ? 27 : 12));

		if("CREATE".equals(mode)) {
			param.set("secret_yn", "Y");
			param.set("userid", fs.getUserId());
			param.set("p_sub_seq", 0);
			param.set("ip", request.getRemoteAddr());

			svc.createComment(param);
		
			result = true;
			msg = "등록되었습니다.";
		} else if("MODIFY".equals(mode)) {
			Param info = svc.getCommentInfo(param);
			if(!fs.getUserId().equals(info.get("userid"))) {
				msg = "잘못된 접근입니다.";
			} else {
				svc.modifyComment(param);

				result = true;
				msg = "수정되었습니다.";
			}
		} else if("REMOVE".equals(mode)) {
			Param info = svc.getCommentInfo(param);
			if(!fs.getUserId().equals(info.get("userid"))) {
				msg = "잘못된 접근입니다.";
			} else {
				param.set("status", "D");
				svc.modifyCommnetStatus(param);

				result = true;
				msg = "삭제되었습니다.";
			}
		}
	} 
%>
{
	"result" : <%= result %>,
	"msg" : "<%=msg %>"
}