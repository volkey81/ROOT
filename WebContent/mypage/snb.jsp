<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="com.sanghafarm.common.*" %>
<%
	int	Depth_1	=	(Integer)request.getAttribute("Depth_1") == null ? 0 : (Integer)request.getAttribute("Depth_1");	
	int	Depth_2	=	(Integer)request.getAttribute("Depth_2") == null ? 0 : (Integer)request.getAttribute("Depth_2");	
	int	Depth_3	=	(Integer)request.getAttribute("Depth_3") == null ? 0 : (Integer)request.getAttribute("Depth_3");
	
	FrontSession fs = FrontSession.getInstance(request, response);
%>
<script>
	function goAuth() {
		window.open("/mobile/member/corpAuth.jsp", "CORP_AUTH", "width=450,height=604,toolbar=no,menubar=no,status=no,scrollbars=yes,resizable=no");
	}
</script>
<div id="snb" class="mypageSnb">
	<p class="tit"><a href="/mypage/index.jsp">마이페이지</a></p>
	<ul>
		<li<%if(Depth_2 == 1){ %> class="on"<%} %>><p><a href="/mypage/order/list.jsp">상품주문관리</a></p>
			<ul>
				<li<%if(Depth_2 == 1 && Depth_3 == 1){ %> class="on"<%} %>><a href="/mypage/order/list.jsp">주문배송조회</a></li>
				<li<%if(Depth_2 == 1 && Depth_3 == 2){ %> class="on"<%} %>><a href="/mypage/order/cancel.jsp">주문취소/교환/반품</a></li>
				<li<%if(Depth_2 == 1 && Depth_3 == 3){ %> class="on"<%} %>><a href="/mypage/order/address.jsp">배송주소록</a></li>
				<li<%if(Depth_2 == 1 && Depth_3 == 4){ %> class="on"<%} %>><a href="/mypage/order/wish.jsp">단골상품</a></li>
			</ul>
		</li>
		<li<%if(Depth_2 == 2){ %> class="on"<%} %>><p><a href="/mypage/coupon/list.jsp">쿠폰관리</a></p>
			<ul>
				<li<%if(Depth_2 == 2 && Depth_3 == 1){ %> class="on"<%} %>><a href="/mypage/coupon/list.jsp">나의 쿠폰</a></li>
				<%-- <li<%if(Depth_2 == 2 && Depth_3 == 2){ %> class="on"<%} %>><a href="/mypage/coupon/download.jsp">쿠폰 다운로드</a></li> --%>
			</ul>
		</li>
		<li<%if(Depth_2 == 3){ %> class="on"<%} %>><p><a href="/mypage/reservation/list.jsp">체험예약관리</a></p>
			<ul>
				<li<%if(Depth_2 == 3 && Depth_3 == 1){ %> class="on"<%} %>><a href="/mypage/reservation/list.jsp">예약현황</a></li>
				<li<%if(Depth_2 == 3 && Depth_3 == 2){ %> class="on"<%} %>><a href="/mypage/reservation/cancel.jsp">예약취소 내역</a></li>
			</ul>
		</li>
		<li<%if(Depth_2 == 6){ %> class="on"<%} %>><p><a href="/mypage/reservation/list.jsp">파머스빌리지예약관리</a></p>
			<ul>
				<li<%if(Depth_2 == 6 && Depth_3 == 1){ %> class="on"<%} %>><a href="/mypage/reservation/hotel/list.jsp">예약현황</a></li>
				<li<%if(Depth_2 == 6 && Depth_3 == 2){ %> class="on"<%} %>><a href="/mypage/reservation/hotel/cancel.jsp">예약취소 내역</a></li>
				<li<%if(Depth_2 == 6 && Depth_3 == 3){ %> class="on"<%} %>><a href="/mypage/reservation/offer/list.jsp">스페셜오퍼 예약현황</a></li>
			</ul>
		</li>
		<li<%if(Depth_2 == 4){ %> class="on"<%} %>><p><a href="/mypage/board/counsel.jsp">활동관리</a></p>
			<ul>
				<li<%if(Depth_2 == 4 && Depth_3 == 1){ %> class="on"<%} %>><a href="/mypage/board/counsel.jsp">1:1문의내역</a></li>
				<li<%if(Depth_2 == 4 && Depth_3 == 2){ %> class="on"<%} %>><a href="/mypage/board/qna.jsp">상품 Q&A 내역</a></li>
				<li<%if(Depth_2 == 4 && Depth_3 == 3){ %> class="on"<%} %>><a href="/mypage/board/hotelCounsel.jsp">파머스빌리지 상담내역</a></li>
				<li<%if(Depth_2 == 4 && Depth_3 == 4){ %> class="on"<%} %>><a href="/mypage/board/review.jsp">상품평 관리</a></li>
			</ul>
		</li>
		<li<%if(Depth_2 == 5){ %> class="on"<%} %>><p><a href="#">회원관리</a></p>
			<ul>
				<li<%if(Depth_2 == 5 && Depth_3 == 1){ %> class="on"<%} %>><a href="javascript:fnt_member_info('R')">회원정보수정</a></li>
<%
	if(!fs.isSns()) {
%>
				<li<%if(Depth_2 == 5 && Depth_3 == 2){ %> class="on"<%} %>><a href="javascript:fnt_change_pw('R')">비밀번호 변경</a></li>
<%
	}
%>
				<%-- <li<%if(Depth_2 == 5 && Depth_3 == 3){ %> class="on"<%} %>><a href="javascript:fnt_change_mkt('R')">이메일/문자수신 관리</a></li> --%>
				<li<%if(Depth_2 == 5 && Depth_3 == 4){ %> class="on"<%} %>><a href="javascript:fnt_out()">회원탈퇴</a></li>
				<li><a href="javascript:goAuth()">협력사 임직원 인증</a></li>
			</ul>
		</li>
	</ul>
</div><!-- //snb -->