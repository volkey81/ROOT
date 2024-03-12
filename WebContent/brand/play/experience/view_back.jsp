<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="com.efusioni.stone.utils.Utils"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.sanghafarm.service.brand.ExpClassService"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(2));
	request.setAttribute("MENU_TITLE", new String("체험교실"));
	
	Param param = new Param(request);
	ExpClassService svc = (new ExpClassService()).toProxyInstance();
	if (StringUtils.isEmpty(param.get("seq"))) {
		Utils.sendMessage(out, "잘못된 경로로 접근하였습니다.");
		return;
	}
	Param info  = svc.getInfo(param.getInt("seq"));
	List<String> imgList = new ArrayList<String>();	
	if (StringUtils.isNotEmpty(info.get("img1"))) {
		imgList.add(info.get("img1"));
	} else if (StringUtils.isNotEmpty(info.get("img2"))) {
		imgList.add(info.get("img2"));
	} else if (StringUtils.isNotEmpty(info.get("img3"))) {
		imgList.add(info.get("img3"));
	} else if (StringUtils.isNotEmpty(info.get("img4"))) {
		imgList.add(info.get("img4"));
	} else if (StringUtils.isNotEmpty(info.get("img5"))) {
		imgList.add(info.get("img5"));
	}
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" /> 
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<jsp:include page="/brand/include/location.jsp" />
	<jsp:include page="/brand/include/snb.jsp" />
	<div id="container">
	<!-- 내용영역 -->
		<div class="expView">
			<div class="gallery">
<%
					if (CollectionUtils.isNotEmpty(imgList)) {					
%>
				<div class="slideCont">
					<ul class="list">
<%
					int i = 1;
					for (String img : imgList) {					
%>
						<li id="gallery<%= i++%>"><img src="<%= img %>" alt=""></li>
<%
					}						
%>
					</ul>
				</div>
				<ul class="nav">
					<!-- cycle.js -->
				</ul>				
<%
					}						
%>
			</div><!-- //gallery -->
			<div class="titArea">
				<p class="tit"><%=info.get("title") %></p>
				<p class="btn"><a href="/brand/play/reservation/admission.jsp">예약하기</a></p>
			</div>
			<table class="bbsList">
				<caption>체험 프로그램 상세내용</caption>
				<colgroup>
					<col width="320"><col width=""><col width=""><col width=""><col width="">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">체험명</th>
						<th scope="col">소요시간</th>
						<th scope="col">포장시간</th>
						<th scope="col">난이도</th>
						<th scope="col">가격</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th scope="row"><%=info.get("title") %></th>
						<td><%=info.get("req_time") %></td>
						<td><%=info.get("wrap_time") %></td>
						<td><p class="assess"><span class="assess<%= info.get("difficulty")%>"><img src="/images/common/ico_assess2.png" alt="별점<%= info.get("difficulty")%>"></span></p></td>
						<td><%= info.get("price")%></td>
					</tr>
				</tbody>
			</table>
			<div class="content">
				<%= info.get("contents")%>
			</div>
			<div class="btnArea">
				<a href="list.jsp" class="btnTypeB sizeL">목록</a>
			</div>
		</div><!-- //expView -->
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
<script>
setCycle(".gallery", "fade", "gallery", 800, 0, "", "");
</script>
</body>
</html>
