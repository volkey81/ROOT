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
        <link rel="stylesheet" href="./css/reset.css">
        <link rel="stylesheet" href="./css/new_common.css">
        <link rel="stylesheet" href="./css/style.css">

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
                    <a href="">고창상하농원</a>
                    <a href="">짓다</a>
                    <a href="">놀다</a>
                    <a href="">먹다</a>
                    <button class="btn_allmenu">전체메뉴</button>
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
            <div class="content_wrap mt40">
                <p class="pageTitle">비회원 주문 및 예약 조회</p>
                <div class="tabBox_g mt20">
                    <button type="button" class="tabBox_item">체험예약</button>
                    <button type="button" class="tabBox_item act">호텔예약</button>
                    <button type="button" class="tabBox_item">마켓주문</button>
                </div>
                <form action="">
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
                    ∙모든 예약은 당사의 사정에 의해 변경될 수 있습니다.<br/>
                    ∙예약 취소 수수료는 아래와 같습니다.
                </div>
                <div class="lineBox_g f_g mt20">
                    <div class="fl w50p">
                        <b>(극)성수기/패키지</b>
                        <p>
                            ∙투숙예정일 15일 전까지 취소한 경우 예약금액 전액 환불<br/>
                            ∙투숙예정일 14~8일 전까지 취소한 경우 예약금액의 10% 환불
                        </p>
                    </div>
                    <div class="fr w50p">
                        <b>비수기 / 공통</b>
                        <p>
                            ∙투숙예정일 8일 전까지 취소한 경우 예약금액 전액 환불<br/>
                            ∙투숙예정일 7~4일 전까지 취소한 경우 예약금액의 50% 환불<br/>
                            ∙투숙예정일 3일 전~당일 취소(No-show포함) 예약금액 환불 없음
                        </p>
                    </div>
                </div>
                <ul class="reserList_wrap mt40">
                    <li class="reserList_th">
                        <p class="reserList_item">예약일시/예약번호</p>
                        <p class="reserList_item">예약 내역</p>
                        <p class="reserList_item">일정</p>
                        <p class="reserList_item">상태</p>
                        <p class="reserList_item">관리</p>
                    </li>
                    <li class="reserList_td">
                        <div class="reserList_item">
                            <span class="item_title">예약일시/<br/>예약번호</span>
                            <p class="textType1"><em>2024.02.02 12:02:38</em> (<em>2024020210492459965_2</em>)</p>
                        </div>
                        <div class="reserList_item">
                            <span class="item_title">예약 내역</span>
                            <b class="textType1 fwBold">테라스</b>
                        </div>
                        <div class="reserList_item">
                            <span class="item_title">일정</span>
                            <b class="textType1 fwBold"><em>2024.01.01</em> ~<br/><em>2024.01.01</em></b>
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