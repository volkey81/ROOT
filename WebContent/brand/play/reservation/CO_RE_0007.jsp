<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			java.text.*,
			java.time.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.service.order.*" %>.
<%
Param param = new Param(request);
if(param.isEmpty()){
	param.set("name", session.getAttribute("name"));
	param.set("mobile1", session.getAttribute("mobile1"));
	param.set("mobile2", session.getAttribute("mobile2"));
	param.set("mobile3", session.getAttribute("mobile3"));
}

SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
Calendar c = Calendar.getInstance();
String today = sdf.format(c.getTime());
c.add(c.DATE, -7);
String stDate = sdf.format(c.getTime());
if(param.get("start_date")=="")	param.set("start_date", stDate);
if(param.get("end_date")=="") param.set("end_date", today);

//주문/배송 현황
	OrderService order = (new OrderService()).toProxyInstance();
// 주문 리스트
	List<Param> orderList = order.getOrderList(param);
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
        <!--[if lte IE 8]>
        <script src="http://carvecat.com/js/html5.js"></script>
        <![endif]-->

        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reset.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/new_common.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
        <script src="./js/sub.js"></script>
        
        <link rel="stylesheet" href="http://code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" type="text/css" />
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
        <script src="http://code.jquery.com/ui/1.8.18/jquery-ui.min.js"></script>
        
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
        <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
        
<script>
    	function dataFormatter(newDay, today) {
    		let year = newDay.getFullYear()
    		let month = newDay.getMonth()+1
    		let date = newDay.getDate()
    		if(today) {
    			let todayDate = today.getDate()
    			if(date != todayDate){
    				if(month == 0 ) year-=1
        			month = (month + 11) % 12
        			date = new Date(year, month, 0).getDate()	
    			}
    		}
    		month = ("0"+month).slice(-2)
    		date = ("0"+date).slice(-2)
    		return year + "." + month + "." + date
    	}
    	
    	$(function(){
    		let endDate = new Date();
    		$("input:radio[name=recently]").change(function(){
    			var ch = $("input[name='recently']:checked").val();
    			let newDate = new Date();
  				newDate.setMonth(endDate.getMonth()-ch)
  				newDate = dataFormatter(newDate,endDate)
    			$("#start_date").val(newDate);
        		$("#end_date").val(dataFormatter(endDate,endDate));
    		})
    	})
    	
    	function tabs(seq){
    		if(seq == '1'){
    			$("#tab").attr("action","CO_RE_0003.jsp").submit();
    		}
    		if(seq == '2'){
    			$("#tab").attr("action","CO_RE_0005.jsp").submit();
    		}
    		if(seq == '3'){
    			$("#tab").attr("action","CO_RE_0007.jsp").submit();
    		}
    	}
    	
