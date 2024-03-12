<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			java.text.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.service.hotel.*,
			org.json.simple.*" %>
<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%
	Param param = new Param(request);
	String gubun = param.get("gubun", "W");
	param.set("gubun", gubun);

	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(6));
	request.setAttribute("Depth_3", "W".equals(gubun) ? new Integer(1) : new Integer(2)); //패키지: Depth_3 = 2
	request.setAttribute("MENU_TITLE", "W".equals(gubun) ? new String("Weekly특가") : new String("패키지"));

	FrontSession fs = FrontSession.getInstance(request, response);

	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessage(out, FrontSession.LOGIN_MSG, request);
		return;
	}

// 	System.out.println(param);
	
	HotelOfferService svc = new HotelOfferService();
	
	Param info = svc.getInfo(param.get("pid"));
	if(info == null || "".equals(info.get("pid")) || !"S".equals(info.get("status"))) {
		Utils.sendMessage(out, "현재 판매중인 상품이 아닙니다.", "/hotel/offer/list.jsp");
		return;
	}

	Param priceInfo = svc.getPriceInfo(param);
	if(param.getInt("qty") > priceInfo.getInt("qty", 0)) {
		Utils.sendMessage(out, "죄송합니다. 선택하신 객실 중 판매가 완료 된 객실이 있습니다.", "/hotel/offer/detail.jsp?pid=" + param.get("pid") + "&gubun=" + param.get("gubun"));
		return;
	}

	int qty = param.getInt("qty");
	int night = SanghafarmUtils.getDateDiff(param.get("chki_date"), param.get("chot_date"));
	int defaultPrice = param.getInt("default_price") * qty;
	int price = param.getInt("price") * qty;
	
	// 추가요금 계산
	for(int i = 1; i <= param.getInt("qty"); i++) {
		int adult = param.getInt("adult" + i);
		int child = param.getInt("child" + i);
		int person = adult + child;
		
		if(person > info.getInt("capa")) {
			if(adult > info.getInt("capa")) {	
				// 성인 추가요금
				defaultPrice += (adult - info.getInt("capa")) * param.getInt("default_adult_price");
				price += (adult - info.getInt("capa")) * param.getInt("adult_price");

				// 어린이 추가요금
				defaultPrice += child * param.getInt("default_child_price");
				price += child * param.getInt("child_price");
			} else {	
				// 어린이 추가요금
				defaultPrice += (person - info.getInt("capa")) * param.getInt("default_child_price");
				price += (person - info.getInt("capa")) * param.getInt("child_price");
			}
		}
	}
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script>
var v;

