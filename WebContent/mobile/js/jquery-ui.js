$(function(){
	$("#wrapper").append("<div class='bgLayer'></div>");
	
	//gnb의 하위메뉴 유무에 따른 아이콘과 a링크 처리
	$("#gnb li").each(function(){
		if($(this).find("li").size() == 0){
			$(this).find(">p .icoFold").hide();
			$(this).find(">p a").removeAttr("onclick");
		} else {
			$(this).find(">p .icoFold").show();
			$(this).find(">p a").attr("onclick", "return false");
			$(this).find(">p").on("click", function(){
				showSubNav($(this));
			});
		}
	});
	
	//쇼핑 gnb 하위카테고리 border처리를 위한
	$("#gnb >li .shopping").each(function(){
		var lastNum = parseInt($(this).find("li").size() / 3) * 3;
		$(this).find("li:eq("+lastNum+"), li:gt("+lastNum+")").css("border-bottom","none");
	});
	
	//빈영역클릭시 카테고리영역 닫기
	$(".bgLayer").on("click", function(e){
		if($("#category").hasClass("on")){
			if(!($(e.target).parents("#category").length)){
				hideCate();
			}
		}
	});
	
	//header menu 버튼
	$("#header .logo .meunBtn").click(function(){
		if(!$(this).parent().hasClass("on")) {
			$(this).parent().addClass("on");
			$(this).parent().next(".topMenu").slideDown();
		} else {
			$(this).parent().removeClass("on");
			$(this).parent().next(".topMenu").slideUp();
		}
		return false;
	});

//파머스빌리지 서브페이지 슬라이드
	var allLength = $(".slideArea .slide").length;
	$('.slideNum .allNum').html("0"+allLength);
	$('.slideWrap .slideArea').on('afterChange', function(event, slick, currentSlide){   
		$('.slideNum .nowNum').html("0"+ (currentSlide + 1));
	});
	
	//terrace room
	if($('.slideWrap .slideArea').size() > 0){
		$('.slideWrap .slideArea').slick({
			slidesToShow: 1,
			slidesToScroll: 1,
			autoplay: false,
			dots: false,
			fade: false,
			arrows: true		
		});
	}
	if($('.slideAreaNav').size() > 0){
		$('.slideAreaNav').slick({
			slidesToShow: 1,
			slidesToScroll: 1,
			asNavFor: '.slideWrap .slideArea',
			dots: false,
			centerMode: false
		});
	}
	
	//하단 버튼
	$(document).on({
		touchstart: function() {
			bottomFix();
		},
		touchmove: function() {
			bottomFix();
		},
		scroll: function() {
			bottomFix();
		},
		touchend: function() {
			bottomFix();
		}
	});
	
	function bottomFix(){
		var scrollTop = $(this).scrollTop();
		var windowH = $(window).height();
		var wrappeH = $("#wrapper").height();
		var footerH = $("#footer").height();
		var bottomH = $(".btnArea").height() ;
		var contH = wrappeH - windowH - footerH - bottomH;
		
		if(scrollTop >= contH) {
			$(".btnArea").addClass("on")

		}else  {
			$(".btnArea").removeClass("on")
		}
	}
	
});

$(document)
.on("click focusin", function(e) {
	
});


// topSrch
function showSrch(){
	$("#topSrch").addClass("on");
	$(".bgLayer").height($(document).height()).show();
	$("#wrapper").css("position", "fixed");
}
function hideSrch(){
	$("#topSrch").removeClass("on");
	$(".bgLayer").fadeOut()
}

//category
var posY;
var cateScroll;
function showCate(){
	$(".bgLayer").height($(document).height()).show();
	$("#category").addClass("on");
	cateScroll = new IScroll("#category .iscrollArea", {
		mouseWheel: true,
		click: true,
		scrollbars: true
	});
	cateScroll.on("beforeScrollStart", function(e){
		$("#category .iscrollArea").on("touchmove", function(e){
			e.preventDefault(); 
		});
	});
	cateScroll.on("scrollEnd", function(){
		posY = this.y;
		$("#category .iscrollArea").off("touchmove");
	});
}
function hideCate(){
	$("#category").removeClass("on");
	setTimeout('$(".bgLayer").hide()', 150);
	cateScroll.destroy();
	
}

function showSubNav(obj){
	var $target = $(obj);
	$target.parent().siblings(":not(.brandNav)").find("ul").slideUp(150);
	$target.parent().siblings(":not(.brandNav)").find(".icoFold").removeClass("on");
	$target.next("ul").slideToggle(150, function(){
		cateScroll.refresh();
	});
	$target.find(".icoFold").toggleClass("on");
}

