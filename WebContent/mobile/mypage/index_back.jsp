<%@page import="com.sanghafarm.service.order.TicketOrderService"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.Date"%>
<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="com.sanghafarm.service.order.OrderService"%>
<%@page import="java.util.List"%>
<%@page import="com.sanghafarm.common.*"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="com.efusioni.stone.common.*"%>
<%@page import="com.sanghafarm.service.order.*"%>
<%@page import="com.sanghafarm.service.member.*"%>
<%@page import="com.sanghafarm.service.code.*"%>
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
	
	// 회원등급 변경 체크
	FamilyMemberService family = (new FamilyMemberService()).toProxyInstance();
	MemberService mem = (new MemberService()).toProxyInstance();
	
	Param familyInfo = family.getInfo(fs.getUserNoLong());
	
	if("Y".equals(familyInfo.get("family_yn")) && !familyInfo.get("family_grade_code").equals(fs.getGradeCode())) {
		fs.setGradeCode(familyInfo.get("family_grade_code"));
		response.sendRedirect("/mobile/mypage/");
		return;
	} else if(!"Y".equals(familyInfo.get("family_yn")) && "003".equals(fs.getGradeCode())) {
		Param memInfo = mem.getImInfo(fs.getUserNo());
		if("1".equals(memInfo.get("stff_dv_cd"))) {	// 임직원
			fs.setGradeCode("002");
		} else {
			fs.setGradeCode("001");
		}
		response.sendRedirect("/mobile/mypage/");
		return;
	}

	// 전체 쿠폰
	CouponService coupon = (new CouponService()).toProxyInstance();
	OffCouponService offCoupon = (new OffCouponService()).toProxyInstance();

	//페이징 변수 설정
