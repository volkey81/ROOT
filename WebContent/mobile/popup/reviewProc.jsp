<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ page contentType="text/html; charset=euc-kr" errorPage="/error/error.jsp"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.service.board.*" %>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	ReviewService review = (new ReviewService()).toProxyInstance();

	FileUploader upload = null;
	try {
		if(request.getContentType().indexOf("multipart/form-data") >= 0) {
			upload = new FileUploader(request, "", 25 * 1024 * 1024);
			param = new Param(upload); 
		 	upload.setParameter("userid", fs.getUserId());
		}
	} catch(Exception e) {}
	
	boolean result = false;
	String msg = "";
	String mode = param.get("mode");

	
	if(!fs.isLogin()) {
		msg = "로그인이 필요합니다.";
	} else if("CREATE".equals(mode)) {
		if (fs.isApp() && "android".equals(fs.getAppOS())) {
			upload.setParameter("APP_YN", "Y");
			if (StringUtils.isNotEmpty(param.get("imgName1"))) {
				upload.setParameter("img1", param.get("imgName1"));				
			}
			if (StringUtils.isNotEmpty(param.get("imgName2"))) {
				upload.setParameter("img2", param.get("imgName2"));				
			}
		}
		review.create(upload);
		msg = "등록되었습니다.";
		result = true;
	} else if("MODIFY".equals(mode)) {
		if (fs.isApp() && "android".equals(fs.getAppOS())) {
			upload.setParameter("APP_YN", "Y");
			if (StringUtils.isNotEmpty(param.get("imgName1"))) {
				upload.setParameter("img1", param.get("imgName1"));				
			}
			if (StringUtils.isNotEmpty(param.get("imgName2"))) {
				upload.setParameter("img2", param.get("imgName2"));				
			}
		}
		review.modify(upload);
		msg = "수정되었습니다.";
		result = true;
	} else if("REMOVE".equals(mode)) {
		review.remove(param);
		msg = "삭제되었습니다.";
		result = true;
	}
	
%>
<% if (mode.equals("REMOVE")){ %>
<% if (result) { %>
{"msg" : "<%=msg %>"}
<% } %>
<% } else { %>
<script>
	alert("<%=msg%>");
	<%
	if (result){
	%>
	parent.document.location.reload();
	<%
	}
	%>
</script>
<% }%>