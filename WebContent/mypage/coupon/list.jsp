<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
		 	com.sanghafarm.utils.*,
			com.sanghafarm.service.order.*" %>
<%
	request.setAttribute("Depth_1", new Integer(3));
	request.setAttribute("Depth_2", new Integer(2));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", new String("나의 쿠폰"));
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
	
	//페이징 변수 설정
	param.addPaging(1, Integer.MAX_VALUE);

	CouponService svc = (new CouponService()).toProxyInstance();
	List<Param> list = svc.getMemCouponList(param);
	List<Param> downloadableList = svc.getDownloadableList(param);
	int downloadableCount = 0;
	for(Param row : downloadableList) {
		if(row.getInt("mem_down_cnt") < row.getInt("max_download") && (row.getInt("tot_down_cnt") < row.getInt("max_issue") || row.getInt("max_issue") == 0)) {
			downloadableCount++;
		}
	}
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
	
	function downloadSerial() {
		if(b) {
// 			alert("처리중입니다.");
		} else {
			if($("input[name=coupon_serial]").val().length < 16) {
				alert("쿠폰번호를 정확히 입력하세요.");
			} else {
				b = true;
				$.ajax({
					method : "POST",
					url : "serial.jsp",
					data : { coupon_serial : $("input[name=coupon_serial]").val() },
					dataType : "json"
				})
				.done(function(json) {
					b = false;
					alert(json.msg);
					if(json.result) location.reload();
				});
			}
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
			<div class="couponSrmy">
				<div class="mine">
					<h2>사용 가능 쿠폰</h2>
					<p class="num"><strong><%= Utils.formatMoney(list.size()) %></strong> 개</p>
				</div>
				<div class="mine down">
					<h2>다운 가능 쿠폰</h2>
					<a href="#none" onclick="couponDownload('all')" class="btn"><img src="/images/btn/btn_download.png" alt="다운로드"></a>
					<p class="num"><strong><%= Utils.formatMoney(downloadableCount) %></strong> 개</p>
				</div>
				<div class="regist">
					<fieldset>
						<legend>쿠폰 등록</legend>
						<input type="text" name="coupon_serial">
						<a href="#none" onclick="downloadSerial()" class="btnTypeD">등록</a>
					</fieldset>
				</div>
			</div><!-- //couponSrmy -->
			<h3 class="couponHead">나의 보유 쿠폰</h3>
			<table class="bbsList couponList">
				<caption>나의 보유 쿠폰 목록</caption>
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
						<td class="fontTypeB">
<%
		if("0".equals(row.get("min_price", "0"))) {
			out.println("조건없이 사용가능");
		} else {
%>
							<%= Utils.formatMoney(row.get("min_price")) %>원 이상 구매시, 최대 <%= Utils.formatMoney(row.get("max_sale")) %>원 할인
<%
		}
%>
						</td>
						<td><%= row.get("start_date") %> ~ <%= row.get("end_date") %></td>
						<td>
						</td>						
					</tr>
<%
	}

	int m = 0;
	for(Param row : downloadableList) {
		if(row.getInt("mem_down_cnt") < row.getInt("max_download") && (row.getInt("tot_down_cnt") < row.getInt("max_issue") || row.getInt("max_issue") == 0)) {
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
							<a href="javascript:couponDownload('<%= row.get("couponid") %>');" class="downBtn"><img src="/images/btn/btn_download.png" alt="다운로드"></a>
<!-- 							<span class="downBtn disabled"><img src="/images/btn/btn_download.png" alt="다운로드"></span> -->
						</td>
					</tr>
<%
			m++;
		}
	}
	if(list.size() == 0 && m == 0) {
%>
					<tr><td colspan="4">+++ 쿠폰 내역이 없습니다 +++</td></tr>
<%
	}
%>
				</tbody>
			</table>
			<ul class="paging">
			</ul>
			<!-- //내용영역 -->
		</div><!-- //contArea -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>