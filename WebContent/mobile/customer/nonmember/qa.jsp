<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.efusioni.stone.security.*,
			com.sanghafarm.service.hotel.*" %>
<%
	request.setAttribute("Depth_1", new Integer(4));
	request.setAttribute("MENU_TITLE", new String("파머스 빌리지 상담"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);
	
	HotelCounselService svc = new HotelCounselService();
	Param info = svc.getInfo(param.get("seq"));
	if(info == null || "".equals(info.get("seq"))) {
		Utils.sendMessage(out, "잘못된 접근입니다.");
		return;
	}
	
	String enc = SecurityUtils.encodeSHA512(param.get("passwd"));
	if(!enc.equals(info.get("passwd"))) {
		Utils.sendMessage(out, "비밀번호가 맞지않습니다.");
		return;
	}
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
		<h1 class="typeA"><%= MENU_TITLE %></h1>
		<div class="cautionBox">
			<p class="caution">항상 최선을 다하는 상하농원이 되겠습니다.</p>
		</div>
		<!-- 내용영역 -->		
		<div class="hotelQaWrap">
			<div class="head">
				<p class="cate"><%= info.get("cate_name") %></p>
				<p class="tit"><%= Utils.safeHTML(info.get("title")) %></p>
				<p class="date"><%= info.get("regist_date") %><span class="status">답변완료</span></p>
			</div>
			<div class="qa">
				<div class="question">
<%
		if("002".equals(info.get("cate"))) {
%>
									업장 : <%= info.get("gubun") %></br>
									이용 일자 : <%= info.get("date1") %></br>
									이용 인원 : <%= info.get("person") %></br></br>
<%
		} else if("003".equals(info.get("cate"))) {
%>
									행사 구분 : <%= info.get("gubun") %></br>
									1순위 일시 : <%= info.get("date1") %> <%= info.get("time_from1") %> ~ <%= info.get("time_to1") %></br>
									2순위 일시 : <%= info.get("date2") %> <%= info.get("time_from2") %> ~ <%= info.get("time_to2") %></br>
									참석 예상 인원 : <%= info.get("person") %></br></br>
<%
		} else if("004".equals(info.get("cate"))) {
%>
									행사 목적 : <%= info.get("gubun") %></br>
									기업명 : <%= info.get("company") %></br>
									일자 및 시간 : <%= info.get("date1") %> <%= info.get("time_from1") %> ~ <%= info.get("time_to1") %></br>
									참석 예상 인원 : <%= info.get("person") %></br>
									객실 사용여부 : <%= "Y".equals(info.get("room_yn")) ? "예" : "아니오" %></br></br>
<%
		}
%>
									<%= Utils.safeHTML(info.get("question"), true) %><br/><br/>
				</div>
				<div class="answer">
					<strong>문의 주신 내용에 답변드립니다.</strong>
					<p>
						<%= Utils.safeHTML(info.get("answer"), true) %>		
					</p>	 
				</div>
			</div>
		</div>
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>