$(function(){
	if($("#header2").size() > 0){
		gnb.initGnb();
		gnb.overEvent();
	}
})
var gnb = {
	initGnb : function initGnb(){
		var $depth1_on = $(".mainNav > ul > li.on");
		var gnbDefault_pos = $(".mainNav > ul > li:first-child > a").position().left;
		$("#gnbOverBar").css({
			"left" : gnbDefault_pos + "px"  
		});
		
		$(".mainNav > ul > li > ul").hide();
		$("#gnbOverBar").fadeIn(function(){
			if($depth1_on.size() > 0) {
				var depth1_w = $depth1_on.find("> a").width(); 
				var depth1_pos = $depth1_on.find("> a").position().left;
				$("#gnbOverBar").css({ 
					"width" : depth1_w + "px",
					"left" : depth1_pos + "px"
				});
				$(window).resize(function(){
					depth1_w = $depth1_on.find("> a").width(); 
					depth1_pos = $depth1_on.find("> a").position().left;
					$("#gnbOverBar").css({ 
						"width" : depth1_w + "px",
						"left" : depth1_pos + "px"
					}); 
				});
			} else {
				$("#gnbOverBar").removeAttr("style");
				$("#gnbOverBar").css({
					"left" : gnbDefault_pos + "px"  
				});
				$("#gnbOverBar").show();
			}
		}); 
	}, 
	overEvent : function overEvent(){
		var $depth1 = $(".mainNav > ul > li > a");
		$depth1.on("mouseenter", function(){
			if($("body").hasClass("main")){
				$("#header2").addClass("on");
			}
			var depth1_w = $(this).width(); 
			var depth1_pos = $(this).position().left;
			$("#gnbOverBar").css({
				"width" : depth1_w + "px",
				"left" : depth1_pos + "px"
			});
			$(".mainNav > ul > li").stop().removeAttr("style");
			$(this).fadeIn(500);
		});
		
		$(".mainNav").on("mouseleave", function(){
			if($("body").hasClass("main") && $(window).scrollTop() <= 0){
				$("#header2").removeClass("on");
			} 
			gnb.initGnb();
		}) 
	} 
}

$(function(){
	/* placeholder */
	$('[placeholder]').focus(function() {
	    var input = $(this);
	    if (input.val() == input.attr('placeholder')) {
			input.val('');
			input.removeClass('placeholder');
		}
	})
	.blur(function() {
		var input = $(this);
		if (input.val() == '' || input.val() == input.attr('placeholder')) {
			input.addClass('placeholder');
			input.val(input.attr('placeholder'));
		}
	})
	.blur().parents('form').submit(function() {
		$(this).find('[placeholder]').each(function() {
			var input = $(this);
			if (input.val() == input.attr('placeholder')) {
				input.val('');
			}
		});
	});
	
	$("#wrapper").append("<div class='bgLayer'></div>");
	
	if($("#snb").size() > 0){
		setSnbHeight();
	}
	
	$("#gnb .mainNav .all, #gnb .mainNav:not(.shopping) >ul:not(.type)").on("mouseenter focusin", function(){
		var obj = $(this);
		showSubNav(obj);
		$("#headerTop").addClass("on")
	});
	$("#gnb .mainNav").on("mouseleave", function(){
		var obj = $(this).find(">ul");
		hideSubNav(obj);
		$("#headerTop").removeClass("on")
	});
	$("#gnb .all").on("click", function(){
		var obj = $(this);
		if($(this).parents(".mainNav").hasClass("on")){
			hideSubNav(obj);
		} else {
			showSubNav(obj);
		}
	});
	
	$(".quickSrch input").on("click focusin", function(){
		$(".popularSrch").show();
	});
	$(".quickSrch").on("focusout", function(){
		//$(".popularSrch").hide();
	});
	
	$(".defaultSelect").each(function() {
		var euiSelect = new ef.ui.Select($(this), {
			html :
				"<div style='width:[width]'>" +
					"<p class='euiSelectMain'>" +
						"<span class='euiSelectTitle'></span>" +
					"</p>" +
					"<ul class='euiSelectList' style='display:none;'>" +
					"</ul>" +
				"</div>",
			visualClass : "eui_" + $(this).attr("class")
		});
		euiSelect.render();
	});
});

