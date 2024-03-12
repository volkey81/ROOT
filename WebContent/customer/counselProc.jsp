<%@page import="com.sanghafarm.service.board.CounselService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.exception.*,
				 com.sanghafarm.service.member.*" %>
<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%
	Param param = new Param(request);
	FileUploader upload = null;
	
	FrontSession fs = FrontSession.getInstance(request, response);
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessage(out, FrontSession.LOGIN_MSG, request);
		return;
	}

	try {
		if(request.getContentType().indexOf("multipart/form-data") >= 0) {
			upload = new FileUploader(request, "", 25 * 1024 * 1024);
			param = new Param(upload); 
	 		upload.setParameter("userid", fs.getUserId());
	 		upload.setParameter("usernm", fs.getUserNm());
	 		upload.setParameter("mobile", fs.getMobile());
	 		upload.setParameter("email" , fs.getEmail());
		 	
		}
	} catch(Exception e) {}
	
	CounselService counsel = (new CounselService()).toProxyInstance();
	
	boolean result = false;
	String msg = "";
	String mode = param.get("mode");
	String url = "../main.jsp";
	
 	if("CREATE".equals(mode)) {
		counsel.create(upload);
		msg = "등록되었습니다.";
		result = true;
	}
 	Utils.sendMessage(out, msg, url);
%>