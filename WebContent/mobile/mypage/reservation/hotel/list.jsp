<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.service.hotel.*,
			org.json.simple.*" %>
<%
	request.setAttribute("Depth_1", new Integer(3));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("예약현황"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
%>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessageMobile(out, FrontSession.LOGIN_MSG, request);
		return;
	}
	
	Param param = new Param(request);
	RMSApiService svc = new RMSApiService();
	param.set("unfy_mmb_no", fs.getUserNo());
	JSONObject json = svc.info(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<script>
	function cancelOrder(intg_resv_no) {
		if(confirm("취소하시겠습니까?")) {
			$("#intg_resv_no").val(intg_resv_no);
			$("#mode").val("CANCEL");
	
			ajaxSubmit($("#orderForm"), function(json) {
				alert(json.msg);
				document.location.reload();
			});
		}
	}
</script> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
	<form name="orderForm" id="orderForm" method="POST" action="/mypage/reservation/hotel/orderProc.jsp">
		<input type="hidden" name="mode" id="mode" />
		<input type="hidden" name="intg_resv_no" id="intg_resv_no" />
	</form>
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<!-- 내용영역 -->
		<div class="cautionBox">
			<ul class="caution">
				<li>모든 예약은 당사의 사정에 의해 변경될 수 있습니다.</li>
					<li>예약 취소 수수료는 아래와 같습니다.
						<ul class="sub">
							<li><p class="tit">(극)성수기/패키지</p>
								<ul>
									<li>투숙예정일 15일 전까지 취소한 경우 예약금액 전액 환불</li>
									<li>투숙예정일 14~8일 전까지 취소한 경우 예약금액의 10% 환불</li>
								</ul>
							</li>
							<li><p class="tit">비&nbsp;수&nbsp;기</p>
								<ul>
									<li>투숙예정일 8일 전까지 취소한 경우 예약금액 전액 환불</li>
								</ul>
							 </li>
							 <li><p class="tit">공&nbsp;통</p>
							 	<ul>
							 		<li>투숙예정일 7~4일 전까지 취소한 경우 예약금액의 50% 환불</li>
							 		<li>투숙예정일 3일 전~당일 취소(No-show포함) 예약금액 환불 없음</li>
							 	</ul>
							 </li>
						</ul>
					</li>
			</ul>
		</div>
		
		<h2 class="typeB">예약내역</h2>
		<ul class="myOrderList">
<%
	int r = 0;
	JSONArray list = (JSONArray) json.get("LIST");
	// 취소가능 체크인 일자
	Calendar cal = Calendar.getInstance();
	cal.add(Calendar.DATE, 8);
	String d = Utils.getTimeStampString(cal.getTime(), "yyyyMMdd");
	
	for(int i = list.size() - 1; i >= 0; i--) {
		String room = "";
		String chkiDate = "";
		String chotDate = "";
		String resvStGbcd = "";
	
		JSONObject row = (JSONObject) list.get(i);
		JSONArray rsvList = (JSONArray) row.get("RSV_LIST");
	
		for(int j = 0; j < rsvList.size(); j++) {
			JSONObject rsvRow = (JSONObject) rsvList.get(j);
			room += rsvRow.get("ROOM_KND_NM") + ", ";
			if(j == 0) {
				chkiDate = (String) rsvRow.get("CHKI_DATE");
				chotDate = (String) rsvRow.get("CHOT_DATE");
				resvStGbcd = (String) rsvRow.get("RESV_ST_GBCD");
			}
		}
		
		if(!"C".equals(resvStGbcd)) {
			r++;
%>		
			<li>
				<div class="head">
					<p class="num"><strong><a href="view.jsp?intg_resv_no=<%= row.get("INTG_RESV_NO") %>"><%= row.get("INTG_RESV_NO") %></a></strong> (<%= row.get("INPT_YMD").toString().substring(0, 4) %>.<%= row.get("INPT_YMD").toString().substring(4, 6) %>.<%= row.get("INPT_YMD").toString().substring(6, 8) %>)</p>
					<p class="status"><%= "R".equals(resvStGbcd) ? "예약완료" : "이용완료" %></p>
				</div>
				<div class="content">
					<div class="tit"><%= room.substring(0, room.length() - 2) %></div>
					<p class="date">일정 : <%= chkiDate.substring(0, 4) %>.<%= chkiDate.substring(4, 6) %>.<%= chkiDate.substring(6, 8) %> ~ <%= chotDate.substring(0, 4) %>.<%= chotDate.substring(4, 6) %>.<%= chotDate.substring(6, 8) %></p>
					<p class="btn">
<%
			if(chkiDate.compareTo(d) >= 0) {
%>
						<a href="javascript:cancelOrder('<%= row.get("INTG_RESV_NO") %>')" class="btnTypeA sizeS">예약취소</a>
<%
			} else {
%>
						<a href="javascript:alert('투숙예정일로부터 7일이내 예약 건은 온라인 취소가 불가능합니다.\n취소를 원하시는 경우 고객센터 1522-3698로 연락주시어 취소하시기 바랍니다');" class="btnTypeA sizeS">예약취소</a>
<%
			}
%>						
					</p>
				</div>
			</li>
<%
		}
	}
	if(r == 0){
%>
			<li class="none">+++ 예약내역이 없습니다 +++</li>
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