function showSubNav(obj){	
	var $target = $(obj);
	if($target.parents(".brand").size() > 0){
		$target.parents(".mainNav").addClass("on");
		$target.parents(".mainNav").find("ul ul").stop().slideDown(150);	
	} else if($target.parents(".shopping").size() > 0){
		$target.parents(".mainNav").addClass("on");
		$target.parents(".mainNav").find(".sub").stop().slideDown(150);	
	} else {
		$target.parents(".mainNav").addClass("on");
		$target.parents(".mainNav").find(">ul ul, .typeSub").stop().slideDown(150);			
	}
}
function hideSubNav(obj){
	var $target = $(obj);
	if($target.parents(".brand").size() > 0){
		$target.parents(".brand").find("ul ul").stop().slideUp(50, function(){
			$target.parents(".mainNav").removeClass("on");
		});
	} else if($target.parents(".shopping").size() > 0){
		$target.parents(".mainNav").find(".sub").stop().slideUp(50, function(){
			$target.parents(".mainNav").removeClass("on");
		});		
	} else {
		$target.parents(".mainNav").find(">ul ul, .typeSub").stop().slideUp(50, function(){
			$target.parents(".mainNav").removeClass("on");
		});	
	}
}

function setCycle(obj, fx, targetID, speed, timeout, before, after, func){
	if(func){
		func();
	}
	$(obj).find(".list").cycle({
		fx: fx,
		speed: speed,
		timeout: timeout,
		slideExpr : "li",
		prev : $(obj).find(".prev"),
		next : $(obj).find(".next"),
		pager : $(obj).find(".nav"),
		activePagerClass: 'on',
		pagerAnchorBuilder: function(idx) {
			idx = idx+1;
	        return '<li><a href="#'+targetID+idx+'">'+ idx +'</a></li>'; 
	    },
	    before : before,
	    after : after
	});		
	$(obj).find(".control .pause").on("click", function(){
		$(obj).find(".list").cycle("pause");
		$(obj).find(".control .play").css("display", "inline-block").siblings(".pause").hide();
	});
	$(obj).find(".control .play").on("click", function(){
		$(obj).find(".list").cycle("resume");
		$(obj).find(".control .pause").css("display", "inline-block").siblings(".play").hide();
	});
}

//리스트 행간 높이 통일
function setListHeight(obj, num){
	var $target = $(obj);
	var lineNum = 0;	
	$target.find("li").each(function(){
		lineNum = parseInt($(this).index() / num);
		$(this).addClass("line" + lineNum);	
	});

	for(var idx = 0; idx < lineNum+1; idx++){
		var wHeight = 0;
		$target.find("li.line" + idx).each(function(){
			if(wHeight < $(this).height()){
				wHeight = $(this).height();
			}
		});
		$target.find("li.line" + idx).height(wHeight);
	}
}

function goTop(){
	$("html, body").stop().animate({scrollTop:0}, 200, "easeInOutQuint");
}

$(document)
.on("click focusin", function(e) {
	if($("#familyList").is(":visible")){
		if(!($(e.target).parents(".family").length)){
			$("#familyList").slideUp(100);
		}
	}
	if($(".popularSrch").is(":visible")){
		if(!($(e.target).parents(".quickSrch").length)){
			$(".popularSrch").hide();
		}
	}
	/*
	if($(".subNav").is(":visible")){
		var obj = $(".subNav");
		if(!($(e.target).parents("#gnb .mainNav").length)){
			hideSubNav(obj);
		}
	}*/
});

