<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.common.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.utils.*,
				 com.sanghafarm.service.order.*,
				 com.sanghafarm.service.product.*,
				 com.sanghafarm.service.code.*,
				 com.sanghafarm.service.promotion.*" %>
<%
	request.setAttribute("Depth_1", new Integer(2));
	request.setAttribute("Depth_2", new Integer(2));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("장바구니"));
%>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	CartService cart = (new CartService()).toProxyInstance();
	ProductService product = (new ProductService()).toProxyInstance();
	CodeService code = new CodeService();
	SecondAnniversaryService sa = new SecondAnniversaryService();
	
	String userid = "";
	
	if(fs.isLogin()) userid = fs.getUserId();
	else userid = fs.getTempUserId();
	
	param.set("userid", userid);
	param.set("grade_code", fs.getGradeCode());
	
	// 배송가능일 지난 상품 삭제
	cart.removeOldDeliveryDate(userid);

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

	// 8월 정기배송 특가 상품 코드
	String eventPid = Config.get("evend1.pid." + SystemChecker.getCurrentName());

	// 2주년 프로모션 정보
	Param saInfo = sa.getInfo();
	List<String> saList = sa.getProductList(saInfo.getLong("seq"));
	
	// 2주년 프로모션 체크용 List
	List<Param> saList1 = new ArrayList<Param>();
	List<Param> saList2 = new ArrayList<Param>();
	List<Param> saList3 = new ArrayList<Param>();
	List<Param> saList4 = new ArrayList<Param>();
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<script>
	$(function() {
		cal();
	});

	function removeCart() {
		if($("input[name='cartid']:checked").length == 0) {
			alert("선택된 상품이 없습니다.");
			return;
		}
		
// 		if(confirm("정말로 삭제하시겠습니까?")) {
			$("#cartForm").attr("action", "/order/cartProc.jsp");
			$("#cartForm").attr("target", "");
			$("#cartForm input[name=mode]").val("REMOVE");
		
			ajaxSubmit($("#cartForm"), function(json) {
				alert(json.msg);
				if(json.result) {
// 					document.location.reload();
					document.location.href = document.location.href;
				}
			});
// 		}	
	}

	function checkAll() {
		var b = $("input[name='check_all']").prop("checked");
		$("input[name='cartid']").each(function(){
			$(this).prop("checked", b);
		});
		
		cal();
	}

	function sendWishList() {
		if($("input[name='cartid']:checked").length == 0) {
			alert("선택된 상품이 없습니다.");
			return;
		}

		$("#cartForm").attr("action", "/mypage/wishProc.jsp");
		$("#cartForm").attr("target", "");
		$("#cartForm input[name=mode]").val("CART");

		ajaxSubmit($("#cartForm"), function(json) {
			alert(json.msg);
			if(json.result) {
				//document.location.reload();
			}
		});
	}

	function order() {
		cal();

		if($("input[name='cartid']:checked").length == 0) {
			alert("선택된 상품이 없습니다.");
			return;
		}
<%
	if(fs.isLogin()) {
%>
		submitOrder();
<%
	} else {
%>
		showMemberPop();
<%
	}
%>
	}
	
	function orderAll() {
		$("input[name='cartid']").each(function(){
			$(this).prop("checked", true);
		});
		
		order();
	}

	function submitOrder() {
		$("#cartForm").attr("action", "/mobile/order/payment.jsp");
		$("#cartForm").attr("target", "");
		$("#cartForm input[name=mode]").val("ORDER");
		$("#cartForm").submit();
	}
	
	function showMemberPop() {
		showPopupLayer('/mobile/popup/memberGate.jsp?call=cart');
// 		submitOrder();
	}

	function setQty(dir, pid) {
		if(dir == 'up') {
			$("#qty_" + pid).val(parseInt($("#qty_" + pid).val()) + 1);
		} else {
			if($("#qty_" + pid).val() != 1) {
				$("#qty_" + pid).val(parseInt($("#qty_" + pid).val()) - 1);
			}
		}
	}
	
	function modifyQty(cartid) {
		$("#cartForm2 input[name=cartid]").val(cartid);
		$("#cartForm2 input[name=qty]").val($("#qty_" + cartid).val());
		$("#cartForm2 input[name=delivery_date]").val($("#delivery_date_" + cartid).val());

		ajaxSubmit($("#cartForm2"), function(json) {
			alert(json.msg);
			if(json.result) {
				document.location.reload();
			}
		});
	}

	function cal() {
		var totAmt = 0;
		var totAmt1 = 0;
		var totAmt2 = 0;
		var totAmt4 = 0;
		var shipAmt = 0;
		var shipAmt1 = 0;
		var shipAmt2 = 0;
		var shipAmt4 = 0;
		
		$("input[name=cartid]:checked").each(function() {
			totAmt += parseInt($("#sale_price_" + $(this).val()).val());
			if($("#ptype_" + $(this).val()).val() == 'A') {
				totAmt1 += parseInt($("#sale_price_" + $(this).val()).val());
			} else if($("#ptype_" + $(this).val()).val() == 'C') {
				totAmt2 += parseInt($("#sale_price_" + $(this).val()).val());
			} else if($("#ptype_" + $(this).val()).val() == 'D') {
				totAmt4 += parseInt($("#sale_price_" + $(this).val()).val());
			}
		});
		
		shipAmt1 = totAmt1 == 0 || totAmt1 >= <%= Config.getInt("shipping.free.amt") %> ? 0 : <%= Config.getInt("shipping.amt") %>;
		shipAmt2 = totAmt2 == 0 || totAmt2 >= <%= Config.getInt("shipping.free.amt") %> ? 0 : <%= Config.getInt("shipping.amt") %>;
		shipAmt4 = totAmt4 == 0 || totAmt4 >= <%= Config.getInt("shipping.free.amt") %> ? 0 : <%= Config.getInt("shipping.amt") %>;
		shipAmt = shipAmt1 + shipAmt2 + shipAmt4;
		
		$("#tot_amt_txt").empty().html(totAmt.formatMoney());
		$("#ship_amt_txt").empty().html(shipAmt.formatMoney());
		$("#sum_amt_txt").empty().html((totAmt + shipAmt).formatMoney());
		$("#totAmt").empty().html((totAmt + shipAmt).formatMoney());
		
		if($("#cartForm input[name=cartid]").not(":checked").length > 0) {
			$("input[name=check_all]").prop("checked", false);
		} else {
			$("input[name=check_all]").prop("checked", true);
		}
	}
