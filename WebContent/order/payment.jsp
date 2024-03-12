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
<%@include file="/order/payco/common_include.jsp" %>
<%
	request.setAttribute("Depth_1", new Integer(2));
	request.setAttribute("Depth_2", new Integer(2));
	request.setAttribute("Depth_3", new Integer(2));
	request.setAttribute("MENU_TITLE", new String("주문/결제"));
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
	String LGD_OID              = ""							;                      //주문번호(상점정의 유니크한 주문번호를 입력하세요)
	String LGD_AMOUNT           = "";								                   //결제금액("," 를 제외한 결제금액을 입력하세요)
	String LGD_MERTKEY          = Config.get("lgdacom.LGD_MERTKEY");   					//상점MertKey(mertkey는 상점관리자 -> 계약정보 -> 상점정보관리에서 확인하실수 있습니다)
	String LGD_BUYER            = "";                    //구매자명
	String LGD_PRODUCTINFO      = "";              //상품명
	String LGD_BUYEREMAIL       = "";               //구매자 이메일
	String LGD_TIMESTAMP        = Utils.getTimeStampString("yyyyMMddHHmmss");                //타임스탬프
	String LGD_CUSTOM_USABLEPAY = "SC0010";        	//상점정의 초기결제수단
	String LGD_CUSTOM_SKIN      = "red";                                                //상점정의 결제창 스킨(red, yellow, purple)
	String LGD_CUSTOM_SWITCHINGTYPE = "IFRAME"; //신용카드 카드사 인증 페이지 연동 방식 (수정불가)
	String LGD_WINDOW_VER		= "2.5";												//결제창 버젼정보
	String LGD_WINDOW_TYPE      = "iframe";               //결제창 호출 방식 (수정불가)
	
	String LGD_TAXFREEAMOUNT	= "";	// 면세금액
	
	Calendar cal = Calendar.getInstance();
	cal.add(Calendar.DATE, 1);
	String LGD_CLOSEDATE		= Utils.getTimeStampString(cal.getTime(), "yyyyMMddHHmmss");	// 무통장 입금 마감시간 (예: yyyyMMddHHmmss)
	
	/*
	 * 가상계좌(무통장) 결제 연동을 하시는 경우 아래 LGD_CASNOTEURL 을 설정하여 주시기 바랍니다.
	 */
// 	String LGD_CASNOTEURL		= "http://" + request.getServerName() + "/order/xpay/cas_noteurl.jsp";
	String LGD_CASNOTEURL		= (SystemChecker.isReal() ? "https" : "http") + "://" + request.getServerName() + "/order/xpay/cas_noteurl.jsp";
// 	String LGD_CASNOTEURL		= Env.getSSLPath() + "/order/xpay/cas_noteurl.jsp";
		
	System.out.println("-------------- LGD_CASNOTEURL : " + LGD_CASNOTEURL);
	
	/*
	 * LGD_RETURNURL 을 설정하여 주시기 바랍니다. 반드시 현재 페이지와 동일한 프로트콜 및  호스트이어야 합니다. 아래 부분을 반드시 수정하십시요.
	 */
// 	String LGD_RETURNURL		= (SystemChecker.isReal() ? "https" : "http") + "://" + request.getServerName() + "/order/xpay/returnurl.jsp";// FOR MANUAL
	String LGD_RETURNURL		= request.getScheme() + "://" + request.getServerName() + "/order/xpay/returnurl.jsp";// FOR MANUAL
// 	String LGD_RETURNURL		= Env.getSSLPath() + "/order/xpay/returnurl.jsp";// FOR MANUAL
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
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	CartService cart = (new CartService()).toProxyInstance();
	OrderService order = (new OrderService()).toProxyInstance();
	MemberService member = (new MemberService()).toProxyInstance();
	CodeService code = (new CodeService()).toProxyInstance();
	CouponService coupon = (new CouponService()).toProxyInstance();
	ImMemberService immem = (new ImMemberService()).toProxyInstance();
	SecondAnniversaryService sa = new SecondAnniversaryService();
	
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
		Utils.sendMessage(out, "모바일용 화면으로 이동합니다.", "/mobile/order/cart.jsp");
		return;
	}
	// End of Device check

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

	if(fs.isLogin()) {
		member.modifyOrderid(userid, orderid);
	}
	
	// 결제방법
	List<Param> payList = code.getList2("007");
	String pnm = "";
	String pid = "";
	
// 	List<String> couponList = new ArrayList<String>();
	
	// 포인트
	int point = 0;
	
	Param memInfo = new Param();
	
	if(fs.isLogin()) {
		point = immem.getMemberPoint(fs.getUserNo());
		memInfo = member.getInfo(fs.getUserId());
	}
	
	String payType = memInfo.get("pay_type", "001");
	
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
<jsp:include page="/include/head.jsp" /> 
<!-- payco -->
<script type="text/javascript" src="https://static-bill.nhnent.com/payco/checkout/js/payco.js" charset="UTF-8"></script>
<!-- // payco -->

