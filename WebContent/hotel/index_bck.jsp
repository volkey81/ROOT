<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.service.board.*"%>
<%
	request.setAttribute("Depth_1", new Integer(6));
	request.setAttribute("Depth_2", new Integer(0));
	request.setAttribute("Depth_3", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("호텔"));

	Param param = new Param(request);
	PopupService popup = new PopupService();
	List<Param> popupList = popup.getList(new Param("device", "P", "position", "C"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" /> 
<script type="text/javascript">
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

	document.addEventListener('DOMContentLoaded', function(){
		fadeEffect($("#headerTxt1"), 1, -20, 500, 'first');	
		headerFadeFn();
		
		$('p.top').on('click', function(){
			fadeEffect($('#headerTxt1'), 1, -20, 500);
         	fadeEffect($('#headerTxt2'), 0, -20, 500, 'first');
         	scrNum = 0;
		});
	});
	
	$.fn.scrollEvent = function(opt){
	    var defaultOpt = {
	        id : null,
	        func : null,
	        reset : true
	    };
	    $.extend(defaultOpt, opt);

	    var elem = defaultOpt.id;
	    
	    if(!defaultOpt.reset){
	    	 if (elem.addEventListener) {    // all browsers except IE before version 9
	 	        // Internet Explorer, Opera, Google Chrome and Safari
	 	        elem.addEventListener ("mousewheel", MouseWheelHandler, false);
	 	        // Firefox
	 	        elem.addEventListener ("DOMMouseScroll", MouseWheelHandler, false);
	 	    }else{
	 	        if (elem.attachEvent) { // IE before version 9
	 	            elem.attachEvent ("onmousewheel", MouseWheelHandler);
	 	        }
	 	    }  
	    }else{
	    	 if (elem.removeEventListener) {    // all browsers except IE before version 9
		 	        // Internet Explorer, Opera, Google Chrome and Safari
		 	        elem.removeEventListener ("mousewheel", MouseWheelHandler, false);
		 	        // Firefox
		 	        elem.removeEventListener ("DOMMouseScroll", MouseWheelHandler, false);
		 	    }else{
		 	        if (elem.detachEvent) { // IE before version 9
		 	            elem.detachEvent ("onmousewheel", MouseWheelHandler);
		 	        }
		 	    }  
	    }
	   
	    function MouseWheelHandler() {
	        var nDelta = 0;
	        if (!event) { event = window.event; }
	        // cross-bowser handling of eventdata to boil-down delta (+1 or -1)
	        if ( event.wheelDelta ) { // IE and Opera
	            nDelta= event.wheelDelta;
	            if ( window.opera ) {  // Opera has the values reversed
	                nDelta= -nDelta;
	            }
	        }
	        else if (event.detail) { // Mozilla FireFox
	            nDelta= -event.detail;
	        }
	        if (nDelta > 0) {
	        	defaultOpt.func('up', nDelta, $(this));
	        }
	        if (nDelta < 0) {
	        	defaultOpt.func('down', nDelta, $(this));
	        }
	        if ( event.preventDefault ) {  // Mozilla FireFox
	           // event.preventDefault();
	        }
	        //event.returnValue = false;  // cancel default action
	   }
	}
	var scrNum = 0;
	function headerFadeFn(){
		$('#headerTxtWrap').scrollEvent({
			id : document.querySelector('#headerTxtWrap'),
			func : wheelE,
			reset : false
		});
	}
	function wheelE(txt, delta){
	   if(scrNum < 1){
		   if ( event.preventDefault ) {  // Mozilla FireFox
	           event.preventDefault();
	        }
	        event.returnValue = false;  // cancel default action
	   }
        if(txt == 'down'){
        	scrNum ++;
        	if(scrNum == 1){
        		fadeEffect($('#headerTxt1'), 0, 20, 500);
            	fadeEffect($('#headerTxt2'), 1, 20, 500, 'end');
        	}        	
        }else{
        	scrNum = 0;
        	if(scrNum == 0){
        		fadeEffect($('#headerTxt1'), 1, -20, 500);
            	fadeEffect($('#headerTxt2'), 0, -20, 500, 'first');
            	
            	$('html').stop().animate({
        			scrollTop : 0
        		},{
        			duration: 500, complete: function(){
        				/* $('.rollOver').each(function(index){
        					$(this).scrollEvent({
        						id : this,
        						func : wheelFn,
        						reset : true
        					});
        				}); */
        		}});
        	}
        }
	}
	function wheelFn(txt, delta, who){		 
        delta = delta/120;
        var moveTop = null;
        if (delta < 0 && scrNum > 1) {
            if (who.next().offset() != undefined) {
               moveTop = who.next().offset().top;
            }
            if(!who.hasClass('final')) effect();
        } else if(delta > 0 && scrNum >= 1) {
            if (who.prev().offset() != undefined) {
               moveTop = who.prev().offset().top;
            }
            if(who.prev().hasClass('first')) moveTop = moveTop - $('#header').height();
            effect();
        }
        function effect(){
        	 $("html,body").stop().animate({
                 scrollTop: moveTop + 'px'
             }, {
                 duration: 800, complete: function () {
                 }
             });
        }
	} 
	function fadeEffect(obj, opa, mt, dur, divide){
		obj.stop().animate({
			opacity : opa,
			marginTop: mt
		},{duration: dur, complete: function(){
			/* if(divide == 'end'){
				$('.rollOver').each(function(index){
					$(this).scrollEvent({
						id : this,
						func : wheelFn,
						reset : false
					});
				});
			} */
		}});	
	}
	function popOpen(id){
		var obj = $("#" + id),		
			  popClose = obj.find('.close');
		
		obj.addClass('on');
		obj.find('.popCont').css({marginTop:-(obj.find('.popCont').height()/2)});
		$(window).on('mousewheel scroll', function(e) {
	        e.preventDefault();
	        e.stopPropagation();
	        return false;
	    });
		obj.on('click', function(e) {
			if($(e.target).parents(".popCont").size() == 0) {
				obj.removeClass('on');
				$(window).off('mousewheel scroll');
				obj.off('click');
			}
	    });	
		popClose.on('click', function(){
			obj.removeClass('on');
			$(window).off('mousewheel scroll')
		});	
	}

	
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
<body>
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
<div id="wrapper" class="hotel">
	<jsp:include page="/include/header.jsp" /> 	
	<div id="container">
		<div class="header">
			<img src="../images/hotel/headerImg.jpg" >
			
			<div id="headerTxtWrap" class="headerTxtWrap">
				<div id="headerTxt1" class="headerTxt"><img src="../images/hotel/header_text1.png"></div>
				<div id="headerTxt2" class="headerTxt"><img src="../images/hotel/header_text2.png"></div>			
			</div>
		</div>
		<div class="adArea">
		
			<img src="../images/hotel/adText.png">
		</div><!-- //header -->
		<div class="contArea">
			<div class="room">
				<img src="../images/hotel/cont_room.jpg">
				<a class="priceGuideBtn" onclick="popOpen('priceGuide')"></a>
			</div>
			<div class="specialEvent">
				<img src="../images/hotel/cont_event.jpg">
			</div>	
			<div class="facilities">
				<img src="../images/hotel/cont_facilities.jpg">
			</div>	
		</div><!-- //contArea -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
	<div class="popup" id="priceGuide">
		<div class="popCont">
			<div class="close"></div>
			<img src="../images/hotel/priceGuide.png">
		</div>
	</div>
</div><!-- //wrapper -->
</body>
</html>
