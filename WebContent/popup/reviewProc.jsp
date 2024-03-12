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
	String url = param.backQuery();
	
	if(!fs.isLogin()) {
		msg = "�α����� �ʿ��մϴ�.";
	} else if("CREATE".equals(mode)) {
		review.create(upload);
		msg = "��ϵǾ����ϴ�.";
		result = true;
	} else if("MODIFY".equals(mode)) {
		review.modify(upload);
		msg = "�����Ǿ����ϴ�.";
		result = true;
	} else if("REMOVE".equals(mode)) {
		param.set("userid", fs.getUserId());
		review.remove(param);
		msg = "�����Ǿ����ϴ�.";
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