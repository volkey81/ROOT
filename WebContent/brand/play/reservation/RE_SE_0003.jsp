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
<%@ include file="/order/payco/common_include.jsp" %>			
<%
//// 앞에서 선택한 체험내용 불러오기
// 주석1
Enumeration params = request.getParameterNames();
List list = new ArrayList();
while (params.hasMoreElements()){
    String name = (String)params.nextElement();
System.out.println(name + " : " +request.getParameter(name));
if(name.contains("item")){
	list.add(request.getParameter(name)); // exp_pid 받아오는 부분입니다.
}
}

%>
<%
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
String LGD_PRODUCTINFO      = "입장권";              //상품명
String LGD_BUYEREMAIL       = "";               //구매자 이메일
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


// Smilepay의 INBOUND 전문 URL SETTING
String msgName = "/smilepay/requestDealApprove.htm";
String webPath = "https://pg.cnspay.co.kr"; //PG사의 인증 서버 주소

String smilepayReturnUrl2	= (SystemChecker.isReal() ? "https" : "http") + "://" + request.getServerName() + "/order/smilepay/returnurl2.jsp";
System.out.println("-------------- smilepayReturnUrl2 : " + smilepayReturnUrl2);

String kakaoReturn = request.getScheme() + "://" + request.getServerName() + "/order/kakaopay/return.jsp";
String naverReturn = request.getScheme() + "://" + request.getServerName() + "/order/naverpay/return.jsp";
%>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(6));
	request.setAttribute("Depth_4", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("예약하기"));
%>
			
<%
Param param = new Param(request);
FrontSession fs = FrontSession.getInstance(request, response);

OrderService order = (new OrderService()).toProxyInstance();
CouponService coupon = (new CouponService()).toProxyInstance();
ImMemberService immem = (new ImMemberService()).toProxyInstance();
CodeService code = (new CodeService()).toProxyInstance();
MemberService member = (new MemberService()).toProxyInstance();

/* 원본 */
//	int point = immem.getMemberPoint(fs.getUserNo());
//	String orderid = order.getNewId();
//	member.modifyOrderid(fs.getUserId(), orderid);
//	LGD_OID = orderid;
//	Param memInfo = member.getInfo(fs.getUserId());

/* 로컬 테스트 */
int point = 0;
String orderid = order.getNewId();
member.modifyOrderid("donna8715", "2016062718563037152");
LGD_OID = orderid;
Param memInfo = member.getInfo("donna8715");
/* 로컬 테스트 End */

String payType = memInfo.get("pay_type", "001");
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

<%-- <link rel="stylesheet" href="/css/layout.css?t=<%=System.currentTimeMillis()%>">
<% if(Depth_1 == 1){ //브랜드 %>
<link rel="stylesheet" href="/css/brand-content.css?t=<%=System.currentTimeMillis()%>">
<link rel="stylesheet" href="/css/slick.css?t=<%=System.currentTimeMillis()%>">
<% } else if(Depth_1 == 5) { // 파머스 빌리지 %>
<link rel="stylesheet" href="/css/hotel_content.css?t=<%=System.currentTimeMillis()%>">
<link rel="stylesheet" href="/css/slick.css?t=<%=System.currentTimeMillis()%>">
<link rel="stylesheet" href="/css/animate.css">
<% } else { // 쇼핑 %>
<link rel="stylesheet" href="/css/common.css?t=<%=System.currentTimeMillis()%>">
<link rel="stylesheet" href="/css/content.css?t=<%=System.currentTimeMillis()%>">
<% } %> --%>
<link rel="stylesheet" href="/css/redmond/jquery-ui-1.8.21.custom.css" type="text/css" media="all" /> 
<link rel="stylesheet" href="/css/swiper.css?t=<%=System.currentTimeMillis()%>" type="text/css" media="all" /> 
<script src="/js/jquery-1.10.2.min.js"></script>
<!-- <script src="/js/jquery-1.8.2.min.js"></script> -->
<script src="/js/jquery.easing.1.3.js"></script>
<script src="/js/jquery.cycle.all.min.js"></script>
<script src="/js/jquery.mousewheel.min.js"></script>
<!-- <script src="/js/jquery-ui-1.8.23.custom.min.js"></script> -->
<script src="/js/jquery-efuSlider.js"></script>
<script src="/js/jquery-ui.js?t=<%=System.currentTimeMillis()%>"></script>
<script src="/js/common.js?t=<%=System.currentTimeMillis()%>"></script>
<script src="/js/efusioni.js?t=<%=System.currentTimeMillis()%>"></script>
<script src="/js/jquery-ui.min.js"></script>
<script src="/mobile/js/swiper.min.js"></script>
<script src="/js/slick.js"></script>
<script src="/js/bluebird.min.js"></script>
<script src="/js/imagesloaded.pkgd.js"></script>
        
        <link rel="stylesheet" href="http://code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" type="text/css" />
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
        <script src="http://code.jquery.com/ui/1.8.18/jquery-ui.min.js"></script>
        
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
        <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
        
<!-- payco -->
<script type="text/javascript" src="https://static-bill.nhnent.com/payco/checkout/js/payco.js" charset="UTF-8"></script>
<!-- // payco -->

<!-- Smilepay css, javascript 시작 -->
<!-- OpenSource Library -->
<link rel="stylesheet" href="<%=webPath%>/dlp/css/pc/cnspay.css" type="text/css" />