//swiper.js 셋팅
function setSwiper(obj){
	var $target = $(obj);
	var defaultWidth = $target.find(".swiper-wrapper").width();
	$target.find(".swiper-wrapper").each(function(){
		var maxWidth = 0;
		$(this).find("li").each(function(){
			var paddingL = Math.ceil(parseInt($(this).css("padding-left"))) ? Math.ceil(parseInt($(this).css("padding-left"))) : 0;
			var paddingR = Math.ceil(parseInt($(this).css("padding-right"))) ? Math.ceil(parseInt($(this).css("padding-right"))) : 0;
			maxWidth = maxWidth + Math.ceil($(this).width()) + paddingL + paddingR + 1;
		});
		if(maxWidth < $(window).width()){
			$(this).width(maxWidth);
			$(this).addClass("noSwiper");
		} else {
			$(this).width();
			$(this).removeClass("noSwiper");				
		}
	});
}

//sns
function showSns(){
	$(".bgLayer").height($(document).height()).show();
	$(".snsLayer").show();
	$(window).on("touchmove", function(e){ //본문스크롤불가
		e.preventDefault();	
	});
} 
function hideSns(){
	$(".bgLayer, .snsLayer").hide();
	$(window).off("touchmove");
} 

//리스트 행간 높이 통일
function setListHeight(target, num){
	var $target = $(target);
	var lineNum = 0;
	if(!num){
		num = $target.find("li:not(.none)").size();
	}

	$target.find("li .wrap").removeAttr("style");

	$target.find("li:not(.none)").each(function(){
		lineNum = parseInt($(this).index() / num);
		$(this).addClass("line" + lineNum);
	});

	if($target.find("img").length > 0){
		$('#container').imagesLoaded()
		  .always( function( instance ) {
			  for(var idx = 0; idx < lineNum+1; idx++){
					var wHeight = 0;
					$target.find("li.line" + idx + " .wrap").each(function(){
						if(wHeight < $(this).height()){
							wHeight = $(this).height();
						}
					});
					$target.find("li.line" + idx + " .wrap").height(wHeight);
				}
		  });
	} else {
		 for(var idx = 0; idx < lineNum+1; idx++){
			var wHeight = 0;
			$target.find("li.line" + idx + " .wrap").each(function(){
				if(wHeight < $(this).height()){
					wHeight = $(this).height();
				}
			});
			$target.find("li.line" + idx + " .wrap").height(wHeight);
		}
	}
}

function showTblDetail(obj){
	var $target = $(obj).parents().next(".tblDetail");
	$target.find("tbody").toggle();
	$(obj).toggleClass("on");
}

function goTop(){
	$("html, body").stop().animate({scrollTop:0}, 200, "easeInOutQuint");
}

function loadingAdd(obj) {
	if(obj == "full"){
		$("body").prepend("<div id=\"loadingArea\" class=\"fullLoad\" style=\"z-index:100010\"><img src=\"/image/common/loading.gif\" alt=\"로딩중...\"></div>");
	} else {
		if($(obj).css("position") != "relative" && $(obj).css("position") != "absolute"){
			$(obj).css("position", "relative");
		}
		$(obj).prepend("<div id=\"loadingArea\"><img src=\"/image/common/loading.gif\" alt=\"로딩중...\"></div>");
	}
} 

function loadingRemove(obj) {
	if(obj != undefined) {
		$(obj).find("#loadingArea").remove();
	} else {
		$("#loadingArea").remove();
	}
} 

function hidePopupLayer(layerId, reset){
	top._hidePopupLayer(layerId, reset);
}
 
function _hidePopupLayer(layerId, reset) {
	if(layerId){
		$("#popLayer" + layerId).empty().remove();
		_popupLayerID = _popupLayerID - 2;	
		if(reset){
			_popupLayerID = _popupLayerID + 2;
			POPUP_INIT_ID = _popupLayerID - 2;
		}	
	} else {
		if(_popupLayerID != POPUP_INIT_ID + 2){
			$("#popLayer" + _popupLayerID).empty().remove();
			_popupLayerID = _popupLayerID - 2;
		} else {
			$("#popLayer" + _popupLayerID).empty().remove();	
			_popupLayerID = _popupLayerID - 2;
			$(".bgLayer").hide();
		}
	}
	//top.$(window).off("touchmove");
	$("html, body").removeClass("oh");	
	$("html, body").scrollTop(hiddenScrollPoint);
}
//공통 레이어팝업
function showPopupLayer(popSrc, pos){
	top._showPopupLayer(popSrc, pos);
	//$('html, body').css("overflow", "hidden");
}

