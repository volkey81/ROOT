<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			java.text.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.service.board.*,
			com.sanghafarm.service.code.*,
			com.sanghafarm.service.product.*,
			com.sanghafarm.utils.*" %>
<%	
	Param param = new Param(request);
	ExpProductService svc = (new ExpProductService()).toProxyInstance();
	List<Param> list = svc.getSelProductList(param);

%>
<script type="text/javascript">
/* 간편결제에 사용될 상품 목록(RE_SE_0003.jsp : maeilpayRequest()) */
    var products = [
        <%
        for(int i = 0; i < list.size(); i++) {
            Param row = list.get(i);
            String ticketName = row.get("ticket_name");
            int price = row.getInt("price");
            // 가정: 각 티켓의 수량을 가져오는 방법을 구현해야 함. 여기서는 예시로 모든 티켓에 대해 수량 1로 설정.
            int quantity = 1; // 실제 구현에는 각 티켓의 실제 수량을 반영해야 합니다.

            if(i > 0) {
                out.print(",");
            }
        %>
        { "name": "<%=ticketName%>", "price": "<%=price%>", "quantity": "<%=quantity%>" }
        <%
        }
        %>
    ];
    
    /* RE_SE_0003의 setQty()에서 연동, 수량 업데이트 하여 products 배열 재생성 */
    function updateQuantity(id, action) {
        var qtyInput = document.getElementById(id);
        var currentQty = parseInt(qtyInput.value);
        if(action === 'increase') {
            currentQty++;
        } else if(action === 'decrease' && currentQty > 0) {
            currentQty--;
        }
        qtyInput.value = currentQty; // 입력 필드에 업데이트된 수량을 반영

        // products 배열 업데이트
        updateProductsArray(id);
    }
 // products 배열을 업데이트하는 함수
    function updateProductsArray(id) {
        var updatedProducts = [];
        <% for(Param row : list) { %>
            var expPid = "<%=row.get("exp_pid")%>";
            var ticketType = "<%=row.get("ticket_type")%>";
            var ticketName = "<%=row.get("ticket_name")%>";
            var price = "<%=row.get("price")%>";
            var qtyInput = document.getElementById(id);
            var quantity = parseInt(qtyInput.value);

            if(quantity > 0) { // 수량이 0보다 큰 항목만 추가
                updatedProducts.push({ "name": ticketName, "price": price, "quantity": quantity });
            }
        <% } %>
        
        // 간편결제를 위한 상품 목록 업데이트
        products = updatedProducts;
        console.log("updateProductsArray : "+products); // 개발 단계에서 확인 용도
    }
</script>
<%
int currentIndex = 0; // 인덱스 
int rIndex = 1; // radio 버튼을 위한 인덱스
String previousValue = null; // 이전값 저장 변수

