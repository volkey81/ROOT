<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			java.text.*,
			java.security.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.service.code.*,				 
			com.sanghafarm.service.member.*" %>
<%@ include file="/order/kakaopay/incKakaopayCommon.jsp" %>
<%@ include file="/order/payco/common_include.jsp" %>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);
	
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessage(out, FrontSession.LOGIN_MSG, request);
		return;
	}

	String referer = request.getHeader("referer");
	//System.out.println("--------------------" + referer);
	if(referer == null || referer.indexOf("/familyJoin2018/agree.jsp") < 0) {
		response.sendRedirect("/familyJoin2018/");
		return;
	}
	
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
		Utils.sendMessage(out, "모바일용 화면으로 이동합니다.", "/mobile/familyJoin2018/");
		return;
	}
	// End of Device check

	FamilyMemberService svc = (new FamilyMemberService()).toProxyInstance();
	CodeService code = (new CodeService()).toProxyInstance();
	MemberService member = (new MemberService()).toProxyInstance();

	String orderid = svc.getNewId();
	member.modifyOrderid(fs.getUserId(), orderid);
	int price = 30000;
	Param memInfo = member.getInfo(fs.getUserId());
	String payType = memInfo.get("pay_type", "001");
%>
<%
	request.setAttribute("Depth_1", new Integer(2));
	request.setAttribute("Depth_2", new Integer(2));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("상하가족 가입안내"));
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
	String LGD_AMOUNT           = (new Integer(price)).toString();								                   //결제금액("," 를 제외한 결제금액을 입력하세요)
	String LGD_MERTKEY          = Config.get("lgdacom.LGD_MERTKEY");   					//상점MertKey(mertkey는 상점관리자 -> 계약정보 -> 상점정보관리에서 확인하실수 있습니다)
	String LGD_BUYER            = fs.getUserNm();                    //구매자명
	String LGD_PRODUCTINFO      = "상하가족";              //상품명
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
<script>

$(function(){
	$(".familyPayment>ul li input")
	.bind("focusin", function(){
		$(this).parent().find("div").addClass("on");	
	})
	.bind("focusout", function(){
		$(this).parent().find("div").removeClass("on");	
	});
});
</script>

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
			document.getElementById("orderForm").action = "<%= Env.getSSLPath() %>/familyJoin2018/orderProc.jsp";
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
        document.orderForm.action = "<%= Env.getSSLPath() %>/familyJoin2018/orderProc.jsp";
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
	var totPrice = <%= price %>;
	var couponAmt = 0;
	var payAmt = <%= price %>;
	var v;

	$(function(){
		getCouponList();
		v = new ef.utils.Validator($("#orderForm"));
// 		checkAll("#agreeAll", ".agrees");

		v.add("name", {
			"empty" : "이름을 입력해 주세요.",
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
		v.add("post_no", {
			"empty" : "우편번호를 입력해 주세요."
		});
		v.add("addr1", {
			"empty" : "주소를 입력해 주세요."
		});
		v.add("addr2", {
			"empty" : "주소를 입력해 주세요."
		});
	});	

	function setAgreeAll() {
		$("#agree1").prop("checked", $("#agreeAll").prop("checked"));
		$("#agree2").prop("checked", $("#agreeAll").prop("checked"));
	}
	
	function orderProc() {
		if(v.validate()) {
			if(!$("#agree1").prop("checked")) {
				alert("결제대행서비스 이용동의는 필수입니다.");
				return;
			}
			if(!$("#agree2").prop("checked")) {
				alert("주문내역 동의는 필수입니다.");
				return;
			}

			if($("input[name=pay_type]:checked").length == 0) {
				alert("결제수단을 선택하세요.");
				return;
			}
	
			/*
			if($("input[name=pay_type]:checked").val() == "010") {	// 쿠폰결제
				if($("input[name=coupon_serial1]").val().length < 4
						|| $("input[name=coupon_serial2]").val().length < 4
						|| $("input[name=coupon_serial3]").val().length < 4
						|| $("input[name=coupon_serial4]").val().length < 4
						) {
					alert("일련번호를 정확히 입력하세요.");
					return;
				}
			}
			*/

			payAmt = totPrice - couponAmt;
			$("#orderForm input[name=LGD_AMOUNT]").val(payAmt);
			$("#orderForm input[name=Amt]").val(payAmt);
			$("#paycoReserveForm input[name=totalPaymentAmt]").val(payAmt);

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
						launchCrossPlatform();
					} else {
						alert("결제 진행중 오류가 발생했습니다.");
					}
				});
			}			
		}
	}
	
	function getCouponList() {
		$.post('coupon.jsp', function(html){
			$("#coupon").empty().html(html);
		});	
	}
	
	function downloadSerial() {
		if($("input[name=coupon_serial1]").val().length != 4) {
			alert("쿠폰번호를 정확히 입력하세요.");
		} else if($("input[name=coupon_serial2]").val().length != 4) {
			alert("쿠폰번호를 정확히 입력하세요.");
		} else if($("input[name=coupon_serial3]").val().length != 4) {
			alert("쿠폰번호를 정확히 입력하세요.");
		} else if($("input[name=coupon_serial4]").val().length != 4) {
			alert("쿠폰번호를 정확히 입력하세요.");
		} else {
			var couponSerial = $("input[name=coupon_serial1]").val() + "-" + $("input[name=coupon_serial2]").val() + "-" + $("input[name=coupon_serial3]").val() + "-" + $("input[name=coupon_serial4]").val();

			$.ajax({
				method : "POST",
				url : "/mypage/coupon/serial.jsp",
				data : { coupon_serial : couponSerial },
				dataType : "json"
			})
			.done(function(json) {
				alert(json.msg);
				if(json.result) getCouponList();
			});
		}
	}

	function applyCoupon() {
		if($("#coupon").val() == '') {
			resetCoupon();
		} else {
			//mem_couponid|sale_type|sale_amt|max_sale|min_price|coupon_name
			var arr = $("#coupon").val().split("|");
			
			// 최소금액 미달시
			if(totPrice < parseInt(arr[4])) {
				alert("최소 " + arr[4].formatMoney() + "원 이상시 사용가능합니다.");
				resetCoupon();
			} else {
				if(arr[1] == 'A') {	// 정액
					couponAmt = parseInt(arr[2]) >= parseInt(arr[3]) ? parseInt(arr[3]) : parseInt(arr[2]);
				} else {	// 정률
					couponAmt = (parseInt(arr[2]) * totPrice / 100 >= parseInt(arr[3])) ? parseInt(arr[3]) : parseInt(arr[2]) * totPrice / 100;
				}
				
				var _txt = "<li>" + arr[5] + "<span class=\"fontTypeE\"><strong>" + couponAmt.formatMoney() + "</strong>원</span></li>";
				$("#couponListArea").html(_txt);
				
				$("#mem_couponid").val(arr[0]);
				$("#totalSaleAmt").html("-" + couponAmt.formatMoney());
				$("#totalPayAmt").html((totPrice - couponAmt).formatMoney());
			}
		} 
	}

	function resetCoupon() {
		couponAmt = 0;
		$("#coupon").val("");
		$("#mem_couponid").val("");
		$("#totalSaleAmt").html("-0");
		$("#totalPayAmt").html(totPrice.formatMoney());
		$("#couponListArea").empty();
	}

	function changeEmail3(v) {
		if(v == '') {
			$("#email2").val("");
			$("#email2").prop("readonly", "");
		} else {
			$("#email2").val(v);
			$("#email2").prop("readonly", "readonly");
		}
	}

	function changeShipMemo(v) {
		if(v == '직접입력') {
			$("#ship_memo").val('');
			$("#ship_memo").show();
		} else {
			$("#ship_memo").val(v);
			$("#ship_memo").hide();
		}
	}
