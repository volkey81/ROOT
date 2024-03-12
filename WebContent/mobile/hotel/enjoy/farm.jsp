<%@page import="com.sanghafarm.utils.FrontPaging"%>
<%@page import="com.sanghafarm.service.brand.ExpClassService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
		 import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.service.board.*,
			com.sanghafarm.service.code.*,
			com.sanghafarm.utils.*" %>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(5));
	request.setAttribute("Depth_3", new Integer(7));
	request.setAttribute("MENU_TITLE", new String("상하농원"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");

	Param param = new Param(request);
	ExpContentService svc = new ExpContentService();
	CodeService code = new CodeService();
	param.keepQuery(response);

	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 9);
	final int BLOCK_SIZE = 5;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);

	List<Param> list = svc.getList(param);
	int totalCount = svc.getListCount(param);

	List<Param> gbList = code.getList2("037");
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
	<div id="container" class="hotelCont styleA">
		<!-- 내용영역 -->
		<!-- slideWrap -->
		<div class="slideWrap animated fadeInUp delay02">
			<div class="slideNum">
				<span class="nowNum">01</span>
				<span class="allNum"></span>
			</div>
			<div class="slideArea"> 
				<div class="slide">
					<img src="/mobile/images/hotel/enjoy/farmSlide01.jpg" alt="농원1">
				</div>
				<div class="slide">
					<img src="/mobile/images/hotel/enjoy/farmSlide02.jpg" alt="농원2">
				</div>
				<div class="slide">
					<img src="/mobile/images/hotel/enjoy/farmSlide03.jpg" alt="농원3">
				</div>
				<div class="slide">
					<img src="/mobile/images/hotel/enjoy/farmSlide04.jpg" alt="농원4">
				</div>
				<div class="slide">
					<img src="/mobile/images/hotel/enjoy/farmSlide05.jpg" alt="농원5">
				</div>
				<div class="slide">
					<img src="/mobile/images/hotel/enjoy/farmSlide06.jpg" alt="농원6">
				</div>
			</div>
		</div>
		<!-- //slideWrap -->

		<div class="hotelContTop animated fadeInUp delay04">
			<h2>상하농원<span>자연과 교감하고, 건강한 먹거리를 즐기는<br>농어촌 체험형 테마파크에 오신것을 환영합니다.</span></h2><br>
		</div>

		<div class="farmCont">
			<h2>공방 가이드 투어</h2>
			<img src="/mobile/images/hotel/enjoy/farm01.jpg" alt="">
			<table>
				<tr>
					<th>일&nbsp;&nbsp;&nbsp;자</th>
					<td>매주 금 / 토 / 일</td>
				</tr>
				<tr>
					<th>시&nbsp;&nbsp;&nbsp;간</th>
					<td>15:20 ~ 15:50 </td>
				</tr>
				<tr>
					<th>집결지</th>
					<td>파머스빌리지 _ 파빌리온</td>
				</tr>
				<tr>
					<th>인&nbsp;&nbsp;&nbsp;원</th>
					<td>1회 20명 한정</td>
				</tr>
			</table>
			<p class="text">상하농원에는 5가지의 공방이 존재합니다.</p>
			<p class="text2">1차산업인 ‘농산물’이 각 공방장의 손에서 2차산업으로 변신하는<br>생생한 과정을 공방 가이드와 함께 경험해보세요.</p>
			<div class="cautionArea">
				<h3>| 유의 사항 |</h3>
				<ul>
					<li>가이드는 출발시간을 엄수하며, 출발시간이 지나면 즉시 출발합니다.</li>
					<li>원활한 진행을 위해, 5분 전 집결지 대기 부탁드립니다.</li>
					<li>예약은 30분 전까지 온라인에서만 가능합니다.</li>
					<li>최종 목적지에서 자유해산입니다.</li>
					<li>우천 및 기상악화 시 취소될 수 있습니다.</li>
				</ul>
			</div>
			<div class="btnArea">
				<a href="/mobile/brand/play/reservation/admission.jsp" class="btnStyle01 sizeS">예 약 하 기</a>
			</div>
		</div><!-- //farmCont -->

		<div class="farmCont farmCont2">
			<h2>상하목장 공장 견학</h2>
			<img src="/mobile/images/hotel/enjoy/farm02.jpg" alt="">
			<table>
				<tr>
					<th>일&nbsp;&nbsp;&nbsp;자</th>
					<td>매일 (일요일 제외)</td>
				</tr>
				<tr>
					<th>시&nbsp;&nbsp;&nbsp;간</th>
					<td>1회 10:30  ｜  2회 14:00</td>
				</tr>
				<tr>
					<th>탑승장</th>
					<td>제 1주차장 공용 화장실 앞 (10분전)</td>
				</tr>
				<tr>
					<th>인&nbsp;&nbsp;&nbsp;원</th>
					<td>1회 20명 한정</td>
				</tr>
			</table>
			<p class="text">자연 그대로, 건강하고 풍부한 맛의 현장</p>
			<p class="text2">유기농 우유와 자연 치즈는 어떻게 만들어질까요?<br>우유와 치즈가 만들어지는 과정을 직접 견학 해보세요!</p>
			<div class="cautionArea">
				<h3>| 유의 사항 |</h3>
				<ul>
					<li>예약은 30분전까지 온라인에서만 가능합니다.</li>
					<li>예약이 확인될 시에만 견학이 가능합니다.</li>
					<li>견학은 반드시 셔틀버스를 통해 이동해야 합니다. (자차 금지)</li>
					<li>10분 전 탑승장 대기 바랍니다. (버스 미 탑승 시, 예약 취소로 간주됩니다.)</li>
				</ul>
			</div>
			<div class="btnArea">
				<a href="/mobile/brand/play/reservation/admission.jsp" class="btnStyle01 sizeS">예 약 하 기</a>
			</div>
		</div><!-- //farmCont2 -->

		<div class="farmCont farmCont3">
			<h2>체험교실</h2>
			<div class="expProgram">
				<div id="programList">
					<ul class="programList">
<%
	for(Param row : list) {
		String link = "Y".equals(row.get("link_yn")) ? "/mobile/brand/play/experience/view.jsp?seq=" + row.get("seq") : "javascript:void(0)";
%>
						<li>
							<a href="<%= link %>">
								<div class="thum"><img src="<%= row.get("thumb") %>" alt=""></div>
								<div class="cont">
									<strong><span><%= row.get("exp_type_nm") %></span><img src="/images/brand/play/img_tag0<%= row.getInt("exp_gb") %>.jpg" alt="카테고리" class="cate"></strong>
									<p><%= row.get("summary") %></p>
								</div>
							</a>
	<%
		if("N".equals(row.get("link_yn"))) {
	%>
							<div class="end">
								<p>
									<strong>마감</strong>
									다음에 또 만나요!
								</p>
							</div>
	<%
		}
	%>
						</li>
<%
	}
%>
					</ul>
					<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging(param.toQueryString("list.jsp"), totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeToShop(out);
	}
%>
					</ul>
				</div>
			</div><!-- //expProgram -->
		</div><!-- //farmCont3 -->
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					