<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.service.hotel.*" %>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	
	FileUploader upload = null;
	try {
		if(request.getContentType().indexOf("multipart/form-data") >= 0) {
			upload = new FileUploader(request, "", 25 * 1024 * 1024);
			param = new Param(upload); 
	 		upload.setParameter("userid", fs.getUserId());
		}
	} catch(Exception e) {}
	
	HotelCounselService counsel = (new HotelCounselService()).toProxyInstance();
	
	boolean result = false;
	String msg = "";
	String mode = param.get("mode");
	String url = "/hotel/";
	if(!"P".equals(param.get("device_type", "P"))) {
		url = "/mobile/hotel/";
	}
	
	
 	if("CREATE".equals(mode)) {
 		try {
			counsel.create(upload);
			msg = "등록되었습니다.";
			result = true;
 		} catch(Exception e) {
 			msg = e.getMessage();
 			result = false;
 			url = "";
 		}
	}
 	Utils.sendMessage(out, msg, url);
%>