for(Param row : list) {
	int remain = row.getInt("seat_num") - row.getInt("reserved_num");
    // exp_pid가 바뀔 때(새 프로그램을 나타냄), 이전 프로그램의 div를 닫고 새 목록 항목을 시작합니다
		if(previousValue != null){
			if(row.get("exp_pid").equals(previousValue)){ // 이전 제목과 동이하면 시간만 출력
%>
<!-- <div class="people_wrap"> 시간을 반복해서 보여줄 필요가 없음-->
<%--    	<span class="wrap_title"><%= row.get("ticket_name") %></span> --%>
<%--    	<button type="button" onClick="setQty('dn','qty_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_minus brNone">-</button> --%>
<%--    	<input type="number" name="qty_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" id="qty_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" class="input_g input_people"  value=0 > --%>
<%--    	<button type="button" onClick="setQty('up','qty_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_plus blNone">+</button>    --%>
<%--    	<input type="hidden" name="exp_pid"  value="<%= row.get("exp_pid") %>" /> --%>
<%--    	<input type="hidden" name="ticket_type_<%= row.get("exp_pid") %>" value="<%= row.get("ticket_type") %>" /> --%>
<%-- 	<input type="hidden" name="ticket_nm_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" id="ticket_nm_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value="<%= row.get("ticket_name") %>" /> --%>
<%-- 	<input type="hidden" name="occu_num_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" id="occu_num_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value="<%= row.get("occu_num") %>" /> --%>
<%-- 	<input type="hidden" name="price_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" id="price_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value="<%= row.get("price") %>" /> --%>
<%-- 	<input type="hidden" name="exp_type_name_<%= row.get("exp_pid") %>" id="exp_type_name_<%= row.get("exp_pid") %>" value="<%= row.get("exp_type_name") %>"> --%>
<%-- 	<input type="hidden" name="exp_type_<%= row.get("exp_pid") %>" id="exp_type_<%= row.get("exp_pid") %>" value="<%= row.get("exp_type") %>"> --%>
<%-- 	<input type="hidden" name="time_name_<%= row.get("exp_pid") %>" id="time_name_<%= row.get("exp_pid") %>" value="<%= row.get("time").substring(0, 2) + ":" + row.get("time").substring(2) %>"> --%>
<%-- 	<input type="hidden" name="place_name_<%= row.get("exp_pid") %>" id="place_name_<%= row.get("exp_pid") %>" value="<%= row.get("place_name") %>"> --%>
<%-- 	<input type="hidden" name="remain_<%= row.get("exp_pid") %>" id="remain_<%= row.get("exp_pid") %>" value="<%= remain %>"> --%>
<!-- </div> -->
<%				
			}else{//이전값과 다르면 새롭게 
				rIndex++;
			    NumberFormat formatter = NumberFormat.getInstance();
			    String formattedPrice = formatter.format(Integer.parseInt(row.get("price")));
%>
 </div>
 </div>
</li>
<li class="program_type1">
        <p class="program_time"><%= row.get("time").substring(0, 2) %>:<%= row.get("time").substring(2) %></p>
<%--         <p class="program_title"><%= row.get("exp_type_nm") %> <%= row.get("ticket_name") %><br/><em class="fcGreen"><%= formattedPrice  %></em>원</p> --%>
		<p class="program_title"><%= row.get("exp_type_nm") %><br/><em class="fcGreen"><%= formattedPrice  %></em>원</p>
        <div class="program_detail">
            <div class="detail_people">
            <% if("아침산책 (조식뷔페 + 입장권)".equals(row.get("exp_type_nm"))||"공장견학".equals(row.get("exp_type_nm"))){ %>
            <!-- 001:대인입장권, 002:소인입장권 -->
           	<!-- 아침산책(070) 일 때만 대/소/유 나오도록, 가격은 하드코딩 | 추후 관리자 페이지에 가격 부분 추가 필요 -->
           	<!-- 대인은 관리자에서 등록한 가격, 소인, 유아는 하드코딩 -->
                <div class="people_wrap">
					<span class="wrap_title">대인</span>
					<button type="button" onClick="setQty('dn','qtyA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_minus brNone">-</button>
					<input type="number" id="qtyA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" class="input_g input_people" name="qtyA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value=0 >
					<button type="button" onClick="setQty('up','qtyA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_plus blNone">+</button>
					<input type="hidden" 
							name="priceA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" 
							id="priceA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" 
							<% if("아침산책 (조식뷔페 + 입장권)".equals(row.get("exp_type_nm"))){ %> value="18000"
							<% }else if("입장권".equals(row.get("exp_type_nm"))){ %> value="9000" <% }%>
					/>
				</div>
				
				<div class="people_wrap">
					<span class="wrap_title">소인</span>
					<button type="button" onClick="setQty('dn','qtyS_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_minus brNone">-</button>
					<input type="number" id="qtyS_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" class="input_g input_people" name="qtyS_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value=0 >
					<button type="button" onClick="setQty('up','qtyS_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_plus blNone">+</button>
					<input type="hidden" 
						name="priceS_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" 
						id="priceS_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>"
					<% if("아침산책 (조식뷔페 + 입장권)".equals(row.get("exp_type_nm"))){ %> value="13500"
					<% }else if("입장권".equals(row.get("exp_type_nm"))){ %> value="6000" <% }%>
					/>
				</div>
				
				<div class="people_wrap">
					<span class="wrap_title">유아</span>
					<button type="button" onClick="setQty('dn','qtyB_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_minus brNone">-</button>
					<input type="number" id="qtyB_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" class="input_g input_people" name="qtyB_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value=0 >
					<button type="button" onClick="setQty('up','qtyB_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_plus blNone">+</button>
					<input type="hidden" 
						name="priceB_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" 
						id="priceB_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>"
						value="0"
					/>
				</div>
				<% if("공장견학".equals(row.get("exp_type_nm"))){ %>
				<div class="detail_transport">
					<span class="wrap_title">이동수단</span>
					<div class="radio_g">
						<input type="radio" name="transport" id="bus" value="b">
						<label for="bus"><span>버스</span></label>
					</div>
					<div class="radio_g ml30">
						<input type="radio" name="transport" id="car" value="c">
						<label for="car"><span>자차</span></label>
					</div>
					<div class="radio_g ml30">
						<input type="radio" name="transport" id="wark" value="w">
						<label for="wark"><span>도보</span></label>
					</div>
				</div>
				<%} %>
			<% }else{  %>
				<div class="people_wrap">
					<span class="wrap_title"></span>
					<button type="button" onClick="setQty('dn','qtyA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_minus brNone">-</button>
					<input type="number" id="qtyA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" class="input_g input_people" name="qtyA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value=0 >
					<button type="button" onClick="setQty('up','qtyA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_plus blNone">+</button>
					<input type="hidden" 
						name="priceA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" 
						id="priceA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" 
						value="<%= row.get("price") %>" />
				</div>
			<% }%>
				
				<input type="hidden" name="exp_pid"  value="<%= row.get("exp_pid") %>" />
				<input type="hidden" name="ticket_type_<%= row.get("exp_pid") %>" value="<%= row.get("ticket_type") %>" />
				<input type="hidden" name="ticket_nm_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" id="ticket_nm_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value="<%= row.get("ticket_name") %>" />
				<input type="hidden" name="occu_num_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" id="occu_num_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value="<%= row.get("occu_num") %>" />
				<input type="hidden" name="exp_type_name_<%= row.get("exp_pid") %>" id="exp_type_name_<%= row.get("exp_pid") %>" value="<%= row.get("exp_type_name") %>">
				<input type="hidden" name="exp_type_<%= row.get("exp_pid") %>" id="exp_type_<%= row.get("exp_pid") %>" value="<%= row.get("exp_type") %>">
				<input type="hidden" name="time_name_<%= row.get("exp_pid") %>" id="time_name_<%= row.get("exp_pid") %>" value="<%= row.get("time").substring(0, 2) + ":" + row.get("time").substring(2) %>">
				<input type="hidden" name="place_name_<%= row.get("exp_pid") %>" id="place_name_<%= row.get("exp_pid") %>" value="<%= row.get("place_name") %>">
				<input type="hidden" name="remain_<%= row.get("exp_pid") %>" id="remain_<%= row.get("exp_pid") %>" value="<%= remain %>">
			</div>
<%				
			}
		}else{//처음 시작부분
		    NumberFormat formatter = NumberFormat.getInstance();
		    String formattedPrice = formatter.format(Integer.parseInt(row.get("price")));
%>
 	<li class="program_type1">
        <p class="program_time"><%= row.get("time").substring(0, 2) %>:<%= row.get("time").substring(2) %></p>
<%--         <p class="program_title"><%= row.get("exp_type_nm") %> <%= row.get("ticket_name") %><br/><em class="fcGreen"><%= formattedPrice %></em>원</p> --%>
		<p class="program_title"><%= row.get("exp_type_nm") %><br/><em class="fcGreen"><%= formattedPrice %></em>원</p>
        <div class="program_detail">
            <div class="detail_people">
           	<% if("아침산책 (조식뷔페 + 입장권)".equals(row.get("exp_type_nm"))||"공장견학".equals(row.get("exp_type_nm"))){ %>
            <!-- 001:대인입장권, 002:소인입장권 -->
           	<!-- 아침산책(070) 일 때만 대/소/유 나오도록, 가격은 하드코딩 | 추후 관리자 페이지에 가격 부분 추가 필요 -->
           	<!-- 대인은 관리자에서 등록한 가격, 소인, 유아는 하드코딩 -->
                <div class="people_wrap">
					<span class="wrap_title">대인</span>
					<button type="button" onClick="setQty('dn','qtyA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_minus brNone">-</button>
					<input type="number" id="qtyA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" class="input_g input_people" name="qtyA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value=0 >
					<button type="button" onClick="setQty('up','qtyA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_plus blNone">+</button>
					<input type="hidden" 
							name="priceA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" 
							id="priceA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" 
							<% if("아침산책 (조식뷔페 + 입장권)".equals(row.get("exp_type_nm"))){ %> value="18000"
							<% }else if("입장권".equals(row.get("exp_type_nm"))){ %> value="9000" <% }%>
					/>
				</div>
				
				<div class="people_wrap">
					<span class="wrap_title">소인</span>
					<button type="button" onClick="setQty('dn','qtyS_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_minus brNone">-</button>
					<input type="number" id="qtyS_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" class="input_g input_people" name="qtyS_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value=0 >
					<button type="button" onClick="setQty('up','qtyS_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_plus blNone">+</button>
					<input type="hidden" 
						name="priceS_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" 
						id="priceS_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>"
						<% if("아침산책 (조식뷔페 + 입장권)".equals(row.get("exp_type_nm"))){ %> value="13500"
						<% }else if("입장권".equals(row.get("exp_type_nm"))){ %> value="6000" <% }%>
					/>
				</div>
				
				<div class="people_wrap">
					<span class="wrap_title">유아</span>
					<button type="button" onClick="setQty('dn','qtyB_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_minus brNone">-</button>
					<input type="number" id="qtyB_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" class="input_g input_people" name="qtyB_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value=0 >
					<button type="button" onClick="setQty('up','qtyB_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_plus blNone">+</button>
					<input type="hidden" 
						name="priceB_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" 
						id="priceB_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>"
						value="0"
					/>
				</div>
				<% if("공장견학".equals(row.get("exp_type_nm"))){ %>
				<div class="detail_transport">
					<span class="wrap_title">이동수단</span>
					<div class="radio_g">
						<input type="radio" name="transport" id="bus" value="b">
						<label for="bus"><span>버스</span></label>
					</div>
					<div class="radio_g ml30">
						<input type="radio" name="transport" id="car" value="c">
						<label for="car"><span>자차</span></label>
					</div>
					<div class="radio_g ml30">
						<input type="radio" name="transport" id="wark" value="w">
						<label for="wark"><span>도보</span></label>
					</div>
				</div>
				<%} %>
			<% }else{  %>
				<div class="people_wrap">
					<span class="wrap_title"></span>
					<button type="button" onClick="setQty('dn','qtyA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_minus brNone">-</button>
					<input type="number" id="qtyA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" class="input_g input_people" name="qtyA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value=0 >
					<button type="button" onClick="setQty('up','qtyA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_plus blNone">+</button>
					<input type="hidden" 
						name="priceA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" 
						id="priceA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" 
						value="<%= row.get("price") %>" />
				</div>
			<% }%>

                <input type="hidden" name="exp_pid"  value="<%= row.get("exp_pid") %>" />
				<input type="hidden" name="ticket_type_<%= row.get("exp_pid") %>" value="<%= row.get("ticket_type") %>" />
				<input type="hidden" name="ticket_nm_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" id="ticket_nm_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value="<%= row.get("ticket_name") %>" />
				<input type="hidden" name="occu_num_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" id="occu_num_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value="<%= row.get("occu_num") %>" />
				<input type="hidden" name="exp_type_name_<%= row.get("exp_pid") %>" id="exp_type_name_<%= row.get("exp_pid") %>" value="<%= row.get("exp_type_name") %>">
				<input type="hidden" name="exp_type_<%= row.get("exp_pid") %>" id="exp_type_<%= row.get("exp_pid") %>" value="<%= row.get("exp_type") %>">
				<input type="hidden" name="time_name_<%= row.get("exp_pid") %>" id="time_name_<%= row.get("exp_pid") %>" value="<%= row.get("time").substring(0, 2) + ":" + row.get("time").substring(2) %>">
				<input type="hidden" name="place_name_<%= row.get("exp_pid") %>" id="place_name_<%= row.get("exp_pid") %>" value="<%= row.get("place_name") %>">
				<input type="hidden" name="remain_<%= row.get("exp_pid") %>" id="remain_<%= row.get("exp_pid") %>" value="<%= remain %>">
			</div>
<%			
		}
%>
<button type="button" class="btn_close"><span class="g_alt">삭제</span></button>
<%
   previousValue = row.get("exp_pid");
   currentIndex++;
}
%>  
		 </div>
	</div>
	
</li>
