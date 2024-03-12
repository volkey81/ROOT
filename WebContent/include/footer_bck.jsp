<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%
	int	Depth_1	=	(Integer)request.getAttribute("Depth_1") == null ? 0 : (Integer)request.getAttribute("Depth_1");	
	int	Depth_2	=	(Integer)request.getAttribute("Depth_2") == null ? 0 : (Integer)request.getAttribute("Depth_2");	
	int	Depth_3	=	(Integer)request.getAttribute("Depth_3") == null ? 0 : (Integer)request.getAttribute("Depth_3");	
%>
<div id="footer"><div class="wrap">
	<p class="logo"><img src="/images/layout/logo2.png" alt="상하농원"></p>
	<div class="contact">
		<address>전라북도 고창군 상하면 상하농원길 11-23</address>
		<p>사업자등록번호 : 415-86-00211</p>
		<p>대표자명 : 임채문, 권태훈</p>
		<p>개인정보 보호정책 책임자 : 임채문</p>
		<p>통신판매업신고번호 : 제2016-4780085-30-2-00015호</p>
		<p>전화번호 : 1522-3698</p>
		<p>상담이용시간 : 09:30~18:00</p>		
		<p>농원운영시간 : 연중무휴 09:30~21:00</p>
		<p><a href="https://goo.gl/XBtJkz" target="_blank">입점/제휴문의</a></p>
	</div>
	<p class="copy">상하농원(유)은 매일유업(주)과의 제휴를 통해 공동으로 서비스를 운영하고 있습니다. <span class="eng">COPYRIGHT 2017 SANGHA FARM CO. ALL RIGHTS RESERVED</span></p>
	<p class="top"><a href="#" onclick="goTop(); return false"><img src="/images/layout/btn_top.gif" alt="TOP"></a></p>
</div></div><!-- //footer -->
<% if(Depth_1 != 1 && Depth_1 != 6){ //브랜드, 호델에서는 노출 X %>
<jsp:include page="/include/quick.jsp" />
<% } %>

<jsp:include page="/include/analytics.jsp" /> 
<jsp:include page="/integration/ssoCheck.jsp" /> 
