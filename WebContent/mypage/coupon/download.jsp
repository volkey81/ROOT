<%@page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.service.order.*" %>
<%
	request.setAttribute("Depth_1", new Integer(3));
	request.setAttribute("Depth_2", new Integer(2));
	request.setAttribute("Depth_3", new Integer(2));
	request.setAttribute("MENU_TITLE", new String("쿠폰 다운로드"));
	String	MENU_TITLE	=	"".equals((String)request.getAttribute("MENU_TITLE")) ? "" : (String)request.getAttribute("MENU_TITLE");	
%>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	if(!fs.isLogin()) {
		SanghafarmUtils.sendLoginMessage(out, FrontSession.LOGIN_MSG, request);
		return;
	}
	
	Param param = new Param(request);
	param.set("userid", fs.getUserId());
	param.set("grade_code", fs.getGradeCode());
	
	CouponService svc = (new CouponService()).toProxyInstance();
	
	List<Param> list = svc.getDownloadableList(param);
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" /> 
<script>
	var b = false;
	function couponDownload(cid) {
		if(b) {
// 			alert("처리중입니다.");
		} else {
			b = true;
			$.ajax({
				method : "POST",
				url : "downloadProc.jsp",
				data : { couponid : cid },
				dataType : "json"
			})
			.done(function(json) {
				b = false;
				alert(json.msg);
				if(json.result) location.reload();
			});
		}
	}
</script>
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header.jsp" />
	<jsp:include page="/include/location.jsp" />
	<div id="container">
		<jsp:include page="/mypage/snb.jsp" />
		<div id="contArea">
			<h1 class="typeA"><%=MENU_TITLE %></h1>
			<!-- 내용영역 -->
			<div class="downHead">
				<ul class="caution">
					<li>쿠폰별 사용조건 및 쿠폰 유효기간은 마이페이지 &gt; 나의 쿠폰에서 확인 가능합니다.</li>
					<li>모든 혜택은 당사 사정에 의해 사전 예고 없이 변경 또는 중지 될 수 있으며, 부당한 방법으로 다운된 쿠폰은 무효시킬 수 있습니다.</li>
				</ul>
			</div>
			<p class="couponAll">현재 다운로드 가능한 모든 쿠폰 다운 받기 <a href="javascript:couponDownload('all');" class="downBtn all"><img src="/images/btn/btn_download.png" alt="다운로드"></a></p>
			<table class="bbsList couponList">
				<caption>다운로드 가능한 쿠폰 목록</caption>
				<colgroup>
					<col width="250"><col width=""><col width="190"><col width="90">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">쿠폰명</th>
						<th scope="col">할인 조건</th>
						<th scope="col">유효기간</th>
						<th scope="col">다운로드</th>
					</tr>
				</thead>
				<tbody>
<%
	for(Param row : list) {
%>
					<tr>
						<th scope="row"><%= row.get("coupon_name") %></th>
						<td class="fontTypeB"><%= Utils.formatMoney(row.get("min_price")) %>원 이상 구매시, 최대 <%= Utils.formatMoney(row.get("max_sale")) %>원 할인</td>
						<td>
<%
		if("0".equals(row.get("period", "0"))) {
			out.println(row.get("start_date") + " ~ " + row.get("end_date"));
		} else {
			out.println("발급일 ~ " + Utils.formatMoney(row.get("period")) + "일");
		}
%>
						</td>
						<td>
<%
		if(row.getInt("mem_down_cnt") < row.getInt("max_download") && (row.getInt("tot_down_cnt") < row.getInt("max_issue") || row.getInt("max_issue") == 0)) {
%>
							<a href="javascript:couponDownload('<%= row.get("couponid") %>');" class="downBtn"><img src="/images/btn/btn_download.png" alt="다운로드"></a>
<%
		} else {
%>
							<span class="downBtn disabled"><img src="/images/btn/btn_download.png" alt="다운로드"></span>
<%
		}
%>
						</td>
					</tr>
<%
	}

	if(list == null || list.size() == 0) {
%>
					<tr><td colspan="4">+++ 다운로드 가능한 쿠폰이 없습니다 +++</td></tr>
<%
	}
%>
				</tbody>
			</table>
			<!-- 
			<ul class="paging">
				<li><a href=""><img src="/images/btn/btn_pgPrev2.gif" alt="이전10페이지"></a></li>
				<li class="btnL"><a href=""><img src="/images/btn/btn_pgPrev.gif" alt="이전페이지"></a></li>
				<li><a href="">1</a></li>
				<li><strong>2</strong></li>
				<li><a href="">3</a></li>
				<li><a href="">4</a></li>
				<li><a href="">5</a></li>
				<li class="btnR"><a href=""><img src="/images/btn/btn_pgNext.gif" alt="다음페이지"></a></li>
				<li><a href=""><img src="/images/btn/btn_pgNext2.gif" alt="다음10페이지"></a></li>
			</ul>
			 -->
			<!-- //내용영역 -->
		</div><!-- //contArea -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>