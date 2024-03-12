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
<%@ include file="/order/kakaopay/incKakaopayCommon.jsp" %>
<%@ include file="/order/payco/common_include.jsp" %>
<%
	response.sendRedirect("admission.jsp");
	if(true) return;
	
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(6));
	request.setAttribute("Depth_4", new Integer(2));
	request.setAttribute("MENU_TITLE", new String("예약하기"));

	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessageMobile(out, FrontSession.LOGIN_MSG, request);
		return;
	}

// 	request.setCharacterEncoding("utf-8");

	/*
	 * [결제 인증요청 페이지(STEP2-1)]
	 *
	 * 샘플페이지에서는 기본 파라미터만 예시되어 있으며, 별도로 필요하신 파라미터는 연동메뉴얼을 참고하시어 추가 하시기 바랍니다.
	 */
	
	/*
	 * 1. 기본결제 인증요청 정보 변경
	 *
	 * 기본정보를 변경하여 주시기 바랍니다.(파라미터 전달시 POST를 사용하세요)
	 */
			
	String CST_PLATFORM         = SystemChecker.isReal() ? "service" : "test";          //LG유플러스 결제서비스 선택(test:테스트, service:서비스)
	String CST_MID              = Config.get("lgdacom.CST_MID3");                      //LG유플러스로 부터 발급받으신 상점아이디를 입력하세요.
	String LGD_MID              = ("test".equals(CST_PLATFORM.trim())?"t":"")+CST_MID;  //테스트 아이디는 't'를 제외하고 입력하세요.
	                                                                                    //상점아이디(자동생성)
	String LGD_OID              = ""							;                      //주문번호(상점정의 유니크한 주문번호를 입력하세요)
	String LGD_AMOUNT           = "0";								                   //결제금액("," 를 제외한 결제금액을 입력하세요)
	String LGD_MERTKEY          = Config.get("lgdacom.LGD_MERTKEY3");   					//상점MertKey(mertkey는 상점관리자 -> 계약정보 -> 상점정보관리에서 확인하실수 있습니다)
	String LGD_BUYER            = "";                    //구매자명
	String LGD_PRODUCTINFO      = "체험권";              //상품명
	String LGD_BUYEREMAIL       = "";               //구매자 이메일
	String LGD_TIMESTAMP        = Utils.getTimeStampString("yyyyMMddHHmmss");                //타임스탬프
	String LGD_CUSTOM_USABLEPAY = "SC0010";        	//상점정의 초기결제수단
	String LGD_CUSTOM_SKIN      = "SMART_XPAY2";                                                //상점정의 결제창 스킨(red, yellow, purple)
	String LGD_CUSTOM_SWITCHINGTYPE = "SUBMIT"; //신용카드 카드사 인증 페이지 연동 방식 (수정불가)
	String LGD_WINDOW_VER		= "2.5";												//결제창 버젼정보
	String LGD_WINDOW_TYPE      = "submit";               //결제창 호출 방식 (수정불가)

	String LGD_TAXFREEAMOUNT	= "0";	// 면세금액
	
	/*
	 * LGD_RETURNURL 을 설정하여 주시기 바랍니다. 반드시 현재 페이지와 동일한 프로트콜 및  호스트이어야 합니다. 아래 부분을 반드시 수정하십시요.
	 */
	String LGD_RETURNURL		= (SystemChecker.isReal() ? "https" : "http") + "://" + request.getServerName() + "/order/xpay/mreturnurl2.jsp";// FOR MANUAL

	String userAgent2 = request.getHeader("User-Agent").toLowerCase();
    
	String LGD_MTRANSFERAUTOAPPYN = "A";
	String LGD_KVPMISPAUTOAPPYN = "A";
	String LGD_MONEPAYAPPYN = "N";
    String LGD_MTRANSFERNOTEURL = "A";

    String LGD_MTRANSFERWAPURL = "sanghafarm://";
    String LGD_MTRANSFERCANCELURL = "sanghafarm://";
    
    String LGD_KVPMISPNOTEURL = "A";
    String LGD_KVPMISPWAPURL =  "sanghafarm://";
    String LGD_KVPMISPCANCELURL = "sanghafarm://";
    String LGD_MONEPAY_RETURNURL = "sanghafarm://";
	
    // ios에서 동기방식(WEB).
	if(userAgent2.indexOf("iphone") > -1 || userAgent2.indexOf("ipad") > -1 || userAgent2.indexOf("ipod") > -1){
    	LGD_MTRANSFERAUTOAPPYN = "N";
    	LGD_KVPMISPAUTOAPPYN = "N";
    	LGD_MTRANSFERNOTEURL = "N";
    }

    if("A".equals(fs.getDeviceType())) {
    	LGD_MTRANSFERAUTOAPPYN = "A";
    	LGD_KVPMISPAUTOAPPYN = "A";
    	LGD_MONEPAYAPPYN = "Y";
    }

    //TODO KaKaoPay의 INBOUND 전문 URL SETTING
	String msgName = "merchant/requestDealApprove.dev";
	String webPath = "https://kmpay.lgcns.com:8443/"; //PG사의 인증 서버 주소

	OrderService order = (new OrderService()).toProxyInstance();
	CouponService coupon = (new CouponService()).toProxyInstance();
	ImMemberService immem = (new ImMemberService()).toProxyInstance();
	CodeService code = (new CodeService()).toProxyInstance();
	MemberService member = (new MemberService()).toProxyInstance();

	int point = immem.getMemberPoint(fs.getUserNo());
	String orderid = order.getNewId();
	member.modifyOrderid(fs.getUserId(), orderid);
	LGD_OID = orderid;

	LGD_RETURNURL += "?orderid=" + orderid;
	System.out.println("-------------- LGD_RETURNURL : " + LGD_RETURNURL);
	
	Param memInfo = member.getInfo(fs.getUserId());
	String payType = memInfo.get("pay_type", "001");
	if(payType.equals("003")) payType = "001";
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<!-- payco -->
<script type="text/javascript" src="https://static-bill.nhnent.com/payco/checkout/js/payco.js" charset="UTF-8"></script>
<!-- // payco -->

<!-- 카카오 css, javascript 시작 -->
<!-- OpenSource Library -->
<script src="https://pg.cnspay.co.kr:443/dlp/scripts/lib/easyXDM.min.js" type="text/javascript"></script>
<script src="https://pg.cnspay.co.kr:443/dlp/scripts/lib/json3.min.js" type="text/javascript"></script>

<!-- JQuery에 대한 부분은 site마다 버전이 다를수 있음 -->
<script src="<%=webPath %>/js/dlp/lib/jquery/jquery-1.11.1.min.js" charset="utf-8"></script>

