<%@page import="com.sanghafarm.service.order.TicketOrderService"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="com.sanghafarm.service.order.OrderService"%>
<%@page import="java.util.*"%>
<%@page import="com.sanghafarm.common.FrontSession"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@page import="com.efusioni.stone.utils.Utils"%>
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
		SanghafarmUtils.sendLoginMessage(out, FrontSession.LOGIN_MSG, request);
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
		response.sendRedirect("/mypage/");
		return;
	} else if(!"Y".equals(familyInfo.get("family_yn")) && "003".equals(fs.getGradeCode())) {
		if("1".equals(memInfo.get("stff_dv_cd"))) {	// 임직원
			fs.setGradeCode("002");
		} else {
			fs.setGradeCode("001");
		}
		response.sendRedirect("/mypage/");
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
	
	// 단골상품
	param.clear();
	param.set("userid", fs.getUserId());
	WishListService wish = new WishListService();
	int wcnt = wish.getListCount(param);
	
	// 상품Q&A
	param.clear();
	param.set("userid", fs.getUserId());
	param.set("answer_yn", "N");
	ProductQnaService qna = new ProductQnaService();
	int qcnt = qna.getListCount(param);
	
	// 상품평쓰기
	ReviewService review = new ReviewService();
	int rcnt = review.getWriteCount(fs.getUserId());
	
	// 빌리지 상담 내역
	HotelCounselService hcounsel = new HotelCounselService();
	int hccnt = hcounsel.getListCount(param); 
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script>
	$(function() {
		$(".benefitArea .btnTypeB").click(function(){
			if(!$(this).hasClass("on")) {
				$(this).addClass("on");
				$(this).parents().next(".cont").slideDown();
			} else {
				$(this).removeClass("on");
				$(this).parents().next(".cont").slideUp();
			}
			return false;
		});
	});
	
	function copyToClipboard(target){
		var target = $(target);
		target.show();
		target.select();
		var isResult = document.execCommand("copy");
		target.hide();		
		if(isResult){
			alert('복사되었습니다.');
		}
	}
</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header.jsp" />
	<jsp:include page="/include/location.jsp" />
	<div id="container">
		<jsp:include page="/mypage/snb.jsp" />
		<div id="contArea">
			<!-- 내용영역 -->
			<div class="myIndex">
				<h1>
					<img src="/images/mypage/grade<%=fs.getGradeCode()%>.png">
					<span><%= gradeName %> <strong class="fontTypeB"><%= fs.getUserNm() %></strong>님</span>
				</h1>
				<!-- urlAddress -->
				<div class="urlAddress">
					<p class="tit"><a href="" onclick="showPopupLayer('/popup/urlCopy.jsp', '580'); return false"><img src="/images/mypage/icon_question2.png" alt=""></a>친구초대란?</p>
					<input type="text" name="myurl" id="myurl" value="http://<%= request.getServerName() %>/familyJoin2018/index.jsp?r=<%= fs.getUserNo() %>" readonly style="display:none;">
					<button class="copy" onclick="showPopupLayer('/popup/urlCopy.jsp', '580'); return false;">친구 초대하기</button>
				</div>
				<!-- //urlAddress -->
				<div class="couponWrap">
					<div class="offlineCoupon">
						<div class="cont">
							<h2>오프라인 쿠폰</h2>
							<a href="/mypage/coupon/offline.jsp">
								<p class="info">
									<strong><%=totalOffCouponCount %></strong> 개
								</p>
							</a>
						</div>
					</div>
					<div class="onlineCoupon">
						<div class="cont">
							<h2>온라인 쿠폰</h2>
							<a href="/mypage/coupon/list.jsp"> 
								<p class="info line_2">
									<strong><%=totalCouponCount %></strong> 개
									<span class="able">다운가능 <em><%=downloadAbleCount %></em> 개</span>
								</p>
							</a>
						</div>
					</div>
					<div class="point">
						<div class="cont">
							<h2>Maeil Do 포인트</h2>
							<p class="info"><strong><%= Utils.formatMoney(point) %></strong> P</p>
						</div>
					</div>
					<div class="onlineCoupon">
						<div class="cont">
							<h2>기프트 카드</h2>
							<p class="info line_2">
								<strong><%= giftcardCnt %></strong> 개
								<span class="able"><em><%= Utils.formatMoney(giftcardAmt) %></em> 원</span>
							</p>							
						</div>
					</div>
				</div>
			</div><!-- //myIndex -->
			<div class="benefitArea">
<%
	if("003".equals(fs.getGradeCode())) {
%>
				<div class="txt">
					<span class="couponTxt">상하가족 회원입니다. 온라인몰을 상시 <em>10% 할인된 금액</em>으로 이용하실 수 있습니다.</span>
					<a href="#" class="btnTypeB">혜택확인하기</a>
				</div>
				<div class="cont">
					<img src="/images/mypage/content.jpg" alt="상하가족의 다양한 혜택">
				</div>		
<%
	} else if("004".equals(fs.getGradeCode())) {
%>		
			<div class="txt">
				<span class="couponTxt">상하가족 회원입니다. 온라인몰에서 <em>결제하신 금액의 5%</em>를 매일Do포인트로 적립해드립니다. </span><!-- 상하가족 B일경우  -->
			</div>
<%
	}
%>
			</div>
			
			<!--데이터 0일때 클릭이 되지 않도록 class="noClick" 추가해주시면 됩니다.  -->
			<div class="orderSrmy">
				<div class="farmersMarket">
					<div class="reserNav">
						<a href="/mypage/order/cancel.jsp">취소 <span><%= cnt6 %></span></a>
						<a href="/mypage/order/cancel.jsp">교환/반품 <span><%= cnt7 %></span></a>
						<a href="/mypage/board/qna.jsp">상품Q&amp;A <span><%= qcnt %></span></a>
						<a href="/mypage/order/list.jsp">상품평쓰기 <span><%= rcnt %></span></a>
						<a href="/mypage/order/wish.jsp">단골상품 <span><%= wcnt %></span></a>
					</div>
					<div class="cont">
						<h2 class="shop"><span>파머스<br>마켓</span></h2>
						<ul class="step">
							<li><a href="/mypage/order/list.jsp" <%= cnt1 == 0 ? "class=\"noClick\"" : "" %>><%= cnt1 %></a>주문접수</li>
							<li><a href="/mypage/order/list.jsp" <%= cnt2 == 0 ? "class=\"noClick\"" : "" %>><%= cnt2 %></a>결제완료</li>
							<li><a href="/mypage/order/list.jsp" <%= cnt3 == 0 ? "class=\"noClick\"" : "" %>><%= cnt3 %></a>상품준비중</li>
							<li><a href="/mypage/order/list.jsp" <%= cnt4 == 0 ? "class=\"noClick\"" : "" %>><%= cnt4 %></a>배송중</li>
							<li><a href="/mypage/order/list.jsp" <%= cnt5 == 0 ? "class=\"noClick\"" : "" %>><%= cnt5 %></a>배송완료</li>
						</ul>
					</div>
				</div>
				<div class="sanghaFarm">
					<div class="reserNav">
						<a href="/mypage/reservation/cancel.jsp">취소 <span><%= tcnt4 %></span></a>
						<a href="/brand/play/reservation/group.jsp">단체예약 상담</a>
					</div>
					<div class="cont">
						<h2 class="reser"><span>상하농원<br>체험</span></h2>
						<ul class="step">
							<li><a href="/mypage/reservation/list.jsp" <%= tcnt1 == 0 ? "class=\"noClick\"" : "" %>><%= tcnt1 %></a>예약완료</li>
							<li><a href="/mypage/reservation/list.jsp" <%= tcnt2 == 0 ? "class=\"noClick\"" : "" %>><%= tcnt2 %></a>이용예정</li>
							<li><a href="/mypage/reservation/list.jsp" <%= tcnt3 == 0 ? "class=\"noClick\"" : "" %>><%= tcnt3 %></a>이용 완료</li>
						</ul>
					</div>
				</div>
				<div class="farmersVillage">
					<div class="reserNav">
						<a href="/mypage/reservation/hotel/cancel.jsp">취소 <span><%= hcnt4 %></span></a>
						<a href="/mypage/board/hotelCounsel.jsp">상담내역 <span><%= hccnt %></span></a>
					</div>
					<div class="cont">
						<h2 class="reser"><span>파머스빌리지<br>일반예약</span></h2>
						<ul class="step">
							<li><a href="/mypage/reservation/hotel/list.jsp" <%= hcnt1 == 0 ? "class=\"noClick\"" : "" %>><%= hcnt1 %></a>예약완료</li>
							<li><a href="/mypage/reservation/hotel/list.jsp" <%= hcnt2 == 0 ? "class=\"noClick\"" : "" %>><%= hcnt2 %></a>이용예정</li>
							<li><a href="/mypage/reservation/hotel/list.jsp" <%= hcnt3 == 0 ? "class=\"noClick\"" : "" %>><%= hcnt3 %></a>이용 완료</li>
						</ul>
					</div>
				</div>
				<div class="farmersVillage">
					<div class="reserNav">
<%-- 						<a href="/mypage/reservation/offer/list.jsp">취소 <span><%= hocnt4 %></span></a> --%>
					</div>
					<div class="cont">
						<h2 class="reser"><span>파머스빌리지<br>스페셜오퍼</span></h2>
						<ul class="step">
							<li><a href="/mypage/reservation/offer/list.jsp" <%= hocnt1 == 0 ? "class=\"noClick\"" : "" %>><%= hocnt1 %></a>예약완료</li>
							<li><a href="/mypage/reservation/offer/list.jsp" <%= hocnt2 == 0 ? "class=\"noClick\"" : "" %>><%= hocnt2 %></a>이용예정</li>
							<li><a href="/mypage/reservation/offer/list.jsp" <%= hocnt3 == 0 ? "class=\"noClick\"" : "" %>><%= hocnt3 %></a>이용 완료</li>
						</ul>
					</div>
				</div>
			</div><!-- //orderSrmy -->
			
			<div class="myPageNavWrap">
				<div class="customerCt">
					<h2>고객센터</h2>
					<ul>
						<li><a href="/customer/counsel.jsp">1:1문의하기</a></li>
						<li><a href="/mypage/board/counsel.jsp">1:1문의내역</a></li>
						<li><a href="/customer/hotelCounsel.jsp">빌리지 상담</a></li>
						<li><a href="/mypage/board/hotelCounsel.jsp">빌리지 상담내역</a></li>
						<li><a href="/customer/faq.jsp">자주하는 질문 (FAQ)</a></li>
					</ul>
				</div>
				<div class="memberInfo">
					<h2>회원정보</h2>
					<ul>
					
					<%
	if("003".equals(fs.getGradeCode()) || "004".equals(fs.getGradeCode())) {
%>
				<li><a href="javascript:alert('준비중입니다')">상하가족 이력</a></li>	
<%
	} else{
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
					</ul>
				</div>
			</div>
			<!-- //내용영역 -->
		</div><!-- //contArea -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>