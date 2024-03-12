<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*" %>
<%
	request.setAttribute("Depth_1", new Integer(2));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("이벤트/기획전"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);

	String example = "예) 리뷰작성 완료했어요! ^^ 스토어ID : 상하맘 / 이름 : 김상하 / 연락처 : 010-1234-5678";
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<link rel="stylesheet" type="text/css" href="event.css?t=<%=System.currentTimeMillis()%>">
<script>
	$(function() {
		getComment(1);
	});
	
	function getComment(p) {
		$.ajax({
			method : "POST",
			url : "comment.jsp",
			data : { page : p },
			dataType : "html"
		})
		.done(function(html) {
			$("#commentList").empty().html(html);
		});
	}
	
	function checkLogin(obj) {
<%
	if(!fs.isLogin()) {
%>
		alert("로그인후 입력이 가능합니다.");
		obj.blur();
<%
	}
%>
	}
	
	function goCreate() {
		if($.trim($("#contents").val()) == "" || $.trim($("#contents").val()) == "<%= example %>") {
			alert("내용을 입력하세요.");
			return;
		} else {
			$("#mode").val("CREATE");
			goSubmit();
		}
	}
	
	function goSubmit() {
		ajaxSubmit($("#commentForm"), function(json) {
			alert(json.msg);
			if(json.result) {
				$("#sub_seq").val("");
				$("#contents").val("");
				getComment(1);
			}
		});
	}
	
	function setModify(seq) {
		if($("#modifyTxt_" + seq).html() == "수정") {
			$("#modifyTxt_" + seq).html("수정 취소");
			$("#contents1_" + seq).show();
			$("#contents2_" + seq).hide();
		} else {
			$("#modifyTxt_" + seq).html("수정");
			$("#contents1_" + seq).hide();
			$("#contents2_" + seq).show();
		}
	}
	
	function goModify(seq) {
		if($.trim($("#contents_" + seq).val()) == "") {
			alert("내용을 입력하세요.");
			return;
		} else {
			$("#mode").val("MODIFY");
			$("#sub_seq").val(seq);
			$("#contents").val($("#contents_" + seq).val());
			goSubmit();
		}
	}
	
	function goRemove(seq) {
		if(confirm("삭제하시겠습니까?")) {
			$("#mode").val("REMOVE");
			$("#sub_seq").val(seq);
			goSubmit();
		}
	}
</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container" class="eventWrap">
	<!-- 내용영역 -->
		<div class="head">
			<h1><img src="images/event1.jpg" alt="상하농원 앱출시 기념 이벤트"></h1>
			<div class="app">
				<img src="images/event2.jpg" alt="지금 바로 플레이스토어, 앱스토어에서 다운받으실 수 있습니다!">
				<a href="market://details?id=com.sanghafarm"><img src="/images/common/sp.gif" alt="Download for Andriod"></a>
				<a href="https://itunes.apple.com/app/id1239671849"><img src="/images/common/sp.gif" alt="Download for Apple iOS"></a>
			</div>
			<img src="images/event3.jpg" alt="1 APP전용 할인쿠폰 증정!">
			<img src="images/event4.jpg" alt="2 앱 리뷰를 남겨주신 모든 분들께 기프티콘 증정!">
		</div>
		<div class="content">
			<form name="commentForm" id="commentForm" action="/event/170614/proc.jsp">
				<input type="hidden" name="mode" id="mode" />
				<input type="hidden" name="sub_seq" id="sub_seq" />
			<div class="fieldArea">
				<p class="text"><img src="images/txt_field.jpg" alt="스토어 ID , 성함 , 연락처 3가지를 꼭! 입력해주셔야 기프티콘 발송이 가능합니다!"></p>
				<fieldset>
					<legend>이벤트 참여 댓글 등록</legend>
					<textarea name="contents" id="contents" placeholder="<%= example %>" onfocus="checkLogin(this);"></textarea>
					<a href="javascript:goCreate()" class="btn">댓글 등록</a>
				</fieldset>
			</div>
			</form>
			<div id="commentList">
			</div>
		</div>
		<img src="images/event5.jpg" alt="">
		<img src="images/event6.jpg" alt="">
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>