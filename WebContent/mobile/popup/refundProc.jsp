<%@ page contentType="text/html; charset=euc-kr" errorPage="/error/error.jsp"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.service.order.*" %>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	FileUploader upload = new FileUploader(request, "", 25 * 1024 * 1024);

	if(!fs.isLogin()) {
%>
		<script>
			alert("로그인이 필요합니다.");
			parent.document.location.href = parent.document.location.reload();
		</script>
<%
		return;
	}
	
 	upload.setParameter("userid", fs.getUserId());
	Param param = new Param(upload);
	OrderService order = (new OrderService()).toProxyInstance();

	Param info = order.getOrderShipInfo(param);
	if(!info.get("userid").equals(fs.getUserId())) {
%>
		<script>
			alert("잘못된 접근입니다.");
			parent.document.location.href = parent.document.location.reload();
		</script>
<%
		return;
		
	}
	
	order.createReturn(upload);
%>
<script>
	alert("등록되었습니다.");
	parent.document.location.reload();
</script>
