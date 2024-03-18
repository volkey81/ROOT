<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.service.order.*" %>
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
                    <span>비회원 호텔예약 내역 조회</span>
                </p>
            </div>
            <div class="content_wrap mt40">
                <p class="pageTitle">비회원 호텔예약 내역 조회</p>
                
                <div class="ulTitle mt30">예약번호 : <a href="">20240202130036627080</a></div>
                <ul class="ulTable">
                    <li>
                        <div class="ulTable_line">
                            <span class="line_title">예약자</span>
                            홍길동
                        </div>
                        <div class="ulTable_line">
                            <span class="line_title">휴대전화</span>
                            010-1111-2222
                        </div>
                    </li>
                    <li>
                        <div class="ulTable_line">
                            <span class="line_title">이메일</span>
                            -
                        </div>
                    </li>
                    <li>
                        <div class="ulTable_line">
                            <span class="line_title">결제수단</span>
                            신용카드
                        </div>
                        <div class="ulTable_line">
                            <span class="line_title">상태</span>
                            결제완료
                        </div>
                    </li>
                </ul>

                <div class="ulTitle mt40">예약상품</div>
                <ul class="ulTable">
                    <li>
                        <div class="ulTable_line line_one">
                            <b class="line_title">먹거리 : 치즈&피자 만들기 체험</b>
                            <div class="flex_wrap">
                                <p>2024.02.28 (수)</p>
                                <p>B동 10:30</p>
                                <p>1인권(입장권별도)</p>
                                <p></p><!--빈 상태로 태그 유지-->
                            </div>
                        </div>
                    </li>
                </ul>

                <div class="bgbox_g bgBox_reserv w1080 mt20">
                    <p>예약 소계 <em>45,000</em>원</p>
                    <p>할인 소계 <em>-0</em>원</p>
                    <p><b>총 결제 금액 <em>45,000</em>원</b></p>
                </div>

                <div class="btn_area mt40">
                    <button type="button" class="btn_submit">목록보기</button>
                </div>
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
                    dateFormat:"yy년 m월 d일(DD)",
                    showOn:"both",
                    buttonImage:"./image/icn_cal_b.png",
                    buttonImageOnly:"true",
                    monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'],
                    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
                    dayNamesMin: ['일','월','화','수','목','금','토'],
                    dayNames: ['일','월','화','수','목','금','토']
                });
                $('#search_date').datepicker('setDate', 'today');
            });
            $(function() {
                $( "#end_date" ).datepicker({
                    dateFormat:"yy년 m월 d일(DD)",
                    showOn:"both",
                    buttonImage:"./image/icn_cal_b.png",
                    buttonImageOnly:"true",
                    monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'],
                    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
                    dayNamesMin: ['일','월','화','수','목','금','토'],
                    dayNames: ['일','월','화','수','목','금','토']
                });
                $('#search_date').datepicker('setDate', 'today');
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