//	final int PAGE_SIZE = param.getInt("page_size", 10);
//	final int BLOCK_SIZE = 10;
//	int nPage = param.getInt("page", 1);
//	param.addPaging(nPage, PAGE_SIZE);
	
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
	
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 10);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);
		
	//게시물 리스트
	param.set("status_type", "1");
	List<Param> orderList = order.getOrderList(param);

	int paymentWaitingCount   = 0;	// 결재대기 갯수
	int paymentCompleteCount  = 0;	// 결재완료 갯수
	int orderConfirmCount     = 0;	// 주문확인중 갯수
	int prepareCommodityCount = 0;	// 상품준비중 갯수
	int shippingCount 		  = 0;	// 배송중 갯수
	int shipCompletedCount 	  = 0;	// 배송완료 갯수
	List<Param> totalCounts = order.getOrderListIndexCount(param);
	
 	for (Param count : totalCounts) {
		switch(count.getInt("STATUS")){
			case 110 :
				paymentWaitingCount   = count.getInt("COUNT");
				break;
			case 120 :
				paymentCompleteCount  = count.getInt("COUNT");
				break;
			case 130 :
				orderConfirmCount     = count.getInt("COUNT");
				break;
			case 140 :
				prepareCommodityCount = count.getInt("COUNT");
				break;
			case 150 :
				shippingCount 		  = count.getInt("COUNT");
				break;
			case 160 :
				shipCompletedCount 	  = count.getInt("COUNT");
				break;
			default : break;
		}
	}
	
 	// 체험 예약 관리
  	param.clear();
 	param.set("userid", fs.getUserId());
 	param.set("status_type", "1");
 	
 	// 주문/배송 현황
 	TicketOrderService ticket = (new TicketOrderService()).toProxyInstance();
 	
 	//페이징 변수 설정
 	param.addPaging(nPage, PAGE_SIZE);
 	
 	// 주문 리스트
 	List<Param> ticketList = ticket.getOrderList(param);
 	
 	// 주문 갯수
 	// 110	결제완료,120 관리자예약, 130 이용완료,140	미이용완료,210	결제취소, 220	관리자취소
 	param.set("status_type", "110");
 	int useCount = ticket.getOrderListCount(param);
 	
 	param.set("status_type", "130");
 	int usedCount = ticket.getOrderListCount(param);
 	
 	param.set("status_type", "210");
 	int cancelCount = ticket.getOrderListCount(param);

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
<script>
	$(function() {
		var clipboard = new Clipboard('.copy');

		clipboard.on('success', function(e) {
			alert("복사되었습니다.");
		});
		
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
</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
		<h1 class="typeA"><%=MENU_TITLE %></h1>
		<!-- 내용영역 -->
		<div class="myIndex">
			<h2><%= gradeName %> <strong class="fontTypeB"><%= fs.getUserNm() %></strong></h2>
			<div class="offlineCoupon">
				<h3>오프라인 쿠폰</h3>
				<div class="cont">
					<div>
						<a href="/mobile/mypage/coupon/offlineCoupon.jsp" class="wrap">
							<p class="num"><strong><%= totalOffCouponCount %></strong> 개</p>
						</a>
						<a href="/mobile/mypage/coupon/offlineDownload.jsp" class="wrap">													
							<p class="able">다운가능<em><strong><%=downloadAbleCount2 %></strong> 개</em></p>							
						</a>
					</div>
				</div>
			</div>
			<div class="coupon">
				<h3>온라인마켓 쿠폰</h3>
				<div class="cont">
					<div>
						<a href="/mobile/mypage/coupon/list.jsp" class="wrap">
							<p class="num"><strong><%=totalCouponCount %></strong> 개</p>
						</a>	
						<a href="/mobile/mypage/coupon/download.jsp" class="wrap">							
							<p class="able">다운가능<em><strong><%=downloadAbleCount %></strong> 개</em></p>
						</a>
					</div>
				</div>
			</div>
			<div class="point">
				<h3>Maeil Do 포인트</h3>
				<div class="cont">
					<div>
						<div class="wrap">
							<p class="num"><strong><%= Utils.formatMoney(point) %></strong> P</p>
						</div>
					</div>
				</div>
			</div>
			<div class="coupon">
				<h3>기프트 카드</h3>
				<div class="cont">
					<div>
						<p class="num"><strong><%= giftcardCnt %></strong> 개</p>
						<p class="able">금액<em><strong><%= Utils.formatMoney(giftcardAmt) %></strong> 원</em></p>
					</div>
				</div>
			</div>
		</div><!-- //myIndex -->

		<!-- urlAddress -->
		<div class="urlAddress">
			<p class="tit"><a href="" onclick="showPopupLayer('/mobile/popup/urlCopy.jsp', '580'); return false"><img src="/images/mypage/icon_question.gif" alt=""></a>나의 고유주소</p>
			<input type="text" name="myurl" id="myurl" value="http://<%= request.getServerName() %>/mobile/familyJoin2018/index.jsp?r=<%= fs.getUserNo() %>" readonly>
			<button class="copy" data-clipboard-target="#myurl">URL 복사하기</button>
		</div>
		<!-- //urlAddress -->
		
<%
	if("003".equals(fs.getGradeCode())) {
%> 
			<div class="benefitArea">
				<div class="txt">
					<span class="couponTxt">상하가족 회원입니다. 온라인몰을 상시 10% 할인된 금액으로 이용하실 수 있습니다.</span>
					<a href="#" class="btnTypeB">혜택확인하기</a>
				</div>
				<div class="cont">
					<img src="/mobile/images/mypage/content.jpg" alt="상하가족의 다양한 혜택">
				</div>		
			</div>
<%
	} else if("004".equals(fs.getGradeCode())) {
%>
		<p class="familyTxt">상하가족 회원입니다. 온라인몰에서 결제하신 금액의 5%를 매일Do포인트로 적립해드립니다. </p><!-- 상하가족 B일경우  -->
<%
	}
%> 

		<div class="barCode">
				<img src="<%= SanghafarmUtils.getBarcode(fs.getCardNo(), Config.get("barcode.member.path")) %>" alt="바코드">
				<p class="barcodeNum"><%= fs.getCardNo() %></p>
			</div>
		
		<div class="mypageNav">
			<ul class="order">
				<li><a href="/mobile/mypage/order/list.jsp">주문배송조회</a></li>
				<li><a href="/mobile/mypage/order/cancel.jsp">주문취소/교환/반품</a></li>
				<li><a href="/mobile/mypage/order/address.jsp">배송주소록</a></li>
				<li><a href="/mobile/mypage/order/wish.jsp">단골상품</a></li>
			</ul>
			<ul class="reser">
				<li><a href="/mobile/mypage/reservation/list.jsp">체험 예약현황</a></li>
				<li><a href="/mobile/mypage/reservation/cancel.jsp">예약취소 내역</a></li>
			</ul>
			<ul class="board">
				<li><a href="/mobile/mypage/board/review.jsp">상품평 관리</a></li>
				<li><a href="/mobile/mypage/board/qna.jsp">상품 Q&amp;A 내역</a></li>
				<li><a href="/mobile/customer/counsel.jsp">1:1문의하기</a></li>
				<li><a href="/mobile/mypage/board/counsel.jsp">1:1문의내역</a></li>
			</ul>
			<ul class="custom">
				<%-- <li><a href="<%= Env.getMaeildoUrl() %>/co/mp/comp01t9.do?chnlCd=3&coopcoCd=7040&returnUrl=http://<%= request.getServerName() %>/mobile">마케팅 수신동의</a></li> --%>
<%-- 				<li><a href="<%= Env.getMaeildoUrl() %>/co/mp/comp01r7.do?chnlCd=3&coopcoCd=7040&returnUrl=http://<%= request.getServerName() %>/mobile">회원탈퇴</a></li> --%>
<%
	if(fs.isSns()) {
%>
				<li><a href="/mobile/member/modifySns2.jsp">회원정보수정</a></li>
				<li><a href="/mobile/member/memLeave2.jsp">회원탈퇴</a></li>
<%
	} else {
%>
				<li><a href="/mobile/member/memModify1.jsp">회원정보수정</a></li>
				<li><a href="/mobile/member/memLeave1.jsp">회원탈퇴</a></li>
<%
	}
%>
			</ul>			
		</div>
		
		<div class="orderSrmy">
			<h2 class="shop">파머스마켓</h2>
			<!-- <h3 class="typeA">주문/배송 현황</h3>
			<ol class="step">
				<li><strong><span><%= paymentWaitingCount %></span></strong>입금대기</li>
				<li class="typeB"><strong><span><%= paymentCompleteCount %></span></strong>결제 완료</li>
				<li><strong><span><%= orderConfirmCount %></span></strong>주문확인중</li>
				<li class="typeB"><strong><span><%= prepareCommodityCount %></span></strong>상품준비중</li>
				<li><strong><span><%= shippingCount %></span></strong>배송중</li>
				<li class="typeC"><strong><span><%= shipCompletedCount %></span></strong>배송완료</li>
			</ol> -->
			
			<h3 class="typeA">최근 주문내역</h3>
			<ul class="myOrderList">
<% 
	if (CollectionUtils.isNotEmpty(orderList)) {
		for (Param row : orderList) {
			String[] items = row.get("ITEMS").split("::");
%>			
				<li>
					<div class="head">
						<p class="num"><strong><a href="/mobile/mypage/order/view.jsp?orderid=<%= row.get("ORDERID") %>&ship_seq=<%= row.get("SHIP_SEQ") %>" class="fontTypeC"><%= row.get("ORDERID") %>_<%= row.get("SHIP_SEQ") %></a></strong><br>주문일시 : <%= row.get("ORDER_DATE_FOR_INDEX") %></p>
						<p class="status"><%= row.get("FE_NAME") %></p>
					</div>
					<div class="content">
						<div class="tit"><%=StringUtils.isNotEmpty(items[3]) ? items[3] : "" %>
							<p class="opt"><%=StringUtils.isNotEmpty(items[4]) ? items[4] : "" %></p>
						</div>
						<p class="date">배송요청일 : <%= row.get("DELIVERY_DATE", "-") %></p>
					</div>
				</li>
<%
		}
	} else {
%>
				<li class="none">+++ 최근 주문 내역이 없습니다 +++</li>
<%  } %>				
			</ul>
			<!-- //최근 주문내역 -->
			
			<h2 class="reser">상하농원 체험교실</h2>
			<!-- <h3 class="typeA">체험 예약 현황</h3>
			<ul class="step">
				<li class="typeC"><strong><span><%=useCount + usedCount + cancelCount %></span></strong>전체</li>
				<li><strong><span><%=useCount %></span></strong>이용 예정</li>
				<li class="typeB"><strong><span><%=usedCount %></span></strong>이용 완료</li>
				<li><strong><span><%= cancelCount %></span></strong>취소/환불</li>
			</ul> -->
			
			<h3 class="typeA">최근 예약내역</h3>
			<ul class="myOrderList">
<%
	if(CollectionUtils.isNotEmpty(ticketList)) {
		for(Param row : ticketList) {
%>
				<li>
					<div class="head">
						<p class="num"><strong><a href="/mobile/mypage/reservation/view.jsp?orderid=<%= row.get("orderid") %>" class="fontTypeC"><%= row.get("orderid") %></a></strong><br>주문일시 : <%= row.get("order_date") %></p>
						<p class="status"><%= row.get("status_name") %></p>
					</div>
					<div class="content">
						<div class="tit"><%= row.get("ticket_name") %>
<%
			String[] items = row.get("items").split(",");
			for(String item : items) {
				String[] it = item.split("::");
%>
							<p class="opt">
								<%= it[0] %> <%= it[1] %><br>
							</p>
								
<%
			}
%>
						</div>
						<p class="date">예약일 : <%= row.get("reserve_date") %> <%= !"".equals(row.get("time")) ? row.get("time").substring(0, 2) + ":" + row.get("time").substring(2) : "" %></p>
					</div>
<%
			String barcodeImg = ticket.getBarcode(row.get("orderid"));
			if (StringUtils.isNotEmpty(barcodeImg)) {
%>
					<div class="foot">
						<img src="<%=barcodeImg %>" alt="">
					</div>
<%
			}					
%>
				</li>
<%
		}
	} else {
%>
					<li class="none">+++ 최근 예약 내역이 없습니다 +++</li>
<%
	}
%>
			</ul>
			<!-- //최근 예약내역 -->
		</div><!-- //orderSrmy -->
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>