</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/mobile/include/header.jsp" /> 	
	<div id="container">
	<!-- 내용영역 -->
		<form name="cartForm2" id="cartForm2" method="post" action="cartProc.jsp">
			<input type="hidden" name="mode" value="MODIFY_QTY" />
			<input type="hidden" name="cartid" value="" />
			<input type="hidden" name="qty" value="" />
			<input type="hidden" name="delivery_date" value="" />
		</form>
		<form name="cartForm" id="cartForm" method="post">
			<input type="hidden" name="mode" value="REMOVE" />
		<div class="orderTit">
			<h1>장바구니</h1>
			<ul class="step">
				<li class="on"><span>장바구니</span></li>
				<li><span>주문/결제</span></li>
				<li><span>주문완료</span></li>
			</ul>
		</div>
		<p class="totalPriceSrmy"><span class="fl">총 결제 금액</span><span class="fontTypeA"><strong id="totAmt"></strong>원</span></p>
		<div class="bbsHead">
			<p class="fl fb">장바구니 <span class="fontTypeA"><%= Utils.formatMoney(list1.size() + list2.size() + list3.size() + list4.size()) %></span>개</p>
<%
	if(list1.size() + list2.size() + list3.size() + list4.size() > 0) {
%>
			<div class="cartBtn">
				선택한 상품을
				<a href="#none" onclick="removeCart(); return false;" class="btnTypeC sizeXS">삭제</a>
				<a href="#none" onclick="sendWishList();" class="btnTypeA sizeXS">단골상품</a>
			</div>
<%
	}
%>
		</div>
		<div class="orderPdtList">
			<div class="head">
				<input type="checkbox" name="check_all" onclick="checkAll();" id="check_all" checked><label for="check_all">전체선택</label>
			</div>
			<ul>
