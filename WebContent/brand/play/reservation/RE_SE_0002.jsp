<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			java.text.*,
			java.security.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.service.code.*,				 
		 	com.sanghafarm.service.member.*,
			com.sanghafarm.service.order.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(6));
	request.setAttribute("Depth_4", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("예약하기"));
	
	boolean ckLogin = false;
	FrontSession fs = FrontSession.getInstance(request, response);
	if(fs.isLogin()) {
		ckLogin = true; 
	}
%>
<html>
    <head>
<jsp:include page="/include/head.jsp" />
<script src="${pageContext.request.contextPath}/js/dlp/lib/jquery/jquery-1.11.1.min.js" charset="urf-8"></script>
<script type="text/javascript">

/* 달력 */
            $(".section_title").click(function() {
                $(this).next(".section_content").stop().slideToggle(300);
                $(this).toggleClass('on').siblings().removeClass('on');
                $(this).next(".section_content").siblings(".section_content").slideUp(300); // 1개씩 펼치기
            });
           
            $(function() {
            	var date;
            	var strdate = getToday(); // 기본값으로 현재 날짜
            	setTime(strdate);
            	getExpList5(strdate,"");
            	$("#param_date").val(strdate);
            	
                $( "#res_date" ).datepicker({
                    dateFormat:"yy년 m월 d일(DD)",
                    showOn:"both",
                    buttonImage:"${pageContext.request.contextPath}/image/icn_cal_b.png",
                    buttonImageOnly:"true",
                    monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'],
                    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
                    dayNamesMin: ['일','월','화','수','목','금','토'],
                    dayNames: ['일','월','화','수','목','금','토'],
                    minDate: 0,
                    onSelect:function(dateText, inst){
                    	date = $(this).datepicker('getDate'),
                    	strdate = date.getFullYear()+"."+(date.getMonth()+1)+"."+date.getDate()
                		setTime(strdate);
                    	getExpList5(strdate,"");
                    	$("#param_date").val(strdate);
                	}
                });               
                $('#res_date').datepicker('setDate', 'today');
// 시간선택 
                $("#selectDate").change(function() {
                	var _time = $(this).val();
                	getExpList5(strdate,_time);// 체험 유형 불러오기
                	checkAllExpGroupBoxes();//체험 유형 모두 체크
                	$("#expAll").prop("checked", true);
                });
            });
            
            function checkAllExpGroupBoxes() {
                $('input[name="expgroupbox"]').each(function() {
                    $(this).prop('checked', true).change();
                });
            }
// 시간 불러오기             
            function setTime(date){
            	$.ajax({
        			method : "POST",
        			url : "RE_SE_expList4.jsp",
        			data : { date : date },
        			dataType : "html"
        		})
        		.done(function(html) {        			
       				$("#selectDate").empty().append($.trim(html));	//원본
        		});
            }
  // 오늘날짜 생성          
            function getToday(){
                var date = new Date();
                var year = date.getFullYear();
                var month = ("0" + (1 + date.getMonth())).slice(-2);
                var day = ("0" + date.getDate()).slice(-2);

                return year + "." + month + "." + day;
            }
  //체험 유형 불러오기 
            function getExpList5(strdate,_time){
            	$.ajax({
        			method : "POST",
        			url : "RE_SE_expList5.jsp",
        			data : { date : strdate , time : _time},
        			dataType : "html"
        		})
        		.done(function(html) {
        			$("#expList5").empty().append($.trim(html));
        			if(!$("#expAll").is(':checked')) $("#expAll").trigger('click');
        		});
            }
  
  			function popDetail(seq){
  				$.ajax({
        			method : "POST",
        			url : "RE_SE_expList6.jsp",
        			data : { seq : seq },
        			dataType : "html"
        		})
        		.done(function(html) {
        			$("#popup_body").empty().append($.trim(html));
        			popupOpen('expDetail1');	
        		});  				
  				
  			}
            
            function popupOpen(popId){
                $('.popup_g').show();
            }
            
            function popupClose(){
                $('.popup_g').hide();
            }
            
            $(".dim_g").click(function(){
                $('.popup_g').hide();
            });
