<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.common.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.service.product.*,
				 com.sanghafarm.service.order.*" %>
<%
	request.setAttribute("MENU_TITLE", new String("정기배송 옵션 선택"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
	String layerId = request.getParameter("layerId");
%>
<%
	String pageNum = "2";
	String subNum = "1";
	String threeNum = "0";
	
	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);
	param.set("grade_code", fs.getGradeCode());
	
	ProductService product = (new ProductService()).toProxyInstance();
	
	Param info = new Param();
	Param cartInfo = new Param();
	int qty = param.getInt("qty", 1);
	String routinePeriod = "";
	String routineDay = "";
	String routineCnt = "4";
	String mode = "CREATE";
	
	if(!"".equals(param.get("cartid"))) {
		mode = "MODIFY";
		CartService cart = (new CartService()).toProxyInstance();
		cartInfo = cart.getInfo(param);
		qty = cartInfo.getInt("qty");
		routinePeriod = cartInfo.get("routine_period");
		routineDay = cartInfo.get("routine_day");
		routineCnt = cartInfo.get("routine_cnt");
		param.set("pid", cartInfo.get("pid"));
	}

	info = product.getInfo(param);
	List<Param> dayList = product.getDeliveryDayList(param.get("pid"));
	List<Param> saleList = product.getRoutineSaleList(param.get("pid"));
	List<Param> cateList = product.getProductCateList(param.get("pid"));

	// 8월 정기배송 특가 상품 코드
	String eventPid = Config.get("evend1.pid." + SystemChecker.getCurrentName());
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script>
	var saleInfo = new Array();
	var idx = 0;
<%
	for(Param row : saleList) {
%>
	var info = {
		"pid" 		: "<%= row.get("pid") %>",
		"seq" 		: <%= row.get("seq") %>,
		"from_cnt" 	: <%= row.get("from_cnt", "0") %>,
		"to_cnt" 	: <%= row.get("to_cnt", "0") %>,
		"sale_amt" 	: <%= row.get("sale_amt", "0") %>
	};
	
	saleInfo[idx] = info;
	idx++;
<%
	}
%>
	
	$(function() {
		calculatePrice();
		calculateDate();
	});
	
	function setQty(dir) {
		if(dir == 'up') {
			$("#qty").val(parseInt($("#qty").val()) + 1);
		} else {
			if($("#qty").val() > 1) {
				$("#qty").val(parseInt($("#qty").val()) - 1);
			}
		}
		calculatePrice();
	}
	
	function setRoutineCnt(dir) {
		if(dir == 'up') {
			if(parseInt($("#routine_cnt").val()) >= 100) {
				$("#routine_cnt").val(100);
			} else {
				$("#routine_cnt").val(parseInt($("#routine_cnt").val()) + 1);
			}
		} else {
			if($("#routine_cnt").val() > 4) {
				$("#routine_cnt").val(parseInt($("#routine_cnt").val()) - 1);
			} else {
				$("#routine_cnt").val(4);
			}
		}
		calculatePrice();
	}
	
	function calculatePrice() {
		var price = <%= info.get("sale_price") %>;
		var saleType = "<%= info.get("routine_sale_type") %>";
		var cnt = parseInt($("#routine_cnt").val());
		var qty = parseInt($("#qty").val());
		var amt = 0;

		for(var i = 0; i < saleInfo.length; i++) {
			if(cnt >= saleInfo[i].from_cnt && cnt <= saleInfo[i].to_cnt) {
				if(amt < saleInfo[i].sale_amt) {
					amt = saleInfo[i].sale_amt;
				}
			}
		}
		
		//alert(amt);
		var saleAtmt = 0;
		if(saleType == "A") {
			saleAmt = amt * qty * cnt;
		} else {
			saleAmt = price * qty * amt * cnt / 100;
		}
		
		//alert(saleAmt);
		$("#price_txt1").html((price * qty * cnt).formatMoney() + " 원");
		$("#price_txt2").html("-" + saleAmt.formatMoney());
		$("#price_txt3").html(((price * qty * cnt) - saleAmt).formatMoney());
	}
	
	function calculateDate() {
		if($("input[name=routine_day]:checked").length == 0) {
			$("#first_date").html("&nbsp;");
		} else {
			var dayName = [ "일", "월", "화", "수", "목", "금", "토" ];
			var daysArr = new Array();
			var dayTxt = "";
			$("input[name=routine_day]:checked").each(function() {
				daysArr.push($(this).val());
				dayTxt += "·" + dayName[parseInt($(this).val()) - 1];
			});
			
			var param = {
					days : daysArr,
					period : $("input[name=routine_period]:checked").val(),
					cnt : $("input[name=routine_cnt]").val(),
					pid : "<%= param.get("pid") %>"
			};
			
			$.ajax({
				method : "POST",
				url : "getDates.jsp",
				data : param,
				dataType : "json"
			})
			.done(function(json) {
				$("#first_date").html(json.syear + "-" + json.smonth + "-" + json.sdate + "(" + json.sday + ")");
			});
		}
		
		calculatePrice();
	}

	//장바구니담기 완료
	function showCartDone(_type){
		if($("input[name=routine_period]:checked").size() == 0) {
			alert("수령주기를 선택하세요.");
			return;
		}
		if($("input[name=routine_day]:checked").size() == 0) {
			alert("수령요일을 선택하세요.");
			return;
		}

		$("#cartForm").attr("action", "/order/cartProc.jsp");
		$("#cartForm").attr("target", "");
		$("#cartForm input[name=mode]").val("<%= mode %>");
		if(_type == 'd') {
			$("#cartForm input[name=order_yn]").val("Y");
		}
		
		ajaxSubmit($("#cartForm"), function(json) {
			if(json.result) {
				/*
<%
	if("CREATE".equals(mode)) {
%>
				var arrPnm = [];
				var etEx = ET.getElementDataExtractor();
				//기존소스
				//arrPnm.push('<%= info.get("pnm") %>');
				arrPnm.push({
					productName: '<%= info.get("pnm") %>',
					productPrice: etEx.extractValue("#price_txt3"),
					productUrl: '<%= Env.getURLPath() %>/product/detail.jsp?pid=<%= param.get("pid") %>',
					productImg: '<%= Env.getURLPath() %><%= info.get("image1") %>'
				});
			
				var arrCate = [];
<%
		for(Param r : cateList) {
%>
				arrCate.push('<%= r.get("cate_name") %>');
<%
		}
%>
// 				ET.exec('cart', arrPnm, arrCate);
				parent.ET.exec('cart', JSON.stringify(arrPnm), arrCate); 
				*/				
				if(_type == 'd') {
<%
		if(fs.isLogin()) {
%>
					parent.document.location.href="/order/payment.jsp";
<%
		} else {
%>
					showPopupLayer('/popup/memberGate.jsp', '580');
					hidePopupLayer(<%=layerId%>, 'reset');
<%
		}
%>
				} else {
	 				showPopupLayer('/popup/cartComplete.jsp', '580');
	 				hidePopupLayer(<%=layerId%>, 'reset');
				}
<%
	} else {
%>
				parent.location.reload();
<%
	}
%>
			} else {
				alert(json.msg);
			}
		});
	}
