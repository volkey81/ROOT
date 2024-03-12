<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="com.sanghafarm.utils.*"%>
<%@page import="com.sanghafarm.common.FrontSession"%>
<%@page import="java.util.List"%>
<%@page import="com.sanghafarm.service.order.*,
				com.sanghafarm.service.code.*,
				com.sanghafarm.service.member.*"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/order/kakaopay/incKakaopayCommon.jsp" %>
<%@ include file="/order/payco/common_include.jsp" %>
<%
	request.setAttribute("Depth_1", new Integer(4));
	request.setAttribute("Depth_2", new Integer(5));
	request.setAttribute("Depth_3", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("개인 결제"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");
	
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);

	// Device check
	boolean isMobileOS = false;
	if("A".equals(fs.getDeviceType())) {
		isMobileOS = true; 
	} else {
		String ua=request.getHeader("User-Agent").toLowerCase();
		if (ua.matches(".*(android|avantgo|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\\/|plucker|pocket|psp|symbian|treo|up\\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino).*")||ua.substring(0,4).matches("1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\\-(n|u)|c55\\/|capi|ccwa|cdm\\-|cell|chtm|cldc|cmd\\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\\-s|devi|dica|dmob|do(c|p)o|ds(12|\\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\\-|_)|g1 u|g560|gene|gf\\-5|g\\-mo|go(\\.w|od)|gr(ad|un)|haie|hcit|hd\\-(m|p|t)|hei\\-|hi(pt|ta)|hp( i|ip)|hs\\-c|ht(c(\\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\\-(20|go|ma)|i230|iac( |\\-|\\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\\/)|klon|kpt |kwc\\-|kyo(c|k)|le(no|xi)|lg( g|\\/(k|l|u)|50|54|e\\-|e\\/|\\-[a-w])|libw|lynx|m1\\-w|m3ga|m50\\/|ma(te|ui|xo)|mc(01|21|ca)|m\\-cr|me(di|rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\\-2|po(ck|rt|se)|prox|psio|pt\\-g|qa\\-a|qc(07|12|21|32|60|\\-[2-7]|i\\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\\-|oo|p\\-)|sdk\\/|se(c(\\-|0|1)|47|mc|nd|ri)|sgh\\-|shar|sie(\\-|m)|sk\\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\\-|v\\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\\-|tdg\\-|tel(i|m)|tim\\-|t\\-mo|to(pl|sh)|ts(70|m\\-|m3|m5)|tx\\-9|up(\\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|xda(\\-|2|g)|yas\\-|your|zeto|zte\\-")){
			isMobileOS = true; 
			if(ua.indexOf("v901") > -1 || ua.indexOf("v500") > -1 || ua.indexOf("v525") > -1 || ua.indexOf("lg-v700n") > -1 || ua.indexOf("lg-v607l") > -1) { 
				isMobileOS = false;	
			}
		}
	}
	if(isMobileOS) {
		Utils.sendMessage(out, "모바일용 화면으로 이동합니다.", "/mobile/customer/paymemt/list.jsp");
		return;
	}
	// End of Device check

	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessage(out, FrontSession.LOGIN_MSG, request);
		return;
	}
	
	PersonalPayService personal = (new PersonalPayService()).toProxyInstance();
	CodeService code = (new CodeService()).toProxyInstance();
	MemberService member = (new MemberService()).toProxyInstance();

	String orderid = param.get("orderid");
	Param info = personal.getInfo(orderid);
	
	if(info == null || "".equals(info.get("orderid")) || fs.getUserNoLong() != info.getLong("unfy_mmb_no")) {
		Utils.sendMessage(out, "잘못된 접근입니다.");
		return;
	}

	Param memInfo = member.getInfo(fs.getUserId());
	String payType = memInfo.get("pay_type", "001");