<!-- DLP창에 대한 KaKaoPay Library -->
<script src="<%=webPath %>/js/dlp/client/kakaopayDlpConf.js" charset="utf-8"></script>
<script src="<%=webPath %>/js/dlp/client/kakaopayDlp.min.js" charset="utf-8"></script> 
<!-- kakaopayLiteRequest에서 jquery 충돌이 나서 회피하려고 할때 변경사항 -->
<!-- <script src="<%=webPath %>/js/dlp/client/kakaopayDlp.pure.min.js" charset="utf-8"></script> -->

<!-- 인증 화면 호출 시 필요한 css 설정 -->
<link href="https://pg.cnspay.co.kr:443/dlp/css/kakaopayDlp.css" rel="stylesheet" type="text/css" />
<!-- 카카오 css, javascript  -->

<script language="javascript" src="http://xpay.uplus.co.kr/xpay/js/xpay_crossplatform.js" type="text/javascript"></script>
<script type="text/javascript">

/*
* 수정불가.
*/
	var LGD_window_type = '<%=LGD_WINDOW_TYPE%>';
	
/*
* 수정불가
*/
function launchCrossPlatform(){
	if($("#LGD_EASYPAY_ONLY").val() == "PAYNOW") {
		lgdwin = openXpay(document.getElementById('orderForm'), '<%= CST_PLATFORM %>', LGD_window_type, null, "600", "400");
	} else {
		lgdwin = openXpay(document.getElementById('orderForm'), '<%= CST_PLATFORM %>', LGD_window_type, null, "", "");
	}
}
/*
* FORM 명만  수정 가능
*/
function getFormObject() {
        return document.getElementById("orderForm");
}

/*
 * 인증결과 처리
 */
function payment_return() {
	var fDoc;
	
		fDoc = lgdwin.contentWindow || lgdwin.contentDocument;
	
		
	if (fDoc.document.getElementById('LGD_RESPCODE').value == "0000") {
			document.getElementById("LGD_PAYKEY").value = fDoc.document.getElementById('LGD_PAYKEY').value;
			document.getElementById("orderForm").target = "_self";
			document.getElementById("orderForm").action = "<%= Env.getSSLPath() %>/brand/play/reservation/orderProc.jsp";
			document.getElementById("orderForm").submit();
	} else {
		alert("LGD_RESPCODE (결과코드) : " + fDoc.document.getElementById('LGD_RESPCODE').value + "\n" + "LGD_RESPMSG (결과메시지): " + fDoc.document.getElementById('LGD_RESPMSG').value);
		closeIframe();
	}
}

</script>

<script>
	/*
	 * 카카오페이 스크립트 블럭 시작
	 */
	
	function cnspay() {
	    if($("input[name=pay_type]:checked").val() == "005"){
	    	var mobileNum = "";
	    	
    		mobileNum = $("select[name=mobile1]").val() + "-" + $("input[name=mobile2]").val() + "-" + $("input[name=mobile3]").val();
	    	
	        // 결과코드가 00(정상처리되었습니다.)
	        if(document.orderForm.resultCode.value == '00') {
	    
	        	// TO-DO : 가맹점에서 해줘야할 부분(TXN_ID)과 KaKaoPay DLP 호출 API
	            kakaopayDlp.setTxnId(document.orderForm.txnId.value);
	    
	          	//DLP에 휴대전화 번호를 미리 셋팅 할 수 있음. 사용 안할 시 사용자가 직접 입력.
	            kakaopayDlp.setChannelType('WPM', 'TMS'); // PC결제
	            //kakaopayDlp.setChannelType('MPM', 'WEB'); // 모바일 웹(브라우저)결제
	            kakaopayDlp.addRequestParams({ MOBILE_NUM : mobileNum}); // 초기값 세팅
	            
				//크롬엔진 버그 회피를 위한 dummy page가 필요할때 설정
				//kakaopayDlp.setDummyPageFlag(true);
	
				//div 태그(kakaopay_layer)에 가맹점 자체 css를 적용옵션
				//kakaopayDlp.setCustomTargetLayerCssFlag(true);     
				
				//DLP 호출
	            kakaopayDlp.callDlp('kakaopay_layer', document.orderForm, submitFunc);
	            
	        } else {
	            alert('[RESULT_CODE] : ' + document.orderForm.resultCode.value + '\n[RESULT_MSG] : ' + document.orderForm.resultMsg.value);
	        }
	    }
	}
	
	function getTxnId(){
        // form에 iframe 주소 세팅
        document.orderForm.target = "txnIdGetterFrame";
        document.orderForm.action = "/order/kakaopay/getTxnId.jsp";
        document.orderForm.acceptCharset = "utf-8";
        if (orderForm.canHaveHTML) { // detect IE
            document.charset = orderForm.acceptCharset;
        }
        
        // post로 iframe 페이지 호출
        document.orderForm.submit();
        
        // orderForm의 타겟, action을 수정한다
        document.orderForm.target = "";
        document.orderForm.action = "<%= Env.getSSLPath() %>/brand/play/reservation/orderProc.jsp";
        document.orderForm.acceptCharset = "utf-8";
        if (orderForm.canHaveHTML) { // detect IE
        	orderForm.charset = orderForm.acceptCharset;
        }
        // getTxnId.jsp의 onload 이벤트를 통해 cnspay() 호출
	}
	
	var submitFunc = function cnspaySubmit(data){
	    
	    if(data.RESULT_CODE === '00') {
	        
	        // 부인방지토큰은 기본적으로 name="NON_REP_TOKEN"인 input박스에 들어가게 되며, 아래와 같은 방법으로 꺼내서 쓸 수도 있다.
	        // 해당값은 가군인증을 위해 돌려주는 값으로서, 가맹점과 카카오페이 양측에서 저장하고 있어야 한다.
	        // var temp = data.NON_REP_TOKEN;
	
	        $("input[name=SPU]").val(data.SPU);
	        $("input[name=SPU_SIGN_TOKEN]").val(data.SPU_SIGN_TOKEN);
	        $("input[name=MPAY_PUB]").val(data.MPAY_PUB);
	        $("input[name=NON_REP_TOKEN]").val(data.NON_REP_TOKEN);
	        
// 			disableScreen();
	        document.orderForm.submit();
	        
	    } else if(data.RESULT_CODE === 'KKP_SER_002') {
	    	isProc = false;
			enableScreen();
	    } else {
	    	isProc = false;
			enableScreen();
	        alert('[RESULT_CODE] : ' + data.RESULT_CODE + '\n[RESULT_MSG] : ' + data.RESULT_MSG);
	    }
	    
	};
	
	function installmentOnChange(){
	    var paymentMethod = "CC"; //결제수단코드 - CC : 신용카드
	    var possiCardNum = document.getElementById('possiCard').value;
	    var fixedIntNum = document.getElementById('fixedInt').value;
	    
	    if( possiCardNum == '' || fixedIntNum == '' ){
	        document.getElementById('noIntOpt').value = "";
	        
	    } else {
	        // 무이자 할부를 선택함에 따라 넘겨줘야 하는 값(pdf 참조)
	        document.getElementById('noIntOpt').value = paymentMethod + possiCardNum + fixedIntNum;
	        
	    }
	}
	
	function noIntYNonChange(){
	    var noIntYN = document.getElementById('noIntYN').value;
	    var paymentMethod = "CC"; //결제수단코드 - CC : 신용카드
	    var possiCardNum = document.getElementById('possiCard').value;
	    var fixedIntNum = document.getElementById('fixedInt').value;
	    
	    if( noIntYN == 'N' ){
	        document.getElementById('noIntOpt').value = "";
	        
	    } else if( possiCardNum == '' || fixedIntNum == '' ){
	        document.getElementById('noIntOpt').value = "";
	        
	    } else {
	        // 무이자 할부를 선택함에 따라 넘겨줘야 하는 값(pdf 참조)
	        document.getElementById('noIntOpt').value = paymentMethod + possiCardNum + fixedIntNum;
	        
	    }
	}
	
	function maxIntChange(){
	    //최대할부개월에 따라서 고정할부개월의 선택 가능 범위 조정
	    
	}
	
	/*
	 * 카카오페이 스크립트 블럭 끝
	 */
