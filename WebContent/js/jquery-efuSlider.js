/*
	ex) efuSlider('.galleryList', 1, 150, '', 'once');
	ex) efuSlider('.galleryList', 3, 150); 
	obj = .slideCont(>ul>li)와 .prev .next를 자식으로 갖는 부모 엘리먼트
	num = 한번에 움직이는 갯수 (보이는 갯수만큼 움직인다고 가정)
	speed = 속도
	fx = vertical(세로형)
	step = once(한칸씩움직임, num = 1 필수)  
*/
function efuSlider(obj, num, speed, fx, step){
	var total, totalWidth, item, itemWidth, itemPadding, itemMargin, itemBorder, moveWidth, totalMoveWidth, speed, moveCnt = 0, activeCnt = 0;
	item = $(".slideCont li:first", obj);
	if(fx == "vertical"){
		if(item.css("height")){
			itemWidth = parseInt(item.css("height"));
		} else {
			itemWidth = item.find("img").height();
		}
		itemPadding = item.css("padding-top") ? (parseInt(item.css("padding-top").replace("px", "")) + parseInt(item.css("padding-bottom").replace("px", ""))) : 0;
		itemMargin = item.css("margin-top") ? (parseInt(item.css("margin-top").replace("px", "")) + parseInt(item.css("margin-bottom").replace("px", ""))) : 0;
		itemBorder = item.css("border-top-width") ? (parseInt(item.css("border-top-width").replace("px", "")) + parseInt(item.css("border-bottom-width").replace("px", ""))) : 0;		
	} else {	
		itemWidth = item.width();
		if(item.css("width")){
			itemWidth = parseInt(item.css("width"));
		} else {
			itemWidth = item.find("img").width();
		}
		itemPadding = item.css("padding-right") ? (parseInt(item.css("padding-right").replace("px", "")) + parseInt(item.css("padding-left").replace("px", ""))) : 0;
		itemMargin = item.css("margin-right") ? (parseInt(item.css("margin-right").replace("px", "")) + parseInt(item.css("margin-left").replace("px", ""))) : 0;
		itemBorder = item.css("border-right-width") ? (parseInt(item.css("border-right-width").replace("px", "")) + parseInt(item.css("border-left-width").replace("px", ""))) : 0;
	}		
	itemPadding = itemPadding ? itemPadding : 0;
	itemMargin = itemMargin ? itemMargin : 0;
	itemBorder = itemBorder ? itemBorder : 0;
	moveWidth = (itemWidth + itemPadding + itemMargin + itemBorder) * num; //한번에 움직이는 사이즈
	totalWidth = (itemWidth + itemPadding + itemMargin + itemBorder) * $(".slideCont >ul >li", obj).size(); 
	
	//console.log(itemWidth+":"+itemPadding+":"+itemMargin+":"+itemBorder);
	
	if(step == "once"){
		moveCnt = $(".slideCont >ul >li", obj).size() - (parseInt(($(".slideCont", obj).width() + itemMargin) / (itemWidth + itemPadding + itemMargin + itemBorder)));
	} else {
		if($(".slideCont >ul >li", obj).size() % num != 0){ 
			moveCnt = parseInt($(".slideCont >ul >li", obj).size() / num); //이동횟수
		} else {
			moveCnt = ($(".slideCont >ul >li", obj).size() / num) - 1;
		}
	}
	
	$(obj).find(".next").off("click");
	$(obj).find(".prev").off("click");
	
	$(".slideCont >ul", obj).width(totalWidth);
	var viewItem = Math.round($(".slideCont", obj).width() / (itemWidth + itemPadding + itemMargin + itemBorder));
	/*if(totalWidth <= $(".slideCont", obj).width()){*/
	if(totalWidth <= viewItem * (itemWidth + itemPadding + itemMargin + itemBorder)){
		//console.log('off')
		$(obj).find(".next, .prev").hide();
		$(obj).addClass("offSlide");
		//$(obj).width(totalWidth);
	} else {	
		$(obj).find(".next, .prev").show();
		$(obj).removeClass("offSlide");
		$(obj).find(".next").on("click", function(e){
			if(activeCnt < moveCnt){
				activeCnt++;
				totalMoveWidth = moveWidth * activeCnt;
				if(fx == "vertical"){
					$(obj).find("ul").animate({marginTop: "-" + totalMoveWidth + "px"}, speed);
				} else {		 
					$(obj).find("ul").animate({marginLeft: "-" + totalMoveWidth + "px"}, speed);
				}
			} 
			e.preventDefault();
		});
		$(obj).find(".prev").on("click", function(e){
			if(activeCnt > 0){
				activeCnt--;
				totalMoveWidth = moveWidth * activeCnt;
				if(fx == "vertical"){
					$(obj).find("ul").animate({marginTop: "-" + totalMoveWidth + "px"}, speed);
				} else {		 
					$(obj).find("ul").animate({marginLeft: "-" + totalMoveWidth + "px"}, speed);
				}
			} 
			e.preventDefault();
		});
	}
}