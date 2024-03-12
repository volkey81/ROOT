<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.service.board.*" %>
<%
	request.setAttribute("Depth_1", new Integer(2));
	request.setAttribute("Depth_2", new Integer(4));
	request.setAttribute("Depth_3", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("파머스빌리지"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);

	PopupService popup = new PopupService();
	List<Param> popupList = popup.getList(new Param("device", "M", "position", "C"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp"/> 
<script>
	$(function (){
		var vSwiper = new Swiper($(".roomInfo"), {
			slidesPerView: 1,
			prevButton: $(".room .prev"),
			nextButton: $(".room .next"),
			loop: true,
			pagination: $(".room .swiperNav"),
			paginationElement: 'li',
			paginationClickable: true
		});
				
		headerTouchFn('.hotel .header');
		$('.hotel #header').append('<div class="closeBtn"><img src="/mobile/images/btn/btn_close2.png" alt="파머스빌리지 닫기"></div>');
		$('.hotel #header .closeBtn').on('click', function(){
<%
		if("web".equals(param.get("target"))){
%>
			location.href = "sanghafarm://";
<%
		}else {
%>
			self.close();
<%
		}
%>
		});

<%
	for(Param row : popupList) {
		if("2".equals(row.get("pop_type"))) {
%>
		//레이어팝업
		if (getCookie("layerPop<%= row.get("seq") %>") != "done" ){
			layerPopOpen('layerPop<%= row.get("seq") %>');
		}
<%
		}
	}
%>
	});
	
	var eventManager = {
			event: {
				isTouchDevice: 'ontouchstart' in window || window.DocumentTouch && document instanceof DocumentTouch,
				selectEvent: function(eventType) {
					var selectedEvent;
					switch (eventType) {
						case 'eventDown':
							selectedEvent = this.isTouchDevice ? 'touchstart' : 'mousedown';
							break;
						case 'eventMove':
							selectedEvent = this.isTouchDevice ? 'touchmove' : 'mousemove';
							break;
						case 'eventUp':
							selectedEvent = this.isTouchDevice ? 'touchend' : 'mouseup';
							break;
						case 'eventOut':
							selectedEvent = this.isTouchDevice ? 'touchleave' : 'mouseout';
							break;
					}
					return selectedEvent;
				}
			}
		};

		function selectEvent(eventType, e) {
			var eventMaster;

			if (eventType === 'eventDown') {
				switch (eventManager.event.selectEvent('eventDown')) {
					case "mousedown":
						eventMaster = e;
						break;
					case "touchstart":
						e.preventDefault();
						eventMaster = e.touches.item(0);
						break;
				}
			} else if (eventType === 'eventMove') {
				switch (eventManager.event.selectEvent('eventMove')) {
					case "mousemove":
						eventMaster = e;
						break;
					case "touchmove":
						eventMaster = e.touches.item(0);
						break;
				}
			} else if (eventType === 'eventUp') {
				switch (eventManager.event.selectEvent('eventUp')) {
					case "mouseup":
						eventMaster = e;
						break;
					case "touchend":
						eventMaster = e.changedTouches[0];
						break;
				}
			} else if (eventType === 'eventOut') {
				switch (GameManager.event.selectEvent('eventOut')) {
					case "mouseout":
						eventMaster = e;
						break;
					case "touchleave":
						eventMaster = e.touches.item(0);
						break;
				}
			}
			return eventMaster;
		}
		function headerTouchFn(efobj){
			var clickArea = document.querySelector(efobj), startX, startY, endX, endY, onDrag = 0, setId;		
			
			var init = function(e){
				$(".headerTxtWrap").addClass("top");	
				$(".headerTxtWrap").removeClass("bot");
			},
			startDrag = function(e){
				var eventMaster = selectEvent('eventDown', e);
				startX = positionCalc(eventMaster).x;
				startY = positionCalc(eventMaster).y;	
				$("body, html").bind('touchmove', function(e){e.returnValue = false;});
				clickArea.addEventListener(eventManager.event.selectEvent('eventMove'), drag, true); 
			},
			drag = function(e){
				e.preventDefault();
				e.stopPropagation();
				
				var eventMaster = selectEvent('eventMove', e);
				
				endX = positionCalc(eventMaster).x;
				endY = positionCalc(eventMaster).y;			
			},
			endDrag = function(e){
				e.preventDefault();
				e.stopPropagation();
				
				var eventMaster = selectEvent('eventUp', e);
				if(startY-endY > this.offsetHeight*0.1) {
					onDrag++;
					if(onDrag < 2) up();
					else if(onDrag >= 2) {
						clickArea.style.pointerEvents='none';
						$('.hotel#wrapper').stop().animate({
		        			scrollTop : $('.hotel .header').height()
		        		},{
		        			duration: 500, complete: function(){
		        				clickArea.style.pointerEvents='auto'; 
		        				onDrag=1;
		        			}
		        		});						
					}
				} else if(endY-startY > 0) {
					down(); 
					onDrag = 0;
				}					
				clickArea.removeEventListener(eventManager.event.selectEvent('eventMove'), drag, true); 
			},
			up = function(){	
				$(".headerTxtWrap").addClass("top");	
				$(".headerTxtWrap").removeClass("bot");
			},
			down = function(){
			 $('.hotel#wrapper').stop().animate({scrollTop :0},{
    			duration: 500, complete: function(){
    				clickArea.style.pointerEvents='auto'; 
    				onDrag=0;
    			}
    		});
				$(".headerTxtWrap").removeClass("top");	
				$(".headerTxtWrap").addClass("bot");
			},
			positionCalc = function(e){
				var x = e.pageX;
				var y = e.pageY;			
				return {x:x,y:y};
			},
			endEffect = function(){
				var setIdx = 0;
				onDrag = 1;
				setId = setInterval(function(){
					if(setIdx >= $('.hotel .header').height()) {
						clearInterval(setId);
						$(window).scrollTop($('.hotel .header').height());
					}else{
						setIdx = setIdx + 5;
						window.scroll($(window).scrollTop()-48, setIdx);
					}
				}); 
			}
			clickArea.addEventListener(eventManager.event.selectEvent('eventDown'), startDrag, false);
			clickArea.addEventListener(eventManager.event.selectEvent('eventUp'), endDrag, false);  
		}
	function popOpen(id){
		var obj = $("#" + id),		
			  popClose = obj.find('.close');
		obj.addClass('on');
		$('#wrapper').addClass('not_scroll');
		
		popClose.on('click', function(){
			obj.removeClass('on');
			$('#wrapper').removeClass('not_scroll');
		});	
	}
	function eventPrevent(e){
		e.preventDefault();
		e.stopPropagation();
	}

	
	//레이어팝업
	function layerPopOpen(obj){
		$('.'+obj).add(".bgLayer").show();
		$('html, body').css("overflow", "hidden");
	}
	function closePopLayer(obj){
		setCookie( obj, "done" , 1);
		layerPopClose(obj);
		$('html, body').css("overflow", "visible");
	}
	function layerPopClose(obj){
		$('.'+obj).add(".bgLayer").hide();
		$('html, body').css("overflow", "visible");
	}
</script>
</head>  
<body>
<%
	for(Param row : popupList) {
		if("2".equals(row.get("pop_type"))) {
%>
<div class="mainPop <%= "Y".equals(row.get("mfull_yn")) ? "full" : "" %> layerPop<%= row.get("seq") %>">
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
<div id="wrapper" class="hotel">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<div class="header">
			<img src="../images/hotel/headerImg.jpg" style="opacity:0;">
			<div id="headerTxtWrap" class="headerTxtWrap">
				<div id="headerTxt1" class="headerTxt"><img src="../images/hotel/header_text1.png"></div>
				<div id="headerTxt2" class="headerTxt"><img src="../images/hotel/header_text2.png"></div>			
			</div>
		</div> 
		<div class="adArea zIndexUp">
			<img src="../images/hotel/adImg.jpg">
		</div><!-- //header -->
		<div class="room zIndexUp">
			<img src="../images/hotel/cont_room_top.jpg">
			<div class="roomInfo">
				<ul class="swiper-wrapper">
					<li class="swiper-slide">
						<img src="../images/hotel/cont_room1.jpg">
					</li>
					<li class="swiper-slide">
						<img src="../images/hotel/cont_room2.jpg">
					</li>
					<li class="swiper-slide">
						<img src="../images/hotel/cont_room3.jpg">
					</li>
					<li class="swiper-slide">
						<img src="../images/hotel/cont_room4.jpg">
					</li>
					<li class="swiper-slide">
						<img src="../images/hotel/cont_room5.jpg">
					</li>
					<li class="swiper-slide">
						<img src="../images/hotel/cont_room6.jpg">
					</li>
				</ul>	
				<ul class="swiperNav"></ul>
				<div class="prev"><img src="/mobile/images/main/btn_prev.png" alt="이전"></div>
				<div class="next"><img src="/mobile/images/main/btn_next.png" alt="다음"></div>	
			</div>
			<img src="../images/hotel/cont_room_bottom.jpg">
			<div class="priceGuideBtn" onclick="popOpen('priceGuide')"></div>						
		</div>
		
		<div class="specialEvent zIndexUp">
			<img src="../images/hotel/cont_event.jpg">
		</div>	
		<div class="facilities zIndexUp">
			<img src="../images/hotel/cont_facilities.jpg">
		</div>	
	<!-- //내용영역 -->
	</div><!-- //container -->
		<div id="footer" class="zIndexUp">
		<ul class="nav">
			<li><a href="/mobile/customer/privacy.jsp"><strong>개인정보취급방침</strong></a></li>
			<li><a href="/mobile/customer/agree.jsp">이용약관</a></li>
			<li><a href="/mobile/customer/faq.jsp">고객센터</a></li>
		</ul>
		<div class="contact">
			<address>전라북도 고창군 상하면 상하농원길 11-23</address>
			<p>사업자등록번호 : 415-86-00211</p>
			<p>대표자명 : 박재범, 권태훈</p>
		</div>
		<p class="copy">COPYRIGHT 2017 SANGHA FARM CO. ALL RIGHTS RESERVED</p>
		<p class="top"><a href="#" onclick="goTop(); return false"><img src="/mobile/images/layout/btn_top.gif" alt="TOP"></a></p>
	</div><!-- //footer -->
	<div class="popup" id="priceGuide">
		<div class="popCont">
			<div class="close"></div>
			<img src="../images/hotel/priceGuide.png" />
		</div>
	</div>
</div><!-- //wrapper -->
</body>
</html>