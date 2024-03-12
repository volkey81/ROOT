$(function(){
	$("#gnb .shopping .typeSub >li:nth-child(2n)").css("border-left", "1px solid #e5e5e5");
	if($(".eventList").size() > 0){
		$(".eventList li:nth-child(3n+1)").css("margin-left", "0");
	} 
	if($(".recipeList").size() > 0){
		$(".recipeList li:nth-child(3n+1)").css("margin-left", "0");
	} 
	if($(".calender").size() > 0){
		$(".calender li:nth-child(7n+1), .calender li:nth-child(7n+1) a").css("color", "#e67200");
	}
	$("input[type=checkbox], input[type=radio]").on("click", function(){
		if($(this).prop("checked")){
			$(this).addClass("checked");
		} else {
			$(this).removeClass("checked");
		}		
	});
});

$(window).on("load resize", function(){
	setScrollWindow();
});

function setScrollWindow(){
	if($(window).width() <= 1230){
		$(".mainVisual .prev").css("margin-left", "-535px");
		$(".mainVisual .next").css("margin-right", "-535px");
	} else {
		$(".mainVisual .prev").css("margin-left", "-615px");
		$(".mainVisual .next").css("margin-right", "-615px");
	}
}