</script>

<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script>
	function execDaumPostcode() {
	    new daum.Postcode({
	        oncomplete: function(data) {
	            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
	
	            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
	            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
	            var fullAddr = ''; // 최종 주소 변수
	            var extraAddr = ''; // 조합형 주소 변수
	
	            // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
	            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
	                fullAddr = data.roadAddress;
	
	            } else { // 사용자가 지번 주소를 선택했을 경우(J)
	                fullAddr = data.jibunAddress;
	            }
	
	            // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
	            if(data.userSelectedType === 'R'){
	                //법정동명이 있을 경우 추가한다.
	                if(data.bname !== ''){
	                    extraAddr += data.bname;
	                }
	                // 건물명이 있을 경우 추가한다.
	                if(data.buildingName !== ''){
	                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                }
	                // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
	                fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
	            }
	
	            // 우편번호와 주소 정보를 해당 필드에 넣는다.
// 	            document.getElementById('sample6_postcode').value = data.zonecode; //5자리 새우편번호 사용
// 	            document.getElementById('sample6_address').value = fullAddr;
	            $("#post_no").val(data.zonecode); //5자리 새우편번호 사용
	            $("#addr1").val(fullAddr);
	
	            // 커서를 상세주소 필드로 이동한다.
// 	            document.getElementById('sample6_address2').focus();
	            $("#addr2").val('');
	            $("#addr2").focus();
	        }
	    }).open();
	}
</script>

</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header.jsp" />
	<ul id="location">
		<li><a href="/">홈</a></li>
		<li>상하가족</li>
	</ul>
	<div id="container">
	<!-- 내용영역 -->
		<form name="orderForm" id="orderForm" method="post" action="<%= Env.getSSLPath() %>/familyJoin2018/orderProc.jsp">
			<input type="hidden" name="orderid" value="<%= orderid %>" />
			<input type="hidden" name="userid" value="<%= param.get("userid") %>" />
			<input type="hidden" name="userno" value="<%= param.get("userno") %>" />
			<input type="hidden" name="benefit_type" value="2" />
		<div class="familyJoin">
			<img src="/images/familyJoin/familyJoin01.jpg" alt="프리미엄 서비스 상하가족 가입안내.상하와 가족이 되다">
			<p class="joinTit">배송지 입력 및 결제 </p>
			<div class="joinStep">
				<ul>
					<li><span>약관동의</span>></li>
					<li class="on"><span>결제</span>></li>
					<li><span>가입완료</span></li>
				</ul>
			</div>
			<div class="familyPayment">
				<ul>
					<li>· 가입선물을 수령하실  배송지 정보를 정확하게 기입해 주세요.</li>
					<li>· 회원님의 과실로 인한 오배송은 책임지지 않습니다.</li>
					<li>· 배송지 변경은 고객센터(1522-3698)로 문의주세요.</li>
				</ul>
				
				<h2 class="typeA">웰컴 기프트배송지 정보 입력</h2>
				<table class="bbsForm">
					<caption>웰컴 기프트배송지 정보 입력폼</caption>
					<colgroup>
						<col width="130"><col width="">
					</colgroup>
					<tr>
						<th scope="row">성명 <em>*</em></th>
						<td>
							<input type="text" name="name" id="name" title="성명" style="width:140px" value="<%= fs.getUserNm() %>">
						</td>
					</tr>
					<tr>
						<th scope="row">휴대전화 <em>*</em></th>
						<td>
							<select name="mobile1" id="mobile1" title="휴대전화 앞자리" style="width:88px">
<%
	for(String mobile : SanghafarmUtils.MOBILES) {
%>
								<option value="<%= mobile %>" <%= mobile.equals(fs.getMobile1()) ? "selected" : "" %>><%= mobile %></option>
<%
	}
