<%@page import="com.sanghafarm.service.order.CartService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.service.product.*" %>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	String layerId = request.getParameter("layerId");
	Param param = new Param(request);
	
	String userid = "";
	
	if(fs.isLogin()) userid = fs.getUserId();
	else userid = fs.getTempUserId();
	
	param.set("userid", userid);
	
	ProductService product = (new ProductService()).toProxyInstance();
	param.set("grade_code", fs.getGradeCode());
	Param info = product.getInfo(param);
	List<Param> optList = product.getOptionList(param);
	List<Param> cateList = product.getProductCateList(param.get("pid"));
	boolean isSoldOut = ("N".equals(info.get("sale_status")) || info.getInt("stock") == 0);
%>
<%
	request.setAttribute("MENU_TITLE", new String("장바구니"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
<script>

	function setQty(dir, pid) {
		if(dir == 'up') {
			$("#qty_" + pid).val(parseInt($("#qty_" + pid).val()) + 1);
		} else {
			if($("#qty_" + pid).val() != 1) {
				$("#qty_" + pid).val(parseInt($("#qty_" + pid).val()) - 1);
			}
		}
		
// 		var price = parseInt($("#qty_" + pid).val()) * parseInt($("#sale_price_" + pid).val());
// 		$("#sale_price_txt_" + pid).html(price.formatMoney() + " 원");
// 		calculatePrice();
	}

	//장바구니담기 완료
	function addCart(orderYn) {
		if($("input[name=sub_pid]:checked").size() == 0) {
			alert("상품 옵션을 선택하세요.");
			return;
		}	
		
		$("#cartForm").attr("action", "/order/cartProc.jsp");
		$("#cartForm").attr("target", "");
		$("#cartForm input[name=mode]").val("CREATE");
		$("#cartForm input[name=order_yn]").val(orderYn);

		ajaxSubmit($("#cartForm"), function(json) {
			if(json.result) {
				/*
				var arrPnm = [];
				var etEx = ET.getElementDataExtractor();
				$("#cartForm input[name=sub_pid]").each(function() {
					if($(this).prop("checked")) {
						var optPid = $(this).val();
						
						arrPnm.push({
							productName: '<%= info.get("pnm") %>' + " - " + $("#sub_pnm_" + optPid).val(),
							productPrice: parseInt($("#sale_price_" + optPid).val()) * parseInt($("#qty_" + optPid).val()),
							productUrl: '<%= Env.getURLPath() %>/product/detail.jsp?pid=<%= param.get("pid") %>',
							productImg: '<%= Env.getURLPath() %>' + $("#image_" + optPid).val()
						});
					}
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
				
				if(orderYn == 'Y') {
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
// 				showPopupLayer('/popup/cartComplete.jsp', '580');
//				hidePopupLayer(<%=layerId%>, 'reset');
			} else {
				alert(json.msg);
				hidePopupLayer();
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
		<h2 class="typeA"><%= info.get("pnm") %></h2>
		<form name="cartForm" id="cartForm" method="post">
			<input type="hidden" name="mode" value="CREATE" />
			<input type="hidden" name="pid" value="<%= param.get("pid") %>" />
			<input type="hidden" name="order_yn" value="N" />
		<table class="bbsList">
			<caption>옵션선택</caption>
			<colgroup>
				<col width="50"><col width="230"><col width="">
			</colgroup>
			<thead>
				<tr>
					<th scope="col">선택</th>
					<th scope="col">옵션</th>
					<th scope="col">수량</th>
				</tr>
			</thead>
		</table>
		<div class="scrTable">
			<table class="bbsList">
				<caption>옵션선택</caption>
				<colgroup>
					<col width="50"><col width="230"><col width="">
				</colgroup>
				<tbody>
					<tr>
						<th scope="row"><input type="checkbox" name="sub_pid" id="sub_pid_<%= info.get("pid") %>" value="<%= info.get("pid") %>" <%= isSoldOut ? "disabled" : "" %> <%= optList.size() == 0 ? "checked" : "" %>></th>
						<td class="tit">
							<label for="sub_pid_<%= info.get("pid") %>" <%= isSoldOut ? "class=\"disabled\"" : "" %>><%= isSoldOut ? "[품절]" : "" %> <%= info.get("opt_pnm") %></label>
							<input type="hidden" name="sub_pnm" id="sub_pnm_<%= info.get("pid") %>" value="<%= info.get("opt_pnm") %>" />
							<input type="hidden" name="image" id="image_<%= info.get("pid") %>" value="<%= info.get("image1") %>" />
							<input type="hidden" name="sale_price" id="sale_price_<%= info.get("pid") %>" value="<%= info.get("sale_price") %>" />
						</td>
						<td>
							<p class="countNum">
								<a href="#none" onclick="setQty('down', '<%= info.get("pid") %>'); return false;"><img src="/images/btn/btn_minus.png" alt="-"></a>
								<input type="text" name="qty_<%= info.get("pid") %>" id="qty_<%= info.get("pid") %>" value="1">
								<a href="#none" onclick="setQty('up', '<%= info.get("pid") %>'); return false;"><img src="/images/btn/btn_plus.png" alt="+"></a>
							</p>
						</td>
					</tr>
<%
	for(Param row : optList) {
		isSoldOut = "N".equals(row.get("sale_status")) || row.getInt("stock") == 0;
%>					
					<tr>
						<th scope="row"><input type="checkbox" name="sub_pid" id="sub_pid_<%= row.get("opt_pid") %>" value="<%= row.get("opt_pid") %>" <%= isSoldOut ? "disabled" : "" %>></th>
						<td class="tit">
							<label for="sub_pid_<%= row.get("opt_pid") %>" <%= isSoldOut ? "class=\"disabled\"" : "" %>><%= isSoldOut ? "[품절]" : "" %> <%= row.get("opt_pnm") %></label>
							<input type="hidden" name="sub_pnm" id="sub_pnm_<%= row.get("opt_pid") %>" value="<%= row.get("opt_pnm") %>" />
							<input type="hidden" name="image" id="image_<%= row.get("opt_pid") %>" value="<%= row.get("image1") %>" />
							<input type="hidden" name="sale_price" id="sale_price_<%= row.get("opt_pid") %>" value="<%= row.get("sale_price") %>" />
						</td>
						<td>
							<p class="countNum">
							<a href="#none" onclick="setQty('down', '<%= row.get("opt_pid") %>'); return false;"><img src="/images/btn/btn_minus.png" alt="-"></a>
							<input type="text" name="qty_<%= row.get("opt_pid") %>" id="qty_<%= row.get("opt_pid") %>" value="1">
							<a href="#none" onclick="setQty('up', '<%= row.get("opt_pid") %>'); return false;"><img src="/images/btn/btn_plus.png" alt="+"></a>
							</p>
						</td>
					</tr>
<%
	}
%>
<!-- 					<tr><td colspan="3">+++ 선택 가능한 옵션이 없습니다 +++</td></tr> -->
				</tbody>
			</table>
		</div>
<%
	if("D".equals(info.get("ptype"))) {	// 배송일 지정상품
		List<Param> deliveryDateList = product.getDeliveryDateList(param.get("pid"));
%>
		<div class="deliveryDate">	
			<strong>배송일지정</strong>
			<select name="delivery_date" title="배송일 선택">
<%
		for(Param row : deliveryDateList) {
%>			
				<option value="<%= row.get("delivery_date") %>"><%= row.get("delivery_date") %></option>
<%
		}
%>
			</select>
		</div>
<%
	}
%>
		<div class="btnArea">
			<a href="#none" onclick="addCart('N')" class="btnTypeA sizeL">장바구니 담기</a>
			<a href="#none" onclick="addCart('Y')" class="btnTypeB sizeL">바로구매</a>
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