</script>
        
    </head>
    <body>
        <div class="header_g">
            <div class="header_wrap">
                <a href="" class="gnb_logo"><span class="g_alt">상하농원</span></a>
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
                <div id="cancelConfirm" class="popup_wrap popup_confirm">
                    <div class="popup_body">
                        <p class="exp_title ac fwBold">취소하시겠습니까?</p>
                        <div class="btn_area">
                            <button type="button" onclick="popupClose()" class="btn_line w120 btn_small">취소</button>
                            <button type="button" onClick="popupOpen('cancelApply')" class="btn_submit w120 ml20 btn_small">확인</button>
                        </div>
                    </div>
                </div>
                <div id="cancelApply" class="popup_wrap popup_confirm">
                    <div class="popup_body">
                        <p class="exp_title ac fwBold">취소되었습니다.</p>
                        <div class="btn_area">
                            <button type="button" onclick="popupClose()" class="btn_submit w120 btn_small">확인</button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="top_wrap w1080 f_g">
                <p class="page_title fl">비회원 예약조회</p>
                <p class="navi_wrap fr">
                    <span>홈</span>
                    <span>비회원 예약조회</span>
                    <span>비회원 주문/예약 내역</span>
                </p>
            </div>
             <form action="" name="tab" id="tab" method="post">
				<input type="hidden" name="name" value="<%= param.get("name") %>" />
				<input type="hidden" name="mobile1" value="<%= param.get("mobile1") %>" />
				<input type="hidden" name="mobile2" value="<%= param.get("mobile2") %>" />
				<input type="hidden" name="mobile3" value="<%= param.get("mobile3") %>" />
			</form>
            <div class="content_wrap mt40">
                <p class="pageTitle">비회원 주문/예약 내역</p>
                <div class="tabBox_g mt20">
                     <a class="tabBox_item" href="javascript:void(0);" onclick="tabs(1);">체험예약</a>
                    <a class="tabBox_item" href="javascript:void(0);" onclick="tabs(2);">호텔예약</a>
                    <a class="tabBox_item act" href="javascript:void(0);" onclick="tabs(3);">마켓주문</a>
                </div>
                <form  name="search" method="post">
                <input type="hidden" name="name" value="<%= param.get("name") %>" />
                <input type="hidden" name="mobile1" value="<%= param.get("mobile1") %>" />
                <input type="hidden" name="mobile2" value="<%= param.get("mobile2") %>" />
                <input type="hidden" name="mobile3" value="<%= param.get("mobile3") %>" />
                    <div class="searchBox_g">
                        <div class="searchBox_item">
                            <div class="item_line">
                                <div class="line_content">
                                    <span class="content_title">기간</span>
                                    <p class="input_date w150">
                                        <input type="text" id="start_date" value="2024.01.01">
                                    </p>
                                    <span>~</span>
                                    <p class="input_date w150">
                                        <input type="text" id="end_date" value="2024.01.01">
                                    </p>
                                </div>
                                <div class="line_content">
                                    <span class="content_title">최근</span>
                                    <div class="radio_g radio_btn">
                                        <input type="radio" name="recently" id="recently1" checked>
                                        <label for="recently1"><span>1개월</span></label>
                                    </div>
                                    <div class="radio_g radio_btn ml10">
                                        <input type="radio" name="recently" id="recently3">
                                        <label for="recently3"><span>3개월</span></label>
                                    </div>
                                    <div class="radio_g radio_btn ml10">
                                        <input type="radio" name="recently" id="recently6">
                                        <label for="recently6"><span>6개월</span></label>
                                    </div>
                                </div>
                            </div>
                            <div class="item_line">
                                <div class="line_content">
                                    <span class="content_title">상품명</span>
                                    <input type="text" placeholder="" class="input_g w800">
                                </div>
                            </div>
                        </div>
                        <div class="searchBox_item">
                            <button type="button" class="btn_line">조회</button>
                        </div>
                    </div>
                </form>
                <div class="text_des fs16 mt15">
                    ∙[결제완료]이전 단계일 경우, [주문배송조회] 페이지 내 직접 취소 가능합니다.<br/>
                    ∙[상품준비중] 단계일 경우, 생산 및 배송이 시작되어 주문취소가 불가합니다.<br/>
                    ∙주문 상품의 부분취소는 불가합니다. 전체 주문취소 후 재구매 해주세요.<br/>
                    ∙배송완료 후 2~3일 후 구매확정 상태로 자동 전환 됩니다.
                </div>
                <ul class="reserList_wrap mt40">
                    <li class="reserList_th">
                        <p class="reserList_item">주문일시/주문번호</p>
                        <p class="reserList_item">주문 내역</p>
                        <p class="reserList_item">배송요청일</p>
                        <p class="reserList_item">상태</p>
                        <p class="reserList_item">관리</p>
                    </li>
                    <li class="reserList_td">
                        <div class="reserList_item">
                            <span class="item_title">주문일시/<br/>주문번호</span>
                            <p class="textType1"><em>2024.02.02 12:02:38</em> (<em>2024020210492459965_2</em>)</p>
                        </div>
                        <div class="reserList_item">
                            <span class="item_title">주문 내역</span>
                            <b class="textType1 fwBold">상하농원 우리쌀 식혜 500ml</b><p class="textType2 fcGray">상하농원 우리쌀 식혜 500ml</p>
                        </div>
                        <div class="reserList_item">
                            <span class="item_title">배송요청일</span>
                            <b class="textType1 fwBold"><em>-</em></b>
                        </div>
                        <div class="reserList_item">
                            <span class="item_title">상태</span>
                            <span class="textType1 fcGray">결제완료</span>
                        </div>
                        <div class="reserList_item">
                            <span class="item_title">관리</span>
                            <button type="button" onClick="popupOpen('cancelConfirm')" class="btn_line btn_gray btn_small w120 mt2">예약취소</button>
                        </div>
                    </li>
                    <li class="reserList_td">
                        <div class="reserList_item">
                            <span class="item_title">주문일시/<br/>주문번호</span>
                            <p class="textType1"><em>2024.02.02 12:02:38</em> (<em>2024020210492459965_2</em>)</p>
                        </div>
                        <div class="reserList_item">
                            <span class="item_title">주문 내역</span>
                            <b class="textType1 fwBold">[매일가족 전용] 2023 김장김치 예약주문</b><p class="textType2 fcGray">[매일가족 전용]상하농원 섞박지 5kg</p>
                        </div>
                        <div class="reserList_item">
                            <span class="item_title">배송요청일</span>
                            <b class="textType1 fwBold"><em>2024.01.19</em></b>
                        </div>
                        <div class="reserList_item">
                            <span class="item_title">상태</span>
                            <span class="textType1 fcGray">상품준비중</span>
                        </div>
                        <div class="reserList_item">
                            <span class="item_title">관리</span>
                            <span class="textType1 fcGray">-</span>
                        </div>
                    </li>
                    <li class="reserList_td">
                        <div class="reserList_item">
                            <span class="item_title">주문일시/<br/>주문번호</span>
                            <p class="textType1"><em>2024.02.02 12:02:38</em> (<em>2024020210492459965_2</em>)</p>
                        </div>
                        <div class="reserList_item">
                            <span class="item_title">주문 내역</span>
                            <b class="textType1 fwBold">2023 추석 고창 명품 멜론 세트(2입)</b><p class="textType2 fcGray">2023 추석 고창 명품 멜론 세트(2입)</p>
                        </div>
                        <div class="reserList_item">
                            <span class="item_title">배송요청일</span>
                            <b class="textType1 fwBold"><em>2024.01.19</em></b>
                        </div>
                        <div class="reserList_item">
                            <span class="item_title">상태</span>
                            <span class="textType1 fcGray">구매확정</span>
                        </div>
                        <div class="reserList_item">
                            <span class="item_title">관리</span>
                            <button type="button" onClick="popupOpen('cancelConfirm')" class="btn_submit btn_gray btn_small w80 mt2">영수증</button>
                            <button type="button" onClick="popupOpen('cancelConfirm')" class="btn_line btn_gray btn_small w80 mt2 ml10">상품평</button>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
        <div class="footer_g">
            <div class="footer_wrap flex_wrap">
                <p class="fotter_logo"><img src="./image/footer_logo.png" alt=""></p>
                <div class="footer_info">
                    <div class="info_link">
                        <a href="">입점/제휴문의</a>
                        <a href="">이용약관</a>
                        <a href="">개인정보취급방침</a>
                        <a href="">고객센터</a>
                        <a href="">윤리 HOT-LINE</a>
                    </div>
                    <div class="info_company">
                        <div>전라북도 고창군 상하면 상하농원길 11-23  |  대표 : 최승우  |  개인정보 보호 책임자 : 최승우  |  사업자등록번호 : 415-86-00211</div>
                        <div>통신판매업신고번호 : 제2016-4780085-30-2-00015호  |  상담이용시간 : 09:30~18:00  |  농원운영시간 : 연중무휴 09:30~21:00</div>
                    </div>
                    <div class="info_extra">
                        <p>상하농원(유)은 매일유업(주)과의 제휴를 통해 공동으로 서비스를 운영하고 있습니다.</p>
                        <p>@ 2021 SANGHA FARM CO. ALL RIGHTS RESERVED</p>
                    </div>
                </div>
                <div class="footer_btn flex_wrap">
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
            $(function() {
                $( "#start_date" ).datepicker({
                    dateFormat:"yy.mm.dd",
                    showOn:"both",
                    buttonImage:"./image/icn_cal_b.png",
                    buttonImageOnly:"true",
                    monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'],
                    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
                    dayNamesMin: ['일','월','화','수','목','금','토'],
                    dayNames: ['일','월','화','수','목','금','토']
                });
                $('#start_date').datepicker('setDate', '<%= param.get("start_date")%>');
            });
            $(function() {
                $( "#end_date" ).datepicker({
                    dateFormat:"yy.mm.dd",
                    showOn:"both",
                    buttonImage:"./image/icn_cal_b.png",
                    buttonImageOnly:"true",
                    monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'],
                    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
                    dayNamesMin: ['일','월','화','수','목','금','토'],
                    dayNames: ['일','월','화','수','목','금','토']
                });
                $('#end_date').datepicker('setDate', '<%= param.get("end_date")%>');
            });
            function countplus(resultId){
                var countValue = document.querySelector("#" + resultId).value;
                
                countValue = Number(countValue) + 1;
                document.querySelector("#" + resultId).value = countValue;
            }
            function countminus(resultId){
                var countValue = document.querySelector("#" + resultId).value;
                
                countValue = Number(countValue) - 1;
                document.querySelector("#" + resultId).value = countValue;
            }
        </script>
    </body>
</html>