</script>

<script>
	var paycoOrderUrl = "";
	
	//주문예약
	function callPaycoUrl(){
//		var Params = "customerOrderNumber=<%= orderid %>";
		var Params = $("#paycoReserveForm").serialize();
		
	    // localhost 로 테스트 시 크로스 도메인 문제로 발생하는 오류 
	    $.support.cors = true;
	
		/* + "&" + $('order_product_delivery_info').serialize() ); */
		
		$.ajax({
			type: "POST",
			url: "/order/payco/payco_reserve.jsp",
			data: Params,		// JSON 으로 보낼때는 JSON.stringify(customerOrderNumber)
			contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			dataType:"json",
			success:function(data){
				if(data.code == '0') {
					//console.log(data.result.reserveOrderNo);
// 					alert("code : " + data.code + "\n" + "message : " + data.message);
					paycoOrderUrl = data.result.orderSheetUrl;
// 					$('#order_num').val(data.result.reserveOrderNo);
// 					$('#order_url').val(data.result.orderSheetUrl);
// 					$('#order_sellerOrderReferenceKey').val(customerOrderNumber);
					payco_order_pop();
				}else{
					alert("code : " + data.code + "\n" + "message : " + data.message);
				}
			},
	        error: function(request,status,error) {
	            //에러코드
	            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
				return false;
	        }
		});

		/*
		ajaxSubmit("#paycoReserveForm", function(data) {
			if(data.code == '0') {
				$('#order_num').val(data.result.reserveOrderNo);
				$('#order_url').val(data.result.orderSheetUrl);
				$('#order_sellerOrderReferenceKey').val(customerOrderNumber);
			}else{
				alert("code : " + data.code + "\n" + "message : " + data.message);
			}
		});
		*/
		
	}
	
	// 결제하기
	function payco_order_pop(){
		
// 		var order_Url = $('#order_url').val(); 
		
		if(paycoOrderUrl == ""){
			alert(" 주문예약이 되어있지 않습니다. \n 주문예약을 먼저 실행 해 주세요.");
			return;
		}
		
		if(<%=isMobile%>){
// 			location.href = paycoOrderUrl;
// 			var paycowin = window.open(paycoOrderUrl, 'popupPayco', 'top=100, left=300, width=727px, height=512px, resizble=no, scrollbars=yes'); 
// 			if(paycowin == null) {
// 				alert("팝업 차단기능이 동작중입니다.\n팝업 차단 기능을 해제한 후 다시 시도하세요.");
// 			}
			$("#paycoOrderUrl").val(paycoOrderUrl);
			$("#orderForm").attr("action", "<%= Env.getSSLPath() %>/mobile/order/orderSessionPayco.jsp");
			$("#orderForm").submit();
		}else{
			var paycowin = window.open(paycoOrderUrl, 'popupPayco', 'top=100, left=300, width=727px, height=512px, resizble=no, scrollbars=yes'); 
			if(paycowin == null) {
				alert("팝업 차단기능이 동작중입니다.\n팝업 차단 기능을 해제한 후 다시 시도하세요.");
			}
		}
	}
	
	function payco_order() {
        $("#orderForm").submit();
	}
</script>

