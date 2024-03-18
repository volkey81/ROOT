<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
                <a href="" class="gnb_logo"><span class="g_alt">상하농원</span></a>
                <!-- 24.03.05 add button -->
                <button class="btn_allmenu mo_only"><span class="g_alt">전체메뉴</span></button>
                <div class="gnb_menu">
                    <a href="">고창상하농원</a>
                    <a href="">짓다</a>
                    <a href="">놀다</a>
                    <a href="">먹다</a>
                    <!-- 24.03.05 add class : pc_only -->
                    <button class="btn_allmenu pc_only">전체메뉴</button>
                </div>
            </div>
        </div>
        <div class="body_wrap">
            <div class="popup_g">
                <div class="dim_g"></div>
                <!-- 24.03.11 modify id -->
                <div id="expDetail" class="popup_wrap popup_exp">
                    <div class="popup_header">
                        <button type="button" onClick="popupClose()" class="btn_close"><span class="g_alt">닫기</span></button>
                    </div>
                    <div class="popup_body">
                        <!-- 24.03.11 delete -->
                        <!-- <p class="exp_label"><span>먹거리</span></p>
                        <b class="exp_title">공장견학</b>
                        <p class="exp_des">여기서 상하목장 우유와 치즈가 만들어져요</p>
                        <p class="divLine mt20 mb20"></p>
                        <div class="exp_content f_g">
                            <div class="fl">
                                <ul class="exp_detail">
                                    <li>
                                        <strong>체험영역</strong>
                                        <span class="tag_item">#참맛</span>
                                        <span class="tag_item">#감사</span>
                                        <span class="tag_item">#슬기</span>
                                        <span class="tag_item">#사랑</span>
                                        <span class="tag_item">#행복</span>
                                    </li>
                                    <li>
                                        <strong>체험 계절</strong>
                                        <p>상시</p>
                                    </li>
                                    <li>
                                        <strong>체험 시간</strong>
                                        <p>약 60분</p>
                                    </li>
                                    <li>
                                        <strong>적정 연령</strong>
                                        <p>제한없음</p>
                                    </li>
                                    <li>
                                        <strong>보호자 동반</strong>
                                        <p>보호자 동반</p>
                                    </li>
                                    <li>
                                        <strong>알레르기 유발성분</strong>
                                        <p>-</p>
                                    </li>
                                </ul>
                            </div>
                            <div class="fr">
                                <img src="./image/epx01_01.png" alt="">
                            </div>
                        </div> -->
                        <!-- 24.03.11 add -->
                        <div class="popup_content">
                            <img id="expCon_PC" src="./image/RE_SE_1006_PC.jpg" class="pc_only" alt="">
                            <img id="expCon_MO" src="./image/RE_SE_1006_MO.jpg" class="mo_only" alt="">
                        </div>
                    </div>
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
                <form action="">
                    <section class="page_section">
                        <div class="section_title on">
                            <span>01</span>
                            체험 희망일
                        </div>
                        <div class="section_content">
                            <div class="f_g">
                                <div class="conLine fl">
                                    <!-- 24.03.17 add span -->
                                    <p class="conLine_title required"><span>*</span> 희망일 (1순위)</p>
                                    <div class="reserveDate_wrap">
                                        <p class="input_date disabled w290">
                                            <input type="text" id="res_date1" value="2024.01.01">
                                        </p>
                                    </div>
                                </div>
                                <!-- 24.03.17 add class : mo_mt20 -->
                                <div class="conLine fr mt0 mo_mt20">
                                    <p class="conLine_title required">희망일 (2순위)</p>
                                    <div class="reserveDate_wrap">
                                        <p class="input_date w290">
                                            <!-- 24.03.17 delete default value / add placeholder -->
                                            <input type="text" id="res_date2" placeholder="날짜를 선택해주세요.">
                                        </p>
                                    </div>
                                </div>
                                
                            </div>
                        </div>
                        
                    </section>
                    <section class="page_section">
                        <div class="section_title on">
                            <span>02</span>
                            체험 유형 선택
                        </div>
                        <div class="section_content">
                            <!-- 24.02.29 위쪽으로 위치 변경 -->
                            <div class="ar">
                                <div class="check_g mb15">
                                    <input type="checkbox" name="expgroupAll" id="expAll">
                                    <label onClick="checkAll('expgroupAll','expgroupCheck')" for="expAll"><span>전체 해제</span></label>
                                </div>
                            </div>
                            <div class="expgroup_wrap">
                                <!-- 24.02.29 위쪽으로 위치 변경 START
                                <div class="ar">
                                    <div class="check_g mb15">
                                        <input type="checkbox" name="expgroupAll" id="expAll">
                                        <label onClick="checkAll('expgroupAll','expgroupCheck')" for="expAll"><span>전체 해제</span></label>
                                    </div>
                                </div>
                                24.02.29 위쪽으로 위치 변경 END -->
                                <div class="expgroup_item">
                                    <input type="checkbox" name="expgroupCheck" id="exp1" checked>
                                    <label for="exp1"><span>먹거리 체험</span></label>
                                </div>
                                <div class="expgroup_item">
                                    <input type="checkbox" name="expgroupCheck" id="exp2" checked>
                                    <label for="exp2"><span>공장 체험</span></label>
                                </div>
                                <div class="expgroup_item">
                                    <input type="checkbox" name="expgroupCheck" id="exp3" checked>
                                    <label for="exp3"><span>수확 체험</span></label>
                                </div>
                                <div class="expgroup_item">
                                    <input type="checkbox" name="expgroupCheck" id="exp4" checked>
                                    <label for="exp4"><span>시즌성 체험</span></label>
                                </div>
                                <div class="expgroup_item">
                                    <input type="checkbox" name="expgroupCheck" id="exp5" checked>
                                    <label for="exp5"><span>이벤트&기타</span></label>
                                </div>
                            </div>
                            <p class="expgroup_des ar">* 해당 금액은 일반 금액이며 단체 방문자는 추가적인 할인혜택이 적용됩니다.</p>
                            <ul class="exp_list">
                                <li>
                                    <div class="exp_item party_exp">
                                        <input type="checkbox" name="" id="partyExp1">
                                        <label for="partyExp1">
                                            <div class="flex_wrap">
                                                <p class="item_img"><img src="./image/exp_01.png" alt=""></p>
                                                <div class="item_content">
                                                    <b>[먹거리] 치즈 & 피자 만들기 체험</b>
                                                    <span>치즈도 만들고 미니피자도 냠냠</span>
                                                </div>
                                                <div class="item_amount">
                                                    <strong>금액: <em>18,000</em>원(1인)</strong>
                                                    <!-- 24.03.11 modify button -->
                                                    <button type="button" onClick="popupOpen('expDetail','RE_SE_1011')">상세보기</button>
                                                </div>
                                            </div>
                                        </label>
                                    </div>
                                </li>
                                <li>
                                    <div class="exp_item party_exp">
                                        <input type="checkbox" name="" id="partyExp2">
                                        <label for="partyExp2">
                                            <div class="flex_wrap">
                                                <p class="item_img"><img src="./image/exp_02.png" alt=""></p>
                                                <div class="item_content">
                                                    <b>[공장견학] 우유와 치즈가 만들어지는 과정</b>
                                                    <span>유기농으로 우유와 치즈는 어떻게 만들어질까요?</span>
                                                </div>
                                                <div class="item_amount">
                                                    <strong>금액: <em>18,000</em>원(1인)</strong>
                                                    <!-- 24.03.11 modify button -->
                                                    <button type="button" onClick="popupOpen('expDetail','RE_SE_1006')">상세보기</button>
                                                </div>
                                            </div>
                                        </label>
                                    </div>
                                </li>
                                <li>
                                    <div class="exp_item party_exp">
                                        <input type="checkbox" name="" id="partyExp3">
                                        <label for="partyExp3">
                                            <div class="flex_wrap">
                                                <p class="item_img"><img src="./image/exp_01.png" alt=""></p>
                                                <div class="item_content">
                                                    <b>[꼬마농부스쿨]  완두콩 심기</b>
                                                    <span>텃밭에서 우리 같이 완두콩 심어볼까요?</span>
                                                </div>
                                                <div class="item_amount">
                                                    <strong>금액: <em>18,000</em>원(1인)</strong>
                                                    <!-- 24.03.11 modify button -->
                                                    <button type="button" onClick="popupOpen('expDetail','RE_SE_1012')">상세보기</button>
                                                </div>
                                            </div>
                                        </label>
                                    </div>
                                </li>
                            </ul>
                            <div class="btn_area">
                                <button class="btn_submit">다음</button>
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
                        <a href="">입점/제휴문의</a>
                        <a href="">이용약관</a>
                        <a href="">개인정보취급방침</a>
                        <a href="">고객센터</a>
                        <a href="">윤리 HOT-LINE</a>
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
                    <!-- 24.03.14 modify : div.footer_contact, div.btn_wrap 순서 변경 -->
                    <div class="footer_contact">
                        <div class="contact_cs"><b>상하농원 고객센터</b><span>1522-3698</span></div>
                        <div class="contact_res"><b>파머스 빌리지 예약</b><span>063-563-6611</span></div>
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

        <script>
            $(".section_title").click(function() {
                $(this).next(".section_content").stop().slideToggle(300);
                $(this).toggleClass('on').siblings().removeClass('on');
                $(this).next(".section_content").siblings(".section_content").slideUp(300); // 1개씩 펼치기
            });
            $(function() {
                $( "#res_date1" ).datepicker({
                    dateFormat:"yy년 m월 d일(DD)",
                    showOn:"both",
                    buttonImage:"./image/icn_cal_b.png",
                    buttonImageOnly:"true",
                    monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'],
                    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
                    dayNamesMin: ['일','월','화','수','목','금','토'],
                    dayNames: ['일','월','화','수','목','금','토']
                });
                $('#res_date1').datepicker('setDate', 'today');
            });
            $(function() {
                $( "#res_date2" ).datepicker({
                    dateFormat:"yy년 m월 d일(DD)",
                    showOn:"both",
                    buttonImage:"./image/icn_cal_b.png",
                    buttonImageOnly:"true",
                    monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'],
                    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
                    dayNamesMin: ['일','월','화','수','목','금','토'],
                    dayNames: ['일','월','화','수','목','금','토']
                });
                $('#res_date2').datepicker('setDate', 'today');
            });
            // 24.03.11 move script : sub.js
            // function popupOpen(popId){
            //     $('.popup_g').show();
            // }
            // function popupClose(){
            //     $('.popup_g').hide();
            // }
            // $(".dim_g").click(function(){
            //     $('.popup_g').hide();
            // });
        </script>
    </body>
</html>