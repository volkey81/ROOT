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
	String LGD_PRODUCTINFO      = "파머스빌리지";              //상품명
	String LGD_BUYEREMAIL       = "";               //구매자 이메일
	String LGD_TIMESTAMP        = Utils.getTimeStampString("yyyyMMddHHmmss");                //타임스탬프
	String LGD_CUSTOM_USABLEPAY = "SC0010";        	//상점정의 초기결제수단
	String LGD_CUSTOM_SKIN      = "red";                                                //상점정의 결제창 스킨(red, yellow, purple)
	String LGD_CUSTOM_SWITCHINGTYPE = "IFRAME"; //신용카드 카드사 인증 페이지 연동 방식 (수정불가)
	String LGD_WINDOW_VER		= "2.5";												//결제창 버젼정보
	String LGD_WINDOW_TYPE      = "iframe";               //결제창 호출 방식 (수정불가)
	
	String LGD_TAXFREEAMOUNT	= "0";	// 면세금액
	
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
	String LGD_RETURNURL		= request.getScheme() + "://" + request.getServerName() + "/order/xpay/returnurl.jsp";// FOR MANUAL
	System.out.println("-------------- LGD_RETURNURL : " + LGD_RETURNURL);


	//TODO KaKaoPay의 INBOUND 전문 URL SETTING
	String msgName = "merchant/requestDealApprove.dev";
	String webPath = "https://kmpay.lgcns.com:8443/"; //PG사의 인증 서버 주소

	String naverReturn = request.getScheme() + "://" + request.getServerName() + "/order/naverpay/return.jsp";
%>
<%
	Param param = new Param(request);
	String gubun = param.get("gubun", "W");
	param.set("gubun", gubun);
	
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(6));
	request.setAttribute("Depth_3", "W".equals(gubun) ? new Integer(1) : new Integer(2)); //패키지: Depth_3 = 2
	request.setAttribute("MENU_TITLE", new String("결제하기"));

// 	boolean nopg = true;
	boolean nopg = false;

	FrontSession fs = FrontSession.getInstance(request, response);

	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessage(out, FrontSession.LOGIN_MSG, request);
		return;
	}
	
	HotelOfferService svc = new HotelOfferService();
	
	Param info = svc.getInfo(param.get("pid"));
	if(info == null || "".equals(info.get("pid")) || !"S".equals(info.get("status"))) {
		Utils.sendMessage(out, "현재 판매중인 상품이 아닙니다.", "/hotel/offer/list.jsp");
		return;
	}

	Param priceInfo = svc.getPriceInfo(param);
	if(param.getInt("qty") > priceInfo.getInt("qty", 0)) {
		Utils.sendMessage(out, "죄송합니다. 선택하신 객실 중 판매가 완료 된 객실이 있습니다.", "/hotel/offer/detail.jsp?pid=" + param.get("pid") + "&gubun=" + param.get("gubun"));
		return;
	}

	int qty = param.getInt("qty");
	int night = SanghafarmUtils.getDateDiff(param.get("chki_date"), param.get("chot_date"));
	int defaultPrice = param.getInt("default_price") * qty;
	int price = param.getInt("price") * qty;
	
	// 추가요금 계산
	for(int i = 1; i <= param.getInt("qty"); i++) {
		int adult = param.getInt("adult" + i);
		int child = param.getInt("child" + i);
		int person = adult + child;
		
		if(person > info.getInt("capa")) {
			if(adult > info.getInt("capa")) {	
				// 성인 추가요금
				defaultPrice += (adult - info.getInt("capa")) * param.getInt("default_adult_price");
				price += (adult - info.getInt("capa")) * param.getInt("adult_price");

				// 어린이 추가요금
				defaultPrice += child * param.getInt("default_child_price");
				price += child * param.getInt("child_price");
			} else {	
				// 어린이 추가요금
				defaultPrice += (person - info.getInt("capa")) * param.getInt("default_child_price");
				price += (person - info.getInt("capa")) * param.getInt("child_price");
			}
		}
	}

	int totAmt = price;
	
	CodeService code = (new CodeService()).toProxyInstance();
	MemberService member = (new MemberService()).toProxyInstance();
	CouponService coupon = (new CouponService()).toProxyInstance();
	ImMemberService immem = (new ImMemberService()).toProxyInstance();

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

	// JSONArray for Npay
	JSONArray jsonArr = new JSONArray();
			
	LGD_PRODUCTINFO = info.get("pnm");

	// JSONObject for Npay
	JSONObject j = new JSONObject();
	j.put("categoryType", "TRAVEL");
	j.put("categoryId", "DOMESTIC");
	j.put("uid", info.get("pid"));
	j.put("name", info.get("pnm"));
	j.put("startDate", param.get("chki_date").replaceAll("\\.", ""));
	j.put("endDate", param.get("chot_date").replaceAll("\\.", ""));
	j.put("count", param.getInt("qty"));
	jsonArr.add(j);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />

<!-- payco -->
<script type="text/javascript" src="https://static-bill.nhnent.com/payco/checkout/js/payco.js" charset="UTF-8"></script>
<!-- // payco -->

<!-- JQuery에 대한 부분은 site마다 버전이 다를수 있음 -->
<script src="<%=webPath %>/js/dlp/lib/jquery/jquery-1.11.1.min.js" charset="urf-8"></script>

<!-- DLP창에 대한 KaKaoPay Library -->
<script src="<%=webPath %>/js/dlp/client/kakaopayDlpConf.js" charset="utf-8"></script>
<script src="<%=webPath %>/js/dlp/client/kakaopayDlp.min.js" charset="utf-8"></script> 
<!-- kakaopayLiteRequest에서 jquery 충돌이 나서 회피하려고 할때 변경사항 -->
<!-- <script src="<%=webPath %>/js/dlp/client/kakaopayDlp.pure.min.js" charset="utf-8"></script> -->

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
			document.getElementById("orderForm").action = "<%= Env.getSSLPath() %>/hotel/offer/proc.jsp";
			try { document.getElementById("LGD_CARDPREFIX").value = fDoc.document.getElementById('LGD_CARDPREFIX').value; } catch(e) {}
			document.getElementById("orderForm").submit();
	} else {
		alert("LGD_RESPCODE (결과코드) : " + fDoc.document.getElementById('LGD_RESPCODE').value + "\n" + "LGD_RESPMSG (결과메시지): " + fDoc.document.getElementById('LGD_RESPMSG').value);
		closeIframe();
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
// 		$("#orderForm").attr("action", "info.jsp");
// 		$("#orderForm").submit();
		history.back();
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
		
		$("#coupon_amt_txt").html("(- " + couponAmt.formatMoney() + "원)");
		$("#promocd_amt_txt").html("(- " + promocdAmt.formatMoney() + "원)");
		$("#giftcard_amt_txt").html("(- " + giftcardAmt.formatMoney() + "원)");
		$("#discount_amt_txt").html(discountAmt.formatMoney() + "원");
		$("#pay_amt_txt").html(payAmt.formatMoney() + "원");
	}
	
	function showGift() {
		showPopupLayer('/popup/giftCard.jsp?pay_amt=' + payAmt, '500');		
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
		if(nopg && SystemChecker.isLocal()) {
	%>
			$("#orderForm").submit();
			return;
	<%
		}
	%>
		if(payAmt == 0) {	// 0원 결제
			$("#orderForm").submit();
		} else if($("input[name=pay_type]:checked").val() == "009") {	// naver pay
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
		            "productCount": $("#productCount").val(),
		            "totalPayAmount": payAmt,
		            "taxScopeAmount": payAmt,
		            "taxExScopeAmount": 0,
		            "returnUrl": "<%= naverReturn %>",
		            "useCfmYmdt": $("#orderForm input[name=chot_date]").val().replace(/\./g, ''),
		            "productItems": $("#productItems").val()
		        });
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
			
			if(payAmt != totAmt) {	// 쿠폰, 포인트로 인해 금액이 변동된 경우
				$("#hashForm input[name=LGD_AMOUNT]").val(payAmt);
				ajaxSubmit("#hashForm", function(json) {
					if(json.result) {
						$("#orderForm input[name=LGD_HASHDATA]").val(json.hash);
						launchCrossPlatform();
					} else {
						alert("결제 진행중 오류가 발생했습니다.");
					}
				});
			} else {
				launchCrossPlatform();
			}
		}			
	}
	
	function naverpay(paymentId) {
    	$("#paymentId").val(paymentId);
    	$("#orderForm").submit();
	}
</script> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<div id="container" class="hotel">
		<!-- 내용영역 -->		
		<div class="offerArea offerArea2">
			<jsp:include page="/hotel/offer/tab.jsp" />
			<p class="srmy animated fadeInUp delay04">상하농원 회원에게만 제공되는<br>특별한 객실 프로모션 상품을 만나보세요.</p>
		</div>
		<div class="reservation animated fadeInUp delay06">
			<!-- customerInfo -->
			<div class="reservationCont">
				<!-- infoCont -->
				<div class="infoCont paymentWrap">
				<form name="orderForm" id="orderForm" action="<%= Env.getSSLPath() %>/hotel/offer/proc.jsp" method="post">
					<input type="hidden" name="orderid" value="<%= orderid %>">