%>
							</select>&nbsp;-
							<input type="text" name="mobile2" id="mobile2" value="<%= fs.getMobile2() %>" title="휴대전화 가운데자리" style="width:70px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">&nbsp;-
							<input type="text" name="mobile3" id="mobile3" value="<%= fs.getMobile3() %>" title="휴대전화 뒷자리" style="width:70px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">
						</td>
					</tr>
					<tr>
						<th scope="row">일반전화</th>
						<td>					
							<input type="text" name="tel1" id="tel1" title="일반전화 앞자리" style="width:70px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">&nbsp;-
							<input type="text" name="tel2" id="tel2" title="일반전화 가운데자리" style="width:70px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">&nbsp;-
							<input type="text" name="tel3" id="tel3" title="일반전화 뒷자리" style="width:70px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">
						</td>
					</tr>
					<tr>
						<th scope="row">이메일</th>
						<td>
							<input type="text" name="email1" id="email1" value="<%= fs.getEmail1() %>" title="이메일 앞자리" style="width:140px">&nbsp;@
							<input type="text" name="email2" id="email2" value="<%= fs.getEmail2() %>" title="이메일 뒷자리" style="width:90px">
							<select name="ship_email3" id="ship_email3" onchange="changeEmail3(this.value)" title="이메일 뒷자리 선택" style="width:110px">
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
					<tr>
						<th scope="row">배송지 <em>*</em></th>
						<td>
							<input type="text" name="post_no" id="post_no" value="<%= fs.getZipCode() %>" title="우편번호" style="width:70px" readonly>
							<a href="javascript:execDaumPostcode()" class="btnTypeA">우편번호찾기</a><br>
							<input type="text" name="addr1" id="addr1" readonly value="<%= fs.getAddr1() %>" title="배송지 주소" style="width:400px;margin-top:6px"><br>
							<input type="text" name="addr2" id="addr2" value="<%= fs.getAddr2() %>" title="배송지 상세주소" style="width:400px;margin-top:6px" placeholder="상세주소 입력">
						</td>
					</tr>
					<tr>
						<th scope="row">배송 요청사항</th>
						<td>
		 					<select name="ship_memo_sel" onchange="changeShipMemo(this.value)">
								<option value="">배송 메시지를 입력해주세요</option>
								<option value="배송 전에 미리 연락 바랍니다.">배송 전에 미리 연락 바랍니다.</option>
								<option value="부재시 경비실에 맡겨주세요.">부재시 경비실에 맡겨주세요.</option>
								<option value="택배함에 넣어주세요.">택배함에 넣어주세요.</option>
								<option value="직접입력">직접입력</option>
							</select><br>
							<input type="text" name="ship_memo" id="ship_memo" style="display:none; margin-top:5px;width:400px;"> <!-- 직접입력 선택시 show-->
						</td>
					</tr>
				</table><!-- //배송지정보 -->
				
				<div class="payment member"><!-- [dev] 회원일떄만 class=member 추가 -->
				 	<div class="totalPrice">
						<span>상품 소계 <em><strong id="totalAmt"><%= Utils.formatMoney(price) %></strong>원</em>
							<span class="couponSelect"></span>
						</span>
						<span>할인 소계<em class="fontTypeE"><strong id="totalSaleAmt">-0</strong>원</em></span>				
						<ul id="couponListArea">
						</ul>
						<!-- 
						<ul id="pointListArea">
							<li>상하가족 5천원 할인쿠폰<span class="fontTypeE"><strong>5,000</strong>원</span></li>
						</ul>
						<ul id="giftListArea">
							<li>상하가족 5천원 할인쿠폰<span class="fontTypeE"><strong>5,000</strong>원</span></li>
						</ul>
						 -->
						<span class="total">총 결제예상금액 <em class="fontTypeE"><strong id="totalPayAmt"><%= Utils.formatMoney(price) %></strong>원</em></span>
					</div>		
				 	<div class="agreeChk">
				 		<div class="allCheck">
				 			<input type="checkbox" id="agreeAll" onclick="setAgreeAll()">
				 			<label for="agreeAll">전체동의</label>
				 		</div>
				 		<div class="section first">
				 			<h3><input type="checkbox" name="agree1" id="agree1" class="agrees"><label for="agree1">결제대행서비스 표준이용약관</label></h3>
				 			<div class="cont">
				 				<div class="scr">			
									<h4>고유식별번호 수집 및 이용 동의</h4>
									<ol>
										<li>1. 주식회사 LG유플러스(이하 “회사”라 합니다)은 개인정보보호법에 의해 통신과금서비스 이용자(이하 “이용자”라 합니다)로 부터 아래와 같이 고유식별번호를 수집 및 이용합니다.</li>
										<li>2. 회사가 이용자의 고유식별번호를 수집, 이용하는 목적은 아래와 같습니다.
											<ol>
												<li>① 이용자가 구매한 재화나 용역의 대금 결제</li>
												<li>② 이용자가 결제한 거래의 취소 또는 환불</li>
												<li>③ 이용자가 결제한 거래의 청구 및 수납</li>
												<li>④ 이용자가 수납한 거래 대금의 정산</li>
												<li>⑤ 이용자가 결제한 거래의 내역을 요청하는 경우 응대 및 확인</li>
												<li>⑥ 통신과금서비스 이용 불가능한 이용자(미성년자 등)와 불량, 불법 이용자의 부정 이용 방지</li>
											</ol>
										</li>
										<li>3. 회사는 아래와 같이 이용자로부터 수집한 고유식별번호를 제3자에게 제공합니다.
											<table class="bbsList typeC">
												<thead>
													<tr>			
														<th scope="col">고유식별번호를 제공받는 자</th>
														<th scope="col">고유식별번호를 제공받는 자의 이용 목적</th>
														<th scope="col">제공받는 자의 고유식별번호 보유 및 이용 기간</th>
													</tr>
												</thead>
												<tbody>
													<tr>
														<td>주식회사 에스케이텔레콤, 주식회사 케이티</td>
														<td>이용자 본인 인증 및 거래 승인</td>
														<td>건당 거래 금액 1만원 초과의 경우 5년, 건당 거래 금액 1만원 이하의 경우 1년</td>
													</tr>
												</tbody>	
											</table>
										</li>		
										<li>회사가 수집한 이용자 고유식별번호의 보유, 이용 기간은 아래와 같습니다.
											<ol>
												<li>① 건당 거래 금액 1만원 초과의 경우: 5년간</li>
												<li>② 건당 거래 금액 1만원 이하의 경우: 1년간</li>
											</ol>
										</li>
									</ol>

									<h4>개인정보 수집 및 이용 동의</h4>
									
									<p>㈜LG유플러스(이하 ‘회사’라 함)는 전자금융거래법 및 동법 시행령 상의 제반 사항, 전자상거래 등에서의 소비자보호에 관한 법률 및 전자상거래 등에서의 소비자보호 지침, 정보통신망 이용촉진 및 정보보호 등에 관한 법률 법률 제22조(개인정보의 수집 이용 동의 등) 및 개인정보보호법 제15조(개인정보의 수집 이용)에 의해 통신과금/전자금융서비스 이용자(이하 “이용자”라 합니다)로부터 아래와 같이 개인정보를 수집 및 이용합니다.</p>
									
									<h5>1. 수집하는 개인정보의 항목</h5>
									<ol>
										<li>가. 회사는 회원가입, 상담, 서비스 신청 등을 위해 아래와 같은 개인정보를 수집하고 있습니다. - 이름, 주민번호, 카드번호, 비밀번호, 전화번호, 휴대폰번호, 이메일, 사용자 IP Address, 쿠키, 서비스 이용기록, 결제기록, 결제정보 등</li>
										<li>나. “결제정보”라 함은 ”이용자”가 고객사의 상품 및 서비스를 구매하기 위하여 “회사”가 제공하는 ‘서비스’를 통해 제시한 각 결제수단 별 제반 정보를 의미하며 신용카드 번호, 신용카드 유효기간, 성명, 계좌번호, 주민등록번호, 휴대폰번호, 유선전화번호, 상품권번호 등을 말합니다.</li>
										<li>다. 회사는 서비스 이용과 관련한 대금결제, 물품배송 및 환불 등에 필요한 정보를 추가로 수집할 수 있습니다.</li>
									</ol>
									
									<h5>2. 개인정보의 수집 및 이용 목적</h5>
									<ol>
										<li>가. 회사는 다음과 같은 목적 하에 “결제서비스”와 관련한 개인정보를 수집합니다. - 사고 및 리스크 관리, 통계 활용, 결제결과 통보<br>
										- 신용카드, 계좌이체, 가상계좌, 휴대폰결제, 유선전화결제 등 결제서비스 제공, 결제결과 조회 및 통보</li>
										<li>나. 서비스 제공에 관한 계약 이행 및 서비스 제공에 따른 요금정산<br>
											- 서비스 가입, 변경 및 해지, 요금정산, A/S 등 서비스 관련 문의 등을 포함한 이용계약관련 사항의 처리<br>
											- 청구서 등의 발송, 금융거래 본인 인증 및 금융서비스, 요금추심 등</li>
										<li>다. 회사가 제공하는 서비스의 이용에 따르는 본인확인, 이용자간 거래의 원활한 진행, 본인의사의 확인, 불만처리, 새로운 정보와 고지사항의 안내, 상품 배송을 위한 배송지 확인, 대금결제서비스의 제공 및 환불입금 정보등 서비스 제공을 원할하게 하기 위해 필요한 최소한의 정보제공만을 받고 있습니다.</li>
									</ol>
								
									<h5>3. 개인정보의 보유 및 이용기간</h5>
			
									<p>이용자의 개인정보는 원칙적으로 개인정보의 수집 및 이용목적이 달성되면 지체 없이 파기합니다. 단, 다음의 정보에 대해서는 아래의 이유로 명시한 기간 동안 보존합니다.</p>
									<ol>
										<li>가. 회사 내부 방침에 의한 정보 보유 사유 - 본 전자결제서비스 계약상의 권리, 의무의 이행</li>
										<li>나. 관련법령에 의한 정보보유 사유 상법, 전자상거래 등에서의 소비자보호에 관한 법률 등 관계법령의 규정에 의하여 보존할 필요가 있는 경우 회사는 관계법령에서 정한 일정한 기간 동안 회원정보를 보관합니다. 이 경우 회사는 보관하는 정보를 그 보관의 목적으로만 이용하며 보존기간은 아래와 같습니다.
											<h6>* 계약 또는 청약철회 등에 관한 기록</h6>
											<ul>
												<li>보존 이유 : 전자상거래 등에서의 소비자보호에 관한 법률</li>
												<li>보존 기간 : 5 년 </li>
											</ul>
											<h6>* 대금결제 및 재화 등의 공급에 관한 기록</h6>
											<ul>
												<li>보존 이유 : 전자상거래 등에서의 소비자보호에 관한 법률</li>
												<li>보존 기간 : 5 년 </li>
											</ul>
											<h6>* 소비자의 불만 또는 분쟁처리에 관한 기록</h6>
											<ul>
												<li>보존 이유 : 전자상거래 등에서의 소비자보호에 관한 법률</li>
												<li>보존 기간 : 3 년</li>
											</ul>
											<h6>* 본인확인에 관한 기록</h6>
											<ul>
												<li>보존 이유 : 정보통신 이용촉진 및 정보보호 등에 관한 법률</li>
												<li>보존 기간 : 6 개월</li>
											</ul>
										</li>
									</ol>
	
									<h5>4. 개인정보 파기절차 및 방법</h5>
									
									<p>이용자의 개인정보는 원칙적으로 개인정보의 수집 및 이용목적이 달성되면 지체 없이 파기합니다. 회사의 개인정보 파기절차 및 방법은 다음과 같습니다.</p>
									<h6>가. 파기절차 </h6>
									<ul>
										<li>이용자가 회원가입 등을 위해 입력한 정보는 목적이 달성된 후 별도의 DB 로 옮겨져(종이의 경우 별도의 서류함) 내부 방침 및 기타 관련 법령에 의한 정보보호 사유에 따라(보유 및 이용기간 참조)일정 기간 저장된 후 파기됩니다.</li>
										<li>동 개인정보는 법률에 의한 경우가 아니고서는 보유되는 이외의 다른 목적으로 이용되지 않습니다.</li>
									</ul>
								
									<h6>나. 파기방법 </h6>
									<ul>
										<li>종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여 파기합니다.</li>
										<li>전자적 파일 형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제합니다.</li>
									</ul>
										
									<h4>개인정보 제공 및 위탁 동의</h4>
									<ol>
										<li>1. 주식회사 LG유플러스(이하 “회사”라 합니다)는 정보통신망 이용촉진 및 정보보호 등에 관한 법률 및 개인정보보호법에 의해 통신과금/전자금융서비스 이용자(이하 “이용자”라 합니다)로부터 수집한 개인정보를 아래와 같이 제3자에게 제공 및 위탁합니다.</li>
										<li>2. 회사는 아래와 같이 이용자로부터 수집한 개인정보를 제3자에게 제공, 위탁합니다.
											<table class="bbsList typeC">
												<colgroup>
													<col width="15%"><col width=""><col width="15%"><col width="15%">
												</colgroup>
												<thead>
													<tr>			
														<th scope="col">제공목적</th>
														<th scope="col">제공받는자</th>
														<th scope="col">제공정보</th>
														<th scope="col">보유 및 이용기간</th>
													</tr>
												</thead>
												<tbody>
													<tr>
														<td>신용카드 결제</td>
														<td>국민,비씨,롯데,삼성,NH농협,현대,외환,신한 4개 시중은행(신한/SC제일/씨티/하나), 3개 특수은행(농협,기업,국민), 3개 지방은행 (대구,부산,경남), 1개 전업카드사 (우리) (주)코밴, KIS정보통신,NICE정보통신, 브이피㈜, 한국신용카드결제(주), 퍼스트 데이터 코리아,㈜케이에스넷</td>
														<td>결제정보,IP Address</td>
														<td rowspan="13">개인정보는 원칙적으로 개인정보의 수집 및 이용목적이 달성되면 지체 없이 파기합니다 (단, 다른 법령에 특별한 규정이 있을 경우 관련 법령에 따라 보관)</td>
													</tr>
													<tr>
														<td>계좌이체 결제</td>
														<td>경남/광주/국민/기업/농협/대구/부산/산업/새마을금고/ 수협/신한/신협/외환/우리/우체국/전북/제주/하나/씨티/SC제일은행 동양/미래에셋/삼성/신한/한투/한화증권 결제서비스 제공업체 : CJ시스템즈, ㈜올앳, 갤럭시아커뮤니케이션즈㈜, ㈜다우기술</td>
														<td>결제정보,IP Address</td>
													</tr>
													<tr>
														<td>가상계좌입금 결제</td>
														<td>국민/농협/우리/신한/하나/기업/우체국/외환/부산/경남/ 대구/수협/씨티 /삼성증권</td>
														<td>결제정보</td>
													</tr>
													<tr>
														<td>휴대전화 결제</td>
														<td>㈜다날, ㈜인포허브, 갤럭시아커뮤니케이션즈㈜</td>
														<td>결제정보,IP Address</td>
													</tr>
													<tr>
														<td>유선전화 결제</td>
														<td>주식회사 케이티, 갤럭시아커뮤니케이션즈㈜, ㈜소프트가족</td>
														<td>결제정보</td>
													</tr>
													<tr>
														<td>상품권 결제</td>
														<td>한국문화진흥, 한국도서보급</td>
														<td>결제정보,IP Address</td>
													</tr>
													<tr>
														<td>포인트 결제</td>
														<td>SK마케팅앤컴퍼니 주식회사, GS넥스테이션 주식회사</td>
														<td>결제정보,IP Address</td>
													</tr>
													<tr>
														<td>본인확인서비스</td>
														<td>나이스신용평가정보, 한국신용평가정보㈜, 한국신용정보, SKT, KT, (주)코밴, KIS정보통신,NICE정보통신, 브이피㈜, 한국신용카드결제(주), 퍼스트 데이터 코리아,㈜케이에스넷 국민,비씨,롯데,삼성,NH농협,현대,외환,신한 경남/광주/국민/기업/농협/대구/부산/산업/새마을금고/ 수협/신한/신협/외환/우리/우체국/전북/제주/하나/씨티/SC제일</td>
														<td>결제정보</td>
													</tr>
													<tr>
														<td>티머니 결제</td>
														<td>주식회사 티모넷</td>
														<td>결제정보</td>
													</tr>
													<tr>
														<td>현금영수증</td>
														<td>국세청</td>
														<td>결제정보</td>
													</tr>
													<tr>
														<td>페이핀</td>
														<td>㈜SK플래닛</td>
														<td>결제정보</td>
													</tr>
													<tr>
														<td>휴대폰대체인증서비스</td>
														<td>㈜한국모바일인증, ㈜크레디프</td>
														<td>이름, 생년월일, 성별, 휴대폰번호</td>
													</tr>
													<tr>
														<td>실명인증</td>
														<td>나이스신용평가정보, 한국신용평가정보㈜, 한국신용정보</td>
														<td>결제정보</td>
													</tr>
												</tbody>	
											</table>		
										</li>
										<li>3. 회사는 통신과금/전자금융 서비스를 제공함에 있어서 취득한 이용자의 인적사항, 이용자의 계좌, 접근매체 및 통신과금의 내용과 실적에 관한 정보 또는 자료를 이용자의 동의를 얻지 아니하고 제3자에게 제공, 누설하거나 업무상 목적 외에 사용하지 아니합니다. 다만, 업무상 이용자 정보를 제3자에게 제공, 위탁할 경우 본 동의서 및 홈페이지(http://ecredit.uplus.co.kr)를 통해 이용자에게 고지를 합니다.</li>
										<li>4. 회사는 정보통신망 이용촉진 및 정보보호 등에 관한 법률(제7장 통신과금서비스)의 관련 규정에 의거하여 구성된 “유무선전화결제이용자보호협의회”가 이용자 보호를 위해 통신과금서비스 관련 정보를 요청하면 다음 각 호의 경우에는 관련 정보를 제공할 수 있습니다.
											<ol>
												<li>① 휴대폰깡, 대포폰, 복제폰 등 시장 질서를 교란시키는 불법업체 혹은 불법행위자에 의한 민원발생의 경우</li>
												<li>② 지인 사용 등 제3자 결제로 인한 민원발생의 경우</li>
												<li>③ 기타 통신과금서비스를 통한 불법행위가 발생하여 이용자 보호가 필요한 경우</li>
											</ol>
										</li>
										<li>5.	회사는 이용자의 개인정보를 원칙적으로 외부에 제공하지 않습니다 다만 아래의 경우에는 예외로 합니다.
											<ul>
												<li>이용자들이 사전에 동의한 경우 </li>
												<li>법령의 규정에 의거하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의 요구가 있는 경우</li>
											</ul>
										</li><li>6. 회사는 이용자의 동의없이 고객님의 정보를 외부 업체에 위탁하지 않습니다. 하단의 업체는 이용자에게 사전 통지 또는 동의를 얻어 위탁 업무를 대행하고 있습니다. 향후 위탁 대상자와 위탁 업무가 추가될 경우 이용자에게 사전 통지하고 필요한 경우 사전 동의를 받습니다.
											<table class="bbsList typeC">
												<colgroup>
													<col width="20%"><col width=""><col width="">
												</colgroup>
												<thead>
													<tr>			
														<th scope="col">서비스내용</th>
														<th scope="col">위탁업체</th>
														<th scope="col">목적</th>
													</tr>
												</thead>
												<tbody>
													<tr>
														<td>상품 배송정보 제공</td>
														<td>	㈜굿스플로</td>
														<td>배송정보 안내 서비스 제공</td>
													</tr>
													<tr>
														<td>채권추심	</td>
														<td>㈜한국신용정보, ㈜한국신용평가, ㈜미래신용정보</td>
														<td>채권추심 업무</td>
													</tr>
													<tr>
														<td>고객지원</td>
														<td>㈜LB휴넷, ㈜에이텍플러스, ㈜미디어로그</td>
														<td>고객상담 및 청약개통 업무지원 위탁수행 (고객센터 1544-7772)</td>
													</tr>
												</tbody>	
											</table>
										</li>
										<li>6. 제3자에게 제공된 개인정보의 보유, 이용 기간이 만료된 개인정보는 아래와 같은 방법으로 파기합니다.</li>
									</ol>
								
									<h4>통신과금 서비스 이용약관</h4>
									<h5>1.	제1조 (목적)</h5>
									<p>이 약관은 통신과금 서비스를 제공하는 주식회사 LG유플러스(이하 '회사'라 합니다)과 통신과금서비스이용자(이하 ‘이용자’라 합니다) 사이의 통신과금 서비스에 관한 기본적인 사항을 정함으로써 통신과금 서비스의 안정성과 신뢰성을 확보함에 그 목적이 있습니다.</p>
									<h5>2.	제2조 (용어의 정의)</h5>
									<p>이 약관에서 정하는 용어의 정의는 다음과 같습니다.</p>
									<ol>
										<li>
											1. 통신과금 서비스'라 함은 정보통신서비스로서 다음 각 항의 업무를 말합니다. 
											<ol>
												<li>① 타인이 판매, 제공하는 재화 또는 용역(이하 “재화 등”이라 합니다)의 대가를 자신이 제공하는 전기통신역무의 요금과 함께 청구, 징수하는 업무</li>
												<li>② 타인이 판매, 제공하는 재화 등의 대가가 전항의 업무를 제공하는 자의 전기통신역무의 요금과 함께 청구, 징수되도록 거래정보를 전자적으로 송수신하는 업무 또는 그 대가의 정산을 대행하거나 매개하는 업무</li>
											</ol>
										</li>
										<li>2. '이용자'라 함은 이 약관에 동의하고 회사가 제공하는 통신과금 서비스를 이용하는 자를 말합니다.</li>
										<li>3. '접근매체'라 함은 통신과금거래에 있어서 거래지시를 하거나 이용자 및 거래내용의 진실성과 정확성을 확보하기 위하여 사용되는 수단 또는 정보로서 유무선 전화 및 통신사에 등록된 이용자의 유무선 전화 번호, 이용자의 생체정보, 이상의 수단이나 정보를 사용하는 데 필요한 비밀번호 등을 말합니다</li>
										<li>4. '거래지시'라 함은 이용자가 통신과금 서비스계약에 따라 회사에게 통신과금 서비스의 처리를 지시하는 것을 말합니다. </li>
										<li>5. '가맹점'이라 함은 통신과금 서비스를 통하여 이용자에게 재화 또는 용역을 판매, 제공하는 자를 말합니다. </li>
									</ol>
									<h5>3.	제3조 (약관의 명시 및 변경)</h5>
									<ol>
										<li>1. 회사는 이용자가 통신과금 서비스를 이용하기 전에 이 약관을 게시하고 이용자가 이 약관의 중요한 내용을 확인할 수 있도록 합니다. </li>
										<li>2. 회사는 이용자의 요청이 있는 경우 전자문서의 전송방식에 의하여 본 약관의 사본을 이용자에게 교부합니다. </li>
										<li>3. 회사가 약관을 변경하는 때에는 그 시행일 2주 전에 변경되는 약관을 지급결제정보 입력화면 및 회사의 홈페이지에 게시함으로써 이용자에게 공지합니다 </li>
									</ol>
									<h5>4.	제4조 (접근매체의 관리 등)</h5>
									<ol>
										<li>1. 회사는 통신과금 서비스 제공 시 접근매체를 선정하여 이용자의 신원, 권한 및 거래지시의 내용 등을 확인할 수 있습니다. </li>
										<li>2. 이용자는 접근매체를 제3자에게 대여하거나 사용을 위임하거나 양도 또는 담보 목적으로 제공할 수 없습니다. </li>
										<li>3. 이용자는 자신의 접근매체를 제3자에게 누설 또는 노출하거나 방치하여서는 안 되며, 접근매체의 도용이나 위조 또는 변조를 방지하기 위하여 충분한 주의를 기울여야 합니다. </li>
										<li>4. 회사는 이용자로부터 접근매체의 분실이나 도난 등의 통지를 받은 때에는 그 때부터 제3자가 그 접근매체를 사용함으로 인하여 이용자에게 발생한 손해를 배상할 책임이 있습니다. </li>
									</ol>
									<h5>5.	제5조 (모니터링 및 해킹방지 시스템 구축)</h5>
									<ol>
										<li>1. 회사는 서버 및 통신기기의 정상작동여부 확인을 위하여 정보처리시스템 자원 상태의 감시, 경고 및 제어가 가능한 모니터링체계를 갖추어야 합니다. </li>
										<li>
											2. 회사는 해킹 침해 방지를 위하여 다음 각 호의 시스템 및 프로그램을 설치하여야 합니다. 
											<ol>
												<li>① 침입차단시스템 설치 </li>
												<li>② 침입탐지시스템 설치</li>
												<li>③ 그 밖에 필요한 보호장비 또는 암호프로그램 등 정보보호시스템 설치</li>
											</ol>
										</li>
									</ol>
									<h5>6.	제6조 (바이러스 감염 방지)</h5>
									<p>회사는 컴퓨터바이러스 감염을 방지하기 위하여 다음 각 호를 포함한 대책을 수립, 운용하여야 합니다.</p>
									<ol>
										<li>1. 출처, 유통경로 및 제작자가 명확하지 아니한 응용프로그램은 사용을 자제하고 불가피할 경우에는 컴퓨터바이러스 검색프로그램으로 진단 및 치료 후 사용할 것 </li>
										<li>2. 컴퓨터바이러스 검색, 치료 프로그램을 설치하고 최신 버전을 유지할 것 </li>
										<li>3. 컴퓨터바이러스 감염에 대비하여 방어, 탐색 및 복구 절차를 마련할 것 </li>
									</ol>
									<h5>7.	제7조 (이용자의 정보보호)</h5>
									<ol>
										<li>1. 회사는 정보통신망에 중대한 침해사고가 발생하여 회사의 서비스를 이용하는 이용자의 정보시스템 또는 정보통신망 등에 심각한 장애가 발생할 가능성이 있는 아래 각 호의 경우에는 이용자에 대한 보호조치를 전자우편, 공지사항 등의 방법으로 요청할 수 있습니다. 
											<ol>
												<li>① 사용자의 장비가 제3의 사용자에게 이용 당하여 회사의 서비스에 장애를 초래한 경우 </li>
												<li>② 사용자의 장비의 H/W 혹은 S/W의 문제로 회사의 서비스에 장애를 초래하는 경우 </li>
												<li>③ 사용자가 고의 혹은 실수로 회사의 악의적인 접속을 시도하거나 접속을 한 경우</li>
											</ol>
										</li>
										<li>2. 이용자가 취할 보호조치의 내용은 아래 각 호와 같습니다. 
											<ol>
												<li>① 해당 장비의 네트워크로부터 연결케이블 제거, 서비스 포트 차단, 네트워크 주소 차단 등의 즉각적인 분리 </li>
												<li>② 해당 장비에 대한 보안점검 </li>
												<li>③ 관련 원인점검 및 패치, OS재설치, 필터링 등의 사후 보안 조치 실시</li>
											</ol>
										</li>
										<li>3. 회사는 이용자가 전항의 보호조치를 이행하지 아니할 경우 정보통신망으로의 접속을 5일간 제한 할 수 있습니다. </li>
										<li>4. 회사가 이용자의 보호조치 불이행에 대하여 부당한 접속 제한을 한 경우 이용자는 제10조 제1항의 담당자에게 이의제기를 할 수 있으며, 회사는 이의제기를 접수 후 2주 이내로 사실을 확인하고, 이용자에게 서면으로 답변을 발송하여야 합니다. </li>
									</ol>
									<h5>제8조 (불법 거래 차단 시스템 구축)</h5>
									<ol>
										<li>1. 회사는 제3자의 불법적인 결제로부터 이용자를 보호하고, 이로 인한 이용자의 손해를 최소화하기 위해 다음 각 호와 같은 시스템을 구축하여야 합니다. 
											<ol>
												<li>① 비정상 거래 유형 분석 시스템 </li>
												<li>② 복제폰 이용 거래 탐지 시스템 </li>
												<li>③ 기타 불법결제 의심 거래 모니터링 시스템</li> 
											</ol>
										</li>
										<li>2. 회사는 본조 제1항 각 호의 시스템을 통해 불법적인 결제 요청으로 판단될 경우, 결제 요청을 차단할 수 있습니다. </li>
										<li>3. 본조 제1항에 의해 결제 요청이 차단된 경우, 이용자는 제15조 제1항의 담당자에게 연락을 하여 본인 확인 절차를 거친 후 통신과금 서비스를 이용할 수 있습니다. </li>
									</ol>
									<h5>제9조 (유무선전화결제이용자보호협의회)</h5>
									<ol>
										<li>1. 회사는 불법 과금, 복제폰, 휴대폰 깡, 및 불법 마케팅 등으로부터 이용자를 보호하기 위하여 유무선전화결제이용자보호협의회(이하 “전보협”이라 한다)의 구성원으로 참여하여, 이용자 보호 원칙을 선언한 “유무선전화결제이용자보호합의서”를 성실히 이행합니다. </li>
										<li>2. 회사는 전보협의 민원경보시스템 운영을 위해 항시 연락 가능한 담당자 1인을 아래와 같이 지정하여, 신속한 민원처리에 협조합니다. <br>
											담당자 : 정 훈<br>
											연락처(전화번호, 전자우편주소) 02)6719-8814 hunippp@lguplus.co.kr</li>
										<li>3. 회사는 전보협 운영위에서 심사하고, 전보협, 방송통신위원회에서 승인하여 제정한 가이드라인을 준수하며, 가맹점에게 가이드라인의 준수를 권고하고 지속적으로 모니터링 합니다.</li>
									</ol>
									<h5>제10조 (회사의 권리와 의무)</h5>
									<ol>
										<li>1. 회사가 접근매체의 발급주체가 아닌 경우에는 접근매체의 위조나 변조로 발생한 사고로 인하여 이용자에게 발생한 손해에 대하여 배상책임이 없습니다.</li>
										<li>2. 회사가 접근매체의 발급주체이거나 사용, 관리주체인 경우에는 접근매체의 위조나 변조로 발생한 사고로 인하여 이용자에게 발생한 손해에 대하여 배상책임이 있습니다.</li>
										<li>3. 회사는 계약체결 또는 거래지시의 전자적 전송이나 처리과정에서 발생한 사고로 인하여 이용자에게 손해가 발생한 경우에는 그 손해를 배상할 책임이 있습니다. 다만, 본조 제2항 단서에 해당하거나 법인('중소기업기본법' 제2조 제2항에 의한 소기업을 제외한다)인 이용자에게 손해가 발생한 경우로서 회사가 사고를 방지하기 위하여 보안절차를 수립하고 이를 철저히 준수하는 등 합리적으로 요구되는 충분한 주의의무를 다한 경우에는 그러하지 아니합니다.</li>
										<li>4. 회사는 이용자가 통신과금 서비스 이용 시 이용약관이나 안내사항 등을 확인하지 않아 발생한 손해, 또는 이용자가 제4조 제2항에 위반하거나 제3자가 권한 없이 이용자의 접근매체를 이용하여 통신과금서비스를 이용할 수 있음을 알았거나 알 수 있었음에도 불구하고 이용자가 자신의 접근매체를 누설 또는 노출하거나 방치한 손해 등 이용자의 부주의에 기한 손해에 대하여 배상 책임이 없습니다.</li>
										<li>5. 회사와 이용자 사이에 손해배상에 관한 협의가 성립되지 아니하거나 협의를 할 수 없는 경우에는 당사자는 방송통신위원회에 재정을 신청할 수 있습니다.</li>
										<li>6. 회사는 이용자에게 거래 금액 외에 일정금액의 수수료를 건당 부과할 수 있습니다. </li>
										<li>7. 회사는 통신사로부터 통신과금 서비스와 관련된 이용자의 개인정보를 제공받을 수 있으며, 회사는 위 제공받은 정보를 통신과금 서비스 외의 목적으로 사용할 수 없습니다. </li>
										<li>8. 회사는 컴퓨터 등 정보통신설비의 보수점검, 교체 및 고장, 통신의 두절 등의 사유가 발생한 경우에는 통신과금 서비스의 제공을 일시적으로 중단할 수 있습니다. </li>
										<li>9. 회사는 전항의 사유로 통신과금 서비스의 제공이 일시적으로 중단됨으로 인하여 이용자가 입은 손해에 대하여 배상합니다. 단, 회사가 고의 또는 과실이 없음을 입증한 경우에는 그러하지 아니합니다. </li>
										<li>10. 회사는 이용자가 전기통신역무의 요금과 함께 청구된 재화 등의 대가를 통신사가 지정한 기일까지 납입하지 아니한 때에는 그 요금의 100분의 2에 상당하는 가산금을 부과합니다. </li>
										<li>11. 이베이코리아(옥션, G마켓), 쿠팡, 위메프, 티몬, 골프존, 잡코리아 등은 엘지유플러스 전자결제서비스 이용에 따른 판매 대금 정산금 채권에 대하여 엘지유플러스의 당사에 대한 선정산 지급으로 엘지유플러스에 양도되었음을 통지합니다. </li>
									</ol>
									<h5>제11조 (고지사항)</h5>
									<p>회사는 재화 등의 판매, 제공의 대가를 청구할 때 이용자에게 다음 각 호의 사항을 고지하여야 합니다.</p>
									<ol>
										<li>1. 통신과금서비스 이용일시</li>
										<li>2. 통신과금서비스를 통한 구매,이용의 거래 상대방(통신과금서비스를 이용하여 그 대가를 받고 재화 또는 용역을 판매,제공하는 자를 말하며, 이하 “거래 상대방”이라 합니다)의 상호와 연락처</li>
										<li>3. 통신과금서비스를 통한 구매,이용 금액과 그 명세</li>
										<li>4. 이의신청 방법 및 연락처</li>
									</ol>
									<h5>제12조 (거래내용의 확인)</h5>
									<ol>
										<li>1. 회사는 이용자가 구매,이용 내역을 확인할 수 있는 방법을 제공하여야 하며, 이용자가 구매,이용 내역에 관한 서면(전자문서를 포함한다. 이하 같다)을 요청하는 경우에는 그 요청을 받은 날부터 2주 이내에 이를 제공하여야 합니다. </li>
										<li>
											2. 회사는 다음 각 호의 사항에 관한 기록을 해당 거래를 한 날부터 1년간 보존하여야 합니다. 다만, 건당 거래 금액이 1만원을 초과하는 거래인 경우에는 5년간 보존하여야 합니다. 
											<ol>
												<li>① 통신과금서비스를 이용한 거래의 종류 </li>
												<li>② 거래 금액 </li>
												<li>③ 거래 상대방 </li>
												<li>④ 거래 일시 </li>
												<li>⑤ 대금을 청구,징수하는 전기통신역무의 가입자번호 </li>
												<li>⑥ 회사가 통신과금 서비스 제공의 대가로 수취한 수수료에 관한 사항 </li>
												<li>⑦ 해당 거래와 관련한 전기통신역무의 접속에 관한 사항 </li>
												<li>⑧ 거래의 신청 및 조건의 변경에 관한 사항 </li>
												<li>⑨ 거래의 승인에 관한 사항</li>
												<li>⑩ 그 밖에 방송통신위원회가 정하여 고시하는 사항</li>
											</ol>
										</li>
										<li>3. 전항에 따른 거래기록은 서면, 마이크로필름, 디스크, 자기테이프, 그 밖의 전산정보처리조직에 의하여 보존하여야 합니다. 다만, 디스크, 자기테이프, 그 밖의 전산정보처리조직에 의하여 보존하는 경우에는 전자거래기본법 제5조 제1항 각 호의 요건을 모두 갖추어야 합니다.</li>
										<li>4. 이용자가 제1항에서 정한 서면교부를 요청하고자 할 경우 다음의 주소 및 전화번호로 요청할 수 있습니다.
											<ul>
												<li>주소: 서울 중구 남대문로5가 827번지 LG유플러스 전자금융사업팀</li>
												<li>이메일 주소: hunippp@lguplus.co.kr</li>
												<li>전화번호: 1544-7772</li>
											</ul>
										</li>
									</ol>
									<h5>제13조 (정정 요구)</h5>
									<p>이용자는 통신과금서비스가 자신의 의사에 반하여 제공되었음을 안 때에는 회사에게 이에 대한 정정을 요구할 수 있으며(이용자의 고의 또는 중과실이 있는 경우는 제외한다), 회사는 그 정정 요구를 받은 날부터 2주 이내에 처리 결과를 알려 주어야 한다.</p>
									<h5>제14조 (통신과금정보의 제공금지)</h5>
									<ol>
										<li>1. 회사는 통신과금 서비스를 제공함에 있어서 취득한 이용자의 인적사항, 이용자의 계좌, 접근매체 및 통신과금의 내용과 실적에 관한 정보 또는 자료를 이용자의 동의를 얻지 아니하고 제3자에게 제공, 누설하거나 업무상 목적 외에 사용하지 아니합니다. 다만, 업무상 이용자 정보를 제3자에게 제공할 경우 본 약관 및 홈페이지(http://ecredit.uplus.co.kr)을 통해 이용자에게 고지를 합니다. </li>
										<li>
										2. 회사는 정보통신망이용촉진및정보보호등에관한법률 (제7장 통신과금서비스)의 관련규정에 의거하여 구성된 “유무선전화결제이용자보호협의회”가 이용자 보호를 위해 통신과금서비스 관련 정보를 요청하면 다음 각 호의 경우에는 관련 정보를 제공할 수 있습니다. 
										<ol>
											<li>① 휴대폰깡, 대포폰, 복제폰 등 시장 질서를 교란시키는 불법업체 혹은 불법행위자에 의한 민원발생의 경우 </li>
											<li>② 지인 사용 등 제3자 결제로 인한 민원발생의 경우</li>
											<li>③ 기타 통신과금서비스를 통한 불법행위가 발생하여 이용자 보호가 필요한 경우</li>
										</ol>
										</li>
										<li>3. 회사는 통신과금 서비스의 거래 내역 확인 및 서비스 상담 등의 이용자 편의 업무를 위해서 아래와 같이 이용자 정보를 제공하고 있습니다. 개인정보를 제3자에게 제공, 위탁 제공 받는 자 제공하는 항목 목적 
										LB 휴넷 휴대전화 번호, 거래 일시, 거래 금액, 거래 상대방 결제정보,IP Address 거래 내역 확인 및 서비스 상담</li>
									</ol>
									<h5>제15조 (이의신청 및 권리구제)</h5>
									<ol>
										<li>1. 이용자는 다음의 보호책임자 및 담당자에 대하여 이의신청 및 권리구제를 요청할 수 있습니다. <br>
											담당자 : 정 훈<br>
											연락처(전화번호, 전자우편주소) : 02)6719-8814, hunippp@lguplus.co.kr </li>
										<li>2. 이용자는 서면(전자문서를 포함한다), 전화, 모사전송 등을 통하여 회사에게 통신과금서비스와 관련된 이의신청을 할 수 있습니다.</li>
										<li>3. 회사는 제2항에 따른 이의신청을 받은 날부터 2주일 이내에 그 조사 또는 처리 결과를 이용자에게 알려야 합니다. </li>
									</ol>
									<h5>제16조 (회사의 안정성 확보 의무)</h5>
									<p>회사는 통신과금 서비스의 안전성과 신뢰성을 확보할 수 있도록 통신과금 서비스의 종류별로 전자적 전송이나 처리를 위한 인력, 시설, 전자적 장치 등의 정보기술부문 및 통신과금업무에 관하여 방송통신위원회가 정하는 기준을 준수합니다.</p>
									<h5>제17조 (약관외 준칙 및 관할)</h5>
									<ol>
										<li>1. 이 약관에서 정하지 아니한 사항에 대하여는 정보통신망 이용촉진 및 정보보호 등에 관한 법률, 전자금융거래법, 전자상거래 등에서의 소비자 보호에 관한 법률, 통신판매에 관한 법률, 여신전문금융업법 등 소비자보호 관련 법령에서 정한 바에 따릅니다.</li>
										<li>2. 회사와 이용자간에 발생한 분쟁에 관한 관할은 민사소송법에서 정한 바에 따릅니다.</li>
									</ol>

		 						</div>
		 					</div>
			 			</div>
				 		<div class="section">
				 			<h3><input type="checkbox" name="agree2" id="agree2" class="agrees"><label for="agree2">주문내역 동의</label></h3>
				 			<div class="cont"><div class="scr">
								주문할 상품의 상품명, 상품가격, 배송정보를 확인하였습니다. (전자상거래법 제 8조 2항)<br>구매에 동의하시겠습니까?
				 			</div>
				 		</div>
					 </div>
				 </div><!-- 이용동의 -->
		 		<!-- //회원 -->
		 	
			 	<h2 class="typeA">할인 받기</h2>
			 	<table class="couponForm">
			 		<caption>할인 적용 선택 폼</caption>
			 		<colgroup>
			 			<col width="100"><col width=""><col width="200">
			 		</colgroup>
			 		<tr>
			 			<th scope="row">쿠폰</th>
			 			<td>
			 				<input type="hidden" name="mem_couponid" id="mem_couponid" value="" />			
			 				<select name="coupon" id="coupon" style="width:384px;" onchange="applyCoupon()">
			 				</select>
			 			</td>		 			
			 			<td class="al">