//퀵메뉴, 예약하기
var quickTop, payQuickTop, moveTop;
$(window).load(function(){
	quickTop = parseInt($("#quick").css("top"));	
	moveTop = $(window).scrollTop();	
	if($(".reserForm").size() > 0){
		payQuickTop = $(".reserForm .fr").offset().top;
	}	
	setQuick();
	//setPayQuick();	
}).scroll(function(){
	moveTop = $(window).scrollTop();	
	setQuick();
	//setPayQuick();
	
	if(moveTop > 0){
		$(".btnTop").addClass("on");
		if(moveTop + $(window).height() > ($(document).height() - $("#footer").height())){
			$(".btnTop").addClass("noFix");
			//$("#quick").addClass("noFix").css("top", "-" + quickInit +"px");
		} else {
			$(".btnTop").removeClass("noFix");
			//$("#quick").removeClass("noFix").removeAttr("style");
		}
	} else {
		$(".btnTop").removeClass("on");
	}
});
//퀵메뉴
function setQuick(){
	if(quickTop > moveTop) {
		$("#quick").stop().animate({
			top : Number(quickTop)
		}, 500);
	} else {
		$("#quick").stop().animate({
			top : moveTop
		}, 500);
	}
}
//예약하기
/*function setPayQuick(){
	if($(".reserForm").size() > 0){ 
		//if(($(".reserForm .fr").height()-70) < $(window).height()){
			if(payQuickTop < moveTop){
				if(moveTop > $(document).height() - $(window).height() - $("#footer").height() - parseInt($("#container").css("padding-bottom"))){
					console.log('end')
					$(".reserForm .fr").removeClass("fix").addClass("bottom");
				} else {
					console.log('start')
					$(".reserForm .fr").removeClass("bottom").addClass("fix");
				}
			} else {
				$(".reserForm .fr").removeClass("fix bottom");			
			}
		//}
	}
}*/

//snb높이설정
function setSnbHeight(){
	$("#snb").css("min-height", $("#contArea").height() + $("#location").height() + parseInt($("#location").css("padding-top")));
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
}
//공통 레이어팝업
function showPopupLayer(popSrc, popWidth){
	top._showPopupLayer(popSrc, popWidth);
}

function outUrlShowPopupLayer(popSrc, popWidth, popHeight){
	top._outUrlShowPopupLayer(popSrc, popWidth, popHeight); 
}

var POPUP_INIT_ID = 111;
var _popupLayerID = POPUP_INIT_ID;
function _showPopupLayer(popSrc, popWidth) {
	_popupLayerID += 2;
	var popTop = $(window).height() / 2 + $(document).scrollTop();
	var marginLeft = -(popWidth / 2);
	var popSrcUrl = popSrc;
	if(popSrcUrl.indexOf("?") > 0){
		popSrcUrl += '&layerId='+ _popupLayerID
	}else {
		popSrcUrl += '?layerId='+ _popupLayerID
	}
	$("#wrapper").append(
		'<div class="popLayer" id="popLayer' + (_popupLayerID) + '" style="z-index:' + _popupLayerID + ';width:' + popWidth + 'px;margin-left:' + marginLeft + 'px">'
		+ ' <iframe src="' + popSrcUrl +'" width="100%" height="100%" frameborder="0" allowTransparency="true" scrolling="no" id="iframePopLayer' + (_popupLayerID) + '"></iframe>'
		+ ' <p class="close"><a href="#" onclick="hidePopupLayer(); return false">닫기</a></p>'
		+ '</div>'
	);     
	$(".bgLayer").css("height", $(document).height() + "px").show();	
	$("#popLayer" + _popupLayerID).show();
}


