<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			java.text.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.service.board.*,
			com.sanghafarm.service.code.*,
			com.sanghafarm.utils.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(2));
	request.setAttribute("MENU_TITLE", new String("체험교실"));
	
	Param param = new Param(request);
	ExpContentService svc = new ExpContentService();
	param.keepQuery(response);

	String date = param.get("date", Utils.getTimeStampString(new Date(), "yyyy.MM.dd"));
	List<Param> list = svc.getListByDate(date);
	
	Calendar c = Calendar.getInstance();
	c.set(Calendar.YEAR, Integer.parseInt(date.substring(0, 4)));
	c.set(Calendar.MONTH, Integer.parseInt(date.substring(5, 7)) - 1);
	c.set(Calendar.DATE, Integer.parseInt(date.substring(8, 10)));
	
	Calendar today = Calendar.getInstance();
	Calendar c1 = (Calendar) c.clone();
	Calendar c2 = (Calendar) c.clone();
	c1.add(Calendar.DATE, -1);
	c2.add(Calendar.DATE, 1);
	String prev = Utils.getTimeStampString(c1.getTime(), "yyyy.MM.dd");
	String next = Utils.getTimeStampString(c2.getTime(), "yyyy.MM.dd");
	String kyou = Utils.getTimeStampString(today.getTime(), "yyyy.MM.dd");
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script>
	$(function () {
		$('.expArea .slideWrap').slick({
	         initialSlide:0,
	         slidesToShow:1,
	         slidesToScroll:1,
	         autoplay: true,
	         autoplaySpeed: 2000,
	         arrows:true,
	         adaptiveHeight: true,
	         infinite: true,
	         dots: true,
	         adaptiveHeight: true
	     });
		
		efuSlider('.calWrap', 1, 0, '', 'once');	
	});

	function popLayerClose(){
		$('.bgLayer').hide();
		$('#calendarPop').hide();
		$(window).off('mousewheel scroll');
	}
	function popLayerOpen(num){
		$('.bgLayer').css('z-index',50);
		$('.bgLayer').show();
		$('#calendarPop').show();
		$(window).on('mousewheel scroll', function(e) {
	        e.preventDefault();
	        e.stopPropagation();
	        return false;
	    });	
	}
</script> 
</head>  
<body class="fullpage">
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<jsp:include page="/brand/include/location.jsp" />
	<jsp:include page="/brand/include/snb.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<div class="expHead">
			<span>오감 먹거리 체험교실</span><br>자연의 먹거리를 그대로 보고,<br>만지는 오감 체험을 통해 바른 먹거리를 배우는 공간	
		</div>
		<div class="expArea">
			<h2><img src="/images/brand/play/tit_experience.png" alt="상하농원 체험교실"></h2>
			<p class="srmy"><span>상하농원 체험 교실의 다섯가지 긍정의 씨앗</span></p>
			<div class="slideWrap">
				<div>
					<p class="desc">사랑의 씨앗</p>
					<p class="cont">가족/친구와 추억을 <br>공유함으로써 유대감과 사랑을 키울 수 있어요</p>
				</div>
				<div>
					<p class="desc">참맛의 씨앗</p>
					<p class="cont">자극적인 맛에 길들여진 미각을 일깨워<br>맛있는 음식에 대한 기준을 재조명 해요 </p>
				</div>
				<div>
					<p class="desc">행복의 씨앗</p>
					<p class="cont">먹거리가 주는 즐거움과 함께<br>만드는 재미를 느껴요</p>
				</div>
				<div>
					<p class="desc">슬기의 씨앗</p>
					<p class="cont">바른 음식을 구별할 수 있는 힘을<br>길러줌으로써 먹거리를 제대로 알고 먹어요</p>
				</div>	
				<div>
					<p class="desc">감사의 씨앗</p>
					<p class="cont">먹거리를 제공하는 모든 자연, 동물과 생산자의 열정에<br> 감사하는 마음을 가져요</p>
				</div>				
			</div>
		</div><!-- //expArea -->
		<div class="expProgram">
			<div class="displayMode">
				<a href="list.jsp">유형으로 보기</a>
				<a href="list2.jsp" class="on">날짜로 보기</a>
			</div>
			<div id="programList">
				<div class="calTabArea">
					<div class="date">
						<span><%= date %></span>
						<a href="javascript:popLayerOpen();" class="calBtn"><img src="/images/brand/play/icon_calender2.png" alt="달력아이콘"></a>
					</div>
					<p>* 체험 일정 및 시간은 일부 조정될 수 있습니다.</p>
					<a href="<%= prev.compareTo(kyou) < 0 ? "javascript:alert('지난 일정입니다.')" : "list2.jsp?date=" + prev %>" class="prev"><img src="/images/btn/btn_prev8.png" alt="이전 날짜"></a>
					<a href="list2.jsp?date=<%= next %>" class="next"><img src="/images/btn/btn_prev8.png" alt="다음 날짜"></a>
				</div>
				<ul class="programList2">