/* 달력, 퍼블 End */

	$(document).ready(function() {
		// 체크박스 상태 변경 이벤트 핸들러 등록
	    $('input[name="expgroupbox"]').change(function() {
	        // 현재 체크된 체크박스의 카테고리를 가져옵니다.
	        var currentCategoryId = $(this).attr('id');
	        var currentCategory = ""; // 현재 카테고리명을 저장할 변수

	        // 체크된 체크박스의 ID에 따라 currentCategory 값을 설정합니다.
	        switch(currentCategoryId) {
	            case 'exp1':
	                currentCategory = "002";
	                break;
	            case 'exp2':
	                currentCategory = "999";
	                break;
	            case 'exp3':
	                currentCategory = "001";
	                break;
	            case 'exp4':
	                currentCategory = "003";
	                break;
	            case 'exp5':
	                currentCategory = "005";
	                break;
	            default:
	            	currentCategory = "888";
	        }

	        // 모든 항목을 숨기고, 선택된 카테고리의 항목만 표시합니다.
	        if($(this).is(':checked')) {
	            // 체크된 경우 해당 카테고리의 항목만 보여줍니다.
	            $('ul.exp_list li').filter('[data-category="' + currentCategory + '"]').show();
	        } else {
	            // 체크 해제된 경우 해당 카테고리의 항목을 숨깁니다.
	            $('ul.exp_list li').filter('[data-category="' + currentCategory + '"]').hide();
	        }
	        
	        var total = $("input[name=expgroupbox]").length;
    		var checked = $("input[name=expgroupbox]:checked").length;

    		if(total != checked){
    			$("#expAll").prop("checked", false);
    		}
    		else{
    			$("#expAll").prop("checked", true); 
    		}
	    });
		/* 체험유형 체크 End */

		
	    // 전체 선택/해제 로직
	    $('#expAll').change(function() {
	        if(this.checked) {
	            $('input[name="expgroupbox"]').prop('checked', true);
	        } else {
	            $('input[name="expgroupbox"]').prop('checked', false);
	        }
	        $('input[name="expgroupbox"]').trigger('change');
	    });
	    
	    
				
        //페이지 로드 시 세션 스토리지에서 폼 데이터를 복원
        if (sessionStorage.getItem('formData')) {
            var formData = JSON.parse(sessionStorage.getItem('formData'));
            $.each(formData, function(i, field) {
                $("[name='" + field.name + "']").val(field.value);
            });
            sessionStorage.removeItem('formData'); // 데이터 복원 후 세션 스토리지에서 삭제
        }
	});
	
	
	$(document).on("click","input[type=radio]",function(e){
		var chk = $(this).is(":checked");
		var pre = $(this).data("previous");
		  if(chk == true && pre == $(this).val()){
		        $(this).prop('checked',false);
		        $(this).data("previous",'');
		    }else{
		        if(chk == true) $(this).data("previous",$(this).val());
		    }
	});

	/* 예약하기 */
	function tosubmit() {
	    var radio_chk = $("input[type=radio]:checked").length;
	    if (radio_chk == 0) {
	        alert("체험유형을 선택해주세요.");
	        return;
	    }
	
	    var isLoggedin = <%= ckLogin %>;
	    
	    if(isLoggedin) {
	        $("#idform").submit();
	    } else {
	        alert("로그인이 필요합니다.");
	     	// 폼 데이터를 sessionStorage에 저장
	        sessionStorage.setItem('formData', JSON.stringify($('#idform').serializeArray()));
	        window.location.href = "/mobile/member/login.jsp?returnUrl=" + encodeURIComponent(window.location.href)+"&type=web";
	    }
	}
