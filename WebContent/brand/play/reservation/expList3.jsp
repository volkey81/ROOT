<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.service.product.*" %>
<%
	Param param = new Param(request);
	ExpProductService svc = (new ExpProductService()).toProxyInstance();
	List<Param> list = svc.getPriceList(param.get("exp_pid"));

	for(Param row : list) {
%>
	<li>
		<p class="tit"><%= row.get("ticket_name") %> (<%= Utils.formatMoney(row.get("price")) %>원)</p>
		<div class="cnt">
			<p class="countNum">
				<a href="javascript:setQty('dn', '<%= row.get("ticket_type") %>')"><img src="/images/btn/btn_minus2.png" alt="-"></a>
				<input type="text" name="qty_<%= row.get("ticket_type") %>" id="qty_<%= row.get("ticket_type") %>" value="0" readonly>
				<a href="javascript:setQty('up', '<%= row.get("ticket_type") %>')"><img src="/images/btn/btn_plus2.png" alt="+"></a>
				<input type="hidden" name="ticket_type" value="<%= row.get("ticket_type") %>" />
				<input type="hidden" name="ticket_nm_<%= row.get("ticket_type") %>" id="ticket_nm_<%= row.get("ticket_type") %>" value="<%= row.get("ticket_name") %>" />
				<input type="hidden" name="occu_num_<%= row.get("ticket_type") %>" id="occu_num_<%= row.get("ticket_type") %>" value="<%= row.get("occu_num") %>" />
				<input type="hidden" name="price_<%= row.get("ticket_type") %>" id="price_<%= row.get("ticket_type") %>" value="<%= row.get("price") %>" />
			</p>
		</div>
		<p class="price"><span id="price_<%= row.get("ticket_type") %>_txt">0</span>원</p>
	</li>
<%
	}
%>