<%
	for(Param row : list) { 
		String link = "Y".equals(row.get("link_yn")) ? "view.jsp?seq=" + row.get("seq") : "javascript:void(0)";
%>
					<li>
						<div class="time"><%= row.get("time").substring(0, 2) %>:<%= row.get("time").substring(2, 4) %></div>
						<div class="cont">
							<strong><%= row.get("exp_type_nm") %><img src="/images/brand/play/img_tag0<%= row.getInt("exp_gb") %>.jpg" alt="카테고리"  class="cate"></strong>
							<p><%= row.get("summary") %></p>
							<a href="<%= link %>">자세히보기 &gt;</a>
						</div>
						<div class="thum"><div class="box"><img src="<%= row.get("thumb") %>" alt=""></div></div>
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
			</div>
		</div><!-- //expProgram -->
	<!-- //내용영역 -->
	</div><!-- //container -->
<%
	Calendar cal = Calendar.getInstance();
	Calendar cal2 = Calendar.getInstance();
	cal2.add(Calendar.DATE, 35);
	
	SimpleDateFormat format = new SimpleDateFormat("yyyy '<strong>'EEE'<br>'MMM dd'</strong>'", Locale.US);
%>	
	<div id="calendarPop">
		<div class="leftArea">
			<p><%= format.format(today.getTime()) %></p>
			<a href="javascript:popLayerClose();" class="closeBtn">CLOSE</a>
		</div>
		<div class="calWrap">
				<div class="slideCont">
					<ul>
<%
	for(int j = 0; j < 3; j++) {
		cal.set(Calendar.DATE, 1);
%>
						<li class="sec">
							<h3><%= (new SimpleDateFormat("YYYY", java.util.Locale.US)).format(cal.getTime()) %>.<span><%=  (new SimpleDateFormat("MM", java.util.Locale.US)).format(cal.getTime())%></span></h3>
							<div class="cal">
								<ol class="week">
									<li>SUN</li>
									<li>MON</li>
									<li>TUE</li>
									<li>WED</li>
									<li>THR</li>
									<li>FRI</li>
									<li>SAT</li>
								</ol>
								<ol class="day">
<%
		for(int i = 1; i < cal.get(Calendar.DAY_OF_WEEK); i++) { 
%>
									<li></li>
<%
		}
	
		while(true) {
			if((cal.compareTo(today) < 0) || (cal.compareTo(cal2) > 0)) {
%>
									<li class="disable"><a href="javascript:void(0)"><%= cal.get(Calendar.DATE) %></a></li>
<%
			} else {
%>
									<li <%= cal.compareTo(today) == 0 ? "class=\"today\"" : "" %>><a href="list2.jsp?date=<%= Utils.getTimeStampString(cal.getTime(), "yyyy.MM.dd") %>"><%= cal.get(Calendar.DATE) %></a></li>
<%			
			}
			
			if(cal.get(Calendar.DATE) == cal.getActualMaximum(Calendar.DATE)) break;
			cal.add(Calendar.DATE, 1);
		}
%>
								</ol>
							</div><!-- //calender -->
						</li><!-- //sec -->
<%
		cal.add(Calendar.MONTH, 1);
	}
%>
					</ul>
				</div><!-- //slideCont -->
				<input type="image" src="/images/btn/btn_prev9.png" alt="이전달" class="prev">
				<input type="image" src="/images/btn/btn_next9.png" alt="다음달" class="next">
			</div>
	</div>
	<jsp:include page="/include/footer.jsp" />
</div><!-- //wrapper -->
</body>
</html>
