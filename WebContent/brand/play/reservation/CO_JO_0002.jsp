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
        <script src="./js/sub.js"></script>
        
        <link rel="stylesheet" href="http://code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" type="text/css" />
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
        <script src="http://code.jquery.com/ui/1.8.18/jquery-ui.min.js"></script>
        
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
        <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
        <script src="/js/jquery-1.10.2.min.js"></script>
		<!-- <script src="/js/jquery-1.8.2.min.js"></script> -->
		<script src="/js/jquery.easing.1.3.js"></script>
		<script src="/js/jquery.cycle.all.min.js"></script>
		<script src="/js/jquery.mousewheel.min.js"></script>
		<!-- <script src="/js/jquery-ui-1.8.23.custom.min.js"></script> -->
		<script src="/js/jquery-efuSlider.js"></script>
		<script src="/mobile/js/iscroll.js"></script>
		<script src="/js/common.js?t=<%=System.currentTimeMillis()%>"></script>
		<script src="/js/efusioni.js?t=<%=System.currentTimeMillis()%>"></script>
		<script src="/js/jquery-ui.min.js"></script>
		<script src="/js/jquery.imgpreload.js"></script>
		<script src="/js/imagesloaded.pkgd.js"></script>
		<script src="/js/bluebird.min.js"></script>
		<script src="/mobile/js/swiper.min.js"></script>
		<script src="/mobile/js/slick.min.js"></script>
		<script src="/mobile/js/jquery-ui.js?t=<%=System.currentTimeMillis()%>"></script>
    </head>
    <body>
        <div class="header_g">
            <div class="header_wrap">
                <a href="" class="gnb_logo"><span class="g_alt">상하농원</span></a>
                <button class="btn_allmenu mo_only"><span class="g_alt">전체메뉴</span></button>
                <div class="gnb_menu">
                    <a href="brand/introduce/story.jsp">고창상하농원</a>
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
                <div id="terms1" class="popup_wrap popup_exp">
                    <div class="popup_header">
                        <button type="button" onClick="popupClose()" class="btn_close"><span class="g_alt">닫기</span></button>
                    </div>
                    <div class="popup_body">
                        <b class="exp_title">개인정보 수집 및 이용동의</b>
                        <div class="terms_table flex_wrap mt20">
                            <div class="flex_item">
                                <b>수집항목</b>
                                <p>
				                                    이름, 아이디, 비밀번호, 휴대전화번호, <br/>
				                                    이메일, 기타 본인 확인 기관에서 제공하는 <br/>
                                    C.I, D.I 등의 추가적인 본인확인 정보
                                </p>
                            </div>
                            <div class="flex_item">
                                <b>이용목적</b>
                                <p>
                                    Maeil Do 포인트 적립 및 사용, 고객 안내 <br/>
				                                    및 CS 처리, 이용회원의 부정 이용 방지 <br/>
				                                    및 비인가 사용 방지
                                </p>
                            </div>
                            <div class="flex_item">
                                <b>보유 및 이용기간</b>
                                <p>
									홈페이지 회원 탈퇴 시 파기(홈페이지 <br/>
									1년 이상 미이용 시에는 개인정보가 <br/>
									분리 보관됨)
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="terms2" class="popup_wrap popup_exp">
                    <div class="popup_header">
                        <button type="button" onClick="popupClose()" class="btn_close"><span class="g_alt">닫기</span></button>
                    </div>
                    <div class="popup_body">
                        <b class="exp_title">개인정보 제3자 제공동의</b>
                        <!-- 24.03.07 modify : 약관 내용 구조 변경 (table -> div) START -->
                        <div class="terms_table flex_wrap mt20">
                            <div class="flex_item">
                                <b>제3자</b>
                                <p>
                                    상하농원(유)<br/>
                                    엠즈씨드(폴 바셋)<br/>
                                    엠즈씨드(크리스탈제이드)<br/>
                                    엠즈씨드(더 키친 일뽀르노)<br/>
                                    제로투세븐(궁중비책)
                                </p>
                            </div>
                            <div class="flex_item">
                                <b>이용목적</b>
                                <p>
                                    웹사이트 로그인, <br/>
                                    Maeil Do 포인트 적립 및 사용, <br/>
                                    기타 Maeil Do Point의 <br/>
                                    부가적인 서비스 제공 목적
                                </p>
                            </div>
                            <div class="flex_item">
                                <b>제공하는 개인정보항목</b>
                                <p>
                                    (필수)이름, 휴대전화번호, <br/>
                                    이메일, 주소, 성별, <br/>
                                    생년월일(선택)<br/>
                                    DM수신 정보, 아기생일, <br/>
                                    아기이름, 출산병원, <br/>
                                    이용한 조리원명, <br/>
                                    이용하는 분유 제품, 수유형태
                                </p>
                            </div>
                            <div class="flex_item">
                                <b>보유 및 이용기간</b>
                                <p>
                                    회원이 제휴사 이용약관에 <br/>
                                    동의한 때로부터 제휴사의 <br/>
                                    이용약관 철회 혹은 <br/>
                                    Maeil Do Point 탈퇴 시까지
                                </p>
                            </div>
                        </div>
                        <!-- 24.03.07 modify : 약관 내용 구조 변경 (table -> div) END -->
                    </div>
                </div>
                <div id="terms3" class="popup_wrap popup_exp">
                    <div class="popup_header">
                        <button type="button" onClick="popupClose()" class="btn_close"><span class="g_alt">닫기</span></button>
                    </div>
                    <div class="popup_body">
                        <b class="exp_title">홍보 및 마케팅 이용에 동의</b>
                        <table class="table_terms mt20">
                            <thead>
                                <tr>
                                    <th>수집항목</th>
                                    <th>이용목적</th>
                                    <th>보유 및 이용기간</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>
                                        이메일 수신동의, SMS 수신동의
                                    </td>
                                    <td>
                                        이벤트/쿠폰 등 광고성 정보 전달
                                    </td>
                                    <td>
                                        수신거부 또는 홈페이지 회원 탈퇴 시 <br/>
                                        파기(홈페이지 1년 이상 미이용 시에는 <br/>
                                        개인정보가 분리 보관됨)
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="content_wrap">
                <div class="step_title">회원가입</div>
                <div class="step_wrap">
                    <div class="step_item act">
                        <p>01</p>
                        <b>약관동의</b>
                    </div>
                    <div class="step_item">
                        <p>02</p>
                        <b>정보입력</b>
                    </div>
                    <div class="step_item">
                        <p>03</p>
                        <b>완료</b>
                    </div>
                </div>
                <form action="">
                    <section class="page_section">
                        <div class="section_title on">
                            서비스 이용 약관에 동의해 주세요.
                        </div>
                        <div class="section_content">
                            <div class="termsAgree_wrap">
                                <div class="check_g">
                                    <input type="checkbox" name="partyResAll" id="partyResAgree">
                                    <label onClick="checkAll('partyResAll','partyResCheck')" for="partyResAgree"><span class="fs18 fwBold">네, 모두 동의합니다.</span></label>
                                </div>
                                <ul class="termsAgree_list mt20">
                                    <li>
                                        <div class="check_g">
                                            <input type="checkbox" name="partyResCheck" id="partyRes1">
                                            <label for="partyRes1"><span>[필수] 만 14세 이상입니다.</span></label>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="check_g">
                                            <input type="checkbox" name="partyResCheck" id="partyRes2">
                                            <label for="partyRes2"><span>[필수] Maeil Do 멤버십 이용약관에 동의</span></label>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="check_g">
                                            <input type="checkbox" name="partyResCheck" id="partyRes3">
                                            <label for="partyRes3"><span>[필수] 개인정보 수집 이용에 동의</span></label>
                                        </div>
                                        <button type="button" onClick="popupOpen('terms1')" class="terms_g">보기</button>
                                    </li>
                                    <li>
                                        <div class="check_g">
                                            <input type="checkbox" name="partyResCheck" id="partyRes4">
                                            <label for="partyRes4"><span>[선택] 개인정보 제3자 제공에 동의('상하농원' 필수)</span></label>
                                        </div>
                                        <button type="button" onClick="popupOpen('terms2')" class="terms_g">보기</button>
                                        <div class="bgbox_g bgF4F4F4 mt20">
                                            <div class="check_g">
                                                <input type="checkbox" name="partyResCheck" id="partyRes41">
                                                <label for="partyRes41"><span class="group_sangha">상하농원(유)</span></label>
                                            </div>
                                            <div class="check_g">
                                                <input type="checkbox" name="partyResCheck" id="partyRes42">
                                                <label for="partyRes42"><span class="group_maeil">매일유업㈜</span></label>
                                            </div>
                                            <div class="check_g">
                                                <input type="checkbox" name="partyResCheck" id="partyRes43">
                                                <label for="partyRes43"><span class="group_pb">엠즈씨드<br/>(폴바셋)</span></label>
                                            </div>
                                            <div class="check_g">
                                                <input type="checkbox" name="partyResCheck" id="partyRes44">
                                                <label for="partyRes44"><span class="group_cj">엠즈씨드<br/>(크리스탈제이드)</span></label>
                                            </div>
                                            <div class="check_g">
                                                <input type="checkbox" name="partyResCheck" id="partyRes45">
                                                <label for="partyRes45"><span class="group_if">엠즈씨드<br/>(더키친 일뽀르노)</span></label>
                                            </div>
                                            <div class="check_g">
                                                <input type="checkbox" name="partyResCheck" id="partyRes46">
                                                <label for="partyRes46"><span class="group_goongbe">제로투세븐<br/>(궁중비책)</span></label>
                                            </div>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="check_g">
                                            <input type="checkbox" name="partyResCheck" id="partyRes5">
                                            <label for="partyRes5"><span>[선택] 홍보 및 마케팅 이용에 동의</span></label>
                                        </div>
                                        <button type="button" onClick="popupOpen('terms3')" class="terms_g">보기</button>
                                        <div class="mt20 ml24">
                                            <div class="check_g inB">
                                                <input type="checkbox" name="partyResCheck" id="partyRes51">
                                                <label for="partyRes51"><span>SMS</span></label>
                                            </div>
                                            <div class="check_g inB">
                                                <input type="checkbox" name="partyResCheck" id="partyRes52">
                                                <label for="partyRes52"><span>이메일</span></label>
                                            </div>
                                        </div>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div class="divLine mt40"></div>
                    </section>
                    <div class="btn_area mt40">
                        <button class="btn_submit">다음</button>
                    </div>
                    <div class="text_des ac mt20">
                        •‘선택’ 항목에 동의하지 않아도 서비스 이용이 가능합니다.<br/>
                        개인정보 수집 및 이용에 대한 동의를 거부할 권리가 있으며, 동의 거부 시 회원제 서비스 이용이 제한됩니다.
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
            function popupOpen(popId){
                $('.popup_g').show();
                if (popId != ''){
                    $('.popup_wrap').hide();
                    $('#' + popId + '.popup_wrap').show();
                }else{
                    $('.popup_wrap').show();
                }
            }
            function popupClose(){
                $('.popup_g').hide();
            }
            $(".dim_g").click(function(){
                $('.popup_g').hide();
            });
        </script>
    </body>
</html>