<script>
	var totPrice = 0;
	var couponAmt = 0;
	var pointAmt = 0;
	var payAmt = 0;
	var reservedNum = 0;
	var v;
	
	$(function(){
		var cSwiper = new Swiper($(".calenderArea .slideCont"), {
			slidesPerView: 1,
			spaceBetween: 15,
			prevButton: $(".calenderArea .prev"),
			nextButton: $(".calenderArea .next"),
			onSlideChangeEnd: function(swiper){	
				var idx = swiper.activeIndex;
			}
		});

		v = new ef.utils.Validator($("#orderForm"));
		
		v.add("name", {
			"empty" : "주문자 이름을 입력해 주세요.",
			"max" : 10
		});
		v.add("mobile2", {
			"empty" : "휴대폰번호를 입력해 주세요.",
			"format" : "numeric",
			"max" : 4
		});
		v.add("mobile3", {
			"empty" : "휴대폰번호를 입력해 주세요.",
			"format" : "numeric",
			"max" : 4
		});
		v.add("email1", {
			"empty" : "이메일을 입력해 주세요.",
			"max" : 100
		});
		v.add("email2", {
			"empty" : "이메일을 입력해 주세요.",
			"max" : 100
		});

<%
	if(!"".equals(param.get("reserve_date"))) {
%>
		step1('<%= param.get("reserve_date") %>', '<%= param.get("exp_type") %>');
<%
	}

	if(!"".equals(param.get("reserve_date"))) {
%>
		step2('<%= param.get("exp_type") %>');
<%
	}
%>
	});	

	function setDate(obj, date) {
		$(".calenderArea ul .choice").removeClass("choice");
		$(obj).parent().addClass("choice");
		
		$("#reserve_date").val(date);
		$("#step2_list").empty();
		$("#step3_list").empty();

		step1(date);
	}
	
	function step1(date, exp_type) {
		$("#exp_type").empty().html("<option value=\"\">체험 프로그램 선택하세요.</option>");

		$.ajax({
			method : "POST",
			url : "/brand/play/reservation/expList1.jsp",
			data : { date : date, exp_type : exp_type },
			dataType : "html"
		})
		.done(function(html) {
			$("#exp_type").append($.trim(html));
		});
		
		cal();
	}
	
	function step2(v) {
		if(v == '007') {	// 공장견학
			alert("월-토 9:30, 16:00 / 일요일 모든 견학은\n견학 시작 10분전까지 자차를 이용하여\n매일유업 상하공장 주차장으로 개별 이동 후 견학이 가능합니다.\n\n- 매표소 발권 후 이용이 가능합니다.\n- 공장 생산이 없는 경우(토,일,공휴일) 영상으로 대체될 수 있습니다.");
		}

		$("#step2_list").empty();
		$("#step3_list").empty();

		$.ajax({
			method : "POST",
			url : "/brand/play/reservation/expList2.jsp",
			data : { date : $("#reserve_date").val(), exp_type : v },
			dataType : "html"
		})
		.done(function(html) {
			$("#step2_list").empty().html($.trim(html));
		});

		cal();
	}
	
	function step3(v) {
		$("#step3_list").empty();

		$.ajax({
			method : "POST",
			url : "/brand/play/reservation/expList3.jsp",
			data : { exp_pid : v },
			dataType : "html"
		})
		.done(function(html) {
			$("#step3_list").empty().html($.trim(html));
		});

		cal();
	}

	function setQty(dir, no) {
		if(dir == 'up') {
			$("#qty_" + no).val(parseInt($("#qty_" + no).val()) + 1);
		} else {
			if($("#qty_" + no).val() != 0) {
				$("#qty_" + no).val(parseInt($("#qty_" + no).val()) - 1);
			}
		}
		
		cal();
	}

	function cal() {
		resetCoupon();
		resetPoint();
		totPrice = 0;
		reservedNum = 0;
		
		$("input[name=ticket_type]").each(function() {
			var tType = $(this).val();
			var price = parseInt($("#price_" + tType).val()) * parseInt($("#qty_" + tType).val());
			var rNum = parseInt($("#occu_num_" + tType).val()) * parseInt($("#qty_" + tType).val());
			$("#price_" + tType + "_txt").html(price.formatMoney());
			totPrice += price;
			reservedNum += rNum;
		});
		
		
		$("#tot_price_txt").html(totPrice.formatMoney());
		$("#tot_price2_txt").html(totPrice.formatMoney());
		$("#pay_amt_txt").html(totPrice.formatMoney());
		
		$("#pay_amt").val(totPrice);
	}

	function resetCoupon() {
		couponAmt = 0;
		$("#coupon").val("");
		$("#mem_couponid").val("");
		$("#coupon_amt_txt").html("-0");
		$("#pay_amt_txt").html((totPrice - couponAmt).formatMoney());
	}
	
	function resetPoint() {
		pointAmt = 0;
		$("#point_all").prop("checked", false);
		$("#point_amt").val("0");
		$("#point_amt_txt").html("-0");
		$("#pay_amt_txt").html((totPrice - couponAmt).formatMoney());
	}
	
	function applyCoupon() {
		resetPoint();
		
		if($("#coupon").val() == '') {
			resetCoupon();
			$("#pay_amt_txt").html(totPrice.formatMoney());
			$("#pay_amt").val(totPrice);
		} else {
			//mem_couponid|sale_type|sale_amt|max_sale|min_price|coupon_name
			var arr = $("#coupon").val().split("|");
			
			// 최소금액 미달시
			if(totPrice < parseInt(arr[4])) {
				alert("최소 " + arr[4].formatMoney() + "원 이상시 사용가능합니다.");
				resetCoupon();
				$("#pay_amt_txt").html(totPrice.formatMoney());
				$("#pay_amt").val(totPrice);
			} else {
				if(arr[1] == 'A') {	// 정액
					couponAmt = parseInt(arr[2]) >= parseInt(arr[3]) ? parseInt(arr[3]) : parseInt(arr[2]);
				} else {	// 정률
					couponAmt = (parseInt(arr[2]) * totPrice / 100 >= parseInt(arr[3])) ? parseInt(arr[3]) : parseInt(arr[2]) * totPrice / 100;
				}
				
				$("#mem_couponid").val(arr[0]);
				$("#coupon_amt_txt").html("-" + couponAmt.formatMoney());
				$("#pay_amt_txt").html((totPrice - couponAmt).formatMoney());
			}
		} 
	}
	
	function applyPoint() {
		pointAmt = parseInt($("#point_amt").val().replace(/,/g, ""));

		if($("#point_amt").val() != "") {
			$("#point_amt").val(pointAmt.formatMoney());
		}
		
		var payAmt = totPrice - couponAmt - pointAmt;
		if(payAmt >= 0) {
			$("#point_amt_txt").html("-" + pointAmt.formatMoney());
			$("#pay_amt_txt").html(payAmt.formatMoney());
		} else {
			resetPoint();
		}
	}
	
	function setAgreeAll() {
		$("#agree1").prop("checked", $("#agreeAll").prop("checked"));
		$("#agree2").prop("checked", $("#agreeAll").prop("checked"));
		$("#agree3").prop("checked", $("#agreeAll").prop("checked"));
	}
	
	function pointAll() {
		if($("#point_all").prop("checked")) {
			var useablePoint = <%= point %>;
			if(totPrice - couponAmt > useablePoint) {
				var appAmt = parseInt(useablePoint / 10) * 10;
			} else {
				var appAmt = parseInt((totPrice - couponAmt) / 10) * 10;
			}
			
			$("#point_amt").val(appAmt);
			applyPoint();
		} else {
			resetPoint();
		}
	}

	function orderProc() {
		if(v.validate()) {
			if($("#reserve_date").val() == "") {
				alert("예약일자를 선택하세요.");
				return;
			}
			
			/*
			if(totPrice == 0) {
				alert("입장권을 선택하세요.");
				return;
			}
			*/
			
			if($("input[name='exp_pid']:checked").length == 0) {
				alert("입장권을 선택하세요.");
				return;
			}

			// 예약 인원 체크
			if(reservedNum <= 0) {
				alert("예약 인원을 선택하세요.");
				return;
			}
			var remain = parseInt($("#remain_" + $("input[name=exp_pid]:checked").val()).val());
			if(reservedNum > remain) {
				alert("예약 가능 인원을 초과했습니다.");
				return;
			}
			
			// 포인트 체크
			var point = parseInt($("#point_amt").val().replace(/,/g, ""));
			if(point % 10 != 0) {
				alert("Maeil Do 포인트는 10P 단위로 사용 가능합니다.");
				return;
			}
			if(!$("#agree1").prop("checked")) {
				alert("취소/환불 규정에 대한 동의는 필수입니다.");
				return;
			}
			if(!$("#agree2").prop("checked")) {
				alert("결제대행서비스 이용동의는 필수입니다.");
				return;
			}
			
			if(!$("#agree3").prop("checked")) {
				alert("주문내역 동의는 필수입니다.");
				return;
			}

			payAmt = totPrice - couponAmt - pointAmt;
			$("#LGD_BUYER").val($("#name").val());
			$("#LGD_BUYEREMAIL").val($("#email1").val() + "@" + $("#email2").val());
			$("#LGD_BUYERPHONE").val($("#mobile1").val() + $("#mobile2").val() + $("#mobile3").val());
			$("#orderForm input[name=BuyerName]").val($("#name").val());
			$("#orderForm input[name=BuyerEmail]").val($("#email1").val() + "@" + $("#email2").val());
			$("#orderForm input[name=LGD_AMOUNT]").val(payAmt);
			$("#orderForm input[name=Amt]").val(payAmt);
			$("#paycoReserveForm input[name=totalPaymentAmt]").val(payAmt);

			$("#orderForm").attr("action", "<%= Env.getSSLPath() %>/brand/play/reservation/orderProc.jsp");

<%
	if(SystemChecker.isLocal()) {
%>
			$("#orderForm").submit();
			return;
<%
	}
%>

			if(payAmt == 0) {	// 0원 결제
				$("#orderForm").submit();
			} else if($("input[name=pay_type]:checked").val() == "005") {	// 카카오페이
				$("#hashKakaoForm input[name=amt]").val(payAmt);
				ajaxSubmit("#hashKakaoForm", function(json) {
					if(json.result) {
						$("#orderForm input[name=EncryptData]").val(json.hash);
						getTxnId();
					} else {
						alert("결제 진행중 오류가 발생했습니다.");
					}
				});
			} else if($("input[name=pay_type]:checked").val() == "006") {	// Payco
				callPaycoUrl();
			} else {
				if($("input[name=pay_type]:checked").val() == "001") {
					$("#LGD_CUSTOM_USABLEPAY").val("SC0010");
					$("#LGD_EASYPAY_ONLY").val("");
				} else if($("input[name=pay_type]:checked").val() == "002") {
					$("#LGD_CUSTOM_USABLEPAY").val("SC0030");
					$("#LGD_EASYPAY_ONLY").val("");
				} else if($("input[name=pay_type]:checked").val() == "003") {
					$("#LGD_CUSTOM_USABLEPAY").val("SC0040");
					$("#LGD_EASYPAY_ONLY").val("");
				} else if($("input[name=pay_type]:checked").val() == "004") {
					$("#LGD_CUSTOM_USABLEPAY").val("SC0010-SC0030");
					$("#LGD_EASYPAY_ONLY").val("PAYNOW");
				} 
				
				$("#hashForm input[name=LGD_AMOUNT]").val(payAmt);
				ajaxSubmit("#hashForm", function(json) {
					if(json.result) {
						$("#orderForm input[name=LGD_HASHDATA]").val(json.hash);
// 						launchCrossPlatform();
						$("#orderForm").attr("action", "<%= Env.getSSLPath() %>/mobile/order/orderSession.jsp");
						$("#orderForm").submit();
					} else {
						alert("결제 진행중 오류가 발생했습니다.");
					}
				});
			}			
		}
	}
