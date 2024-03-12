<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.service.code.*,
			com.sanghafarm.utils.*" %>
<%
	request.setAttribute("Depth_1", new Integer(2));
	request.setAttribute("Depth_2", new Integer(4));
	request.setAttribute("Depth_3", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("파머스빌리지 상담"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");

	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	
	CodeService code = new CodeService();
	List<Param> cateList = code.getList2("036");
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<link rel="stylesheet" type="text/css" href="/css/jquery-ui-timepicker-addon.css">
<script type="text/javascript" src="/js/timepicker/jquery-ui-timepicker-addon.js"></script>
<script type="text/javascript" src="/js/timepicker/localization/jquery-ui-timepicker-ko.js"></script>
<script>
	var v;
	var isProgress = false;

	$(function () {		
		v = new ef.utils.Validator($("#hotelCounselForm"));
		v.add("name", {
			empty : "이름을 입력해주세요."
		});
		v.add("mobile2", {
			empty : "연락처를 숫자로 입력해주세요.",
			max : 4,
			min: 3,
			format : "numeric"
		});
		v.add("mobile3", {
			empty : "연락처를 숫자로 입력해주세요.",
			max : 4,
			min: 3,
			format : "numeric"
		});
		v.add("title", {
			empty : "제목을 입력해주세요."
		});
		v.add("question", {
			empty : "내용을 입력해주세요."
		});
		
<%
	if(!fs.isLogin()) {
%>
		v.add("passwd", {
			empty : "비밀번호를4자 이상 입력해주세요.",
			min : 4,
			max : 20
		});
<%
	}
%>
		$("input[name='date1_002']").datepicker({
	        showOn: "button",
	        buttonImage: "/images/btn/btn_calender2.png",
	        dateFormat: 'yy.mm.dd',
	        buttonImageOnly: true
	    });
		
		$("input[name='date1_003']").datepicker({
	        showOn: "button",
	        buttonImage: "/images/btn/btn_calender2.png",
	        dateFormat: 'yy.mm.dd',
	        buttonImageOnly: true
	    });

		$("input[name='date2_003']").datepicker({
	        showOn: "button",
	        buttonImage: "/images/btn/btn_calender2.png",
	        dateFormat: 'yy.mm.dd',
	        buttonImageOnly: true
	    });
		
		$("input[name='date1_004']").datepicker({
	        showOn: "button",
	        buttonImage: "/images/btn/btn_calender2.png",
	        dateFormat: 'yy.mm.dd',
	        buttonImageOnly: true
	    });

		setForm();
	});
	
	function goRegist() {
		if(!isProgress) {
			if(v.validate()) {
				if($("#agree").prop("checked")) {
					if(confirm("등록 하시겠습니까?")) {
						isProgress = true;
						$("#hotelCounselForm").submit();
	 				}
				} else {
					alert("개인 정보 수집 및 이용에 대한 동의가 필요합니다.");
				}
			}
		}
	}
	
	function setForm() {
		var cate = $("#cate").val();
		$("#hotelCounselForm .cate").hide();
		$("." + cate).show();
		
		if(cate == '004') {
			$("#question_txt").html("* 추가 문의 및<br>요청사항");
		} else {
			$("#question_txt").html("* 내용");
		}
	}	
	
	function setUser(b) {
		if(b) {
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
</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
		<div id="contArea">
			<h1 class="typeA"><%=MENU_TITLE %></h1>
			<!-- 내용영역 -->	
			<div class="cautionBox">
				<p class="caution">문의하신 내용에 대한 답변은 <a href="/mobile/mypage/board/hotelCounsel.jsp" class="fontTypeA">마이페이지 &gt; 파머스빌리지 상담내역</a>에서 확인하실 수 있습니다.</p>
				<p class="caution">비회원 문의는 SMS로 답변 드립니다.</p>
			</div>
			<form class="" name="hotelCounselForm" id="hotelCounselForm" method="post" action="/customer/hotelCounselProc.jsp" enctype="multipart/form-data">
				<input type="hidden" name="mode" id="mode" value="CREATE" />
				<input type="hidden" name="device_type" id="device_type" value="<%= fs.getDeviceType() %>" />
				<table class="bbsForm typeB">
					<caption>1:1 상담 입력폼</caption>
					<colgroup>
						<col width="85"><col width="">
					</colgroup>
					<tr>
						<th scope="row"><label for="type">* 문의유형</label></th>
						<td>
							<select name="cate" id="cate" onchange="setForm()">
<%
	for(Param row : cateList) {
%>
								<option value="<%= row.get("code2") %>"><%= row.get("name2") %></option>
<%
	}
%>
							</select>
						</td>
					</tr>
					<tr>
						<th><label for="type">* 이름</label></th>
						<td>
							<input type="text" name="name" id="name" maxlength="10"> 
<%
	if(fs.isLogin()) {//회원일때
%>	
							<div class="setUser"><input type="checkbox" name="infoCopy" onclick="setUser(this.checked)"><span>고객 정보 동일</span></div>
<%
	}
%>
						</td>
					</tr>
					<tr>
						<th><label for="type">성별</label></th>
						<td>
							<input type="radio" name="gender" id="man" value="M" checked><span>남</span> 
							<input type="radio" name="gender" id="woman" value="F"><span>여</span>
						</td>
					</tr>
					<tr>
						<th><label for="type">* 연락처</label></th>
						<td>
							<select name="mobile1" id="mobile1">
<%
	for(String mobile : SanghafarmUtils.MOBILES) {
%>
								<option value="<%= mobile %>"><%= mobile %></option>
<%
	}
%>
							</select> 
							 - <input type="text" name="mobile2" id="mobile2" style="width:70px;">
							 - <input type="text" name="mobile3" id="mobile3" style="width:70px;">
						</td>
					</tr>
<%
	if(!fs.isLogin()) {	//비회원일때
%>
					<tr>
						<th><label for="type">* 비밀번호</label></th>
						<td><input type="password" name="passwd" id="passwd"><span>비회원 SMS 답변 확인 시 해당 비밀번호로 확인 가능합니다.</span></td>
					</tr>
<% 
	} 
%>
					<!-- 다이닝 -->
					<tr class="cate 002">
						<th scope="row"><label for="type">업장 선택</label></th>
						<td>
							<select name="gubun_002" id="gubun_002">
								<option value="조식뷔페">조식뷔페</option>
								<option value="웰컴라운지">웰컴라운지</option>
							</select>
						</td>
					</tr>
					<tr class="cate 002">
						<th scope="row"><label for="type">이용 일자</label></th>
						<td class="availableDates">
							<div class="calInput">
								<input type="text" name="date1_002" title="이용일자" value="" readonly>
							</div>
						</td>
					</tr>
					<tr class="cate 002">
						<th scope="row"><label for="type">이용 인원</label></th>
						<td>
							<input type="text" name="person_002" id="person_002" title="이용 인원" maxlength="10" onkeydown="return onlyNumber(event);" onkeyup="removeChar(event);"><span>명</span>
						</td>
					</tr>
					
					<!-- 웨딩&연회 -->
					<tr class="cate 003">
						<th scope="row"><label for="type">행사 구분</label></th>
						<td>
							<select name="gubun_003" id="gubun_003">
								<option value="웨딩">웨딩</option>
								<option value="연회">연회</option>
							</select>
						</td>
					</tr>
					<tr class="cate 003">
						<th scope="row"><label for="type">일자 및<br>시간</label></th>
						<td class="availableDates">
							<div class="inputWrap">
								<strong>1 순위</strong>
								<div class="calInput">
									<input type="text" name="date1_003" title="이용일자" value="" readonly>
								</div>
								<select name="time_from1_003" id="time_from1_003">
<% 
	for(int i = 0; i <= 24; i++) {
 			String hour = i < 10 ? "0" + i : "" + i;
%>
									<option value="<%= hour %>:00"><%= hour %>:00</option>
<%
	}
%>
								</select> ~
								<select name="time_to1_003" id="time_to1_003">
<% 
	for(int i = 0; i <= 24; i++) {
 			String hour = i < 10 ? "0" + i : "" + i;
%>
									<option value="<%= hour %>:00"><%= hour %>:00</option>
<%
	}
%>
								</select>	
							</div>
							<div class="inputWrap">
								<strong>2 순위</strong>
								<div class="calInput">
									<input type="text" name="date2_003" title="이용일자" value="" readonly>
								</div>
								<select name="time_from2_003" id="time_from2_003">
<% 
	for(int i = 0; i <= 24; i++) {
 			String hour = i < 10 ? "0" + i : "" + i;
%>
									<option value="<%= hour %>:00"><%= hour %>:00</option>
<%
	}
%>
								</select> ~
								<select name="time_to2_003" id="time_to2_003">
<% 
	for(int i = 0; i <= 24; i++) {
 			String hour = i < 10 ? "0" + i : "" + i;
%>
									<option value="<%= hour %>:00"><%= hour %>:00</option>
<%
	}
%>
								</select>	
							</div>						
						</td>
					</tr>
					<tr class="cate 003">
						<th scope="row"><label for="type">참석 예상<br>인원</label></th>
						<td>
							<input type="text" name="person_003" id="person_003" title="참석 예상인원" maxlength="10" onkeydown="return onlyNumber(event);" onkeyup="removeChar(event);"><span>명</span>
						</td>
					</tr>
				
					<!-- 세미나 -->
					<tr class="cate 004">
						<th scope="row"><label for="type">행사 구분</label></th>
						<td>
							<select name="gubun_004" id="gubun_004">
								<option value="세미나">세미나</option>
								<option value=단체행사>단체행사</option>
								<option value="기타">기타</option>
							</select>
						</td>
					</tr>
					<tr class="cate 004">
						<th scope="row"><label for="type">기업명</label></th>
						<td><input type="text" name="company_004" id="company_004" maxlength="20"></td>
					</tr>
					<tr class="cate 004">
						<th scope="row"><label for="type">일자 및<br>시간</label></th>
						<td class="availableDates">
							<div class="calInput">
								<input type="text" name="date1_004" title="이용일자" value="" readonly>
							</div>
							<select name="time_from1_004" id="time_from1_004">
<% 
	for(int i = 0; i <= 24; i++) {
 			String hour = i < 10 ? "0" + i : "" + i;
%>
									<option value="<%= hour %>:00"><%= hour %>:00</option>
<%
	}
%>
							</select> ~
							<select name="time_to1_004" id="time_to1_004">
<% 
	for(int i = 0; i <= 24; i++) {
 			String hour = i < 10 ? "0" + i : "" + i;
%>
									<option value="<%= hour %>:00"><%= hour %>:00</option>
<%
	}
%>
							</select>	
						</td>
					</tr>
					<tr class="cate 004">
						<th scope="row"><label for="type">참석 예상<br>인원</label></th>
						<td>
							<input type="text" name="person_004" maxlength="10" onkeydown="return onlyNumber(event);" onkeyup="removeChar(event);"><span>명</span>
						</td>
					</tr>
					<tr class="cate 004">
						<th scope="row"><label for="type">객실 사용<br>여부</label></th>
						<td>
							<input type="radio" name="room_yn_004" value="Y" checked><span>예</span>
							<input type="radio" name="room_yn_004" value="N"><span>아니오</span>
						</td>
					</tr>
				
					<tr>
						<th scope="row"><label for="title">* 제목</label></th>
						<td><input type="text" name="title" id="title" style="width:100%;" maxlength="20"></td>
					</tr>
					<tr>
						<th scope="row"><label for="cont" id="question_txt">내용</label></th>
						<td><textarea id="question" name="question" style="width:100%;height:250px;" placeholder="문의주신 내용은 순차적으로 확인 후 연락을 드리고 있습니다. 시간이 소요되는 점 양해 부탁드립니다.
웨딩 관련하여 상담을 원하시는 고객님께서는 카카오톡 채널 &lt;상하농원 웨딩&gt;을 검색하여 채팅 문의 주시면 원활한 상담이 가능합니다."></textarea></td>
					</tr>
					<tr class="cate 004">
						<th scope="row"><label for="imageName">견적 문의</label></th>
						<td>
							<p class="fileBox">
								<a href="/files/hotel/파머스빌리지_행사견적요청양식_2018.docx<%=fs.isApp() ? "?target=web" : ""%>" target="_blank"  class="btnTypeA">견적 요청 양식 업로드</a>
							</p>
							<span>모바일에서는 견적요청 양식 다운로드만 가능합니다.</span>
							<span>보다 자세한 견적요청을 원하시는 분들은 다운 받은 파일에 세부내용을 기재하여, PC(고객센터 > 파머스빌리지상담)에서 재문의 해주세요.</span>
						</td>
					</tr>
				</table>
				
				<div class="agreeWrap">
					<label for="type">개인 정보 수집 및 이용에 대한 동의 <em>(필수)</em></label>
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
					<input type="checkbox" name="agree" id="agree"><span>개인정보 수집 및 이용에 동의합니다.</span>
				</div>
				<div class="btnArea ac">
					<span><a href="#" onClick="goRegist();" class="btnTypeB">등록</a></span>
				</div>
			</form>
			<!-- //내용영역 -->
		</div><!-- //contArea -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>