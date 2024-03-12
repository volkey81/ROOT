<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			java.text.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.service.hotel.*,
			com.sanghafarm.utils.*,
			org.apache.commons.lang.*" %>
<%
	request.setAttribute("Depth_1", new Integer(5));
	request.setAttribute("Depth_2", new Integer(6));
	request.setAttribute("Depth_3", new Integer(3));
	request.setAttribute("MENU_TITLE", new String("빌리지 소개"));

	Param param = new Param(request);
	HotelPromotionService svc = new HotelPromotionService();
	
	if(StringUtils.isEmpty(param.get("seq"))) {
		Utils.sendMessage(out, "잘못된 접근입니다.");
		return;
	}
	
	Param info = svc.getInfo(param);
	svc.modifyHit(param);
%>

<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<div id="container" class="hotel village">
		<!-- 내용영역 -->
		<jsp:include page="/hotel/offer/tab.jsp" />
		<div class="villageTop villageList">
			<p class="animated fadeInUp delay02">파머스빌리지에서 준비한<br>특별한 프로모션을 만나보세요.</p>
		</div>	
		<div class="promotionWrap villageView">
			<table>
				<colgroup>
					<col width="*">
					<col width="40%">
				</colgroup>
				<thead>
					<tr class="animated fadeIn delay04">
						<th scope="col" class="al"><%= Utils.removeHtmlTag(info.get("title")) %></th>
						<th scope="col">
							<div class="viewDate">
								<span><%= info.get("start_date").substring(0, 10) %> ~ <%= info.get("end_date").substring(0, 10) %></span>
								<p class="ico ico<%= Integer.parseInt(info.get("cate")) %>"><%= info.get("cate_name") %></p>
							</div>		
						</th>
					</tr>
				</thead>
				<tbody>
					<tr class="animated fadeIn delay06">
						<td colspan="2"><%= info.get("pc_contents") %></td>
					</tr>
				</tbody>
			</table>
			<div class="btnArea">
				<a href="<%= "".equals(param.backQuery()) ? "list.jsp" : param.backQuery() %>" class="btnStyle01 sizeL">목록</a>
			</div>
		</div>

		<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
