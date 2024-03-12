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

<%
int currentIndex = 0; // 인덱스 
int rIndex = 1; // radio 버튼을 위한 인덱스
String previousValue = null; // 이전값 저장 변수
for(Param row : list) {
	int remain = row.getInt("seat_num") - row.getInt("reserved_num");
		if(previousValue != null){
			if(row.get("exp_pid").equals(previousValue)){ // 이전 제목과 동이하면 시간만 출력
%>
 <div class="people_wrap">
   	<span class="wrap_title"><%= row.get("ticket_name") %></span>
   	<button type="button" onClick="setQty('dn','qty_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_minus brNone">-</button>
   	<input type="number" id="qty_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" class="input_g input_people" name="qty_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value=0 >
   	<button type="button" onClick="setQty('up','qty_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_plus blNone">+</button>   
   	<input type="hidden" name="exp_pid"  value="<%= row.get("exp_pid") %>" />
   	<input type="hidden" name="ticket_type_<%= row.get("exp_pid") %>" value="<%= row.get("ticket_type") %>" />
	<input type="hidden" name="ticket_nm_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" id="ticket_nm_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value="<%= row.get("ticket_name") %>" />
	<input type="hidden" name="occu_num_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" id="occu_num_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value="<%= row.get("occu_num") %>" />
	<input type="hidden" name="price_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" id="price_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value="<%= row.get("price") %>" />
	<input type="hidden" name="exp_type_name_<%= row.get("exp_pid") %>" id="exp_type_name_<%= row.get("exp_pid") %>" value="<%= row.get("exp_type_name") %>">
	<input type="hidden" name="time_name_<%= row.get("exp_pid") %>" id="time_name_<%= row.get("exp_pid") %>" value="<%= row.get("time").substring(0, 2) + ":" + row.get("time").substring(2) %>">
	<input type="hidden" name="place_name_<%= row.get("exp_pid") %>" id="place_name_<%= row.get("exp_pid") %>" value="<%= row.get("place_name") %>">
	<input type="hidden" name="remain_<%= row.get("exp_pid") %>" id="remain_<%= row.get("exp_pid") %>" value="<%= remain %>">
</div>

	 
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
        <p class="program_title"><%= row.get("exp_type_nm") %> <%= row.get("ticket_name") %><br/><em class="fcGreen"><%= formattedPrice  %></em>원</p>
        <div class="program_detail">
            <div class="detail_people">
				<div class="people_wrap">
					<span class="wrap_title">성인</span>
					<button type="button" onClick="setQty('dn','qtyA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_minus brNone">-</button>
					<input type="number" id="qtyA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" class="input_g input_people" name="qtyA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value=0 >
					<button type="button" onClick="setQty('up','qtyA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_plus blNone">+</button>
				</div>
				
				<div class="people_wrap">
					<span class="wrap_title">학생</span>
					<button type="button" onClick="setQty('dn','qtyS_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_minus brNone">-</button>
					<input type="number" id="qtyS_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" class="input_g input_people" name="qtyS_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value=0 >
					<button type="button" onClick="setQty('up','qtyS_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_plus blNone">+</button>
				</div>
				
				<div class="people_wrap">
					<span class="wrap_title">유아</span>
					<button type="button" onClick="setQty('dn','qtyB_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_minus brNone">-</button>
					<input type="number" id="qtyB_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" class="input_g input_people" name="qtyB_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value=0 >
					<button type="button" onClick="setQty('up','qtyB_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_plus blNone">+</button>
				</div>
				
				<input type="hidden" name="exp_pid"  value="<%= row.get("exp_pid") %>" />
				<input type="hidden" name="ticket_type_<%= row.get("exp_pid") %>" value="<%= row.get("ticket_type") %>" />
				<input type="hidden" name="ticket_nm_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" id="ticket_nm_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value="<%= row.get("ticket_name") %>" />
				<input type="hidden" name="occu_num_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" id="occu_num_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value="<%= row.get("occu_num") %>" />
				<input type="hidden" name="price_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" id="price_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value="<%= row.get("price") %>" />
				<input type="hidden" name="exp_type_name_<%= row.get("exp_pid") %>" id="exp_type_name_<%= row.get("exp_pid") %>" value="<%= row.get("exp_type_name") %>">
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
        <p class="program_title"><%= row.get("exp_type_nm") %> <%= row.get("ticket_name") %><br/><em class="fcGreen"><%= formattedPrice %></em>원</p>
        <div class="program_detail">
            <div class="detail_people">
                <div class="people_wrap">
					<span class="wrap_title">성인</span>
					<button type="button" onClick="setQty('dn','qtyA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_minus brNone">-</button>
					<input type="number" id="qtyA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" class="input_g input_people" name="qtyA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value=0 >
					<button type="button" onClick="setQty('up','qtyA_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_plus blNone">+</button>
				</div>
				
				<div class="people_wrap">
					<span class="wrap_title">학생</span>
					<button type="button" onClick="setQty('dn','qtyS_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_minus brNone">-</button>
					<input type="number" id="qtyS_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" class="input_g input_people" name="qtyS_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value=0 >
					<button type="button" onClick="setQty('up','qtyS_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_plus blNone">+</button>
				</div>
				
				<div class="people_wrap">
					<span class="wrap_title">유아</span>
					<button type="button" onClick="setQty('dn','qtyB_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_minus brNone">-</button>
					<input type="number" id="qtyB_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" class="input_g input_people" name="qtyB_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value=0 >
					<button type="button" onClick="setQty('up','qtyB_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>')" class="btn_plus blNone">+</button>
				</div>

                   <input type="hidden" name="exp_pid"  value="<%= row.get("exp_pid") %>" />
				<input type="hidden" name="ticket_type_<%= row.get("exp_pid") %>" value="<%= row.get("ticket_type") %>" />
				<input type="hidden" name="ticket_nm_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" id="ticket_nm_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value="<%= row.get("ticket_name") %>" />
				<input type="hidden" name="occu_num_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" id="occu_num_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value="<%= row.get("occu_num") %>" />
				<input type="hidden" name="price_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" id="price_<%= row.get("exp_pid") %>_<%= row.get("ticket_type") %>" value="<%= row.get("price") %>" />
				<input type="hidden" name="exp_type_name_<%= row.get("exp_pid") %>" id="exp_type_name_<%= row.get("exp_pid") %>" value="<%= row.get("exp_type_name") %>">
				<input type="hidden" name="time_name_<%= row.get("exp_pid") %>" id="time_name_<%= row.get("exp_pid") %>" value="<%= row.get("time").substring(0, 2) + ":" + row.get("time").substring(2) %>">
				<input type="hidden" name="place_name_<%= row.get("exp_pid") %>" id="place_name_<%= row.get("exp_pid") %>" value="<%= row.get("place_name") %>">
				<input type="hidden" name="remain_<%= row.get("exp_pid") %>" id="remain_<%= row.get("exp_pid") %>" value="<%= remain %>">
			</div>
<%			
		}
	
%>
        
   <%
   previousValue = row.get("exp_pid");
   currentIndex++;
}
   %>  
 </div>
 </div>
   </li>   