</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<jsp:include page="/mobile/brand/play/reservation/subNav.jsp" />
		<p class="reserSrmy">상하농원 먹거리 체험 프로그램을 사전에 예약하고, 이용할 수 있습니다.</p>
		<h2 class="typeA"><strong class="num">01</strong> 날짜 선택</h2>
		<div class="calenderArea"><div class="slideCont">
			<ul class="swiper-wrapper">
<%
	Calendar today = Calendar.getInstance();
	Calendar cal = Calendar.getInstance();
	
	for(int j = 0; j < 3; j++) {
		cal.set(Calendar.DATE, 1);
%>
				<li class="sec swiper-slide">
					<h3><%= (new SimpleDateFormat("MMMMMMMMM", java.util.Locale.US)).format(cal.getTime()) %><br><strong><%= (new SimpleDateFormat("MM", java.util.Locale.US)).format(cal.getTime()) %></strong></h3>
					<div class="calender">
						<ol class="week">
							<li>일</li>
							<li>월</li>
							<li>화</li>
							<li>수</li>
							<li>목</li>
							<li>금</li>
							<li>토</li>
						</ol>
						<ol class="day">
<%
		for(int i = 1; i < cal.get(Calendar.DAY_OF_WEEK); i++) { 
%>
							<li><span></span></li>
<%
	}

		while(true) {
			if(cal.compareTo(today) < 0) {
%>
								<li class="disable"><a href="javascript:void(0)"><%= cal.get(Calendar.DATE) %></a></li>
<%
			} else {
				String cstr = Utils.getTimeStampString(cal.getTime(), "yyyy.MM.dd");
%>
								<li class="<%= cal.compareTo(today) == 0 ? "today" : "" %> <%= param.get("reserve_date").equals(cstr) ? "choice" : "" %>"><a href="#none" onclick="setDate(this, '<%= Utils.getTimeStampString(cal.getTime(), "yyyy.MM.dd") %>'); return false;"><%= cal.get(Calendar.DATE) %></a></li>
<%		
			}
			if(cal.get(Calendar.DATE) == cal.getActualMaximum(Calendar.DATE)) break;
			cal.add(Calendar.DATE, 1);
		}
%>
						</ol>
					</div><!-- //calender -->
				</li><!-- //sec -->
<%
		cal.add(Calendar.MONTH, 1);
	}
%>
			</ul>
			<input type="image" src="/mobile/images/btn/btn_prev2.png" alt="이전달" class="prev">
			<input type="image" src="/mobile/images/btn/btn_next2.png" alt="다음달" class="next">
			<div class="calenderPoint">
				<p class="datePoint today">오늘 날짜</p>
				<p class="datePoint choice">선택일</p>
				<p class="datePoint disable">예약 불가능</p>
			</div>
		</div></div><!-- //calenderArea -->
		
		<form name="orderForm" id="orderForm" method="post" action="<%= Env.getSSLPath() %>/brand/play/reservation/orderProc.jsp">
			<input type="hidden" name="orderid" value="<%= orderid %>" />
			<input type="hidden" name="reserve_date" id="reserve_date" value="<%= param.get("reserve_date") %>" />
			<input type="hidden" name="ticket_div" value="02" />
		<div class="reserForm">
			<h2 class="typeA"><strong class="num">02</strong> 예약자 정보</h2>
			<table class="bbsForm">
				<caption>예약자 정보입력 폼</caption>
				<colgroup>
					<col width="70"><col width="">
				</colgroup>
				<tr>
					<th scope="row">성명</th>
					<td><input type="text" name="name" id="name" value="<%= fs.getUserNm() %>" title="성명" style="width:100%"></td>
				</tr>
				<tr>
					<th scope="row">휴대전화</th>
					<td>
						<select name="mobile1" id="mobile1" title="휴대전화 첫자리" style="width:60px">
<%
	for(String mobile : SanghafarmUtils.MOBILES) {
%>
							<option value="<%= mobile %>" <%= mobile.equals(fs.getMobile1()) ? "selected" : "" %>><%= mobile %></option>
<%
	}