<!-- 			 				<a href="javascript:applyCoupon()" class="btnTypeA">적용하기</a> -->
<!-- 			 				<a href="#couponApplyArea" onclick="$('#couponApplyArea').show(); return false;" class="btnTypeA">등록하기</a> -->
			 			</td>
			 		</tr>
			 		<tr id="couponApplyArea" style="display:;">
			 			<th></th>
			 			<td>
			 				<input type="text" name="coupon_serial1" maxlength="4" style="width:17%">
							<input type="text" name="coupon_serial2" maxlength="4" style="width:17%">
							<input type="text" name="coupon_serial3" maxlength="4" style="width:17%">
							<input type="text" name="coupon_serial4" maxlength="4" style="width:17%">
							<p class="infoTxt fontTypeE">* 인쇄된 오프라인 쿠폰은 등록 후 사용 가능합니다.</p> 
			 			</td>
			 			<td class="al vt"><a href="#none" onclick="downloadSerial()" class="btnTypeA">등록</a></td>
			 		</tr>
			 	</table>
			 	
			 	
			 	<h2 class="typeA">결제수단 선택</h2>
			 	<p class="discountInfo"><!-- <a href="">신용카드 별 결제 할인 안내</a> --></p>
				<div class="payWay">
				 	<input type="radio" name="pay_type" id="pay_001" value="001" <%= "001".equals(payType) ? "checked" : "" %>>
					<label for="pay_001" style="color:">신용카드</label>
					

				 	<input type="radio" name="pay_type" id="pay_002" value="002" <%= "002".equals(payType) ? "checked" : "" %>>
					<label for="pay_002" style="color:">계좌이체</label>
					

				 	<input type="radio" name="pay_type" id="pay_004" value="004" <%= "004".equals(payType) ? "checked" : "" %>>
					<label for="pay_004" style="color:">PayNow</label>
					

				 	<input type="radio" name="pay_type" id="pay_006" value="006" <%= "005".equals(payType) ? "checked" : "" %>>
					<label for="pay_006" style="color:red">PAYCO</label>


<%-- <%	
	if("".equals(param.get("userid"))) {
%>
					<!-- 쿠폰사용 -->
					<div class="payType">
						<input type="radio" name="pay_type" id="pay_010" value="010">
						<label for="pay_010" >쿠폰사용</label>
						<input type="text" name="coupon_serial1" maxlength="4">
						<input type="text" name="coupon_serial2" maxlength="4">
						<input type="text" name="coupon_serial3" maxlength="4">
						<input type="text" name="coupon_serial4" maxlength="4">
					</div>
					<!-- //쿠폰사용 -->
<%
	}
%> --%>
				</div><!-- //결제수단 선택 -->
			 	<input type="hidden" name="save_pay_type" value="Y">
		 	</div>
		</div>
		<div class="agreeChk">
			<div class="btnArea">
				<a href="javascript:history.back();">뒤로가기</a>
				<a href="javascript:orderProc()">결제하기</a>
			</div>
		</div>
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