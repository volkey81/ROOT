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
            <div class="box_wrap box1080">
                <p class="box_title">로그인</p>
                <form action="" class="form_login">
                    <input type="text" placeholder="아이디" class="input_g">
                    <input type="text" placeholder="비밀번호" class="input_g mt10">
                    <div class="mt15 f_g">
                        <div class="fl">
                            <div class="check_g">
                                <input type="checkbox" id="saveId">
                                <label for="saveId"><span>아이디 저장</span></label>
                            </div>
                        </div>
                        <p class="fr">
                            <a href="" class="login_util">아이디 찾기</a>
                            <a href="" class="login_util">비밀번호 찾기</a>
                        </p>
                    </div>
                    <div class="btn_area mt30">
                        <a type="button" class="btn_submit inB w100p">로그인</a>
                    </div>
                </form>
                <div class="login_etc">
                    <div class="login_sns">
                        <p class="hr_or">
                            <span>또는</span>
                        </p>
                        <div class="btn_area mt20">
                            <a class="btn_kakao"><span class="g_alt">카카오톡 로그인</span></a>
                            <a class="btn_naver"><span class="g_alt">네이버 로그인</span></a>
                            <a class="btn_facebook"><span class="g_alt">페이스북 로그인</span></a>
                        </div>
                    </div>
                    <div class="btn_area mt20">
                        <a class="btn_line inB w100p">비회원 주문/예약 조회</a>
                    </div>
                </div>
                <div class="bgbox_g mt30">
                    <p class="bgbox_title">상하농원 회원이 아니신가요</p>
                    <p class="bgbox_des">
                        상하농원의 회원으로 Maeil Do 통합멤버십에 가입하시면 <br/>
                        상하농원 뿐 아니라 <span class="fcGreen fwBold">6개 제휴브랜드 이용 시 다양한 혜택</span>을 누리실 수 있습니다.
                    </p>
                    <div class="memberGroup">
                        <p class="group_maeil">매일유업㈜</p>
                        <p class="group_goongbe">제로투세븐<br/>(궁중비책)</p>
                        <p class="group_sangha">상하농원(유)</p>
                        <p class="group_pb">엠즈씨드<br/>(풀바셋)</p>
                        <p class="group_cj">엠즈씨드<br/>(크리스탈제이드)</p>
                        <p class="group_if">엠즈씨드<br/>(더키친 일뽀르노)</p>
                    </div>
                    <div class="btn_area mt20">
                        <a class="btn_line inB w400">상하농원 회원 가입하기</a>
                    </div>
                </div>
            </div>
        </div>
        <div class="footer_g">
            <div class="footer_wrap flex_wrap">
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
                    buttonImage:"${pageContext.request.contextPath}/image/icn_cal_b.png",
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