<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
	int	Depth_1	=	(Integer)request.getAttribute("Depth_1") == null ? 0 : (Integer)request.getAttribute("Depth_1");	
	int	Depth_2	=	(Integer)request.getAttribute("Depth_2") == null ? 0 : (Integer)request.getAttribute("Depth_2");	
	int	Depth_3	=	(Integer)request.getAttribute("Depth_3") == null ? 0 : (Integer)request.getAttribute("Depth_3");
%>
<div id="snb" class="customerSnb">
	<p class="tit"><a href="/customer/faq.jsp">고객센터</a></p>
	<ul>
		<li<%if(Depth_2 == 1){ %> class="on"<%} %>><a href="/customer/faq.jsp">자주하는 질문</a></li>
		<li<%if(Depth_2 == 2){ %> class="on"<%} %>><a href="/customer/notice/list.jsp">공지사항</a></li>
		<%-- <li<%if(Depth_2 == 3){ %> class="on"<%} %>><a href="/customer/delivery.jsp">상하배송안내</a></li> --%>
		<li<%if(Depth_2 == 4){ %> class="on"<%} %>><a href="/customer/counsel.jsp">1:1상담</a></li>
		<li<%if(Depth_2 == 5){ %> class="on"<%} %>><a href="/customer/hotelCounsel.jsp">파머스빌리지 상담</a></li>
<%-- 		<li<%if(Depth_2 == 5){ %> class="on"<%} %>><a href="/customer/payment/list.jsp">개인 결제</a></li> --%>
	</ul>
	<ul>
		<li<%if(Depth_2 == 5){ %> class="on"<%} %>><a href="/customer/agree.jsp">이용약관</a></li>
		<li<%if(Depth_2 == 6){ %> class="on"<%} %>><a href="/customer/privacy.jsp">개인정보 보호정책</a></li>
	</ul>
	<div class="centerInfo">
		<p class="tel">고객상담<br><span>1522-3698</span></p>
		<p class="time">오전 10:00 ~ 오후 18:00</p>
		<p class="mail"><a href="mailto:sangha3698@maeil.com">sangha3698@maeil.com</a></p>
	</div>
</div><!-- //snb -->