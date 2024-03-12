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
            <div class="pagetop_wrap pagetop_04">
                <p class="pagetop_title">짓다, 놀다, 먹다</p>
                <p class="pagetop_des">체험</p>
            </div>
            <div class="content_wrap">
                <div class="step_wrap">
                    <div class="step_item act pre">
                        <p>01</p>
                        <b>체험선택</b>
                    </div>
                    <div class="step_item act">
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
                            프로그램 정보
                        </div>
                        <div class="section_content">
                            <div class="conLine_Wrap">
                                <div class="conLine w50p">
                                    <p class="conLine_title">예약 희망일 ①</p>
                                    <em class="conLine_content">2024년 1월 30일 (월)</em>
                                </div>
                                <div class="conLine">
                                    <p class="conLine_title">예약 희망일 ②</p>
                                    <em class="conLine_content">2024년 1월 30일 (월)</em>
                                </div>
                            </div>
                            
                            <ul class="program_wrap">
                                <li id="program1" class="program_type1">
                                    <p class="program_title">치즈 & 피자 만들기 체험</p>
                                    <div class="program_time">
                                        <div class="check_g inB wAuto">
                                            <input type="checkbox" name="" id="pro1time1">
                                            <label for="pro1time1"><span>오전</span></label>
                                        </div>
                                        <div class="check_g inB wAuto ml30">
                                            <input type="checkbox" name="" id="pro1time2">
                                            <label for="pro1time2"><span>오후</span></label>
                                        </div>
                                    </div>
                                    <div class="program_detail">
                                        <div class="detail_people">
                                            <div class="people_wrap">
                                                <span class="wrap_title">성인</span>
                                                <button type="button" onClick="countminus('item1')" class="btn_minus brNone">-</button>
                                                <input type="number" id="item1" class="input_g input_people" value="1">
                                                <button type="button" onClick="countplus('item1')" class="btn_plus blNone">+</button>
                                            </div>
                                            <div class="people_wrap">
                                                <span class="wrap_title">학생</span>
                                                <button type="button" onClick="countminus('item2')" class="btn_minus brNone">-</button>
                                                <input type="number" id="item2" class="input_g input_people" value="0">
                                                <button type="button" onClick="countplus('item2')" class="btn_plus blNone">+</button>
                                            </div>
                                            <div class="people_wrap">
                                                <span class="wrap_title">유아</span>
                                                <button type="button" onClick="countminus('item3')" class="btn_minus brNone">-</button>
                                                <input type="number" id="item3" class="input_g input_people" value="0">
                                                <button type="button" onClick="countplus('item3')" class="btn_plus blNone">+</button>
                                            </div>
                                        </div>
                                    </div>
                                </li>
                                <li class="program_type2">
                                    <p class="program_title">공장견학</p>
                                    <div class="program_time">
                                        <div class="check_g inB wAuto">
                                            <input type="checkbox" name="" id="pro2time1">
                                            <label for="pro2time1"><span>오전</span></label>
                                        </div>
                                        <div class="check_g inB wAuto ml30">
                                            <input type="checkbox" name="" id="pro2time2">
                                            <label for="pro2time2"><span>오후</span></label>
                                        </div>
                                    </div>
                                    <div class="program_detail">
                                        <div class="detail_people">
                                            <div class="people_wrap">
                                                <span class="wrap_title">성인</span>
                                                <button type="button" onClick="countminus('item4')" class="btn_minus brNone">-</button>
                                                <input type="number" id="item4" class="input_g input_people" value="1">
                                                <button type="button" onClick="countplus('item4')" class="btn_plus blNone">+</button>
                                            </div>
                                            <div class="people_wrap">
                                                <span class="wrap_title">학생</span>
                                                <button type="button" onClick="countminus('item5')" class="btn_minus brNone">-</button>
                                                <input type="number" id="item5" class="input_g input_people" value="0">
                                                <button type="button" onClick="countplus('item5')" class="btn_plus blNone">+</button>
                                            </div>
                                            <div class="people_wrap">
                                                <span class="wrap_title">유아</span>
                                                <button type="button" onClick="countminus('item6')" class="btn_minus brNone">-</button>
                                                <input type="number" id="item6" class="input_g input_people" value="0">
                                                <button type="button" onClick="countplus('item6')" class="btn_plus blNone">+</button>
                                            </div>
                                        </div>
                                        <div class="detail_transport">
                                            <span class="wrap_title">이동수단</span>
                                            <div class="radio_g radio_check">
                                                <input type="radio" name="transport" id="bus">
                                                <label for="bus"><span>버스</span></label>
                                            </div>
                                            <div class="radio_g radio_check ml30">
                                                <input type="radio" name="transport" id="car">
                                                <label for="car"><span>자차</span></label>
                                            </div>
                                            <div class="radio_g radio_check ml30">
                                                <input type="radio" name="transport" id="wark">
                                                <label for="wark"><span>도보</span></label>
                                            </div>
                                        </div>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </section>
                    <section class="page_section">
                        <div class="section_title on">
                            예약자 정보
                        </div>
                        <div class="section_content">
                            <div class="divLine mt30 mb20"></div>
                            <div class="conLine">
                                <p class="conLine_title required"><span>*</span>단체명</p>
                                <input type="text" class="input_g input_medium">
                            </div>
                            <div class="conLine">
                                <p class="conLine_title required"><span>*</span>신청자 성명</p>
                                <input type="text" class="input_g input_medium">
                            </div>
                            <div class="conLine">
                                <p class="conLine_title required"><span>*</span>연락처</p>
                                <select name="" id="" class="select_g select_small">
                                    <option value="010">010</option>
                                </select>
                                <input type="text" class="input_g input_small ml10">
                                <input type="text" class="input_g input_small ml10">
                                <button class="btn_g btn_gray ml10 w150">인증번호 요청</button>
                            </div>
                            <div class="conLine">
                                <p class="conLine_title required"><span>*</span>인증번호 확인</p>
                                <input type="text" class="input_g input_medium">
                                <button class="btn_g btn_gray ml10 w150">확인</button>
                            </div>
                            <div class="conLine">
                                <p class="conLine_title required">상하농원 식당 이용</p>
                                <div class="radio_g mt10">
                                    <input type="radio" name="restaurant" id="restaurantY">
                                    <label for="restaurantY"><span>예</span></label>
                                </div>
                                <div class="radio_g mt10 ml30">
                                    <input type="radio" name="restaurant" id="restaurantN">
                                    <label for="restaurantN"><span>아니오</span></label>
                                </div>
                            </div>
                            <div class="conLine">
                                <p class="conLine_title required">기타 문의</p>
                                <div class="textarea_g">
                                    <textarea name="" id=""></textarea>
                                </div>
                            </div>
                            <div class="divLine mt20 mb20"></div>
                            <div class="agree_wrap">
                                <div class="check_g check_agree">
                                    <input type="checkbox" name="partyResAgree" id="partyResAgree">
                                    <label for="partyResAgree"><span>이용약관 동의</span></label>
                                </div>
                                <a href="" class="agree_terms">자세히</a>
                            </div>
                        </div>
                    </section>

                    <div class="btn_area mt40">
                        <button class="btn_line w300 mr30">이전으로</button>
                        <button class="btn_submit">예약 접수하기</button>
                    </div>
                </form>
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