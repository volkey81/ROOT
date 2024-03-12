<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(2));
	request.setAttribute("Depth_4", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("걸어온 길"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" /> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<jsp:include page="/brand/include/location.jsp" />
	<jsp:include page="/brand/include/snb.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<div class="historyWrap">
			<h2>
				<span>당신을 만나기까지</span>
				상하농원이 걸어온 길
			</h2>
			<div class="historyList"> 
				<div id="his2018" class="section">
					<div>
						<img src="/images/brand/introduce/history/thum_2018_1.jpg" alt="">
						<strong>2018</strong>
					</div>
					<ul>
						<li>
							<span class="month">07</span>
							<b>자연, 농부의 쉼터가 되다</b>
							<p>웨딩, 연회, 세미나, 체험이 가능한 숙박시설 오픈</p>
						</li>
					</ul>
				</div><!-- //section -->
				<div id="his2016" class="section ar">
					<div>
						<img src="/images/brand/introduce/history/thum_2015.jpg" alt="">
						<strong>2016</strong>
					</div>
					<ul>
						<li>
							<span class="month">04</span>
							<b>세상을 만나다</b>
							<p>농원 전 시설 오픈</p>
						</li>
					</ul>
				</div>
				<div id="his2015" class="section ar">				
					<div>
						<strong>2015</strong>
					</div>
					<ul>				
						<li>
							<span class="month">09</span>
							<b>상하농원 첫 솜씨를 맛보다</b>
							<p>농원회관, 햄공방 외 6개 공간<br>
							시범 운영시작</p>
						</li>
					</ul>
				</div><!-- //section -->
				<div id="his2014" class="section">
					<div>
						<img src="/images/brand/introduce/history/thum_2014.jpg" alt="">
						<strong>2014</strong>
					</div>
					<ul>
						<li>
							<span class="month">10</span>
							<b>자연을 품다</b>
							<p>순백색 동물복지유정란</p>
						</li>
					</ul>
				</div><!-- //section -->
				<div id="his2013" class="section ar">
					<div>
						<img src="/images/brand/introduce/history/thum_2013.jpg" alt="">
						<strong>2013</strong>
					</div>
					<ul>
						<li>
							<span class="month">12</span>
							<b>첫 삽을 뜨다</b>
							<p>토목공사 착공</p>
						</li>
					</ul>
				</div><!-- //section -->
				<div id="his2012" class="section">
					<div>
						<img src="/images/brand/introduce/history/thum_2012.jpg" alt="">
						<strong>2012</strong>
					</div>
					<ul>
						<li>
							<span class="month">06</span>
							<b>씨앗을 뿌리다</b>
							<p>고시히카리 테스트 재배 시작</p>
						</li>
					</ul>
				</div><!-- //section -->
				<div id="his2011" class="section ar">
					<div>
						<img src="/images/brand/introduce/history/thum_2011.jpg" alt="">
						<strong>2011</strong>
					</div>
					<ul>
						<li>
							<span class="month">02</span>
							<b>예술, 농촌을 만나다</b>
							<p>아티스트 김범 작가 합류<br>
							서울대 최준웅교수 합류(건축설계시작)</p>
						</li>
						<li>
							<span class="month">04</span>
							<b>진심을 전하다</b>
							<p>유기농 목장 체험활동 시작</p>
						</li>
					</ul>
				</div><!-- //section -->
				<div id="his2010" class="section">
					<div>
						<img src="/images/brand/introduce/history/thum_2010.jpg" alt="">
						<strong>2010</strong>
					</div>
					<ul>
						<li>
							<span class="month">01</span>
							<b>마음을 얻다</b>
							<p>인근지역 농민 대상 사업설명회 개최<br>
							고창군, 매일유업 사업투자 확정</p>
						</li>
					</ul>
				</div><!-- //section -->
				<div id="his2008" class="section">
					<div>
						<strong>2008</strong>
					</div>
					<ul>
						<li>
							<span class="month">12</span>
						</li>
					</ul>
					<p class="firstTxt">농부, 상하의 자연을 만나다</p>
				</div><!-- //section -->
				<div class="bg1"></div>
				<div class="bg2"></div>
			</div><!-- //historyList -->
		</div>	
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					