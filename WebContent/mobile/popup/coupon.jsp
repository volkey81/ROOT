<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.service.order.*"%>
<%
	request.setAttribute("MENU_TITLE", new String("쿠폰 적용"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
	String layerId = request.getParameter("layerId");
%>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	CartService cart = (new CartService()).toProxyInstance();
	CouponService coupon = (new CouponService()).toProxyInstance();
	
	String userid = "";
	if(fs.isLogin()) userid = fs.getUserId();
	else userid = fs.getTempUserId();
	
	param.set("userid", userid);
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

	List<String> couponList = new ArrayList<String>();
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" />
<script>
	var totalAmt = 0;
	var saleAmt = 0;
	var saleAmt1 = 0;
	var saleAmt2 = 0;
	var saleAmt3 = 0;
	var shipAmt = 0;

	function selectCoupon001(obj) {
		$("select[name=coupon001]").each(function() {
			if($(obj).val() != "" && $(obj).attr("id") != $(this).attr("id") && $(obj).val() == $(this).val()) {
				alert("이미 선택하신 쿠폰입니다.");
				$(obj).val("");
				return false;
			}
		});

		cal();
		return true;
	}
	
	function cal() {
		totalAmt = 0;
		saleAmt1 = 0;
		$("select[name=coupon001]").each(function() {
			var amt = parseInt($(this).parent().parent().find("input[name=amt]").val());

			if($(this).val() != "") {
				var arr = $(this).val().split("|");
				var saleAmt = 0;
				
				if(arr[1] == "A") {	// 정량
					saleAmt = parseInt(arr[2]);
				} else {	// 정률
					saleAmt = parseInt((parseInt(arr[2]) * amt / 100 >= parseInt(arr[3])) ? parseInt(arr[3]) : parseInt(arr[2]) * amt / 100);
				}
				
				totalAmt += amt - saleAmt
				saleAmt1 += saleAmt
				$(this).parent().parent().find("input[name=coupon001_amt]").val(saleAmt);
			} else {
				totalAmt += amt
				$(this).parent().parent().find("input[name=coupon001_amt]").val("0");
			}
		});
		
		$("#saleAmt001").html(saleAmt1.formatMoney());
		
		// 장바구니쿠폰
		if($("select[name=coupon002]").val() == "") {
			$("#saleAmt002").html("0");
			$("input[name=coupon002_amt]").val("0");
		} else {
			var arr = $("select[name=coupon002]").val().split("|");

			if(arr[1] == "A") {	// 정량
				saleAmt2 = parseInt(arr[2]);
			} else {	// 정률
// 				saleAmt2 = (parseInt(arr[2]) * totalAmt / 100 >= parseInt(arr[3])) ? parseInt(arr[3]) : parseInt(parseInt(arr[2]) * totalAmt / 100);
				$.ajax({
					method : "GET",
					url : "/ajax/cartCouponInfo.jsp",
					data : { mem_couponid : arr[0] },
					dataType : "json",
					async : false
				})
				.done(function(json) {
					var _amt = 0;
					$("input[name=cartid]").each(function(idx) {
						var isExclude = false;
						var exclude = json.EXCLUDE;
						$.each(exclude, function(i, item) {
							if($($("input[name=pid]")[idx]).val() == item.PID) {
								isExclude = true;
							}
						});
						
						if(!isExclude) {
							_amt += (parseInt($($("input[name=amt]")[idx]).val()) - parseInt($($("input[name=coupon001_amt]")[idx]).val()));
						}
					})
	 				saleAmt2 = (parseInt(arr[2]) * _amt / 100 >= parseInt(arr[3])) ? parseInt(arr[3]) : parseInt(parseInt(arr[2]) * _amt / 100);
				});
			}

			$("input[name=coupon002_amt]").val(saleAmt2);
			$("#saleAmt002").html(saleAmt2.formatMoney());
		}

		// 배송비쿠폰
		if($("select[name=coupon003]").val() == "") {
			$("#saleAmt003").html("0");
			$("input[name=coupon003_amt]").val("0");
		} else {
			var arr = $("select[name=coupon003]").val().split("|");

			if(arr[1] == "A") {	// 정량
				saleAmt3 = parseInt(arr[2]);
			} else {	// 정률
//				saleAmt3 = (parseInt(arr[2]) * <%= Config.get("shipping.amt") %> / 100 >= parseInt(arr[3])) ? parseInt(arr[3]) : parseInt(arr[2]) * <%= Config.get("shipping.amt") %> / 100;
				saleAmt3 = (parseInt(arr[2]) * shipAmt / 100 >= parseInt(arr[3])) ? parseInt(arr[3]) : parseInt(arr[2]) * shipAmt / 100;
			}

			$("input[name=coupon003_amt]").val(saleAmt3);
			$("#saleAmt003").html(saleAmt3.formatMoney());
		}

		saleAmt = saleAmt1 + saleAmt2 + saleAmt3;
		$("#saleAmt").html(saleAmt.formatMoney());
	}
	
	function apply() {
		var coupons = new Array();
		var idx = 0;
		$("select[name=coupon001]").each(function() {
			if(!selectCoupon001($(this))) {
				return false;
			}
			
			if($(this).val() != "") {
				var c = {
					"coupon_type" : "001",
					"cartid" : $(this).parent().parent().find("input[name=cartid]").val(),
					"coupon" : $(this).val(),
					"coupon_amt" : $(this).parent().parent().find("input[name=coupon001_amt]").val()
				};
				coupons[idx++] = c;
			}
		});	
		
		if($("select[name=coupon002]").val() != "") {
			var c = {
				"coupon_type" : "002",
				"cartid" : "",
				"coupon" : $("select[name=coupon002]").val(),
				"coupon_amt" : $("input[name=coupon002_amt]").val()
			};
			coupons[idx++] = c;
		}
		
		if($("select[name=coupon003]").val() != "") {
			var c = {
				"coupon_type" : "003",
				"cartid" : "",
				"coupon" : $("select[name=coupon003]").val(),
				"coupon_amt" : $("input[name=coupon003_amt]").val()
			};
			coupons[idx++] = c;
		}
		
		parent.applyCoupon(coupons, saleAmt);
		hidePopupLayer();
	}
</script>
</head>  
<body class="popup">
<div id="popWrap">
	<h1><%=MENU_TITLE %></h1>
	<div id="popCont">
	<!-- 내용영역 -->
		<div class="myCoupon">
			<div class="head">
				<h2 class="typeB">상품할인 쿠폰 <span class="num" id="saleCouponCnt">0</span></h2>
				<p class="price">할인금액 : <span class="fontTypeA" id="saleAmt001">0</span>원</p>
			</div>
<%
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

	int totalPrice = 0;
	int couponCnt1 = 0;
	int couponCnt2 = 0;
	int couponCnt3 = 0;
	int couponCnt4 = 0;
	
	// 일반상품
	for(Param row : list1) {
		int amt = row.getInt("sale_price") * row.getInt("qty");
		totalPrice += amt;

		Param p = new Param();
		p.set("userid", fs.getUserId());
		p.set("device_type", fs.getDeviceType());
		p.set("grade_code", fs.getGradeCode());
		p.set("pid", row.get("sub_pid"));
		p.set("min_price", amt);
		
		List<Param> cList = coupon.getApplyableList(p);
		couponCnt1 = cList.size();
%>
			<div class="coupon">
				<input type="hidden" name="cartid" value="<%= row.get("cartid") %>" />			
				<input type="hidden" name="pid" value="<%= row.get("sub_pid") %>" />			
				<input type="hidden" name="amt" value="<%= amt %>" />			
				<input type="hidden" name="coupon001_amt" value="0" />			
				<p class="tit"><%= row.get("pnm") %><br><span class="opt"><%= row.get("sub_opt_pnm") %></span></p>
				<div class="cont">
					<select name="coupon001" id="coupon001_<%= row.get("cartid") %>" title="상품할인쿠폰 선택" onchange="selectCoupon001(this)">
<%
		if(cList.size() == 0) {
%>
						<option value="">적용 가능한 쿠폰이 없습니다</option>
<%
		} else {
%>
						<option value="">쿠폰 선택</option>
<%
			for(Param r : cList) {
				if(!couponList.contains(r.get("mem_couponid"))) {
					couponList.add(r.get("mem_couponid"));
				}
%>
						<option value="<%= r.get("mem_couponid") %>|<%= r.get("sale_type") %>|<%= r.get("sale_amt") %>|<%= r.get("max_sale") %>|<%= r.get("coupon_name") %>"><%= r.get("coupon_name") %></option>
<%
			}
		}
%>
					</select>
				</div>
			</div>
<%
	}

	// 산지직송 상품
	for(Param row : list2) {
		int amt = row.getInt("sale_price") * row.getInt("qty");
		totalPrice += amt;

		Param p = new Param();
		p.set("userid", fs.getUserId());
		p.set("device_type", fs.getDeviceType());
		p.set("grade_code", fs.getGradeCode());
		p.set("pid", row.get("sub_pid"));
		p.set("min_price", amt);
		
		List<Param> cList = coupon.getApplyableList(p);
		couponCnt2 = cList.size();
%>
			<div class="coupon">
				<input type="hidden" name="cartid" value="<%= row.get("cartid") %>" />			
				<input type="hidden" name="pid" value="<%= row.get("sub_pid") %>" />			
				<input type="hidden" name="amt" value="<%= amt %>" />			
				<input type="hidden" name="coupon001_amt" value="0" />			
				<p class="tit"><%= row.get("pnm") %><br><span class="opt"><%= row.get("sub_opt_pnm") %></span></p>
				<div class="cont">
					<select name="coupon001" id="coupon001_<%= row.get("cartid") %>" title="상품할인쿠폰 선택" onchange="selectCoupon001(this)">
<%
		if(cList.size() == 0) {
%>
						<option value="">적용 가능한 쿠폰이 없습니다</option>
<%
		} else {
%>
						<option value="">쿠폰 선택</option>
<%
			for(Param r : cList) {
				if(!couponList.contains(r.get("mem_couponid"))) {
					couponList.add(r.get("mem_couponid"));
				}
%>
						<option value="<%= r.get("mem_couponid") %>|<%= r.get("sale_type") %>|<%= r.get("sale_amt") %>|<%= r.get("max_sale") %>|<%= r.get("coupon_name") %>"><%= r.get("coupon_name") %></option>
<%
			}
		}
%>
					</select>
				</div>
			</div>
<%
	}

	// 정기배송상품
	for(Param row : list3) {
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

		Param p = new Param();
		p.set("userid", fs.getUserId());
		p.set("device_type", fs.getDeviceType());
		p.set("grade_code", fs.getGradeCode());
		p.set("pid", row.get("sub_pid"));
		p.set("min_price", amt);
		
		List<Param> cList = coupon.getApplyableList(p);
		couponCnt3 = cList.size();
%>

			<div class="coupon">
				<input type="hidden" name="cartid" value="<%= row.get("cartid") %>" />			
				<input type="hidden" name="pid" value="<%= row.get("sub_pid") %>" />			
				<input type="hidden" name="amt" value="<%= amt %>" />			
				<input type="hidden" name="coupon001_amt" value="0" />			
				<p class="tit"><%= row.get("pnm") %><br><span class="opt"><%= row.get("sub_opt_pnm") %></span></p>
				<div class="cont">
					<select name="coupon001" id="coupon001_<%= row.get("cartid") %>" title="상품할인쿠폰 선택" onchange="selectCoupon001(this)">
<%
		if(cList.size() == 0) {
%>
						<option value="">적용 가능한 쿠폰이 없습니다</option>
<%
		} else {
%>
						<option value="">쿠폰 선택</option>
<%
			for(Param r : cList) {
				if(!couponList.contains(r.get("mem_couponid"))) {
					couponList.add(r.get("mem_couponid"));
				}
%>
						<option value="<%= r.get("mem_couponid") %>|<%= r.get("sale_type") %>|<%= r.get("sale_amt") %>|<%= r.get("max_sale") %>|<%= r.get("coupon_name") %>"><%= r.get("coupon_name") %></option>
<%
			}
		}
%>
					</select>
				</div>
			</div>
<%
	}
	
	// 배송일 지정 상품
	for(Param row : list4) {
		int amt = row.getInt("sale_price") * row.getInt("qty");
		totalPrice += amt;

		Param p = new Param();
		p.set("userid", fs.getUserId());
		p.set("device_type", fs.getDeviceType());
		p.set("grade_code", fs.getGradeCode());
		p.set("pid", row.get("sub_pid"));
		p.set("min_price", amt);
		
		List<Param> cList = coupon.getApplyableList(p);
		couponCnt4 = cList.size();
%>
			<div class="coupon">
				<input type="hidden" name="cartid" value="<%= row.get("cartid") %>" />			
				<input type="hidden" name="pid" value="<%= row.get("sub_pid") %>" />			
				<input type="hidden" name="amt" value="<%= amt %>" />			
				<input type="hidden" name="coupon001_amt" value="0" />			
				<p class="tit"><%= row.get("pnm") %><br><span class="opt"><%= row.get("sub_opt_pnm") %></span></p>
				<div class="cont">
					<select name="coupon001" id="coupon001_<%= row.get("cartid") %>" title="상품할인쿠폰 선택" onchange="selectCoupon001(this)">
<%
		if(cList.size() == 0) {
%>
						<option value="">적용 가능한 쿠폰이 없습니다</option>
<%
		} else {
%>
						<option value="">쿠폰 선택</option>
<%
			for(Param r : cList) {
				if(!couponList.contains(r.get("mem_couponid"))) {
					couponList.add(r.get("mem_couponid"));
				}
%>
						<option value="<%= r.get("mem_couponid") %>|<%= r.get("sale_type") %>|<%= r.get("sale_amt") %>|<%= r.get("max_sale") %>|<%= r.get("coupon_name") %>"><%= r.get("coupon_name") %></option>
<%
			}
		}
%>
					</select>
				</div>
			</div>
<%
	}

%>
<script>
	if ('<%= couponCnt1 + couponCnt2 + couponCnt3 + couponCnt4 %>' != 0) {
		$("#saleCouponCnt").text('<%= couponCnt1 + couponCnt2 + couponCnt3 + couponCnt4 %>')
	}
</script>
			<!-- //상품할인쿠폰 -->
			
			<div class="head">
				<h2 class="typeB">주문할인 쿠폰 <span class="num" id="orderCouponCnt">0</span></h2>
				<p class="price">할인금액 : <span class="fontTypeA" id="saleAmt002">0</span>원</p>				
			</div>
			<div class="coupon">				
				<p class="tit">주문할인 쿠폰 선택</p>
				<div class="cont">
<%
	Param p = new Param();
	p.set("userid", fs.getUserId());
	p.set("device_type", fs.getDeviceType());
	p.set("grade_code", fs.getGradeCode());
	p.set("coupon_type", "002");
	p.set("min_price", totalPrice);
	
// 	List<Param> cList = coupon.getApplyableList2(p);
	List<Param> cList = coupon.getCartApplyableList(p);
%>
<script>
	if ('<%= cList.size()%>' != 0) {
		$("#orderCouponCnt").text('<%= cList.size()%>')
	}
</script>
					<input type="hidden" name="coupon002_amt" value="0" />			
					<select name="coupon002" title="주문할인쿠폰 선택" onchange="cal()">
<%
	if(cList.size() == 0) {
%>
						<option value="">적용 가능한 쿠폰이 없습니다</option>
<%
	} else {
%>
						<option value="">쿠폰 선택</option>
<%
		for(Param r : cList) {
			if(!couponList.contains(r.get("mem_couponid"))) {
				couponList.add(r.get("mem_couponid"));
			}
%>
						<option value="<%= r.get("mem_couponid") %>|<%= r.get("sale_type") %>|<%= r.get("sale_amt") %>|<%= r.get("max_sale") %>|<%= r.get("coupon_name") %>"><%= r.get("coupon_name") %></option>
<%
		}
	}
%>
					</select>
				</div>
			</div>
			<!-- //주문할인쿠폰 -->
			
			<div class="head">
				<h2 class="typeB">배송비 쿠폰 <span class="num" id="shipCouponCnt" >0</span></h2>
				<p class="price">할인금액 : <span class="fontTypeA" id="saleAmt003">0</span>원</p>				
			</div>
			<div class="coupon">				
				<p class="tit">배송비 할인 쿠폰 선택</p>
				<div class="cont">
<%
	p.remove("min_price");
	p.set("coupon_type", "003");
	
	cList = coupon.getApplyableList2(p);
%>
<script>
	if ('<%= cList.size()%>' != 0) {
		$("#shipCouponCnt").text('<%= shipAmt == 0 ? "0" : cList.size()%>')
	}
</script>
					<input type="hidden" name="coupon003_amt" value="0" />			
					<select name="coupon003" title="배송비 할인쿠폰 선택" onchange="cal()">
<%
	if(shipAmt == 0 || cList.size() == 0) {
%>
						<option value="">적용 가능한 쿠폰이 없습니다</option>
<%
	} else {
%>
						<option value="">쿠폰 선택</option>
<%
		for(Param r : cList) {
			if(!couponList.contains(r.get("mem_couponid"))) {
				couponList.add(r.get("mem_couponid"));
			}
%>
						<option value="<%= r.get("mem_couponid") %>|<%= r.get("sale_type") %>|<%= r.get("sale_amt") %>|<%= r.get("max_sale") %>|<%= r.get("coupon_name") %>"><%= r.get("coupon_name") %></option>
<%
		}
	}
%>
					</select>
				</div>
			</div>
			<!-- //배송비할인쿠폰 -->

			<div class="all">
				<p>적용 가능 쿠폰<em><strong class="fontTypeA"><%= Utils.formatMoney(couponList.size()) %></strong>개</em></p>
				<p class="total">총 할인금액<em><strong class="fontTypeA" id="saleAmt">0</strong>원</em></p>
			</div>
		</div>
		<div class="btnArea">
			<span><a href="#none" onclick="hidePopupLayer(); return false" class="btnTypeA sizeL">취소</a></span>
			<span><a href="#none" onclick="apply()" class="btnTypeB sizeL">적용</a></span>
		</div>
	<!-- //내용영역 -->
	</div><!-- //popCont -->
</div><!-- //popWrap -->
<script>
//팝업높이조절
setPopup(<%=layerId%>);
shipAmt = <%= shipAmt %>;
</script>
</body>
</html>