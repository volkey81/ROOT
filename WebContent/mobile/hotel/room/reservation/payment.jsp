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
			com.sanghafarm.service.order.*,				 
			com.sanghafarm.service.hotel.*,
			org.json.simple.*" %>
<%@ include file="/order/kakaopay/incKakaopayCommon.jsp" %>
<%@include file="/order/payco/common_include.jsp" %>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(2));
	request.setAttribute("Depth_3", new Integer(4));
	request.setAttribute("Depth_4", new Integer(4));
	request.setAttribute("MENU_TITLE", new String("객실"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
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
	String CST_MID              = Config.get("lgdacom.CST_MID2");                      //LG유플러스로 부터 발급받으신 상점아이디를 입력하세요.
	String LGD_MID              = ("test".equals(CST_PLATFORM.trim())?"t":"")+CST_MID;  //테스트 아이디는 't'를 제외하고 입력하세요.
	                                                                                    //상점아이디(자동생성)
	String LGD_OID              = ""							;                      //주문번호(상점정의 유니크한 주문번호를 입력하세요)
	String LGD_AMOUNT           = "";								                   //결제금액("," 를 제외한 결제금액을 입력하세요)
	String LGD_MERTKEY          = Config.get("lgdacom.LGD_MERTKEY2");   					//상점MertKey(mertkey는 상점관리자 -> 계약정보 -> 상점정보관리에서 확인하실수 있습니다)
	String LGD_BUYER            = "";                    //구매자명
	String LGD_PRODUCTINFO      = "";              //상품명
	String LGD_BUYEREMAIL       = "";               //구매자 이메일
	String LGD_TIMESTAMP        = Utils.getTimeStampString("yyyyMMddHHmmss");                //타임스탬프
	String LGD_CUSTOM_USABLEPAY = "SC0010";        	//상점정의 초기결제수단
	String LGD_CUSTOM_SKIN      = "SMART_XPAY2";                                                //상점정의 결제창 스킨(red, yellow, purple)
	String LGD_CUSTOM_SWITCHINGTYPE = "SUBMIT"; //신용카드 카드사 인증 페이지 연동 방식 (수정불가)
	String LGD_WINDOW_VER		= "2.5";												//결제창 버젼정보
	String LGD_WINDOW_TYPE      = "submit";               //결제창 호출 방식 (수정불가)
	
	String LGD_TAXFREEAMOUNT	= "";	// 면세금액
	
	Calendar cal = Calendar.getInstance();
	cal.add(Calendar.DATE, 1);
	String LGD_CLOSEDATE		= Utils.getTimeStampString(cal.getTime(), "yyyyMMddHHmmss");	// 무통장 입금 마감시간 (예: yyyyMMddHHmmss)
	
	/*
	 * 가상계좌(무통장) 결제 연동을 하시는 경우 아래 LGD_CASNOTEURL 을 설정하여 주시기 바랍니다.
	 */
	String LGD_CASNOTEURL		= "http://" + request.getServerName() + "/order/xpay/cas_noteurl.jsp";
		
	System.out.println("-------------- LGD_CASNOTEURL : " + LGD_CASNOTEURL);
	/*
	 * LGD_RETURNURL 을 설정하여 주시기 바랍니다. 반드시 현재 페이지와 동일한 프로트콜 및  호스트이어야 합니다. 아래 부분을 반드시 수정하십시요.
	 */
	String LGD_RETURNURL		= (SystemChecker.isReal() ? "https" : "http") + "://" + request.getServerName() + "/order/xpay/mreturnurl_hotel.jsp";// FOR MANUAL
// 	String LGD_RETURNURL		= Env.getSSLPath() + "/order/xpay/mreturnurl.jsp";// FOR MANUAL

	String userAgent2 = request.getHeader("User-Agent").toLowerCase();
	boolean isIOS = userAgent2.indexOf("iphone") > -1 || userAgent2.indexOf("ipad") > -1 || userAgent2.indexOf("ipod") > -1;

	/*
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
//         LGD_MONEPAY_RETURNURL = "sanghafarm://";
    }

    if("A".equals(fs.getDeviceType())) {
    	LGD_MTRANSFERAUTOAPPYN = "A";
    	LGD_KVPMISPAUTOAPPYN = "A";
    	LGD_MONEPAYAPPYN = "Y";
    }
    */
    
	String LGD_MTRANSFERAUTOAPPYN = "A";
	String LGD_KVPMISPAUTOAPPYN = "A";
	String LGD_MONEPAYAPPYN = "N";
	
    // ios에서 동기방식(WEB).
	if(isIOS){
    	LGD_MTRANSFERAUTOAPPYN = "N";
    	LGD_KVPMISPAUTOAPPYN = "N";
    }
    //APP일때 동기방식.
    if(fs.isApp()){
    	LGD_MTRANSFERAUTOAPPYN = "A";
    	LGD_KVPMISPAUTOAPPYN = "A";
    	LGD_MONEPAYAPPYN = "Y";
    }
    
    // ios 동기 방식일때 필요. note_url은 사용안함.
    String LGD_MTRANSFERNOTEURL = "A";
    String LGD_MTRANSFERWAPURL = "";
    String LGD_MTRANSFERCANCELURL = "";
    
    String LGD_KVPMISPNOTEURL = "A";
    String LGD_KVPMISPWAPURL =  "";
    String LGD_KVPMISPCANCELURL = "";
    
    if(fs.isApp() && "ios".equals(fs.getAppOS())){
    	LGD_MTRANSFERWAPURL = "sanghafarm://";
    	LGD_MTRANSFERCANCELURL = "sanghafarm://";
    	
    	LGD_KVPMISPWAPURL =  "sanghafarm://";
    	LGD_KVPMISPCANCELURL = "sanghafarm://";
    }
    
    String LGD_MONEPAY_RETURNURL = "sanghafarm://";    

    //TODO KaKaoPay의 INBOUND 전문 URL SETTING
	String msgName = "merchant/requestDealApprove.dev";
	String webPath = "https://kmpay.lgcns.com:8443/"; //PG사의 인증 서버 주소

	
	RMSApiService api = new RMSApiService();
	HotelReserveService svc = (new HotelReserveService()).toProxyInstance();
	CodeService code = (new CodeService()).toProxyInstance();
	MemberService member = (new MemberService()).toProxyInstance();
	CouponService coupon = (new CouponService()).toProxyInstance();
	ImMemberService immem = (new ImMemberService()).toProxyInstance();

	JSONObject json = api.forecast(param);
	List<Param> list = api.getRoomList(param, json);
	
	if(list.size() == 0) {
		Utils.sendMessage(out, "선택하신 날짜의 숙박 가능한 객실이 없습니다.", "date.jsp");
		return;
	}
	
	int night = SanghafarmUtils.getDateDiff(param.get("chki_date"), param.get("chot_date"));
	int totAmt = 0;
	int totQty = 0;
	String listTxt = "";
	
	String orderid = svc.getNewId();
	LGD_OID = orderid;
	
	member.modifyOrderid(fs.getUserId(), orderid);
	Param memInfo = member.getInfo(fs.getUserId());
	String payType = memInfo.get("pay_type", "001");
	
	// 쿠폰
	Param p = new Param();
	p.set("userid", fs.getUserId());
	p.set("device_type", fs.getDeviceType());
	p.set("grade_code", fs.getGradeCode());
	p.set("coupon_type", "007");
	List<Param> couponList = coupon.getApplyableList2(p);

	// 포인트
	int point = immem.getMemberPoint(fs.getUserNo());

	LGD_RETURNURL += "?orderid=" + orderid;
	System.out.println("-------------- LGD_RETURNURL : " + LGD_RETURNURL);

	// JSONArray for Npay
	JSONArray jsonArr = new JSONArray();
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp"/> 
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
			document.getElementById("orderForm").action = "<%= Env.getSSLPath() %>/hotel/room/reservation/proc.jsp";
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
        document.orderForm.action = "<%= Env.getSSLPath() %>/hotel/room/reservation/proc.jsp";
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
	var totAmt = 0;
	var couponAmt = 0;
	var promocdAmt = 0;
	var giftcardAmt = 0;
	var pointAmt = 0;
	var payAmt = 0;
	
	$(function() {
		$("input[name=pay_type]").click(function() {
			if($(this).val() == '009') {
				$("#npay_notice").show();
			} else {
				$("#npay_notice").hide();
			}
		});
		
		if($("input[name=pay_type]:checked").val() == '009') {
			$("#npay_notice").show();
		}
	});
	
	function goPrev() {
		$("#orderForm").attr("action", "info.jsp");
		$("#orderForm").submit();
	}
	
	function applyCoupon() {
		resetCoupon();
		if($("#coupon").val() != '') {
			//mem_couponid|sale_type|sale_amt|max_sale|min_price|coupon_name
			var arr = $("#coupon").val().split("|");
			
			// 최소금액 미달시
			if(totAmt < parseInt(arr[4])) {
				alert("최소 " + arr[4].formatMoney() + "원 이상시 사용가능합니다.");
			 	$("#coupon").val("");
				resetCoupon();
			} else {
				if(arr[1] == 'A') {	// 정액
					couponAmt = parseInt(arr[2]);
				} else {	// 정률
					couponAmt = (parseInt(arr[2]) * totAmt / 100 >= parseInt(arr[3])) ? parseInt(arr[3]) : parseInt(arr[2]) * totAmt / 100;
				}
				
				if(couponAmt > payAmt) {
					couponAmt = payAmt;
				}
				
				$("#mem_couponid").val(arr[0]);
				$("#coupon_amt").val(couponAmt);
			}
		} 
		getPromocd(false);
	}
	
	function resetCoupon() {
		couponAmt = 0;
	// 	$("#coupon").val("");
		$("#mem_couponid").val("");
		$("#coupon_amt").val("");
		setAmt();
	}
	
	function getPromocd(b) {
		if(b && $("#promocd").val() == '') {
			alert("프로모션 코드를 입력하세요.");
		} else {
			var data = {
					promocd : $("#promocd").val(),
					chki_date : "<%= param.get("chki_date") %>",
					chot_date : "<%= param.get("chot_date") %>"
				};
			
			$.ajax({
				method : "POST",
				url : "/ajax/promocd.jsp",
				data : data,
				dataType : "json"
			})
			.done(function(json) {
				promocdAmt = 0;
				console.log(json);
				if(json.result == 'N') {
					if(b) alert(json.msg);
					resetPromocd();
				} else if(totAmt < parseInt(json.min_price)) {	// 최소금액 미달
					if(b) alert("최소 " + json.min_price.formatMoney() + "원 이상시 사용가능합니다.");
					resetPromocd();
				} else {
					if(json.sale_type == 'A') {
						promocdAmt = parseInt(json.sale_amt);
					} else {
						promocdAmt = (parseInt(json.sale_amt) * (totAmt - couponAmt) / 100 >= parseInt(json.max_sale)) ? parseInt(json.max_sale) : (parseInt(json.sale_amt) * (totAmt - couponAmt) / 100); 
					}
					
					if(promocdAmt > (totAmt - couponAmt)) {
						promocdAmt = totAmt - couponAmt;
					}
			
					$("#promocdid").val(json.promocdid);
					$("#promocd_amt").val(promocdAmt);
				}
				
				setAmt();
			});
		}
	}
	
	function resetPromocd() {
		promocdAmt = 0;
	// 	$("#promocd").val("");
		$("#promocdid").val("");
		$("#promocd_amt").val("");
		setAmt();
	}
	
	function applyGiftcard(cardid, amt, receipt, cardnum) {
		giftcardAmt = parseInt(amt.replace(/,/g, ""));
		console.log(amt + " : " + giftcardAmt);
		$("#giftcard_id").val(cardid);
		$("#giftcard_amt").val(giftcardAmt);
		$("#LGD_CASHRECEIPTUSE").val(receipt);
		$("#LGD_CASHCARDNUM").val(cardnum);
		setAmt();
	}
	
	function resetGift() {
		giftcardAmt = 0;
		$("#giftcard_id").val("");
		$("#giftcard_amt").val("");
		$("#LGD_CASHRECEIPTUSE").val("");
		$("#LGD_CASHCARDNUM").val("");
		setAmt();
	}
	
	function pointAll() {
		if($("#point_all").prop("checked")) {
			var useablePoint = <%= point %>;
			if(payAmt > useablePoint) {
				pointAmt = parseInt(useablePoint / 10) * 10;
// 				pointAmt = useablePoint;
			} else {
				pointAmt = parseInt(payAmt / 10) * 10;
// 				pointAmt = payAmt;
			}
			
			$("#point_amt").val(pointAmt.formatMoney());
		} else {
			pointAmt = 0;
			$("#point_amt").val("");
		}
		
		applyPoint();
	}
	
	function applyPoint() {
		pointAmt = parseInt($("#point_amt").val().replace(/,/g, ""));
	
		if($("#point_amt").val() == "") {
			pointAmt = 0;
		}
	
		if(pointAmt > <%= point %>) {
			alert("보유 포인트를 초과하였습니다.");
			resetPoint();
			return;
		} else if(pointAmt % 10 != 0) {
			alert("포인트는 10P 단위로 사용가능합니다.");
			resetPoint();
			return;
		}
		
		$("#point_amt").val(pointAmt > 0 ? pointAmt.formatMoney() : "");
		setAmt();
	}
	
	function resetPoint() {
		pointAmt = 0;
		$("#point_amt").val("");
		$("#point_all").prop("checked", false);
		setAmt();
	}
	
	function setAmt() {
		var discountAmt = couponAmt + promocdAmt + giftcardAmt + pointAmt;
		payAmt = totAmt - discountAmt;
		
		$("#coupon_amt_txt").html("(-" + couponAmt.formatMoney() + "원)");
		$("#promocd_amt_txt").html("(-" + promocdAmt.formatMoney() + "원)");
		$("#giftcard_amt_txt").html("(-" + giftcardAmt.formatMoney() + "원)");
		$("#point_amt_txt").html("(-" + pointAmt.formatMoney() + "원)");
		$("#discount_amt_txt").html("-" + discountAmt.formatMoney() + "원");
		$("#pay_amt_txt").html(payAmt.formatMoney() + "원");
	}
	
	function goNext() {
		if(payAmt < 0) {
			alert("결제금액이 0원 미만입니다.");
			return;
		}
		
		$("#LGD_BUYER").val($("#name").val());
		$("#LGD_BUYERPHONE").val($("#mobile1").val() + $("#mobile2").val() + $("#mobile3").val());
		$("#orderForm input[name=BuyerName]").val($("#name").val());
		$("#orderForm input[name=LGD_AMOUNT]").val(payAmt);
		$("#orderForm input[name=Amt]").val(payAmt);
		$("#paycoReserveForm input[name=totalPaymentAmt]").val(payAmt);
	
	<%
// 		boolean nopg = true;
		boolean nopg = false;
		if(nopg && SystemChecker.isLocal()) {
	%>
			$("#orderForm").submit();
			return;
	<%
		}
	%>
		if(payAmt == 0) {	// 0원 결제
			$("#orderForm").submit();
		} else if($("input[name=pay_type]:checked").val() == "009") {	// 네이버페이
			if(payAmt < 100) {
				alert("결제 최소금액은 100원입니다.");
			} else {
				$("#orderForm").attr("action", "<%= Env.getSSLPath() %>/mobile/order/orderSessionNaverPay.jsp");
				$("#orderForm").submit();
			}
		} else if($("input[name=pay_type]:checked").val() == "005") {	// 카카오페이
			if(payAmt != totAmt) {	// 쿠폰, 포인트로 인해 금액이 변동된 경우
				$("#hashKakaoForm input[name=amt]").val(payAmt);
				ajaxSubmit("#hashKakaoForm", function(json) {
					if(json.result) {
						$("#orderForm input[name=EncryptData]").val(json.hash);
						getTxnId();
					} else {
						alert("결제 진행중 오류가 발생했습니다.");
					}
				});
			} else {
				getTxnId();
			}
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
			
			$("#orderForm").attr("action", "<%= Env.getSSLPath() %>/mobile/order/orderSession.jsp");
	
			if(payAmt != totAmt) {	// 쿠폰, 포인트로 인해 금액이 변동된 경우
				$("#hashForm input[name=LGD_AMOUNT]").val(payAmt);
				ajaxSubmit("#hashForm", function(json) {
					if(json.result) {
						$("#orderForm input[name=LGD_HASHDATA]").val(json.hash);
						$("#orderForm").submit();
					} else {
						alert("결제 진행중 오류가 발생했습니다.");
						return;
					}
				});
			} else {
	// 			launchCrossPlatform();
				$("#orderForm").submit();
			}
		}			
	}
	
	function showGift() {
		showPopupLayer('/mobile/popup/giftCard.jsp?pay_amt=' + payAmt, '500');		
	}
	
</script>
</head>  
<body>
<div id="wrapper" class="hotelWrap">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container" class="room btnFix">
	<!-- 내용영역 -->
		<div class="reservation">
			<h2 class="animated fadeInUp delay02">예약하기</h2>
			<!-- reservationTop -->
			<jsp:include page="/mobile/hotel/room/reservation/reservationTop.jsp" />
			<!-- //reservationTop -->
		
			<div class="paymentArea">
				<form name="orderForm" id="orderForm" action="<%= Env.getSSLPath() %>/hotel/room/reservation/proc.jsp" method="post">
					<input type="hidden" name="orderid" value="<%= orderid %>">
					<input type="hidden" name="name" id="name" value="<%= param.get("name") %>">
					<input type="hidden" name="mobile1" id="mobile1" value="<%= param.get("mobile1") %>">
					<input type="hidden" name="mobile2" id="mobile2" value="<%= param.get("mobile2") %>">
					<input type="hidden" name="mobile3" id="mobile3" value="<%= param.get("mobile3") %>">
					<input type="hidden" name="chki_date" value="<%= param.get("chki_date") %>">
					<input type="hidden" name="chot_date" value="<%= param.get("chot_date") %>">
<%
	for(Param row : list) {
		String txt = "";
		int roomCnt = 0;
		int amt = fs.isStaff() ? row.getInt("room_amt_02") : row.getInt("room_amt_01");
		int basic = row.getInt("basic_prsn");
		int addAdult = 0;
		int addKids = 0;
		int addAmt = 0;
%>
					<input type="hidden" name="<%= row.get("room_knd_gbcd") %>_basic_prsn" id="<%= row.get("room_knd_gbcd") %>_basic_prsn" value="<%= row.get("basic_prsn") %>">
					<input type="hidden" name="<%= row.get("room_knd_gbcd") %>_room_knd_nm" id="<%= row.get("room_knd_gbcd") %>_room_knd_nm" value="<%= row.get("room_knd_nm") %>">
					<input type="hidden" name="<%= row.get("room_knd_gbcd") %>_max_prsn" id="<%= row.get("room_knd_gbcd") %>_max_prsn" value="<%= row.get("max_prsn") %>">
					<input type="hidden" name="<%= row.get("room_knd_gbcd") %>_chrg_grup_gbcd" id="<%= row.get("room_knd_gbcd") %>_chrg_grup_gbcd" value="<%= fs.isStaff() ? row.get("chrg_grup_gbcd_02") : row.get("chrg_grup_gbcd_01") %>">
					<input type="hidden" name="<%= row.get("room_knd_gbcd") %>_room_amt" id="<%= row.get("room_knd_gbcd") %>_room_amt" value="<%= fs.isStaff() ? row.get("room_amt_02") : row.get("room_amt_01") %>">
					<input type="hidden" name="<%= row.get("room_knd_gbcd") %>_qty" id="<%= row.get("room_knd_gbcd") %>_qty" value="<%= param.get(row.get("room_knd_gbcd") + "_qty") %>">
					<input type="hidden" name="<%= row.get("room_knd_gbcd") %>_note" id="<%= row.get("room_knd_gbcd") %>_note" value="<%= param.get(row.get("room_knd_gbcd") + "_note") %>">
<%
		for(int i = 1; i <= 4; i++) {
			int adult = param.getInt(row.get("room_knd_gbcd") + "_qty_" + i + "_adult");
			int kids = param.getInt(row.get("room_knd_gbcd") + "_qty_" + i + "_kids");
			int _addAdultAmt = RMSApiService.getAddAmt(param.get("chki_date"), row.get("room_knd_gbcd"), "ADULT");
			int _addChildAmt = RMSApiService.getAddAmt(param.get("chki_date"), row.get("room_knd_gbcd"), "CHILD");

			if(adult + kids > 0) {
				if(adult + kids > basic) {	// 추가요금 계산
					if(adult > basic) {	// 성인만으로도 기본 초과인 경우
						addAdult += (adult - basic);
						addAmt += (_addAdultAmt * (adult - basic) * night);
						if(kids > 0) {
							addKids += kids;
							addAmt += (_addChildAmt * kids * night);
						}
					} else {
						addKids += (adult + kids - basic);
						addAmt += (_addChildAmt * (adult + kids - basic) * night);
					}
				}
				txt += "<li>객실 " + i + "<span>성인 " + adult + " , 어린이 " + kids + "</span></li>";
				roomCnt++;
			}
%>
					<input type="hidden" name="<%= row.get("room_knd_gbcd") %>_qty_<%= i %>_adult" id="<%= row.get("room_knd_gbcd") %>_qty_<%= i %>_adult" value="<%= adult %>">
					<input type="hidden" name="<%= row.get("room_knd_gbcd") %>_qty_<%= i %>_kids" id="<%= row.get("room_knd_gbcd") %>_qty_<%= i %>_adult" value="<%= kids %>">
<%
		}

		if(roomCnt > 0) {
			totAmt += ((amt * roomCnt) + addAmt);
			totQty += roomCnt;
			listTxt += "<li>" + row.get("room_knd_nm") + "<span>" + roomCnt + " 객실</span><ul>" + txt + "</ul></li>";
			LGD_PRODUCTINFO	= row.get("room_knd_nm");

			// JSONObject for Npay
			JSONObject j = new JSONObject();
			j.put("categoryType", "TRAVEL");
			j.put("categoryId", "DOMESTIC");
			j.put("uid", row.get("room_knd_gbcd"));
			j.put("name", row.get("room_knd_nm"));
			j.put("startDate", param.get("chki_date").replaceAll("\\.", ""));
			j.put("endDate", param.get("chot_date").replaceAll("\\.", ""));
			j.put("count", roomCnt);
			
			jsonArr.add(j);
		}
	}
%>
					<input type="hidden" name="tot_amt" id="tot_amt" value="<%= totAmt %>">
				<h3>예약정보</h3>
				<div class="infoArea">
					<ul class="tit">
						<li>체크인</li>
						<li>체크아웃</li>
					</ul>
					<div class="infoTxt">
						<ul class="checkDate">
							<li class="checkIn"><%= param.get("chki_date").substring(5, 10) %><span><%= param.get("chki_date").substring(0, 4) %></span></li>
							<li class="checkOut"><%= param.get("chot_date").substring(5, 10) %><span><%= param.get("chot_date").substring(0, 4) %></span></li>
						</ul>
						<span class="dateNum">(<%= night %>박)</span>		
						<div class="reservationRoom">
							<p class="tit">객실</p>
							<ul class="roomList">
								<%= listTxt %>
							</ul>
						</div>
					</div>
				</div>
			
				<h3>결제하기</h3>
				<table>
					<colgroup>
						<col width="30%">
						<col width="*">
					</colgroup>
					<tr>
						<th scope="col"><span>쿠폰할인</span></th>
						<td>
							<div>
								<input type="hidden" name="mem_couponid" id="mem_couponid" value="" />			
								<input type="hidden" name="coupon_amt" id="coupon_amt" value="0" />			
								<select style="width:100%" name="coupon" id="coupon" onchange="applyCoupon()">
<%
	if(couponList == null || couponList.size() == 0) {
%>
									<option>적용 가능한 쿠폰이 없습니다.</option>
<%
	} else {
%>
									<option value="">쿠폰을 선택하세요.</option>
<%
		for(Param r : couponList) {
%>
									<option value="<%= r.get("mem_couponid") %>|<%= r.get("sale_type") %>|<%= r.get("sale_amt") %>|<%= r.get("max_sale") %>|<%= r.get("min_price") %>|<%= r.get("coupon_name") %>"><%= r.get("coupon_name") %></option>
<%
		}
	}
%>
								</select>
								<span class="priceTxt" id="coupon_amt_txt">(-0원)</span>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="col"><span>프로모션 코드</span></th>
						<td>
							<div>
								<input type="text" name="promocd" id="promocd"><a href="javascript:getPromocd(true)" class="btnStyle03">확인</a>
								<span class="priceTxt" id="promocd_amt_txt">(-0원)</span>
								<input type="hidden" name="promocdid" id="promocdid" value=""/>
								<input type="hidden" name="promocd_amt" id="promocd_amt" value="0"/>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="col"><span>기프트 카드<a href="#none" onclick="showPopupLayer('/mobile/popup/giftCardInfo.jsp'); return false"><img src="/mobile/images/hotel/room/icon_question.png" alt="안내" style="vertical-align:-2px; width:15px;"></a></span></th>
						<td>
							<div>
								<input type="text" name="giftcard_amt" id="giftcard_amt" readonly><a href="#none" onclick="showGift(); return false" class="btnStyle03">조회</a>
								<span class="priceTxt" id="giftcard_amt_txt">(-0원)</span>
								<input type="hidden" name="giftcard_id" id="giftcard_id">
							</div>
						</td>
					</tr>
					<tr>
						<th scope="col"><span>매일 Do 포인트</span></th>
						<td>
							<div>
								<input type="text" name="point_amt" id="point_amt" value="" onkeydown="return onlyNumber(event);" onkeyup="removeChar(event);" onchange="applyPoint();" <%= point < 100 ? "disabled" : "" %>>P
								<span class="priceTxt" id="point_amt_txt">(-0원)</span>
							</div>
						</td>
					</tr>
				</table>
				<div class="pointAll">
					<input type="checkbox" name="point_all" id="point_all" onclick="pointAll()" <%= point < 100 ? "disabled" : "" %>><label for="point_all">모두사용 (보유 포인트 : <span><%= Utils.formatMoney(point) %></span>P)</label>
				</div>
				<ul class="caption">
					<li>100P 이상 가지고 계실 때, 1P 단위로 사용가능합니다.</li>
					<li>쿠폰은 경우에 따라 중복 적용이 불가합니다.</li>
				</ul>				
				<ul class="allPriceWrap">
					<li>총 예약금액<span><%= Utils.formatMoney(totAmt) %>원</span></li>
					<li>총 할인액<span id="discount_amt_txt">-0원</span></li>
					<li class="last">최종 결제액<span id="pay_amt_txt"><%= Utils.formatMoney(totAmt) %>원</span></li>
				</ul>
			
				<h3>결제수단 선택</h3>
				
				<div class="paymentMethod">
					<ul>
						<li class="pay001"><input type="radio" name="pay_type" id="pay_001" value="001" <%= "001".equals(payType) ? "checked" : "" %>><label for="pay_001">신용카드</label></li>

						<li class="pay002"><input type="radio" name="pay_type" id="pay_002" value="002" <%= "002".equals(payType) ? "checked" : "" %>><label for="pay_002">계좌이체</label></li>

<%-- 						<li class="pay004"><input type="radio" name="pay_type" id="pay_004" value="004" <%= "004".equals(payType) ? "checked" : "" %>><label for="pay_004">PayNow</label></li> --%>

						<li class="pay006"><input type="radio" name="pay_type" id="pay_006" value="006" <%= "006".equals(payType) ? "checked" : "" %>><label for="pay_006">PAYCO</label></li>

						<li class="pay009"><input type="radio" name="pay_type" id="pay_009" value="009" <%= "009".equals(payType) ? "checked" : "" %>><label for="pay_009">네이버페이</label></li>
					</ul>
				</div>
				<ul class="caption captionStyle02" id="npay_notice" style="display:none">
					<li>주문 변경 시 카드사 혜택 및 할부 적용 여부는 해당 카드사 정책에 따라 변경될 수 있습니다.</li>
			 		<li>네이버페이는 네이버ID로 별도 앱 설치 없이 신용카드 또는 은행계좌 정보를 등록하여 네이버페이 비밀번호로 결제할 수 있는 간편결제 서비스입니다.  </li>
			 		<li>결제 가능한 신용카드: 신한, 삼성, 현대, BC, 국민, 하나, 롯데, NH농협, 씨티, 카카오뱅크</li>
			 		<li>결제 가능한 은행: NH농협, 국민, 신한, 우리, 기업, SC제일, 부산, 경남, 수협, 우체국, 미래에셋대우, 광주, 대구, 전북, 새마을금고, 제주은행, 신협, 하나은행, 케이뱅크, 카카오뱅크, 삼성증권</li>
			 		<li>네이버페이 카드 간편결제는 네이버페이에서 제공하는 카드사 별 무이자, 청구할인 혜택을 받을 수 있습니다.</li>
				</ul>	
<%
	LGD_AMOUNT			= String.valueOf(totAmt);
	LGD_TAXFREEAMOUNT	= "0";

	session.setAttribute("DB_AMOUNT", LGD_AMOUNT);
	
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
	StringBuffer sb = new StringBuffer();
	sb.append(LGD_MID);
	sb.append(LGD_OID);
	sb.append(LGD_AMOUNT);
	sb.append(LGD_TIMESTAMP);
	sb.append(LGD_MERTKEY);
	
	byte[] bNoti = sb.toString().getBytes();
	MessageDigest md = MessageDigest.getInstance("MD5");
	byte[] digest = md.digest(bNoti);
	
	StringBuffer strBuf = new StringBuffer();
	for (int i=0 ; i < digest.length ; i++) {
	    int c = digest[i] & 0xff;
	    if (c <= 15){
	        strBuf.append("0");
	    }
	    strBuf.append(Integer.toHexString(c));
	}
	
	String LGD_HASHDATA = strBuf.toString();
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

   	// 가상계좌(무통장) 결제연동을 하시는 경우  할당/입금 결과를 통보받기 위해 반드시 LGD_CASNOTEURL 정보를 LG 유플러스에 전송해야 합니다 .
	payReqMap.put("LGD_CASNOTEURL"          , LGD_CASNOTEURL );               // 가상계좌 NOTEURL
	
	/*Return URL에서 인증 결과 수신 시 셋팅될 파라미터 입니다.*/
	payReqMap.put("LGD_RESPCODE"  		 , "" );
	payReqMap.put("LGD_RESPMSG"  		 , "" );
	payReqMap.put("LGD_PAYKEY"  		 , "" );
	payReqMap.put("LGD_CARDPREFIX" 		 , "" );
	
	session.setAttribute("PAYREQ_MAP", payReqMap);

	for(Iterator i = payReqMap.keySet().iterator(); i.hasNext();){
		Object key = i.next();
		out.println("<input type='hidden' name='" + key + "' id='"+key+"' value='" + payReqMap.get(key) + "'>" );
	}
%>
			<input type="hidden" name="LGD_BUYERPHONE"              id="LGD_BUYERPHONE"               value="">
			<input type="hidden" name="LGD_CASHCARDNUM"             id="LGD_CASHCARDNUM"              value="">
			<input type="hidden" name="LGD_CASHRECEIPTUSE"          id="LGD_CASHRECEIPTUSE"           value="">
			<input type="hidden" name="mem_couponid_cart" id="mem_couponid_cart" />
			<input type="hidden" name="mem_couponid_ship" id="mem_couponid_ship" />
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
	String md_src = EdiDate + MID + LGD_AMOUNT;
	System.out.println("LiteRequest : " + md_src);
	//String hash_String  = SHA256Salt(md_src, EncodeKey);
	String hash_String  = KakaopayUtil.SHA256Salt(md_src, encodeKey);
	System.out.println("LiteRequest : " + hash_String);
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
			<input type="hidden" name="BIN_NUMBER"		value="">
			<!-- KAKAOPAY Field End -->					
			
			<!-- payco field -->
			<input type="hidden" name="reserveOrderNo" id="reserveOrderNo"	value="">
			<input type="hidden" name="sellerOrderReferenceKey" id="sellerOrderReferenceKey"	value="">
			<input type="hidden" name="paymentCertifyToken" id="paymentCertifyToken"	value="">
			<input type="hidden" name="paycoOrderUrl" id="paycoOrderUrl"	value="">

			<!-- Npay field -->
			<input type="hidden" name="paymentId" id="paymentId" value="" />
			<input type="hidden" name="productItems" id="productItems" value='<%= jsonArr.toJSONString() %>' />
			<input type="hidden" name="productCount" id="productCount" value='<%= totQty %>' />
			<input type="hidden" name="naver_return" id="naver_return" value="mreturn_hotel" />

			<!-- etc -->
			<input type="hidden" name="device_type" value="<%= fs.getDeviceType() %>" />

				</form>		
			</div>
			<div class="btnArea">
				<a href="javascript:goPrev()" class="btnStyle04">이전</a><a href="javascript:goNext()" class="btnStyle03">결제하기</a>
			</div>
		</div>
	
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
<script>
totAmt = <%= totAmt %>;
payAmt = <%= totAmt %>;
</script>
<form name="hashForm" id="hashForm" method="POST" action="/order/xpay/hash.jsp">
	<input type="hidden" name="GB" value="hotel">
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
	<input type="hidden" name="sellerOrderProductReferenceKey" value="admission" />
	<input type="hidden" name="excludePaymentMethodCodes" value="02" />
	<input type="hidden" name="returnUrl" value="payco_return_mobile_hotel.jsp?orderid=<%= orderid %>">
</form>
<!-- KAKAOPAY Hidden -->
<div id="kakaopay_layer"  style="display: none"></div>
<iframe name="txnIdGetterFrame" id="txnIdGetterFrame" src="" width="0" height="0"></iframe>
</body> 
</html>