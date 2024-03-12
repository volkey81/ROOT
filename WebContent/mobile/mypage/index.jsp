<%@page import="com.sanghafarm.service.order.TicketOrderService"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="com.sanghafarm.service.order.OrderService"%>
<%@page import="java.util.*"%>
<%@page import="com.sanghafarm.common.FrontSession"%>
<%@page import="com.efusioni.stone.utils.*"%>
<%@page import="com.efusioni.stone.common.*"%>
<%@page import="com.sanghafarm.service.order.*"%>
<%@page import="com.sanghafarm.service.member.*"%>
<%@page import="com.sanghafarm.service.code.*"%>
<%@page import="com.sanghafarm.service.hotel.*,
				com.sanghafarm.service.board.*,
				org.json.simple.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setAttribute("Depth_1", new Integer(3));
	request.setAttribute("Depth_2", new Integer(0));
	request.setAttribute("Depth_3", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("마이페이지"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	FrontSession fs = FrontSession.getInstance(request, response);
	
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessageMobile(out, FrontSession.LOGIN_MSG, request);
		return;
	}
	
	/*
	// 회원등급 변경 체크
	FamilyMemberService family = (new FamilyMemberService()).toProxyInstance();
	MemberService mem = (new MemberService()).toProxyInstance();
	
	Param memInfo = mem.getImInfo(fs.getUserNo());
	Param familyInfo = family.getInfo(fs.getUserNoLong());
	String gradeCode = "";
	
	if(!"005".equals(fs.getGradeCode())) {
		if("1".equals(memInfo.get("stff_dv_cd"))) {	// 임직원
			if("Y".equals(familyInfo.get("family_yn")) && "003".equals(familyInfo.get("family_grade_code"))) {
				gradeCode = "003";
			} else {
				gradeCode = "002";
			}
		} else if("Y".equals(familyInfo.get("family_yn"))) {	// 상하가족
			gradeCode = familyInfo.get("family_grade_code");
		} else {
			gradeCode = memInfo.get("grade_code");
		}
	
		if(!gradeCode.equals(fs.getGradeCode())) {
			fs.setGradeCode(gradeCode);
			response.sendRedirect("/mypage/");
			return;
		}
	}
	*/
	
	/*
	if("Y".equals(familyInfo.get("family_yn")) && !familyInfo.get("family_grade_code").equals(fs.getGradeCode())) {
		fs.setGradeCode(familyInfo.get("family_grade_code"));
		response.sendRedirect("/mobile/mypage/");
		return;
	} else if(!"Y".equals(familyInfo.get("family_yn")) && "003".equals(fs.getGradeCode())) {
		if("1".equals(memInfo.get("stff_dv_cd"))) {	// 임직원
			fs.setGradeCode("002");
		} else {
			fs.setGradeCode("001");
		}
		response.sendRedirect("/mobile/mypage/");
		return;
	}
	*/

	// 전체 쿠폰
	CouponService coupon = (new CouponService()).toProxyInstance();
	OffCouponService offCoupon = (new OffCouponService()).toProxyInstance();

	// 전체 쿠폰 갯수
	Param param = new Param(request);
	param.set("userid", fs.getUserId());
	int totalCouponCount = coupon.getMemCouponListCount(param);
	int totalOffCouponCount = offCoupon.getMemUseableCouponListCount(fs.getUserNoLong());
	
	// 다운로드 가능 쿠폰 갯수
	param.set("grade_code", fs.getGradeCode());
	List<Param> downloadableList = coupon.getDownloadableList(param);
	int downloadAbleCount = 0;
	for(Param row : downloadableList) {
		if(row.getInt("mem_down_cnt") < row.getInt("max_download") && (row.getInt("tot_down_cnt") < row.getInt("max_issue") || row.getInt("max_issue") == 0)) {
			downloadAbleCount++;
		}
	}
	
	param.set("unfy_mmb_no", fs.getUserNo());
	List<Param> downloadableList2 = offCoupon.getDownloadableList(param);
	int downloadAbleCount2 = 0;
	for(Param row : downloadableList2) {
		if(row.getInt("mem_down_cnt") < row.getInt("max_download") && (row.getInt("tot_down_cnt") < row.getInt("max_issue") || row.getInt("max_issue") == 0)) {
			downloadAbleCount2++;
		}
	}
	
	// 주문/배송 현황
	OrderService order = (new OrderService()).toProxyInstance();	
	int cnt1 = 0;	// 결재대기 갯수
	int cnt2 = 0;	// 결재완료 갯수
	int cnt3 = 0;	// 상품준비중 갯수
	int cnt4 = 0;	// 배송중 갯수
	int cnt5 = 0;	// 배송완료 갯수
	int cnt6 = 0; 	// 취소
	int cnt7 = 0; 	// 반품/교환
	
	List<Param> totalCounts = order.getOrderListIndexCount(param);
	
 	for(Param row : totalCounts) {
 		if("110".equals(row.get("status"))) cnt1 = row.getInt("count");
 		else if("120".equals(row.get("status"))) cnt2 = row.getInt("count");
 		else if("140".equals(row.get("status"))) cnt3 = row.getInt("count");
 		else if("150".equals(row.get("status"))) cnt4 = row.getInt("count");
 		else if("160".equals(row.get("status"))) cnt5 = row.getInt("count");
 		else if("290".equals(row.get("status"))) cnt6 = row.getInt("count");
 		else if(row.getInt("status") >= 210 && row.getInt("status") <= 260) cnt7 = row.getInt("count");
	}
 	
 	// 체험 예약 관리
 	param.clear();
	param.set("userid", fs.getUserId());
	TicketOrderService ticket = (new TicketOrderService()).toProxyInstance();
	param.addPaging(1, Integer.MAX_VALUE);
	List<Param> tList = ticket.getOrderList(param);
	int tcnt1 = 0;	// 예약완료
	int tcnt2 = 0;	// 이용예정
	int tcnt3 = 0;	// 이용완료
	int tcnt4 = 0;	// 취소
	
	String today = Utils.getTimeStampString("yyyy.MM.dd");
	
	for(Param row : tList) {
		if("210,220".indexOf(row.get("status")) != -1) tcnt4++;
		else if(SanghafarmUtils.getDateDiff(today, row.get("reserve_date").substring(0, 10)) <= 0) tcnt3++;
		else if(SanghafarmUtils.getDateDiff(today, row.get("reserve_date").substring(0, 10)) <= 2) tcnt2++;
		else tcnt1++;
	}
	
	// 빌리지 예약
	int hcnt1 = 0;	// 예약완료
	int hcnt2 = 0;	// 이용예정
	int hcnt3 = 0;	// 이용완료
	int hcnt4 = 0;	// 취소
 	param.clear();
	param.set("unfy_mmb_no", fs.getUserNo());
	RMSApiService svc = new RMSApiService();
	JSONObject json = svc.info(param);
	if(json != null) {
		JSONArray hList = (JSONArray) json.get("LIST");
		today = Utils.getTimeStampString("yyyyMMdd");
		
		for(int i = 0; i < hList.size(); i++) {
			JSONObject row = (JSONObject) hList.get(i);
			JSONArray rsvList = (JSONArray) row.get("RSV_LIST");
			String chkiDate = "";
			String chotDate = "";
			String resvStGbcd = "";
			
			for(int j = 0; j < rsvList.size() && j < 1; j++) {
				JSONObject rsvRow = (JSONObject) rsvList.get(j);
				chkiDate = (String) rsvRow.get("CHKI_DATE");
				resvStGbcd = (String) rsvRow.get("RESV_ST_GBCD");
			}
			
			if("C".equals(resvStGbcd)) hcnt4++;
			else if(SanghafarmUtils.getDateDiff(today, chkiDate, "yyyyMMdd") <= 0) hcnt3++; 
			else if(SanghafarmUtils.getDateDiff(today, chkiDate, "yyyyMMdd") <= 8) hcnt2++;
			else hcnt1++;
		}
	}
	
	// 빌리지 스페셜오퍼
	HotelOfferService hoffer = new HotelOfferService();
 	param.clear();
	param.set("userid", fs.getUserId());
	Param hofferSummary = hoffer.getReserveSummary(param);
	
	int hocnt1 = hofferSummary.getInt("cnt1");
	int hocnt2 = hofferSummary.getInt("cnt2");
	int hocnt3 = hofferSummary.getInt("cnt3");
	int hocnt4 = hofferSummary.getInt("cnt4");

	ImMemberService immem = (new ImMemberService()).toProxyInstance();
	int point = immem.getMemberPoint(fs.getUserNo());

	CodeService code = (new CodeService()).toProxyInstance();
	String gradeName = code.getCode2Name(new Param("code1", "001", "code2", fs.getGradeCode()));

	// 기프트카드
	List<Param> giftcardList = immem.getMemberGiftcard(fs.getUserNo());
	int giftcardCnt = 0;
	int giftcardAmt = 0;
	for(Param row : giftcardList) {
		if("10".equals(row.get("crd_st"))) {
			giftcardCnt++;
			giftcardAmt += (row.getInt("actv_amt") - row.getInt("use_amt"));
		}
	}
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<script src="/js/clipboard.min.js"></script>
<script type="text/javascript" src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script>
	$(function() {
// 		Kakao.init('875eb70060bda09cc2d0a3dfc9998a05');    	
		Kakao.init('b0f34396ce9620b05e6814cac819e2d0');    	

		var clipboard = new Clipboard('.copy');

		clipboard.on('success', function(e) {
			alert("복사되었습니다.");
		});
		
		$(".slideBtn").click(function(){
			if(!$(this).hasClass("on")) {
				$(this).addClass("on");
				$(this).next(".cont").slideDown(150);
			}else{
				$(this).removeClass("on");
				$(this).next(".cont").slideUp(150);
			}
			return false;
		});
	});
	
	function sendInvitation() {
    	Kakao.Link.sendDefault({
    		objectType: 'feed',
    		content: {
    			title: "회원가입 시 <%= fs.getUserNm() %>(<%= fs.getUserId() %>) 추천하고 다양한 혜택받아보세요!",
    			description: "무료배송, 온/오프 할인쿠폰, 최대 3% 포인트 적립",
    			imageUrl: 'https://www.sanghafarm.co.kr/images/invitaion.jpg',
    			link: {
    				mobileWebUrl: 'https://www.sanghafarm.co.kr/mobile/event/view.jsp?seq=181&type=view',
    				webUrl: 'https://www.sanghafarm.co.kr/event/view.jsp?seq=181&type=view'
    			}
    		}
    	});
	}
	
</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container" class="myPageMain">
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<!-- 내용영역 -->
		<div class="myIndex">
			<h1><strong><%= fs.getUserNm() %></strong>님의 등급은 <span class="fontTypeG">[<%= gradeName %>]</span>입니다.</h1>
			
<%
	if("003".equals(fs.getGradeCode())) {
%>
			<p class="benefit"><span class="icoGo"></span>온라인몰 10% 할인</p>
<%
	} else if("004".equals(fs.getGradeCode())) {
%>		
			<p class="benefit"><span class="icoGo"></span>온라인몰 5% 매일Do포인트 적립</p>
<%
	}
%>			
			<div class="btnArea">
				<span><a href="javascript:sendInvitation()" class="btnTypeA">친구 초대하기</a></span>
<%
	if("003".equals(fs.getGradeCode())) {
%>
				<span><a href="#" onclick="showLayerPopup('.benefitLayer', 'setTop'); return false" class="btnTypeA">혜택 확인하기</a></span>
<%
	}
%>
			</div>
			<div class="barcode">
				<img src="<%= SanghafarmUtils.getBarcode(fs.getCardNo(), Config.get("barcode.member.path")) %>" alt="바코드">
				<p class="barcodeNum"><%= fs.getCardNo() %></p>
			</div>
		</div><!-- //myIndex -->
		<div class="myBenefit">
			<h2>나의 혜택</h2>
			<ul>
				<li><a href="/mobile/mypage/coupon/list.jsp" class="icoGo">
					<p class="tit">파머스 마켓 쿠폰</p>
					<p class="num"><strong><%=totalCouponCount %></strong>개</p>
				</a></li>
				<li><a href="/mobile/mypage/coupon/offlineCoupon.jsp" class="icoGo">
					<p class="tit">상하농원 쿠폰</p>
					<p class="num"><strong><%=totalOffCouponCount %></strong>개</p>
				</a></li>
				<li><div>
					<p class="tit">Maeil Do 포인트</p>
					<p class="num"><strong><%= Utils.formatMoney(point) %></strong>P</p>
				</div></li>
				<li><div>
					<p class="tit">기프트카드</p>
					<p class="num"><strong><%= giftcardCnt %></strong>개 (<%= Utils.formatMoney(giftcardAmt) %></em>원)</span></p>
				</div></li>
			</ul>
		</div><!-- //coupon -->
				
		<div class="orderSrmy">
			<div class="farmersMarket">
				<h2 class="shop">파머스 마켓</h2>
				<ul class="step">
					<li><a href="/mobile/mypage/order/list.jsp" <%= cnt1 == 0 ? "class=\"noClick\"" : "" %>><%= cnt1 %></a>주문접수</li>
					<li><a href="/mobile/mypage/order/list.jsp" <%= cnt2 == 0 ? "class=\"noClick\"" : "" %>><%= cnt2 %></a>결제완료</li>
					<li><a href="/mobile/mypage/order/list.jsp"	<%= cnt3 == 0 ? "class=\"noClick\"" : "" %>><%= cnt3 %></a>상품준비중</li>
					<li><a href="/mobile/mypage/order/list.jsp" <%= cnt4 == 0 ? "class=\"noClick\"" : "" %>><%= cnt4 %></a>배송중</li>
					<li><a href="/mobile/mypage/order/list.jsp" <%= cnt5 == 0 ? "class=\"noClick\"" : "" %>><%= cnt5 %></a>배송완료</li>
				</ul>
				<div class="reserNav">
					<a href="/mobile/mypage/order/list.jsp">주문배송조회</a>
					<a href="/mobile/mypage/order/cancel.jsp">주문 취소/교환/반품</a>
					<a href="/mobile/mypage/order/address.jsp">배송주소록</a>
					<a href="/mobile/mypage/order/wish.jsp">단골상품</a>
<!-- 					<a href="/mobile/customer/counsel.jsp">문의하기</a> -->
					<a href="/mobile/mypage/board/review.jsp">상품평 관리</a>
					<a href="/mobile/mypage/board/qna.jsp">상품Q&A내역</a>
				</div>
			</div>
			<div class="sanghaFarm">
				<h2 class="reser">상하농원 체험</h2>
				<ul class="step">
					<li><a href="/mobile/mypage/reservation/list.jsp" <%= tcnt1 == 0 ? "class=\"noClick\"" : "" %>><%= tcnt1 %></a>예약완료</li>
					<li><a href="/mobile/mypage/reservation/list.jsp" <%= tcnt2 == 0 ? "class=\"noClick\"" : "" %>><%= tcnt2 %></a>이용예정</li>
					<li><a href="/mobile/mypage/reservation/list.jsp" <%= tcnt3 == 0 ? "class=\"noClick\"" : "" %>><%= tcnt3%></a>이용 완료</li>
				</ul>
				<div class="reserNav">
					<a href="/mobile/mypage/reservation/list.jsp">예약현황</a>
					<a href="/mobile/mypage/reservation/cancel.jsp">예약취소 내역</a>
					<a href="/mobile/mypage/reservation/offer/list.jsp">스페셜오퍼 예약현황</a>
					<a href="/mobile/customer/counsel.jsp?cate=007">문의하기</a>
					<a href="/mobile/mypage/board/counsel.jsp">내 문의내역</a>
				</div>
			</div>
			<div class="farmersVillage">
				<h2 class="reser">파머스빌리지 일반예약</h2>
				<ul class="step">
					<li><a href="/mobile/mypage/reservation/hotel/list.jsp" <%= hcnt1 == 0 ? "class=\"noClick\"" : "" %>><%= hcnt1 %></a>예약완료</li>
					<li><a href="/mobile/mypage/reservation/hotel/list.jsp" <%= hcnt2 == 0 ? "class=\"noClick\"" : "" %>><%= hcnt2 %></a>이용예정</li>
					<li><a href="/mobile/mypage/reservation/hotel/list.jsp" <%= hcnt3 == 0 ? "class=\"noClick\"" : "" %>><%= hcnt3 %></a>이용 완료</li>
				</ul>
				<div class="reserNav">
					<a href="/mobile/mypage/reservation/hotel/list.jsp">예약현황</a>
					<a href="/mobile/mypage/reservation/hotel/cancel.jsp">예약취소 내역</a>
					<a href="/mobile/customer/hotelCounsel.jsp">파머스빌리지 상담</a>
					<a href="/mobile/mypage/board/hotelCounsel.jsp">내 상담내역</a>
				</div>
			</div>
			<div class="farmersVillage">
				<h2 class="reser">파머스빌리지 스페셜오퍼</h2>			
				<ul class="step">
					<li><a href="/mobile/mypage/reservation/offer/list.jsp" <%= hocnt1 == 0 ? "class=\"noClick\"" : "" %>><%= hocnt1 %></a>예약완료</li>
					<li><a href="/mobile/mypage/reservation/offer/list.jsp" <%= hocnt2 == 0 ? "class=\"noClick\"" : "" %>><%= hocnt2 %></a>이용예정</li>
					<li><a href="/mobile/mypage/reservation/offer/list.jsp" <%= hocnt3 == 0 ? "class=\"noClick\"" : "" %>><%= hocnt3 %></a>이용 완료</li>
				</ul>
				<div class="reserNav">
					<a href="/mobile/mypage/reservation/offer/list.jsp">예약현황</a>
<!-- 					<a href="/mobile/mypage/reservation/offer/list.jsp">예약취소 내역</a> -->
				</div>
			</div>
		</div><!-- //orderSrmy -->
			
		<div class="myPageNavWrap">
			<div class="customerCt">
				<h2>고객센터</h2>
				<ul>
					<li><a href="/mobile/customer/counsel.jsp">1:1문의하기</a></li>
					<li><a href="/mobile/mypage/board/counsel.jsp">1:1문의내역</a></li>
					<li><a href="/mobile/customer/faq.jsp">자주하는 질문</a></li>
					<li><a href="javascript:_serviceCenterTel();">고객센터 연결</a></li>
				</ul>
			</div>
			<div class="memberMg">
				<h2>나의활동</h2>
				<ul>
					
<%
	if("003".equals(fs.getGradeCode()) || "004".equals(fs.getGradeCode())) {
%>
					<li><a href="javascript:alert('준비중입니다')">상하가족 이력</a></li>	
<%
	} else {
%>		
					<li><a href="javascript:alert('상하가족회원 서비스입니다')">상하가족 이력</a></li>
<%
	}
%>
						
					<li><a href="javascript:fnt_member_info('R')">회원정보 수정</a></li>
<%
	if(!fs.isSns()) {
%>
					<li><a href="javascript:fnt_change_pw('R')">비밀번호 변경</a></li>
<%
	}
%>
					<li><a href="javascript:fnt_out()">회원탈퇴</a></li>
					<li><a href="/mobile/member/corpAuth.jsp">협력사 임직원 인증</a></li>
				</ul>
			</div>
		</div>
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
<div class="popLayer benefitLayer">
	<p class="close"><a href="#" onclick="hideLayerPopup(this); return false"><img src="/mobile/images/btn/btn_close3.png" alt="닫기"></a></p>
	<div class="popCont">
		<img src="/mobile/images/mypage/content.jpg" alt="상하가족의 다양한 혜택">
	</div>
</div>
</body>
</html>