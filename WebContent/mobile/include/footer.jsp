<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%
	int	Depth_1	=	(Integer)request.getAttribute("Depth_1") == null ? 0 : (Integer)request.getAttribute("Depth_1");	
	int	Depth_2	=	(Integer)request.getAttribute("Depth_2") == null ? 0 : (Integer)request.getAttribute("Depth_2");	
	int	Depth_3	=	(Integer)request.getAttribute("Depth_3") == null ? 0 : (Integer)request.getAttribute("Depth_3");
	int	Depth_4	=	(Integer)request.getAttribute("Depth_4") == null ? 0 : (Integer)request.getAttribute("Depth_4");
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
	String url = request.getRequestURI();
%>
<div id="footer">
	<ul class="nav">
		<!-- <li><a href="">공지사항</a></li> -->
		<li><a href="/mobile/customer/partnership.jsp">입점/제휴문의</a></li>
		<li><a href="/mobile/customer/agree.jsp">이용약관</a></li>
		<li><a href="/mobile/customer/privacy.jsp"><strong>개인정보취급방침</strong></a></li>
		<li><a href="/mobile/customer/faq.jsp">고객센터</a></li>
		<li class="last"><a href="#" onclick="$('.popHotLine').fadeIn(); return false">윤리 HOT-LINE</a></li>
	</ul>
	<div class="contact">
		<address>전라북도 고창군 상하면 상하농원길 11-23</address>
		<p>
			<span>대표 : 최승우</span>
			<span>개인정보 보호 책임자 : 최승우</span>
		</p>
		<p>
			<span>사업자등록번호 : 415-86-00211</span>
		</p>
		<p>
			<span>통신판매업신고번호 : 제2016-4780085-30-2-00015호 </span>
		</p>
		<p>
			<span>상담이용시간 : 09:30~18:00</span>
			<span>농원운영시간 : 연중무휴 09:30~21:00</span>
		</p>
		<p>		
			<span>고객센터 1522-3698</span>
			<span>빌리지예약 063-563-6611</span>
		</p>
	</div>
	<p class="copy">@ 2018 SANGHA FARM CO. ALL RIGHTS RESERVED</p>
	<p class="top"><a href="#" onclick="goTop(); return false"><img src="/mobile/images/layout/btn_top.png" alt="TOP"></a></p>
<% 
	//if(Depth_1 == 1 || Depth_1 == 5){ //브랜드 , 파머스빌맂 
		if(!url.equals("/mobile/brand/")
				&& !url.equals("/mobile/brand/index.jsp")
				&& !url.equals("/mobile/hotel/")
				&& !url.equals("/mobile/hotel/index.jsp")
				&& !url.equals("/mobile/hotel/room/reservation/room.jsp")
				&& !url.equals("/mobile/hotel/room/reservation/info.jsp")
				&& !url.equals("/mobile/hotel/room/reservation/payment.jsp")
				&& !url.equals("/mobile/hotel/room/reservation/complete.jsp")
				&& !url.equals("/mobile/main.jsp")) {
%>
	<a href="javascript:history.back()" class="btnPrev"><img src="/mobile/images/hotel/common/btn_prev.png" alt="이전"></a>
<% 
		}
	//} 
%>
</div><!-- //footer -->
<div class="popLayer popHotLine">
	<h2>윤리 HOT-LINE</h2>
	<p class="close"><a href="#" onclick="hideLayerPopup(this); return false"><img src="/mobile/images/btn/btn_close2.png" alt="닫기"></a></p>
	<div class="popCont">
		상하농원은 고객 및 임직원의 소중한 의견을 청취하여 윤리경영의 초석을 마련하고자 합니다.<br>
		다음과 같은 사실이 있을 경우 제보해 주시기 바랍니다.
		<ul class="typeA">
			<li>임직원의 부적절한 언행</li>
			<li>부당한 금품·향응·편의 요구, 불공정거래행위 및 비윤리 행위 등과 관련된 제보</li>
		</ul> 
		<ul class="typeB">
			<li>제보자의 신분 노출 및 조사의 전문성과 객관성을 확보하기 위하여 사내의 감사실과는 별도로 독립적인 외부 제보 채널에서 운영되고 있습니다.</li>
			<li>단순 민원성 제보나 근거 없이 타인을 비방하거나 음해하는 내용의 제보는 처리되지 않을 수도 있습니다.</li>
			<li>제보 내용은 육하원칙에 따라 제보하여 주시면 보다 신속한 답변에 도움이 될 수 있습니다.</li>
		</ul> 
		<div class="btnArea">
			<a href="https://pito.co.kr/hot_line/index.php?scode=CDATIZ" target="_blank" class="btnTypeB sizeM">신고하기</a>
		</div>
	</div>	
</div><!-- //popHotLine -->

<!-- NAVER SCRIPT -->
<script type="text/javascript" src="//wcs.naver.net/wcslog.js"></script> 
<script type="text/javascript"> 
if (!wcs_add) var wcs_add={};
wcs_add["wa"] = "s_22b521e45584";
if (!_nasa) var _nasa={};
wcs.inflow("sanghafarm.co.kr");
wcs_do(_nasa);
</script>

<%
	if(url.indexOf("/brand/") < 0 && url.indexOf("/product/detail.jsp") < 0){
%>
	<jsp:include page="/mobile/include/quick.jsp" />
<%
	}
%>

<jsp:include page="/include/analytics.jsp" /> 
<jsp:include page="/integration/ssoCheck.jsp" /> 