<!-- JQuery에 대한 부분은 site마다 버전이 다를수 있음 -->
<script src="<%=webPath %>/js/dlp/lib/jquery/jquery-1.11.1.min.js" charset="urf-8"></script>
<!-- Smilepay css, javascript  -->

<script language="javascript" src="<%= request.getScheme() %>://xpay.uplus.co.kr/xpay/js/xpay_crossplatform.js" type="text/javascript"></script>

<!-- 네이버페이 -->
<script src="https://nsp.pay.naver.com/sdk/js/naverpay.min.js"></script>

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
			document.getElementById("orderForm").action = "<%= Env.getSSLPath() %>/brand/play/reservation/orderProc2.jsp";
			document.getElementById("orderForm").submit();
	} else {
		alert("LGD_RESPCODE (결과코드) : " + fDoc.document.getElementById('LGD_RESPCODE').value + "\n" + "LGD_RESPMSG (결과메시지): " + fDoc.document.getElementById('LGD_RESPMSG').value);
		closeIframe();
	}
}

</script>

<script src="<%= webPath %>/dlp/scripts/smilepay.js" charset="UTF-8"></script>
<script>
	 //Smilepay 스크립트 블럭 시작
		//인증 시 발급된 txnid를 받아옵니다.
	    function getTxnId(){
            // form에 iframe 주소 세팅
            document.orderForm.target = "txnIdGetterFrame";
            document.orderForm.acceptCharset = "utf-8";
            if (document.orderForm.canHaveHTML) { // detect IE
                document.charset = orderForm.acceptCharset;
            }
            document.orderForm.action = "/order/smilepay/getTxnId.jsp";
            // post로 iframe 페이지 호출
	        document.orderForm.submit();
	    }

		//인증 후 SmilePay 결제창을 호출
		function smilepay(){
// 			if(document.getElementById("smilepay").checked){
				// 결과코드가 00(정상처리되었습니다.)
				if(document.orderForm.resultCode.value == "00"){
					//스마일페이 결제창을 호출하는 부분
					smilepay_L.callPopup(document.orderForm.txnId.value, smilepay_callback);
				}else{
					alert("[RESULT_CODE] : " + document.orderForm.resultCode.value + "\n[RESULT_MSG] : " + document.orderForm.resultMsg.value);
				}
// 			}
		}

		
		//smilepay 결제버튼 완료 후 호출되는 콜백.
		var smilepay_callback = function (message){
			//결제창 닫기
			smilepay_L.destroy();

			if(validResult(message)){
				var obj = JSON.parse(message);
				
				document.getElementsByName('SPU')[0].value = obj.SPU;
				document.getElementsByName('SPU_SIGN_TOKEN')[0].value = obj.SPU_SIGN_TOKEN;
				document.getElementsByName('etc1')[0].value = obj.ETC1;
				document.getElementsByName('etc2')[0].value = obj.ETC2;
				document.getElementsByName('etc3')[0].value = obj.ETC3;

				document.orderForm.target = "";
				document.orderForm.action = "<%= Env.getSSLPath() %>/brand/play/reservation/orderProc2.jsp";
				document.orderForm.acceptCharset = "utf-8";
				
				if(orderForm.canHaveHTML){ // detect IE
					document.charset = orderForm.acceptCharset;
				}
				document.orderForm.submit();
			}else{
				alert("결제가 취소되었습니다.");
			}
		}
		
		//message에 대한 유효성 검증
		function validResult(message){
			if(message == null || message == ""){
				return;
			}else{
				var data = JSON.parse(message);
				if(data == null){
					return;
				}else{
					//0001은 CNS 내부 처리 실패, 0002는 고객이 스마일페이 결제창에서 닫기 버튼을 누를 경우 
					if(data.resultCode == '0001' || data.resultCode == '0002'){
						return;
					}else{
						if(data.SPU != null && data.SPU_SIGN_TOKEN != null){
							return true;
						}else{
							return;
						}
					}
				}
			}
		}
</script>

