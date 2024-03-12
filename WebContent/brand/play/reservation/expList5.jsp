<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.service.product.*" %>
<%
	Param param = new Param(request);

	if("0".equals(param.get("exp_pid"))) {
%>
				<div class="listCont" id="price_row_0">
					<table>
						<colgroup>
							<col width="15%">
							<col width="*">
						</colgroup>
						<tr>
							<th scope="col">종류</th>
							<td>입장권</td>
						</tr>
						<tr>
							<th scope="col">시간</th>
							<td>하루종일</td>
						</tr>
						<tr>
							<th scope="col">권종</th>
							<td>
								<ul>	
									<li>대인 입장권 <strike>9,000원</strike>
										<span class="price"><%= Utils.formatMoney(Config.get("admission.fee.001")) %>원</span>
										<div class="num">
											<a href="javascript:setQty('dn', '0', '001')" class="numMinus">-</a>
											<input type="text" name="qty_0_001" id="qty_0_001" value="0" min="0" readonly> 
											<a href="javascript:setQty('up', '0', '001')" class="numPlus">+</a>
											<input type="hidden" name="ticket_type_0" value="001" />
											<input type="hidden" name="ticket_nm_0_001" id="ticket_nm_0_001" value="대인 입장권" />
											<input type="hidden" name="occu_num_0_001" id="occu_num_0_001" value="1" />
											<input type="hidden" name="price_0_001" id="price_0_001" value="<%= Config.get("admission.fee.001") %>" />
										</div>
									</li>
									<li>소인 입장권 (36개월~19세) <strike>6,000원</strike>
										<span class="price"><%= Utils.formatMoney(Config.get("admission.fee.002")) %>원</span>
										<div class="num">
											<a href="javascript:setQty('dn', '0', '002')" class="numMinus">-</a>
											<input type="text" name="qty_0_002" id="qty_0_002" value="0" min="0" readonly> 
											<a href="javascript:setQty('up', '0', '002')" class="numPlus">+</a>
											<input type="hidden" name="ticket_type_0" value="002" />
											<input type="hidden" name="ticket_nm_0_002" id="ticket_nm_0_002" value="소인 입장권" />
											<input type="hidden" name="occu_num_0_002" id="occu_num_0_002" value="1" />
											<input type="hidden" name="price_0_002" id="price_0_002" value="<%= Config.get("admission.fee.002") %>" />
										</div>
									</li>
									
								</ul>
							</td>
						</tr>
					</table>
				</div>
<%
	} else {
		ExpProductService svc = (new ExpProductService()).toProxyInstance();
		List<Param> list = svc.getPriceList(param.get("exp_pid"));
		Param info = svc.getInfo(param.get("exp_pid"));
%>
				<div class="listCont" id="price_row_<%= param.get("exp_pid") %>">
					<table>
						<colgroup>
							<col width="15%">
							<col width="*">
						</colgroup>
						<tr>
							<th scope="col">종류</th>
							<td><%= info.get("exp_type_name") %> - <%= info.get("place_name") %></td>
						</tr>
						<tr>
							<th scope="col">시간</th>
							<td><%= info.get("time").substring(0, 2) %>:<%= info.get("time").substring(2) %></td>
						</tr>
						<tr>
							<th scope="col">권종</th>
							<td>
								<ul>	
<%
		for(Param row : list) {
%>
									<li><%= row.get("ticket_name") %>
										<span class="price"><%= Utils.formatMoney(row.get("price")) %>원</span>
										<div class="num">
											<a href="javascript:setQty('dn', '<%= param.get("exp_pid") %>', '<%= row.get("ticket_type") %>')" class="numMinus">-</a>
											<input type="text" name="qty_<%= param.get("exp_pid") %>_<%= row.get("ticket_type") %>" id="qty_<%= param.get("exp_pid") %>_<%= row.get("ticket_type") %>" value="0" min="0" readonly> 
											<a href="javascript:setQty('up', '<%= param.get("exp_pid") %>', '<%= row.get("ticket_type") %>')" class="numPlus">+</a>
											<input type="hidden" name="ticket_type_<%= param.get("exp_pid") %>" value="<%= row.get("ticket_type") %>" />
											<input type="hidden" name="ticket_nm_<%= param.get("exp_pid") %>_<%= row.get("ticket_type") %>" id="ticket_nm_<%= param.get("exp_pid") %>_<%= row.get("ticket_type") %>" value="<%= row.get("ticket_name") %>" />
											<input type="hidden" name="occu_num_<%= param.get("exp_pid") %>_<%= row.get("ticket_type") %>" id="occu_num_<%= param.get("exp_pid") %>_<%= row.get("ticket_type") %>" value="<%= row.get("occu_num") %>" />
											<input type="hidden" name="price_<%= param.get("exp_pid") %>_<%= row.get("ticket_type") %>" id="price_<%= param.get("exp_pid") %>_<%= row.get("ticket_type") %>" value="<%= row.get("price") %>" />
										</div>
									</li>
<%
		}
%>
								</ul>
							</td>
						</tr>
					</table>
				</div>
<%
	}
%>
