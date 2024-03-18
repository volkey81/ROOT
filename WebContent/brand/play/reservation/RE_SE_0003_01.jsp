<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
                                <input type="checkbox" name="partyResAll" id="partyResAgree">
                                <label onClick="checkAll('partyResAll','partyResCheck')" for="partyResAgree"><span class="fs18 fwBold">네, 모두 동의합니다.</span></label>
                            </div>
                        </div>
                        <div class="mt30">
                            <div class="check_g">
                                <input type="checkbox" name="partyResCheck" id="partyRes1">
                                <label for="partyRes1"><span>취소/환불 규정에 대한 동의</span></label>
                            </div>
                            <div class="textarea_g readOnly">
                                <textarea name="" id="" redonly="redonly">기후상황, 개인사유 등에 따른 일정변경으로 인한 손해에 대해서는 상하농원에서 책임지지 않습니다. 취소/환불 규정에 동의 하시겠습니까?

이용 7일 전까지 취소 수수료 없음
이용 7일 전 ~ 당일 체험시작 20분 전까지 3set에 한해 수량 변경 가능
식사 예약 수량은 당일 10시 이전까지 인원의 10%내외에 한해 수량 변경 가능</textarea>
                            </div>
                        </div>
                        <div class="mt30">
                            <div class="check_g">
                                <input type="checkbox" name="partyResCheck" id="partyRes2">
                                <label for="partyRes2"><span>예약내역 동의</span></label>
                            </div>
                            <div class="textarea_g readOnly">
                                <textarea name="" id="" redonly="redonly">예약할 상품의 상품명, 사용일자 및 시간, 상품가격을 확인했습니다. (전자상거래법 제 8조 2항) 예약에 동의하시겠습니까?

상하농원 단체 체험은 20인 이상에 한해 예약이 가능합니다.
체험 시작 이후에는 입장이 제한됩니다. (체험시작 20분 전까지 매표소 도착)
40명 이상 단체의 경우 추가 포장시간이 2시간까지 소요될 수 있습니다.</textarea>
                            </div>
                        </div>
                        <div class="btn_area mt40">
                            <button class="btn_submit">확인</button>
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
                <form action="">
                    <section class="page_section">
                        <div class="section_title on">
                            <span>01</span>
                            날짜 선택
                        </div>
                        <div class="section_content">
                            <div class="reserveDate_wrap">
                                <p class="input_date w290">
                                    <input type="text" id="res_date" value="2024.01.01">
                                </p>
                            </div>
                        </div>
                    </section>
                    <section class="page_section">
                        <div class="section_title on">
                            <span>02</span>
                            예약자 정보
                        </div>
                        <div class="section_content">
                            <strong class="content_title blk">농원 내 식당을 이용할 계획이면 체크해주세요.</strong>
                            <div class="radio_g mt10">
                                <input type="radio" name="restaurant" id="rest_1">
                                <label for="rest_1"><span>농원식당</span></label>
                            </div>
                            <div class="radio_g mt10 ml30">
                                <input type="radio" name="restaurant" id="rest_2">
                                <label for="rest_2"><span>상하키친</span></label>
                            </div>
                            <div class="divLine mt20 mb20"></div>
                            <div class="conLine">
                                <p class="conLine_title">체험 프로그램</p>
                                <select name="" id="" class="select_g select_medium">
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
                                <input type="text" class="input_g input_medium">
                            </div>
                            <div class="conLine">
                                <p class="conLine_title required">체험인원</p>
                                <input type="text" class="input_g input_medium"> 명
                            </div>
                            <div class="conLine">
                                <p class="conLine_title">참관인원</p>
                                <input type="text" class="input_g input_medium"> 명
                            </div>
                            <div class="conLine">
                                <p class="conLine_title">휴대폰번호</p>
                                <select name="" id="" class="select_g select_small tel_input">
                                    <option value="010">010</option>
                                </select>
                                <input type="text" class="input_g input_small tel_input ml10">
                                <input type="text" class="input_g input_small tel_input ml10">
                            </div>
                            <div class="conLine">
                                <p class="conLine_title">연령대</p>
                                <select name="" id="" class="select_g select_medium">
                                    <option value="">3~6세</option>
                                </select>
                            </div>
                            <div class="conLine">
                                <p class="conLine_title required">기타 문의</p>
                                <div class="textarea_g">
                                    <textarea name="" id=""></textarea>
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
                                    <input type="checkbox" name="partyResAgree" id="partyResAgree">
                                    <label for="partyResAgree"><span>이용약관 동의</span></label>
                                </div>
                                <button type="button" onClick="popupOpen('terms')" class="terms_g">보기</button>
                            </div>
                        </div>
                    </section>

                    <div class="btn_area mo_btn2 mt40">
                        <button class="btn_line w300">이전으로</button>
                        <button class="btn_submit ml30">상담등록</button>
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
            $(function() {
                $( "#res_date" ).datepicker({
                    dateFormat:"yy년 m월 d일(DD)",
                    showOn:"both",
                    buttonImage:"./image/icn_cal_b.png",
                    buttonImageOnly:"true",
                    monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'],
                    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
                    dayNamesMin: ['일','월','화','수','목','금','토'],
                    dayNames: ['일','월','화','수','목','금','토']
                });
                $('#res_date').datepicker('setDate', 'today');
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