<script>
	var paycoOrderUrl = "";
	
	//주문예약
	function callPaycoUrl(){
//		var Params = "customerOrderNumber=<%= orderid %>";
		var Params = $("#paycoReserveForm").serialize();
		
	    // localhost 로 테스트 시 크로스 도메인 문제로 발생하는 오류 
	    $.support.cors = true;
	
		$.ajax({
			type: "POST",
			url: "/order/payco/payco_reserve.jsp",
			data: Params,		// JSON 으로 보낼때는 JSON.stringify(customerOrderNumber)
			contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			dataType:"json",
			success:function(data){
				if(data.code == '0') {
// 					alert("code : " + data.code + "\n" + "message : " + data.message);
					paycoOrderUrl = data.result.orderSheetUrl;
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
		
	}
	
	// 결제하기
	function payco_order_pop(){
		
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
        var totAmt = 0;
    	var couponAmt = 0;
    	var giftcardAmt = 0;
    	var pointAmt = 0;
    	var payAmt = 0;
    	var totQty = 0;
    	var v;
    	
    	
    	$(function(){
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
        
        $(function() {
        	// re_se_0002.jsp 에서 보내온 exp_pid 가  list 이다.. 
        	var param = <%= list %>
        	
        	getSelProductList(param.join(","));
        	
        	 cal();
        	
        });
        
        function getSelProductList(param){
        	$.ajax({
    			method : "POST",
    			url : "RE_SE_expList7.jsp",
    			data : { exp_pid : param },
    			dataType : "html"
    		})
    		.done(function(html) {        			
    				$("#program_wrap").empty().append($.trim(html));
    		});
        }
        
        // 티켓 인원 조정
        function setQty(dir, id) {
    		var obj = $("#" + id );
    		if(dir == 'up') {
    			obj.val(parseInt(obj.val()) + 1);
    		} else {
    			if(obj.val() != 0) {
    				obj.val(parseInt(obj.val()) - 1);
    			}
    		}
    		cal();
    	
    	}
        
        // // 총금액 계산.
        function cal(){        	
		    var totalAmt = 0;
		    // 고유한 exp_pid 값을 저장할 배열
		    var uniquePids = [];
		
		    // 모든 exp_pid 값을 순회하며 고유한 값만 추출
		    $("input[name='exp_pid']").each(function() {
		        var pidValue = $(this).val();
		        if ($.inArray(pidValue, uniquePids) === -1) {
		            uniquePids.push(pidValue);
		        }
		    });
		
		    // 고유한 exp_pid 값에 대해서만 계산 수행
		    $.each(uniquePids, function(index, _pid) {
		    	var _ticket = "";
		        $("input[name='ticket_type_" + _pid + "']").each(function() {
		        	if(_ticket == ""){
						_ticket = $(this).val();
						
			            var _price = parseInt($("#price_" + _pid + "_" + _ticket).val(), 10) || 0;
			    		
			            var _qtyA = parseInt($("#qtyA_" + _pid + "_" + _ticket).val(), 10) || 0;
			            var _qtyS = parseInt($("#qtyS_" + _pid + "_" + _ticket).val(), 10) || 0;
			            var _qtyB = parseInt($("#qtyB_" + _pid + "_" + _ticket).val(), 10) || 0;
			
			            totalAmt += _price * (_qtyA + _qtyS + _qtyB);	//최종결제 금액
			            totQty +=(_qtyA + _qtyS + _qtyB);				//validation 체크에 사용할 수량 증가
		        	}
		        });
		        _ticket = "";
		        totAmt = totalAmt;										//valication 체크에 사용할 최종 금액
		    });

        	$("#tot_amt").val(totalAmt);
    		$("#tot_amt_txt").html(totalAmt.formatMoney());
    		$("#pay_amt_txt").html(totalAmt.formatMoney());
        	$("#tot_amt_nl_txt").html(totalAmt.formatMoney());
        
        	
        }
        
        // 회원일 경우.
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
    					couponAmt = parseInt(arr[2]) >= parseInt(arr[3]) ? parseInt(arr[3]) : parseInt(arr[2]);
    				} else {	// 정률
    					couponAmt = (parseInt(arr[2]) * totAmt / 100 >= parseInt(arr[3])) ? parseInt(arr[3]) : parseInt(arr[2]) * totAmt / 100;
    				}
    				
    				if(couponAmt > totAmt) {
    					couponAmt = totAmt;
    				}

    				$("#mem_couponid").val(arr[0]);
    				$("#coupon_amt").val(couponAmt);
    				setAmt();
    			}
    		} 
    	}
        
    	function resetCoupon() {
    		couponAmt = 0;
    		$("#mem_couponid").val("");
    		$("#coupon_amt").val("");
    		setAmt();
    	}
    	// 회원일 경우 
    	function applyGiftcard(cardid, amt, receipt, cardnum) {
    		console.log("appplygiftcard : " + cardid + ";" + amt);
    		giftcardAmt = parseInt(amt.replace(/,/g, ""));
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
    			if(totAmt - couponAmt > useablePoint) {
    				var appAmt = parseInt(useablePoint / 10) * 10;
    			} else {
    				var appAmt = parseInt((totAmt - couponAmt) / 10) * 10;
    			}
    			
    			$("#point_amt").val(appAmt);
    			applyPoint();
    		} else {
    			resetPoint();
    		}
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

    		$("#point_amt").val(pointAmt.formatMoney());
    		setAmt();
    	}

    	function resetPoint() {
    		pointAmt = 0;
    		$("#point_all").prop("checked", false);
    		$("#point_amt").val("");
    		setAmt();
    	}
    	
    	function setAmt() {
    		payAmt = totAmt - couponAmt - pointAmt - giftcardAmt;
    		$("#coupon_amt_txt").html("-" + couponAmt.formatMoney());
    		$("#giftcard_amt_txt").html("-" + giftcardAmt.formatMoney());
    		$("#point_amt_txt").html("-" + pointAmt.formatMoney());
    		$("#pay_amt_txt").html(payAmt.formatMoney());
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
    	
// 결제하기 
    	function orderProc() {
//     		popupOpen('terms');
    		if(payAmt < 0) {
    			alert("결제금액이 0원 미만입니다.");
    			return;
    		}

    		if(v.validate()) {
    			if(totAmt == 0) {
    				alert("입장권을 선택하세요.");
    				return;
    			}

    			if(totQty == 0) {
    				alert("입장권을 선택하세요.");
    				return;
    			}
<%
if(fs.isLogin()){ //회원여부 확인
%> 
    			// 포인트 체크
    			var point = parseInt($("#point_amt").val().replace(/,/g, ""));
    			if($("#point_amt").val() != "" && point % 10 != 0) {
    				alert("Maeil Do 포인트는 10P 단위로 사용 가능합니다.");
    				return;
    			}
 <%
}
 %>
    			if($("input[name=pay_type]:checked").length == 0) {
    				alert("결제수단을 선택하세요.");
    				return;
    			}

    			payAmt = totAmt - couponAmt - pointAmt - giftcardAmt;
    			$("#LGD_BUYER").val($("#name").val());
    			$("#LGD_BUYEREMAIL").val($("#email1").val() + "@" + $("#email2").val());
    			$("#LGD_BUYERPHONE").val($("#mobile1").val() + $("#mobile2").val() + $("#mobile3").val());
    			$("#orderForm input[name=BuyerName]").val($("#name").val());
    			$("#orderForm input[name=BuyerEmail]").val($("#email1").val() + "@" + $("#email2").val());
    			$("#orderForm input[name=LGD_AMOUNT]").val(payAmt);
    			$("#orderForm input[name=Amt]").val(payAmt);
    			$("#paycoReserveForm input[name=totalPaymentAmt]").val(payAmt);

    			var _taxationAmt = payAmt;
    			var _goodsVat = parseInt(_taxationAmt / 11);
    			var _supplyAmt = payAmt - _goodsVat;
    				
    			$("#orderForm input[name=SupplyAmt]").val(_supplyAmt);
    			$("#orderForm input[name=GoodsVat]").val(_goodsVat);
    			$("#orderForm input[name=ServiceAmt]").val(0);
    			$("#orderForm input[name=TaxationAmt]").val(_taxationAmt);
    <%
    	boolean nopg = true;	//로컬 테스트 시 true로 사용
//     	boolean nopg = false;	//상용에 올릴때는 false로 설정
    	if(nopg && SystemChecker.isLocal()) {
    %>
    			$("#orderForm").submit(); // 로컬테스트
    			return;
    <%
    	}
    %>
//     			console.log("paytype : " + $("input[name=pay_type]:checked").val());
    			console.log($("#reserve_date").val().replace(/\./g, ''));
    			if(payAmt == 0) {	// 0원 결제
    				$("#orderForm").submit();
    			} else if($("input[name=pay_type]:checked").val() == "009") {	// NaverPay
    				if(payAmt < 100) {
    					alert("결제 최소금액은 100원입니다.");
    				} else {
    					var nPay = Naver.Pay.create({
    					    "mode" : "<%= SystemChecker.isReal() ? "production" : "development" %>", // development or production
    					    "openType" : "popup" ,	//layer, page, popup 
    					    "clientId": "<%= Config.get("npay.noshop.clientid") %>", // clientId
    					    "onAuthorize" : function(oData) {
    					    	console.log('onNaverPayAuthorize', oData);
    					    	
    					        if(oData.resultCode === "Success") {
    					        	$("#paymentId").val(oData.paymentId);
    					        	$("#orderForm").submit();
    					        } else {
    					        	if(oData.resultMessage === "userCancel") {
    					        		alert("결제를 취소하셨습니다.\n주문 내용 확인 후 다시 결제해주세요.");
    					        	} else if(oData.resultMessage === "OwnerAuthFail") {
    					        		alert("타인 명의 카드는 결제가 불가능합니다.\n회원 본인 명의의 카드로 결제해주세요.");
    					        	} else if(oData.resultMessage === "paymentTimeExpire") {
    					        		alert("결제 가능한 시간이 지났습니다.\n주문 내용 확인 후 다시 결제해주세요.");
    					        	}
    					        }
    					    }
    					});
    	
    					nPay.open({
    			            "merchantPayKey": "<%= orderid %>",
    			            "productName": $("#LGD_PRODUCTINFO").val(),
    			            "productCount": totQty,
    			            "totalPayAmount": payAmt,
    			            "taxScopeAmount": payAmt,
    			            "taxExScopeAmount": 0,
    			            "returnUrl": "<%= naverReturn %>",
    			            "useCfmYmdt": $("#reserve_date").val().replace(/\./g, ''),
    			            "productItems": getProductJson()
    			        });
    				}
    			} else if($("input[name=pay_type]:checked").val() == "008") {	// Smilepay
    				$("#hashSmilepayForm input[name=amt]").val(payAmt);
    				ajaxSubmit("#hashSmilepayForm", function(json) {
    					if(json.result) {
    						$("#orderForm input[name=EncryptData]").val(json.hash);
    						getTxnId();
    					} else {
    						alert("결제 진행중 오류가 발생했습니다.");
    					}
    				});
    			} else if($("input[name=pay_type]:checked").val() == "006") {	// Payco
    				callPaycoUrl();
    			} else if($("input[name=pay_type]:checked").val() == "007") {	// 카카오페이2
    				$("#kakaopayReadyForm input[name=total_amount]").val(payAmt);
    				ajaxSubmit("#kakaopayReadyForm", function(json) {
    					if(json.response_code == '200') {
    						$("#tid").val(json.tid);
    						//console.log(json.next_redirect_pc_url);
    						outUrlShowPopupLayer(json.next_redirect_pc_url, '426', '510');
//     						window.open(json.next_redirect_pc_url, "KAKAOPAYPOP", "width=426,height=510");
    					} else {
    						alert(json.msg); 
    					}
    				});
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
        <div class="header_g">
            <div class="header_wrap">
                <a href="/brand/index.jsp" class="gnb_logo"><span class="g_alt">상하농원</span></a>
                <!-- 24.03.05 add button -->
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
<!-- 24.03.11 add START -->
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
                                <label onClick="checkAll('partyResAll','partyResCheck')" for="partyResAgree"><span class="fs18 fwBold">전체 동의하기</span></label>
                            </div>
                        </div>
                        <div class="mt30">
                            <div class="check_g">
                                <input type="checkbox" name="partyResCheck" id="partyRes1">
                                <label for="partyRes1"><span>취소/환불 규정에 대한 동의</span></label>
                            </div>
                            <div class="textarea_g readOnly">
                                <textarea name="" id="" redonly="redonly">- 이용 3일전까지 취소 수수료 없음
- 이용 3~1일전 총 결제금액의 50% 차감
- 이용당일 총 결제금액의 100% 차감
- 체험 취소 후 환불까지 최대 5일(영업일 기준) 소요 됩니다.</textarea>
                            </div>
                        </div>
                        <div class="mt30">
                            <div class="check_g">
                                <input type="checkbox" name="partyResCheck" id="partyRes2">
                                <label for="partyRes2"><span>결제대행서비스 표준이용약관</span></label>
                            </div>
                            <div class="textarea_g readOnly">
                                <textarea name="" id="" redonly="redonly">고유식별번호 수집 및 이용 동의
1. 주식회사 LG유플러스(이하 “회사”라 합니다)은 개인정보보호법에 의해 통신과금서비스 이용자(이하 “이용자”라 합니다)로 부터 아래와 같이 고유식별번호를 수집 및이용합니다.</textarea>
                            </div>
                        </div>
                        <div class="mt30">
                            <div class="check_g">
                                <input type="checkbox" name="partyResCheck" id="partyRes2">
                                <label for="partyRes2"><span>개인정보 수집 및 이용에 대한 동의</span></label>
                            </div>
                            <div class="textarea_g readOnly">
                                <textarea name="" id="" redonly="redonly">본인은 상하농원(유) (이하’회사’ 라 합니다) 가 제공하는 호텔 예약서비스(이하’서비스’라 합니다)를 이용하기 위해, 다음과 같이 ‘회사’가 본인의 개인정보를 수집/이용하고 개인정보의 취급을 위탁하는 것에</textarea>
                            </div>
                        </div>
                        <div class="mt30">
                            <div class="check_g">
                                <input type="checkbox" name="partyResCheck" id="partyRes2">
                                <label for="partyRes2"><span>주문내역 동의</span></label>
                            </div>
                            <div class="textarea_g readOnly">
                                <textarea name="" id="" redonly="redonly">주문할 입장/체험 상품의 상품명, 사용일자 및 시간, 상품가격을 확인했습니다.
(전자상거래법 제 8조 2항) 구매에 동의하시겠습니까?
체험 시작 이후에는 입장이 제한됩니다.</textarea>
                            </div>
                        </div>
                        <div class="btn_area mt40">
                            <button class="btn_submit">결제하기</button>
                        </div>
                    </div>
                </div>
            </div>
            <!-- 24.03.11 add END -->
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
                <form name="orderForm" id="orderForm" method="post" action="<%= Env.getSSLPath() %>/brand/play/reservation/orderProc2.jsp">
	                <input type="hidden" name="orderid" value="<%= orderid %>" />
					<input type="hidden" name="reserve_date" id="reserve_date" />
<%
if(fs.isLogin()){
%>                
                    <!-- 회원 예약자 정보 START -->
                    <section class="page_section">
                        <div class="section_title on">
                            예약자 정보
                        </div>
                        <div class="section_content">
                            <div class="conLine">
                                <p class="conLine_title required"><span>*</span>이름</p>
                                <em class="conLine_content"><%= fs.getUserNm() %></em>
                                <input type="hidden" name="name" id="name" value="<%= fs.getUserNm() %>"/>
                            </div>
                            <div class="conLine">
                                <p class="conLine_title required"><span>*</span>핸드폰 번호</p>
                                <select name="mobile1" id="mobile1" title="휴대전화 첫자리" class="select_g select_small tel_input">
                                    <option value="010">010</option>
                                </select>                               
                             <input type="text" name="mobile2" id="mobile2" value="" title="휴대전화 가운데자리" class="input_g input_small tel_input ml10"  onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">&nbsp;-
							<input type="text" name="mobile3" id="mobile3" value="" title="휴대전화 뒷자리" class="input_g input_small tel_input ml10"  onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">
                            <button class="btn_g btn_gray ml10">수정</button>
                            </div>
                            <div class="conLine">
                                <p class="conLine_title required"><span>*</span>이메일주소</p>
                               <input type="text" placeholder="이메일 주소" name="email1" id="email1" value="" title="이메일 앞자리"  class="input_g input_medium email_input email_id mr10">
                                <span class="conLine_content email_at">@</span>
                                <input type="text" name="email2" id="email2" value="" title="이메일 뒷자리" class="input_g input_medium email_domain ml10">
                                <select name="email3" id="email3" onchange="changeEmail3(this.value)" title="주문자 이메일 뒷자리 선택" class="select_g select_medium email_domainSel ml10">
                                    <option value="">직접입력</option>
<%
	for(String domain : SanghafarmUtils.EMAILS) {
%>									
								<option value="<%= domain %>"><%= domain %></option>
<%
	}
%>
                                </select>
                            </div>
                        </div>
                    </section>
                    <!-- 회원 예약자 정보 END -->
<%
}else{
%>
                    <!-- 비회원 예약자 정보 START -->
                    <section class="page_section">
                        <div class="section_title on">
                            예약자 정보
                        </div>
                        <div class="section_content">
                            <div class="conLine">
                                <p class="conLine_title required"><span>*</span>이름</p>
                                <input type="text" name="name" id="name" class="input_g input_medium">
                            </div>
                            <div class="conLine">
                                <p class="conLine_title required"><span>*</span>핸드폰 번호</p>
                                <select name="mobile1" id="mobile1" title="휴대전화 첫자리" class="select_g select_small tel_input">
                                    <option value="010">010</option>
                                </select>
                                 <input type="text" name="mobile2" id="mobile2" value="" title="휴대전화 가운데자리" class="input_g input_small tel_input ml10"  onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">&nbsp;-
							<input type="text" name="mobile3" id="mobile3" value="" title="휴대전화 뒷자리" class="input_g input_small tel_input ml10"  onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">
                                <button class="btn_g btn_gray ml10">수정</button>
                            </div>
                            <div class="conLine">
                                <p class="conLine_title required"><span>*</span>이메일주소</p>
                                <input type="text" placeholder="이메일 주소" name="email1" id="email1" value="" title="이메일 앞자리"  class="input_g input_medium email_input email_id mr10">
                                <span class="conLine_content email_at">@</span>
                                <input type="text" name="email2" id="email2" value="" title="이메일 뒷자리" class="input_g input_medium email_domain ml10">
                                <select name="email3" id="email3" onchange="changeEmail3(this.value)" title="주문자 이메일 뒷자리 선택" class="select_g select_medium email_domainSel ml10">
                                    <option value="">직접입력</option>
<%
	for(String domain : SanghafarmUtils.EMAILS) {
%>									
								<option value="<%= domain %>"><%= domain %></option>
<%
	}
%>
                                </select>
                            </div>
                        </div>
                    </section>
                    <!-- 비회원 예약자 정보 END -->
<%
}
%>

                    <section class="page_section">
                        <div class="section_title on">
                            프로그램 정보
                        </div>
                        <div class="section_content">
                            <div class="conLine">
                                <p class="conLine_title">예약일</p>
                                <em class="conLine_content fcGreen fwBold"><%= param.get("res_date") %></em>
                            </div>
                            <ul class="program_wrap" id="program_wrap">
                                <!-- RE_SE_expList7 -->
                            </ul>
                        </div>
                    </section>
<%
if(fs.isLogin()){
%>   
                    <!-- 회원 결제 정보 START -->
                    <section class="page_section">
                        <div class="section_title on">
                            결제정보
                        </div>
                        <div class="section_content">
                            <div class="conLine">
                                <p class="conLine_title">결제금액</p>
                                <span class="conLine_content"><em id="tot_amt_txt">0</em> 원</span>
                            </div>
                            <div class="conLine">
                                <p class="conLine_title">쿠폰할인</p>
                               <select name="coupon" id="coupon" title="쿠폰선택" onchange="applyCoupon()" class="select_g select_medium">
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
                            </div>
                            <div class="conLine">
                                <p class="conLine_title">기프트 카드</p>
                                <input type="text" name="giftcard_amt" id="giftcard_amt" value="0" title="기프트 카드" readonly class="input_g input_medium">
                                <input type="hidden" name="giftcard_id" id="giftcard_id">
                                <button type="button" onclick="javascript:showGift();" class="btn_g btn_gray ml10 w130">확인</button>
                                <p class="price"><span class="fontTypeF" id="giftcard_amt_txt">-0</span>원</p>
                            </div>
                            <div class="conLine">
                                <p class="conLine_title">Maeil Do 포인트</p>
                                <input type="text" class="input_g input_medium">
                                <button class="btn_g btn_gray ml10 w130">확인</button>
                                <div class="check_g mt10">
                                    <input type="checkbox" name="point_all" id="point_all" onclick="pointAll()" <%= point < 100 ? "disabled" : "" %>><label for="point_all">모두사용</label><span>모두사용 (보유 포인트 : <em class="fcGreen"><%= Utils.formatMoney(point) %></em> P</span>
                                    <input type="hidden" name="point_amt" id="point_amt" />
                                </div>
                            </div>
                            <p class="divLine mt30 mb30"></p>
                            <div class="conLine">
                                <p class="conLine_title fs18">총 결제금액</p>
                                <span class="conLine_content fwBold fs18"><em class="fcGreen" id="pay_amt_txt">-0</em> 원</span>
                            </div>
                        </div>
                    </section>
                    <!-- 회원 결제 정보 END -->
<%
}else{
%>                    
                    
                    <!-- 비회원 결제 정보 START -->
                    <section class="page_section">
                        <div class="section_title on">
                            결제정보
                        </div>
                        <div class="section_content">
                            <div class="conLine">
                                <p class="conLine_title fs18">총 결제금액</p>
                                <span class="conLine_content fwBold fs18"><em class="fcGreen"  id=tot_amt_nl_txt>-0</em> 원</span>
                            </div>
                            <div class="textbox_g textbox_resJoin">
                                회원가입을 하면 쿠폰할인, 키프트카드, Maell Do 포인트 등 다양한 할인혜택을 받을 수 있습니다.
                                <button class="btn_join">단체예약 바로가기</button>
                            </div>
                        </div>
                    </section>
                    <!-- 비회원 결제 정보 END -->
<%
}
%>
                    <!-- 24.02.29 ADD section : 회원 이용 동의 START-->
                    <section class="page_section">
                        <div class="section_title on">
                            이용 동의
                        </div>
                        <div class="section_content">
                            <div class="check_g">
                                <input type="checkbox" id="memberAgree" name="">
                                <label for="memberAgree"><span>전체 동의하기</span></label>
                            </div>
                        </div>
                    </section>
                    <!-- 24.02.29 ADD section : 회원 이용 동의 END-->
                    
                    <section class="page_section">
                        <div class="section_title on">
                            결제수단 선택
                        </div>
                        <div class="section_content">
                            <div class="radio_content">
                                <div class="radio_g radio_check">
                                    <input type="radio" name="payGroup" id="pay1">
                                    <label for="pay1"><img src="${pageContext.request.contextPath}/image/icn_maeilpay.png" alt=""></label>
                                </div>
                                <div class="maeilpay_wrap">
                                    <div class="maeilpay_reg pay_kb"></div>
                                    <button class="maeilpay_new">
                                        <span>카드추가</span>
                                    </button>
                                </div>
                            </div>
                            <p class="divLine mt30 mb30"></p>
                            <div class="radio_content">
                                <div class="radio_g radio_check">
                                    <input type="radio" name="payGroup" id="pay2">
                                    <label for="pay2"><span>다른 결제 수단</span></label>
                                </div>
                                <ul class="payType_wrap">
                                    <li>
                                        <div class="payType_item">
                                            <input type="radio" name="pay_type" id="pay_001" value="001" <%= "001".equals(payType) ? "checked" : "" %>>
                                            <label for="pay_001"><span>신용카드</span></label>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="payType_item">
                                            <input type="radio" name="pay_type" id="pay_002" value="002" <%= "002".equals(payType) ? "checked" : "" %>>
                                            <label for="pay_002"><span>계좌이체</span></label>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="payType_item">
                                            <input type="radio" name="pay_type" id="pay_009" value="009" <%= "009".equals(payType) ? "checked" : "" %>>
                                            <label for="pay_009"><span>네이버페이</span></label>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="payType_item">
                                            <input type="radio" name="pay_type" id="pay_007" value="007" <%= "007".equals(payType) ? "checked" : "" %>>
                                            <label for="pay_007"><span>카카오페이</span></label>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="payType_item">
                                            <input type="radio" name="pay_type" id="pay_006" value="006" <%= "006".equals(payType) ? "checked" : "" %>>
                                            <label for="pay_006"><span>페이코</span></label>
                                        </div>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </section>
                    <div class="btn_area mo_btn2 mt100">
                        <button class="btn_line w300">이전으로</button>
                        <!-- popupOpen('terms') | 이용약관 팝업 함수, 넣어야 함 | 03.11 | hjm -->
<!--                         <a class="btn_submit ml30" onclick="popupOpen('terms'); javascript:orderProc()">결제하기</a> -->
                        <a class="btn_submit inB ml30" onclick="javascript:orderProc()">결제하기</a>
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
			<input type="hidden" name="LGD_BUYERPHONE"              id="LGD_BUYERPHONE"               value="">
			<input type="hidden" name="LGD_CASHCARDNUM"             id="LGD_CASHCARDNUM"              value="">
			<input type="hidden" name="LGD_CASHRECEIPTUSE"          id="LGD_CASHRECEIPTUSE"           value="">
<%
	/*
	 *************************************************
	 * Smilepay - 시작
	 *************************************************
	 */
	////////위변조 처리/////////
	//전문생성일시
	String EdiDate = KakaopayUtil.getyyyyMMddHHmmss();
	/*
	 *************************************************
	 * Smilepay - 끝
	 *************************************************
	 */
%>
			<!-- Smilepay Field Start -->
			<!-- input -->
			<input type="hidden" name="PayMethod"				id="PayMethod"				value="SMILEPAY">
			<input type="hidden" name="GoodsName"				id="GoodsName"				value="<%=LGD_PRODUCTINFO %>">
			<input type="hidden" name="Amt"						id="Amt"					value="<%=LGD_AMOUNT %>">
			<input type="hidden" name="SupplyAmt"				id="SupplyAmt"				value="">
			<input type="hidden" name="GoodsVat"				id="GoodsVat"				value="">
			<input type="hidden" name="ServiceAmt"				id="ServiceAmt"				value="">
			<input type="hidden" name="TaxationAmt"				id="TaxationAmt"			value="">
			<input type="hidden" name="GoodsCnt"				id="GoodsCnt"				value="1">
			<input type="hidden" name="MID"						id="MID"					value="<%= SmilepayUtil.MID %>">
			<input type="hidden" name="AuthFlg"					id="AuthFlg"				value="10">
			<input type="hidden" name="EdiDate"					id="EdiDate"				value="<%=EdiDate%>">
			<input type="hidden" name="EncryptData"				id="EncryptData"			value="">
			<input type="hidden" name="BuyerEmail"				id="BuyerEmail"				value="<%=LGD_BUYEREMAIL%>">
			<input type="hidden" name="BuyerName"				id="BuyerName"				value="<%=LGD_BUYER%>">
			<input type="hidden" name="certifiedFlag"			id="certifiedFlag"			value="CN">
			<input type="hidden" name="currency"				id="currency"				value="KRW">
			<input type="hidden" name="merchantEncKey"			id="merchantEncKey"			value="<%= SmilepayUtil.MERCHANT_ENC_KEY %>">
			<input type="hidden" name="merchantHashKey"			id="merchantHashKey"		value="<%= SmilepayUtil.MERCHANT_HASH_KEY %>">
			<input type="hidden" name="requestDealApproveUrl"	id="requestDealApproveUrl"	value="<%=webPath + "/" + msgName%>">
			<input type="hidden" name="prType"					id="prType"					value="WPM">
			<input type="hidden" name="channelType"				id="channelType"			value="4">
			<input type="hidden" name="merchantTxnNum"			id="merchantTxnNum"			value="<%=System.nanoTime() %>">
			<input type="hidden" name="Moid"					id="Moid"					value="<%= orderid %>">
			<input type="hidden" name="possiCard"				id="possiCard"				value="">
			<input type="hidden" name="fixedInt"				id="fixedInt"				value="">
			<input type="hidden" name="maxInt"					id="maxInt"					value="">
			<input type="hidden" name="noIntYN"					id="noIntYN"				value="Y">
			<input type="hidden" name="noIntOpt"				id="noIntOpt"				value="">
			<input type="hidden" name="pointUseYn"				id="pointUseYn"				value="N">
			<input type="hidden" name="blockCard"				id="blockCard"				value="">
			<input type="hidden" name="blockBin"				id="blockBin"				value="">
			<input type="hidden" name="OrderCheckYn"			id="OrderCheckYn"			value="">
			<input type="hidden" name="OrderBirthDay"			id="OrderBirthDay"			value="">
			<input type="hidden" name="OrderName"				id="OrderName"				value="">
			<input type="hidden" name="OrderTel"				id="OrderTel"				value="">
			<!-- output -->
			<input type="hidden" name="resultCode"				id="resultCode"				value="">
			<input type="hidden" name="resultMsg"				id="resultMsg"				value="">
			<input type="hidden" name="txnId"					id="txnId"					value="">
			<input type="hidden" name="prDt"					id="prDt"					value="">
			<input type="hidden" name="SPU"						id="SPU"					value="">
			<input type="hidden" name="SPU_SIGN_TOKEN"			id="SPU_SIGN_TOKEN"			value="">
			<input type="hidden" name="MPAY_PUB"				id="MPAY_PUB"				value="">
			<input type="hidden" name="NON_REP_TOKEN"			id="NON_REP_TOKEN"			value="">
			<input type="hidden" name="BIN_NUMBER"				id="BIN_NUMBER"				value="">
            <input type="hidden" name="etc1" value=""/>
            <input type="hidden" name="etc2" value=""/>
            <input type="hidden" name="etc3" value=""/>
            <input type="hidden" name="returnUrl2" value="<%= smilepayReturnUrl2 %>"/>
			<!-- Smilepay Field End -->					
			
			<!-- payco field -->
			<input type="hidden" name="reserveOrderNo" id="reserveOrderNo"	value="">
			<input type="hidden" name="sellerOrderReferenceKey" id="sellerOrderReferenceKey"	value="">
			<input type="hidden" name="paymentCertifyToken" id="paymentCertifyToken"	value="">
			
			<!-- Npay field -->
			<input type="hidden" name="paymentId" id="paymentId" value="" />

			<!-- etc -->
			<input type="hidden" name="device_type" value="<%= fs.getDeviceType() %>" />
			<input type="hidden" name="tot_amt" id="tot_amt" />
			<input type="hidden" name="tid" id="tid" value="" />
			<input type="hidden" name="pg_token" id="pg_token" value="" />
                </form>
            </div>
        </div>
<form name="hashForm" id="hashForm" method="POST" action="/order/xpay/hash.jsp">
	<input type="hidden" name="GB" value="exp">
	<input type="hidden" name="LGD_OID" value="<%=LGD_OID%>">
	<input type="hidden" name="LGD_AMOUNT" value="<%=LGD_AMOUNT%>">
	<input type="hidden" name="LGD_TIMESTAMP" value="<%=LGD_TIMESTAMP%>">
</form>
<form name="hashSmilepayForm" id="hashSmilepayForm" method="POST" action="/order/smilepay/hash.jsp">
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
	<input type="hidden" name="returnUrl" value="payco_return.jsp">
</form>
<form name="kakaopayReadyForm" id="kakaopayReadyForm" method="post" action="/order/kakaopay/ready.jsp">
	<input type="hidden" name="partner_order_id" value="<%= orderid %>" />
	<input type="hidden" name="partner_user_id" value="<%= fs.getUserId() %>" />
	<input type="hidden" name="item_name" value="<%= LGD_PRODUCTINFO %>" />
	<input type="hidden" name="quantity" value="1" />
	<input type="hidden" name="total_amount" value="<%= LGD_AMOUNT %>" />
	<input type="hidden" name="vat_amount" value="" />
	<input type="hidden" name="tax_free_amount" value="0" />
	<input type="hidden" name="approval_url" value="<%= kakaoReturn %>?result=success" />
	<input type="hidden" name="fail_url" value="<%= kakaoReturn %>?result=fail" />
	<input type="hidden" name="cancel_url" value="<%= kakaoReturn %>?result=cancel" />
</form>
<!-- Smilepay Hidden -->
<div class='div_frame' id="smilePay_layer"  style="display: none"></div>
<iframe name="txnIdGetterFrame" id="txnIdGetterFrame" src="" width="0" height="0"></iframe>
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
           
            
        </script>
    </body>
</html>