function _outUrlShowPopupLayer(popSrc, popWidth, popHeight) {
	_popupLayerID += 2;
	var popTop = $(window).height() / 2 + $(document).scrollTop();
	var marginLeft = -(popWidth / 2);
	var marginTop = -(popHeight / 2);
	var popSrcUrl = popSrc;
	if(popSrcUrl.indexOf("?") > 0){
		popSrcUrl += '&layerId='+ _popupLayerID
	}else {
		popSrcUrl += '?layerId='+ _popupLayerID
	}
	$("#wrapper").append(
		'<div class="popLayer" id="popLayer' + (_popupLayerID) + '" style="z-index:' + _popupLayerID + ';width:' + popWidth + 'px;height:' + popHeight+ 'px; margin-left:' + marginLeft + 'px;margin-top:' + marginTop + 'px; opacity:1;">'
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
	if($("#popWrap").height() >= $(window.parent).height()- 40){ //팝업높이가 부모창 높이보다 길때
		$("#popCont").height($(window.parent).height()-150).css("overflow-y", "scroll").css("padding-right", "10px");
		parent.$("#iframePopLayer" + obj).height($("#popWrap").height());
		//parent.$("#popLayer" + obj).css("top", $(window.parent).scrollTop() + "px").css("margin-top", "20px");
		parent.$("#popLayer" + obj).css("top", "20px").css("margin-top", "0");
		if($(window.parent).scrollTop() + $("#popWrap").height() > parent.$(".bgLayer").height()){ //반투명 BG 높이가 모자를때
			parent.$(".bgLayer").height($(window.parent).scrollTop() + $("#popWrap").height() + 3);
		}
	}
	parent.$("#popLayer" + obj).css("opacity", "1");
}

//오늘 하루 레이어팝업
function setCookie( name, value, expiredays){
	var todayDate = new Date();
    todayDate.setDate( todayDate.getDate() + expiredays );
    if(expiredays != null){
    	document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";";
    } else {
    	document.cookie = name + "=" + escape( value ) + "; path=/; ";
    }
    
}
function getCookie(name){
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
	$("."+obj2).add($("."+obj2).find("td")).not($(target).add($(target).find("td"))).hide();
	$(target).add($(target).find("td")).toggle();
	$(obj).parents("tr").siblings().removeClass("on");
	$(obj).parents("tr").toggleClass("on");
}
function hideTab2(obj){
	var target = $(obj).parents("tr");
	$(target).add($(target).find("td")).hide();
	$(target).add($(target).siblings()).removeClass("on");
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

//scroll - hotel
function scrollVMove(obj, speed, moveStart, moveEnd, scrollStart, scrollEnd){
	jQuery(window).scroll(function(e){
		scrollTop = jQuery(this).scrollTop();
		var $obj = jQuery(obj);
		//$obj.addClass("transition");
		var move =  - ((scrollTop - scrollStart)  / speed);
		var startNum = 0;
		var endNum = 999999999999999;
		if(scrollStart || scrollStart != "") {
			startNum = scrollStart;
		}
		if(scrollEnd || scrollEnd != "") {
			endNum = scrollEnd;
		}
		if(moveEnd == null) {
			moveEnd = "";
		}
		
		if(startNum < scrollTop && endNum > scrollTop){
			if(moveStart >= 0){
				move = moveStart + move;
				if (Number(move) < Number(moveEnd) && moveEnd.toString() != ""){ 
					$obj.css("transform", "translateY("+ moveEnd +"px)");
				} else {
					$obj.css("transform", "translateY("+ move +"px)");
				}
			}
		}
	});
}
//scroll - hotel
function scrollVMoveNew(obj, moveObj, speed, startgap, endgap){
	$(window).scroll(function(e){
		if($(obj).size() <= 0){
			return false;
		}
		var scrollTop = $(this).scrollTop();
		var $obj = $(obj);
		var $moveObj = $(obj).find(moveObj);
		var offsetTop = $obj.offset().top
		if(startgap == null) {
			startgap = 0;
		}
		if(endgap == null) {
			endgap = 0;
		}
		
		var moveStart = Number(offsetTop) - Number($(window).height()) + Number(startgap);
		var moveEnd = Number(offsetTop) + Number($obj.height()) +  Number(endgap) 
		var moveNum =  -((scrollTop - moveStart) * (speed / 100));
		if(scrollTop > moveStart && scrollTop < moveEnd) {
			$moveObj.css("transform", "translateY("+ moveNum +"px)");
		}
	});
}

//상하 파머스 타이틀
$(window).scroll( function(){
	$('.titMove>img').each( function(i){ 
		var moveTitTop = $(this).offset().top + $(this).outerHeight();
		var windowTop = $(window).scrollTop() + $(window).height();
	    if( windowTop > moveTitTop ){
	        $(this).animate({
	        	'opacity' : 1,
	        	'left':'0'
	        },1000, 'easeInOutQuint', function(){
	        });
	    }
	}); 
});

function showPopup(obj){
	$(".bgLayer").css("height", $(document).height() + "px").show();
	$(obj).show().addClass("on");	
}
function hidePopup(obj){
	$(".bgLayer").hide();
	$(obj).parents('.popLayer').hide().removeClass("on");	
	
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
