<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			java.text.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.service.code.*" %>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	/* if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessage(out, FrontSession.LOGIN_MSG, request);
		return;
	} */
	
	CodeService code = (new CodeService()).toProxyInstance();
	List<Param> list = code.getList2("026");
%>
<html>
    <head>
     
  		 <meta charset="utf-8">
        <meta http-equiv="imagetoolbar" content="no">
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1,user-scalable=no">
        <meta name="title" content="">
        <meta name="publisher" content="">
        <meta name="author" content="">
        <meta name="robots" content="index,follow">
        <meta name="keywords" content="">
        <meta name="description" content="">
        <meta name="twitter:card" content="summary_large_image">
        <meta property="og:title" content="">
        <meta property="og:site_name" content="">
        <meta property="og:author" content="">
        <meta property="og:type" content="">
        <meta property="og:description" content="">
        <meta property="og:url" content="">
        
        <title>상하목장</title>
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reset.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/new_common.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
 <%--        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main_style.css"> --%>

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/sub.js"></script>
        
        <link rel="stylesheet" href="https://code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" type="text/css" />
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
        <script src="https://code.jquery.com/ui/1.8.18/jquery-ui.min.js"></script>
        
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
        <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
        <script src="/js/efusioni.js?t=<%=System.currentTimeMillis()%>"></script>
        <script src="/js/common.js?t=<%=System.currentTimeMillis()%>"></script>
   <script>
	var v;

	$(function(){
		v = new ef.utils.Validator($("#reserveForm"));
		
		v.add("group_nm", {
			"empty" : "단체명을 입력해 주세요.",
			"max" : 20
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
		v.add("exp_num", {
			"empty" : "체험인원을 입력해 주세요.",
			"max" : 6,
			"format" : "numeric"
		});
		v.add("see_num", {
			"empty" : "참관인원을 입력해 주세요.",
			"max" : 6,
			"format" : "numeric"
		});

	//	efuSlider('.calenderArea', 1, 0, '', 'once');	
	});	
	
	function removeChar(event) {
	    event = event || window.event;
	    var target = event.target || event.srcElement;
	    var nonDigits = /[^0-9]/g; // 숫자가 아닌 모든 문자를 찾는 정규 표현식
	    target.value = target.value.replace(nonDigits, ''); // 숫자가 아닌 문자 제거
	}
	
	function onlyNumber(event) {
	    // 이벤트가 없으면 글로벌 이벤트를 사용
	    event = event || window.event;
	    
	    // 키 코드 또는 이벤트 키를 사용하여 식별
	    var key = event.key || event.keyCode || event.which;
	    
	    // 숫자, 백스페이스, 삭제, 방향키, 탭 키를 확인하는 조건
	    var isAllowedKey = (key >= '0' && key <= '9') ||
	                       ['Backspace', 'Delete', 'ArrowLeft', 'ArrowRight', 'Tab'].includes(key) ||
	                       (event.keyCode >= 96 && event.keyCode <= 105); // 숫자 패드

	    if (!isAllowedKey) {
	        // 조건에 맞지 않는 입력은 이벤트를 취소
	        event.preventDefault();
	    }
	}
	
	function ajaxSubmit(form, callback) {
		var isJQueryObject = form instanceof jQuery;
		var jForm = (isJQueryObject ? form : $(form));

		var formData = jForm.serialize();

		/*action 페이지에서는 결과 json을 출력해야 한다. 예 {"isOk" : true, "msg" : "등록되었습니다."}*/
		$.ajax({
			type : "POST",
			url : jForm.attr("action"),
			data : formData,
			dataType : "json",
			success : function(result) {
				callback(result);
			},
			fail : function() {
				callback({isOk : false, msg : "서버오류가 발생했습니다."});
			}
		});
	}

	function step1(obj, date) {
		$(".calenderArea .choice").removeClass("choice");
		$(obj).parent().addClass("choice");
		
		$("#reserve_date").val(date);
		
		$.ajax({
			method : "POST",
			url : "expList1.jsp",
			data : { date : date },
			dataType : "html"
		})
		.done(function(html) {
			$("#exp_type").empty().html("<option value=''>선택없음</option>");
			$("#exp_type").append($.trim(html));
		});
	}
	
	function proc() {
		if(v.validate()) {
			if($("#reserve_date").val() == "") {
				alert("예약일자를 선택하세요.");
				return;
			}
			
			if(!$("#agree1").prop("checked")) {
				alert("취소/환불 규정에 대한 동의는 필수입니다.");
				return;
			}

			if(!$("#agree2").prop("checked")) {
				alert("예약내역동의는 필수입니다.");
				return;
			}

			ajaxSubmit($("#reserveForm"), function(json) {
				alert(json.msg);
				if(json.result) {
					document.location.href="/";
				}
			});
		}
	}
	
	
$(document).ready(function(){

	 // 이용약관 관련  전체 동의 이벤트
   $("#agreeAll").click(function() {    	
		if($("#agreeAll").is(":checked")){ 
			$("input[name=partyResCheck]").prop("checked", true);
			$("#memberAgree").prop("checked", true);
		}else{ 
			$("input[name=partyResCheck]").prop("checked", false);
			$("#memberAgree").prop("checked", false);
		}
	});
   // 이용약관 관련  전체 동의 이벤트
   $("#memberAgree").click(function() {    	
		if($("#agreeAll").is(":checked")){ 
			$("input[name=partyResCheck]").prop("checked", true);
			$("#memberAgree").prop("checked", true);
		}else{ 
			$("input[name=partyResCheck]").prop("checked", false);
			$("#memberAgree").prop("checked", false);
		}
	});
   // 이용약관 관련  전체 동의 이벤트
	$("input[name=partyResCheck]").click(function() {		
		var total = $("input[name=partyResCheck]").length;
		var checked = $("input[name=partyResCheck]:checked").length;

		if(total != checked){
			$("#agreeAll").prop("checked", false);
			$("#memberAgree").prop("checked", false);
		}
		else{
			$("#agreeAll").prop("checked", true); 
			$("#memberAgree").prop("checked", true);
		}
	});
})	;
	
	
</script>
    </head>
    <body>
        <div class="header_g">
            <div class="header_wrap">
                <a href="/index2.jsp" class="gnb_logo"><span class="g_alt">상하농원</span></a>
                <!-- 24.03.05 add button -->
                <button class="btn_allmenu mo_only"><span class="g_alt">전체메뉴</span></button>
                <div class="gnb_menu">
                    <a href="/brand/introduce/story.jsp">고창상하농원</a>
                    <a href="/brand/workshop/ham.jsp">짓다</a>
                    <a href="/brand/play/gallery.jsp">놀다</a>
                    <a href="/brand/food/store1.jsp">먹다</a>
                    <!-- 24.03.05 add class : pc_only -->
                    <button class="btn_allmenu pc_only">전체메뉴</button>
                </div>
            </div>
        </div>
        <div class="body_wrap">
            <div class="popup_g">
                <div class="dim_g"></div>
                <div id="terms" class="popup_wrap popup_terms">
                    <div class="popup_header">
                        <button type="button" onClick="popupClose()" class="btn_close"><span class="g_alt">닫기</span></button>
                    </div>
                    <div class="popup_body">
                        <b class="terms_title">이용동의</b>
                        <div class="mt50">
                            <div class="check_g">
                                <input type="checkbox" name="partyResAll" id="agreeAll">
                                <label  for="agreeAll"><span class="fs18 fwBold">네, 모두 동의합니다.</span></label>
                            </div>
                        </div>
                        <div class="mt30">
                            <div class="check_g">
                                <input type="checkbox" name="partyResCheck" id="agree1">
                                <label for="agree1"><span>취소/환불 규정에 대한 동의</span></label>
                            </div>
                            <!-- 24.03.17 add class : mt10 -->
                            <div class="textarea_g readOnly mt10">
                                <textarea name="" id="" readonly="readonly">기후상황, 개인사유 등에 따른 일정변경으로 인한 손해에 대해서는 상하농원에서 책임지지 않습니다. 취소/환불 규정에 동의 하시겠습니까?

- 이용 7일 전까지 취소 수수료 없음
- 이용 7일 전 ~ 당일 체험시작 20분 전까지 3set에 한해 수량 변경 가능
- 식사 예약 수량은 당일 10시 이전까지 인원의 10%내외에 한해 수량 변경 가능</textarea>
                            </div>
                        </div>
                        <div class="mt30">
                            <div class="check_g">
                                <input type="checkbox" name="partyResCheck" id="agree2">
                                <label for="agree2"><span>예약내역 동의</span></label>
                            </div>
                            <!-- 24.03.17 add class : mt10 -->
                            <div class="textarea_g readOnly mt10">
                                <textarea name="" id="" redonly="redonly">예약할 상품의 상품명, 사용일자 및 시간, 상품가격을 확인했습니다. (전자상거래법 제 8조 2항) 예약에 동의하시겠습니까?

- 상하농원 단체 체험은 20인 이상에 한해 예약이 가능합니다.
- 체험 시작 이후에는 입장이 제한됩니다. (체험시작 20분 전까지 매표소 도착)
- 40명 이상 단체의 경우 추가 포장시간이 2시간까지 소요될 수 있습니다.</textarea>
                            </div>
                        </div>
                        <div class="btn_area mt40">
                            <button type="button" onClick="popupClose()" class="btn_submit">확인</button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="pagetop_wrap pagetop_04">
                <p class="pagetop_title">짓다, 놀다, 먹다</p>
                <p class="pagetop_des">체험</p>
            </div>
            <div class="content_wrap">
                <div class="type_wrap">
                    <div class="type_item type_personal">
                        <p>개인예약</p>
                        <span>(20명미만)</span>
                    </div>
                    <div class="type_item type_group act">
                        <p>단체예약</p>
                        <span>(20명이상)</span>
                    </div>
                </div>
                <!-- 24.03.17 add p tag -->
                <p class="expgroup_des pl20 pr20 ar">20인이상의 단체방문자는 추가적인 할인혜택이 적용됩니다. 방문계획을 남겨주시면, 전화를 통해 예약을 확정합니다.</p>
                <!-- 24.03.17 add class : mt20 -->
                <form name="reserveForm" id="reserveForm" method="post" action="reserveProc.jsp" class="mt20">
                <input type="hidden" name="reserve_date" id="reserve_date" />
                    <section class="page_section">
                        <div class="section_title on">
                            <span>01</span>
                            날짜 선택
                        </div>
                        <div class="section_content">
                            <!-- 24.03.21 modify wrap START -->
                            <div class="conLine_Wrap">
                                <div class="conLine w50p">
                                    <p class="conLine_title">예약 희망일 ①</p>
                                    <p class="input_date conLine_content w290">
                                        <input type="text" id="res_date1" name="reserve_date" value="2024.01.01">
                                    </p>
                                    <script>
                                        $(function() {
                                            $( "#res_date1" ).datepicker({
                                                dateFormat:"yy년 m월 d일(DD)",
                                                showOn:"both",
                                                buttonImage:"${pageContext.request.contextPath}/image/icn_cal_b.png",
                                                buttonImageOnly:"true",
                                                monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'],
                                                monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
                                                dayNamesMin: ['일','월','화','수','목','금','토'],
                                                dayNames: ['일','월','화','수','목','금','토'],
                                                onSelect:function(dateText, inst){
                                                	date = $(this).datepicker('getDate'),
                                                	strdate = date.getFullYear()+"."+(date.getMonth()+1)+"."+date.getDate()
                                            		
                                                	step1("",strdate);
                                                	$("#reserve_date").val(strdate);
                                            	}
                                            });
                                            $('#res_date1').datepicker('setDate', 'today');
                                        });
                                    </script>
                                </div>
<!--                                 <div class="conLine">
                                    <p class="conLine_title">예약 희망일 ②</p>
                                    <p class="input_date conLine_content w290">
                                        <input type="text" id="res_date2" value="2024.01.01">
                                    </p>
                                    <script>
                                        $(function() {
                                            $( "#res_date2" ).datepicker({
                                                dateFormat:"yy년 m월 d일(DD)",
                                                showOn:"both",
                                                buttonImage:"${pageContext.request.contextPath}/image/icn_cal_b.png",
                                                buttonImageOnly:"true",
                                                monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'],
                                                monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
                                                dayNamesMin: ['일','월','화','수','목','금','토'],
                                                dayNames: ['일','월','화','수','목','금','토']
                                            });
                                            $('#res_date2').datepicker('setDate', 'today');
                                        });
                                    </script>
                                </div> -->
                            </div>
                            <!-- 24.03.21 modify wrap END -->
                        </div>
                    </section>
                    <section class="page_section">
                        <div class="section_title on">
                            <span>02</span>
                            예약자 정보
                        </div>
                        <div class="section_content">
                            <strong class="content_title blk">농원 내 식당을 이용할 계획이면 체크해주세요.</strong>
                            <div class="check_g mt10">
                                <input type="checkbox" name="kitchen_yn" id="groupOpt1" value="Y">
                                <label for="groupOpt1"><span>농원식당</span></label>
                            </div>
                            <div class="check_g mt10 ml30">
                                <input type="checkbox" name="other_yn" id="groupOpt2" value="Y">
                                <label for="groupOpt2"><span>상하키친</span></label>
                            </div>
                            <div class="divLine mt20 mb20"></div>
                            <div class="conLine">
                                <p class="conLine_title">체험 프로그램</p>
                                <select name="exp_type" id="exp_type" title="프로그램 선택" class="select_g select_medium">
                                    <option value="">선택없음</option>
                                </select>
                            </div>
                            <div class="conLine lh16 fcGray fs14">
                                - 20명 이상 이용 시에만 단체가격의 적용이 가능합니다.<br/>
                                - 웹사이트 예약 접수 후 유선을 통한 예약 확정이 필요합니다. (예약 후 3일 이내 해피콜 예정)<br/>
                                - 단체 도시락 식사가 가능한 실내 시설이 없습니다. 도시락 지참 시 참고 바랍니다.<br/>
                                - 단체 체험 취소는 일주일 전까지만 가능합니다.
                            </div>
                            <div class="conLine">
                                <p class="conLine_title required">단체명</p>
                                <input type="text" name="group_nm" id="group_nm" title="단체명"  class="input_g input_medium">
                            </div>
                            <div class="conLine">
                                <p class="conLine_title required">체험인원</p>
                                <!-- 24.03.21 add span.subText -->
                                <input type="text" name="exp_num" id="exp_num" title="체험인원"  class="input_g input_medium" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)"><span class="subText">명</span>
                            </div>
                            <div class="conLine">
                                <p class="conLine_title">참관인원</p>
                                <!-- 24.03.21 add span.subText -->
                                <input type="text" name="see_num" id="see_num" title="참관인원" class="input_g input_medium" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)"><span class="subText">명</span>
                            </div>
                            <div class="conLine">
                                <p class="conLine_title">휴대폰번호</p>
                                <select  name="mobile1" id="mobile1" title="연락처 첫자리" class="select_g select_small tel_input">
