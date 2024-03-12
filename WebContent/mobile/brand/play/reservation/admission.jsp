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
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(6));
	request.setAttribute("Depth_4", new Integer(1));
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
	String LGD_PRODUCTINFO      = "입장권";              //상품명
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
	String LGD_RETURNURL		= (SystemChecker.isReal() ? "https" : "http") + "://" + request.getServerName() + "/order/xpay/mreturnurl_exp.jsp";// FOR MANUAL

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
	if(isIOS){
    	LGD_MTRANSFERAUTOAPPYN = "N";
    	LGD_KVPMISPAUTOAPPYN = "N";
    	LGD_MTRANSFERNOTEURL = "N";
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

    // Smilepay의 INBOUND 전문 URL SETTING
	String msgName = "/smilepay/requestDealApprove.htm";
	String webPath = "https://pg.cnspay.co.kr"; //PG사의 인증 서버 주소

	String smilepayReturnUrl2	= (SystemChecker.isReal() ? "https" : "http") + "://" + request.getServerName() + "/order/smilepay/mreturnurl2_exp.jsp";
	System.out.println("-------------- smilepayReturnUrl2 : " + smilepayReturnUrl2);

	String kakaoReturn = request.getScheme() + "://" + request.getServerName() + "/order/kakaopay/return.jsp";

	OrderService order = (new OrderService()).toProxyInstance();
	CouponService coupon = (new CouponService()).toProxyInstance();
	ImMemberService immem = (new ImMemberService()).toProxyInstance();
	CodeService code = (new CodeService()).toProxyInstance();
	MemberService member = (new MemberService()).toProxyInstance();

	int point = immem.getMemberPoint(fs.getUserNo());
	String orderid = order.getNewId();
	member.modifyOrderid(fs.getUserId(), orderid);
	LGD_OID = orderid;
	Param memInfo = member.getInfo(fs.getUserId());
	String payType = memInfo.get("pay_type", "001");
	
	LGD_RETURNURL += "?orderid=" + orderid;
	System.out.println("-------------- LGD_RETURNURL : " + LGD_RETURNURL);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<!-- payco -->
<script type="text/javascript" src="https://static-bill.nhnent.com/payco/checkout/js/payco.js" charset="UTF-8"></script>
<!-- // payco -->

<!-- Smilepay css, javascript 시작 -->
<!-- OpenSource Library -->
<link rel="stylesheet" href="<%=webPath%>/dlp/css/pc/cnspay.css" type="text/css" />

<!-- JQuery에 대한 부분은 site마다 버전이 다를수 있음 -->
<script src="<%=webPath %>/js/dlp/lib/jquery/jquery-1.11.1.min.js" charset="urf-8"></script>
<!-- Smilepay css, javascript  -->

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
			document.getElementById("orderForm").action = "<%= Env.getSSLPath() %>/brand/play/reservation/orderProc2.jsp";
			document.getElementById("orderForm").submit();
	} else {
		alert("LGD_RESPCODE (결과코드) : " + fDoc.document.getElementById('LGD_RESPCODE').value + "\n" + "LGD_RESPMSG (결과메시지): " + fDoc.document.getElementById('LGD_RESPMSG').value);
		closeIframe();
	}
}

</script>

<script src="<%= webPath %>/dlp/scripts/smilepay.js" charset="utf-8"></script>
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
					smilepay_L.movePage(document.orderForm.txnId.value);
				}else{
					alert("[RESULT_CODE] : " + document.orderForm.resultCode.value + "\n[RESULT_MSG] : " + document.orderForm.resultMsg.value);
				}