<%	
	Set set = param.keySet();
	for(Iterator it = set.iterator(); it.hasNext(); ) {
		String key = (String) it.next();
%>
					<input type="hidden" name="<%= key %>" id="<%= key %>" value="<%= param.get(key) %>">
<%
	}
	
	if(nopg) {
%>
					<input type="hidden" name="nopg" value="Y">
<%
	}
%>
					<input type="hidden" name="tot_amt" id="tot_amt" value="<%= totAmt %>">
					<input type="hidden" name="default_amt" id="default_amt" value="<%= defaultPrice %>">
					<div class="cont">
						<h2>결제하기</h2>
						<table>
							<colgroup>
								<col width="20%">
								<col width="*">
							</colgroup>
							<tr>
								<th scope="col">쿠폰할인</th>
								<td>
									<input type="hidden" name="mem_couponid" id="mem_couponid" value="" />			
									<input type="hidden" name="coupon_amt" id="coupon_amt" value="0" />			
			 						<select name="coupon" id="coupon" onchange="applyCoupon()">
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
									<span class="priceResult" id="coupon_amt_txt">(- 0원)</span>
								</td>
							</tr>
							<tr>
								<th scope="col">프로모션 코드</th>
								<td>
									<input type="text" name="promocd" id="promocd"><a href="javascript:getPromocd(true)" class="btnStyle03">확인</a>
									<span class="priceResult" id="promocd_amt_txt">(- 0원)</span>
									<input type="hidden" name="promocdid" id="promocdid" value=""/>
									<input type="hidden" name="promocd_amt" id="promocd_amt" value="0"/>
								</td>
							</tr>
							<tr>
								<th scope="col"><span class="giftCard">기프트 카드<a href="#none" onclick="showPopupLayer('/popup/giftCardInfo.jsp', '500'); return false" class="giftCardIcon"></a></span></th>
								<td>
									<input type="text" name="giftcard_amt" id="giftcard_amt" value="" readonly><a href="#none" onclick="showGift(); return false" class="btnStyle03">조회</a>
									<span class="priceResult" id="giftcard_amt_txt">(- 0원)</span>
									<input type="hidden" name="giftcard_id" id="giftcard_id">
								</td>
							</tr>
							<tr>
								<th scope="col">매일 Do 포인트</th>
								<td>
									<input type="text" name="point_amt" id="point_amt" value="" onkeydown="return onlyNumber(event);" onkeyup="removeChar(event);" onchange="applyPoint();" <%= point < 100 ? "disabled" : "" %>>
									<p class="doPoint"> 
										<input type="checkbox" name="point_all" id="point_all" onclick="pointAll()" <%= point < 100 ? "disabled" : "" %>><label for="point_all">모두사용 (보유 포인트 : <span><%= Utils.formatMoney(point) %></span>P)</label>
									</p>
								</td>
							</tr>
						</table>
						<ul class="caption">
							<li>* 100P 이상 가지고 계실 때, 1P 단위로 사용가능합니다.</li>
							<li>* 쿠폰은 경우에 따라 중복 적용이 불가합니다.</li>
						</ul>
					</div>
					<div class="cont">
						<h2>결제수단 선택</h2>
						<div class="payWay">
					 		<input type="radio" name="pay_type" id="pay_001" value="001" <%= "001".equals(payType) ? "checked" : "" %>>
					 		<label for="pay_001" style="">신용카드</label>
			
					 		<input type="radio" name="pay_type" id="pay_002" value="002" <%= "002".equals(payType) ? "checked" : "" %>>
					 		<label for="pay_002" style="">계좌이체</label>
			
					 		<!-- <input type="radio" name="pay_type" id="pay_004" value="004" <%= "004".equals(payType) ? "checked" : "" %>>
					 		<label for="pay_004" style=""><img src="/images/hotel/room/ico_paynow.png" alt="PayNow"></label> -->
							
					 		<!-- <input type="radio" name="pay_type" id="pay_007" value="007" <%= "007".equals(payType) ? "checked" : "" %>>
					 		<label for="pay_007" style="color:">KakaoPay</label> -->
			
					 		<input type="radio" name="pay_type" id="pay_006" value="006" <%= "006".equals(payType) ? "checked" : "" %>>
					 		<label for="pay_006" style="color:red"><img src="/images/hotel/room/ico_payco.png" alt="PAYCO"></label>

					 		<input type="radio" name="pay_type" id="pay_009" value="009" <%= "009".equals(payType) ? "checked" : "" %>>
					 		<label for="pay_009" style="">네이버페이</label>
					 	</div>
					 	<ul class="caption" id="npay_notice" style="display:none">
					 		<li>* 주문 변경 시 카드사 혜택 및 할부 적용 여부는 해당 카드사 정책에 따라 변경될 수 있습니다.</li>
					 		<li>* 네이버페이는 네이버ID로 별도 앱 설치 없이 신용카드 또는 은행계좌 정보를 등록하여 네이버페이 비밀번호로 결제할 수 있는 간편결제 서비스입니다.  </li>
					 		<li>* 결제 가능한 신용카드: 신한, 삼성, 현대, BC, 국민, 하나, 롯데, NH농협, 씨티, 카카오뱅크</li>
					 		<li>* 결제 가능한 은행: NH농협, 국민, 신한, 우리, 기업, SC제일, 부산, 경남, 수협, 우체국, 미래에셋대우, 광주, 대구, 전북, 새마을금고, 제주은행, 신협, 하나은행,<br>케이뱅크, 카카오뱅크, 삼성증권</li>
					 		<li>* 네이버페이 카드 간편결제는 네이버페이에서 제공하는 카드사 별 무이자, 청구할인 혜택을 받을 수 있습니다.</li>
					 	</ul>
					</div>			
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
			
			<!-- Npay field -->
			<input type="hidden" name="paymentId" id="paymentId" value="" />
			<input type="hidden" name="productItems" id="productItems" value='<%= jsonArr.toJSONString() %>' />
			<input type="hidden" name="productCount" id="productCount" value='<%= param.get("qty") %>' />

			<!-- etc -->
			<input type="hidden" name="device_type" value="<%= fs.getDeviceType() %>" />

				</form>
					</div>
				<!-- //infoCont -->
			
				<!-- choiceInfoWrap -->
				<div class="choiceInfoWrap">
					<h2>전체 예약정보</h2>
					<!-- choiceInfo -->
					<div class="choiceInfo">
						<div class="top">
							<ul>
								<li>체크인<span><%= param.get("chki_date") %></span></li>
								<li>체크아웃<span><%= param.get("chot_date") %></span></li>
							</ul>
							<span class="dateNum">(<%= Utils.formatMoney(night) %>박)</span>
						</div>
						<div class="middle" id="room_list">
							<p class="tit">객실</p>
							<ul>
								<li class="first"><%= info.get("pnm") %><span><%= param.get("qty") %> 객실</span></li>