%>
						</select>&nbsp;-
						<input type="text" name="mobile2" id="mobile2" value="<%= fs.getMobile2() %>" title="휴대전화 가운데자리" style="width:60px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">&nbsp;-
						<input type="text" name="mobile3" id="mobile3" value="<%= fs.getMobile3() %>" title="휴대전화 뒷자리" style="width:60px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">
					</td>
				</tr>
				<tr>
					<th scope="row">이메일</th>
					<td>
						<input type="text" name="email1" id="email1" value="<%= fs.getEmail1() %>" title="이메일 앞자리" style="width:100px">&nbsp;@
						<input type="text" name="email2" id="email2" value="<%= fs.getEmail2() %>" title="이메일 뒷자리" style="width:100px"><br>
						<select name="email3" id="email3" onchange="changeEmail3('1', this.value)" title="주문자 이메일 뒷자리 선택" style="width:100px;margin-top:5px">
							<option value="">직접입력</option>
<%
	for(String domain : SanghafarmUtils.EMAILS) {
%>									
							<option value="<%= domain %>"><%= domain %></option>
<%
	}
%>
						</select>
					</td>
				</tr>
			</table>
			<!-- //step2 예약자정보 -->
				
			<div class="reserHead">
				<h2 class="typeA"><strong class="num">03</strong> 체험프로그램 선택</h2>
				<a href="admission.jsp" class="btnTypeA sizeS icoGo">입장권 구매</a>
			</div>
			<div class="program">
				<select name="exp_type" id="exp_type" title="체험 프로그램 선택" onchange="step2(this.value)">
					<option value="">체험 프로그램 선택하세요.</option>
				</select>
				<ul id="step2_list">
				</ul>
				<ul class="ar" id="step3_list">
				</ul>
			</div>
			<p class="total">소계 <strong><span id="tot_price_txt">0</span>원</strong></p>				
			<ul class="caution">
				<li>체험은 예약제로 운영되며, 예약현황에 따라 조기 마감 또는 변경될 수 있습니다.</li>
				<li>일부 체험 수량에 한해 선착순 현장 구매가 가능합니다.</li>
				<li>체험에는 대인/소인 구분이 없습니다.</li>
				<li>체험은 기본 2인 1세트입니다.</li>
				<li>체험권에는 입장권이 포함되지 않습니다.</li>
				<li>체험권 구매인원에 한해 패키지 입장(3,000원/1인) 가격이 적용됩니다.</li>
				<li>기타 우대 및 할인 혜택은 현장 체험분에 한해 적용이 가능합니다.</li>
			</ul>
			<!-- //step3 체험프로그램 선택 -->				
			
			<div class="agreeHead">
				<h2 class="typeA">이용 동의</h2>
				<p class="allChk"><input type="checkbox" name="agreeAll" id="agreeAll" onclick="setAgreeAll()"><label for="agreeAll">전체 동의하기</label>
			</div>
			<div class="agreeChk">
		 		<div class="section">
		 			<h3><a href="#agreeCont1" onclick="showTab2(this, 'cont'); return false" class="icoMore typeB on">취소/환불 규정에 대한 동의</a> <input type="checkbox" name="agree1" id="agree1"></h3>
		 			<div class="cont" id="agreeCont1"><div class="scr">
						<jsp:include page="/order/agree3.jsp" />
		 			</div></div>
		 		</div>
		 		<div class="section">
		 			<h3><a href="#agreeCont2" onclick="showTab2(this, 'cont'); return false" class="icoMore typeB">결제대행서비스 표준이용약관</a> <input type="checkbox" name="agree2" id="agree2"></h3>
		 			<div class="cont" id="agreeCont2" style="display:none"><div class="scr">
						<jsp:include page="/order/agree.jsp" />
		 			</div></div>
		 		</div>
		 		<div class="section">
		 			<h3><a href="#agreeCont3" onclick="showTab2(this, 'cont'); return false" class="icoMore typeB">주문내역 동의</a> <input type="checkbox" name="agree3" id="agree3"></h3>
		 			<div class="cont" id="agreeCont3" style="display:none"><div class="scr">
						주문할 입장/체험 상품의 상품명, 사용일자 및 시간, 상품가격을 확인했습니다.<br>(전자상거래법 제 8조 2항) 구매에 동의하시겠습니까?<br><br>
						<ul>
							<li>체험 시작 이후에는 입장이 제한됩니다. (최소 20분전 도착)</li>
							<li>체험 상품에 따라 별도 포장 시간이 소요될 수 있습니다.</li>
							<li>개인 일정에 따른 손해에 대해서는 상하농원에서 책임지지 않습니다.</li>
						</ul>
		 			</div></div>
		 		</div>
		 	</div>
		 	<!--//이용동의 -->
		 	
			<h2 class="typeA"><strong class="num">04</strong> 총 결제 금액</h2>
			<div class="totalPrice">
				<dl>
					<dt>총 주문 금액</dt><dd><span id="tot_price2_txt">0</span>원</dd>
					<dt>쿠폰할인</dt>
					<dd>	
						<p class="field">
							<input type="hidden" name="mem_couponid" id="mem_couponid" value="" />			
							<select name="coupon" id="coupon" title="쿠폰선택" onchange="applyCoupon()">
<%
	Param p = new Param();
	p.set("userid", fs.getUserId());
	p.set("device_type", fs.getDeviceType());
	p.set("grade_code", fs.getGradeCode());
	p.set("coupon_type", "004");
	List<Param> couponList = coupon.getApplyableList2(p);
	if(couponList == null || couponList.size() == 0) {
%>
								<option value="">적용 가능한 쿠폰이 없습니다.</option>
<%
	} else {
%>
								<option value="">쿠폰 선택</option>
<%
		for(Param r : couponList) {
%>
								<option value="<%= r.get("mem_couponid") %>|<%= r.get("sale_type") %>|<%= r.get("sale_amt") %>|<%= r.get("max_sale") %>|<%= r.get("min_price") %>|<%= r.get("coupon_name") %>"><%= r.get("coupon_name") %></option>
<%
		}
	}
%>
							</select>
						</p>
						<p class="price"><span class="fontTypeE" id="coupon_amt_txt">-0</span>원</p>
					</dd>
					<dt>Maeil Do 포인트</dt>
					<dd>
						<p class="field"><input type="text" name="point_amt" id="point_amt" value="0" title="포인트" style="ime-mode:disabled" onkeydown="return onlyNumber(event);" onkeyup="removeChar(event); applyPoint();" <%= point < 1000 ? "disabled" : "" %>>&nbsp;P</p>
						<p class="price"><span class="fontTypeE" id="point_amt_txt">-0</span>P</p><br>
						<p class="all"><input type="checkbox" name="point_all" id="point_all" onclick="pointAll()" <%= point < 1000 ? "disabled" : "" %>><label for="point_all">모두사용</label> (보유 포인트 : <strong class="fontTypeE"><%= Utils.formatMoney(point) %></strong> P)</p>
					</dd>
				</dl>
				<ul class="caution">
					<li>1,000P 이상 가지고 계실 때, 10P 단위로 사용가능합니다.</li>
					<li>쿠폰은 기본적으로 중복 적용이 불가 합니다.</li>
					<li>일부 체험의 경우 할인 쿠폰이 적용되지 않을 수 있습니다.</li>
				</ul>
				<div class="payType">
					<h3>결제수단 선택</h3>
				 	<p class="discountInfo"><!-- <a href="">신용카드 별 결제 할인 안내</a> --></p>
				 	<div class="payWay typeB">