<%
	for(String mobile : SanghafarmUtils.MOBILES) {
%>
								<option value="<%= mobile %>" <%= mobile.equals(fs.getMobile1()) ? "selected" : "" %>><%= mobile %></option>
<%
	}
%>
                                </select>
                                <input type="text" name="mobile2" id="mobile2" value="<%= fs.getMobile2() %>" title="연락처 가운데자리" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)" class="input_g input_small tel_input ml10">
                                <input type="text" name="mobile3" id="mobile3" value="<%= fs.getMobile3() %>" title="연락처 뒷자리" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)" class="input_g input_small tel_input ml10">
                            </div>
                            <div class="conLine">
                                <p class="conLine_title">연령대</p>
                                <select name="age" id="age"  title="연령대 선택" class="select_g select_medium">
<%
	for(Param row : list) {
%>
						<option value="<%= row.get("code2") %>"><%= row.get("name2") %></option>
<%
	}
%>
                                </select>
                            </div>
                            <div class="conLine">
                                <p class="conLine_title required">기타 문의</p>
                                <div class="textarea_g">
                                    <textarea  name="content" ></textarea>
                                </div>
                            </div>
                        </div>
                    </section>
                    <section class="page_section">
                        <div class="section_title on">
                            이용동의
                        </div>
                        <div class="section_content">
                            <div class="agree_wrap">
                                <div class="check_g">
                                    <input type="checkbox"  id="memberAgree" onClick="popupOpen('terms')">
                                    <!-- 24.03.21 add onClick -->
                                    <label  for="memberAgree"><span>이용약관 동의</span></label>
                                </div>
                            </div>
                        </div>
                    </section>

                    <div class="btn_area mo_btn2 mt40">
                        <button type="button" onclick="history.back()" class="btn_line w300">이전으로</button>
                        <button type="button" onclick="proc()" class="btn_submit ml30">상담등록</button>
                    </div>
                </form>
            </div>
        </div>
        <div class="footer_g">
            <div class="footer_wrap flex_wrap">
                <div class="footer_group_mo mo_only">
                    <div class="groupWrap">
                        <div class="groupLine icn_cs">
                            <span>상하농원 고객센터</span>
                            <p><a href="tel:1522-3698">1522-3698</a></p>
                        </div>
                        <div class="groupLine icn_reserv">
                            <span>파머스 빌리지 예약</span>
                            <p><a href="tel:063-563-6611">063-563-6611</a></p>
                        </div>
                    </div>
                    <div class="groupWrap">
                        <div class="groupLine icn_and">
                            <span>상하농원</span>
                            <p><a href="">안드로이드 다운로드</a></p>
                        </div>
                        <div class="groupLine icn_ios">
                            <span>다운로드</span>
                            <p><a href="">iOS 다운로드</a></p>
                        </div>
                    </div>
                </div>
                <p class="fotter_logo"><img src="${pageContext.request.contextPath}/image/footer_logo.png" alt=""></p>
                <div class="footer_info">
                    <div class="info_link">
                        <a href="">입점/제휴문의</a>
                        <a href="">이용약관</a>
                        <a href="">개인정보취급방침</a>
                        <a href="">고객센터</a>
                        <a href="">윤리 HOT-LINE</a>
                    </div>
                    <div class="info_company">
                        <div class="companyLine">
                            <p><span>전라북도 고창군 상하면 상하농원길 11-23</span><span>대표 : 최승우</span></p>
                            <p><span>개인정보 보호 책임자 : 최승우</span><span>사업자등록번호 : 415-86-00211</span></p>
                        </div>
                        <div class="companyLine">
                            <p><span>통신판매업신고번호 : 제2016-4780085-30-2-00015호</span></p>
                            <p><span>상담이용시간 : 09:30~18:00</span><span>농원운영시간 : 연중무휴 09:30~21:00</span></p>
                        </div>
                    </div>
                    <div class="info_extra">
                        <p>상하농원(유)은 매일유업(주)과의 제휴를 통해 공동으로 서비스를 운영하고 있습니다.</p>
                        <p>@ 2021 SANGHA FARM CO. ALL RIGHTS RESERVED</p>
                    </div>
                </div>
                <div class="footer_btn flex_wrap pc_only">
                    <div class="btn_wrap flex_wrap">
                        <p>상하농원 <br>앱 다운로드</p>
                        <div>
                            <p class="btn_and">안드로이드</p>
                            <p class="btn_ios">iOS</p>
                        </div>
                    </div>
                    <div class="footer_contact">
                        <div class="contact_cs"><b>고객센터</b><span>1522-3698</span></div>
                        <div class="contact_res"><b>빌리지예약</b><span>063-563-6611</span></div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            $(".section_title").click(function() {
                $(this).next(".section_content").stop().slideToggle(300);
                $(this).toggleClass('on').siblings().removeClass('on');
                $(this).next(".section_content").siblings(".section_content").slideUp(300); // 1개씩 펼치기
            });
        
        </script>
    </body>
</html>