<%
	// 배송비 계산 -----------------
	int totalPrice1 = 0;
	for(Param row : list1) {
		totalPrice1 += row.getInt("sale_price") * row.getInt("qty");
	}
	int shipAmt1 = totalPrice1 == 0 || totalPrice1 >= Config.getInt("shipping.free.amt") ? 0 : Config.getInt("shipping.amt");

	int totalPrice2 = 0;
	for(Param row : list2) {
		totalPrice2 += row.getInt("sale_price") * row.getInt("qty");
	}
	int shipAmt2 = totalPrice2 == 0 || totalPrice2 >= Config.getInt("shipping.free.amt") ? 0 : Config.getInt("shipping.amt");

	int totalPrice4 = 0;
	for(Param row : list4) {
		totalPrice4 += row.getInt("sale_price") * row.getInt("qty");
	}
	int shipAmt4 = totalPrice4 == 0 || totalPrice4 >= Config.getInt("shipping.free.amt") ? 0 : Config.getInt("shipping.amt");

	int shipAmt = shipAmt1 + shipAmt2 + shipAmt4;
	//-----------------------------------------
	
	// 일반상품
	int totalPrice = 0;
	for(int i = 0; i < list1.size(); i++) {
		Param row = list1.get(i);
		int salePrice = row.getInt("sale_price") * row.getInt("qty");
		totalPrice += salePrice;
		boolean isSoldOut = ("N".equals(row.get("sale_status")) || "N".equals(row.get("sub_sale_status")) || row.getInt("stock") == 0);
%>
				<li>
<%
		if(isSoldOut) {
%>
					<div class="prdDim">
						<p><%= code.getCode2Name("028", row.get("soldout_msg", "001")) %></p>
					</div>
<%
		}
%>
					<p class="chk">
						<input type="checkbox" name="cartid" value="<%= row.get("cartid") %>" onclick="cal()" <%= isSoldOut ? "" : "checked" %>>
						<input type="hidden" name="sale_price" id="sale_price_<%= row.get("cartid") %>" value="<%= salePrice %>" />
						<input type="hidden" name="ptype" id="ptype_<%= row.get("cartid") %>" value="A" />
					</p>
					<p class="thumb"><a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%= row.get("opt_thumb") %>" alt=""></a></p>
					<div class="content">
						<div class="tit"><a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>">
							<%= row.get("pnm") %>
							<p class="opt"><%= row.get("sub_opt_pnm") %></p>
						</a></div>
						<p class="price"><strong><%= Utils.formatMoney(row.getInt("sale_price") * row.getInt("qty")) %></strong>원</p>
						<div class="btn">
							<p class="countNum">
								<a href="#none" onclick="setQty('dn', '<%= row.get("cartid") %>')"><img src="/mobile/images/btn/btn_minus.png" alt="-"></a>
								<input type="text" name="qty" value="<%= row.get("qty") %>" id="qty_<%= row.get("cartid") %>" readonly>
								<a href="#none" onclick="setQty('up', '<%= row.get("cartid") %>')"><img src="/mobile/images/btn/btn_plus.png" alt="+"></a>
							</p>
							<a href="#none" onclick="modifyQty('<%= row.get("cartid") %>')" class="btnTypeA">적용</a>
						</div>	
					</div>
				</li>
<%
		if(i == list1.size()-1) {
%>
				<li class="delivery">
					<p>
						일반배송 묶음<br><%= Utils.formatMoney(totalPrice1) %>원 + 배송비 <%= shipAmt1 == 0 ? "무료" : Utils.formatMoney(shipAmt1) + "원" %>
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
	}

	// 산지직송 상품
	for(int i = 0; i < list2.size(); i++) {
		Param row = list2.get(i);
		int salePrice = row.getInt("sale_price") * row.getInt("qty");
		totalPrice += salePrice;
		boolean isSoldOut = ("N".equals(row.get("sale_status")) || "N".equals(row.get("sub_sale_status")) || row.getInt("stock") == 0);
%>
				<li>
<%
		if(isSoldOut) {
%>
					<div class="prdDim">
						<p><%= code.getCode2Name("028", row.get("soldout_msg", "001")) %></p>
					</div>
<%
		}
%>
					<p class="chk">
						<input type="checkbox" name="cartid" value="<%= row.get("cartid") %>" onclick="cal()" <%= isSoldOut ? "" : "checked" %>>
						<input type="hidden" name="sale_price" id="sale_price_<%= row.get("cartid") %>" value="<%= salePrice %>" />
						<input type="hidden" name="ptype" id="ptype_<%= row.get("cartid") %>" value="C" />
					</p>
					<p class="thumb"><a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%= row.get("opt_thumb") %>" alt=""></a></p>
					<div class="content">
						<div class="tit"><a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>">
							<%= row.get("pnm") %>
							<p class="opt"><%= row.get("sub_opt_pnm") %></p>
						</a></div>
						<p class="price"><strong><%= Utils.formatMoney(row.getInt("sale_price") * row.getInt("qty")) %></strong>원</p>
						<div class="btn">
							<p class="countNum">
								<a href="#none" onclick="setQty('dn', '<%= row.get("cartid") %>')"><img src="/mobile/images/btn/btn_minus.png" alt="-"></a>
								<input type="text" name="qty" value="<%= row.get("qty") %>" id="qty_<%= row.get("cartid") %>" readonly>
								<a href="#none" onclick="setQty('up', '<%= row.get("cartid") %>')"><img src="/mobile/images/btn/btn_plus.png" alt="+"></a>
							</p>
							<a href="#none" onclick="modifyQty('<%= row.get("cartid") %>')" class="btnTypeA">적용</a>
						</div>	
					</div>
				</li>
<%
		if(i == list2.size()-1) {
%>
				<li class="delivery">	
					<p>
						산지직송 묶음<br><%= Utils.formatMoney(totalPrice2) %>원 + 배송비 <%= shipAmt2 == 0 ? "무료" : Utils.formatMoney(shipAmt2) + "원" %>
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
	}
	
	// 정기배송상품
	for(Param row : list3) {
		String routineDay = row.get("routine_day");
		routineDay = routineDay.replaceAll("1", "일");
		routineDay = routineDay.replaceAll("2", "월");
		routineDay = routineDay.replaceAll("3", "화");
		routineDay = routineDay.replaceAll("4", "수");
		routineDay = routineDay.replaceAll("5", "목");
		routineDay = routineDay.replaceAll("6", "금");
		routineDay = routineDay.replaceAll("7", "토");

		int salePrice = 0;
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

		salePrice = price - routineSaleAmt - couponSaleAmt;
		totalPrice += salePrice;
		boolean isSoldOut = ("N".equals(row.get("sale_status")) || "N".equals(row.get("sub_sale_status")) || row.getInt("stock") == 0);

		String firstDeliveryDate = "";
		if(eventPid.equals(row.get("sub_pid"))) {
			firstDeliveryDate = SanghafarmUtils.getFirstDeliveryDate(row.get("routine_day").split(","), "yyyy-MM-dd", "20170803");
		} else {
			firstDeliveryDate = SanghafarmUtils.getFirstDeliveryDate(row.get("routine_day").split(","), "yyyy-MM-dd");
		}
%>
				<li class="regular">
<%
		if(isSoldOut) {
%>
					<div class="prdDim">
						<p><%= code.getCode2Name("028", row.get("soldout_msg", "001")) %></p>
					</div>
<%
		}
%>
					<p class="chk">
						<input type="checkbox" name="cartid" value="<%= row.get("cartid") %>" onclick="cal()" <%= isSoldOut ? "" : "checked" %>>
						<input type="hidden" name="sale_price" id="sale_price_<%= row.get("cartid") %>" value="<%= salePrice %>" />
						<input type="hidden" name="ptype" id="ptype_<%= row.get("cartid") %>" value="" />
					</p>
					<p class="thumb"><a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%= row.get("opt_thumb") %>" alt=""></a></p>
					<div class="content">
						<div class="tit"><a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>">
							<%= row.get("pnm") %>
							<p class="opt"><%= row.get("sub_opt_pnm") %></p>
						</a></div>
						<p class="price"><strong><%= Utils.formatMoney(salePrice) %></strong>원</p>
						<div class="btn">
							<a href="#" onclick="showPopupLayer('/mobile/popup/regularOption.jsp?cartid=<%= row.get("cartid") %>'); return false" class="btnTypeA">옵션변경</a>
						</div>	
					</div>
					<div class="foot">
						<p class="cycle"><strong>정기배송상품</strong><%= row.get("routine_period") %>주마다 / <%= routineDay %> / <%= row.get("routine_cnt") %>회 / <%= firstDeliveryDate %> 부터</p>
					</div>					
				</li>
				<li class="delivery">	
					<p>정기배송<br><%= row.get("routine_cnt") %>회*<%= Config.getInt("shipping.amt") %>원 <span class="fontTypeB">= <span class="through"><%= Utils.formatMoney(Config.getInt("shipping.amt") * row.getInt("routine_cnt")) %>원</span> <strong>무료</strong></span></p>
				</li>
<%
	}

	// 배송일 지정 상품
	for(int i = 0; i < list4.size(); i++) {
		Param row = list4.get(i);
		int salePrice = row.getInt("sale_price") * row.getInt("qty");
		totalPrice += salePrice;
		boolean isSoldOut = ("N".equals(row.get("sale_status")) || "N".equals(row.get("sub_sale_status")) || row.getInt("stock") == 0);
%>		
				<!-- 날짜지정배송 -->
				<li>
<%
		if(isSoldOut) {
%>
					<div class="prdDim">
						<p><%= code.getCode2Name("028", row.get("soldout_msg", "001")) %></p>
					</div>
<%
		}
%>
					<p class="chk">
						<input type="checkbox" name="cartid" value="<%= row.get("cartid") %>" onclick="cal()" <%= isSoldOut ? "" : "checked" %>>
						<input type="hidden" name="sale_price" id="sale_price_<%= row.get("cartid") %>" value="<%= salePrice %>">
						<input type="hidden" name="ptype" id="ptype_<%= row.get("cartid") %>" value="D">
					</p>
					<p class="thumb"><a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>"><img src="<%= row.get("opt_thumb") %>" alt=""></a></p>
					<div class="content">
						<div class="tit"><a href="/mobile/product/detail.jsp?pid=<%= row.get("pid") %>">
							<%= row.get("pnm") %>
							<p class="opt"><%= row.get("sub_opt_pnm") %></p>
						</a></div>
						<p class="price"><strong><%= Utils.formatMoney(row.getInt("sale_price") * row.getInt("qty")) %></strong>원</p>
						<div class="btn">
							<p class="countNum">
								<a href="#none" onclick="setQty('dn', '<%= row.get("cartid") %>')"><img src="/mobile/images/btn/btn_minus.png" alt="-"></a>
								<input type="text" name="qty" value="<%= row.get("qty") %>" id="qty_<%= row.get("cartid") %>" readonly="">
								<a href="#none" onclick="setQty('up', '<%= row.get("cartid") %>')"><img src="/mobile/images/btn/btn_plus.png" alt="+"></a>
							</p>
							<a href="#none" onclick="modifyQty('<%= row.get("cartid") %>')" class="btnTypeA">적용</a>
						</div>
					</div>
					<div class="foot">
						<p class="deliveryDateCart">
							<strong>배송일지정</strong>
							<select name="delivery_date" title="배송일 선택" id="delivery_date_<%= row.get("cartid") %>">
<%
		List<Param> deliveryDateList = product.getDeliveryDateList(row.get("pid"));

		for(Param d : deliveryDateList) {
%>
								<option value="<%= d.get("delivery_date") %>" <%= d.get("delivery_date").equals(row.get("delivery_date")) ? "selected" : "" %>><%= d.get("delivery_date") %></option>
<%
		}
%>
							</select>
						</p>
					</div>	
				</li>
<%
		if(i == list4.size()-1) {
%>
				<li class="delivery">	
					<p>
						날짜지정배송<br><%= Utils.formatMoney(totalPrice4) %>원 + 배송비 <%= shipAmt4 == 0 ? "무료" : Utils.formatMoney(shipAmt4) + "원" %>
<%
			if(shipAmt4 > 0) {
%>
						<span class="free"><%= Utils.formatMoney(Config.getInt("shipping.free.amt") - totalPrice4) %>원 추가주문시, <strong>무료배송</strong></span>
<%
			}
%>
					</p>
				</li>
<%
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
	}

	if(list1.size() + list2.size() + list3.size() + list4.size() == 0) {
%>
				<li>장바구니에 담긴 상품이 없습니다.</li>
<%
	}
%>
			</ul>
		</div>

<%
	if(list1.size() + list2.size() + list3.size() + list4.size() > 0) {
%>		
		<div class="totalPrice">
			<p>상품 소계 <em><strong id="tot_amt_txt"><%= Utils.formatMoney(totalPrice) %></strong>원</em></p>
			<p>총 배송비 <em><strong id="ship_amt_txt"><%= Utils.formatMoney(shipAmt) %></strong>원</em></p>
			<p class="total">총 결제 금액 <em><strong class="fontTypeA" id="sum_amt_txt"><%= Utils.formatMoney(totalPrice + shipAmt) %></strong>원</em></p>
		</div>
		<div class="btnArea">
			<span><a href="#none" onclick="order(); return false;" class="btnTypeA sizeL">선택 주문</a></span>
			<span><a href="#none" onclick="orderAll(); return false;" class="btnTypeB sizeL">전체 주문</a></span>
		</div>
<%
	}
%>
		</form>
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
<script>
$("#totAmt").html('<%= totalPrice > 0 ? Utils.formatMoney(totalPrice + shipAmt) : 0 %>');
</script>

<script>
	$(function() {
<%
	if(saList1 != null && saList1.size() > 0) {
		String msg = "비회원은 주문할 수 없는 프로모션상품이 있습니다.\\n";
		for(Param row : saList1) {
			msg += "   -" + row.get("pnm") + " - " + row.get("sub_opt_pnm") + "\\n";
		}
		msg += "\\n로그인 후 이용하시거나 해당 상품을 제외하고 비회원 주문이 가능합니다.";
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
%>
		alert("<%= msg %>");
<%
	}
%>
	});
</script>
</body>
</html>