<!-- Smilepay css, javascript 시작 -->
<!-- OpenSource Library -->
<link rel="stylesheet" href="<%=webPath%>/dlp/css/pc/cnspay.css" type="text/css" />

<!-- JQuery에 대한 부분은 site마다 버전이 다를수 있음 -->
<script src="<%=webPath %>/js/dlp/lib/jquery/jquery-1.11.1.min.js" charset="utf-8"></script>
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
			document.getElementById("orderForm").action = "<%= Env.getSSLPath() %>/order/orderProc.jsp";
			try { document.getElementById("LGD_CARDPREFIX").value = fDoc.document.getElementById('LGD_CARDPREFIX').value; } catch(e) {}
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
				document.orderForm.action = "<%= Env.getSSLPath() %>/order/orderProc.jsp";
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

<%
	if("http".equals(request.getScheme())) {
%>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<%
	} else {
%>
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
<%
	}
%>
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
	            $("#ship_post_no").val(data.zonecode); //5자리 새우편번호 사용
	            $("#ship_addr1").val(fullAddr);
	
	            // 커서를 상세주소 필드로 이동한다.
// 	            document.getElementById('sample6_address2').focus();
	            $("#ship_addr2").val('');
	            $("#ship_addr2").focus();
	            
	            checkEarly();
	        }
	    }).open();
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
			} else if($("input[name=pay_type]:checked").val() == "009") {	// naver pay
				if(payAmt < 100) {
					alert("결제 최소금액은 100원입니다.");
				} else {
					var taxAmt = payAmt - totalTaxFreeAmt;
					var taxFree = totalTaxFreeAmt;
					if(taxAmt < 0) {
						taxAmt = 0;
						taxFree = payAmt;
					}
// 					console.log(payAmt + ";" + taxFree + ";" + taxAmt);
					
					var nPay = Naver.Pay.create({
					    "mode" : "<%= SystemChecker.isReal() ? "production" : "development" %>", // development or production
					    "openType" : "popup" ,	//layer, page, popup 
					    "clientId": "<%= Config.get("npay.shop.clientid") %>", // clientId
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
			            "taxScopeAmount": taxAmt,
			            "taxExScopeAmount": taxFree,
			            "returnUrl": "<%= naverReturn %>",
			            "productItems": $("#productItems").val()
			        });
				}
			} else if($("input[name=pay_type]:checked").val() == "008") {	// Smilepay
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
			} else if($("input[name=pay_type]:checked").val() == "006") {	// Payco
				callPaycoUrl();
			} else if($("input[name=pay_type]:checked").val() == "007") {	// Kakaopay
				if(payAmt != totalPayAmt) {	// 쿠폰, 포인트로 인해 금액이 변동된 경우
					$("#kakaopayReadyForm input[name=total_amount]").val(payAmt);
				}

				ajaxSubmit("#kakaopayReadyForm", function(json) {
					if(json.response_code == '200') {
						$("#tid").val(json.tid);
						//console.log(json.next_redirect_pc_url);
						outUrlShowPopupLayer(json.next_redirect_pc_url, '426', '510');
// 						window.open(json.next_redirect_pc_url, "KAKAOPAYPOP", "width=426,height=510");
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
				
				if(payAmt != totalPayAmt) {	// 쿠폰, 포인트로 인해 금액이 변동된 경우
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
	}
	//나의 배송 주소록
	function showAddressListPop() {
		showPopupLayer('/popup/popAddressList.jsp', '910', '450');
	}

	function showMyAddressPop() {
		showPopupLayer('/popup/popMyAddress.jsp?mode=COPY', '910', '520');
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
			var url = "/mypage/order/addrProc.jsp?mode=" + mode;
			
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
		showPopupLayer('/popup/giftCard.jsp?pay_amt=' + payAmt, '500');		
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
    
    function naverpay(paymentId) {
    	$("#paymentId").val(paymentId);
    	$("#orderForm").submit();

    }
</script>
</head>  
<body>
<!-- 팝업 -->
<div class="cardPop" style="display:none">
	<p><strong>잠깐만요!</strong></p>
	<p class="popTxt">현대카드 프로모션 상품으로 the Black, the Purple카드 결제 시 20% 할인 혜택이 제공됩니다. 그 외 카드 결제 시 승인 후 자동 취소됩니다.</p>
	<div class="popBtn"><a href="#" onClick="layerClose('.cardPop');return false;">확인</a></div>
	<a href="#" onClick="layerClose('.cardPop');return false;" class="btnClose"><img src="/images/btn/btn_close5.gif" alt="닫기"></a>
</div> 	
<div class="bgLayer2" style="display:none"></div>
<!-- //팝업 -->
<div id="wrapper">
	<jsp:include page="/include/header.jsp" />
	<ul id="location">
		<li><a href="/">홈</a></li>
		<li>주문/결제</li>
	</ul>
	<div id="container">
	<!-- 내용영역 -->
		<form name="orderForm" id="orderForm" method="POST" action="<%= Env.getSSLPath() %>/order/orderProc.jsp">
			<input type="hidden" name="orderid" value="<%= orderid %>" />
		<div class="orderTit">
			<h1 class="typeA step2">주문/결제</h1>
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
				<col width="130"><col width="">
			</colgroup>
			<tr>
				<th scope="row">성명 <em>*</em></th>
				<td><input type="text" name="name" id="name" value="<%= fs.getUserNm() %>" title="주문자 성명" style="width:140px"></td>
			</tr>
			<tr>
				<th scope="row">휴대전화 <em>*</em></th>
				<td>
					<select name="mobile1" id="mobile1" title="주문자 휴대전화 앞자리" style="width:88px">
<%
	for(String mobile : SanghafarmUtils.MOBILES) {
%>
						<option value="<%= mobile %>" <%= mobile.equals(fs.getMobile1()) ? "selected" : "" %>><%= mobile %></option>
<%
	}
%>
					</select>&nbsp;-
					<input type="text" name="mobile2" id="mobile2" value="<%= fs.getMobile2() %>" title="주문자 휴대전화 가운데자리" style="width:70px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">&nbsp;-
					<input type="text" name="mobile3" id="mobile3" value="<%= fs.getMobile3() %>" title="주문자 휴대전화 뒷자리" style="width:70px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">
				</td>
			</tr>
			<tr>
				<th scope="row">일반전화</th>
				<td>					
					<input type="text" name="tel1" id="tel1" title="주문자 일반전화 앞자리" style="width:70px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">&nbsp;-
					<input type="text" name="tel2" id="tel2" title="주문자 일반전화 가운데자리" style="width:70px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">&nbsp;-
					<input type="text" name="tel3" id="tel3" title="주문자 일반전화 뒷자리" style="width:70px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">
				</td>
			</tr>
			<tr>
				<th scope="row">이메일</th>
				<td>
					<input type="text" name="email1" id="email1" value="<%= fs.getEmail1() %>" title="주문자 이메일 앞자리" style="width:140px">&nbsp;@
					<input type="text" name="email2" id="email2" value="<%= fs.getEmail2() %>" title="주문자 이메일 뒷자리" style="width:90px">
					<select name="email3" id="email3" onchange="changeEmail3('1', this.value)" title="주문자 이메일 뒷자리 선택" style="width:110px">
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
		
		<h2 class="typeA">배송지 정보 <span class="fs"><em>*</em> 필수입력항목</span></h2>
		<table class="bbsForm">
			<caption>배송지 정보 입력폼</caption>
			<colgroup>
				<col width="130"><col width="">
			</colgroup>
<%
	if(fs.isLogin()) {
%>
			<tr>
				<th scope="row">배송지 선택</th>
				<td>
					<input type="radio" name="addr_type" value="1" onclick="setAddr(this.value)" id="addr1" checked><label for="addr1">기본 배송지</label>
					<input type="radio" name="addr_type" value="2" onclick="setAddr(this.value)" id="addr2"><label for="addr2">새로운 배송지</label>
					<input type="radio" name="addr_type" value="3" onclick="setAddr(this.value)" id="addr3"><label for="addr3">최근 배송지</label>
					<a href="#none" onclick="showPopupLayer('/popup/addressList.jsp', '630'); return false" class="btnTypeA">나의 배송 주소록</a>
				</td>
			</tr>
<%
	}
%>
			<tr>
				<th scope="row">성명 <em>*</em></th>
				<td>
					<input type="text" name="ship_name" id="ship_name" title="수취인 성명" style="width:140px">
					<label><input type="checkbox" name="copyinfo" id="copyinfo" onclick="copyInfo()">위 주문자 정보와 동일하게 입력</label>
				</td>
			</tr>
			<tr>
				<th scope="row">휴대전화 <em>*</em></th>
				<td>
					<select name="ship_mobile1" id="ship_mobile1" title="수취인 휴대전화 앞자리" style="width:88px">
<%
	for(String mobile : SanghafarmUtils.MOBILES) {
%>
						<option value="<%= mobile %>"><%= mobile %></option>
<%
	}
%>
					</select>&nbsp;-
					<input type="text" name="ship_mobile2" id="ship_mobile2" title="수취인 휴대전화 가운데자리" style="width:70px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">&nbsp;-
					<input type="text" name="ship_mobile3" id="ship_mobile3" title="수취인 휴대전화 뒷자리" style="width:70px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">
				</td>
			</tr>
			<tr>
				<th scope="row">일반전화</th>
				<td>					
					<input type="text" name="ship_tel1" id="ship_tel1" title="수취인 일반전화 앞자리" style="width:70px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">&nbsp;-
					<input type="text" name="ship_tel2" id="ship_tel2" title="수취인 일반전화 가운데자리" style="width:70px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">&nbsp;-
					<input type="text" name="ship_tel3" id="ship_tel3" title="수취인 일반전화 뒷자리" style="width:70px;ime-mode:disabled" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)">
				</td>
			</tr>
			<tr>
				<th scope="row">이메일</th>
				<td>
					<input type="text" name="ship_email1" id="ship_email1" title="수취인 이메일 앞자리" style="width:140px">&nbsp;@
					<input type="text" name="ship_email2" id="ship_email2" title="수취인 이메일 뒷자리" style="width:90px">
					<select name="ship_email3" id="ship_email3" onchange="changeEmail3('2', this.value)" title="수취인 이메일 뒷자리 선택" style="width:110px">
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
					<input type="text" name="ship_post_no" id="ship_post_no" value="<%= fs.getZipCode() %>" title="배송지 우편번호" style="width:70px" readonly>
					<a href="javascript:execDaumPostcode()" class="btnTypeA">우편번호찾기</a><br>
					<input type="text" name="ship_addr1" id="ship_addr1" readonly value="<%= fs.getAddr1() %>" title="배송지 주소" style="width:400px;margin-top:6px"><br>
					<input type="text" name="ship_addr2" id="ship_addr2" value="<%= fs.getAddr2() %>" title="배송지 상세주소" style="width:400px;margin-top:6px" placeholder="상세주소 입력">
<!-- 					<a href="javascript:checkEarly()" class="btnTypeA">새벽 배송 가능지역 확인하기 &gt;</a><br> -->
					<p class="earlyText" style="display:none">새벽배송 가능 지역입니다.</p>
					<p class="text fontTypeG">*신선제품의 경우 제주/도서산간 지역은 배송이 2일 이상 소요될 수 있으므로 휴일 또는 주말 전 주문하실 경우 신선도가 저하될 수 있습니다.</p>
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
					<span class="text">*온라인 결제정보 및 주문정보를 이메일이나 모바일로 받아 보시려면 수신동의를 체크해 주세요.</span>
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
				<input type="radio" name="delivery_type" id="delivery_type1" value="1" checked  onclick="early('1')">
				<p class="tit">택배배송</p>주6일 출고(일,월,화,수,목,금)
				<br>오후 3시까지 주문 시 다음날 도착(제주 및 도서산간 지역은 2일 소요)
				<br>*산지직송 상품은 오전 10시까지 주문 마감 (산지 사정에 따라 변경될 수 있습니다.)
			</label>
		</div><!-- //배송방법 선택 -->
		
		<div id="earlyInfo" style="display:none">
		<h2 class="typeA">새벽배송 정보 입력</h2>
		<table class="bbsForm">
			<caption>새벽배송 정보 입력폼</caption>
			<colgroup>
				<col width="180"><col width="">
			</colgroup>
			<tr>
				<th scope="row">공동 현관 출입 방법</th>
				<td>
					<input type="radio" name="early_note1" value="비밀번호" onclick="$('input[name=early_pw]').prop('disabled', false);" checked><label for="entrance1">비밀번호</label>
					<input type="radio" name="early_note1" value="경비실호출" onclick="$('input[name=early_pw]').prop('disabled', true);"><label for="entrance2">경비실호출</label>
					<input type="radio" name="early_note1" value="자유 출입 가능" onclick="$('input[name=early_pw]').prop('disabled', true);"><label for="entrance3">자유 출입 가능</label>
				</td>
			</tr>
			<tr>
				<th scope="row">공동 현관 비밀번호</th>
				<td>
					<input type="text" name="early_pw" style="width:400px">
				</td>
			</tr>
			<tr>
				<th scope="row">추가 요청사항</th>
				<td>
					<textarea style="width:400px;height:90px" name="early_note2"></textarea>
				</td>
			</tr>
			<tr>
				<th scope="row">새벽배송 도착 알림</th>
				<td>
					<input type="radio" name="early_sms" value="X" checked><label for="alram1">오전 7시 이후 알려주세요.</label>
					<input type="radio" name="early_sms" value="O"><label for="alram2">새벽배송 도착 즉시 알려주세요</label>
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
		<table class="bbsList typeB">
			<caption>주문/결제 상품 목록</caption>
			<colgroup>
				<col width="50"><col width="126"><col width=""><col width="180"><col width="220"><col width="150">
			</colgroup>
			<thead>
				<tr>
					<th scope="col"></th>
					<th scope="col" colspan="2">상품</th>
					<th scope="col">수량</th>
					<th scope="col">가격</th>
					<th scope="col">배송비</th>
				</tr>
			</thead>
			<tbody>
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
				<tr>
					<th scope="row" class="vt"></th>
					<td><p class="thumb"><a href="/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%= row.get("opt_thumb") %>" alt="" width="124"></a></p></td>
					<td class="tit pName"><a href="/product/detail.jsp?pid=<%= row.get("pid") %>">
<%-- 						<input type="hidden" name="mem_couponid_<%= row.get("cartid") %>" id="mem_couponid_<%= row.get("cartid") %>" value="" /> --%>
						<%= row.get("pnm") %>
						<p class="opt"><%= row.get("sub_opt_pnm") %></p>
					</a></td>
					<td><%= row.get("qty") %></td>
					<td>
						<p class="price"><strong><%= Utils.formatMoney(row.getInt("sale_price") * row.getInt("qty")) %></strong>원</p>
					</td>
<%
		if(i == 0) {
%>
					<td rowspan="<%= list1.size() %>" class="last">
						<p class="delivery">
							<span class="d1">일반배송(택배배송)</span><br><%= Utils.formatMoney(totalPrice1) %>원<br>+<br>배송비<br><%= shipAmt1 == 0 ? "무료" : Utils.formatMoney(shipAmt1) + "원" %><br>
<%
			if(shipAmt1 > 0) {
%>
							<span class="free"><%= Utils.formatMoney(Config.getInt("shipping.free.amt") - totalPrice1) %>원 추가주문시,<br><strong>무료배송</strong></span>
<%
			}
%>
						</p>
					</td>
<%
		}
%>
				</tr>
<%
		// 쿠폰
		/*
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
		*/

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
				<tr>
					<th scope="row" class="vt"></th>
					<td><p class="thumb"><a href="/product/detail.jsp?pid="<%= row.get("pid") %>"><img src="<%= row.get("opt_thumb") %>" alt="" width="124"></a></p></td>
					<td class="tit pName"><a href="/product/detail.jsp?pid="<%= row.get("pid") %>">
<%-- 						<input type="hidden" name="mem_couponid_<%= row.get("cartid") %>" id="mem_couponid_<%= row.get("cartid") %>" value="" /> --%>
						<%= row.get("pnm") %>
						<p class="opt"><%= row.get("sub_opt_pnm") %></p>
					</a></td>
					<td><%= row.get("qty") %></td>
					<td>
						<p class="price"><strong><%= Utils.formatMoney(row.getInt("sale_price") * row.getInt("qty")) %></strong>원</p>
					</td>
<%
		if(i == 0) {
%>
					<td rowspan="<%= list2.size() %>" class="last">
						<p class="delivery">
							<span id="d1">산지직송<br>(택배배송)</span><br><%= Utils.formatMoney(totalPrice2) %>원<br>+<br>배송비<br><%= shipAmt2 == 0 ? "무료" : Utils.formatMoney(shipAmt2) + "원" %><br>
<%
			if(shipAmt2 > 0) {
%>
							<span class="free"><%= Utils.formatMoney(Config.getInt("shipping.free.amt") - totalPrice2) %>원 추가주문시,<br><strong>무료배송</strong></span>
<%
			}
%>
						</p>
					</td>
<%
		}
%>
				</tr>
<%
		// 쿠폰
		/*
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
		*/

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
		
		/*
		if(!"".equals(row.get("mem_couponid"))) {
			if("A".equals(row.get("sale_type"))) {
				couponSaleAmt = row.getInt("sale_amt") > row.getInt("sale_max") ? row.getInt("sale_max") : row.getInt("sale_amt"); 
			} else {
				int m = (price - routineSaleAmt) * row.getInt("sale_amt") / 100;
				couponSaleAmt = m > row.getInt("sale_max") ? row.getInt("sale_max") : m; 
			}
		}
		*/

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
				<tr class="regular"><!-- 정기배송일때 class="regular" -->
					<th scope="row" class="vt"></th>
					<td><p class="thumb"><a href="/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%= row.get("opt_thumb") %>" alt="" width="124"></a></p></td>
					<td class="tit pName"><a href="/product/detail.jsp?pid=<%= row.get("pid") %>">
<%-- 						<input type="hidden" name="mem_couponid_<%= row.get("cartid") %>" id="mem_couponid_<%= row.get("cartid") %>" value="" /> --%>
						<%= row.get("pnm") %>
						<p class="opt"><%= row.get("sub_opt_pnm") %></p>
						<p class="cycle"><strong>정기배송상품</strong><%= row.get("routine_period") %>주마다 / <%= routineDay %> / <%= row.get("routine_cnt") %>회 / <%= firstDeliveryDate %> 부터</p>
					</a></td>
					<td></td>
					<td>
						<p class="price"><strong><%= Utils.formatMoney(amt) %></strong>원</p>
					</td>
					<td class="last">
						<p class="delivery"><span class="<%= "C".equals(row.get("ptype")) ? "" : "d2" %>">정기배송<br>(택배배송)</span><br><%= row.get("routine_cnt") %>회*<%= Config.getInt("shipping.amt") %>원<br><span class="fontTypeB">= <span class="through"><%= Utils.formatMoney(Config.getInt("shipping.amt") * row.getInt("routine_cnt")) %>원</span> <strong>무료</strong></span></p>
					</td>
				</tr>
<%
		// 쿠폰
		/*
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
		*/

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
				<tr>
					<th scope="row" class="vt"></th>
					<td><p class="thumb"><a href="/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%= row.get("opt_thumb") %>" alt="" width="124"></a></p></td>
					<td class="tit pName"><a href="/product/detail.jsp?pid=<%= row.get("pid") %>">
<%-- 						<input type="hidden" name="mem_couponid_<%= row.get("cartid") %>" id="mem_couponid_<%= row.get("cartid") %>" value=""> --%>
						<%= row.get("pnm") %>
						<p class="opt"><%= row.get("sub_opt_pnm") %></p>
						<p class="deliveryDateCart">
							<strong>배송일</strong>
							<span><%= row.get("delivery_date") %></span>
						</p>
					</a></td>
					<td><%= row.get("qty") %></td>
					<td>
						<p class="price"><strong><%= Utils.formatMoney(row.getInt("sale_price") * row.getInt("qty")) %></strong>원</p>
					</td>
<%
		if(i == 0) {
%>
					<td rowspan="<%= list4.size() %>" class="last">
						<p class="delivery">
							<span class="d1">날짜지정배송<br>(택배배송)</span><br><%= Utils.formatMoney(totalPrice4) %>원<br>+<br>배송비<br><%= shipAmt4 == 0 ? "무료" : Utils.formatMoney(shipAmt4) + "원" %><br>
<%
			if(shipAmt1 > 0) {
%>
							<span class="free"><%= Utils.formatMoney(Config.getInt("shipping.free.amt") - totalPrice4) %>원 추가주문시,<br><strong>무료배송</strong></span>
<%
			}
%>
						</p>
					</td>
<%
		}
%>
				</tr>
				<!-- //날짜지정배송 -->
<%
		// 쿠폰
		/*
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
		*/

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
			</tbody>
		</table><!-- //주문상품 확인 -->

		<div class="payment <%= fs.isLogin() ? "member" : "" %>"><!-- [dev] 회원일떄만 class=member 추가 -->
<%
	if(!fs.isLogin()) {
%>		
			<!-- 비회원 -->
			<div class="totalPrice">
				<span>상품 소계 <em><strong><%= Utils.formatMoney(totalPrice) %></strong>원</em></span>
				<span class="math">+</span>
				<span>총 배송비 <em><strong><%= Utils.formatMoney(shipAmt) %></strong>원</em></span>
				<span class="math">-</span>
				<span>총 할인 금액 <em class="fontTypeA"><strong>0</strong>원</em></span>
				<span class="math">=</span>
				<span class="total">총 결제 금액 <em class="fontTypeA"><strong><%= Utils.formatMoney(totalPrice + shipAmt) %></strong>원</em></span>
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
		 		<p class="agreeCheck"><input id="agree" type="checkbox"><label for="agree"><b>구매조건을 확인하였으며, 결제대행 서비스 약관에 동의합니다.</b></label></p>

		 	</div><!--//이용동의 -->
		 	<!-- //비회원 -->
		 	
		 	<!-- 회원 -->
<%
	} else {
		// 장바구니 쿠폰
		/*
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
		*/
		
		// 배송비 쿠폰
		/*
		if(shipAmt > 0) {
			p.set("coupon_type", "003");
			
			cList = coupon.getApplyableList2(p);
			for(Param c : cList) {
				if(!couponList.contains(c.get("mem_couponid"))) {
					couponList.add(c.get("mem_couponid"));
				}
			}
		}
		*/
%>
		 	<div class="totalPrice">
				<span>상품 소계 <em><strong><%= Utils.formatMoney(totalPrice) %></strong>원</em></span>
				<span>총 배송비 <em><strong><%= Utils.formatMoney(shipAmt) %></strong>원</em></span>
				<span>할인 소계<em class="fontTypeA"><strong id="totalSaleAmt">-0</strong>원</em></span>				
				<ul id="couponListArea">
				</ul>
				<ul id="pointListArea">
				</ul>
				<ul id="giftListArea">
				</ul>
				<span class="total">총 결제예상금액 <em class="fontTypeA"><strong id="totalPayAmt"><%= Utils.formatMoney(totalPrice + shipAmt) %></strong>원</em></span>
			</div>
			
		 	<div class="titArea">
			 	<h2 class="typeA">할인 받기</h2>
			 	<p class="text">※ 사용하신 할인수단의 유효기간 경과 이후 구매(결제)를 취소하시는 경우, <br>사용하셨던 쿠폰/포인트/기프트카드는 별도 고지 없이 바로 소멸되며 복원이 불가합니다.</p>
			</div>
		 	<table class="couponForm">
		 		<caption>할인 적용 선택 폼</caption>
		 		<colgroup>
		 			<col width="250"><col width=""><col width="130">
		 		</colgroup>
<%
	List<Param> couponList1 = coupon.getApplyableList3(new Param("userid", fs.getUserId(), "device_type", fs.getDeviceType(), "grade_code", fs.getGradeCode()));
// 	List<Param> couponList2 = coupon.getApplyableList2(new Param("userid", fs.getUserId(), "device_type", fs.getDeviceType(), "grade_code", fs.getGradeCode(), "coupon_type", "003"));
%>
		 		<tr>
		 			<th scope="row">쿠폰&nbsp;&nbsp;<span class="text">(적용가능: <strong class="fontTypeA"><%= Utils.formatMoney(couponList1.size()) %></strong>개)</span></th>
		 			<td colspan="2">
		 				<select name="mcoupon" onchange="applyCoupon(this.value)">
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
		 				</select>
		 				&nbsp;&nbsp;(할인 금액: <strong class="fontTypeA" id="coupon_amt_txt">0</strong>원)
		 			</td>		 			
		 			<!-- <td><a href="#" onclick="showPopupLayer('/popup/coupon.jsp', '630'); return false" class="btnTypeA">쿠폰적용</a></td> -->
		 		</tr>
		 		<tr>
		 			<th scope="row">Maeil Do 포인트</th>
		 			<td><input type="text" name="point_amt" id="point_amt" value="0" title="" style="width:150px;ime-mode:disabled" onkeydown="return onlyNumber(event);" onkeyup="removeChar(event);" onchange="applyPoint()" <%= point < 100 ? "disabled" : "" %>>&nbsp;P&nbsp;&nbsp;&nbsp;(보유 포인트: <strong class="fontTypeA"><%= Utils.formatMoney(point) %></strong>P)</td>		 			
		 			<td><input type="checkbox" name="point_all" id="point_all" onclick="pointAll()" <%= point < 100 ? "disabled" : "" %>><label for="point_all">모두사용</label></td>
		 		</tr>
		 		<tr>
		 			<th scope="row">기프트 카드 <a href="#none" onclick="showPopupLayer('/popup/giftCardInfo.jsp', '500'); return false" ><img src="/images/mypage/icon_question.gif" alt="안내" style="vertical-align:-5px;"></a></th>
		 			<td>
		 				<input type="text" name="giftcard_amt" id="giftcard_amt" value="0" title="" style="width:150px;" readonly>&nbsp;원
		 				<input type="hidden" name="giftcard_id" id="giftcard_id">
		 			</td>		 			
		 			<td>
		 				<a href="#none" onclick="showGift(); return false" class="btnTypeA">조회</a>
		 				<!-- <a href="#" class="btnTypeA">적용취소</a> -->
		 			</td>
		 		</tr>
		 	</table><!-- //할인받기 -->
		 	
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
		 		<p class="agreeCheck"><input id="agree" type="checkbox"><label for="agree">구매조건을 확인하였으며, 결제대행 서비스 약관에 동의합니다.</label></p>
		 	</div><!-- 이용동의 -->
		 	<!-- //회원 -->
<%
	}
%>		 	
		 	<h2 class="typeA">결제수단 선택</h2>
		 	<p class="discountInfo"><!-- <a href="">신용카드 별 결제 할인 안내</a> --></p>
		 	<div class="payWay">
		 		<input type="radio" name="pay_type" id="pay_001" value="001" <%= "001".equals(payType) ? "checked" : "" %>>
		 		<label for="pay_001" style="color:">신용카드</label>

		 		<input type="radio" name="pay_type" id="pay_002" value="002" <%= "002".equals(payType) ? "checked" : "" %>>
		 		<label for="pay_002" style="color:">계좌이체</label>

		 		<input type="radio" name="pay_type" id="pay_003" value="003" <%= "003".equals(payType) ? "checked" : "" %>>
		 		<label for="pay_003" style="color:">무통장 입금</label>

				<span class="pr">
			 		<input type="radio" name="pay_type" id="pay_011" value="011" <%= "011".equals(payType) ? "checked" : "" %>>
			 		<label for="pay_011" style="color:">토스페이</label>
			 		<%--<span class="tossBallon">첫 결제 2천원 캐시백</span>--%>
		 		</span>

<!--		 		<input type="radio" name="pay_type" id="pay_004" value="004" <%= "004".equals(payType) ? "checked" : "" %>>
 		 		<label for="pay_004" style="color:">PayNow</label> -->

<%
	if(!existsHyundaiCardPid) {
%>
		 		<input type="radio" name="pay_type" id="pay_007" value="007" <%= "007".equals(payType) ? "checked" : "" %>>
		 		<label for="pay_007" style="color:">KakaoPay</label>
<%
	}
%>

		 		<div class="line">
			 		<input type="radio" name="pay_type" id="pay_006" value="006" <%= "006".equals(payType) ? "checked" : "" %>>
			 		<label for="pay_006" style="color:red">PAYCO</label>
	
			 		<input type="radio" name="pay_type" id="pay_008" value="008" <%= "008".equals(payType) ? "checked" : "" %>>
			 		<label for="pay_008">SmilePay</label>

			 		<input type="radio" name="pay_type" id="pay_009" value="009" <%= "009".equals(payType) ? "checked" : "" %>>
			 		<label for="pay_009">네이버페이</label>
				</div>
		 	</div><!-- //결제수단 선택 -->
		 	<ul class="caption" id="npay_notice" style="display:none">
				<li>* 주문 변경 시 카드사 혜택 및 할부 적용 여부는 해당 카드사 정책에 따라 변경될 수 있습니다.</li>
		 		<li>* 네이버페이는 네이버ID로 별도 앱 설치 없이 신용카드 또는 은행계좌 정보를 등록하여 네이버페이 비밀번호로 결제할 수 있는 간편결제<br>서비스입니다.  </li>
		 		<li>* 결제 가능한 신용카드: 신한, 삼성, 현대, BC, 국민, 하나, 롯데, NH농협, 씨티, 카카오뱅크</li>
		 		<li>* 결제 가능한 은행: NH농협, 국민, 신한, 우리, 기업, SC제일, 부산, 경남, 수협, 우체국, 미래에셋대우, 광주, 대구, 전북, 새마을금고, 제주은행, 신협,<br>하나은행, 케이뱅크, 카카오뱅크, 삼성증권</li>
		 		<li>* 네이버페이 카드 간편결제는 네이버페이에서 제공하는 카드사 별 무이자, 청구할인 혜택을 받을 수 있습니다.</li>
			</ul>	
		 	<input type="hidden" name="save_pay_type" value="Y">
	 	</div>
	 	
		<div class="btnArea">
			<a href="/order/cart.jsp" class="btnTypeA sizeXL">장바구니</a>
			<a href="javascript:orderProc()" class="btnTypeB sizeXL">결제하기</a>
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
			<input type="hidden" name="GoodsName"				id="GoodsName"				value="<%= LGD_PRODUCTINFO %>">
			<input type="hidden" name="Amt"						id="Amt"					value="<%= LGD_AMOUNT %>">
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
			<input type="hidden" name="productItems" id="productItems" value='<%= jsonArr.toJSONString() %>' />
			<input type="hidden" name="productCount" id="productCount" value='<%= totQty %>' />
			
			<!-- etc -->
			<input type="hidden" name="device_type" value="<%= fs.getDeviceType() %>" />
			<input type="hidden" name="tid" id="tid" value="" />
			<input type="hidden" name="pg_token" id="pg_token" value="" />
		</form>
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
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
		document.location.href = "/order/cart.jsp";
<%
	}
%>
	});

	$("input[name=deliType]").on("change", function(){
		if($(this).is(":checked")){
			$(this).parents("label").addClass("on").siblings().removeClass("on")
		}
	})
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
	<input type="hidden" name="returnUrl" value="payco_return.jsp">
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
		
		Utils.sendMessage(out, msg, "/order/cart.jsp");
		return;
	} else if(isInvalidDdate) {
		Utils.sendMessage(out, "유효하지 않은 배송일이 지정되었습니다.\\n배송일 지정상품을 제외하고 주문하세요.", "/order/cart.jsp");
		return;
	}
%>
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
		$(".d1").html("일반배송<br>(택배배송)");
		$(".d2").html("정기배송<br>(택배배송)");
		$("#earlyInfo").hide();
	} else {
		$(".d1").html("일반배송<br>(새벽배송)");
		$(".d2").html("정기배송<br>(새벽배송)");
		$("#earlyInfo").show();
	}
}
</script>
</body>
</html>