</script>
</head>  
<body class="popup">
<div id="popWrap">
	<h1><%=MENU_TITLE %></h1>
	<div id="popCont">
	<!-- 내용영역 -->
		<form name="cartForm" id="cartForm" method="post">
			<input type="hidden" name="mode" value="<%= mode %>" />
			<input type="hidden" name="cartid" value="<%= param.get("cartid") %>" />
			<input type="hidden" name="pid" value="<%= param.get("pid") %>" />
			<input type="hidden" name="sub_pid" value="<%= param.get("pid") %>" />
			<input type="hidden" name="routine_yn" value="Y" />
			<input type="hidden" name="order_yn" value="N" />
		<table class="bbsForm typeB optionForm">
			<caption>정기배송 옵션 선택 폼</caption>
			<colgroup>
				<col width="100"><col width="">
			</colgroup>
			<tr>
				<th scope="row">상품명</th>
				<td><%= info.get("pnm") %></td>
			</tr>
			<tr class="divide">
				<th scope="row">1회 배송수량</th>
				<td>
					<p class="countNum">
						<a href="#none" onclick="setQty('dn')"><img src="/images/btn/btn_minus.png" alt="-"></a>
						<input type="text" name="qty_<%= param.get("pid") %>" id="qty" value="<%= qty %>" readonly>
						<a href="#none" onclick="setQty('up')"><img src="/images/btn/btn_plus.png" alt="+"></a>
					</p>
				</td>
			</tr>
			<tr>
				<th scope="row">총 배송 횟수</th>
				<td>
					<p class="countNum">
						<a href="#none" onclick="setRoutineCnt('dn')"><img src="/images/btn/btn_minus.png" alt="-"></a>
						<input type="text" name="routine_cnt" id="routine_cnt" value="<%= routineCnt %>" readonly>
						<a href="#none" onclick="setRoutineCnt('up')"><img src="/images/btn/btn_plus.png" alt="+"></a>
					</p>
				</td>
			</tr>
			<tr>
				<th scope="row">수령 주기</th>
				<td>
					<input type="radio" name="routine_period" value="1" id="period1" <%= "1".equals(routinePeriod) ? "checked" : "" %>><label for="period1">매주</label>
					<input type="radio" name="routine_period" value="2" id="period2" <%= "2".equals(routinePeriod) ? "checked" : "" %>><label for="period2">2주</label>
					<input type="radio" name="routine_period" value="3" id="period3" <%= "3".equals(routinePeriod) ? "checked" : "" %>><label for="period3">3주</label>
					<input type="radio" name="routine_period" value="4" id="period4" <%= "4".equals(routinePeriod) ? "checked" : "" %>><label for="period4">4주</label>
				</td>
			</tr>
			<tr>
				<th scope="row">수령 요일</th>
				<td>