function outUrlShowPopupLayer(popSrc, popWidth, popHeight){
	top._outUrlShowPopupLayer(popSrc, popWidth, popHeight); 
}

var POPUP_INIT_ID = 111;
var _popupLayerID = POPUP_INIT_ID;
var hiddenScrollPoint = 0;
function _showPopupLayer(popSrc, pos) {
	_popupLayerID += 2;
	var popTop = $(window).height() / 2 + $(document).scrollTop() + "px"
	var popSrcUrl = popSrc;
	if(popSrcUrl.indexOf("?") > 0){
		popSrcUrl += '&layerId='+ _popupLayerID
	}else {
		popSrcUrl += '?layerId='+ _popupLayerID
	}
	var position = "absolute";
	if(pos == "fix"){
		position = "fixed";
		popTop = "50%"; 
	}
	if($("#wrapper").length > 0){
		$("#wrapper").append(
			'<div class="popLayer" id="popLayer' + (_popupLayerID) + '" style="z-index:' + _popupLayerID + ';">' 
			+ ' <iframe src="' + popSrcUrl +'" width="100%" height="100%" frameborder="0" allowTransparency="true" scrolling="no" id="iframePopLayer' + (_popupLayerID) + '" name="iframePopLayer"></iframe>'
			+ ' <p class="close"><a href="#" onclick="hidePopupLayer(); return false"><img src="/mobile/images/btn/btn_close3.png" alt="닫기"></a></p>'
			+ '</div>'
		);
	} else {
		$("body").append(
			'<div class="popLayer" id="popLayer' + (_popupLayerID) + '" style="z-index:' + _popupLayerID + ';">' 
			+ ' <iframe src="' + popSrcUrl +'" width="100%" height="100%" frameborder="0" allowTransparency="true" scrolling="no" id="iframePopLayer' + (_popupLayerID) + '" name="iframePopLayer"></iframe>'
			+ ' <p class="close"><a href="#" onclick="hidePopupLayer(); return false"><img src="/mobile/images/btn/btn_close3.png" alt="닫기"></a></p>'
			+ '</div>'
		);
	}
	if(popSrcUrl.indexOf("login.jsp") > 0){
		$(".bgLayer").add("#popLayer" + _popupLayerID).css("z-index", "200");
	}
	if(!$(".bgLayer").length){
		$("body").append("<div class='bgLayer'></div>")
	}
	$(".bgLayer").css("height", $(document).height() + "px").show();
	hiddenScrollPoint = $(window).scrollTop();
	$("html, body").addClass("oh");
	$("#popLayer" + _popupLayerID).show();
	//top.$(window).on("touchmove", function(e){ //본문스크롤불가
		//e.preventDefault();	
	//});
}

function _outUrlShowPopupLayer(popSrc, popWidth, popHeight) {
	_popupLayerID += 2;
	var popTop = $(window).height() / 2 + $(document).scrollTop();
	var popWidth = $(window).width();
	var marginTop = -(popHeight / 2);
	var popSrcUrl = popSrc;
	if(popSrcUrl.indexOf("?") > 0){
		popSrcUrl += '&layerId='+ _popupLayerID
	}else {
		popSrcUrl += '?layerId='+ _popupLayerID
	}
	$("#wrapper").append(
		'<div class="popLayer" id="popLayer' + (_popupLayerID) + '" style="z-index:' + _popupLayerID + ';width:' + popWidth + 'px;height:' + popHeight+ 'px; opacity:1;">'
		+ ' <iframe src="' + popSrcUrl +'" width="'+ popWidth +'" height="'+ popHeight +'" frameborder="0" allowTransparency="true" scrolling="no" id="iframePopLayer' + (_popupLayerID) + '"></iframe>'
		+ '</div>'
	);
	$(".bgLayer").css("height", $(document).height() + "px").show();
	$("#popLayer" + _popupLayerID).show();
}

function setPopup(obj){
	if($("body").hasClass("hideClose")){
		parent.$("#popLayer" + obj + " .close").hide();
	}
	parent.$("#iframePopLayer" + obj).height($("#popWrap").height());
	parent.$("#popLayer" + obj).css("margin-top", "-" + $("#popWrap").height()/2 + "px");
	if($("#popWrap").height() >= $(window.parent).height()){ //팝업높이가 부모창 높이보다 길때
		$("#popCont").height($(window.parent).height()-90).css("overflow-y", "scroll");
		parent.$("#iframePopLayer" + obj).height($("#popWrap").height());
		var sPopTop = $(window.parent).scrollTop()
		if(parent.$(".bgLayer").css("position") == "fixed"){
			sPopTop = 0
		} 
		//parent.$("#popLayer" + obj).css("top", sPopTop + "px").css("margin-top", "10px");
		//parent.$("#popLayer" + obj).css("margin-top", "0");
		parent.$("#popLayer" + obj).css("margin-top", "-" + $("#popWrap").height()/2 + "px");
		if($(window.parent).scrollTop() + $("body").height() > parent.$(".bgLayer").height()){ //반투명 BG 높이가 모자를때
			parent.$(".bgLayer").height($(window.parent).scrollTop() + $("body").height() + 3);
		}
	}
	parent.$("#popLayer" + obj).css("opacity", "1");
}

