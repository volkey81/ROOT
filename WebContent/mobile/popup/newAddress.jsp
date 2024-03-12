<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.utils.*,
				 com.sanghafarm.service.member.*" %>
<%
	request.setAttribute("MENU_TITLE", new String("신규 배송지등록"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
	String layerId = request.getParameter("layerId");
%>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	AddrBookService  addr = (new AddrBookService()).toProxyInstance();
	
	if(!fs.isLogin()) {
%>
		<script>
			alert("로그인이 필요합니다.");
			hidePopupLayer();
		</script>
<%
		return;
	}
	
	String mode = param.get("mode", "CREATE");
	Param info = new Param();
	
	if("MODIFY".equals(mode)) {
		param.set("userid", fs.getUserId());
		info = addr.getInfo(param);
	}
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<%
	if(request.getScheme().equals("https")) {
%> 
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<%
	} else {
%>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<%
	}
%>
<script>
	var v;
	
	$(function() {
		v = new ef.utils.Validator($("#addrForm"));
		
		v.add("addr_name", {
			"empty" : "배송지명을 입력해 주세요.",
			"max" : 10
		});
		v.add("name", {
			"empty" : "수취인명을 입력해 주세요.",
			"max" : 10
		});
		v.add("mobile2", {
			"empty" : "휴대폰번호를 입력해 주세요.",
			"format" : "numeric",
			"max" : 4
		});
		v.add("mobile3", {
			"empty" : "휴대폰번호를 입력해 주세요.",
			"format" : "numeric",
			"max" : 4
		});
		v.add("tel1", {
			"format" : "numeric",
			"max" : 4
		});
		v.add("tel2", {
			"format" : "numeric",
			"max" : 4
		});
		v.add("tel3", {
			"format" : "numeric",
			"max" : 4
		});
		v.add("post_no", {
			"empty" : "우편번호를 입력해 주세요."
		});
		v.add("addr1", {
			"empty" : "주소를 입력해 주세요."
		});
		v.add("addr2", {
			"empty" : "주소를 입력해 주세요."
		});
	});
	
	function goSubmit() {
		if(v.validate()) {
			ajaxSubmit($("#addrForm"), function(json) {
				alert(json.msg);
<%
	if("CREATE_POP".equals(mode)) {
%>
				document.location.href="/mobile/popup/addressList.jsp?layerId=<%=layerId%>";
// 				showPopupLayer('/mobile/popup/addressList.jsp', '630'); 
//				hidePopupLayer(<%=layerId%>, 'reset');
<%
	} else {
%>
				parent.document.location.reload();
<%
	}
%>
			});
		}
	}
</script></head>  
<body class="popup">
<div id="popWrap">
	<h1><%=MENU_TITLE %></h1>
	<div id="popCont">
	<!-- 내용영역 -->
		<form name="addrForm" id="addrForm" action="/mypage/order/addrProc.jsp" method="POST">
			<input type="hidden" name="mode" value="<%= mode %>" />
			<input type="hidden" name="seq" value="<%= param.get("seq") %>" />
		<table class="bbsForm typeB">
			<caption>신규 배송지 정보 입력폼</caption>
			<colgroup>
				<col width=70><col width="">
			</colgroup>
			<tr>
				<th scope="row">배송지명</th>
				<td><input type="text" name="addr_name" id="addr_name" value="<%= info.get("addr_name") %>" title="배송지명" style="width:100%"></td>
			</tr>
			<tr>
				<th scope="row">수취인</th>
				<td><input type="text" name="name" id="name" value="<%= info.get("name") %>" title="수취인 성명" style="width:100%"></td>
			</tr>
			<tr>
				<th scope="row">휴대전화</th>
				<td>
					<select name="mobile1" id="mobile1" title="수취인 휴대전화 앞자리" style="width:55px">
<%
	for(String mobile : SanghafarmUtils.MOBILES) {
%>
						<option value="<%= mobile %>" <%= mobile.equals(info.get("mobile1")) ? "selected" : "" %>><%= mobile %></option>
<%
	}
%>
					</select>&nbsp;-
					<input type="text" name="mobile2" id="mobile2" value="<%= info.get("mobile2") %>" title="수취인 휴대전화 가운데자리" style="width:55px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">&nbsp;-
					<input type="text" name="mobile3" id="mobile3" value="<%= info.get("mobile3") %>" title="수취인 휴대전화 뒷자리" style="width:55px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">
				</td>
			</tr>
			<tr>
				<th scope="row">일반전화</th>
				<td>					
					<input type="text" name="tel1" id="tel1" value="<%= info.get("tel1") %>" title="수취인 일반전화 앞자리" style="width:55px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">&nbsp;-
					<input type="text" name="tel2" id="tel2" value="<%= info.get("tel2") %>" title="수취인 일반전화 가운데자리" style="width:55px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">&nbsp;-
					<input type="text" name="tel3" id="tel3" value="<%= info.get("tel3") %>" title="수취인 일반전화 뒷자리" style="width:55px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">
				</td>
			</tr>
			<tr>
				<th scope="row">배송지</th>
				<td>
					<input type="text" name="post_no" id="post_no" value="<%= info.get("post_no") %>" readonly title="배송지 우편번호" style="width:60px">
					<a href="javascript:execDaumPostcode()" class="btnTypeA sizeS">우편번호찾기</a>
					<input type="text" name="addr1" id="addr1" readonly value="<%= info.get("addr1") %>" title="배송지 주소" style="width:100%;margin-top:5px"><br>
					<input type="text" name="addr2" id="addr2" value="<%= info.get("addr2") %>" title="배송지 상세주소" style="width:100%;margin-top:5px" placeholder="상세주소 입력">
				</td>
			</tr>
		</table><!-- //배송지정보 -->
		<div class="btnArea">
			<span><a href="#none" onclick="goSubmit()" class="btnTypeB sizeL">확인</a></span>
		</div>
		</form>
	<!-- //내용영역 -->
	</div><!-- //popCont -->
</div><!-- //popWrap -->
<div id="layer" style="display:none;position:fixed;overflow:hidden;z-index:1;-webkit-overflow-scrolling:touch;">
<img src="//t1.daumcdn.net/localimg/localimages/07/postcode/320/close.png" id="btnCloseLayer" style="cursor:pointer;position:absolute;right:-3px;top:-3px;z-index:1;width:auto" onclick="closeDaumPostcode()" alt="닫기 버튼">
</div>
<script>
	//팝업높이조절
	setPopup(<%=layerId%>);
	
	//우편번호 찾기 화면을 넣을 element
	var element_layer = document.getElementById('layer');
	
	function closeDaumPostcode() {
	    // iframe을 넣은 element를 안보이게 한다.
	    element_layer.style.display = 'none';
	}
	
	function execDaumPostcode() {
	    new daum.Postcode({
	        oncomplete: function(data) {
	            // 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
	
	            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
	            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
	            var fullAddr = data.address; // 최종 주소 변수
	            var extraAddr = ''; // 조합형 주소 변수
	
	            // 기본 주소가 도로명 타입일때 조합한다.
	            if(data.addressType === 'R'){
	                //법정동명이 있을 경우 추가한다.
	                if(data.bname !== ''){
	                    extraAddr += data.bname;
	                }
	                // 건물명이 있을 경우 추가한다.
	                if(data.buildingName !== ''){
	                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                }
	                // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
	                fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
	            }
	
	            // 우편번호와 주소 정보를 해당 필드에 넣는다.
	            $("#post_no").val(data.zonecode); //5자리 새우편번호 사용
	            $("#addr1").val(fullAddr);
	            $("#addr2").val('');
	            $("#addr2").focus();
	
	            // iframe을 넣은 element를 안보이게 한다.
	            // (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
	            element_layer.style.display = 'none';
	        },
	        width : '100%',
	        height : '100%',
	        maxSuggestItems : 5
	    }).embed(element_layer);
	
	    // iframe을 넣은 element를 보이게 한다.
	    element_layer.style.display = 'block';
	
	    // iframe을 넣은 element의 위치를 화면의 가운데로 이동시킨다.
	    initLayerPosition();
	}
	
	// 브라우저의 크기 변경에 따라 레이어를 가운데로 이동시키고자 하실때에는
	// resize이벤트나, orientationchange이벤트를 이용하여 값이 변경될때마다 아래 함수를 실행 시켜 주시거나,
	// 직접 element_layer의 top,left값을 수정해 주시면 됩니다.
	function initLayerPosition(){
	    var width = 290; //우편번호서비스가 들어갈 element의 width
	    var height = 380; //우편번호서비스가 들어갈 element의 height
	    var borderWidth = 5; //샘플에서 사용하는 border의 두께
	
	    // 위에서 선언한 값들을 실제 element에 넣는다.
	    element_layer.style.width = width + 'px';
	    element_layer.style.height = height + 'px';
	    element_layer.style.border = borderWidth + 'px solid';
	    // 실행되는 순간의 화면 너비와 높이 값을 가져와서 중앙에 뜰 수 있도록 위치를 계산한다.
	    element_layer.style.left = (((window.innerWidth || document.documentElement.clientWidth) - width)/2 - borderWidth) + 'px';
	    element_layer.style.top = (((window.innerHeight || document.documentElement.clientHeight) - height)/2 - borderWidth) + 'px';
	}
/*
	function execDaumPostcode() {
	    new daum.Postcode({
	        oncomplete: function(data) {
	            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
	
	            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
	            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
	            var fullAddr = ''; // 최종 주소 변수
	            var extraAddr = ''; // 조합형 주소 변수
	
	            // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
	            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
	                fullAddr = data.roadAddress;
	
	            } else { // 사용자가 지번 주소를 선택했을 경우(J)
	                fullAddr = data.jibunAddress;
	            }
	
	            // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
	            if(data.userSelectedType === 'R'){
	                //법정동명이 있을 경우 추가한다.
	                if(data.bname !== ''){
	                    extraAddr += data.bname;
	                }
	                // 건물명이 있을 경우 추가한다.
	                if(data.buildingName !== ''){
	                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                }
	                // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
	                fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
	            }
	
	            // 우편번호와 주소 정보를 해당 필드에 넣는다.
// 	            document.getElementById('sample6_postcode').value = data.zonecode; //5자리 새우편번호 사용
// 	            document.getElementById('sample6_address').value = fullAddr;
	            $("#post_no").val(data.zonecode); //5자리 새우편번호 사용
	            $("#addr1").val(fullAddr);
	
	            // 커서를 상세주소 필드로 이동한다.
// 	            document.getElementById('sample6_address2').focus();
	            $("#addr2").val('');
	            $("#addr2").focus();
	        }
	    }).open();
	}
*/
</script>
</body>
</html>