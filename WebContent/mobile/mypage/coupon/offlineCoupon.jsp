<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
		 	com.sanghafarm.utils.*,
			com.sanghafarm.service.order.*" %>
<%
	request.setAttribute("Depth_1", new Integer(3));
	request.setAttribute("Depth_2", new Integer(2));
	request.setAttribute("Depth_3", new Integer(3));
	request.setAttribute("MENU_TITLE", new String("상하농원 오프라인 쿠폰"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
%>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessageMobile(out, FrontSession.LOGIN_MSG, request);
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
<jsp:include page="/mobile/include/head.jsp" />
<script>
	
</script> 
</head>  
<body>
<div id="wrapper"> 
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<!-- 내용영역 -->
		<div class="offlineCouponArea">
			<ul>
				<li>상하 가족회원을 위해 제공된 특별 이용권입니다.</li>
				<li>가입일로부터 1년간 유효하오니 해당 기간내 이용하시기 바랍니다.(단, 가입당일은 사용 불가능합니다.)</li>
				<li>결제시 계산원에게 해당 이용권을 이용 갯수 만큼 제시해 주세요.</li>
			</ul>
		</div><!-- //offlineCouponArea -->
		<div class="barCode">
			<img src="<%= SanghafarmUtils.getBarcode(fs.getCardNo(), Config.get("barcode.member.path")) %>" alt="바코드">
			<p class="barcodeNum"><%= fs.getCardNo() %></p>
		</div>
		<h3 class="headText">나의 쿠폰 <span class="fontTypeA"><%= Utils.formatMoney(list.size()) %></span>개</h3>
		<ul class="myOrderList myCoupinList">
<%
	for(Param row : list) {
%>
			<li <%= "".equals(row.get("use_date")) ? "class=\"couponIng\"" : "" %>>
				<div class="head">	
					<p class="couponStatus <%= "".equals(row.get("use_date")) ? "" : "end" %>">상하가족 전용</p><!-- 쿠폰 사용 완료시 class="end"추가 -->
					<p class="tit"><strong><%= row.get("coupon_name") %></strong></p>
<%
		if(!"".equals(row.get("use_date"))) {
%>
					<p class="status end">이용완료</p>
<%
		}
%>
				</div>
				<div class="content">
					<div class="tit"><%= row.get("note") %></div>
					<p class="date"><%= row.get("start_date").substring(0, 10) %> ~ <%= row.get("end_date").substring(0, 10) %></p>
				</div>
<%
		if("".equals(row.get("use_date"))) {
%>
				<div class="foot">
					<img src="<%= SanghafarmUtils.getBarcode(row.get("mem_couponid"), Config.get("barcode.coupon.path")) %>" alt="">
					<p class="barcodeNum"><%= row.get("mem_couponid") %></p>
				</div>
<%
		}
%>
			</li>
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