// 			}
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
	
		/* + "&" + $('order_product_delivery_info').serialize() ); */
		
		$.ajax({
			type: "POST",
			url: "/order/payco/payco_reserve.jsp",
			data: Params,		// JSON 으로 보낼때는 JSON.stringify(customerOrderNumber)
			contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			dataType:"json",
			success:function(data){
				if(data.code == '0') {
// 					console.log(data.result.reserveOrderNo);
// 					console.log(data);
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
	var giftcardAmt = 0;
	var pointAmt = 0;
	var payAmt = 0;
	var totQty = 0;
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
		/* v.add("email2", {
			"empty" : "이메일을 입력해 주세요.",
			"max" : 100
		}); */
		
		//프로그램 권종
		$(".numPlus").click(function() { 	 
		    var item = $(this).closest(".num").find("input"); 	 
		    item.val(Number(item.val()) + 1); 	 
		}); 
		 
		$(".numMinus").click(function() { 	 
		    var item = $(this).closest(".num").find("input"); 	 
		    item.val(Number(item.val()) - 1); 	 
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

	var days = ["일", "월", "화", "수", "목", "금", "토"];

	function setDate(obj, date) {
		var d = new Date(parseInt(date.split('.')[0]), parseInt(date.split('.')[1]) - 1, parseInt(date.split('.')[2]));
// 		console.log(date, d, parseInt(date.split('.')[1]) - 1);

		$(".calenderArea .choice").removeClass("choice");
		$(obj).parent().addClass("choice");
		$("#reserve_date").val(date);
		$("#reserve_date_txt").html(date);
		$('.calenderArea .choiceDate dd span:eq(0)').html(date.split('.')[1]);
		$('.calenderArea .choiceDate dd span:eq(1)').html(date.split('.')[2]);
		$('.calenderArea .choiceDate dd span:eq(2)').html(days[d.getDay()]);
		$('.programSel .listCont').remove();
		step1(date);
	}

	function step1(date) {
		$(".programChk").empty();

		$.ajax({
			method : "POST",
			url : "/brand/play/reservation/expList4.jsp",
			data : { date : date },
			dataType : "html"
		})
		.done(function(html) {
			$(".programChk").empty().append($.trim(html));
			$(".reservationMethod").css("display","block");
		});
		
		cal();
	}

	function step2(pid) {
		if($("#exp_pid_" + pid).prop("checked")) {
			if($("input[name=exp_pid]:checked").length > 5) {
				alert("최대 5개까지 선택 가능합니다.");
				$("#exp_pid_" + pid).prop("checked", false);
			} else {
				$.ajax({
					method : "POST",
					url : "/brand/play/reservation/expList5.jsp",
					data : { exp_pid : pid },
					dataType : "html"
				})
				.done(function(html) {
					$(".programSel").append($.trim(html));
				});
			}
		} else {
			$("#price_row_" + pid).remove();
		}

		cal();
	}
	
	function setQty(dir, pid, no) {
		var obj = $("#qty_" + pid + "_" + no);
		if(dir == 'up') {
			obj.val(parseInt(obj.val()) + 1);
		} else {
			if(obj.val() != 0) {
				obj.val(parseInt(obj.val()) - 1);
			}
		}
		
		cal();
	}
	
	function cal() {
		totAmt = 0;
		totQty = 0;
		var _listTxt = "";
		$("input[name=exp_pid]:checked").each(function() {
			var _pid = $(this).val();
			$("input[name=ticket_type_" + _pid + "]").each(function() {
				var _ticket = $(this).val();
				var _price = parseInt($("#price_" + _pid + "_" + _ticket).val());
				var _qty = parseInt($("#qty_" + _pid + "_" + _ticket).val());
// 				console.log(_pid + ", " + _ticket + ", " + _price + ", " + _qty);
				totAmt += (_price * _qty);
				totQty += _qty;
				
				if(_qty > 0) {
					_listTxt += "<tr class='list_txt_row'><td><span>" + $("#exp_type_name_" + _pid).val() + " ( " + $("#time_name_" + _pid).val() + " ) </span></td>";
					_listTxt += "<td><span>" + $("#ticket_nm_" + _pid + "_" + _ticket).val() + " ( " + $("#qty_" + _pid + "_" + _ticket).val() + " )</span></td></tr>"; 
				}
			});
		});
	
// 		console.log("totAmt : " + totAmt);
		$("#tot_amt").val(totAmt);
		$("#productCount").val(totQty);
		$("#tot_amt_txt").html(totAmt.formatMoney());
		$("#pay_amt_txt").html(totAmt.formatMoney());
		$(".list_txt_row").remove();
		$("#list_txt").append(_listTxt);
		setAmt();
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
// 		$("#coupon").val("");
		$("#mem_couponid").val("");
		$("#coupon_amt").val("");
		setAmt();
	}
	
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
	
	function setAgreeAll() {
		$("#agree1").prop("checked", $("#agreeAll").prop("checked"));
		$("#agree2").prop("checked", $("#agreeAll").prop("checked"));
		$("#agree3").prop("checked", $("#agreeAll").prop("checked"));
		$("#agree4").prop("checked", $("#agreeAll").prop("checked"));
	}
	
	function orderProc() {
		if(payAmt < 0) {
			alert("결제금액이 0원 미만입니다.");
			return;
		}

		if(v.validate()) {
			if($("#reserve_date").val() == "") {
				alert("예약일자를 선택하세요.");
				return;
			}
			
			/*
			if(totAmt == 0) {
				alert("입장권을 선택하세요.");
				return;
			}
			*/

			if(totQty == 0) {
				alert("입장권을 선택하세요.");
				return;
			}

			// 포인트 체크
			var point = parseInt($("#point_amt").val().replace(/,/g, ""));
			if($("#point_amt").val() != "" && point % 10 != 0) {
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
			
			if(!$("#agree4").prop("checked")) {
				alert("개인정보 수집 및 이용에 대한 동의는 필수입니다.");
				return;
			}

			if(!$("#agree3").prop("checked")) {
				alert("주문내역 동의는 필수입니다.");
				return;
			}

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
				
//			console.log(_taxationAmt + ":" + _goodsVat + ":" + _supplyAmt);
				
			$("#orderForm input[name=SupplyAmt]").val(_supplyAmt);
			$("#orderForm input[name=GoodsVat]").val(_goodsVat);
			$("#orderForm input[name=ServiceAmt]").val(0);
			$("#orderForm input[name=TaxationAmt]").val(_taxationAmt);
<%
// 	boolean nopg = true;
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
			} else if($("input[name=pay_type]:checked").val() == "009") {	// naverpay
				if(payAmt < 100) {
					alert("결제 최소금액은 100원입니다.");
				} else {
					$("#orderForm").attr("action", "<%= Env.getSSLPath() %>/mobile/order/orderSessionNaverPay.jsp");
					$("#productItems").val(JSON.stringify(getProductJson()));
					$("#orderForm").submit();
				}
			} else if($("input[name=pay_type]:checked").val() == "008") {	// Smilepay
				/*
				$("#hashSmilepayForm input[name=amt]").val(payAmt);
				ajaxSubmit("#hashSmilepayForm", function(json) {
					if(json.result) {
						$("#orderForm input[name=EncryptData]").val(json.hash);
						getTxnId();
					} else {
						alert("결제 진행중 오류가 발생했습니다.");
					}
				});
				*/
				
				$("#orderForm").attr("action", "<%= Env.getSSLPath() %>/mobile/order/orderSessionSmilePay.jsp");
				$("#orderForm").submit();
			} else if($("input[name=pay_type]:checked").val() == "006") {	// Payco
				callPaycoUrl();
			} else if($("input[name=pay_type]:checked").val() == "007") {	// 카카오페이2
				$("#kakaopayReadyForm input[name=total_amount]").val(payAmt);
				ajaxSubmit("#kakaopayReadyForm", function(json) {
					if(json.response_code == '200') {
						$("#tid").val(json.tid);
//  						window.open(json.next_redirect_mobile_url, "KAKAOPAYPOP", "width=426,height=510");
<%
	if(fs.isApp()) {
%>
						outUrlShowPopupLayer(json.next_redirect_app_url, '426', '510');
<%
	} else {
%>
						outUrlShowPopupLayer(json.next_redirect_mobile_url, '426', '510');
<%
	}
%>
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
	
	$(function(){
		$(".programChk li input:checkbox").on('click', function(){ 
			if ( $(this).prop('checked')){ 
				$(this).parent().addClass("chk");
			} else { 
				$(this).parent().removeClass("chk");
			} 
		});		
	})

	function showGift() {
		showPopupLayer('/popup/giftCard.jsp?pay_amt=' + payAmt, '500');		
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
	
	function autoFill() {
		if($("#auto_fill").prop("checked")) {
			$("#name").val("<%= fs.getUserNm() %>");
			$("#mobile1").val("<%= fs.getMobile1() %>");
			$("#mobile2").val("<%= fs.getMobile2() %>");
			$("#mobile3").val("<%= fs.getMobile3() %>");
			$("#email1").val("<%= fs.getEmail1() %>");
			$("#email2").val("<%= fs.getEmail2() %>");
			$("#email3").val("");
		} else {
			$("#name").val("");
			$("#mobile1").val("010");
			$("#mobile2").val("");
			$("#mobile3").val("");
			$("#email1").val("");
			$("#email2").val("");
			$("#email3").val("");
		}
	}

	function kakaopay(token) {
// 		console.log("token : " + token);
		$("#pg_token").val(token);
		$("#orderForm").submit();
	}

    function kakaopayPopClose() {
    	hidePopupLayer();
    }

    function getProductJson() {
    	var productItems = new Array();
    	
		$("input[name=exp_pid]:checked").each(function() {
			var _pid = $(this).val();
			$("input[name=ticket_type_" + _pid + "]").each(function() {
				var _ticket = $(this).val();
				var _price = parseInt($("#price_" + _pid + "_" + _ticket).val());
				var _qty = parseInt($("#qty_" + _pid + "_" + _ticket).val());
// 				console.log(_pid + ", " + _ticket + ", " + _price + ", " + _qty);
				
				if(_qty > 0) {
					var json = {
							"categoryType": "PLAY",
							"categoryId" : "TICKET",
							"uid": _pid + "_" + _ticket,
							"name": $("#exp_type_name_" + _pid).val() + "-" + $("#ticket_nm_" + _pid + "_" + _ticket).val(),
							"startDate": $("#reserve_date").val().replace(/\./g, ''),
							"endDate": $("#reserve_date").val().replace(/\./g, ''),
							"count": _qty
					}
					
					productItems.push(json);
				}
			});
		});
	
		console.log(productItems);
		return productItems;    	
    }
</script>
</head> 
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container" class="reservationWrap">
	<!-- 내용영역 -->
		<jsp:include page="/mobile/brand/play/reservation/subNav.jsp" />
		<p class="reserSrmy">새콤하고 달콤한 딸기 수확체험은 가오픈 12/2~10 , 정식오픈 12/11~5/12 체험 진행됩니다.</p>
		<h2 class="typeA"><strong class="num">01</strong> 날짜 선택</h2>		
		<form name="orderForm" id="orderForm" method="post" action="<%= Env.getSSLPath() %>/brand/play/reservation/orderProc2.jsp">
			<input type="hidden" name="orderid" value="<%= orderid %>" />
			<input type="hidden" name="reserve_date" id="reserve_date" />
			<input type="hidden" name="ticket_div" value="01" />
			<div class="calenderArea">
<%
	Calendar today = Calendar.getInstance();
	Calendar cal = Calendar.getInstance();
	Calendar cal2 = Calendar.getInstance();
	cal2.add(Calendar.DATE, 70);
%>
				<div id="step1" class="step">
					<p class="stepTxt"><span>STEP 1</span>입장 및 체험권을 구매하실 날짜를 선택해 주세요.</p>
					<dl class="choiceDate">
						<dt>선택하신 날짜</dt>
						<dd><span><%= (new SimpleDateFormat("MM", java.util.Locale.US)).format(cal.getTime()) %></span>월 <span><%= (new SimpleDateFormat("dd", java.util.Locale.US)).format(cal.getTime())%></span>일 (<span><%= (new SimpleDateFormat("E", java.util.Locale.KOREA)).format(cal.getTime()) %></span>)</dd>
					</dl>
					<div class="slideCont">
						<ul class="swiper-wrapper">
<%
	for(int j = 0; j < 4; j++) {
		cal.set(Calendar.DATE, 1);
%>
							<li class="sec swiper-slide">
								<%-- <h3><%= (new SimpleDateFormat("MMMMMMMMM", java.util.Locale.US)).format(cal.getTime()) %><br><strong><%= (new SimpleDateFormat("MM", java.util.Locale.US)).format(cal.getTime()) %></strong></h3> --%>
								<h3><%= (new SimpleDateFormat("YYYY", java.util.Locale.US)).format(cal.getTime()) %><span>.<%= (new SimpleDateFormat("MM", java.util.Locale.US)).format(cal.getTime()) %></span></h3>
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
										<li></li>
	<%
			}
		
			while(true) {
				if((cal.compareTo(today) < 0) || (cal.compareTo(cal2) > 0)) {
	%>
										<li class="disable"><a href="javascript:void(0)"><%= cal.get(Calendar.DATE) %></a></li>
	<%
				} else {
	%>
										<li <%= cal.compareTo(today) == 0 ? "class=\"today\"" : "" %>><a href="#none" onclick="setDate(this, '<%= Utils.getTimeStampString(cal.getTime(), "yyyy.MM.dd") %>'); return false;"><%= cal.get(Calendar.DATE) %></a></li>
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
					<input type="image" src="/mobile/images/btn/btn_next6.png" alt="이전달" class="prev">
					<input type="image" src="/mobile/images/btn/btn_next7.png" alt="다음달" class="next">
				</div><!-- //slideCont -->
				<div class="choiceInfo">
					<p class="datePoint today">오늘 날짜</p>
					<p class="datePoint choice">선택일</p>
					<p class="datePoint disable">예약 불가능</p>
				</div>
			</div><!-- //step1 -->	
			<div id="step2" class="step">
				<p class="stepTxt"><span>STEP 2</span>체험하실 프로그램을 선택해 주세요. (최대 5개까지 선택 가능합니다.)</p>
				<ul class="programChk"></ul>
				<!-- <div class="reservationMethod">
					<p class="tit">시골패키지 예약 하는 법</p>
					<ol>
						<li>1. 숙박을 원하시는 날짜를 선택해주세요.
							<ul>
								<li>- 예약 불가능으로 표시 되어 있는 경우엔 전화로 예약 부탁 드립니다.</li>
							</ul>
						</li>
						<li>2. 숙박을 원하시는 객실 타입을 선택해주세요.
							<ul>
								<li>- 온돌 룸은 수량이 많지 않아 온라인 예약이 불가하므로 전화 예약 부탁 드립니다.</li>
								<li>- 갯벌체험을 원하시는 고객님께서는 체험 시간표를 확인하시고 꼭 전화로<br>사전 예약을 해주세요.
									<a href="/mobile/brand/bbs/news/view.jsp?seq=187" target="_blank">갯벌체험 시간 확인하기</a>
								</li>
							</ul>
						</li>
						<li>3. 권종에서 옵션을 선택해주세요.
							<ul>
								<li>예) 7월 10일 입실 ~ 7월 11일 퇴실(1박 2일)의 경우
									<span> - 날짜를 10일로 선택하시고 시골패키지 숙박권 옆 수량을 1로 변경 후 마지막 단계까지 진행하면 예약 완료 !</span>
								</li>
								<li>예) 7월 10일 입실 ~ 7월 12일 퇴실(2박 3일)의 경우
									<span>Step 1. 날짜를 10일로 선택하시고  1박 2일과 동일하게 시골패키지 숙박권만 수량을 1로 변경하여 마지막 단계까지 결제 진행 해주세요.</span>
									<span> Step 2. 다시 날짜 선택으로 돌아가셔서 날짜를 11일로 선택하시고 1박 추가요금만 수량을 1로 변경하여 결제하면 예약 완료 !</span>
								</li>
							</ul>
						</li>
						<li>4. 고객님 정보를 입력하시고 이용 약관 확인 후 동의 해주세요.</li>
						<li>5. 예약 정보 확인 → 할인 혜택 선택 → 결제 진행 해주세요.</li>
					</ol>
				</div> -->
			</div>			
		</div><!-- //calenderArea -->
		
		<div class="reserForm">
			<div class="programSel">
				<h2 class="typeA">
					<strong class="num">02</strong> 체험프로그램 선택					
				</h2>
				<ul class="caution">
					<li>체험권 권종에 입장권이 포함되어있을 수 있으니 유의 바랍니다.</li>
					<li>이용 3일이내 예약하고 취소하는 경우 위약금이 부과됩니다.</li>
					<li>당일 예약 시 당일 취소 하여도 환불 되지 않으니 확인 후 예약 바랍니다.</li>
				</ul>
			</div>
			<div class="customerInfo">
				<h2 class="typeA"><strong class="num">03</strong> 고객정보</h2>
				<p class="sameChk"><input type="checkbox" name="auto_fill" id="auto_fill" onclick="autoFill()"><label for="auto_fill">고객 정보 동일</label>
				<table>
					<caption>예약자 정보입력 폼</caption>
					<colgroup>
						<col width="70"><col width="">
					</colgroup>
					<tr>
						<th scope="row">이름</th>
						<td><input type="text" name="name" id="name" value="" title="성명" style="width:120px;"></td>
					</tr>
					<tr>
						<th scope="row">연락처</th>
						<td>
							<select name="mobile1" id="mobile1" title="휴대전화 첫자리" style="width:80px">
<%
	for(String mobile : SanghafarmUtils.MOBILES) {
%>
								<option value="<%= mobile %>"><%= mobile %></option>
<%
	}
%>
							</select>&nbsp;-
							<input type="text" name="mobile2" id="mobile2" value="" title="휴대전화 가운데자리" style="width:80px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">&nbsp;-
							<input type="text" name="mobile3" id="mobile3" value="" title="휴대전화 뒷자리" style="width:80px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">
						</td>
					</tr>
					<tr>
						<th scope="row" class="email">이메일</th>
						<td>
							<input type="text" name="email1" id="email1" value="" title="이메일 앞자리" style="width:130px">&nbsp;@
							<input type="text" name="email2" id="email2" value="" title="이메일 뒷자리" style="width:140px">
							<select name="email3" id="email3" onchange="changeEmail3(this.value)" title="주문자 이메일 뒷자리 선택" style="width:192px">
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
				<ul class="caution">
					<li>예매 정보를 해당 고객 연락처로 발송해드립니다.</li>
				</ul>
				<!-- //step2 예약자정보 -->
			</div>
			<div class="agreeHead">
				<h2 class="typeA">이용 동의</h2>
				<p class="allChk"><input type="checkbox" name="agreeAll" id="agreeAll" onclick="setAgreeAll()"><label for="agreeAll">전체 동의하기</label>
			</div>
			<div class="agreeChk">
		 		<div class="section">
		 			<h3><input type="checkbox" name="agree1" id="agree1"><a href="#" onclick="showTab3(this, '.icoMore', '.agreeChk .cont'); return false;" class="icoMore typeB on">취소/환불 규정에 대한 동의</a></h3>
		 			<div class="cont">
			 			<div class="scr">
							<jsp:include page="/order/agree3.jsp" />
			 			</div>
		 			</div>
		 		</div>
		 		<div class="section">
		 			<h3><input type="checkbox" name="agree2" id="agree2"><a href="#" onclick="showTab3(this, '.icoMore', '.agreeChk .cont'); return false;" class="icoMore typeB">결제대행서비스 표준이용약관</a></h3>
		 			<div class="cont" id="agreeCont2" style="display:none;">
		 				<div class="scr">
							<jsp:include page="/order/agree.jsp" />
			 			</div>
		 			</div>
		 		</div>
		 		<div class="section">
		 			<h3><input type="checkbox" name="agree4" id="agree4"><a href="#" onclick="showTab3(this, '.icoMore', '.agreeChk .cont'); return false;" class="icoMore typeB">개인정보 수집 및 이용에 대한 동의</a></h3>
		 			<div class="cont" style="display:none;">
			 			<div class="scr">
							본인은 상하농원(유) (이하’회사’ 라 합니다) 가 제공하는 호텔 예약서비스(이하’서비스’라 합니다) 를 이용하기 위해, 다음과 같이 ‘회사’가 본인의 개인정보를 수집/이용하고 개인정보의 
							취급을 위탁하는 것에 동의합니다. 수집항목 - 이용자의 성명, 이동전화번호, 이메일.
			 			</div>
		 			</div>
		 		</div>
		 		<div class="section">
		 			<h3><input type="checkbox" name="agree3" id="agree3"><a href="#" onclick="showTab3(this, '.icoMore', '.agreeChk .cont'); return false;" class="icoMore typeB">주문내역 동의</a></h3>
		 			<div class="cont" style="display:none;">
			 			<div class="scr">
							주문할 입장/체험 상품의 상품명, 사용일자 및 시간, 상품가격을 확인했습니다.<br>(전자상거래법 제 8조 2항) 구매에 동의하시겠습니까?<br><br>
							<ul>
								<li>체험 시작 이후에는 입장이 제한됩니다. (최소 20분전 도착)</li>
								<li>체험 상품에 따라 별도 포장 시간이 소요될 수 있습니다.</li>
								<li>개인 일정에 따른 손해에 대해서는 상하농원에서 책임지지 않습니다.</li>
							</ul>
			 			</div>
		 			</div>
		 		</div>
		 	</div>
		 	<!--//이용동의 -->
			<div class="payInfo">
				<h2 class="typeA"><strong class="num">04</strong> 총 결제 금액</h2>
				<div class="totalPrice">
					<div class="reservationInfo">
						<h3>예약 정보</h3>
						<p class="info">예약일<span id="reserve_date_txt"></span></p>
						<table id="list_txt">
							<colgroup>
								<col width="50%">
								<col width="50%">
							</colgroup>
							<tr id="list_txt_head">
								<th scope="col"><span>체험 종류</span></th>
								<th scope="col"><span>선택 권종</span></th>
							</tr>
						</table>
					</div>
					<ul class="discount">
						<li>
							<strong>총 금액</strong><div class="allPrice"><span id="tot_amt_txt">0</span>원</div>
						</li>
						<li>
							<strong>쿠폰할인</strong>
							<div class="cont">	
								<p class="field">
									<input type="hidden" name="mem_couponid" id="mem_couponid" value="" />			
									<input type="hidden" name="coupon_amt" id="coupon_amt" value="0" />			
									<select name="coupon" id="coupon" title="쿠폰선택" onchange="applyCoupon()" style="width:100%;">
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
								<p class="price"><span class="fontTypeF" id="coupon_amt_txt">-0</span>원</p>
							</div>
						</li>
						<li>
							<strong>기프트 카드</strong>
							<div class="cont">	
								<p class="field">
									<input type="text" name="giftcard_amt" id="giftcard_amt" value="0" title="기프트 카드" readonly style="width:74%;">
									<input type="hidden" name="giftcard_id" id="giftcard_id">
									<a href="javascript:showGift();" class="btnOk">확인</a>
								</p>								
								<p class="price"><span class="fontTypeF" id="giftcard_amt_txt">-0</span>원</p>
							</div>
						</li>
						<li>
							<strong>Maeil Do 포인트</strong>
							<div class="cont">	
								<p class="field"><input type="text" name="point_amt" id="point_amt" value="" title="포인트" onkeydown="return onlyNumber(event);" onkeyup="removeChar(event);" onchange="applyPoint();" <%= point < 100 ? "disabled" : "" %> style="width:90%;">&nbsp;P</p>
								<p class="price"><span class="fontTypeF" id="point_amt_txt">-0</span>P</p>
							</div>
							<p class="all"><input type="checkbox" name="point_all" id="point_all" onclick="pointAll()" <%= point < 100 ? "disabled" : "" %>><label for="point_all">모두사용</label> (보유 포인트 : <strong class="fontTypeF"><%= Utils.formatMoney(point) %></strong> P)</p>
						</li>
					</ul>
					<ul class="caution">
						<li>100P 이상 가지고 계실 때, 10P 단위로 사용가능합니다.</li>
						<li>쿠폰은 기본적으로 중복 적용이 불가 합니다.</li>
						<li>일부 체험의 경우 할인 쿠폰이 적용되지 않을 수 있습니다.</li>
					</ul>					
					<div class="payType">
						<h3>결제수단 선택</h3>
					 	<p class="discountInfo"><!-- <a href="">신용카드 별 결제 할인 안내</a> --></p>
					 	<div class="payWay">
					 		<p><input type="radio" name="pay_type" id="pay_001" value="001" <%= "001".equals(payType) ? "checked" : "" %>>
					 		<label for="pay_001" style="color:">신용카드</label></p>

					 		<p><input type="radio" name="pay_type" id="pay_002" value="002" <%= "002".equals(payType) ? "checked" : "" %>>
					 		<label for="pay_002" style="color:">계좌이체</label></p>

					 		<!-- <p><input type="radio" name="pay_type" id="pay_004" value="004" <%= "004".equals(payType) ? "checked" : "" %>>
					 		<label for="pay_004" style="color:">PayNow</label></p> -->

					 		<p><input type="radio" name="pay_type" id="pay_007" value="007" <%= "007".equals(payType) ? "checked" : "" %>>
					 		<label for="pay_007" style="color:">KakaoPay</label></p>

					 		<p><input type="radio" name="pay_type" id="pay_006" value="006" <%= "006".equals(payType) ? "checked" : "" %>>
					 		<label for="pay_006" style="color:red">PAYCO</label></p>

					 		<p><input type="radio" name="pay_type" id="pay_008" value="008" <%= "008".equals(payType) ? "checked" : "" %>>
					 		<label for="pay_008" style="color:">SmilePay</label></p>

					 		<p><input type="radio" name="pay_type" id="pay_009" value="009" <%= "009".equals(payType) ? "checked" : "" %>>
					 		<label for="pay_009" style="color:">네이버페이</label></p>
					 	</div>
					 	<ul class="caution cautionStyle02" id="npay_notice" style="display:none">
							<li>주문 변경 시 카드사 혜택 및 할부 적용 여부는 해당 카드사 정책에 따라 변경될 수 있습니다.</li>
					 		<li>네이버페이는 네이버ID로 별도 앱 설치 없이 신용카드 또는 은행계좌 정보를 등록하여 네이버페이 비밀번호로 결제할 수 있는 간편결제 서비스입니다.  </li>
					 		<li>결제 가능한 신용카드: 신한, 삼성, 현대, BC, 국민, 하나, 롯데, NH농협, 씨티, 카카오뱅크</li>
					 		<li>결제 가능한 은행: NH농협, 국민, 신한, 우리, 기업, SC제일, 부산, 경남, 수협, 우체국, 미래에셋대우, 광주, 대구, 전북, 새마을금고, 제주은행, 신협, 하나은행, 케이뱅크, 카카오뱅크, 삼성증권</li>
					 		<li>네이버페이 카드 간편결제는 네이버페이에서 제공하는 카드사 별 무이자, 청구할인 혜택을 받을 수 있습니다.</li>
						</ul>	
				 	</div>
					<p class="lastPrice">최종 결제액 <em><strong class="fontTypeA" id="pay_amt_txt">0</strong>원</em></p>
					<input type="hidden" name="save_pay_type" value="Y">
				</div>
				<!-- //step4 총결제금액 -->
			 	
			 	<div class="btnArea ac">
			 		<a href="javascript:orderProc()" class="btnTypeA sizeXL">결제하기</a>
			 	</div>
			</div>
		</div><!-- //reserForm -->
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
            <input type="hidden" name="etc1" value="<%= orderid %>"/>
            <input type="hidden" name="etc2" value=""/>
            <input type="hidden" name="etc3" value=""/>
            <input type="hidden" name="returnUrl2" value="<%= smilepayReturnUrl2 %>"/>
			<!-- Smilepay Field End -->					
			
			<!-- payco field -->
			<input type="hidden" name="reserveOrderNo" id="reserveOrderNo"	value="">
			<input type="hidden" name="sellerOrderReferenceKey" id="sellerOrderReferenceKey"	value="">
			<input type="hidden" name="paymentCertifyToken" id="paymentCertifyToken"	value="">
			<input type="hidden" name="paycoOrderUrl" id="paycoOrderUrl"	value="">
			
			<!-- Npay field -->
			<input type="hidden" name="paymentId" id="paymentId" value="" />
			<input type="hidden" name="productItems" id="productItems" value='' />
			<input type="hidden" name="productCount" id="productCount" value='' />
			<input type="hidden" name="naver_return" id="naver_return" value="mreturn_exp" />

			<!-- etc -->
			<input type="hidden" name="device_type" value="<%= fs.getDeviceType() %>" />
			<input type="hidden" name="tot_amt" id="tot_amt" />
			<input type="hidden" name="tid" id="tid" value="" />
			<input type="hidden" name="pg_token" id="pg_token" value="" />
	 	</form>
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
<!-- <div class="popWait">
	<p class="close"><a href="#" onclick="hidePopup(this); return false"><img src="/mobile/images/btn/btn_close4.png" alt="닫기"></a></p>
	<div class="text">
		<strong>잠깐만요!</strong><br>상하가족에 가입하시면<br>무료입장권10매 체험 10% 할인권을<br>증정해드려요!
	</div>
	<div class="btnArea">
		<a href="/mobile/brand/play/reservation/experience.jsp" class="typeA">상하가족 가입하고 할인받기 <span class="ico">GO</span></a>
		<a href="#" onclick="hidePopup(this); return false" class="typeB">할인없이 입장/체험관 예약하기 <span class="ico">GO</span></a>
	</div>
</div>
<script>
$(window).on("load", function(){
	$(".popWait").css("top", ($(window).scrollTop()+$(window).height()/2)+"px").css("margin-top", "-" + ($(".popWait").height()/2) + "px");
	$(".bgLayer, .popWait").show();	
});
function hidePopup(){
	$(".bgLayer, .popWait").hide();	
}
</script> -->
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
	<input type="hidden" name="returnUrl" value="payco_return_mobile_exp.jsp?orderid=<%= orderid %>">
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
</body>
</html>
					