<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
		 	com.sanghafarm.utils.*,
			com.sanghafarm.service.order.*" %>
<%
	request.setAttribute("Depth_1", new Integer(3));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("오프라인 쿠폰 "));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
%>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessage(out, FrontSession.LOGIN_MSG, request);
		return;
	}
	
	Param param = new Param(request);
	param.set("grade_code", fs.getGradeCode());
	param.set("unfy_mmb_no", fs.getUserNo());
	
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", Integer.MAX_VALUE);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);

	OffCouponService svc = (new OffCouponService()).toProxyInstance();
	List<Param> list = svc.getMemUseableCouponList(param);
// 	int totalCount = svc.getMemUseableCouponListCount(fs.getUserNoLong());
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script>
</script> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header.jsp" />
	<jsp:include page="/include/location.jsp" />
	<div id="container">
		<jsp:include page="/mypage/snb.jsp" />
		<div id="contArea">
			<h1 class="typeA"><%=MENU_TITLE %></h1>
			<!-- 내용영역 -->
			<div class="offlineSrmy">
				<p class="num"></p>
				<ul>
					<li>상하 가족회원을 위해 제공된 특별 이용권입니다.</li>
					<li>가입일로부터 1년간 유효하오니 해당 기간내 이용하시기 바랍니다.</li>
					<li>결제시 계산원에게 해당 이용권을 이용 갯수 만큼 제시해 주세요.</li>
					<li>유료회원 : 무료 입장권 5매 가입당일 2매만 사용 가능 </li>
				</ul>
				
			</div><!-- //couponSrmy -->
			<h3 class="couponHead">나의 쿠폰 <span class="fontTypeA"><%= Utils.formatMoney(list.size()) %></span>개</h3>
			<table class="bbsList couponList">
				<caption>나의 할인 쿠폰 목록</caption>
				<colgroup>
					<col width="300"><col width=""><col width="200">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">쿠폰명</th>
						<th scope="col">혜택 내용</th>
						<th scope="col">유효기간</th>
					</tr>
				</thead>
				<tbody>
<%
	for(Param row : list) {
%>
					<tr>
						<th scope="row"><%= row.get("coupon_name") %></th>
						<td class="fontTypeB"><%= row.get("note") %></td>
						<td><%= row.get("start_date").substring(0, 10) %> ~ <%= row.get("end_date").substring(0, 10) %></td>
					</tr>
<%
	}

	if(list.size() == 0) {
%>
					<tr><td colspan="3">+++ 나의 할인 쿠폰 내역이 없습니다 +++</td></tr>
<%
	}
%>
				</tbody>
			</table>
			<!-- //내용영역 -->
		</div><!-- //contArea -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>