<%
	List<Param> payList = code.getList2("007");
	for(Param row : payList) {
		if("003".equals(row.get("code2"))) continue;
%>
				 		<p class="pay<%= row.get("code2") %>"><input type="radio" name="pay_type" id="pay_<%= row.get("code2") %>" value="<%= row.get("code2") %>" <%= payType.equals(row.get("code2")) ? "checked" : "" %>>
				 		<label for="pay_<%= row.get("code2") %>"><%= row.get("name2") %></label></p>
<%
	}
%>
				 	</div>
		 			<p class="paySave"><input type="checkbox" name="save_pay_type" id="save" value="Y" checked><label for="save">마지막 결제수단 저장하기</label></p>
			 	</div>
				<p class="lastPrice"><span>최종 결제액</span> <em><strong class="fontTypeA" id="pay_amt_txt">0</strong>원</em></p>
			</div>
			<!-- //step4 총결제금액 -->
		</div><!-- //reserForm -->
			 	
	 	<div class="btnArea ac">
	 		<a href="javascript:orderProc()" class="btnTypeA sizeL">결제하기</a>
	 	</div>
<%
	/*
	 *************************************************
	 * 2. MD5 해쉬암호화 (수정하지 마세요) - BEGIN
	 *
	 * MD5 해쉬암호화는 거래 위변조를 막기위한 방법입니다.
	 *************************************************
	 *
	 * 해쉬 암호화 적용( LGD_MID + LGD_OID + LGD_AMOUNT + LGD_TIMESTAMP + LGD_MERTKEY )
	 * LGD_MID          : 상점아이디
	 * LGD_OID          : 주문번호
	 * LGD_AMOUNT       : 금액
	 * LGD_TIMESTAMP    : 타임스탬프
	 * LGD_MERTKEY      : 상점MertKey (mertkey는 상점관리자 -> 계약정보 -> 상점정보관리에서 확인하실수 있습니다)
	 *
	 * MD5 해쉬데이터 암호화 검증을 위해
	 * LG유플러스에서 발급한 상점키(MertKey)를 환경설정 파일(lgdacom/conf/mall.conf)에 반드시 입력하여 주시기 바랍니다.
	 */
	String LGD_HASHDATA = "";
	String LGD_CUSTOM_PROCESSTYPE = "TWOTR";
	/*
	 *************************************************
	 * 2. MD5 해쉬암호화 (수정하지 마세요) - END
	 *************************************************
	 */
		 
	Map<String, Object> payReqMap = new HashMap<String, Object>();
	payReqMap.put("CST_PLATFORM"                , CST_PLATFORM);                   	// 테스트, 서비스 구분
	payReqMap.put("CST_MID"                     , CST_MID );                        	// 상점아이디
	payReqMap.put("LGD_WINDOW_TYPE"             , LGD_WINDOW_TYPE );                        	// 상점아이디
	payReqMap.put("LGD_MID"                     , LGD_MID );                        	// 상점아이디
	payReqMap.put("LGD_OID"                     , LGD_OID );                        	// 주문번호
	payReqMap.put("LGD_BUYER"                   , LGD_BUYER );                      	// 구매자
	payReqMap.put("LGD_PRODUCTINFO"             , LGD_PRODUCTINFO );                	// 상품정보
	payReqMap.put("LGD_AMOUNT"                  , LGD_AMOUNT );                     	// 결제금액
	payReqMap.put("LGD_BUYEREMAIL"              , LGD_BUYEREMAIL );                 	// 구매자 이메일
	payReqMap.put("LGD_CUSTOM_SKIN"             , LGD_CUSTOM_SKIN );                	// 결제창 SKIN
	payReqMap.put("LGD_CUSTOM_PROCESSTYPE"      , LGD_CUSTOM_PROCESSTYPE );         	// 트랜잭션 처리방식
	payReqMap.put("LGD_TIMESTAMP"               , LGD_TIMESTAMP );                  	// 타임스탬프
	payReqMap.put("LGD_HASHDATA"                , LGD_HASHDATA );      	           	// MD5 해쉬암호값
	payReqMap.put("LGD_RETURNURL"   			, LGD_RETURNURL );      			   	// 응답수신페이지
	payReqMap.put("LGD_VERSION"         		, "JSP_SmartXPay_1.0");			   	   	// 버전정보 (삭제하지 마세요)
	payReqMap.put("LGD_CUSTOM_USABLEPAY"  		, LGD_CUSTOM_USABLEPAY );				// 디폴트 결제수단 (해당 필드를 보내지 않으면 결제수단 선택 UI 가 보이게 됩니다.)
	payReqMap.put("LGD_CUSTOM_SWITCHINGTYPE"  	, LGD_CUSTOM_SWITCHINGTYPE );			// 신용카드 카드사 인증 페이지 연동 방식
	payReqMap.put("LGD_WINDOW_VER"  			, LGD_WINDOW_VER );						// 결제창 버젼정보 
	payReqMap.put("LGD_TAXFREEAMOUNT"  			, LGD_TAXFREEAMOUNT );						// 결제창 버젼정보 
	payReqMap.put("LGD_ENCODING"  				, "UTF-8" ); 
	payReqMap.put("LGD_ENCODING_NOTEURL"		, "UTF-8" ); 
	payReqMap.put("LGD_ENCODING_RETURNURL"		, "UTF-8" ); 
	payReqMap.put("LGD_EASYPAY_ONLY"			, "" ); 
	
    payReqMap.put("LGD_CUSTOM_ROLLBACK"         , "");		   	   				   // 비동기 ISP에서 트랜잭션 처리여부
    payReqMap.put("LGD_KVPMISPNOTEURL"  		, LGD_KVPMISPNOTEURL );		   // 비동기 ISP(ex. 안드로이드) 승인결과를 받는 URL
    payReqMap.put("LGD_KVPMISPWAPURL"  		 	, LGD_KVPMISPWAPURL );			   // 비동기 ISP(ex. 안드로이드) 승인완료후 사용자에게 보여지는 승인완료 URL
    payReqMap.put("LGD_KVPMISPCANCELURL"  		, LGD_KVPMISPCANCELURL );		   // ISP 앱에서 취소시 사용자에게 보여지는 취소 URL
    payReqMap.put("LGD_MTRANSFERAUTOAPPYN"		, LGD_MTRANSFERAUTOAPPYN);
    payReqMap.put("LGD_KVPMISPAUTOAPPYN"		, LGD_KVPMISPAUTOAPPYN);
    payReqMap.put("LGD_MONEPAYAPPYN"			, LGD_MONEPAYAPPYN);
    payReqMap.put("LGD_MTRANSFERNOTEURL"		, LGD_MTRANSFERNOTEURL);
    payReqMap.put("LGD_MTRANSFERWAPURL"			, LGD_MTRANSFERWAPURL);
    payReqMap.put("LGD_MTRANSFERCANCELURL"		, LGD_MTRANSFERCANCELURL);
   	payReqMap.put("LGD_MONEPAY_RETURNURL"		, LGD_MONEPAY_RETURNURL);

   	/*Return URL에서 인증 결과 수신 시 셋팅될 파라미터 입니다.*/
	payReqMap.put("LGD_RESPCODE"  		 , "" );
	payReqMap.put("LGD_RESPMSG"  		 , "" );
	payReqMap.put("LGD_PAYKEY"  		 , "" );
	
	session.setAttribute("PAYREQ_MAP", payReqMap);

	for(Iterator i = payReqMap.keySet().iterator(); i.hasNext();){
		Object key = i.next();
		out.println("<input type='hidden' name='" + key + "' id='"+key+"' value='" + payReqMap.get(key) + "'>" );
	}