%>
<%
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
	String CST_MID              = Config.get("lgdacom.CST_MID");                      //LG유플러스로 부터 발급받으신 상점아이디를 입력하세요.
	String LGD_MID              = ("test".equals(CST_PLATFORM.trim())?"t":"")+CST_MID;  //테스트 아이디는 't'를 제외하고 입력하세요.
	                                                                                    //상점아이디(자동생성)
	String LGD_OID              = orderid;                      //주문번호(상점정의 유니크한 주문번호를 입력하세요)
	String LGD_AMOUNT           = info.get("sale_price");								                   //결제금액("," 를 제외한 결제금액을 입력하세요)
	String LGD_MERTKEY          = Config.get("lgdacom.LGD_MERTKEY");   					//상점MertKey(mertkey는 상점관리자 -> 계약정보 -> 상점정보관리에서 확인하실수 있습니다)
	String LGD_BUYER            = fs.getUserNm();                    //구매자명
	String LGD_PRODUCTINFO      = "개인결제";              //상품명
	String LGD_BUYEREMAIL       = fs.getEmail();               //구매자 이메일
	String LGD_BUYERPHONE		= fs.getMobileWithoutHyphen();
	String LGD_TIMESTAMP        = Utils.getTimeStampString("yyyyMMddHHmmss");                //타임스탬프
	String LGD_CUSTOM_USABLEPAY = "SC0010";        	//상점정의 초기결제수단
	String LGD_CUSTOM_SKIN      = "red";                                                //상점정의 결제창 스킨(red, yellow, purple)
	String LGD_CUSTOM_SWITCHINGTYPE = "IFRAME"; //신용카드 카드사 인증 페이지 연동 방식 (수정불가)
	String LGD_WINDOW_VER		= "2.5";												//결제창 버젼정보
	String LGD_WINDOW_TYPE      = "iframe";               //결제창 호출 방식 (수정불가)
	
	String LGD_TAXFREEAMOUNT	= "0";	// 면세금액
	
	/*
	 * LGD_RETURNURL 을 설정하여 주시기 바랍니다. 반드시 현재 페이지와 동일한 프로트콜 및  호스트이어야 합니다. 아래 부분을 반드시 수정하십시요.
	 */
	String LGD_RETURNURL		= request.getScheme() + "://" + request.getServerName() + "/order/xpay/returnurl.jsp";// FOR MANUAL
	System.out.println("-------------- LGD_RETURNURL : " + LGD_RETURNURL);


	//TODO KaKaoPay의 INBOUND 전문 URL SETTING
	String msgName = "merchant/requestDealApprove.dev";
	String webPath = "https://kmpay.lgcns.com:8443/"; //PG사의 인증 서버 주소
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" /> 
<!-- payco -->
<script type="text/javascript" src="https://static-bill.nhnent.com/payco/checkout/js/payco.js" charset="UTF-8"></script>
<!-- // payco -->

<!-- 카카오 css, javascript 시작 -->
<!-- OpenSource Library -->
<script src="https://pg.cnspay.co.kr:443/dlp/scripts/lib/easyXDM.min.js" type="text/javascript"></script>
<script src="https://pg.cnspay.co.kr:443/dlp/scripts/lib/json3.min.js" type="text/javascript"></script>

<!-- JQuery에 대한 부분은 site마다 버전이 다를수 있음 -->
<script src="<%=webPath %>/js/dlp/lib/jquery/jquery-1.11.1.min.js" charset="urf-8"></script>

<!-- DLP창에 대한 KaKaoPay Library -->
<script src="<%=webPath %>/js/dlp/client/kakaopayDlpConf.js" charset="utf-8"></script>
<script src="<%=webPath %>/js/dlp/client/kakaopayDlp.min.js" charset="utf-8"></script> 
<!-- kakaopayLiteRequest에서 jquery 충돌이 나서 회피하려고 할때 변경사항 -->
<!-- <script src="<%=webPath %>/js/dlp/client/kakaopayDlp.pure.min.js" charset="utf-8"></script> -->

<!-- 인증 화면 호출 시 필요한 css 설정 -->
<link href="https://pg.cnspay.co.kr:443/dlp/css/kakaopayDlp.css" rel="stylesheet" type="text/css" />
<!-- 카카오 css, javascript  -->