<%
	for(int i = 1; i <= param.getInt("qty"); i++) {
%>
								<li>객실 <%= i %><span>성인 <%= param.get("adult" + i) %> , 어린이 <%= param.get("child" + i) %></span></li>
<%
	}
%>
							</ul>
						</div>
						<div class="bottom">
							<ul>
								<li class="discount">총 예약금액<span><%= Utils.formatMoney(totAmt) %>원</span></li>
								<li class="discount">총 할인액<span id="discount_amt_txt">0원</span></li>
								<li>최종 결제액<span id="pay_amt_txt"><%= Utils.formatMoney(totAmt) %>원</span></li>
							</ul>
						</div>
						<div class="choiceInfoBtn">
							<a href="javascript:goPrev()" class="btnStyle02">이전</a><a href="javascript:goNext()" class="btnStyle01">결제하기</a>
						</div>
					</div>
					<!-- //choiceInfo -->
				</div>
				<!-- //choiceInfoWrap -->
			</div>
			<!-- //customerInfo -->
		</div>
		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
<script>
totAmt = <%= totAmt %>;
payAmt = <%= totAmt %>;
</script>
<form name="hashForm" id="hashForm" method="POST" action="/order/xpay/hash.jsp">
	<input type="hidden" name="LGD_OID" value="<%=LGD_OID%>">
	<input type="hidden" name="LGD_AMOUNT" value="<%=LGD_AMOUNT%>">
	<input type="hidden" name="LGD_TIMESTAMP" value="<%=LGD_TIMESTAMP%>">
</form>
<form name="paycoReserveForm" id="paycoReserveForm" method="post" action="/order/payco/payco_reserve.jsp">
	<input type="hidden" name="sellerOrderReferenceKey" value="<%= orderid %>" />
	<input type="hidden" name="totalPaymentAmt" value="<%= LGD_AMOUNT %>" />
	<input type="hidden" name="totalTaxfreeAmt" value="<%= LGD_TAXFREEAMOUNT %>" />
	<input type="hidden" name="productName" value="<%= LGD_PRODUCTINFO %>" />
	<input type="hidden" name="sellerOrderProductReferenceKey" value="hotel" />
	<input type="hidden" name="returnUrl" value="payco_return.jsp">
</form>
</body>
</html>
