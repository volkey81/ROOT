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
		<ul>
			<li><a href="/customer/partnership.jsp">입점/제휴문의</a></li>
			<li><a href="/customer/agree.jsp">이용약관</a></li>
			<li><a href="/customer/privacy.jsp">개인정보취급방침</a></li>
			<li><a href="/customer/faq.jsp">고객센터</a></li>
			<li><a href="#" onclick="showPopup('.popHotLine'); return false">윤리 HOT-LINE</a></li>
		</ul>
		<p>
			<span>전라북도 고창군 상하면 상하농원길 11-23</span>
			<span>대표 : 최승우</span>
			<span>개인정보 보호 책임자 : 최승우</span>
		</p>
		<p>
			<span>사업자등록번호 : 415-86-00211</span>
			<span>통신판매업신고번호 : 제2016-4780085-30-2-00015호</span>
		</p>
		<p>
			<span>상담이용시간 : 09:30~18:00</span>
			<span>농원운영시간 : 연중무휴 09:30~21:00</span>
		</p>
		<p>		
			<span>고객센터 1522-3698</span>
			<span>빌리지예약 063-563-6611</span>
		</p>
		<p class="text">상하농원(유)은 매일유업(주)과의 제휴를 통해 공동으로 서비스를 운영하고 있습니다.</p>
	</div>
	<p class="copy">@ 2021 SANGHA FARM CO. ALL RIGHTS RESERVED</p>
	<div class="appDownload">
		<p class="appTit">상하농원 <span>앱 다운로드</span></p>
		<!-- <div>
		<form name="footerAppForm" id="footerAppForm" action="/ajax/appDownload.jsp" method="post">
			010<span>-</span><input type="text" name="mobile2" maxlength="4" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)"><span>-</span><input type="text" name="mobile3" maxlength="4" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">
			<a href="javascript:appDownload();">받기  &gt;</a>
		</form>
		</div> -->
		<ul class="qrArea">
			<li class="fl"><span>안드로이드</span><img src="/images/common/qr_android.png?ver=1" alt=""></li>
			<li class="fr"><span>Ios</span><img src="/images/common/qr_ios.png?ver=1" alt=""></li>
		</ul>
	</div>
	<p class="btnTop"><a href="#" onclick="goTop(); return false"><img src="/images/layout/btn_top.png" alt="TOP"></a></p>
</div></div><!-- //footer -->
<div class="popLayer popHotLine">
	<h2>윤리 HOT-LINE</h2>
	<p class="close"><a href="#" onclick="hidePopup(this); return false">팝업닫기</a></p>
	<div class="popCont">
		상하농원은 고객 및 임직원의 소중한 의견을 청취하여 윤리경영의 초석을 마련하고자 합니다.<br>
		다음과 같은 사실이 있을 경우 제보해 주시기 바랍니다.<br><br>
		- 임직원의 부적절한 언행<br>
		- 부당한 금품·향응·편의 요구, 불공정거래행위 및 비윤리 행위 등과 관련된 제보 
		<ul>
			<li>제보자의 신분 노출 및 조사의 전문성과 객관성을 확보하기 위하여 사내의 감사실과는 별도로 독립적인 외부 제보 채널에서 운영되고 있습니다.</li>
			<li>단순 민원성 제보나 근거 없이 타인을 비방하거나 음해하는 내용의 제보는 처리되지 않을 수도 있습니다.</li>
			<li>제보 내용은 육하원칙에 따라 제보하여 주시면 보다 신속한 답변에 도움이 될 수 있습니다.</li>
		</ul> 
		<div class="btnArea">
			<a href="https://pito.co.kr/hot_line/index.php?scode=CDATIZ" target="_blank" class="btnTypeB sizeXL">신고하기</a>
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

<script>
function appDownload() {
	if($("#footerAppForm input[name=mobile2]").val() == '') {
		alert("휴대폰 번호를 입력하세요.");
	} else if($("#footerAppForm input[name=mobile3]").val() == '') {
		alert("휴대폰 번호를 입력하세요.");
	} else {
		ajaxSubmit($("#footerAppForm"), function(json) {
			alert(json.msg);
		});
	}
}
</script>
<% if(Depth_1 != 1 && Depth_1 != 5){ //브랜드, 호델에서는 노출 X %>
<%-- <jsp:include page="/include/quick.jsp" /> --%>
<% } %>

<jsp:include page="/include/analytics.jsp" /> 
<jsp:include page="/integration/ssoCheck.jsp" /> 