<%
	for(Param row : dayList) {
%>
					<input type="checkbox" name="routine_day" id="day_<%= row.get("day") %>" value="<%= row.get("day") %>" <%= routineDay.indexOf(row.get("day")) != -1 ? "checked" : "" %> onclick="calculateDate()"><label for="day_<%= row.get("day") %>"><%= row.get("day_name") %></label>
<%
	}
%>
				</td>
			</tr>
		</table>
		<dl class="regularSrmy">
			<dt>첫 배송예정일</dt><dd id="first_date" <%= eventPid.equals(param.get("pid")) ? "class=\"fontTypeA\"" : "" %>>&nbsp;</dd>
			<dt>총 상품 금액</dt><dd id="price_txt1">0 원</dd>
			<dt>정기배송 할인</dt><dd><strong class="fontTypeA" id="price_txt2"></strong> 원</dd>
			<dt>결제 예상 금액</dt><dd><strong class="fontTypeA" id="price_txt3"></strong> 원</dd>
		</dl>
		<div class="btnArea">
<%
	if(!"".equals(param.get("cartid"))) {
%>
			<a href="#none" onclick="hidePopupLayer(); return false" class="btnTypeA sizeL">취소</a>
			<a href="#none" onclick="showCartDone();return false;" class="btnTypeB sizeL">적용</a>
<%
	} else {
%>
			<a href="#none" onclick="showCartDone();return false;" class="btnTypeA sizeL">장바구니 담기</a>
			<a href="#none" onclick="showCartDone('d');return false;" target="_parent" class="btnTypeB sizeL">바로구매</a>
<%
	}
%>
		</div>
		</form>
	<!-- //내용영역 -->
	</div><!-- //popCont -->
</div><!-- //popWrap -->
<script>
//팝업높이조절
setPopup(<%=layerId%>);
</script>
</body>
</html>