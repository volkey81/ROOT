<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.security.*,
				 com.efusioni.stone.common.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.utils.*,
				 com.sanghafarm.service.order.*,
				 com.sanghafarm.service.member.*,
				 com.sanghafarm.service.code.*,
				 com.sanghafarm.service.promotion.*,
				 org.json.simple.*" %>
<%@ include file="/order/payco/common_include.jsp" %>
<%
	request.setAttribute("Depth_1", new Integer(2));
	request.setAttribute("Depth_2", new Integer(2));
	request.setAttribute("Depth_3", new Integer(2));
	request.setAttribute("MENU_TITLE", new String("주문/결제"));
%>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);

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
	String LGD_OID              = ""							;                      //주문번호(상점정의 유니크한 주문번호를 입력하세요)
	String LGD_AMOUNT           = "";								                   //결제금액("," 를 제외한 결제금액을 입력하세요)
	String LGD_MERTKEY          = Config.get("lgdacom.LGD_MERTKEY");   					//상점MertKey(mertkey는 상점관리자 -> 계약정보 -> 상점정보관리에서 확인하실수 있습니다)
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
// 	String LGD_CASNOTEURL		= "http://" + request.getServerName() + "/order/xpay/cas_noteurl.jsp";
	String LGD_CASNOTEURL		= (SystemChecker.isReal() ? "https" : "http") + "://" + request.getServerName() + "/order/xpay/cas_noteurl.jsp";
		
	System.out.println("-------------- LGD_CASNOTEURL : " + LGD_CASNOTEURL);
	/*
	 * LGD_RETURNURL 을 설정하여 주시기 바랍니다. 반드시 현재 페이지와 동일한 프로트콜 및  호스트이어야 합니다. 아래 부분을 반드시 수정하십시요.
	 */
	String LGD_RETURNURL		= (SystemChecker.isReal() ? "https" : "http") + "://" + request.getServerName() + "/order/xpay/mreturnurl.jsp";// FOR MANUAL
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
	if(isIOS) {
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

	String smilepayReturnUrl2	= (SystemChecker.isReal() ? "https" : "http") + "://" + request.getServerName() + "/order/smilepay/mreturnurl2.jsp";
	System.out.println("-------------- smilepayReturnUrl2 : " + smilepayReturnUrl2);

	String kakaoReturn = request.getScheme() + "://" + request.getServerName() + "/order/kakaopay/return.jsp";

	CartService cart = (new CartService()).toProxyInstance();
	OrderService order = (new OrderService()).toProxyInstance();
	MemberService member = (new MemberService()).toProxyInstance();
	CodeService code = (new CodeService()).toProxyInstance();
	CouponService coupon = (new CouponService()).toProxyInstance();
	ImMemberService immem = (new ImMemberService()).toProxyInstance();
	SecondAnniversaryService sa = new SecondAnniversaryService();
	
	String userid = "";
	if(fs.isLogin()) userid = fs.getUserId();
	else userid = fs.getTempUserId();
	
	param.set("userid", userid);
	
	String[] cartid = param.getValues("cartid");
	if(cartid != null && cartid.length > 0) cart.setOrderYn(param);
	
	param.set("grade_code", fs.getGradeCode());
	param.set("order_yn", "Y");
	
	// 일반상품
	param.set("routine_yn", "N");
	param.set("ptype", "A");
	List<Param> list1 = cart.getList(param);
	
	// 산지직송 상품
	param.set("ptype", "C");
	List<Param> list2 = cart.getList(param);

	// 정기구매
	param.set("routine_yn", "Y");
	param.remove("ptype");
	List<Param> list3 = cart.getList(param);

	// 배송일 지정 상품
	param.set("routine_yn", "N");
	param.set("ptype", "D");
	List<Param> list4 = cart.getList(param);

	String orderid = order.getNewId();
	LGD_OID				= orderid;
	LGD_RETURNURL		+= "?orderid=" + orderid;
	System.out.println("-------------- LGD_RETURNURL : " + LGD_RETURNURL);
	Param memInfo = new Param();
	
	if(fs.isLogin()) {
		member.modifyOrderid(userid, orderid);
		memInfo = member.getInfo(userid);
	}
	String payType = memInfo.get("pay_type", "001");
	
	// 결제방법
	List<Param> payList = code.getList2("007");
	String pnm = "";
	String pid = "";
	
	List<String> couponList = new ArrayList<String>();
	
	// 포인트
	int point = 0;
	if(fs.isLogin()) {
		point = immem.getMemberPoint(fs.getUserNo());
	}

	// 재고부족 상품 리스트
	List<Param> soldOutList1 = new ArrayList<Param>();
	// 미판매 상품 리스트
	List<Param> soldOutList2 = new ArrayList<Param>();

	// 8월 정기배송 특가 상품 코드
	String eventPid = Config.get("evend1.pid." + SystemChecker.getCurrentName());

	// 현대카드 프로모션 상품 존재 여부
	boolean existsHyundaiCardPid = false;

	// 2주년 프로모션 정보
	Param saInfo = sa.getInfo();
	List<String> saList = sa.getProductList(saInfo.getLong("seq"));
	
	// 2주년 프로모션 체크용 List
	List<Param> saList1 = new ArrayList<Param>();
	List<Param> saList2 = new ArrayList<Param>();
	List<Param> saList3 = new ArrayList<Param>();
	List<Param> saList4 = new ArrayList<Param>();

	// 지정배송일 오류 체크
	boolean isInvalidDdate = false;

	// 품절옵션
	List<Param> soldoutOptList = code.getList2("031");

	// 새벽배송전용 
	boolean isEarlyOnly = false;

	// 새벽배송 가능여부
	boolean isEarlyAvailable = list1.size() > 0 ? true : false;
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
			document.getElementById("orderForm").action = "<%= Env.getSSLPath() %>/order/orderProc.jsp";
			document.getElementById("LGD_CARDPREFIX").value = fDoc.document.getElementById('LGD_CARDPREFIX').value;
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
	var totalTaxFreeAmt = 0;
	var totalPayAmt = 0;
	var payAmt = 0;
	
	var v;
	
	$(function() {
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
		v.add("tel1", {
			"format" : "numeric",
			"max" : 4
		});
		v.add("tel2", {
			"format" : "numeric",
			"max" : 4
		});
		v.add("tel3", {
			"format" : "numeric",
			"max" : 4
		});
		
		/*
		v.add("email1", {
			"empty" : "이메일을 입력해 주세요.",
			"max" : 100
		});
		v.add("email2", {
			"empty" : "이메일을 입력해 주세요.",
			"max" : 100
		});
		v.add("ship_email1", {
			"empty" : "이메일을 입력해 주세요.",
			"max" : 100
		});
		v.add("ship_email2", {
			"empty" : "이메일을 입력해 주세요.",
			"max" : 100
		});
		*/

		v.add("ship_name", {
			"empty" : "수취인 이름을 입력해 주세요.",
			"max" : 10
		});
		v.add("ship_post_no", {
			"empty" : "우편번호를 입력해 주세요."
		});
		v.add("ship_addr1", {
			"empty" : "주소를 입력해 주세요."
		});
		v.add("ship_addr2", {
			"empty" : "주소를 입력해 주세요."
		});
		v.add("ship_mobile2", {
			"empty" : "수취인 휴대폰번호를 입력해 주세요.",
			"format" : "numeric",
			"max" : 4
		});
		v.add("ship_mobile3", {
			"empty" : "수취인 휴대폰번호를 입력해 주세요.",
			"format" : "numeric",
			"max" : 4
		});
		v.add("ship_tel1", {
			"format" : "numeric",
			"max" : 4
		});
		v.add("ship_tel2", {
			"format" : "numeric",
			"max" : 4
		});
		v.add("ship_tel3", {
			"format" : "numeric",
			"max" : 4
		});
		
<%
	if(fs.isLogin()) {
%>
		setAddr("1");
<%
	}
%>

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
	
	function changeEmail3(n, v) {
		if(n == '1') {
			if(v == '') {
				$("#email2").val("");
				$("#email2").prop("readonly", "");
			} else {
				$("#email2").val(v);
				$("#email2").prop("readonly", "readonly");
			}
		} else {
			if(v == '') {
				$("#ship_email2").prop("readonly", "");
				$("#ship_email2").val("");
			} else {
				$("#ship_email2").prop("readonly", "readonly");
				$("#ship_email2").val(v);
			}
		}
	}
	
	function copyInfo() {
		var b = $("#copyinfo").prop("checked");
		$("#ship_name").val(b ? $("#name").val() : "");
		$("#ship_mobile1").val(b ? $("#mobile1").val() : "010");
		$("#ship_mobile2").val(b ? $("#mobile2").val() : "");
		$("#ship_mobile3").val(b ? $("#mobile3").val() : "");
		$("#ship_tel1").val(b ? $("#tel1").val() : "010");
		$("#ship_tel2").val(b ? $("#tel2").val() : "");
		$("#ship_tel3").val(b ? $("#tel3").val() : "");
		$("#ship_email1").val(b ? $("#email1").val() : "");
		$("#ship_email2").val(b ? $("#email2").val() : "");
	}
	
	function orderProc() {
		if(isEarlyOnly && $("input[name=delivery_type]:checked").val() == "1") {
			alert("새벽배송전용상품은 택배배송으로 주문이 불가능합니다.");
			return;
		}

		if(v.validate()) {
<%
	if(!fs.isLogin()) {
%>
			/*
			if(!$("#agree1").prop("checked")) {
				alert("비회원구매 개인정보 취급방침 동의는 필수입니다.");
				reutrn;
			}
			*/
<%
	}
%>
			/*
			if(!$("#agree2").prop("checked")) {
				alert("결제대행서비스 이용동의는 필수입니다.");
				reutrn;
			}
			
			if(!$("#agree3").prop("checked")) {
				alert("주문내역 동의는 필수입니다.");
				reutrn;
			}
			*/

			if($("input[name=delivery_type]:checked").val() == "5" && $("input[name=early_note1]:checked").val() == "비밀번호" && $("input[name=early_pw]").val() == '') {
				alert("공동현관 비밀번호를 입력하세요.");
				return;
			}

			if(!$("#agree").prop("checked")) {
				alert("이용동의는 필수입니다.");
				return;
			}

<%
	if(fs.isLogin()) {
%>
			// 포인트 체크
			var point = parseInt($("#point_amt").val().replace(/,/g, ""));
			if(point % 10 != 0) {
// 				alert("Maeil Do 포인트는 10P 단위로 사용 가능합니다.");
				alert("100P 이상 가지고 계실 때, 10P 단위로 사용가능합니다.");
				return;
			}
<%
	}
%>

			if($("input[name=pay_type]:checked").length == 0) {
				alert("결제수단을 선택하세요.");
				return;
			}

			$("#LGD_BUYER").val($("#name").val());
			$("#LGD_BUYEREMAIL").val($("#email1").val() + "@" + $("#email2").val());
			$("#LGD_BUYERPHONE").val($("#mobile1").val() + $("#mobile2").val() + $("#mobile3").val());
			$("#orderForm input[name=BuyerName]").val($("#name").val());
			$("#orderForm input[name=BuyerEmail]").val($("#email1").val() + "@" + $("#email2").val());
			$("#orderForm input[name=LGD_AMOUNT]").val(payAmt);
			$("#orderForm input[name=Amt]").val(payAmt);
			$("#paycoReserveForm input[name=totalPaymentAmt]").val(payAmt);

			// 면세 금액 조정
			if(payAmt < totalTaxFreeAmt) {
				$("#orderForm input[name=LGD_TAXFREEAMOUNT]").val(payAmt);
				$("#paycoReserveForm input[name=totalTaxfreeAmt]").val(payAmt);

				$("#orderForm input[name=SupplyAmt]").val(payAmt);
				$("#orderForm input[name=GoodsVat]").val(0);
				$("#orderForm input[name=ServiceAmt]").val(0);
				$("#orderForm input[name=TaxationAmt]").val(payAmt);
			} else {
				var _taxationAmt = payAmt - totalTaxFreeAmt;
				var _goodsVat = parseInt(_taxationAmt / 11);
				var _supplyAmt = payAmt - _goodsVat;
				
// 				console.log(_taxationAmt + ":" + _goodsVat + ":" + _supplyAmt);
				
				$("#orderForm input[name=SupplyAmt]").val(_supplyAmt);
				$("#orderForm input[name=GoodsVat]").val(_goodsVat);
				$("#orderForm input[name=ServiceAmt]").val(0);
				$("#orderForm input[name=TaxationAmt]").val(_taxationAmt);
			}
			
			$("#orderForm").attr("action", "<%= Env.getSSLPath() %>/order/orderProc.jsp");

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
					$("#orderForm").submit();
				}
			} else if($("input[name=pay_type]:checked").val() == "008") {	// smilepay
				/*
				if(payAmt != totalPayAmt) {	// 쿠폰, 포인트로 인해 금액이 변동된 경우
					$("#hashSmilepayForm input[name=amt]").val(payAmt);
					ajaxSubmit("#hashSmilepayForm", function(json) {
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
				*/
				
				$("#orderForm").attr("action", "<%= Env.getSSLPath() %>/mobile/order/orderSessionSmilePay.jsp");
				$("#orderForm").submit();
			} else if($("input[name=pay_type]:checked").val() == "006") {	// Payco
				callPaycoUrl();
			} else if($("input[name=pay_type]:checked").val() == "007") {	// 카카오페이2
				if(payAmt != totalPayAmt) {	// 쿠폰, 포인트로 인해 금액이 변동된 경우
					$("#kakaopayReadyForm input[name=total_amount]").val(payAmt);
				}

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
				} else if($("input[name=pay_type]:checked").val() == "011") {
					$("#LGD_CUSTOM_USABLEPAY").val("SC0010");
					$("#LGD_EASYPAY_ONLY").val("TOSSPAY");
				} 
				
				$("#orderForm").attr("action", "<%= Env.getSSLPath() %>/mobile/order/orderSession.jsp");
				if(payAmt != totalPayAmt) {	// 쿠폰, 포인트로 인해 금액이 변동된 경우
					$("#hashForm input[name=LGD_AMOUNT]").val(payAmt);
					ajaxSubmit("#hashForm", function(json) {
						if(json.result) {
							$("#orderForm input[name=LGD_HASHDATA]").val(json.hash);
// 							launchCrossPlatform();
							$("#orderForm").submit();
						} else {
							alert("결제 진행중 오류가 발생했습니다.");
						}
					});
				} else {
// 					launchCrossPlatform();
					$("#orderForm").submit();
				}
			}			
		}
	}
	//나의 배송 주소록
	function showAddressListPop() {
		showPopupLayer('/mobile/popup/popAddressList.jsp');
	}

	function showMyAddressPop() {
		showPopupLayer('/mobile/popup/popMyAddress.jsp?mode=COPY');
	}
	
	function setAddr(n) {
		if(n == '2') {
			$("#ship_name").val('');
			$("#ship_post_no").val('');
			$("#ship_addr1").val('');
			$("#ship_addr2").val('');
			$("#ship_mobile1").val('010');
			$("#ship_mobile2").val('');
			$("#ship_mobile3").val('');
			$("#ship_tel1").val('');
			$("#ship_tel2").val('');
			$("#ship_tel3").val('');
		} else {
			var mode = n == '1' ? "SET_DEFAULT" : "SET_LATEST";
			var url = "/mobile/mypage/order/addrProc.jsp?mode=" + mode;
			
			$.getJSON(url, function(json) {
				if(!json.result) {
					alert(json.msg);
				} else {
					$("#ship_name").val(json.name);
					$("#ship_post_no").val(json.post_no);
					$("#ship_addr1").val(json.addr1);
					$("#ship_addr2").val(json.addr2);
					$("#ship_mobile1").val(json.mobile1);
					$("#ship_mobile2").val(json.mobile2);
					$("#ship_mobile3").val(json.mobile3);
					$("#ship_tel1").val(json.tel1);
					$("#ship_tel2").val(json.tel2);
					$("#ship_tel3").val(json.tel3);
				}
			});
		}
		
		checkEarly();
	}
	
	function applyCoupon(v) {
		resetPoint();
		resetCoupon();
		resetGiftcard();
		
		$.ajax({
			method : "GET",
			url : "/ajax/couponInfo.jsp",
			data : { mem_couponid : v },
			dataType : "json",
			async : false
		})
		.done(function(json) {
			console.log("cartinfo", json);
			var _amt = json.COUPON_AMT;
			var _type = json.COUPON_TYPE;
			
			$("#mem_couponid").val(v);
			$("#coupon_amt").val(_amt.formatMoney());
			$("#coupon_amt_txt").html(_amt.formatMoney());

			calAmt();
		});

	}
	
	/*
	function applyCoupon(coupons, amt) {
		resetPoint();
		resetCoupon();
		resetGiftcard();
		
		$("#coupon_amt").val(amt.formatMoney());

		for(var i = 0; i < coupons.length; i++) {
			var coupon = coupons[i].coupon.split("|");
			
			if(coupons[i].coupon_type == "001") {	// 상품쿠폼
				$("#mem_couponid_" + coupons[i].cartid).val(coupon[0]);
			} else if(coupons[i].coupon_type == "002") {	// 장바구니 쿠폰
				$("#mem_couponid_cart").val(coupon[0]);
			} else if(coupons[i].coupon_type == "003") {	// 배송비 쿠폰
				$("#mem_couponid_ship").val(coupon[0]);
			}

			$("#couponListArea").append("<li>" + coupon[4] + "<span class=\"fontTypeA\"><strong>" + coupons[i].coupon_amt.formatMoney() + "</strong>원</span></li>");
			
			calAmt();
		}
	}
	*/
	
	function resetCoupon() {
/*
<%
	for(Param row : list1) {
%>
		$("#mem_couponid_<%= row.get("cartid") %>").val("");
<%
	}

	for(Param row : list2) {
%>
		$("#mem_couponid_<%= row.get("cartid") %>").val("");
<%
	}

	for(Param row : list3) {
%>
		$("#mem_couponid_<%= row.get("cartid") %>").val("");
<%
	}

	for(Param row : list4) {
%>
		$("#mem_couponid_<%= row.get("cartid") %>").val("");
<%
	}
%>
*/
		$("#mem_couponid").val("");
// 		$("#mem_couponid_cart").val("");
// 		$("#mem_couponid_ship").val("");
		$("#coupon_amt").val("0");
		$("#couponListArea").empty();
	}
	
	function applyPoint() {
		var point = parseInt($("#point_amt").val().replace(/,/g, ""));

		if(point % 10 != 0) {
//				alert("Maeil Do 포인트는 10P 단위로 사용 가능합니다.");
			alert("100P 이상 가지고 계실 때, 10P 단위로 사용가능합니다.");
			$("#point_amt").val("0");
		}
		
		calAmt();
	}
	
	function pointAll() {
		$("#point_amt").val("0");
		$("#pointListArea").empty();
		calAmt();

		if($("#point_all").prop("checked")) {
			var useablePoint = <%= point %>;
			if(payAmt > useablePoint) {
				var appAmt = parseInt(useablePoint / 10) * 10;
			} else {
				var appAmt = parseInt(payAmt / 10) * 10;
			}
			
			$("#point_amt").val(appAmt.formatMoney());
			calAmt();
		} else {
			resetPoint();
		}
	}
	
	function calAmt() {
		var couponAmt = parseInt($("#coupon_amt").val().replace(/,/g, ""));
		var pointAmt = parseInt($("#point_amt").val().replace(/,/g, ""));
		var giftAmt = parseInt($("#giftcard_amt").val().replace(/,/g, ""));

		if($("#point_amt").val() == "") {
			pointAmt = 0;
		} else {
			$("#point_amt").val(pointAmt.formatMoney());
		}
		
		payAmt = totalPayAmt - couponAmt - pointAmt - giftAmt;
		
		if(pointAmt > 0) {
			$("#pointListArea").html("<li>Maeil Do 포인트<span class=\"fontTypeA\"><strong>" + $("#point_amt").val() + "</strong>P</span></li>");
		} else {
			$("#pointListArea").empty();
		} 
		if(payAmt < 0) {
			resetPoint();
			return;
		} else if(pointAmt > <%= point %>) {
			alert("보유 포인트를 초과하였습니다.");
			resetPoint();
			return;
		}
		
		if(giftAmt > 0) {
			$("#giftListArea").html("<li>기프트 카드<span class=\"fontTypeA\"><strong>" + $("#giftcard_amt").val() + "</strong>원</span></li>");
		} 

		$("#totalSaleAmt").html("-" + (couponAmt + pointAmt + giftAmt).formatMoney());
		$("#totalPayAmt").html(payAmt.formatMoney());
	}
	
	function resetPoint() {
		$("#point_amt").val("0");
		$("#pointListArea").empty();
		$("#point_all").prop("checked", false);
		calAmt();
	}
	
	function layerClose(obj){
		$('.bgLayer2').hide();
		$(obj).hide();
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
	
	function showGift() {
		showPopupLayer('/mobile/popup/giftCard.jsp?pay_amt=' + payAmt, '500');		
	}
	
	function resetGiftcard() {
		$("#giftcard_id").val("");
		$("#giftcard_amt").val("0");
		$("#giftListArea").empty();
	}
	
	function applyGiftcard(cardid, amt, receipt, cardnum) {
		$("#giftcard_id").val(cardid);
		$("#giftcard_amt").val(amt);
		$("#LGD_CASHRECEIPTUSE").val(receipt);
		$("#LGD_CASHCARDNUM").val(cardnum);
		calAmt();
	}

	function kakaopay(token) {
// 		console.log("token : " + token);
		$("#pg_token").val(token);
		$("#orderForm").submit();
	}

    function kakaopayPopClose() {
    	hidePopupLayer();
    }
    $("input[name=deliType]").on("change", function(){
		if($(this).is(":checked")){
			$(this).parents("label").addClass("on").siblings().removeClass("on")
		}
	})
</script>
</head>  
<body>
<div id="wrapper">
<!-- 팝업 -->
<div class="cardPop" style="display:none">
	<div>
		<p><strong>잠깐만요!</strong></p>
		<p class="popTxt">현대카드 프로모션 상품으로<br>the Black, the Purple카드<br>결제 시 20% 할인 혜택이<br>제공됩니다. 그 외 카드 결제<br>시 승인 후 자동 취소됩니다.</p>
		<div class="popBtn"><a href="#" onClick="layerClose('.cardPop');return false;">확인</a></div>
		<a href="#" onClick="layerClose('.cardPop');return false;" class="btnClose"><img src="/images/btn/btn_close5.gif" alt="닫기"></a>
	</div> 	
	</div>
<div class="bgLayer2" style="display:none"></div>
<!-- //팝업 -->

	<jsp:include page="/mobile/include/header.jsp" /> 	
	<div id="container">
	<!-- 내용영역 -->
		<form name="orderForm" id="orderForm" method="POST" action="<%= Env.getSSLPath() %>/order/orderProc.jsp">
			<input type="hidden" name="orderid" value="<%= orderid %>" />
		<div class="orderTit">
			<h1>주문/결제</h1>
			<ul class="step">
				<li><span>장바구니</span></li>
				<li class="on"><span>주문/결제</span></li>
				<li><span>주문완료</span></li>
			</ul>
		</div>
		
		<h2 class="typeA">주문자 정보 <span class="fs"><em>*</em> 필수입력항목</span></h2>
		<table class="bbsForm">
			<caption>주문자 정보 입력폼</caption>
			<colgroup>
				<col width="75"><col width="">
			</colgroup>
			<tr>
				<th scope="row">성명 <em>*</em></th>
				<td><input type="text" name="name" id="name" value="<%= fs.getUserNm() %>" title="주문자 성명" style="width:100%"></td>
			</tr>
			<tr>
				<th scope="row">휴대전화 <em>*</em></th>
				<td>
					<select name="mobile1" id="mobile1" title="주문자 휴대전화 앞자리" style="width:60px">
<%
	for(String mobile : SanghafarmUtils.MOBILES) {
%>
						<option value="<%= mobile %>" <%= mobile.equals(fs.getMobile1()) ? "selected" : "" %>><%= mobile %></option>
<%
	}
%>
					</select>&nbsp;-
					<input type="tel" name="mobile2" id="mobile2" value="<%= fs.getMobile2() %>" title="주문자 휴대전화 가운데자리" style="width:60px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">&nbsp;-
					<input type="tel" name="mobile3" id="mobile3" value="<%= fs.getMobile3() %>" title="주문자 휴대전화 뒷자리" style="width:60px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">
				</td>
			</tr>
			<tr>
				<th scope="row">일반전화</th>
				<td>					
					<input type="tel" name="tel1" id="tel1" title="주문자 일반전화 앞자리" style="width:60px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">&nbsp;-
					<input type="tel" name="tel2" id="tel2" title="주문자 일반전화 가운데자리" style="width:60px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">&nbsp;-
					<input type="tel" name="tel3" id="tel3" title="주문자 일반전화 뒷자리" style="width:60px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">
				</td>
			</tr>
			<tr>
				<th scope="row">이메일</th>
				<td>
					<input type="text" name="email1" id="email1" value="<%= fs.getEmail1() %>" title="주문자 이메일 앞자리" style="width:80px">&nbsp;@
					<input type="text" name="email2" id="email2" value="<%= fs.getEmail2() %>" title="주문자 이메일 뒷자리" style="width:110px"><br>
					<select name="email3" id="email3" onchange="changeEmail3('1', this.value)" title="주문자 이메일 뒷자리 선택" style="width:150px;margin-top:5px">
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
		</table><!-- //주문자정보 -->
		<div id="layer" style="display:none;position:absolute;overflow:hidden;z-index:1;-webkit-overflow-scrolling:touch;">
			<img src="//i1.daumcdn.net/localimg/localimages/07/postcode/320/close.png" id="btnCloseLayer" style="cursor:pointer;position:absolute;width:20px;height:20px;right:-3px;top:-3px;z-index:1" onclick="closeDaumPostcode()" alt="닫기 버튼">
		</div>
		<h2 class="typeA">배송지 정보 <span class="fs"><em>*</em> 필수입력항목</span></h2>
		<table class="bbsForm">
			<caption>배송지 정보 입력폼</caption>
			<colgroup>
				<col width="75"><col width="">
			</colgroup>
<%
	if(fs.isLogin()) {
%>
			<tr>
				<th scope="row">배송지선택</th>
				<td>
					<p class="dib"><input type="radio" name="addr_type" value="1" onclick="setAddr(this.value)" id="addr1" checked><label for="addr1">기본배송지</label></p>
					<p class="dib"><input type="radio" name="addr_type" value="2" onclick="setAddr(this.value)" id="addr2"><label for="addr2">새로운배송지</label></p>
					<p class="dib"><input type="radio" name="addr_type" value="3" onclick="setAddr(this.value)" id="addr3"><label for="addr3">최근배송지</label></p><br>
					<p class="ar" style="margin-top:5px"><a href="#none" onclick="showPopupLayer('/mobile/popup/addressList.jsp'); return false" class="btnTypeA sizeS">나의 배송주소록</a></p>
				</td>
			</tr>
<%
	}
%>
			<tr>
				<th scope="row">성명 <em>*</em></th>
				<td>
					<input type="text" name="ship_name" id="ship_name" title="수취인 성명" style="width:100%">
					<label><input type="checkbox" name="copyinfo" id="copyinfo" onclick="copyInfo()">위 주문자 정보와 동일하게 입력</label>
				</td>
			</tr>
			<tr>
				<th scope="row">휴대전화 <em>*</em></th>
				<td>
					<select name="ship_mobile1" id="ship_mobile1" title="수취인 휴대전화 앞자리" style="width:60px">
<%
	for(String mobile : SanghafarmUtils.MOBILES) {
%>
						<option value="<%= mobile %>"><%= mobile %></option>
<%
	}
%>
					</select>&nbsp;-
					<input type="tel" name="ship_mobile2" id="ship_mobile2" title="수취인 휴대전화 가운데자리" style="width:60px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">&nbsp;-
					<input type="tel" name="ship_mobile3" id="ship_mobile3" title="수취인 휴대전화 뒷자리" style="width:60px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">
				</td>
			</tr>
			<tr>
				<th scope="row">일반전화</th>
				<td>					
					<input type="tel" name="ship_tel1" id="ship_tel1" title="수취인 일반전화 앞자리" style="width:60px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">&nbsp;-
					<input type="tel" name="ship_tel2" id="ship_tel2" title="수취인 일반전화 가운데자리" style="width:60px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">&nbsp;-
					<input type="tel" name="ship_tel3" id="ship_tel3" title="수취인 일반전화 뒷자리" style="width:60px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">
				</td>
			</tr>
			<tr>
				<th scope="row">이메일</th>
				<td>
					<input type="text" name="ship_email1" id="ship_email1" title="수취인 이메일 앞자리" style="width:80px">&nbsp;@
					<input type="text" name="ship_email2" id="ship_email2" title="수취인 이메일 뒷자리" style="width:110px"><br>
					<select name="ship_email3" id="ship_email3" onchange="changeEmail3('2', this.value)" title="수취인 이메일 뒷자리 선택" style="width:150px;margin-top:5px">
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
			<tr style="border:0">
				<th scope="row">배송지 <em>*</em></th>
				<td>
					<input type="text" name="ship_post_no" id="ship_post_no" value="<%= fs.getZipCode() %>" title="배송지 우편번호" style="width:60px" readonly>
					<a href="javascript:execDaumPostcode()" class="btnTypeA sizeS">우편번호찾기</a><br>
					<input type="text" name="ship_addr1" id="ship_addr1" readonly value="<%= fs.getAddr1() %>" title="배송지 주소" style="width:100%;margin-top:5px"><br>
					<input type="text" name="ship_addr2" id="ship_addr2" value="<%= fs.getAddr2() %>" title="배송지 상세주소" style="width:100%;margin-top:5px" placeholder="상세주소 입력">
<!-- 					<a href="javascript:checkEarly()" class="btnTypeA sizeS">새벽 배송 가능지역 확인하기 &gt;</a><br> -->
					<p class="earlyText" style="display:none">새벽배송 가능 지역입니다.</p>
					<p class="text fontTypeG">*신선제품의 경우 제주/도서산간 지역은 배송이 2일 이상 소요될 수 있으므로 휴일 또는 주말 전 주문하실 경우 신선도가 저하될 수 있습니다.</p>
				</td>
			</tr>
			<tr><td colspan="2" style="height:0;padding:0">				
				<div id="zipArea" style="display:none;border:1px solid;width:300px;height:300px;position:relative;margin-bottom:8px; float:right">
					<img src="//t1.daumcdn.net/localimg/localimages/07/postcode/320/close.png" id="btnFoldWrap" style="cursor:pointer;position:absolute;right:0px;top:-1px;z-index:1;width:20px;" onclick="foldDaumPostcode()" alt="접기 버튼">
				</div>
				<div class="cb"></div>
			</td></tr>
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
					<input type="text" name="ship_memo" id="ship_memo" style="display:none; margin-top:5px; width:100%"><!-- 직접입력 선택시 show-->
				</td>
			</tr>
			<tr>
				<th scope="row">품절 옵션</th>
				<td>
 					<select name="soldout_opt">
<%
	for(Param row : soldoutOptList) {
%>
						<option value="<%= row.get("code2") %>"><%= row.get("name2") %></option>
<%
	}
%>
					</select><br>
				</td>
			</tr>
<%
	if(!fs.isLogin()) {
%>
			<tr>
				<th scope="row">수신동의</th>
				<td>
					<input type="checkbox" name="email_yn" id="email_yn" value="Y"><label for="agreeemail">이메일</label>
					<input type="checkbox" name="sms_yn" id="sms_yn" value="Y"><label for="agreesms">휴대폰 (SMS등)</label>
					<p class="text">*온라인 결제정보 및 주문정보를 이메일이나 모바일로 받아 보시려면 수신동의를 체크해 주세요.</p>
				</td>
			</tr>
<%
	}
%>
		</table><!-- //배송지정보 -->
		
		<h2 class="typeA">배송방법 선택</h2>
		<div class="deliType">
			<label class="early" style="display:none">
				<input type="radio" name="delivery_type" id="delivery_type5" value="5" onclick="early('5')">
				<p class="tit">새벽배송</p>
				주 6일 출고(일~금)<br>
				오후 6시까지 주문시 내일 아침 7시 전 도착<br>
				(산지직송/지정일배송 상품은 새벽배송 불가)
			</label>
			<label>
				<input type="radio" name="delivery_type" id="delivery_type1" value="1" checked onclick="early('1')">
				<p class="tit">택배배송</p>
				주6일 출고(일,월,화,수,목,금)
				<br>오후 3시까지 주문 시 다음날 도착(제주 및 도서산간 지역은 2일 소요)
				<br>*산지직송 상품은 오전 10시까지 주문 마감 (산지 사정에 따라 변경될 수 있습니다.)
			</label>
		</div><!-- //배송방법 선택 -->
		
		<div id="earlyInfo" style="display:none">
		<h2 class="typeA">새벽배송 정보 입력</h2>
		<table class="bbsForm">
			<caption>새벽배송 정보 입력폼</caption>
			<colgroup>
				<col width="75"><col width="">
			</colgroup>
			<tr>
				<th scope="row">공동 현관 <br>출입 방법</th>
				<td>
					<p class="dib"><input type="radio" name="early_note1" id="en1" value="비밀번호" onclick="$('input[name=early_pw]').prop('disabled', false);" checked><label for="en1">비밀번호</label></p>
					<p class="dib"><input type="radio" name="early_note1" id="en2" value="경비실호출" onclick="$('input[name=early_pw]').prop('disabled', true);"><label for="en2">경비실호출</label></p>
					<p class="dib"><input type="radio" name="early_note1" id="en3" value="자유 출입 가능" onclick="$('input[name=early_pw]').prop('disabled', true);"><label for="en3">자유 출입 가능</label></p>
				</td>
			</tr>
			<tr>
				<th scope="row">공동 현관 <br>비밀번호</th>
				<td>
					<input type="text" name="early_pw" style="width:100%">
				</td>
			</tr>
			<tr>
				<th scope="row">추가 <br>요청사항</th>
				<td>
					<textarea style="width:100%;height:90px" name="early_note2"></textarea>
				</td>
			</tr>
			<tr>
				<th scope="row">새벽배송 <br>도착 알림</th>
				<td>
					<p class="dib"><input type="radio" name="early_sms" id="es1" value="X" checked><label for="es1">오전 7시 이후 알려주세요.</label></p>
					<p class="dib"><input type="radio" name="early_sms" id="es2" value="O"><label for="es2">새벽배송 도착 즉시 알려주세요</label></p>
				</td>
			</tr>
		</table><!-- //새벽배송 정보 입력 -->
		
		<div class="warningBox">
			<h2>꼭 확인해주세요!</h2>
			<ul>
				<li>다음의 경우 공동현관 앞 또는 경비실 앞으로 대응배송이 될 수 있습니다.
					<ul>
						<li>입력해 주신 비밀번호가 없거나 비밀번호가 일치하지 않는 경우</li>
						<li>기기 오작동 또는 경비원의 부재로 공동현관 출입이 원활하지 않을 경우</li>
						<li>기타 공동현관 출입이 불가하여 자택 앞으로 배송할 수 없는 경우</li>
					</ul>
				</li>
				<li>비밀번호는 배송 목적으로만 사용 후 안전하게 폐기합니다.</li>
				<li>공동현관 출입 방법을 정확하게 입력해 주세요.</li>
				<li>도착 알림을 [새벽배송 도착 즉시]로 선택하실 경우, 시간에 관계없이 배송완료 시점에 문자안내를 드립니다.</li>
			</ul>
		</div>
		</div>
				
		<h2 class="typeA">주문상품 확인</h2>
		<div class="orderPdtList typeB">
			<ul>
<%
	int totalPrice = 0;
	int totalTaxFreeAmt = 0;
	int totQty = 0;

	// 배송비 계산 -----------------
	int totalPrice1 = 0;
	for(Param row : list1) {
		totalPrice1 += row.getInt("sale_price") * row.getInt("qty");
	}
	int shipAmt1 = totalPrice1 == 0 ? 0 : (totalPrice1 >= Config.getInt("shipping.free.amt") ? 0 : Config.getInt("shipping.amt"));

	int totalPrice2 = 0;
	for(Param row : list2) {
		totalPrice2 += row.getInt("sale_price") * row.getInt("qty");
	}
	int shipAmt2 = totalPrice2 == 0 ? 0 : (totalPrice2 >= Config.getInt("shipping.free.amt") ? 0 : Config.getInt("shipping.amt"));
	
	int totalPrice4 = 0;
	for(Param row : list4) {
		totalPrice4 += row.getInt("sale_price") * row.getInt("qty");
	}
	int shipAmt4 = totalPrice4 == 0 ? 0 : (totalPrice4 >= Config.getInt("shipping.free.amt") ? 0 : Config.getInt("shipping.amt"));
	
	int shipAmt = shipAmt1 + shipAmt2 + shipAmt4;
	//-----------------------------------------
	
	// JSONArray for Npay
	JSONArray jsonArr = new JSONArray();

	// 일반상품
	for(int i = 0; i < list1.size(); i++) {
		Param row = list1.get(i);

		pnm = row.get("sub_pnm");
		pid = row.get("sub_pid");
		
		int amt = row.getInt("sale_price") * row.getInt("qty");
		totalPrice += amt;
		totQty += row.getInt("qty");

		if("N".equals(row.get("tax_yn"))) {
			totalTaxFreeAmt += amt;
		}

		if("N".equals(row.get("sale_status"))) { // 미판매 상품
			soldOutList2.add(row);
		} else if(row.getInt("qty") > row.getInt("stock")) { // 재고수량이 주문수량보다 적을 경우
			soldOutList1.add(row);
		}
%>
				<li>
					<p class="thumb"><a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%= row.get("opt_thumb") %>" alt=""></a></p>
					<div class="content">
						<div class="tit"><a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>">
<%-- 							<input type="hidden" name="mem_couponid_<%= row.get("cartid") %>" id="mem_couponid_<%= row.get("cartid") %>" value="" /> --%>
							<%= row.get("pnm") %>
							<p class="opt"><%= row.get("sub_opt_pnm") %></p>
						</a></div>
						<p class="price"><strong><%= Utils.formatMoney(row.getInt("sale_price") * row.getInt("qty")) %></strong>원</p>
						<p class="cnt"><strong><%= row.get("qty") %></strong>개</p>	
					</div>
				</li>
<%
		if(i == list1.size()-1) {
%>
				<li class="delivery">	
					<p>
						<span class="d1">일반배송(택배배송)</span><br><%= Utils.formatMoney(totalPrice1) %>원 + 배송비 <%= shipAmt1 == 0 ? "무료" : Utils.formatMoney(shipAmt1) + "원" %>
<%
			if(shipAmt1 > 0) {
%>
						<span class="free"><%= Utils.formatMoney(Config.getInt("shipping.free.amt") - totalPrice1) %>원 추가주문시, <strong>무료배송</strong></span>
<%
			}
%>
					</p>					
				</li>
<%
		}
%>
<%
		// 쿠폰
		if(fs.isLogin()) {
			Param p = new Param();
			p.set("userid", fs.getUserId());
			p.set("device_type", fs.getDeviceType());
			p.set("grade_code", fs.getGradeCode());
			p.set("pid", row.get("sub_pid"));
			p.set("min_price", amt);
			
			List<Param> cList = coupon.getApplyableList(p);
			for(Param c : cList) {
				if(!couponList.contains(c.get("mem_couponid"))) {
					couponList.add(c.get("mem_couponid"));
				}
			}
		}

		// 현대카드 할인상품
		if(SanghafarmUtils.isHyundaiPromotionPid(row.get("sub_pid"))) {
			existsHyundaiCardPid = true;
		}

		// 2주년 프로모션 체크
		if("S".equals(saInfo.get("status"))) {
			if(!fs.isLogin()) { 
				if(saList.contains(row.get("sub_pid"))) {
					saList1.add(row);
				}
			} else {
				if(saList.contains(row.get("sub_pid"))) {
					List<Param> l = sa.getOrderList(new Param("userid", fs.getUserId(), "pid", row.get("sub_pid")));
					if(l != null && l.size() > 0) {
						saList2.add(row);
					}
				}
				
				if(saList.contains(row.get("sub_pid")) && row.getInt("qty") > saInfo.getInt("buy_avail_qty")) {
					saList3.add(row);
				}
			}
			
			// 동일 상품 체크
			boolean isSame = false;
			for(int j = 0; j < saList4.size(); j++) {
				Param p = saList4.get(j);
				if(p.get("sub_pid").equals(row.get("sub_pid"))) {
					p.set("qty", p.getInt("qty") + row.getInt("qty"));
					saList4.remove(j);
					saList4.add(j, p);
					isSame = true;
					break;
				}
			}
			
			if(!isSame) {
				Param p = new Param("pid", row.get("pid"), "sub_pid", row.get("sub_pid"), "qty", row.get("qty"));
				saList4.add(p);
			}
		}
		
		// JSONObject for Npay
		JSONObject json = new JSONObject();
		json.put("categoryType", "PRODUCT");
		json.put("categoryId", "GENERAL");
		json.put("uid", row.get("sub_pid"));
		json.put("name", row.get("sub_opt_pnm"));
		json.put("count", row.getInt("qty"));
		
		jsonArr.add(json);
		
		// 새벽배송전용여부
		if("Y".equals(row.get("early_only"))) isEarlyOnly = true;
	}

	// 산지직송 상품
	for(int i = 0; i < list2.size(); i++) {
		Param row = list2.get(i);

		pnm = row.get("sub_pnm");
		pid = row.get("sub_pid");
		int amt = row.getInt("sale_price") * row.getInt("qty");
		totalPrice += amt;
		totQty += row.getInt("qty");

		if("N".equals(row.get("tax_yn"))) {
			totalTaxFreeAmt += amt;
		}

		if("N".equals(row.get("sale_status"))) { // 미판매 상품
			soldOutList2.add(row);
		} else if(row.getInt("qty") > row.getInt("stock")) { // 재고수량이 주문수량보다 적을 경우
			soldOutList1.add(row);
		}
%>
				<li>
					<p class="thumb"><a href="/mobile/product/detail.jsp?pid="<%= row.get("pid") %>"><img src="<%= row.get("opt_thumb") %>" alt=""></a></p>
					<div class="content">
						<div class="tit"><a href="/mobile/product/detail.jsp?pid="<%= row.get("pid") %>">
<%-- 							<input type="hidden" name="mem_couponid_<%= row.get("cartid") %>" id="mem_couponid_<%= row.get("cartid") %>" value="" /> --%>
							<%= row.get("pnm") %>
							<p class="opt"><%= row.get("sub_opt_pnm") %></p>
						</a></div>
						<p class="price"><strong><%= Utils.formatMoney(row.getInt("sale_price") * row.getInt("qty")) %></strong>원</p>
						<p class="cnt"><strong><%= row.get("qty") %></strong>개</p>
					</div>
				</li>
<%
		if(i == list2.size()-1) {
%>
				<li class="delivery">	
					<p>
						산지직송 묶음(택배배송)<br><%= Utils.formatMoney(totalPrice2) %>원 + 배송비 <%= shipAmt2 == 0 ? "무료" : Utils.formatMoney(shipAmt2) + "원" %>
<%
			if(shipAmt2 > 0) {
%>
						<span class="free"><%= Utils.formatMoney(Config.getInt("shipping.free.amt") - totalPrice2) %>원 추가주문시, <strong>무료배송</strong></span>
<%
			}
%>
					</p>
				</li>
<%
		}
%>				
<%
		// 쿠폰
		if(fs.isLogin()) {
			Param p = new Param();
			p.set("userid", fs.getUserId());
			p.set("device_type", fs.getDeviceType());
			p.set("grade_code", fs.getGradeCode());
			p.set("pid", row.get("sub_pid"));
			p.set("min_price", amt);
			
			List<Param> cList = coupon.getApplyableList(p);
			for(Param c : cList) {
				if(!couponList.contains(c.get("mem_couponid"))) {
					couponList.add(c.get("mem_couponid"));
				}
			}
		}

		// 현대카드 할인상품
		if(SanghafarmUtils.isHyundaiPromotionPid(row.get("sub_pid"))) {
			existsHyundaiCardPid = true;
		}

		// 2주년 프로모션 체크
		if("S".equals(saInfo.get("status"))) {
			if(!fs.isLogin()) { 
				if(saList.contains(row.get("sub_pid"))) {
					saList1.add(row);
				}
			} else {
				if(saList.contains(row.get("sub_pid"))) {
					List<Param> l = sa.getOrderList(new Param("userid", fs.getUserId(), "pid", row.get("sub_pid")));
					if(l != null && l.size() > 0) {
						saList2.add(row);
					}
				}
				
				if(saList.contains(row.get("sub_pid")) && row.getInt("qty") > saInfo.getInt("buy_avail_qty")) {
					saList3.add(row);
				}
			}
			
			// 동일 상품 체크
			boolean isSame = false;
			for(int j = 0; j < saList4.size(); j++) {
				Param p = saList4.get(j);
				if(p.get("sub_pid").equals(row.get("sub_pid"))) {
					p.set("qty", p.getInt("qty") + row.getInt("qty"));
					saList4.remove(j);
					saList4.add(j, p);
					isSame = true;
					break;
				}
			}
			
			if(!isSame) {
				Param p = new Param("pid", row.get("pid"), "sub_pid", row.get("sub_pid"), "qty", row.get("qty"));
				saList4.add(p);
			}
		}
		
		// JSONObject for Npay
		JSONObject json = new JSONObject();
		json.put("categoryType", "PRODUCT");
		json.put("categoryId", "GENERAL");
		json.put("uid", row.get("sub_pid"));
		json.put("name", row.get("sub_opt_pnm"));
		json.put("count", row.getInt("qty"));
		
		jsonArr.add(json);
		
		// 새벽배송전용여부
		if("Y".equals(row.get("early_only"))) isEarlyOnly = true;
	}
	
	// 정기배송상품
	for(Param row : list3) {
		pnm = row.get("sub_pnm");
		pid = row.get("sub_pid");
		String routineDay = row.get("routine_day");
		routineDay = routineDay.replaceAll("1", "일");
		routineDay = routineDay.replaceAll("2", "월");
		routineDay = routineDay.replaceAll("3", "화");
		routineDay = routineDay.replaceAll("4", "수");
		routineDay = routineDay.replaceAll("5", "목");
		routineDay = routineDay.replaceAll("6", "금");
		routineDay = routineDay.replaceAll("7", "토");

		int routineSaleAmt = 0;
		int couponSaleAmt = 0;
		int price = row.getInt("sale_price") * row.getInt("qty") * row.getInt("routine_cnt");

		if("A".equals(row.get("routine_sale_type"))) {
			routineSaleAmt = row.getInt("routine_sale_amt") * row.getInt("qty") * row.getInt("routine_cnt");
		} else {
			routineSaleAmt = row.getInt("sale_price") * row.getInt("qty") * row.getInt("routine_cnt") * row.getInt("routine_sale_amt") / 100;
		}
		
		if(!"".equals(row.get("mem_couponid"))) {
			if("A".equals(row.get("sale_type"))) {
				couponSaleAmt = row.getInt("sale_amt") > row.getInt("sale_max") ? row.getInt("sale_max") : row.getInt("sale_amt"); 
			} else {
				int m = (price - routineSaleAmt) * row.getInt("sale_amt") / 100;
				couponSaleAmt = m > row.getInt("sale_max") ? row.getInt("sale_max") : m; 
			}
		}

		int amt = price - routineSaleAmt - couponSaleAmt;
		totalPrice += amt;
		totQty += row.getInt("qty") * row.getInt("routine_cnt");

		if("N".equals(row.get("tax_yn"))) {
			totalTaxFreeAmt += amt;
		}

		if("N".equals(row.get("sale_status"))) { // 미판매 상품
			soldOutList2.add(row);
		} else if(row.getInt("qty") > row.getInt("stock")) { // 재고수량이 주문수량보다 적을 경우
// 			soldOutList1.add(row);
		}

		String firstDeliveryDate = "";
		if(eventPid.equals(row.get("sub_pid"))) {
			firstDeliveryDate = SanghafarmUtils.getFirstDeliveryDate(row.get("routine_day").split(","), "yyyy-MM-dd", "20170803");
		} else {
			firstDeliveryDate = SanghafarmUtils.getFirstDeliveryDate(row.get("routine_day").split(","), "yyyy-MM-dd");
		}
%>
				<li class="regular">
					<p class="thumb"><a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%= row.get("opt_thumb") %>" alt=""></a></p>
					<div class="content">
						<div class="tit"><a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>">
<%-- 							<input type="hidden" name="mem_couponid_<%= row.get("cartid") %>" id="mem_couponid_<%= row.get("cartid") %>" value="" /> --%>
							<%= row.get("pnm") %>
							<p class="opt"><%= row.get("sub_opt_pnm") %></p>
						</a></div>
						<p class="price"><strong><%= Utils.formatMoney(amt) %></strong>원</p>
					</div>
					<div class="foot">
						<p class="cycle"><strong>정기배송상품</strong><%= row.get("routine_period") %>주마다 / <%= routineDay %> / <%= row.get("routine_cnt") %>회 / <%= firstDeliveryDate %> 부터</p>
					</div>					
				</li>
				<li class="delivery">	
					<p><span class="<%= "C".equals(row.get("ptype")) ? "" : "d2" %>">정기배송(택배배송)</span><br><%= row.get("routine_cnt") %>회*<%= Config.getInt("shipping.amt") %>원 <span class="fontTypeB">= <span class="through"><%= Utils.formatMoney(Config.getInt("shipping.amt") * row.getInt("routine_cnt")) %>원</span> <strong>무료</strong></span></p>
				</li>
<%
		// 쿠폰
		if(fs.isLogin()) {
			Param p = new Param();
			p.set("userid", fs.getUserId());
			p.set("device_type", fs.getDeviceType());
			p.set("grade_code", fs.getGradeCode());
			p.set("pid", row.get("sub_pid"));
			p.set("min_price", amt);
			
			List<Param> cList = coupon.getApplyableList(p);
			for(Param c : cList) {
				if(!couponList.contains(c.get("mem_couponid"))) {
					couponList.add(c.get("mem_couponid"));
				}
			}
		}

		// 현대카드 할인상품
		if(SanghafarmUtils.isHyundaiPromotionPid(row.get("sub_pid"))) {
			existsHyundaiCardPid = true;
		}
		
		// JSONObject for Npay
		JSONObject json = new JSONObject();
		json.put("categoryType", "PRODUCT");
		json.put("categoryId", "GENERAL");
		json.put("uid", row.get("sub_pid"));
		json.put("name", row.get("sub_opt_pnm"));
		json.put("count", row.getInt("qty"));
		
		jsonArr.add(json);
		
		// 새벽배송전용여부
		if("Y".equals(row.get("early_only"))) isEarlyOnly = true;
		if(!"C".equals(row.get("ptype"))) isEarlyAvailable = true;
	}

	// 날짜지정배송
	cal = Calendar.getInstance();
	int hour = cal.get(Calendar.HOUR_OF_DAY);
	if(hour < 10) cal.add(Calendar.DATE, 1);
	else cal.add(Calendar.DATE, 2);
	String minDate = Utils.getTimeStampString(cal.getTime(), "yyyy.MM.dd");

	for(int i = 0; i < list4.size(); i++) {
		Param row = list4.get(i);

		pnm = row.get("sub_pnm");
		pid = row.get("sub_pid");
		int amt = row.getInt("sale_price") * row.getInt("qty");
		totalPrice += amt;
		totQty += row.getInt("qty");

		if("N".equals(row.get("tax_yn"))) {
			totalTaxFreeAmt += amt;
		}

		if("N".equals(row.get("sale_status"))) { // 미판매 상품
			soldOutList2.add(row);
		} else if(row.getInt("qty") > row.getInt("stock")) { // 재고수량이 주문수량보다 적을 경우
			soldOutList1.add(row);
		}
%>
				<!-- 날짜지정배송 -->
				<li>
					<p class="thumb"><a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%= row.get("opt_thumb") %>" alt=""></a></p>
					<div class="content">
						<div class="tit"><a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>">
<%-- 							<input type="hidden" name="mem_couponid_<%= row.get("cartid") %>" id="mem_couponid_<%= row.get("cartid") %>" value=""> --%>
							<%= row.get("pnm") %>
							<p class="opt"><%= row.get("sub_opt_pnm") %></p>
						</a></div>
						<p class="price"><strong><%= Utils.formatMoney(row.getInt("sale_price") * row.getInt("qty")) %></strong>원</p>
						<p class="cnt"><strong><%= row.get("qty") %></strong>개</p>	
					</div>
					<div class="foot">
						<p class="deliveryDateCart">
							<strong>배송일</strong>
							<span><%= row.get("delivery_date") %></span>
						</p>
					</div>
				</li>
<%
		if(i == list4.size()-1) {
%>
				<li class="delivery">
					<p>
						날짜지정배송(택배배송)<br><%= Utils.formatMoney(totalPrice4) %>원 + 배송비 <%= shipAmt4 == 0 ? "무료" : Utils.formatMoney(shipAmt4) + "원" %>
<%
			if(shipAmt1 > 0) {
%>
						<span class="free"><%= Utils.formatMoney(Config.getInt("shipping.free.amt") - totalPrice4) %>원 추가주문시, <strong>무료배송</strong></span>
<%
			}
%>
					</p>
				</li>
				<!-- //날짜지정배송 -->
<%
		}

		// 쿠폰
		if(fs.isLogin()) {
			Param p = new Param();
			p.set("userid", fs.getUserId());
			p.set("device_type", fs.getDeviceType());
			p.set("grade_code", fs.getGradeCode());
			p.set("pid", row.get("sub_pid"));
			p.set("min_price", amt);
			
			List<Param> cList = coupon.getApplyableList(p);
			for(Param c : cList) {
				if(!couponList.contains(c.get("mem_couponid"))) {
					couponList.add(c.get("mem_couponid"));
				}
			}
		}

		// 현대카드 할인상품
		if(SanghafarmUtils.isHyundaiPromotionPid(row.get("sub_pid"))) {
			existsHyundaiCardPid = true;
		}

		// 2주년 프로모션 체크
		if("S".equals(saInfo.get("status"))) {
			if(!fs.isLogin()) { 
				if(saList.contains(row.get("sub_pid"))) {
					saList1.add(row);
				}
			} else {
				if(saList.contains(row.get("sub_pid"))) {
					List<Param> l = sa.getOrderList(new Param("userid", fs.getUserId(), "pid", row.get("sub_pid")));
					if(l != null && l.size() > 0) {
						saList2.add(row);
					}
				}
				
				if(saList.contains(row.get("sub_pid")) && row.getInt("qty") > saInfo.getInt("buy_avail_qty")) {
					saList3.add(row);
				}
			}
			
			// 동일 상품 체크
			boolean isSame = false;
			for(int j = 0; j < saList4.size(); j++) {
				Param p = saList4.get(j);
				if(p.get("sub_pid").equals(row.get("sub_pid"))) {
					p.set("qty", p.getInt("qty") + row.getInt("qty"));
					saList4.remove(j);
					saList4.add(j, p);
					isSame = true;
					break;
				}
			}
			
			if(!isSame) {
				Param p = new Param("pid", row.get("pid"), "sub_pid", row.get("sub_pid"), "qty", row.get("qty"));
				saList4.add(p);
			}
		}

		// 지정배송일 체크
		if(minDate.compareTo(row.get("delivery_date")) > 0) {
			isInvalidDdate = true;
		}
		
		// JSONObject for Npay
		JSONObject json = new JSONObject();
		json.put("categoryType", "PRODUCT");
		json.put("categoryId", "GENERAL");
		json.put("uid", row.get("sub_pid"));
		json.put("name", row.get("sub_opt_pnm"));
		json.put("count", row.getInt("qty"));
		
		jsonArr.add(json);
		
		// 새벽배송전용여부
		if("Y".equals(row.get("early_only"))) isEarlyOnly = true;
	}
%>
			</ul>
		</div><!-- //주문상품 확인 -->

		<div class="payment <%= fs.isLogin() ? "member" : "" %>"><!-- [dev] 회원일떄만 class=member 추가 -->
<%
	if(!fs.isLogin()) {
%>		
			<!-- 비회원 -->
			<div class="totalPrice">
				<p>상품 소계 <em><strong><%= Utils.formatMoney(totalPrice) %></strong>원</em></p>
				<p>총 배송비 <em><strong><%= Utils.formatMoney(shipAmt) %></strong>원</em></p>
				<p>총 할인 금액 <em class="fontTypeA"><strong>0</strong>원</em></p>
				<p class="total">총 결제 금액 <em class="fontTypeA"><strong><%= Utils.formatMoney(totalPrice + shipAmt) %></strong>원</em></p>
			</div>
	
		 	<h2 class="typeA">이용 동의</h2>
		 	<div class="agreeChk">
		 		<div class="section">
		 			<h3>비회원구매 개인정보 취급방침</h3>
		 			<div class="cont"><div class="scr">
						<jsp:include page="/order/agree2.jsp" />
		 			</div></div>
		 		</div>
		 		<div class="section">
		 			<h3>결제대행서비스 표준이용약관</h3>
		 			<div class="cont"><div class="scr">
						<jsp:include page="/order/agree.jsp" />
		 			</div></div>
		 		</div>
		 		<div class="section">
		 			<h3>주문내역 동의</h3>
		 			<div class="cont"><div class="scr">
						주문할 상품의 상품명, 상품가격, 배송정보를 확인하였습니다. (전자상거래법 제 8조 2항)<br>구매에 동의하시겠습니까?
		 			</div></div>
		 		</div>
		 		<!-- 2018.03.29 추가 -->
		 		<p class="agreeCheck"><input id="agree" type="checkbox"><label for="agree">구매조건을 확인하였으며, 결제대행 서비스 약관에 동의합니다.</label></p>
		 		
		 	</div><!--//이용동의 -->
		 	<!-- //비회원 -->
		 	
		 	<!-- 회원 -->
<%
	} else {
		// 장바구니 쿠폰
		Param p = new Param();
		p.set("userid", fs.getUserId());
		p.set("device_type", fs.getDeviceType());
		p.set("grade_code", fs.getGradeCode());
		p.set("coupon_type", "002");
		p.set("min_price", totalPrice);
		
		List<Param> cList = coupon.getCartApplyableList(p);
		for(Param c : cList) {
			if(!couponList.contains(c.get("mem_couponid"))) {
				couponList.add(c.get("mem_couponid"));
			}
		}

		// 배송비 쿠폰
		if(shipAmt > 0) {
			p.set("coupon_type", "003");
			
			cList = coupon.getApplyableList2(p);
			for(Param c : cList) {
				if(!couponList.contains(c.get("mem_couponid"))) {
					couponList.add(c.get("mem_couponid"));
				}
			}
		}		
%>			
		 	<h2 class="typeA">할인 받기</h2>
		 	<p class="text">※ 사용하신 할인수단의 유효기간 경과 이후 구매(결제)를 취소하시는 경우, 사용하셨던 쿠폰/포인트/기프트카드는 별도 고지 없이 바로 소멸되며 복원이 불가합니다.</p>
		 	<table class="couponForm">
		 		<caption>할인 적용 선택 폼</caption>
		 		<colgroup>
		 			<col width="110"><col width="">
		 		</colgroup>
<%
	List<Param> couponList1 = coupon.getApplyableList3(new Param("userid", fs.getUserId(), "device_type", fs.getDeviceType(), "grade_code", fs.getGradeCode()));
// 	List<Param> couponList2 = coupon.getApplyableList2(new Param("userid", fs.getUserId(), "device_type", fs.getDeviceType(), "grade_code", fs.getGradeCode(), "coupon_type", "003"));
%>
		 		<tr>
		 			<th scope="row">쿠폰<br><span class="text">(적용가능: <strong class="fontTypeA"><%= Utils.formatMoney(couponList1.size()) %></strong>개)</span></th>
		 			<td>
		 				<select name="mcoupon" style="width:100%" onchange="applyCoupon(this.value)">
		 					<option value="">쿠폰 선택</option>
<%
	for(Param row : couponList1) {
%>
		 					<option value="<%= row.get("mem_couponid") %>"><%= row.get("coupon_name") %></option>
<%
	}
// 	for(Param row : couponList2) {
%>
<%-- 							<option value="<%= row.get("mem_couponid") %>"><%= row.get("coupon_name") %></option> --%>
<%
// 	}
%>
		 				</select><br>
		 				<p class="cb">(할인 금액: <strong class="fontTypeA" id="coupon_amt_txt">0</strong>원)</p>
		 			</td>
		 		</tr>
		 		<tr>
		 			<th scope="row">Maeil Do 포인트</th>
		 			<td>
		 				<span class="fl"><input type="text" name="point_amt" id="point_amt" value="0" title="" style="ime-mode:disabled" onkeydown="return onlyNumber(event);" onkeyup="removeChar(event);" onchange="applyPoint()" <%= point < 100 ? "disabled" : "" %>>&nbsp;P</span><span class="fr"><input type="checkbox" name="point_all" id="point_all" onclick="pointAll()" <%= point < 100 ? "disabled" : "" %>><label for="point_all">모두사용</label></span>
		 				<p class="cb">(보유 포인트: <strong class="fontTypeA"><%= Utils.formatMoney(point) %></strong>P)</p>
		 			</td>
		 		</tr>
		 		<tr>
		 			<th scope="row">기프트 카드 <a href="#none" onclick="showPopupLayer('/mobile/popup/giftCardInfo.jsp'); return false" ><img src="/images/mypage/icon_question.gif" alt="안내" style="vertical-align:-2px; width:15px;"></a></th>
		 			<td>
		 				<span class="fl">
		 					<input type="text" name="giftcard_amt" id="giftcard_amt" value="0" title="" readonly>&nbsp;원
			 				<input type="hidden" name="giftcard_id" id="giftcard_id">
		 				</span>
		 				<span class="fr">
		 					<a href="#none" onclick="showGift(); return false" class="btnTypeA sizeS">조회</a>
		 					<!-- <a href="#" class="btnTypeA sizeS">적용취소</a> -->
		 				</span>
		 			</td>
		 		</tr>
		 	</table><!-- //할인받기 -->
		 	
		 	<div class="totalPrice">
				<p>상품 소계 <em><strong><%= Utils.formatMoney(totalPrice) %></strong>원</em></p>
				<p>총 배송비 <em><strong><%= Utils.formatMoney(shipAmt) %></strong>원</em></p>
				<p>할인 소계<em class="fontTypeA"><strong id="totalSaleAmt">-0</strong>원</em></p>				
				<ul id="couponListArea">
				</ul>
				<ul id="pointListArea">
				</ul>
				<ul id="giftListArea">
				</ul>
				<p class="total">총 결제예상금액 <em class="fontTypeA"><strong id="totalPayAmt"><%= Utils.formatMoney(totalPrice + shipAmt) %></strong>원</em></p>
			</div>
		 	
		 	<h2 class="typeA">이용동의</h2>
		 	<div class="agreeChk">
		 		<div class="section">
		 			<h3><label for="agree2">결제대행서비스 표준이용약관</label></h3>
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
		 		<p class="agreeCheck"><input id="agree" type="checkbox"><label for="agree">구매조건을 확인하였으며, 결제대행 서비스 약관에 동의합니다.</label></p>
		 	</div><!-- 이용동의 -->
		 	<!-- //회원 -->
<%
	}
%>		 	
		 	<h2 class="typeA">결제수단 선택</h2>
		 	<p class="discountInfo"><!-- <a href="">신용카드 별 결제 할인 안내</a> --></p>
		 	<div class="payWay">
		 		<p class="pay001"><input type="radio" name="pay_type" id="pay_001" value="001" <%= "001".equals(payType) ? "checked" : "" %>>
		 		<label for="pay_001">신용카드</label></p>

		 		<p class="pay002"><input type="radio" name="pay_type" id="pay_002" value="002" <%= "002".equals(payType) ? "checked" : "" %>>
		 		<label for="pay_002">계좌이체</label></p>

		 		<p class="pay003"><input type="radio" name="pay_type" id="pay_003" value="003" <%= "003".equals(payType) ? "checked" : "" %>>
		 		<label for="pay_003">무통장 입금</label></p>

		 		<p class="pay011"><input type="radio" name="pay_type" id="pay_011" value="011" <%= "011".equals(payType) ? "checked" : "" %>>
		 		<label for="pay_011">토스페이</label><%--<span class="tossBallon">첫 결제 2천원 캐시백</span>--%></p>

<!--		 		<p class="pay004"><input type="radio" name="pay_type" id="pay_004" value="004" <%= "004".equals(payType) ? "checked" : "" %>>
 		 		<label for="pay_004">PayNow</label></p> -->

<%
	if(!existsHyundaiCardPid) {
%>
		 		<p class="pay005"><input type="radio" name="pay_type" id="pay_007" value="007" <%= "007".equals(payType) ? "checked" : "" %>>
		 		<label for="pay_007">KakaoPay</label></p>
<%
	}
%>

		 		<p class="pay006"><input type="radio" name="pay_type" id="pay_006" value="006" <%= "006".equals(payType) ? "checked" : "" %>>
		 		<label for="pay_006">PAYCO</label></p>

		 		<p class="pay008"><input type="radio" name="pay_type" id="pay_008" value="008" <%= "008".equals(payType) ? "checked" : "" %>>
		 		<label for="pay_008">SmilePay</label></p>

		 		<p class="pay009"><input type="radio" name="pay_type" id="pay_009" value="009" <%= "009".equals(payType) ? "checked" : "" %>>
		 		<label for="pay_009">네이버페이</label></p>
		 	</div><!-- //결제수단 선택 -->
		 	<ul class="caption" id="npay_notice" style="display:none">
				<li>주문 변경 시 카드사 혜택 및 할부 적용 여부는 해당 카드사 정책에 따라 변경될 수 있습니다.</li>
		 		<li>네이버페이는 네이버ID로 별도 앱 설치 없이 신용카드 또는 은행계좌 정보를 등록하여 네이버페이 비밀번호로 결제할 수 있는 간편결제 서비스입니다.  </li>
		 		<li>결제 가능한 신용카드: 신한, 삼성, 현대, BC, 국민, 하나, 롯데, NH농협, 씨티, 카카오뱅크</li>
		 		<li>결제 가능한 은행: NH농협, 국민, 신한, 우리, 기업, SC제일, 부산, 경남, 수협, 우체국, 미래에셋대우, 광주, 대구, 전북, 새마을금고, 제주은행, 신협, 하나은행, 케이뱅크, 카카오뱅크, 삼성증권</li>
		 		<li>네이버페이 카드 간편결제는 네이버페이에서 제공하는 카드사 별 무이자, 청구할인 혜택을 받을 수 있습니다.</li>
			</ul>	
		 	<p class="paySave"><input type="checkbox" name="save_pay_type" id="save" value="Y" checked><label for="save">마지막 결제수단 저장하기</label></p>
	 	</div>
	 	
		<div class="btnArea">
			<span><a href="/mobile/order/cart.jsp" class="btnTypeA sizeL">장바구니</a></span>
			<span><a href="javascript:orderProc()" class="btnTypeB sizeL">결제하기</a></span>
		</div>
<%
	LGD_AMOUNT			= String.valueOf(totalPrice + shipAmt);
	LGD_PRODUCTINFO		= pnm;
	LGD_TAXFREEAMOUNT	= String.valueOf(totalTaxFreeAmt);

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
			<input type="hidden" name="mem_couponid" id="mem_couponid" />
			<input type="hidden" name="coupon_amt" id="coupon_amt" value="0">
<!-- 			<input type="hidden" name="mem_couponid_cart" id="mem_couponid_cart" /> -->
<!-- 			<input type="hidden" name="mem_couponid_ship" id="mem_couponid_ship" /> -->
<%
	/*
	 *************************************************
	 * Smilepay - 시작
	 *************************************************
	 */
	////////위변조 처리/////////
	//전문생성일시
	String EdiDate = KakaopayUtil.getyyyyMMddHHmmss();
	
	//결제요청용 키값
	String md_src = EdiDate + SmilepayUtil.MID + LGD_AMOUNT;
	System.out.println("LiteRequest : " + md_src);
	//String hash_String  = SHA256Salt(md_src, EncodeKey);
	String hash_String  = SmilepayUtil.SHA256Salt(md_src, SmilepayUtil.ENCODE_KEY);
	System.out.println("LiteRequest : " + hash_String);
	
	int taxationAmt = totalPrice - totalTaxFreeAmt;
	int goodsVat = taxationAmt / 11;
	int supplyAmt = totalPrice - goodsVat;
	int serviceAmt = 0;
	
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
			<input type="hidden" name="SupplyAmt"				id="SupplyAmt"				value="<%= supplyAmt %>">
			<input type="hidden" name="GoodsVat"				id="GoodsVat"				value="<%= goodsVat %>">
			<input type="hidden" name="ServiceAmt"				id="ServiceAmt"				value="<%= serviceAmt %>">
			<input type="hidden" name="TaxationAmt"				id="TaxationAmt"			value="<%= taxationAmt %>">
			<input type="hidden" name="GoodsCnt"				id="GoodsCnt"				value="1">
			<input type="hidden" name="MID"						id="MID"					value="<%= SmilepayUtil.MID %>">
			<input type="hidden" name="AuthFlg"					id="AuthFlg"				value="10">
			<input type="hidden" name="EdiDate"					id="EdiDate"				value="<%=EdiDate%>">
			<input type="hidden" name="EncryptData"				id="EncryptData"			value="<%=hash_String%>">
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
            <input type="hidden" name="etc1" id="etc1" value="<%= orderid %>"/>
            <input type="hidden" name="etc2" id="etc2" value=""/>
            <input type="hidden" name="etc3" id="etc3" value=""/>
            <input type="hidden" name="returnUrl2" value="<%= smilepayReturnUrl2 %>"/>
			<!-- Smilepay Field End -->					
			
			<!-- payco field -->
			<input type="hidden" name="reserveOrderNo" id="reserveOrderNo"	value="">
			<input type="hidden" name="sellerOrderReferenceKey" id="sellerOrderReferenceKey"	value="">
			<input type="hidden" name="paymentCertifyToken" id="paymentCertifyToken"	value="">
			<input type="hidden" name="paycoOrderUrl" id="paycoOrderUrl"	value="">

			<!-- Npay field -->
			<input type="hidden" name="paymentId" id="paymentId" value="" />
			<input type="hidden" name="productItems" id="productItems" value='<%= jsonArr.toJSONString() %>' />
			<input type="hidden" name="productCount" id="productCount" value='<%= totQty %>' />
			<input type="hidden" name="naver_return" id="naver_return" value="mreturn" />

			<!-- etc -->
			<input type="hidden" name="device_type" value="<%= fs.getDeviceType() %>" />
			<input type="hidden" name="tid" id="tid" value="" />
			<input type="hidden" name="pg_token" id="pg_token" value="" />
		</form>
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
<script>
totalTaxFreeAmt = <%= totalTaxFreeAmt %>;
totalPayAmt = <%= totalPrice + shipAmt %>;
payAmt = <%= totalPrice + shipAmt %>;
<%
	if(existsHyundaiCardPid) {
%>
// 	alert("현대카드 블랙/퍼플 전용 할인 상품이 있습니다.\n결제에 해당 카드로 주문하셔야 합니다.");
	$(".cardPop").show();
	$(".bgLayer2").show();
<%
	}
%>
</script>

<script>
	$(function() {
<%
	boolean isBack = false;
	if(saList1 != null && saList1.size() > 0) {
		String msg = "비회원은 주문할 수 없는 프로모션상품이 있습니다.\\n";
		for(Param row : saList1) {
			msg += "   -" + row.get("pnm") + " - " + row.get("sub_opt_pnm") + "\\n";
		}
		msg += "\\n로그인 후 이용하시거나 해당 상품을 제외하고 비회원 주문이 가능합니다.";
		isBack = true;
%>
		alert("<%= msg %>");
<%
	}

	if(saList2 != null && saList2.size() > 0) {
		String msg = "오늘 구매이력이 있어 주문할 수 없는 상품이 있습니다.\\n";
		for(Param row : saList2) {
			msg += "   -" + row.get("pnm") + " - " + row.get("sub_opt_pnm") + "\\n";
		}
		msg += "\\n프로모션 상품은 1일 1회 주문 가능합니다. 해당상품을 제외하고 주문해 주세요.";
		isBack = true;
%>
		alert("<%= msg %>");
<%
	}

	if(saList3 != null && saList3.size() > 0) {
		String msg = "1일 최대 " + saInfo.getInt("buy_avail_qty") + "개까지 주문이 가능한 상품이 있습니다.\\n";
		for(Param row : saList3) {
			msg += "   -" + row.get("pnm") + " - " + row.get("sub_opt_pnm") + "\\n";
		}
		msg += "\\n프로모션 상품 수량을 " + saInfo.getInt("buy_avail_qty") + "개 이하로 조정한 후 주문해 주세요.";
		isBack = true;
%>
		alert("<%= msg %>");
<%
	}
	
	String s = "";
	List<String> temp = null;
	for(Param row : saList4) {
		if(row.getInt("qty") > saInfo.getInt("buy_avail_qty")) {
			temp = new ArrayList<String>();
			for(Param r : list1) {
				if(row.get("sub_pid").equals(r.get("sub_pid"))) {
					temp.add(r.get("pnm") + " - " + r.get("sub_opt_pnm"));
				}
			}
			for(Param r : list2) {
				if(row.get("sub_pid").equals(r.get("sub_pid"))) {
					temp.add(r.get("pnm") + " - " + r.get("sub_opt_pnm"));
				}
			}
			for(Param r : list4) {
				if(row.get("sub_pid").equals(r.get("sub_pid"))) {
					temp.add(r.get("pnm") + " - " + r.get("sub_opt_pnm"));
				}
			}
			
			if(temp.size() > 1) {
				for(int i = 0; i < temp.size(); i++) {
					s += "   " + temp.get(i);
					if(i == temp.size() - 1) {
						s += "은 같은 상품입니다.\\n\\n";
					} else {
						s += "와(과)\\n";
					}
				}
			}
		}
	}
	
	if(!"".equals(s)) {
		String msg = "동일한 상품으로 합계수량이 " + saInfo.getInt("buy_avail_qty") + "개를 초과하였습니다.\\n";
		msg += s + "합계 수량을 " + saInfo.getInt("buy_avail_qty") + "개 이하로 조정한 후 주문해 주세요.";
		isBack = true;
%>
		alert("<%= msg %>");
<%
	}

	if(isBack) {
%>
		document.location.href = "/mobile/order/cart.jsp";
<%
	}
%>
	});
</script>
<form name="hashForm" id="hashForm" method="POST" action="/order/xpay/hash.jsp">
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
	<input type="hidden" name="sellerOrderProductReferenceKey" value="<%= pid %>" />
	<input type="hidden" name="orderChannel" value="MOBILE" />
	<input type="hidden" name="returnUrl" value="payco_return_mobile.jsp?orderid=<%= orderid %>">
</form>
<form name="kakaopayReadyForm" id="kakaopayReadyForm" method="post" action="/order/kakaopay/ready.jsp">
	<input type="hidden" name="partner_order_id" value="<%= orderid %>" />
	<input type="hidden" name="partner_user_id" value="<%= userid %>" />
<%-- 	<input type="hidden" name="item_name" value="<%= LGD_PRODUCTINFO %>" /> --%>
	<input type="hidden" name="item_name" value="<%= LGD_PRODUCTINFO.replaceAll("%", "") %>" />
	<input type="hidden" name="quantity" value="<%= totQty %>" />
	<input type="hidden" name="total_amount" value="<%= LGD_AMOUNT %>" />
	<input type="hidden" name="vat_amount" value="" />
	<input type="hidden" name="tax_free_amount" value="<%= totalTaxFreeAmt %>" />
	<input type="hidden" name="approval_url" value="<%= kakaoReturn %>?result=success" />
	<input type="hidden" name="fail_url" value="<%= kakaoReturn %>?result=fail" />
	<input type="hidden" name="cancel_url" value="<%= kakaoReturn %>?result=cancel" />
</form>
<!-- Smilepay Hidden -->
<div class='div_frame' id="smilePay_layer"  style="display: none"></div>
<iframe name="txnIdGetterFrame" id="txnIdGetterFrame" src="" width="0" height="0"></iframe>
<%
	if(soldOutList1.size() > 0 || soldOutList2.size() > 0) {
		/*
		String msg = "주문서의 일부 상품 재고가 부족합니다.\\n\\n주문이 가능한 수량은\\n";
		for(Param row : soldOutList) {
			msg += row.get("opt_pnm") + " " + row.getInt("stock") + "개\\n";
		}
		msg += "입니다.\\n\\n주문 수량을 조정하시거나, 해당 상품을 제외하시고\\n주문 부탁드립니다.";
		*/
		
		String msg = "다음과 같은 이유로 주문을 처리할 수 없습니다.\\n";
		if(soldOutList1.size() > 0) {
			msg += "\\n- 재고 부족\\n";
			for(Param row : soldOutList1) {
				msg += "    " + row.get("sub_opt_pnm") + " 현재" + row.getInt("stock") + "개 주문 가능\\n";
			}
		}
		
		if(soldOutList2.size() > 0) {
			msg += "\\n- 미판매 상품\\n";
			for(Param row : soldOutList2) {
				msg += "    " + row.get("sub_opt_pnm") + "\\n";
			}
		}
		
		msg += "\\n주문 수량을 조정하시거나, 해당 상품을 제외하시고 주문 부탁드립니다.";

		Utils.sendMessage(out, msg, "/mobile/order/cart.jsp");
		return;
	} else if(isInvalidDdate) {
		Utils.sendMessage(out, "유효하지 않은 배송일이 지정되었습니다.\\n배송일 지정상품을 제외하고 주문하세요.", "/mobile/order/cart.jsp");
		return;
	}
%>
</body>


<%
	if("http".equals(request.getScheme())){
%>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<%
	}else {
%>
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
<%
	}
%>
<script>
    // 우편번호 찾기 화면을 넣을 element
    var element_wrap = document.getElementById('zipArea');
	
	function foldDaumPostcode() {
	    // iframe을 넣은 element를 안보이게 한다.
	    element_wrap.style.display = 'none';
	}

    function execDaumPostcode() {
    	var currentScroll = Math.max(document.body.scrollTop, document.documentElement.scrollTop);
        new daum.Postcode({
            oncomplete: function(data) {
                // 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullAddr = data.address; // 최종 주소 변수
                var extraAddr = ''; // 조합형 주소 변수

                // 기본 주소가 도로명 타입일때 조합한다.
                if(data.addressType === 'R'){
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
                //document.getElementById('sample3_postcode').value = data.zonecode; //5자리 새우편번호 사용
                //document.getElementById('sample3_address').value = fullAddr;
                $("#ship_post_no").val(data.zonecode); //5자리 새우편번호 사용
	            $("#ship_addr1").val(fullAddr);

                // iframe을 넣은 element를 안보이게 한다.
                // (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
                element_wrap.style.display = 'none';

                // 우편번호 찾기 화면이 보이기 이전으로 scroll 위치를 되돌린다.
                document.body.scrollTop = currentScroll;
                
	            checkEarly();
            },
            // 우편번호 찾기 화면 크기가 조정되었을때 실행할 코드를 작성하는 부분. iframe을 넣은 element의 높이값을 조정한다.
            onresize : function(size) {
                element_wrap.style.height = size.height+'px';
            },
            width : '100%',
            height : '100%'
        }).embed(element_wrap);

        // iframe을 넣은 element를 보이게 한다.
        element_wrap.style.display = 'block';
        
        /* new daum.Postcode({
            oncomplete: function(data) {
                // 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullAddr = data.address; // 최종 주소 변수
                var extraAddr = ''; // 조합형 주소 변수

                // 기본 주소가 도로명 타입일때 조합한다.
                if(data.addressType === 'R'){
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
	            $("#ship_post_no").val(data.zonecode); //5자리 새우편번호 사용
	            $("#ship_addr1").val(fullAddr);
	

	            $("#ship_addr2").val('');
	            $("#ship_addr2").focus();

                // iframe을 넣은 element를 안보이게 한다.
                // (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
                element_layer.style.display = 'none';
            },
            width : '100%',
            height : '100%'
        }).embed(element_layer);

        // iframe을 넣은 element를 보이게 한다.
        element_layer.style.display = 'block';

        // iframe을 넣은 element의 위치를 화면의 가운데로 이동시킨다.
        initLayerPosition(); */
    }

    // 브라우저의 크기 변경에 따라 레이어를 가운데로 이동시키고자 하실때에는
    // resize이벤트나, orientationchange이벤트를 이용하여 값이 변경될때마다 아래 함수를 실행 시켜 주시거나,
    // 직접 element_layer의 top,left값을 수정해 주시면 됩니다.
    function initLayerPosition(){
        var width = 300; //우편번호서비스가 들어갈 element의 width
        var height = 460; //우편번호서비스가 들어갈 element의 height
        var borderWidth = 5; //샘플에서 사용하는 border의 두께

        // 위에서 선언한 값들을 실제 element에 넣는다.
        element_layer.style.width = width + 'px';
        element_layer.style.height = height + 'px';
        element_layer.style.border = borderWidth + 'px solid';
        // 실행되는 순간의 화면 너비와 높이 값을 가져와서 중앙에 뜰 수 있도록 위치를 계산한다.
        element_layer.style.left = (((window.innerWidth || document.documentElement.clientWidth) - width)/2 - borderWidth) + 'px';
        element_layer.style.top = ($(document).scrollTop()+((window.innerHeight || document.documentElement.clientHeight) - height)/2 - borderWidth) + 'px';
        if(height > window.innerHeight){
        	element_layer.style.top = $(document).scrollTop();
        }
        element_layer.style.zIndex = 60;
    }
</script>
<form name="earlyForm" id="earlyForm" method="post" action="">
	<input type="hidden" name="addr">
</form>
<script>
var isEarlyOnly = <%= isEarlyOnly %>;

$(function() {
	checkEarly();
});

function checkEarly() {
	hideEarly();
<%
// 	if(list1.size() > 0 || list3.size() > 0) {
	if(isEarlyAvailable) {
%>
	setTimeout(function() {
		var addr = $("#ship_addr1").val();
		console.log("addr1", addr);
		if(addr != '') {
			$("#earlyForm input[name=addr]").val(addr);
			$.ajax({
				type: "POST",
				url : "/api/searchDeliveryArea.jsp",
				data : $("#earlyForm").serialize(),
				cache: false,
				dataType : "json"
			})
			.done(function(json) {
				console.log(json);
		// 		console.log(json.result.delyverYn);
				if(json.resultCode == '0000') {
					if(json.result.delyverYn == '1') {
						showEarly();
					} else {
						hideEarly();
					}
				} else {
					hideEarly();

					alert("새벽 배송 가능지역 확인중 오류가 발생했습니다.");
				}
			});
		} else {
			hideEarly();
		}
	}, 500);
<%
	}
%>
}

function showEarly() {
	$(".earlyText").show();
	$(".early").show();
	$("#delivery_type5").prop("checked", true);
	early('5');
}

function hideEarly() {
	$(".earlyText").hide();
	$(".early").hide();
	$("#delivery_type1").prop("checked", true);
	early('1');
}

function early(v) {
	if(v == '1') {
		$(".d1").html("일반배송(택배배송)");
		$(".d2").html("정기배송(택배배송)");
		$("#earlyInfo").hide();
	} else {
		$(".d1").html("일반배송(새벽배송)");
		$(".d2").html("정기배송(새벽배송)");
		$("#earlyInfo").show();
	}
}
</script>
</html>
