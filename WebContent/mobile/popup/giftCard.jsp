<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.service.member.*,
			com.sanghafarm.common.*" %>
<%
	request.setAttribute("MENU_TITLE", new String("기프트 카드 조회"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
	String layerId = request.getParameter("layerId");

	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	
	ImMemberService immem = (new ImMemberService()).toProxyInstance();
	List<Param> list = immem.getMemberGiftcard(fs.getUserNo());
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<script>
	var receiptNum;
	var receiptSubNum;
	function receiptChange(val) {
		receiptNum = val;
		if(receiptNum == 1 || receiptNum == 2){
			var $target =  $("#receiptType_" + receiptNum);
			$(".receiptSection:visible input").val("");
			$(".receiptSection:visible").hide();
			$target.show();
			if($target.find("#receiptSubSelect").size() > 0){
				$("#receiptSubSelect option:first-child").prop("selected", true);
				receiptSubChange(0);
			}
		} else {
			$(".receiptSection:visible input").val("");
			$(".receiptSection:visible").hide();
			$(".receiptSubSection:visible input").val("");
			$(".receiptSubSection:visible").hide();
		}
		setPopup(<%=layerId%>);
	}
	
	function receiptSubChange(val) {
		receiptSubNum = val;
		if(receiptNum == 0 || receiptNum == 1){
			var $target =  $("#receiptType_" + receiptNum + "_" + receiptSubNum);
			$(".receiptSubSection:visible input").val("");
			$(".receiptSubSection:visible").hide();
			$target.show();
		}
		setPopup(<%=layerId%>);
	}

	function setCard(cardid) {
		$("#gift_amt").val("0");
		$("#gift_all").prop("checked", false);
	}
	
	function setAll() {
		if($("input[name='crd_id']:checked").length == 0) {
			alert("결제할 카드를 선택해 주세요.");
		} else {
			var cardid = $("input[name='crd_id']:checked").val();
			var amt = $("#amt_" + cardid).val();
			if(parseInt(amt) > <%= param.getInt("pay_amt") %>) {
				amt = <%= param.getInt("pay_amt") %>;
			}
			
			$("#gift_amt").val(amt.formatMoney());
		}
	}
	
	function apply() {
		var cardnum = "";

		if($("input[name='crd_id']:checked").length == 0) {
			alert("결제할 카드를 선택해 주세요.");
		} else {
			if($("#receiptSelect").val() == '') {
				alert("기프트카드 결제금액에 대한 현금영수증 발급여부를 선택해 주세요.");
				return;
			} else if($("#receiptSelect").val() == '1') {
				if($("#receiptSubSelect").val() == '0') {
					if($("#no_1_0_2").val().length < 3) {
						alert("휴대폰 번호를 정확히 입력하세요.");
						$("#no_1_0_2").focus();
						return;
					} else if($("#no_1_0_3").val().length < 4) {
						alert("휴대폰 번호를 정확히 입력하세요.");
						$("#no_1_0_3").focus();
						return;
					} else {
						cardnum = $("#no_1_0_1").val() + $("#no_1_0_2").val() + $("#no_1_0_3").val();
					}
				} else if($("#receiptSubSelect").val() == '1') {
					for(var i = 1; i <= 4; i++) {
						cardnum += $("#no_1_1_" + i).val();
					}
					
					if(!cardnum.validateCardNum()) {
						alert("신용카드번호를 정확히 입력하세요.");
						return;
					}
				} else if($("#receiptSubSelect").val() == '2') {
					for(var i = 1; i <= 3; i++) {
						if($("#no_1_2_" + i).val().length < 4) {
							$("#no_1_2_" + i).focus();
							alert("현금영수증 카드번호를 정확히 입력하세요.");
							return;
						} else {
							cardnum += $("#no_1_2_" + i).val();
						}
					}
					if($("#no_1_2_4").val().length < 6) {
						$("#no_1_2_4").focus();
						alert("현금영수증 카드번호를 정확히 입력하세요.");
						return;
					} else {
						cardnum += $("#no_1_2_4").val();
					}
				}
			} else if($("#receiptSelect").val() == '2') {
				if($("#no_2_1").val().length < 3) {
					alert("사업자 등록번호를 정확히 입력하세요.");
					$("#no_2_1").focus();
					return;
				} else if($("#no_2_2").val().length < 2) {
					$("#no_2_2").focus();
					alert("사업자 등록번호를 정확히 입력하세요.");
					return;
				} else if($("#no_2_3").val().length < 5) {
					$("#no_2_3").focus();
					alert("사업자 등록번호를 정확히 입력하세요.");
					return;
				} else {
					cardnum = $("#no_2_1").val() + $("#no_2_2").val() + $("#no_2_3").val();
				}
			}

			var cardid = $("input[name='crd_id']:checked").val();
			var giftAmt = $("#gift_amt").val().replace(/,/g, "");
			if(parseInt(giftAmt) > parseInt($("#amt_" + cardid).val())) {
				giftAmt = $("#amt_" + cardid).val();
			} 
			if(parseInt(giftAmt) > <%= param.getInt("pay_amt") %>) {
				giftAmt = <%= param.getInt("pay_amt") %>;
			}
			
			$("#gift_amt").val(giftAmt.formatMoney());
			
			parent.applyGiftcard(cardid, giftAmt.formatMoney(), $("#receiptSelect").val(), cardnum);
			hidePopupLayer();
		}		
	}
</script>
</head>  
<body class="popup">
<div id="popWrap">
	<h1><%=MENU_TITLE %></h1>
	<div id="popCont">
	<!-- 내용영역 -->
		<div class="myGiftCard">
			<div class="head">
				<h2 class="typeB">결제할 카드를 선택해 주세요.</h2>
			</div>
			<div class="scr">
				<table class="bbsList ">
					<colgroup><col width="130"><col></colgroup>
<%
	int cnt = 0;
	for(Param row : list) {
		if("10".equals(row.get("crd_st"))) {
%>
					<tr>
						<th>
							<input type="radio" id="crd_id_<%= row.get("crd_id") %>" name="crd_id" class="vm" value="<%= row.get("crd_id") %>" onclick="setCard('<%= row.get("crd_id") %>')">
							<label for="crd_id_<%= row.get("crd_id") %>"><img src="https://www.maeildo.com/imageserver<%= SystemChecker.isReal() ? "" : "/stage" %>/<%= row.get("crd_img") %>" alt="카드 이미지" style="width:90px"  class="vm"></label>
						</th>
						<td class="al">
							<span class="num"><%= row.get("crd_id").substring(0, 4) %>-<%= row.get("crd_id").substring(4, 8) %>-<%= row.get("crd_id").substring(8, 12) %>-<%= row.get("crd_id").substring(12, 16) %></span>
							<p class="price"><strong><%= Utils.formatMoney(row.getInt("actv_amt") - row.getInt("use_amt")) %></strong>원</p>
							<span class="date">등록 : <%= row.get("reg_dt").substring(0, 4) %>-<%= row.get("reg_dt").substring(4, 6) %>-<%= row.get("reg_dt").substring(6, 8) %></span>
							<input type="hidden" name="amt" id="amt_<%= row.get("crd_id") %>" value="<%= row.getInt("actv_amt") - row.getInt("use_amt") %>" />
						</td>
					</tr>
<%
			cnt++;
		}
	}
%>
				</table>
			</div>
			
			<div class="head">
				<h2 class="typeB">결제할 금액을 입력해 주세요.</h2>
			</div>
			<table class="couponForm">
		 		<caption>할인 적용 선택 폼</caption>
		 		<colgroup>
		 			<col width=""><col width="100">
		 		</colgroup>
		 		<tr>
		 			<td><input type="text" name="gift_amt" id="gift_amt" value="0" title="" style="width:195px;">&nbsp;원</td>		 			
		 			<td><input type="checkbox" name="gift_all" id="gift_all"" onclick="setAll()"><label for="gift_all">모두사용</label></td>
		 		</tr>
		 	</table><!-- //할인받기 -->

			<div class="head">
				<h2 class="typeB">현금영수증 발행 여부를 선택해 주세요.</h2>
			</div>
			<div id="receiptArea" class="cont">
				<select name="receiptSelect" id="receiptSelect" onchange="receiptChange(this.value);" style="width:49%;">
					<option value="" selected="selected">현금영수증발행여부</option>
					<option value="0">현금영수증 미발행</option>
					<option value="1">소득공제(개인)</option>
					<option value="2">지출증빙(사업자 등록번호)</option>
				</select>
				
				<div id="receiptType_1" class="receiptSection">
					<select name="receiptSubSelect" id="receiptSubSelect" onchange="receiptSubChange(this.value);"  style="width:49%;">
						<option value="0" selected="selected">휴대전화번호</option>
						<option value="1">신용카드번호</option>
						<option value="2">현금영수증 카드</option>
					</select>
					
					<div id="receiptType_1_0" class="receiptSubSection inputArea">
						<span>
							<select name="no_1_0_1" id="no_1_0_1">
								<option value="010" selected="selected">010</option>
								<option value="011">011</option>
								<option value="016">016</option>
								<option value="017">017</option>
								<option value="018">018</option>
								<option value="019">019</option>
								<option value="0130">0130</option>
							</select>
						</span>
						<span><input type="text" name="no_1_0_2" id="no_1_0_2" maxlength="4" style="ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)"></span>				
						<span><input type="text" name="no_1_0_3" id="no_1_0_3" maxlength="4" style="ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)"></span>
					</div>			
					
					<div id="receiptType_1_1" class="receiptSubSection inputArea num4">			
						<span><input type="text" name="no_1_1_1" id="no_1_1_1" maxlength="4" style="ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)"></span>				
						<span><input type="text" name="no_1_1_2" id="no_1_1_2" maxlength="4" style="ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)"></span>
						<span><input type="text" name="no_1_1_3" id="no_1_1_3" maxlength="4" style="ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)"></span>				
						<span><input type="text" name="no_1_1_4" id="no_1_1_4" maxlength="4" style="ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)"></span>
					</div>			
					
					<div id="receiptType_1_2" class="receiptSubSection inputArea num4">			
						<span><input type="text" name="no_1_2_1" id="no_1_2_1" maxlength="4" style="ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)"></span>				
						<span><input type="text" name="no_1_2_2" id="no_1_2_2" maxlength="4" style="ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)"></span>
						<span><input type="text" name="no_1_2_3" id="no_1_2_3" maxlength="4" style="ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)"></span>				
						<span><input type="text" name="no_1_2_4" id="no_1_2_4" maxlength="6" style="ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)"></span>
					</div>
				</div>
				
				<div id="receiptType_2" class="receiptSection inputArea">
					<span><input type="text" name="no_2_1" id="no_2_1" maxlength="3" style="ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)"></span>				
					<span><input type="text" name="no_2_2" id="no_2_2" maxlength="2" style="ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)"></span>
					<span><input type="text" name="no_2_3" id="no_2_3" maxlength="5" style="ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)"></span>				
				</div>
			</div>
		</div>
		<div class="btnArea">
			<span><a href="#" onclick="hidePopupLayer();return false" class="btnTypeA sizeL">취소</a></span>
			<span><a href="#" onclick="apply();return false" class="btnTypeB sizeL">적용</a></span>
		</div>
	<!-- //내용영역 -->
	</div><!-- //popCont -->
</div><!-- //popWrap -->
<script>
//팝업높이조절
setPopup(<%=layerId%>);
</script>
</body>
</html>