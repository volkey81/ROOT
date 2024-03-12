<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.service.order.*" %>
<%
	request.setAttribute("Depth_1", new Integer(3));
	request.setAttribute("Depth_2", new Integer(2));
	request.setAttribute("Depth_3", new Integer(2));
	request.setAttribute("MENU_TITLE", new String("오프라인 쿠폰 다운로드"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
%>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessageMobile(out, FrontSession.LOGIN_MSG, request);
		return;
	}
	
	Param param = new Param(request);
	param.set("userid", fs.getUserId());
	param.set("grade_code", fs.getGradeCode());
	param.set("unfy_mmb_no", fs.getUserNo());
	
	OffCouponService svc = (new OffCouponService()).toProxyInstance();
	
	List<Param> list = svc.getDownloadableList(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<script>
	function couponDownload(cid) {
		$.ajax({
			method : "POST",
			url : "/mypage/coupon/offDownloadProc.jsp",
			data : { couponid : cid },
			dataType : "json"
		})
		.done(function(json) {
			alert(json.msg);
			if(json.result) location.reload();
		});
	}
</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<!-- 내용영역 -->
		<div class="cautionBox">
			<ul class="caution">
				<li>쿠폰별 사용조건 및 쿠폰 유효기간은 <strong class="fontTypeA">오프라인 쿠폰 목록</strong>에서 확인 가능합니다.</li>
				<li>모든 혜택은 당사 사정에 의해 사전 예고 없이 변경 또는 중지 될 수 있으며, 부당한 방법으로 다운된 쿠폰은 무효시킬 수 있습니다.</li>
			</ul>
		</div>
		<p class="couponAll"><a href="javascript:couponDownload('all');">현재 다운로드 가능한 모든 쿠폰 다운 받기 <img src="/mobile/images/btn/btn_download.png" alt="다운로드"></a></p>
		<ul class="downloadList">		
<%
	for(Param row : list) {
%>
			<li>
				<p class="tit"><%= row.get("coupon_name") %></p>
				<p class="cont"><%= Utils.formatMoney(row.get("min_price")) %>원 이상 구매시, 최대 <%= Utils.formatMoney(row.get("max_sale")) %>원 할인</p>
				<p class="date">
<%
		if("0".equals(row.get("period", "0"))) {
			out.println(row.get("start_date") + " ~ " + row.get("end_date"));
		} else {
			out.println("발급일 ~ " + Utils.formatMoney(row.get("period")) + "일");
		}
%>				
				</p>
<%
		if(row.getInt("mem_down_cnt") < row.getInt("max_download") && (row.getInt("tot_down_cnt") < row.getInt("max_issue") || row.getInt("max_issue") == 0)) {
%>
				<p class="downBtn"><a href="javascript:couponDownload('<%= row.get("couponid") %>');"><img src="/mobile/images/btn/btn_download2.png" alt="다운로드"></a></p>
<%
		} else {
%>
				<p class="downBtn disabled"><img src="/mobile/images/btn/btn_download2.png" alt="다운로드"></p>
<%
		}
%>				
			</li>
<%
	}

	if(list == null || list.size() == 0) {
%>
			<li class="none">+++ 다운로드 가능한 쿠폰이 없습니다 +++</li>
<%
	}
%>			
		</ul>
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>