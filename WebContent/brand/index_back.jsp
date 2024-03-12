<%@page import="com.sanghafarm.service.board.*"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			java.text.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*" %>
<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%
	// 진입페이지 쿠키
	SanghafarmUtils.setCookie(response, "LANDING_PAGE", "BRAND", ".sanghafarm.co.kr", 60*60*24*100);
%>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(0));
	request.setAttribute("Depth_3", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("브랜드"));

	PopupService popup = (new PopupService()).toProxyInstance();
	List<Param> popupList = popup.getList(new Param("device", "P", "position", "B"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script>
	$(function() {
<%
	for(Param row : popupList) {
		if("1".equals(row.get("pop_type"))) {
%>
		//일반팝업
		if (getCookie("popup<%= row.get("seq") %>") != "done" ){
			var popHeight = <%= row.get("height") %> + 25;
			window.open('/popup/popup.jsp?seq=<%= row.get("seq") %>','popup<%= row.get("seq") %>','width=<%= row.get("width") %>, height='+popHeight+', top=<%= row.get("top") %>, left=<%= row.get("left") %>, scrollbars=no')	
		}
<%
		} else {
%>
		//레이어팝업
		if (getCookie("layerPop<%= row.get("seq") %>") != "done" ){
			var popHeight = <%= row.get("height") %> + 25;
			layerPopOpen('layerPop<%= row.get("seq") %>', '<%= row.get("top") %>', '<%= row.get("left") %>', '<%= row.get("width") %>', popHeight);
		}
<%
		}
	}
%>
	});

	//레이어팝업
	function layerPopOpen(obj, top, left, width, height){
		$('.'+obj).css({top:top+'px', left:left+'px', width:width+'px', height:height+'px'}).show();
	}
	
	function closePopLayer(obj){
		setCookie( obj, "done" , 1);
		$('.'+obj).css("display", "none");
	}
	
	function layerPopClose(obj){
		$('.'+obj).hide();
	}
</script> 
</head>  
<body class="main">
<%
	for(Param row : popupList) {
		if("2".equals(row.get("pop_type"))) {
%>
<div class="mainPop layerPop<%= row.get("seq") %>">
	<div>
		<%= row.get("contents") %>
	</div>
	<p class="popFoot">
		<a href="#" onclick="layerPopClose('layerPop<%= row.get("seq") %>');return false;" class="fl">닫기</a>
		<a href="#" onclick="closePopLayer('layerPop<%= row.get("seq") %>');return false;" class="fr">오늘하루 열지않기</a>
	</p>
</div>
<%
		}
	}
%>
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<!-- 브랜드 뉴 메인 비주얼 롤링 -->
		<jsp:include page="/brand/include/banner.jsp" flush="true">
		    <jsp:param name="position" value="030"/>
		    <jsp:param name="POS_END" value="9999"/>
		</jsp:include>
		<div class="srmyInfo"><div class="wrap">
			<ul class="info">
				<li class="time">
					<p class="tit">농원이용시간</p>
					<p class="cont">
						9:30~21:00(연중무휴)<br />
						17시 이후 무료입장<br />
						18시 이후 운영시설<br />
						: 파머스빌리지, 농원식당, 상하키친
					</p>
					<a class="btnTypeE" href="http://www.sanghafarm.co.kr/brand/introduce/guide.jsp">상세보기</a>
				</li>
				<li class="kitchen">
					<p class="tit">상하키친</p>
					<p class="cont">햄 공방에서 만들어진 햄과 소시지에<br>셰프의 솜씨를 더해 피자, 파스타, 샐러드의<br>맛있는 요리로 선보이는 레스토랑</p>
					<a class="btnTypeA" href="http://www.sanghafarm.co.kr/brand/food/store1.jsp">상세보기</a>
				</li>
				<li class="tour">
					<p class="tit">주변관광</p>
					<p class="cont">계절의 정취가 느껴지는 선운산에서부터<br>1,200ha 광활한 갯벌이 펼쳐진 하전마을,<br>사계절 축제가 있는 청보리밭까지</p>
					<a class="btnTypeE" href="http://www.sanghafarm.co.kr/brand/introduce/tour.jsp">상세보기</a>
				</li>
			</ul>
			<ul class="bann">
				<jsp:include page="/brand/include/banner.jsp" flush="true">
				    <jsp:param name="position" value="031"/>
				    <jsp:param name="POS_END" value="1"/>
				</jsp:include>
				<jsp:include page="/brand/include/banner.jsp" flush="true">
				    <jsp:param name="position" value="032"/>
				    <jsp:param name="POS_END" value="1"/>
				</jsp:include>
				<jsp:include page="/brand/include/banner.jsp" flush="true">
				    <jsp:param name="position" value="033"/>
				    <jsp:param name="POS_END" value="1"/>
				</jsp:include>
				<jsp:include page="/brand/include/banner.jsp" flush="true">
				    <jsp:param name="position" value="034"/>
				    <jsp:param name="POS_END" value="1"/>
				</jsp:include>
			</ul>
			
		</div></div><!-- //srmyInfo -->
		
		<div class="quickReser"><div class="wrap">
			<div class="field">
				<h2>체험 프로그램 예약</h2>
				<div class="selectBox">
					<p class="tit"><a href="#" onclick="showSelect(this); return false" id="reserve_date_txt">체험날짜 선택</a></p>
					<ul>
<%
	Calendar cal = Calendar.getInstance();
	String reserveDate = "";
	String reserveDateTxt = "";
	for(int i = 0; i < 20; i++) {
		if(i < 7 && cal.get(Calendar.DAY_OF_WEEK) == 7) {
			reserveDate = Utils.getTimeStampString(cal.getTime(), "yyyy.MM.dd");
			reserveDateTxt = (new SimpleDateFormat("yyyy년 MM월 dd일 (E)", java.util.Locale.KOREA)).format(cal.getTime()); 
		}
%>
						<li><a href="#none" alt="<%= Utils.getTimeStampString(cal.getTime(), "yyyy.MM.dd") %>" onclick="selectReserveDate(this)"><%= (new SimpleDateFormat("yyyy년 MM월 dd일 (E)", java.util.Locale.KOREA)).format(cal.getTime()) %></a></li>
<%		
		cal.add(Calendar.DATE, 1);
	}
%>
					</ul>
				</div>
				<div class="selectBox">
					<p class="tit"><a href="#" onclick="showSelect(this); return false" id="exp_type_txt">체험프로그램 선택</a></p>
					<ul id="exp_type_list">
					</ul>
				</div>
				<input type="hidden" name="reserve_date" id="reserve_date" value="<%= reserveDate %>" />
				<input type="hidden" name="exp_type" id="exp_type" />
				<a href="javascript:goReserve()" class="btnTypeB">예약하기</a>
			</div>
			<jsp:include page="/brand/include/banner.jsp" flush="true">
			    <jsp:param name="position" value="035"/>
			    <jsp:param name="POS_END" value="9999"/>
			</jsp:include>
			
		</div></div><!-- //quickReser -->
		
		<div class="srmyChef"><div class="wrap">
			<h2><img src="/images/brand/main/tit_chef.png" alt="상하농원 공방장을 소개합니다"></h2>
			<ul>
				<li>
					<p class="thumb"><img src="/images/brand/main/thumb_chef1.jpg" alt="이태리 공방장"></p>
					<p class="tit"><img src="/images/brand/main/ico_main2.gif" alt="">햄공방</p>
					<p class="txt">건강한 재료로 만든 햄은 그 어떤<br>보양식보다도 훌륭한 건강식품이라고<br>자신있게 소개할 수 있습니다.</p>
				</li>
				<li>
					<p class="thumb"><img src="/images/brand/main/thumb_chef2.jpg" alt="조용준 공방장"></p>
					<p class="tit"><img src="/images/brand/main/ico_main3.gif" alt="">과일공방</p>
					<p class="txt">잼,청, 말린 과일을 만드는 과일공방입니다.<br>깐깐한 선별기준으로 최상급의<br>과일만을 사용해 상품을 만듭니다.</p>
				</li>
				<li>
					<p class="thumb"><img src="/images/brand/main/thumb_chef3_1.jpg" alt="장시영 공방장"></p>
					<p class="tit"><img src="/images/brand/main/ico_main4.gif" alt="">빵공방</p>
					<p class="txt">언제나 고소한 빵 굽는 냄새가 진동하는<br>소박하지만 넉넉한 엄마의 마음으로<br>전하고 싶습니다.</p>
				</li>
				<li>
					<p class="thumb"><img src="/images/brand/main/thumb_chef4.jpg" alt="김병천 공방장"></p>
					<p class="tit"><img src="/images/brand/main/ico_main5.gif" alt="">발효공방</p>
					<p class="txt">지붕 위에 옹기종기 모여있는 장독들을<br>보고 있노라면 세상을 다 가진것 같은<br>기분이 들어요. </p>
				</li>
			</ul>
		</div></div><!-- //srmyChef -->
		
		<div class="srmyKitchen"><div class="wrap">
			<h2><img src="/images/brand/main/logo_kitchen2.png" alt=""></h2>
			<p class="text"><span>내 손으로 조물조물!</span><br>직접 만들어 더욱 맛있게! 더욱 즐겁게!</p>
			<jsp:include page="/brand/include/banner.jsp" flush="true">
			    <jsp:param name="position" value="036"/>
			    <jsp:param name="POS_END" value="3"/>
			</jsp:include>
		</div></div><!-- //srmyKitchen -->
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
<script>
	$(".mainVisual .list").cycle({
		fx: "fade",
		speed: 800,
		timeout: 5000,
		slideExpr : "li",
		pause : 1,
		fit:1,
		width: "100%",
		prev : $(".mainVisual .prev"),
		next : $(".mainVisual .next"),
		pager : $(".mainVisual .nav"),
		activePagerClass: 'on',
		pagerAnchorBuilder: function(idx) {
			idx = idx+1;
	        return '<li><a href="#visual'+idx+'">'+ idx +'</a></li>'; 
	    }
	});
	
	//체험프로그램예약
	setCycle(".quickReser", "scrollHorz", "", 500, 5000, "", "");
	
	function showSelect(obj){
		var $target = $(obj).parents(".selectBox");
		$target.siblings().find("ul").slideUp(50);
		$target.find("ul").slideToggle(100);
		/*
		$target.find("li a").on("click", function(){
			alert($(this).attr("alt"));
			$target.find(".tit a").text($(this).text());
			$target.find("ul").slideUp(50);
			return false;
		});
		*/
	}
	
	$(document).on("click focusin", function(e) {
		if($(".selectBox ul").is(":visible")){
			if(!($(e.target).parents(".selectBox").length)){
				$(".selectBox ul").slideUp(50);
			}
		}
	});
	
	function selectReserveDate(obj) {
		$("#reserve_date").val($(obj).attr("alt"));
		
		var $target = $(obj).parents(".selectBox");
		$("#reserve_date_txt").text($(obj).text());
		$target.find("ul").slideUp(50);

		getExpList();

		return false;
	}
	
	function selectExpType(obj) {
		$("#exp_type").val($(obj).attr("alt"));
		
		var $target = $(obj).parents(".selectBox");
		$("#exp_type_txt").text($(obj).text());
		$target.find("ul").slideUp(50);
		return false;
	}
	
	function getExpList() {
		$("#exp_type_txt").text("체험프로그램 선택");
		$.ajax({
			method : "POST",
			url : "/ajax/expList1.jsp",
			data : { date : $("#reserve_date").val() },
			dataType : "html"
		})
		.done(function(html) {
			$("#exp_type_list").empty().html($.trim(html));
		});
	}

	function goReserve() {
		if($("#reserve_date").val() == '') {
			alert("체험날짜를 선택하세요.");
		} else if($("#exp_type").val() == '') {
			alert("체험프로그램을 선택하세요.");
		} else {
			document.location.href="/brand/play/reservation/experience.jsp?reserve_date=" + $("#reserve_date").val() + "&exp_type=" + $("#exp_type").val();
		}
	}
	
	$(function() {
		$("#reserve_date_txt").text("<%= reserveDateTxt %>");
		getExpList();
	});


</script>
</body>
</html>
