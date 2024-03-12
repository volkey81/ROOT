<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.service.product.*,
				 com.sanghafarm.service.member.*,
				 com.sanghafarm.service.code.*" %>
<%
	request.setAttribute("MENU_TITLE", new String("상하가족  선물하기"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
	String layerId = request.getParameter("layerId");

	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<script>
	
</script>
</head>  
<body class="popup">
<div id="popWrap">
	<h1><%=MENU_TITLE %></h1>
	<div id="popCont">
	<!-- 내용영역 -->
		<div class="giftArea">
			<p class="tit">상하가족 멤버심 선물 받으실 회원 검색하기</p>
			<div class="idSearch">
				<form name="memForm" id="memForm" method="post" action="gift.jsp">
					<input type="text" name="userid" value="<%= param.get("userid") %>">
					<a href="#none" onclick="$('#memForm').submit()" class="btnTypeA">검색</a>
				</form>
			</div>
<%
	if(!"".equals(param.get("userid"))) {
		MemberService svc = (new MemberService()).toProxyInstance();
		Param info = svc.getImInfoById(param.get("userid"));
	
		if(info != null && !"".equals(info.get("mmb_id"))) {
			if(info.get("mmb_id").equals(fs.getUserId())) {
%>
			<p class="result">본인에게는 선물할 수 없습니다.</p>
<%
			} else {
				String name = "";
				String tel = "";
	
				for(int i = 0; i < info.get("mmb_nm").length(); i++) {
					if(i == 1) {
						name += "*";
					} else {
						name += info.get("mmb_nm").substring(i, i + 1);
					}
				}
		
				for(int i = 0; i < info.get("wrls_tel_no").length(); i++) {
					if(i == 5 || i == 6 || i == 10 || i == 12) {
						tel += "*";
					} else {
						tel += info.get("wrls_tel_no").substring(i, i + 1);
					}
				}
%>
			<p class="result"><%= param.get("userid") %> / <span><%= name %></span> / <span><%= tel %></span></p>
			<div class="btnArea">
				<form name="familyForm" id="familyForm" method="post" action="/mobile/familyJoin/agree.jsp" target="_top">
					<input type="hidden" name="userid" value="<%= info.get("mmb_id") %>">
					<input type="hidden" name="userno" value="<%= info.get("unfy_mmb_no") %>">
					<input type="hidden" name="usernm" value="<%= info.get("mmb_nm") %>">
					<a href="#" onclick="$('#familyForm').submit();" class="btnTypeB sizeL">선물하기</a>
				</form>
			</div>
<%
			}
		} else {
%>
			<p class="result">입력하신 아이디의 회원이 없습니다.</p>
<%
		}
	}
%>			
			<ul class="txt">
				<li>상하농원에 정보제공동의가 되어 있어야 합니다. </li>
				<li>매일Do 회원으로 등록 되어야 합니다.</li>
				<li>SNS 회원에게는 선물이 불가 합니다.</li>
			</ul>
		</div>
	<!-- //내용영역 -->
	</div><!-- //popCont -->
</div><!-- //popWrap -->
<script>
//팝업높이조절
setPopup(<%=layerId%>);
</script>
</body>
</html>