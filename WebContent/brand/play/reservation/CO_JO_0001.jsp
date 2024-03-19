<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sanghafarm.common.FrontSession"%>
<%@ page import="com.efusioni.stone.security.CryptoUtil"%>
<%@ page import="com.efusioni.stone.common.SystemChecker"%>
<%@ page import="com.efusioni.stone.utils.Utils"%>
<%@ page import="com.efusioni.stone.common.Config"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="com.efusioni.stone.utils.Param"%>
<%
    // String strReturnUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/joinSns1.jsp"; //SNS계정 미가입 URL
    
	request.setAttribute("Depth_1", new Integer(2));
    Param param = new Param(request);
	String snsLoginUrl   = Config.get("api.auth.snsLogin." + SystemChecker.getCurrentName()); //APIURL
	String strCoopcoCd   = Config.get("join.parameter.coopcoCd");        //제휴사코드
// 	String strChnlCd     = Config.get("join.parameter.chnlCd");          //채널코드
	String strChnlCd     = SanghafarmUtils.getChnlCd(request);                         //채널코드
// 	String strNtryPath   = Config.get("join.parameter.ntryPath");        //사이트코드
	String strNtryPath   = SanghafarmUtils.getNtryPath(request);                       //사이트코드
	String strReturnUrl  = request.getScheme() + "://" + request.getServerName() + "/mobile/member/snsLoginProc.jsp"; //URL(sns로그인)
	String strLoginUrl   = request.getScheme() + "://" + request.getServerName() + "/mobile/member/loginProc.jsp"; //URL(일반로그인)
	String strIp         = request.getRemoteAddr();                      //IP주소
	String strResult     = "";                                           //전송결과
	String strMessage    = "";                                           //결과메세지
	String strResultCode ="";                                            //결과코드
	String strUnfyMmbNo  = "";                                           //통합회원번호
	String strSocId      = "";                                           //소셜아이디
	String strSocNm      = "";                                           //소셜이름
	String strErr        = "";                                           //에러판별
	String strId         = SanghafarmUtils.getCookie(request, "saveid"); //저장된 아이디
	String strSaveFlg    = SanghafarmUtils.getCookie(request, "saveidflg"); //아이디저장플레그
	FrontSession fs      = FrontSession.getInstance(request, response);
	String device_Type   = fs.getDeviceType();
	String referUrl      = request.getHeader("referer");
	if(referUrl == null || "".equals(referUrl)) {
		referUrl = Utils.safeHTML(param.get("returnUrl"));
	}

	//sns로그인URL작성
	snsLoginUrl = snsLoginUrl + "?coopcoCd=" + strCoopcoCd 
			                  + "&chnlCd=" + strChnlCd
			                  + "&ntryPath=" + strNtryPath
			                  + "&returnUrl=" + strReturnUrl
			                  + "&clientIp=" + strIp
			                  + "&socKindCd=";
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
        <script src="${pageContext.request.contextPath}/js/sub.js"></script>
        
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
		<script>
		var doubleSubmitFlag = false;    // 이중처리방지 플레그
		var snsUrl = "";
		var saveIdFlg = "<%=strSaveFlg%>";
		var deviceType = "<%=device_Type%>";
		var id = "<%=strId%>";
		$(document).ready(function(){
			if(saveIdFlg == "true"){
				$("#idSave").prop("checked", true);
				$("#userId").val(id);
			}
			
			if(deviceType == "A"){
				$("#loginAuto").show();
				$("#loginAutoLab").show();
			}
			
			$("#userPwd").keyup(function (e) {
		        if (e.keyCode === 13) {
		        	login();
				}
		    });
		});
		/***************************************
		 * SNS로그인
		 **************************************/
		function snsLogin(snsKind) {
			
//		    	sessionStorage.setItem('snsKind', snsKind);
		  	setCookie("cookieSnsKind", snsKind, 1);
		  	
			//이중처리방지
		   if(doubleSubmitCheck()) return;
		   snsUrl = "<%=snsLoginUrl %>" + snsKind;
		   location.href = snsUrl;
			
		   doubleSubmitFlag = false; 
		   
		}

		//이중처리방지
		function doubleSubmitCheck(){
		    if(doubleSubmitFlag){
		        return doubleSubmitFlag;
		    }else{
		        doubleSubmitFlag = true;
		    }
		}
		</script>
    </head>
    <body>
        <div class="header_g">
            <div class="header_wrap">
                <a href="/index2.jsp" class="gnb_logo"><span class="g_alt">상하농원</span></a>
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
            <div class="box_wrap box1080">
                <p class="box_title">회원가입</p>
                <p class="box_subtitle mt20 fs18"><span class="fcBlue">Maeil Do!</span> 통합멤버십 가입을 환영합니다.</p>
                <div class="btn_area mt40">
                    <button type="button" class="btn_submit w300" onclick="location.href='/brand/play/reservation/CO_JO_0002.jsp'">일반가입</button>
                </div>
                <div class="login_etc">
                    <div class="login_sns sns_join">
                        <p class="hr_or">
                            <span>SNS 계정으로 가입하기</span>
                        </p>
                        <div class="btn_area mt20">
                            <a class="btn_kakao"><span class="btn_title" onclick="snsLogin('K');">카카오톡 로그인</span></a>
                            <a class="btn_naver"><span class="btn_title" onclick="snsLogin('N');">네이버 로그인</span></a>
                            <a class="btn_facebook"><span class="btn_title" onclick="snsLogin('F');">페이스북 로그인</span></a>
                        </div>
                    </div>
                    <div class="ac mt50">
                        <span class="login_use">이미 가입하셨나요?<a href="" class="fcGreen fwBold">로그인하기</a></span><!-- 링크추가필요 -->
                    </div>
                </div>
            </div>
            <div class="bgbox_g w1080 mt40">
                <p class="bgbox_title">Maeil Do 통합멤버십에 가입하시면<br/> 하나의 계정으로 6개 제휴브랜드 혜택을 모두 누리실 수 있습니다.</p>
                <p class="bgbox_des">(각 브랜드별 약관 동의 시 이용 가능)</p>
                <div class="memberGroup">
                    <p class="group_maeil">매일유업㈜</p>
                    <p class="group_goongbe">제로투세븐<br/>(궁중비책)</p>
                    <p class="group_sangha">상하농원(유)</p>
                    <p class="group_pb">엠즈씨드<br/>(풀바셋)</p>
                    <p class="group_cj">엠즈씨드<br/>(크리스탈제이드)</p>
                    <p class="group_if">엠즈씨드<br/>(더키친 일뽀르노)</p>
                </div>
                <div class="fs14 lh16 fcGray ac mt30">
                    *상하가족 서비스를 이용하실 분은 SNS계정으로 가입, 로그인이 아닌 일반회원으로 가입, 로그인 해주세요!
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