<script language="javascript" src="<%= request.getScheme() %>://xpay.uplus.co.kr/xpay/js/xpay_crossplatform.js" type="text/javascript"></script>
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
			document.getElementById("orderForm").action = "<%= Env.getSSLPath() %>/customer/payment/orderProc.jsp";
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
        document.orderForm.action = "<%= Env.getSSLPath() %>/customer/payment/orderProc.jsp";
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
			location.href = paycoOrderUrl;
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
	var v;
	var payAmt = <%= info.get("sale_price") %>;

	$(function(){
		v = new ef.utils.Validator($("#orderForm"));
	});	

	function orderProc() {
		if(v.validate()) {
			if(!$("#agree").prop("checked")) {
				alert("결제대행서비스 이용동의는 필수입니다.");
				return;
			}
	
			if($("input[name=pay_type]:checked").length == 0) {
				alert("결제수단을 선택하세요.");
				return;
			}
<%
	if(SystemChecker.isLocal()) {
%>
// 			$("#orderForm").submit();
// 			return;
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
						launchCrossPlatform();
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
	<jsp:include page="/include/header.jsp" />
	<jsp:include page="/include/location.jsp" />
	<div id="container">
		<jsp:include page="/customer/snb.jsp" />
		<div id="contArea" class="customerPayment">
		<form name="orderForm" id="orderForm" method="post" action="<%= Env.getSSLPath() %>/customer/payment/orderProc.jsp">
			<input type="hidden" name="orderid" value="<%= orderid %>" />
		
			<h1 class="typeA"><%=MENU_TITLE %><span>※ 개인 결제 문의는 고객센터  1522-3698로 연락 부탁드립니다</span></h1>
			<!-- 내용영역 -->	
<%
	if("120".equals(info.get("status"))) {
%>
			<p class="endTxt">결제가 완료되었습니다.</p>
<%
	} else if("290".equals(info.get("status"))) {
%>
			<p class="endTxt">결제가 취소되었습니다.</p>
<%
	}
%>
			<table class="bbsForm typeB">
				<caption>개인 결제입력폼</caption>
				<colgroup>
					<col width="130"><col width="">
				</colgroup>
				<tr>
					<th scope="row"><label for="type">* 판매구분</label></th>
					<td><span><%= info.get("div_name") %></span></td>
				</tr>
				<tr>
					<th scope="row"><label for="info">* 결제 정보</label></th>
					<td><span><%= info.get("mmb_nm") %>(<%= info.get("mmb_id") %>)님의 <%= info.get("regist_date") %>에 등록된 개인 결제</span></td>
				</tr>
				<tr>
					<th scope="row"><label for="cont">주문 내역</label></th>
					<td><span class="txt"><%= Utils.enter2br(info.get("contents")) %></span></td>
				</tr>
				<tr>
					<th scope="row"><label for="price">* 결제 금액</label></th>
					<td><span class="price"><%= Utils.formatMoney(info.get("sale_price")) %>원</span></td>
				</tr>	
			</table>

<%
	if("110".equals(info.get("status"))) {
%>
			<h2 class="typeA">이용동의</h2>
		 	<div class="agreeChk">
		 		<div class="section">
		 			<h3>결제대행서비스 표준이용약관</h3>
		 			<div class="cont"><div class="scr">
						<jsp:include page="/order/agree.jsp" />
		 			</div></div>
		 		</div>
		 		<div class="section">
		 			<h3><label for="agree3">주문내역 동의</label></h3>
		 			<div class="cont"><div class="scr">
						주문할 상품의 상품명, 상품가격, 배송정보를 확인하였습니다. (전자상거래법 제 8조 2항)<br>구매에 동의하시겠습니까?
		 			</div></div>
		 		</div>
		 		<p class="agreeCheck"><input name="agree" id="agree" type="checkbox"><label for="agree">구매조건을 확인하였으며, 결제대행 서비스 약관에 동의합니다.</label></p>
		 	</div><!-- 이용동의 -->
		 	<!-- //회원 -->
	 	
		 	<h2 class="typeA">결제수단 선택</h2>
		 	<p class="discountInfo"><!-- <a href="">신용카드 별 결제 할인 안내</a> --></p>
		 	<div class="payWay">
<%
		List<Param> payList = code.getList2("007");
		for(Param row : payList) {
			if("003".equals(row.get("code2")) || "005".equals(row.get("code2"))) continue;
%>
			 	<input type="radio" name="pay_type" id="pay_<%= row.get("code2") %>" value="<%= row.get("code2") %>" <%= payType.equals(row.get("code2")) ? "checked" : "" %>>
				<label for="pay_<%= row.get("code2") %>" style="color:"><%= row.get("name2") %></label>
					
<%
		}
%>
		 	</div>	
			<div class="btnArea ac">
				<a href="javascript:orderProc()" class="btnTypeB">결제하기</a>
			</div>

<%
	}
%>

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
			<input type="hidden" name="LGD_BUYERPHONE"              id="LGD_BUYERPHONE"               value="<%= LGD_BUYERPHONE %>">
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
			
			<!-- etc -->
			<input type="hidden" name="device_type" value="<%= fs.getDeviceType() %>" />

		</form>
			<!-- //내용영역 -->
		</div><!-- //contArea -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
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
	<input type="hidden" name="sellerOrderProductReferenceKey" value="FAMILY" />
	<input type="hidden" name="excludePaymentMethodCodes" value="02" />
	<input type="hidden" name="returnUrl" value="payco_return.jsp">
</form>
<!-- KAKAOPAY Hidden -->
<div id="kakaopay_layer"  style="display: none"></div>
<iframe name="txnIdGetterFrame" id="txnIdGetterFrame" src="" width="0" height="0"></iframe>

</body>
</html>