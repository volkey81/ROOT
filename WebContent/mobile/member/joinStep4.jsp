<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page import="com.efusioni.stone.common.*" %>
<%@ page import="com.sanghafarm.service.member.*"%>
<%
	String referer = request.getHeader("Referer");
	System.out.println("referer ---------------------- " + referer);
	
	if(SystemChecker.isReal()) {
		if(referer == null || (referer.indexOf("joinProc.jsp") == -1 && referer.indexOf("snsJoinProc.jsp") == -1)) {
			throw new Exception();
		}
	}
	
	request.setAttribute("Depth_1", new Integer(2));
	Param param = new Param(request);
	MemberService svc = (new MemberService()).toProxyInstance();

	/*
	Param info = svc.getInfo(param.get("userid"));
	if(!"".equals(info.get("recommender"))) {
		response.sendRedirect("joinComplete.jsp?type=" + param.get("type"));
		return;
	}
	*/
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
	<jsp:include page="/mobile/include/head.jsp" />
<% 
	if("web".equals(param.get("type"))){
%>
	<link rel="stylesheet" href="/css/common.css?t=<%=System.currentTimeMillis()%>">
	<link rel="stylesheet" href="/css/layout.css?t=<%=System.currentTimeMillis()%>">
	<script src="/js/jquery-ui.js?t=<%=System.currentTimeMillis()%>"></script>
<%
	} 
%>
</head>  
<body>
<div id="wrapper" class="login<%= "web".equals(param.get("type")) ? " webType" : "" %>">
<% 
	if("web".equals(param.get("type"))){
%>
	<jsp:include page="/include/header.jsp" />
<%
	}
%>	
	<div class="loginHead">
		<img src="/mobile/images/member/head.jpg" alt="" />
	</div>	 	
	<div id="container" class="join">
	<!-- 내용영역 -->
		<div class="logInTop lgPop">
			<ul class="step">
				<li>본인인증</li>
				<li>회원가입</li>
				<li class="fb">추천인 입력</li>
			</ul>
<% 
	if(!"web".equals(param.get("type"))){
%>		
			<jsp:include page="/mobile/member/memberClose.jsp" />
<%
	}
%>
		</div>	
		<strong class="formTitle">추천인 입력 <span class="fs fontTypeC">(선택사항)</span> </strong>
		<table class="joinForm">
			<tr>
				<td style="padding-top:0;">
					<form name="joinForm" id="joinForm">
					<input type="text" name="recommender" id="recommender" value="" placeholder="*아이디" style="width:76%;" maxlength="12">
						<a href="javascript:void(0)" class="btnCheck" onclick="duplicateId();">확인</a>
					<input type="hidden" name="userid" id="userid" value="<%= param.get("userid") %>"/>						
					<input type="hidden" name="unfy_mmb_no" id="unfy_mmb_no" value="<%= param.get("unfy_mmb_no") %>"/>						
					</form>					
				</td>
			</tr>	
		</table>
		<div class="btnWarp">
			<a href="javascript:goRecommender()" class="btnCheck Large">추천인 등록</a>	
			<a href="joinComplete.jsp?type=<%=param.get("type") %>" class="btnCheck Large typeB">추천인 없이 가입하기</a>				
		</div>	
		
	<!-- //내용영역 -->
	</div><!-- //container -->
<% 
	if("web".equals(param.get("type"))){
%>
	<jsp:include page="/include/footer.jsp" />
<%
	}
%>
</div><!-- //wrapper -->
<jsp:include page="/mobile/include/pop_footer.jsp" /> 
</body>
<script>
	var checkedId = "";
	var doubleSubmitFlag = false;
	
	function duplicateId() {
		
	    if(doubleSubmitCheck()) return;
	    checkedId = "";
	    
		var id = $("#recommender").val();
		if (id == '') {
			alert("아이디를 입력해주세요.");
			doubleSubmitFlag = false;
			return;
/*		} else {
			var idRegExp = /^[A-Za-z0-9]{4,20}$/;
			// 영문/숫자 4~12자리 체크
			var chkNum = id.search(/[0-9]/g); 
		    var chkEng = id.search(/[a-z]/ig);
			if (!idRegExp.test( id )) {
	            alert("영문/숫자 포함 4~20자리로 아이디를 입력해 주세요.");
				$("#userId").focus();
				doubleSubmitFlag = false;
				return;
	 		} else if((chkNum < 0 || chkEng < 0)) {
			    if(chkNum < 0 || chkEng < 0) {  
			}else if(id.length < 4 || id.length > 20 ){
		    	alert("영문/숫자 포함 4~12자리로 아이디를 입력해 주세요.");
				$("#userId").focus();
				doubleSubmitFlag = false;
				return;
			}
*/
		}
		
	    var param = {
	    		userId : id
	        }

	    $.ajax({
	        type : "POST",
	        url : '/mobile/member/checkRecommenderId.jsp',
	        dataType : "json",
	        data : param,
	    }).done(function(data) {
    		if(data.result == "true") {
    			checkedId = id;
    			alert("등록 가능한 아이디입니다.");	
    		}else{
    			alert("등록 불가능한 아이디입니다.");	
    		}
			doubleSubmitFlag = false;
	    });
		
	}
	
	//이중처리방지
	function doubleSubmitCheck(){
	    if(doubleSubmitFlag){
	        return doubleSubmitFlag;
	    }else{
	        doubleSubmitFlag = true;
	        return false;
	    }
	}

	function goRecommender() {
		console.log(checkedId, $("#recommender").val())
		if(checkedId != $("#recommender").val()) {
			alert("아이디 확인이 필요합니다.");
		} else {
		    if(doubleSubmitCheck()) return;
		    var param = {
		    		userid : $("#userid").val(),
		    		recommender : $("#recommender").val(),
		    		unfy_mmb_no : $("#unfy_mmb_no").val()
		        }

		    $.ajax({
		        type : "POST",
		        url : '/mobile/member/recommender.jsp',
		        dataType : "json",
		        data : param,
		    })
		    .done(function(data) {
	    		if(data.result) {
	    			document.location.href = "joinComplete.jsp?type=<%= param.get("type") %>";
	    		}else{
	    			alert(data.message);
	    		}
			    doubleSubmitFlag = false;
		    });
		}
	}
</script>
</html>