//오늘 하루 레이어팝업
function setCookie( name, value, expiredays ) {
	var todayDate = new Date();
	todayDate.setDate( todayDate.getDate() + expiredays );
	document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
}
function getCookie(name)
{
	var nameOfCookie = name + "=";
	var x = 0;
	while (x <= document.cookie.length)
	{
		var y = (x+nameOfCookie.length);
		if (document.cookie.substring(x, y) == nameOfCookie) {
			if ((endOfCookie=document.cookie.indexOf( ";", y )) == -1) endOfCookie = document.cookie.length;
			return unescape(document.cookie.substring(y, endOfCookie ));
		}
		x = document.cookie.indexOf(" ", x) + 1;
		if (x == 0) break;
	}
	return "";
}

function showTab(obj, obj2){
	var target = $(obj).attr("href");
	$(target).show().siblings("."+ obj2).hide();
	$(obj).parent().addClass("on").siblings().removeClass("on");
}

function showTab2(obj, obj2){
	var target = $(obj).attr("href");
	$("."+obj2).not($(target)).slideUp(150);
	$(target).slideToggle(150);
	if($(obj).hasClass("icoMore")){
		$("."+obj2+" .icoMore").not($(obj)).removeClass("on");
		$(obj).toggleClass("on");
	}
}
function showTab3(obj, objClass, targetClass){
	var objIdx = $(objClass).index(obj),
		  target = $(targetClass).eq(objIdx);		
	$(targetClass).not($(target)).slideUp(150);
	$(target).slideToggle(150);	
	if($(obj).hasClass('on')){		
		$(obj).removeClass('on');
	}else{
		$(objClass).removeClass('on');
		$(obj).addClass('on');
	}
}
function checkAll(all, chks){
	var $chkAll = $(all);
	var $chkOther = $(chks);
	$chkAll.change(function(){
		var chkAllState = $(this).prop("checked");
		$chkOther.prop("checked", chkAllState).change(); 
		if(chkAllState){
			$chkOther.parent().addClass("on");
		} else {
			$chkOther.parent().removeClass("on");
		}
	});
	$chkOther.change(function(){
		var chkVal = true;
		var allCheckState = true;
		$chkOther.each(function(){
			if(!$(this).prop("checked")){
				chkVal = false;	
			}
		});
		$chkOther.not(this).each(function(){
			if(!$(this).prop("checked")){
				allCheckState = false;	 
			}
		});
		$chkAll.prop("checked", chkVal);   
		if(chkVal) {
			$chkAll.parent().addClass("on");
		} else {
			$chkAll.parent().removeClass("on");
			if(allCheckState) {
				$chkOther.prop("checked", true);
				$chkOther.parent().removeClass("on");
				$(this).prop("checked", false);
				$(this).parent().addClass("on");				
			}
		}
	});
}

var hiddenScrollPoint = 0; 
function showLayerPopup(obj, set){
	hiddenScrollPoint = $(window).scrollTop();
	$("html, body").addClass("oh")
	$(".bgLayer").css("height", $(document).height() + "px").show();
	if(set == "setTop"){
		$(obj).show();
		if($(obj).height() < $(window).height()){
			$(obj).css("margin-top", "-" + ($(obj).height() / 2) + "px");
		} else {
			$(obj).css("top", "0")
		}	
		$(obj).addClass("on");
	} else {
		$(obj).show().addClass("on");
	}
		
}
function hideLayerPopup(obj){
	$(".bgLayer").hide();
	$(obj).parents('.popLayer').hide().removeClass("on");	
	$("html, body").removeClass("oh");
	$("html, body").scrollTop(hiddenScrollPoint)
	
}

function showMessage(text){
	$("body").append('<div class="messageLayer">'+text+'</div>')
	$(".messageLayer").fadeIn(100);
	setTimeout(function(){
		$(".messageLayer").fadeOut(200, function(){
			$(".messageLayer").remove()
		})
	}, 2000)
}