</script>
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
        <!--[if lte IE 8]>
        <script src="http://carvecat.com/js/html5.js"></script>
        <![endif]-->

        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/reset.css">
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/new_common.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/sub.js"></script>
        
        <link rel="stylesheet" href="http://code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" type="text/css" />
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
        <script src="http://code.jquery.com/ui/1.8.18/jquery-ui.min.js"></script>
        
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
        <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
      
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
                <div id="expDetail1" class="popup_wrap popup_exp">
                    <div class="popup_header">
                        <button type="button" onClick="popupClose()" class="btn_close"><span class="g_alt">닫기</span></button>
                    </div>
                    <div class="popup_body" id="popup_body">
						<!-- 24.03.11 add -->
                        <div class="popup_content">
                            <img id="expCon_PC" src="${pageContext.request.contextPath}/image/RE_SE_1006_PC.jpg" class="pc_only" alt="">
                            <img id="expCon_MO" src="${pageContext.request.contextPath}/image/RE_SE_1006_MO.jpg" class="mo_only" alt="">
                        </div>
                    </div><!--  팝업 end -->
                </div>
            </div>
            <div class="pagetop_wrap pagetop_04">
                <p class="pagetop_title">짓다, 놀다, 먹다</p>
                <p class="pagetop_des">체험</p>
            </div>
            <div class="content_wrap">
                <div class="step_wrap">
                    <div class="step_item act">
                        <p>01</p>
                        <b>체험선택</b>
                    </div>
                    <div class="step_item">
                        <p>02</p>
                        <b>정보입력</b>
                    </div>
                    <div class="step_item">
                        <p>03</p>
                        <b>예약완료</b>
                    </div>
                </div>
 <!-- form 시작 -->
    <form action="RE_SE_0003.jsp" id="idform" method="post">
                    <section class="page_section">
                        <div class="section_title on">
                            <span>01</span>
                            체험 희망일
                        </div>
                        <div class="section_content">
                            <div class="reserveDate_wrap">
                                <p class="input_date">
                                    <input type="text" id="res_date" name="res_date" value="">
                                    <input type="hidden" id="param_date" name="param_date" value="">
                                </p>
                                <select name="selectDate" id="selectDate" class="select_date">                                
                                    <option value="">시간 선택</option>
                                </select>
                            </div>
                            <div class="textbox_g">
                                <p class="textbox_title">[체험프로그램 안내사항]</p>
                                <ul>
                                    <li>체험 프로그램은 봄, 여름, 가을, 겨울 그리고 이벤트에 맞춰서 상시적으로 업데이트 되고 있습니다.</li>
                                    <li>입장료는 체험프로그램 결제에 포함되어 있지 않습니다. 현장결제 또는 객실예약시 무료로 제공하고 있습니다.</li>
                                    <li>상하농원은 단체를 위한 스페셜 프로그램을 마련하고 있습니다.</li>
                                </ul>
                                <a href="/brand/play/reservation/RE_GR_0001.jsp" button class="btn_group inB" style="text-align:center;">단체예약 바로가기 </a>
                            </div>
                        </div>
                    </section>
                    <section class="page_section">
                        <div class="section_title on">
                            <span>02</span>
                            체험 유형 선택
                        </div>
                        <div class="section_content">
                            <!-- 24.03.17 add -->
                            <div class="ar">
                                <div class="check_g mb15">
                                    <input type="checkbox" name="expgroupAll" id="expAll">
                                    <label for="expAll"><span>전체 해제</span></label>
                                </div>
                            </div>
                            <div class="expgroup_wrap">
                                <div class="expgroup_item">
                                    <input type="checkbox" name="expgroupbox" id="exp1">
                                    <label for="exp1"><span>먹거리</span></label>
                                </div>
                                <div class="expgroup_item">
                                    <input type="checkbox" name="expgroupbox" id="exp2">
                                    <label for="exp2"><span>공장 견학</span></label>
                                </div>
                                <div class="expgroup_item">
                                    <input type="checkbox" name="expgroupbox" id="exp3">
                                    <label for="exp3"><span>수확 체험</span></label>
                                </div>
                                <div class="expgroup_item">
                                    <input type="checkbox" name="expgroupbox" id="exp4">
                                    <label for="exp4"><span>시즌성</span></label>
                                </div>
                                <div class="expgroup_item">
                                    <input type="checkbox" name="expgroupbox" id="exp5">
                                    <label for="exp5"><span>이벤트&기타</span></label>
                                </div>
                            </div>
                            <ul class="exp_list" id="expList5">
                                <!-- RE_SE_expList5.jsp 리스트  -->
                            </ul>
                            <div class="btn_area">
                                <a type="button" onclick="tosubmit()" class="btn_submit inB">예약하기</a>
                            </div>
                        </div>
                    </section>
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
                <p class="fotter_logo"><img src="./image/footer_logo.png" alt=""></p>
                <div class="footer_info">
                    <div class="info_link">
                        <!-- 24.03.22 add href -->
                        <a href="www.sanghafarm.co.kr/customer/partnership.jsp">입점/제휴문의</a>
                        <!-- 24.03.22 add 인재채용 -->
                        <a href="www.sanghafarm.co.kr/brand/bbs/jobnotice/story1.jsp">인재채용</a>
                        <!-- 24.03.22 add href -->
                        <a href="www.sanghafarm.co.kr/customer/agree.jsp">이용약관</a>
                        <!-- 24.03.22 add href -->
                        <a href="www.sanghafarm.co.kr/customer/privacy.jsp">개인정보취급방침</a>
                        <!-- 24.03.22 add href -->
                        <a href="www.sanghafarm.co.kr/customer/faq.jsp">고객센터</a>
                        <!-- 24.03.22 add onClick -->
                        <a a href="#"  onClick="popupOpen('hotline')">윤리 HOT-LINE</a>
                    </div>
                    <div class="info_company">
                        <!-- 24.03.05 modify : .info_company 태그 및 내용 변경 -->
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
                <!-- 24.03.03 add class : pc_only -->
                <div class="footer_btn flex_wrap pc_only">
                    <div class="footer_contact">
                        <div class="contact_cs"><b>고객센터</b><span>1522-3698</span></div>
                        <div class="contact_res"><b>빌리지예약</b><span>063-563-6611</span></div>
                    </div>
                    <div class="btn_wrap flex_wrap">
                        <p>상하농원 <br>앱 다운로드</p>
                        <div>
                            <p class="btn_and">안드로이드</p>
                            <p class="btn_ios">iOS</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>