%>
			<input type="hidden" name="LGD_BUYERPHONE"              id="LGD_BUYERPHONE"               value="">
<%
	/*
	 *************************************************
	 * 카카오 페이 - 시작
	 *************************************************
	 */
	////////위변조 처리/////////
	//전문생성일시
	String EdiDate = KakaopayUtil.getyyyyMMddHHmmss();
	
	//결제요청용 키값
	String hash_String  = "";
	/*
	 *************************************************
	 * 카카오 페이 - 끝
	 *************************************************
	 */
%>
			<!-- KAKAOPAY Field Start -->
			<!-- input -->
			<input type="hidden" name="PayMethod"				value="KAKAOPAY">
			<input type="hidden" name="GoodsName"				value="<%=LGD_PRODUCTINFO %>">
			<input type="hidden" name="Amt"						value="<%=LGD_AMOUNT %>">
			<input type="hidden" name="SupplyAmt"				value="0">
			<input type="hidden" name="GoodsVat"				value="0">
			<input type="hidden" name="ServiceAmt"				value="0">
			<input type="hidden" name="GoodsCnt"				value="1">
			<input type="hidden" name="MID"						value="<%=MID %>">
			<input type="hidden" name="AuthFlg"					value="10">
			<input type="hidden" name="EdiDate"					value="<%=EdiDate%>">
			<input type="hidden" name="EncryptData"				value="<%=hash_String%>">
			<input type="hidden" name="BuyerEmail"				value="<%=LGD_BUYEREMAIL%>">
			<input type="hidden" name="BuyerName"				value="<%=LGD_BUYER%>">
			<input type="hidden" name="certifiedFlag"			value="CN">
			<input type="hidden" name="currency"				value="KRW">
			<input type="hidden" name="merchantEncKey"			value="<%=merchantEncKey %>">
			<input type="hidden" name="merchantHashKey"			value="<%=merchantHashKey %>">
			<input type="hidden" name="requestDealApproveUrl"	value="<%=webPath + "/" + msgName%>">
			<input type="hidden" name="prType"					value="WPM">
			<input type="hidden" name="channelType"				value="4">
			<input type="hidden" name="merchantTxnNum"			value="<%=System.nanoTime() %>">
			<input type="hidden" name="Moid"					value="<%= orderid %>">
			<input type="hidden" name="possiCard"				value="">
			<input type="hidden" name="fixedInt"				value="">
			<input type="hidden" name="maxInt"					value="">
			<input type="hidden" name="noIntYN"					value="Y">
			<input type="hidden" name="noIntOpt"				value="">
			<input type="hidden" name="pointUseYn"				value="N">
			<input type="hidden" name="blockCard"				value="">
			<input type="hidden" name="blockBin"				value="">
			<input type="hidden" name="OrderCheckYn"			value="">
			<input type="hidden" name="OrderBirthDay"			value="">
			<input type="hidden" name="OrderName"				value="">
			<input type="hidden" name="OrderTel"				value="">
			<!-- output -->
			<input type="hidden" name="resultCode"		id="resultCode"		value="">
			<input type="hidden" name="resultMsg"		id="resultMsg"		value="">
			<input type="hidden" name="txnId"			id="txnId"			value="">
			<input type="hidden" name="prDt"			id="prDt"			value="">
			<input type="hidden" name="SPU"				value="">
			<input type="hidden" name="SPU_SIGN_TOKEN"	value="">
			<input type="hidden" name="MPAY_PUB"		value="">
			<input type="hidden" name="NON_REP_TOKEN"	value="">
			<!-- KAKAOPAY Field End -->					
			
			<!-- payco field -->
			<input type="hidden" name="reserveOrderNo" id="reserveOrderNo"	value="">
			<input type="hidden" name="sellerOrderReferenceKey" id="sellerOrderReferenceKey"	value="">
			<input type="hidden" name="paymentCertifyToken" id="paymentCertifyToken"	value="">
			<input type="hidden" name="paycoOrderUrl" id="paycoOrderUrl"	value="">
			
			<!-- etc -->
			<input type="hidden" name="device_type" value="<%= fs.getDeviceType() %>" />
		</form>
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
<form name="hashForm" id="hashForm" method="POST" action="/order/xpay/hash.jsp">
	<input type="hidden" name="LGD_OID" value="<%=LGD_OID%>">
	<input type="hidden" name="LGD_AMOUNT" value="<%=LGD_AMOUNT%>">
	<input type="hidden" name="LGD_TIMESTAMP" value="<%=LGD_TIMESTAMP%>">
</form>
<form name="hashKakaoForm" id="hashKakaoForm" method="POST" action="/order/kakaopay/hashKakao.jsp">
	<input type="hidden" name="amt" value="<%=LGD_AMOUNT%>">
	<input type="hidden" name="edi_date" value="<%=EdiDate%>">
</form>
<form name="paycoReserveForm" id="paycoReserveForm" method="post" action="/order/payco/payco_reserve.jsp">
	<input type="hidden" name="sellerOrderReferenceKey" value="<%= orderid %>" />
	<input type="hidden" name="totalPaymentAmt" value="<%= LGD_AMOUNT %>" />
	<input type="hidden" name="totalTaxfreeAmt" value="<%= LGD_TAXFREEAMOUNT %>" />
	<input type="hidden" name="productName" value="<%= LGD_PRODUCTINFO %>" />
	<input type="hidden" name="sellerOrderProductReferenceKey" value="ticket" />
	<input type="hidden" name="excludePaymentMethodCodes" value="02" />
	<input type="hidden" name="returnUrl" value="payco_return_mobile2.jsp?orderid=<%= orderid %>">
</form>
<!-- KAKAOPAY Hidden -->
<div id="kakaopay_layer"  style="display: none"></div>
<iframe name="txnIdGetterFrame" id="txnIdGetterFrame" src="" width="0" height="0"></iframe>
</body>
</html>
					