$(function(){
	$(".infoAgree li span").click(function(){
		if(!$(this).parent().hasClass("on")) {
			$(this).parent().addClass("on");
			$(this).parent().find(".agreeTxt").slideDown();
		} else {
			$(this).parent().removeClass("on");
			$(this).parent().find(".agreeTxt").slideUp();
		}
		return false;
	});

	v = new ef.utils.Validator($("#orderForm"));
	
	v.add("name", {
		"empty" : "주문자 이름을 입력해 주세요.",
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
	
	var quickPos = $("#choiceInfoWrap").offset().top;
	$(window).scroll(function(){
		var scrollTop = $(this).scrollTop();
		var gap = 80;
		if(scrollTop > quickPos - gap){
			$("#choiceInfoWrap").addClass("fixed");
		} else {
			$("#choiceInfoWrap").removeClass("fixed");
		}
	})
});

function goPrev() {
	document.location.href = "detail.jsp?pid=<%= param.get("pid") %>&gubun=<%= param.get("gubun") %>";
}

function goNext() {
	if(v.validate()) {
		if(!checkName($("#name").val())) {
			alert("이름에 특수문자 입력은 불가합니다.");
			return;
		} else if(!$("#agree1").prop("checked")) {
			alert("취소/환불규정에 대한 동의는 필수입니다.");
			return;
		} else if(!$("#agree2").prop("checked")) {
			alert("결제대행서비스 표준이용약관에 대한 동의는 필수입니다.");
			return;
		} else if(!$("#agree3").prop("checked")) {
			alert("개인정보 수집 및 이용에 대한 동의는 필수입니다.");
			return;
		} else {
			$("#orderForm").submit();	
		}
	}
}

function autoFill() {
	if($("#auto_fill").prop("checked")) {
		$("#name").val("<%= fs.getUserNm() %>");
		$("#mobile1").val("<%= fs.getMobile1() %>");
		$("#mobile2").val("<%= fs.getMobile2() %>");
		$("#mobile3").val("<%= fs.getMobile3() %>");
	} else {
		$("#name").val("");
		$("#mobile1").val("010");
		$("#mobile2").val("");
		$("#mobile3").val("");
	}
}

function checkAll() {
	if($("#checkall").prop("checked")) {
		$("#agree1").prop("checked", true);
		$("#agree2").prop("checked", true);
		$("#agree3").prop("checked", true);
	} else {
		$("#agree1").prop("checked", false);
		$("#agree2").prop("checked", false);
		$("#agree3").prop("checked", false);
	}
}

function checkName(s) { 
	var regx = /[~!@\#$%<>^&*\()\-=+_\’]/gi; 
	if(regx.test(s)) { 
		return false; 
	} else {
		return true;
	}
}
</script> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<div id="container" class="hotel">
		<!-- 내용영역 -->		
		<div class="offerArea offerArea2">
			<jsp:include page="/hotel/offer/tab.jsp" />
			<p class="srmy animated fadeInUp delay04">상하농원 회원에게만 제공되는<br>특별한 객실 프로모션 상품을 만나보세요.</p>
		</div>
		<div class="reservation animated fadeInUp delay06">
			<!-- customerInfo -->
			<div class="reservationCont">
				<form name="orderForm" id="orderForm" action="<%= Env.getSSLPath() %>/hotel/offer/payment.jsp" method="post">
<%	
	Set set = param.keySet();
	for(Iterator it = set.iterator(); it.hasNext(); ) {
		String key = (String) it.next();
%>
					<input type="hidden" name="<%= key %>" id="<%= key %>" value="<%= param.get(key) %>">
<%
	}
%>
				<!-- infoCont -->
				<div class="infoCont">
					<div class="cont">
						<h2>고객정보</h2>
						<table>
							<colgroup>
								<col width="20%">
								<col width="*">
							</colgroup>
							<tr>
								<th scope="col">이름 *</th>
								<td><input type="text" name="name" id="name" style="width:187px;"></td>
							</tr>
							<tr>
								<th scope="col">연락처 *</th>
								<td>
									<select name="mobile1" id="mobile1" title="주문자 휴대전화 앞자리" style="width:88px">
<%
	for(String mobile : SanghafarmUtils.MOBILES) {
%>
										<option value="<%= mobile %>"><%= mobile %></option>
<%
	}
%>
									</select>
									<span>-</span>
									<input type="text" name="mobile2" id="mobile2" value="" title="주문자 휴대전화 가운데자리" style="width:70px;ime-mode:disabled" maxlength="4" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">
									<span>-</span>
									<input type="text" name="mobile3" id="mobile3" value="" title="주문자 휴대전화 뒷자리" style="width:70px;ime-mode:disabled" maxlength="4" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">
								</td>
							</tr>
						</table>
						<ul class="caption">
							<li>* 실제 투숙할 고객에 대한 정보를 입력해주세요.</li>
							<li>* 예약정보는 고객정보에 입력한 연락처로 SMS 발송됩니다.</li>
						</ul>
						<p class="agreeChk">고객정보 동일 <input type="checkbox" name="auto_fill" id="auto_fill" onclick="autoFill()"></p>
					</div>
					<div class="cont">
						<h2>이용 동의</h2>
						<ul class="infoAgree">
							<li><span>취소/환불규정에 대한 동의</span><input type="checkbox" name="agree1" id="agree1"><span class="checkIcon"></span>
								<div class="agreeTxt">
									<div class="txtArea">
										<p>예약취소 및 미입실(No Show)에 관한 위약금 규정에 관하여 <strong>공정거래위 산하 소비자 보호원 기준에 따라 아래와 같이 위약금 부과 처리에 관해 안내</strong> 하오니, 이용에 유의 하시기 바랍니다.</p>
										<h3>1.위약금 규정</h3>
										<ul class="tbl">
											<li><p class="tit">(극)성수기/패키지</p>
												<ul>
													<li>- 투숙예정일 15일 전까지 취소한 경우 예약금액 전액 환불</li>
													<li>- 투숙예정일 14~8일 전까지 취소한 경우 예약금액의 90% 환불</li>
												</ul>
											</li>
											<li><p class="tit">비&nbsp;수&nbsp;기</p>
												<ul>
													<li>- 투숙예정일 8일 전까지 취소한 겨우 예약금액 전액 환불</li>
												</ul>
											 </li>
											 <li><p class="tit">공&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;통</p>
											 	<ul>
											 		<li>- 투숙예정일 7~4일 전까지 취소한 경우 예약금액의 50% 환불</li>
											 		<li>- 투숙예정일 3일 전~당일 취소(No-show포함) 예약금액 환불 없음</li>
											 	</ul>
											 </li>
										</ul>
										<p>- 총 요금이란? 객실과 부가서비스를 선택한 총 합계 금액으로 포인트, 기프트카드, 할인액, 실결제액을 더한 금액입니다.</p>
										<h3>2.온라인예약취소</h3>
										<ul>
											<li>8일전까지는 온라인취소 가능</li>
											<li>  8일전~당일까지는 상하농원 고객센터(1522-3698)을 통해서만 취소가능하며, 위약금 규정에 따라 환불처리 됨</li>
										</ul>
									</div>
								</div>
							</li>
							<li><span>결제대행서비스 표준이용약관 </span><input type="checkbox" name="agree2" id="agree2"><span class="checkIcon"></span>
								<div class="agreeTxt">
									<div class="txtArea">	
										<h3>고유식별번호 수집 및 이용 동의</h3>
										<ol>
											<li>1. 주식회사 LG유플러스(이하 “회사”라 합니다)은 개인정보보호법에 의해 통신과금서비스 이용자(이하 “이용자”라 합니다)로 부터 아래와 같이 고유식별번호를 수집 및 이용합니다.</li>
											<li>2. 회사가 이용자의 고유식별번호를 수집, 이용하는 목적은 아래와 같습니다.
												<ol>
													<li>① 이용자가 구매한 재화나 용역의 대금 결제</li>
													<li>② 이용자가 결제한 거래의 취소 또는 환불</li>
													<li>③ 이용자가 결제한 거래의 청구 및 수납</li>
													<li>④ 이용자가 수납한 거래 대금의 정산</li>
													<li>⑤ 이용자가 결제한 거래의 내역을 요청하는 경우 응대 및 확인</li>
													<li>⑥ 통신과금서비스 이용 불가능한 이용자(미성년자 등)와 불량, 불법 이용자의 부정 이용 방지</li>
												</ol>
											</li>
											<li>3. 회사는 아래와 같이 이용자로부터 수집한 고유식별번호를 제3자에게 제공합니다.
												<table class="bbsList typeC">
													<thead>
														<tr>			
															<th scope="col">고유식별번호를 제공받는 자</th>
															<th scope="col">고유식별번호를 제공받는 자의 이용 목적</th>
															<th scope="col">제공받는 자의 고유식별번호 보유 및 이용 기간</th>
														</tr>
													</thead>
													<tbody>
														<tr>
															<td>주식회사 에스케이텔레콤, 주식회사 케이티</td>
															<td>이용자 본인 인증 및 거래 승인</td>
															<td>건당 거래 금액 1만원 초과의 경우 5년, 건당 거래 금액 1만원 이하의 경우 1년</td>
														</tr>
													</tbody>	
												</table>
											</li>		
											<li>회사가 수집한 이용자 고유식별번호의 보유, 이용 기간은 아래와 같습니다.
												<ol>
													<li>① 건당 거래 금액 1만원 초과의 경우: 5년간</li>
													<li>② 건당 거래 금액 1만원 이하의 경우: 1년간</li>
												</ol>
											</li>
										</ol>					
										<h3>개인정보 수집 및 이용 동의</h3>
										<p>㈜LG유플러스(이하 ‘회사’라 함)는 전자금융거래법 및 동법 시행령 상의 제반 사항, 전자상거래 등에서의 소비자보호에 관한 법률 및 전자상거래 등에서의 소비자보호 지침, 정보통신망 이용촉진 및 정보보호 등에 관한 법률 법률 제22조(개인정보의 수집 이용 동의 등) 및 개인정보보호법 제15조(개인정보의 수집 이용)에 의해 통신과금/전자금융서비스 이용자(이하 “이용자”라 합니다)로부터 아래와 같이 개인정보를 수집 및 이용합니다.</p>
										<h4>1. 수집하는 개인정보의 항목</h4>
										<ol>
											<li>가. 회사는 회원가입, 상담, 서비스 신청 등을 위해 아래와 같은 개인정보를 수집하고 있습니다. - 이름, 주민번호, 카드번호, 비밀번호, 전화번호, 휴대폰번호, 이메일, 사용자 IP Address, 쿠키, 서비스 이용기록, 결제기록, 결제정보 등</li>
											<li>나. “결제정보”라 함은 ”이용자”가 고객사의 상품 및 서비스를 구매하기 위하여 “회사”가 제공하는 ‘서비스’를 통해 제시한 각 결제수단 별 제반 정보를 의미하며 신용카드 번호, 신용카드 유효기간, 성명, 계좌번호, 주민등록번호, 휴대폰번호, 유선전화번호, 상품권번호 등을 말합니다.</li>
											<li>다. 회사는 서비스 이용과 관련한 대금결제, 물품배송 및 환불 등에 필요한 정보를 추가로 수집할 수 있습니다.</li>
										</ol>
										<h4>2. 개인정보의 수집 및 이용 목적</h4>
										<ol>
											<li>가. 회사는 다음과 같은 목적 하에 “결제서비스”와 관련한 개인정보를 수집합니다. - 사고 및 리스크 관리, 통계 활용, 결제결과 통보<br>
											- 신용카드, 계좌이체, 가상계좌, 휴대폰결제, 유선전화결제 등 결제서비스 제공, 결제결과 조회 및 통보</li>
											<li>나. 서비스 제공에 관한 계약 이행 및 서비스 제공에 따른 요금정산<br>
												- 서비스 가입, 변경 및 해지, 요금정산, A/S 등 서비스 관련 문의 등을 포함한 이용계약관련 사항의 처리<br>
												- 청구서 등의 발송, 금융거래 본인 인증 및 금융서비스, 요금추심 등</li>
											<li>다. 회사가 제공하는 서비스의 이용에 따르는 본인확인, 이용자간 거래의 원활한 진행, 본인의사의 확인, 불만처리, 새로운 정보와 고지사항의 안내, 상품 배송을 위한 배송지 확인, 대금결제서비스의 제공 및 환불입금 정보등 서비스 제공을 원할하게 하기 위해 필요한 최소한의 정보제공만을 받고 있습니다.</li>
										</ol>
										<h4>3. 개인정보의 보유 및 이용기간</h4>
										<p>이용자의 개인정보는 원칙적으로 개인정보의 수집 및 이용목적이 달성되면 지체 없이 파기합니다. 단, 다음의 정보에 대해서는 아래의 이유로 명시한 기간 동안 보존합니다.</p>
										<ol>
											<li>가. 회사 내부 방침에 의한 정보 보유 사유 - 본 전자결제서비스 계약상의 권리, 의무의 이행</li>
											<li>나. 관련법령에 의한 정보보유 사유 상법, 전자상거래 등에서의 소비자보호에 관한 법률 등 관계법령의 규정에 의하여 보존할 필요가 있는 경우 회사는 관계법령에서 정한 일정한 기간 동안 회원정보를 보관합니다. 이 경우 회사는 보관하는 정보를 그 보관의 목적으로만 이용하며 보존기간은 아래와 같습니다.
												<h5>* 계약 또는 청약철회 등에 관한 기록</h5>
												<ul>
													<li>보존 이유 : 전자상거래 등에서의 소비자보호에 관한 법률</li>
													<li>보존 기간 : 5 년 </li>
												</ul>
												<h5>* 대금결제 및 재화 등의 공급에 관한 기록</h5>
												<ul>
													<li>보존 이유 : 전자상거래 등에서의 소비자보호에 관한 법률</li>
													<li>보존 기간 : 5 년 </li>
												</ul>
												<h5>* 소비자의 불만 또는 분쟁처리에 관한 기록</h5>
												<ul>
													<li>보존 이유 : 전자상거래 등에서의 소비자보호에 관한 법률</li>
													<li>보존 기간 : 3 년</li>
												</ul>
												<h5>* 본인확인에 관한 기록</h5>
												<ul>
													<li>보존 이유 : 정보통신 이용촉진 및 정보보호 등에 관한 법률</li>
													<li>보존 기간 : 6 개월</li>
												</ul>
											</li>
										</ol>
										<h4>4. 개인정보 파기절차 및 방법</h4>
										<p>이용자의 개인정보는 원칙적으로 개인정보의 수집 및 이용목적이 달성되면 지체 없이 파기합니다. 회사의 개인정보 파기절차 및 방법은 다음과 같습니다.</p>
										<h5>가. 파기절차 </h5>
										<ul>
											<li>이용자가 회원가입 등을 위해 입력한 정보는 목적이 달성된 후 별도의 DB 로 옮겨져(종이의 경우 별도의 서류함) 내부 방침 및 기타 관련 법령에 의한 정보보호 사유에 따라(보유 및 이용기간 참조)일정 기간 저장된 후 파기됩니다.</li>
											<li>동 개인정보는 법률에 의한 경우가 아니고서는 보유되는 이외의 다른 목적으로 이용되지 않습니다.</li>
										</ul>
										<h5>나. 파기방법 </h5>
										<ul>
											<li>종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여 파기합니다.</li>
											<li>전자적 파일 형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제합니다.</li>
										</ul>
										<h3>개인정보 제공 및 위탁 동의</h3>
										<ol>
											<li>1. 주식회사 LG유플러스(이하 “회사”라 합니다)는 정보통신망 이용촉진 및 정보보호 등에 관한 법률 및 개인정보보호법에 의해 통신과금/전자금융서비스 이용자(이하 “이용자”라 합니다)로부터 수집한 개인정보를 아래와 같이 제3자에게 제공 및 위탁합니다.</li>
											<li>2. 회사는 아래와 같이 이용자로부터 수집한 개인정보를 제3자에게 제공, 위탁합니다.
												<table class="bbsList typeC">
													<colgroup>
														<col width="15%"><col width=""><col width="15%"><col width="15%">
													</colgroup>
													<thead>
														<tr>			
															<th scope="col">제공목적</th>
															<th scope="col">제공받는자</th>
															<th scope="col">제공정보</th>
															<th scope="col">보유 및 이용기간</th>
														</tr>
													</thead>
													<tbody>
														<tr>
															<td>신용카드 결제</td>
															<td>국민,비씨,롯데,삼성,NH농협,현대,외환,신한 4개 시중은행(신한/SC제일/씨티/하나), 3개 특수은행(농협,기업,국민), 3개 지방은행 (대구,부산,경남), 1개 전업카드사 (우리) (주)코밴, KIS정보통신,NICE정보통신, 브이피㈜, 한국신용카드결제(주), 퍼스트 데이터 코리아,㈜케이에스넷</td>
															<td>결제정보,IP Address</td>
															<td rowspan="13">개인정보는 원칙적으로 개인정보의 수집 및 이용목적이 달성되면 지체 없이 파기합니다 (단, 다른 법령에 특별한 규정이 있을 경우 관련 법령에 따라 보관)</td>
														</tr>
														<tr>
															<td>계좌이체 결제</td>
															<td>경남/광주/국민/기업/농협/대구/부산/산업/새마을금고/ 수협/신한/신협/외환/우리/우체국/전북/제주/하나/씨티/SC제일은행 동양/미래에셋/삼성/신한/한투/한화증권 결제서비스 제공업체 : CJ시스템즈, ㈜올앳, 갤럭시아커뮤니케이션즈㈜, ㈜다우기술</td>
															<td>결제정보,IP Address</td>
														</tr>
														<tr>
															<td>가상계좌입금 결제</td>
															<td>국민/농협/우리/신한/하나/기업/우체국/외환/부산/경남/ 대구/수협/씨티 /삼성증권</td>
															<td>결제정보</td>
														</tr>
														<tr>
															<td>휴대전화 결제</td>
															<td>㈜다날, ㈜인포허브, 갤럭시아커뮤니케이션즈㈜</td>
															<td>결제정보,IP Address</td>
														</tr>
														<tr>
															<td>유선전화 결제</td>
															<td>주식회사 케이티, 갤럭시아커뮤니케이션즈㈜, ㈜소프트가족</td>
															<td>결제정보</td>
														</tr>
														<tr>
															<td>상품권 결제</td>
															<td>한국문화진흥, 한국도서보급</td>
															<td>결제정보,IP Address</td>
														</tr>
														<tr>
															<td>포인트 결제</td>
															<td>SK마케팅앤컴퍼니 주식회사, GS넥스테이션 주식회사</td>
															<td>결제정보,IP Address</td>
														</tr>
														<tr>
															<td>본인확인서비스</td>
															<td>나이스신용평가정보, 한국신용평가정보㈜, 한국신용정보, SKT, KT, (주)코밴, KIS정보통신,NICE정보통신, 브이피㈜, 한국신용카드결제(주), 퍼스트 데이터 코리아,㈜케이에스넷 국민,비씨,롯데,삼성,NH농협,현대,외환,신한 경남/광주/국민/기업/농협/대구/부산/산업/새마을금고/ 수협/신한/신협/외환/우리/우체국/전북/제주/하나/씨티/SC제일</td>
															<td>결제정보</td>
														</tr>
														<tr>
															<td>티머니 결제</td>
															<td>주식회사 티모넷</td>
															<td>결제정보</td>
														</tr>
														<tr>
															<td>현금영수증</td>
															<td>국세청</td>
															<td>결제정보</td>
														</tr>
														<tr>
															<td>페이핀</td>
															<td>㈜SK플래닛</td>
															<td>결제정보</td>
														</tr>
														<tr>
															<td>휴대폰대체인증서비스</td>
															<td>㈜한국모바일인증, ㈜크레디프</td>
															<td>이름, 생년월일, 성별, 휴대폰번호</td>
														</tr>
														<tr>
															<td>실명인증</td>
															<td>나이스신용평가정보, 한국신용평가정보㈜, 한국신용정보</td>
															<td>결제정보</td>
														</tr>
													</tbody>	
												</table>		
											</li>
											<li>3. 회사는 통신과금/전자금융 서비스를 제공함에 있어서 취득한 이용자의 인적사항, 이용자의 계좌, 접근매체 및 통신과금의 내용과 실적에 관한 정보 또는 자료를 이용자의 동의를 얻지 아니하고 제3자에게 제공, 누설하거나 업무상 목적 외에 사용하지 아니합니다. 다만, 업무상 이용자 정보를 제3자에게 제공, 위탁할 경우 본 동의서 및 홈페이지(http://ecredit.uplus.co.kr)를 통해 이용자에게 고지를 합니다.</li>
											<li>4. 회사는 정보통신망 이용촉진 및 정보보호 등에 관한 법률(제7장 통신과금서비스)의 관련 규정에 의거하여 구성된 “유무선전화결제이용자보호협의회”가 이용자 보호를 위해 통신과금서비스 관련 정보를 요청하면 다음 각 호의 경우에는 관련 정보를 제공할 수 있습니다.
												<ol>
													<li>① 휴대폰깡, 대포폰, 복제폰 등 시장 질서를 교란시키는 불법업체 혹은 불법행위자에 의한 민원발생의 경우</li>
													<li>② 지인 사용 등 제3자 결제로 인한 민원발생의 경우</li>
													<li>③ 기타 통신과금서비스를 통한 불법행위가 발생하여 이용자 보호가 필요한 경우</li>
												</ol>
											</li>
											<li>5.	회사는 이용자의 개인정보를 원칙적으로 외부에 제공하지 않습니다 다만 아래의 경우에는 예외로 합니다.
												<ul>
													<li>이용자들이 사전에 동의한 경우 </li>
													<li>법령의 규정에 의거하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의 요구가 있는 경우</li>
												</ul>
											</li><li>6. 회사는 이용자의 동의없이 고객님의 정보를 외부 업체에 위탁하지 않습니다. 하단의 업체는 이용자에게 사전 통지 또는 동의를 얻어 위탁 업무를 대행하고 있습니다. 향후 위탁 대상자와 위탁 업무가 추가될 경우 이용자에게 사전 통지하고 필요한 경우 사전 동의를 받습니다.
												<table class="bbsList typeC">
													<colgroup>
														<col width="20%"><col width=""><col width="">
													</colgroup>
													<thead>
														<tr>			
															<th scope="col">서비스내용</th>
															<th scope="col">위탁업체</th>
															<th scope="col">목적</th>
														</tr>
													</thead>
													<tbody>
														<tr>
															<td>상품 배송정보 제공</td>
															<td>	㈜굿스플로</td>
															<td>배송정보 안내 서비스 제공</td>
														</tr>
														<tr>
															<td>채권추심	</td>
															<td>㈜한국신용정보, ㈜한국신용평가, ㈜미래신용정보</td>
															<td>채권추심 업무</td>
														</tr>
														<tr>
															<td>고객지원</td>
															<td>㈜LB휴넷, ㈜에이텍플러스, ㈜미디어로그</td>
															<td>고객상담 및 청약개통 업무지원 위탁수행 (고객센터 1544-7772)</td>
														</tr>
													</tbody>	
												</table>
											</li>
											<li>6. 제3자에게 제공된 개인정보의 보유, 이용 기간이 만료된 개인정보는 아래와 같은 방법으로 파기합니다.</li>
										</ol>
										<h3>통신과금 서비스 이용약관</h3>
										<h4>1.	제1조 (목적)</h4>
										<p>이 약관은 통신과금 서비스를 제공하는 주식회사 LG유플러스(이하 '회사'라 합니다)과 통신과금서비스이용자(이하 ‘이용자’라 합니다) 사이의 통신과금 서비스에 관한 기본적인 사항을 정함으로써 통신과금 서비스의 안정성과 신뢰성을 확보함에 그 목적이 있습니다.</p>
										<h4>2.	제2조 (용어의 정의)</h4>
										<p>이 약관에서 정하는 용어의 정의는 다음과 같습니다.</p>
										<ol>
											<li>
												1. 통신과금 서비스'라 함은 정보통신서비스로서 다음 각 항의 업무를 말합니다. 
												<ol>
													<li>① 타인이 판매, 제공하는 재화 또는 용역(이하 “재화 등”이라 합니다)의 대가를 자신이 제공하는 전기통신역무의 요금과 함께 청구, 징수하는 업무</li>
													<li>② 타인이 판매, 제공하는 재화 등의 대가가 전항의 업무를 제공하는 자의 전기통신역무의 요금과 함께 청구, 징수되도록 거래정보를 전자적으로 송수신하는 업무 또는 그 대가의 정산을 대행하거나 매개하는 업무</li>
												</ol>
											</li>
											<li>2. '이용자'라 함은 이 약관에 동의하고 회사가 제공하는 통신과금 서비스를 이용하는 자를 말합니다.</li>
											<li>3. '접근매체'라 함은 통신과금거래에 있어서 거래지시를 하거나 이용자 및 거래내용의 진실성과 정확성을 확보하기 위하여 사용되는 수단 또는 정보로서 유무선 전화 및 통신사에 등록된 이용자의 유무선 전화 번호, 이용자의 생체정보, 이상의 수단이나 정보를 사용하는 데 필요한 비밀번호 등을 말합니다</li>
											<li>4. '거래지시'라 함은 이용자가 통신과금 서비스계약에 따라 회사에게 통신과금 서비스의 처리를 지시하는 것을 말합니다. </li>
											<li>5. '가맹점'이라 함은 통신과금 서비스를 통하여 이용자에게 재화 또는 용역을 판매, 제공하는 자를 말합니다. </li>
										</ol>
										<h4>3.	제3조 (약관의 명시 및 변경)</h4>
										<ol>
											<li>1. 회사는 이용자가 통신과금 서비스를 이용하기 전에 이 약관을 게시하고 이용자가 이 약관의 중요한 내용을 확인할 수 있도록 합니다. </li>
											<li>2. 회사는 이용자의 요청이 있는 경우 전자문서의 전송방식에 의하여 본 약관의 사본을 이용자에게 교부합니다. </li>
											<li>3. 회사가 약관을 변경하는 때에는 그 시행일 2주 전에 변경되는 약관을 지급결제정보 입력화면 및 회사의 홈페이지에 게시함으로써 이용자에게 공지합니다 </li>
										</ol>
										<h4>4.	제4조 (접근매체의 관리 등)</h4>
										<ol>
											<li>1. 회사는 통신과금 서비스 제공 시 접근매체를 선정하여 이용자의 신원, 권한 및 거래지시의 내용 등을 확인할 수 있습니다. </li>
											<li>2. 이용자는 접근매체를 제3자에게 대여하거나 사용을 위임하거나 양도 또는 담보 목적으로 제공할 수 없습니다. </li>
											<li>3. 이용자는 자신의 접근매체를 제3자에게 누설 또는 노출하거나 방치하여서는 안 되며, 접근매체의 도용이나 위조 또는 변조를 방지하기 위하여 충분한 주의를 기울여야 합니다. </li>
											<li>4. 회사는 이용자로부터 접근매체의 분실이나 도난 등의 통지를 받은 때에는 그 때부터 제3자가 그 접근매체를 사용함으로 인하여 이용자에게 발생한 손해를 배상할 책임이 있습니다. </li>
										</ol>
										<h4>5.	제5조 (모니터링 및 해킹방지 시스템 구축)</h4>
										<ol>
											<li>1. 회사는 서버 및 통신기기의 정상작동여부 확인을 위하여 정보처리시스템 자원 상태의 감시, 경고 및 제어가 가능한 모니터링체계를 갖추어야 합니다. </li>
											<li>
												2. 회사는 해킹 침해 방지를 위하여 다음 각 호의 시스템 및 프로그램을 설치하여야 합니다. 
												<ol>
													<li>① 침입차단시스템 설치 </li>
													<li>② 침입탐지시스템 설치</li>
													<li>③ 그 밖에 필요한 보호장비 또는 암호프로그램 등 정보보호시스템 설치</li>
												</ol>
											</li>
										</ol>
										<h4>6.	제6조 (바이러스 감염 방지)</h4>
										<p>회사는 컴퓨터바이러스 감염을 방지하기 위하여 다음 각 호를 포함한 대책을 수립, 운용하여야 합니다.</p>
										<ol>
											<li>1. 출처, 유통경로 및 제작자가 명확하지 아니한 응용프로그램은 사용을 자제하고 불가피할 경우에는 컴퓨터바이러스 검색프로그램으로 진단 및 치료 후 사용할 것 </li>
											<li>2. 컴퓨터바이러스 검색, 치료 프로그램을 설치하고 최신 버전을 유지할 것 </li>
											<li>3. 컴퓨터바이러스 감염에 대비하여 방어, 탐색 및 복구 절차를 마련할 것 </li>
										</ol>
										<h4>7.	제7조 (이용자의 정보보호)</h4>
										<ol>
											<li>1. 회사는 정보통신망에 중대한 침해사고가 발생하여 회사의 서비스를 이용하는 이용자의 정보시스템 또는 정보통신망 등에 심각한 장애가 발생할 가능성이 있는 아래 각 호의 경우에는 이용자에 대한 보호조치를 전자우편, 공지사항 등의 방법으로 요청할 수 있습니다. 
												<ol>
													<li>① 사용자의 장비가 제3의 사용자에게 이용 당하여 회사의 서비스에 장애를 초래한 경우 </li>
													<li>② 사용자의 장비의 H/W 혹은 S/W의 문제로 회사의 서비스에 장애를 초래하는 경우 </li>
													<li>③ 사용자가 고의 혹은 실수로 회사의 악의적인 접속을 시도하거나 접속을 한 경우</li>
												</ol>
											</li>
											<li>2. 이용자가 취할 보호조치의 내용은 아래 각 호와 같습니다. 
												<ol>
													<li>① 해당 장비의 네트워크로부터 연결케이블 제거, 서비스 포트 차단, 네트워크 주소 차단 등의 즉각적인 분리 </li>
													<li>② 해당 장비에 대한 보안점검 </li>
													<li>③ 관련 원인점검 및 패치, OS재설치, 필터링 등의 사후 보안 조치 실시</li>
												</ol>
											</li>
											<li>3. 회사는 이용자가 전항의 보호조치를 이행하지 아니할 경우 정보통신망으로의 접속을 5일간 제한 할 수 있습니다. </li>
											<li>4. 회사가 이용자의 보호조치 불이행에 대하여 부당한 접속 제한을 한 경우 이용자는 제10조 제1항의 담당자에게 이의제기를 할 수 있으며, 회사는 이의제기를 접수 후 2주 이내로 사실을 확인하고, 이용자에게 서면으로 답변을 발송하여야 합니다. </li>
										</ol>
										<h4>제8조 (불법 거래 차단 시스템 구축)</h4>
										<ol>
											<li>1. 회사는 제3자의 불법적인 결제로부터 이용자를 보호하고, 이로 인한 이용자의 손해를 최소화하기 위해 다음 각 호와 같은 시스템을 구축하여야 합니다. 
												<ol>
													<li>① 비정상 거래 유형 분석 시스템 </li>
													<li>② 복제폰 이용 거래 탐지 시스템 </li>
													<li>③ 기타 불법결제 의심 거래 모니터링 시스템</li> 
												</ol>
											</li>
											<li>2. 회사는 본조 제1항 각 호의 시스템을 통해 불법적인 결제 요청으로 판단될 경우, 결제 요청을 차단할 수 있습니다. </li>
											<li>3. 본조 제1항에 의해 결제 요청이 차단된 경우, 이용자는 제15조 제1항의 담당자에게 연락을 하여 본인 확인 절차를 거친 후 통신과금 서비스를 이용할 수 있습니다. </li>
										</ol>
										<h4>제9조 (유무선전화결제이용자보호협의회)</h4>
										<ol>
											<li>1. 회사는 불법 과금, 복제폰, 휴대폰 깡, 및 불법 마케팅 등으로부터 이용자를 보호하기 위하여 유무선전화결제이용자보호협의회(이하 “전보협”이라 한다)의 구성원으로 참여하여, 이용자 보호 원칙을 선언한 “유무선전화결제이용자보호합의서”를 성실히 이행합니다. </li>
											<li>2. 회사는 전보협의 민원경보시스템 운영을 위해 항시 연락 가능한 담당자 1인을 아래와 같이 지정하여, 신속한 민원처리에 협조합니다. <br>
												담당자 : 정 훈<br>
												연락처(전화번호, 전자우편주소) 02)6719-8814 hunippp@lguplus.co.kr</li>
											<li>3. 회사는 전보협 운영위에서 심사하고, 전보협, 방송통신위원회에서 승인하여 제정한 가이드라인을 준수하며, 가맹점에게 가이드라인의 준수를 권고하고 지속적으로 모니터링 합니다.</li>
										</ol>
										<h4>제10조 (회사의 권리와 의무)</h4>
										<ol>
											<li>1. 회사가 접근매체의 발급주체가 아닌 경우에는 접근매체의 위조나 변조로 발생한 사고로 인하여 이용자에게 발생한 손해에 대하여 배상책임이 없습니다.</li>
											<li>2. 회사가 접근매체의 발급주체이거나 사용, 관리주체인 경우에는 접근매체의 위조나 변조로 발생한 사고로 인하여 이용자에게 발생한 손해에 대하여 배상책임이 있습니다.</li>
											<li>3. 회사는 계약체결 또는 거래지시의 전자적 전송이나 처리과정에서 발생한 사고로 인하여 이용자에게 손해가 발생한 경우에는 그 손해를 배상할 책임이 있습니다. 다만, 본조 제2항 단서에 해당하거나 법인('중소기업기본법' 제2조 제2항에 의한 소기업을 제외한다)인 이용자에게 손해가 발생한 경우로서 회사가 사고를 방지하기 위하여 보안절차를 수립하고 이를 철저히 준수하는 등 합리적으로 요구되는 충분한 주의의무를 다한 경우에는 그러하지 아니합니다.</li>
											<li>4. 회사는 이용자가 통신과금 서비스 이용 시 이용약관이나 안내사항 등을 확인하지 않아 발생한 손해, 또는 이용자가 제4조 제2항에 위반하거나 제3자가 권한 없이 이용자의 접근매체를 이용하여 통신과금서비스를 이용할 수 있음을 알았거나 알 수 있었음에도 불구하고 이용자가 자신의 접근매체를 누설 또는 노출하거나 방치한 손해 등 이용자의 부주의에 기한 손해에 대하여 배상 책임이 없습니다.</li>
											<li>5. 회사와 이용자 사이에 손해배상에 관한 협의가 성립되지 아니하거나 협의를 할 수 없는 경우에는 당사자는 방송통신위원회에 재정을 신청할 수 있습니다.</li>
											<li>6. 회사는 이용자에게 거래 금액 외에 일정금액의 수수료를 건당 부과할 수 있습니다. </li>
											<li>7. 회사는 통신사로부터 통신과금 서비스와 관련된 이용자의 개인정보를 제공받을 수 있으며, 회사는 위 제공받은 정보를 통신과금 서비스 외의 목적으로 사용할 수 없습니다. </li>
											<li>8. 회사는 컴퓨터 등 정보통신설비의 보수점검, 교체 및 고장, 통신의 두절 등의 사유가 발생한 경우에는 통신과금 서비스의 제공을 일시적으로 중단할 수 있습니다. </li>
											<li>9. 회사는 전항의 사유로 통신과금 서비스의 제공이 일시적으로 중단됨으로 인하여 이용자가 입은 손해에 대하여 배상합니다. 단, 회사가 고의 또는 과실이 없음을 입증한 경우에는 그러하지 아니합니다. </li>
											<li>10. 회사는 이용자가 전기통신역무의 요금과 함께 청구된 재화 등의 대가를 통신사가 지정한 기일까지 납입하지 아니한 때에는 그 요금의 100분의 2에 상당하는 가산금을 부과합니다. </li>
											<li>11. 이베이코리아(옥션, G마켓), 쿠팡, 위메프, 티몬, 골프존, 잡코리아 등은 엘지유플러스 전자결제서비스 이용에 따른 판매 대금 정산금 채권에 대하여 엘지유플러스의 당사에 대한 선정산 지급으로 엘지유플러스에 양도되었음을 통지합니다. </li>
										</ol>
										<h4>제11조 (고지사항)</h4>
										<p>회사는 재화 등의 판매, 제공의 대가를 청구할 때 이용자에게 다음 각 호의 사항을 고지하여야 합니다.</p>
										<ol>
											<li>1. 통신과금서비스 이용일시</li>
											<li>2. 통신과금서비스를 통한 구매,이용의 거래 상대방(통신과금서비스를 이용하여 그 대가를 받고 재화 또는 용역을 판매,제공하는 자를 말하며, 이하 “거래 상대방”이라 합니다)의 상호와 연락처</li>
											<li>3. 통신과금서비스를 통한 구매,이용 금액과 그 명세</li>
											<li>4. 이의신청 방법 및 연락처</li>
										</ol>
										<h4>제12조 (거래내용의 확인)</h4>
										<ol>
											<li>1. 회사는 이용자가 구매,이용 내역을 확인할 수 있는 방법을 제공하여야 하며, 이용자가 구매,이용 내역에 관한 서면(전자문서를 포함한다. 이하 같다)을 요청하는 경우에는 그 요청을 받은 날부터 2주 이내에 이를 제공하여야 합니다. </li>
											<li>
												2. 회사는 다음 각 호의 사항에 관한 기록을 해당 거래를 한 날부터 1년간 보존하여야 합니다. 다만, 건당 거래 금액이 1만원을 초과하는 거래인 경우에는 5년간 보존하여야 합니다. 
												<ol>
													<li>① 통신과금서비스를 이용한 거래의 종류 </li>
													<li>② 거래 금액 </li>
													<li>③ 거래 상대방 </li>
													<li>④ 거래 일시 </li>
													<li>⑤ 대금을 청구,징수하는 전기통신역무의 가입자번호 </li>
													<li>⑥ 회사가 통신과금 서비스 제공의 대가로 수취한 수수료에 관한 사항 </li>
													<li>⑦ 해당 거래와 관련한 전기통신역무의 접속에 관한 사항 </li>
													<li>⑧ 거래의 신청 및 조건의 변경에 관한 사항 </li>
													<li>⑨ 거래의 승인에 관한 사항</li>
													<li>⑩ 그 밖에 방송통신위원회가 정하여 고시하는 사항</li>
												</ol>
											</li>
											<li>3. 전항에 따른 거래기록은 서면, 마이크로필름, 디스크, 자기테이프, 그 밖의 전산정보처리조직에 의하여 보존하여야 합니다. 다만, 디스크, 자기테이프, 그 밖의 전산정보처리조직에 의하여 보존하는 경우에는 전자거래기본법 제5조 제1항 각 호의 요건을 모두 갖추어야 합니다.</li>
											<li>4. 이용자가 제1항에서 정한 서면교부를 요청하고자 할 경우 다음의 주소 및 전화번호로 요청할 수 있습니다.
												<ul>
													<li>주소: 서울 중구 남대문로5가 827번지 LG유플러스 전자금융사업팀</li>
													<li>이메일 주소: hunippp@lguplus.co.kr</li>
													<li>전화번호: 1544-7772</li>
												</ul>
											</li>
										</ol>
										<h4>제13조 (정정 요구)</h4>
										<p>이용자는 통신과금서비스가 자신의 의사에 반하여 제공되었음을 안 때에는 회사에게 이에 대한 정정을 요구할 수 있으며(이용자의 고의 또는 중과실이 있는 경우는 제외한다), 회사는 그 정정 요구를 받은 날부터 2주 이내에 처리 결과를 알려 주어야 한다.</p>
										<h4>제14조 (통신과금정보의 제공금지)</h4>
										<ol>
											<li>1. 회사는 통신과금 서비스를 제공함에 있어서 취득한 이용자의 인적사항, 이용자의 계좌, 접근매체 및 통신과금의 내용과 실적에 관한 정보 또는 자료를 이용자의 동의를 얻지 아니하고 제3자에게 제공, 누설하거나 업무상 목적 외에 사용하지 아니합니다. 다만, 업무상 이용자 정보를 제3자에게 제공할 경우 본 약관 및 홈페이지(http://ecredit.uplus.co.kr)을 통해 이용자에게 고지를 합니다. </li>
											<li>
											2. 회사는 정보통신망이용촉진및정보보호등에관한법률 (제7장 통신과금서비스)의 관련규정에 의거하여 구성된 “유무선전화결제이용자보호협의회”가 이용자 보호를 위해 통신과금서비스 관련 정보를 요청하면 다음 각 호의 경우에는 관련 정보를 제공할 수 있습니다. 
											<ol>
												<li>① 휴대폰깡, 대포폰, 복제폰 등 시장 질서를 교란시키는 불법업체 혹은 불법행위자에 의한 민원발생의 경우 </li>
												<li>② 지인 사용 등 제3자 결제로 인한 민원발생의 경우</li>
												<li>③ 기타 통신과금서비스를 통한 불법행위가 발생하여 이용자 보호가 필요한 경우</li>
											</ol>
											</li>
											<li>3. 회사는 통신과금 서비스의 거래 내역 확인 및 서비스 상담 등의 이용자 편의 업무를 위해서 아래와 같이 이용자 정보를 제공하고 있습니다. 개인정보를 제3자에게 제공, 위탁 제공 받는 자 제공하는 항목 목적 
											LB 휴넷 휴대전화 번호, 거래 일시, 거래 금액, 거래 상대방 결제정보,IP Address 거래 내역 확인 및 서비스 상담</li>
										</ol>
										<h4>제15조 (이의신청 및 권리구제)</h4>
										<ol>
											<li>1. 이용자는 다음의 보호책임자 및 담당자에 대하여 이의신청 및 권리구제를 요청할 수 있습니다. <br>
												담당자 : 정 훈<br>
												연락처(전화번호, 전자우편주소) : 02)6719-8814, hunippp@lguplus.co.kr </li>
											<li>2. 이용자는 서면(전자문서를 포함한다), 전화, 모사전송 등을 통하여 회사에게 통신과금서비스와 관련된 이의신청을 할 수 있습니다.</li>
											<li>3. 회사는 제2항에 따른 이의신청을 받은 날부터 2주일 이내에 그 조사 또는 처리 결과를 이용자에게 알려야 합니다. </li>
										</ol>
										<h4>제16조 (회사의 안정성 확보 의무)</h4>
										<p>회사는 통신과금 서비스의 안전성과 신뢰성을 확보할 수 있도록 통신과금 서비스의 종류별로 전자적 전송이나 처리를 위한 인력, 시설, 전자적 장치 등의 정보기술부문 및 통신과금업무에 관하여 방송통신위원회가 정하는 기준을 준수합니다.</p>
										<h4>제17조 (약관외 준칙 및 관할)</h4>
										<ol>
											<li>1. 이 약관에서 정하지 아니한 사항에 대하여는 정보통신망 이용촉진 및 정보보호 등에 관한 법률, 전자금융거래법, 전자상거래 등에서의 소비자 보호에 관한 법률, 통신판매에 관한 법률, 여신전문금융업법 등 소비자보호 관련 법령에서 정한 바에 따릅니다.</li>
											<li>2. 회사와 이용자간에 발생한 분쟁에 관한 관할은 민사소송법에서 정한 바에 따릅니다.</li>
										</ol>
									</div>
								</div>
							</li>
							<li><span>개인정보 수집 및 이용에 대한 동의 </span><input type="checkbox" name="agree3" id="agree3"><span class="checkIcon"></span>
								<div class="agreeTxt">
									<div class="txtArea">
										<p>파머스호텔 객실예약 시 수집된 정보는 객실 및 상담 관련 서비스를 제공하기 위하여서만 사용되며, 제공받은 목적을 달성되면 파기합니다.</p>
										<ol>
											<li>1. 수집항목
												<ol>
													<li>- 객실 예약: 예약자정보(ID, 이름, 연락처, 투숙일, 객실타입, 인원수, 객실수, 요청사항, 결제정보), 투숙자정보(이름, 연락처) </li>
													<li>- 객실 문의: 문의자 정보(ID, 이름, 연락처, 이메일), 문의내용</li>
													<li>- 다이닝 문의: 문의자 정보(ID, 이름, 연락처, 이메일), 문의내용 (시설, 이용예정일, 인원 등)</li>
													<li>- 웨딩, 연회 문의: 문의자 정보(ID, 이름, 연락처, 이메일), 문의내용 (시설, 이용예정일, 인원 수 등)</li>
													<li>- 세미나 문의 : 문의자 정보(ID, 이름, 연락처, 이메일), 문의내용 (시설, 이용예정일, 인원 수 등)</li>
													<li>- 기타 문의:  문의자 정보(ID, 이름, 연락처, 이메일), 문의내용</li>
												</ol>
											</li>
											<li>2. 수집방법: 객실예약 시, 시설관련 문의 시</li>
											<li>3. 수집목적: 객실예약처리, 객실체크인처리, 객실 및 숙박관련 상담 처리 및 불만 처리</li>
											<li>4. 보유기간: 예약 또는 문의 발생일로부터 3년</li>
											<li>5. 개인정보 위탁 <br>서비스를 제공하기 위하여 개인정보 취급업무는 외부 전문업체에 의뢰하여 위탁 운영하고 있습니다. 
												<table class="bbsList typeC">
													<colgroup>
														<col width="25%"><col width="25%"><col width="25%"><col width="25%">
													</colgroup>
													<thead>
														<tr>			
															<th scope="col">위탁 목적</th>
															<th scope="col">위탁 제휴사</th>
															<th scope="col">보유 및 이용기간</th>
															<th scope="col">위탁 정보</th>
														</tr>
													</thead>
													<tbody>
														<tr>
															<td>전산 처리 및 시스템 유지 관리</td>
															<td>㈜ 이퓨전아이<br>㈜ 티유정보기술<br>㈜ 진코퍼레이션</td>
															<td>회원 탈퇴시 혹은 위탁 계약 종료시 까지</td>
															<td>회원정보 전체</td>
														</tr>
														<tr>
															<td>회원제 관리 및 시스템 유지 관리</td>
															<td>㈜ 매일유업<br>㈜아이비즈소프트웨어</td>
															<td>회원 탈퇴시 혹은 위탁 계약 종료시 까지</td>
															<td>회원정보 전체</td>
														</tr>
														<tr>
															<td>본인 확인을 위한 휴대폰 인증</td>
															<td>㈜서울신용평가</td>
															<td>위탁 목적이 달성 될 때 까지</td>
															<td>본인 식별 정보</td>
														</tr>
														<tr>
															<td>상품 구매, 체험 예약 시 결제</td>
															<td>㈜ LG 유플러스<br>엔에이치엔페이코(주)<br>㈜카카오페이</td>
															<td>위탁 목적이달성 될 때 까지</td>
															<td>결제정보 전송, 결제대행 업무</td>
														</tr>
													</tbody>	
												</table>
											</li>
											<li>6. 개인정보의 파기절차 및 방법<br>회사는 개인정보 수집 및 이용목적이 달성된 해당 정보를 지체 없이 파기합니다. 파기절차 및 방법은 다음과 같습니다.
												<ol>
													<li>6.1파기절차<br>
														가) 회원가입 및 서비스 신청 등을 위하여 입력하신 정보는 목적이 달성된 후 내부 방침 및 기타 관련 법령에 의한 정보보호 사유에 따라(보유 및 이용기간 참조) 일정 기간 저장된 후 파기합니다.<br>
														나) 동 개인정보는 법률에 의한 경우가 아니고서는 보유 이외의 다른 목적으로 이용되지 않습니다.
													</li>
													<li>6.2파기방법<br>
														가) 전자적 파일형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제합니다.<br>
														나) 종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각합니다.
													</li>
												</ol>
											</li>
										</ol>
										
									</div>
								</div>
							</li>
						</ul>
						<p class="agreeChk">전체 동의 <input type="checkbox" name="checkall" id="checkall" onclick="checkAll()"></p>
					</div>
				</div>
				<!-- //infoCont -->
			
				<!-- choiceInfoWrap -->
				<div class="choiceInfoWrap" id="choiceInfoWrap">
					<h2>전체 예약정보</h2>
					<!-- choiceInfo -->
					<div class="choiceInfo">
						<div class="top">
							<ul>
								<li>체크인<span><%= param.get("chki_date") %></span></li>
								<li>체크아웃<span><%= param.get("chot_date") %></span></li>
							</ul>
							<span class="dateNum">(<%= Utils.formatMoney(night) %>박)</span>
						</div>
						<div class="middle" id="room_list">
							<p class="tit">객실</p>
							<ul>
								<li class="first"><%= info.get("pnm") %><span><%= param.get("qty") %> 객실</span></li>
<%
	for(int i = 1; i <= param.getInt("qty"); i++) {
%>
								<li>객실 <%= i %><span>성인 <%= param.get("adult" + i) %> , 어린이 <%= param.get("child" + i) %></span></li>
<%
	}
%>
							</ul>
						</div>
						<div class="bottom">
							<ul>
								<li class="discount">예약 소계<span><%= Utils.formatMoney(defaultPrice) %>원</span></li>
								<li class="discount">스페셜 오퍼<span>-<%= Utils.formatMoney(defaultPrice - price) %>원</span></li>
								<li>총 예약금액<span><%= Utils.formatMoney(price) %>원</span></li>
							</ul>
						</div>
						<div class="choiceInfoBtn">
							<a href="javascript:goPrev()" class="btnStyle02">이전</a><a href="javascript:goNext()" class="btnStyle01">다음</a>
						</div>
					</div>
					<!-- //choiceInfo -->
				</div>
				<!-- //choiceInfoWrap -->
				</form>
			</div>
			<!-- //customerInfo -->
		</div>
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
