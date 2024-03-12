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
<jsp:include page="/include/head.jsp" /> 
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
<div id="wrapper" class="fullpage">
	<jsp:include page="/include/header.jsp" />
	<div id="container" class="eventWrap">
	<!-- 내용영역 -->
		<div class="head">
			<h1><img src="images/event1.jpg" alt="상하농원 앱출시 기념 이벤트"></h1>
			<h2><img src="images/event2.jpg" alt="앱을 다운받으신 고객님을 위한 3가지 특별한 혜택"></h2>
			<img src="images/event3.jpg" alt="APP 전용 할인쿠폰 증정" usemap="#event1">
			<map name="event1">
				<area shape="rect" coords="596,392,1037,471" href="/mypage/coupon/list.jsp" alt="쿠폰 확인하기">
			</map>
		</div>
		<div class="content">
			<img src="images/event4.jpg" alt="">
			<form name="commentForm" id="commentForm" action="/event/170614/proc.jsp">
				<input type="hidden" name="mode" id="mode" />
				<input type="hidden" name="sub_seq" id="sub_seq" />
			<div class="fieldArea">
				<p class="text"><img src="images/txt_field.gif" alt="스토어 ID , 성함 , 연락처 3가지를 꼭! 입력해주셔야 기프티콘 발송이 가능합니다!"></p>
				<fieldset>
					<legend>이벤트 참여 댓글 등록</legend>
					<textarea name="contents" id="contents" placeholder="<%= example %>" onfocus="checkLogin(this);"></textarea>
					<a href="javascript:goCreate()"><img src="images/btn_register.png" alt="댓글 등록"></a>
				</fieldset>
				<p class="text2">게시판은 매일Do 아이디로 로그인 하셔야 응모하실 수 있습니다. 리뷰에 욕설 및 의미 없는 의성어 작성시 행사 대상에서 제외될 수 있습니다.<br>게시글은 자동 비밀글로 설정되며, 작성자 본인과 관리자만 확인할 수 있습니다.</p>
			</div>
			</form>
			<div id="commentList">
			</div>
		</div>
		<div class="foot">
			<img src="images/event5.jpg" alt="">
		</div>
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>