<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*" %>
<%@ page import="java.util.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("Depth_4", new Integer(0));
	request.setAttribute("MENU_TITLE", new String("복리후생"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/include/head.jsp" />
</head>  
<body>
<div id="wrapper">
	<jsp:include page="/include/header_new.jsp" />
	<jsp:include page="/brand/include/location_job.jsp" />

<div id="snbBrand">

	<ul class="menu01">
		<!--<li><a href="/brand/introduce/story.jsp">채용공고</a></li>-->
		<li><a href="/brand/bbs/jobnotice/story1.jsp">핵심가치</a></li>
		<li><a href="/brand/bbs/jobnotice/story2.jsp">인재상</a></li>
		<li class="on"><a href="/brand/bbs/jobnotice/story3.jsp">복리후생</a></li>
		<li><a href="/brand/bbs/jobnotice/story4_list.jsp">입사지원하기</a></li>
	</ul>
</div>
	<!-- <div id="container" class="storyWrap"> -->
	<!-- 내용영역 -->
	<div class="contBody">
		<table width="1000" align="center" cellspacing="0" cellpadding="0">
			<tbody>
				<tr>
					<td>
						<img style="width:100%;" src="/images/brand/bbs/story3.png" alt="복리후생"  border="0" usemap="#imageMap1">						
						<map name="imageMap1">
							<!--<area href="#" shape="rect" coords="728,3351,905,3391" target="_blank" alt="이력서 다운받기">
							<area href="#" shape="rect" coords="728,3400,905,3440" target="_blank" alt="이메일 지원하기">
							<area href="#" shape="rect" coords="728,3442,905,3480" target="_blank" alt="채용사이트 이동">-->
							<area href="/images/brand/bbc/icon4_1.png" download="상하농원 이력서 다운로드" shape="rect" coords="62,3985,490,4070" target="_blank" alt="이력서 다운받기">
							<area href="#" shape="rect" coords="510,3985,940,4070" target="_blank" alt="상시 채용 지원하기">
							<area href="http://www.saramin.co.kr/zf_user/company-info/view-inner-recruit?csn=4158600211" shape="rect" coords="62,4085,940,4170" target="_blank" alt="현재 채용중인 공고보기">
						</map>
				
					</td>
				</tr>
			</tbody>
		</table>


	</div>	
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/include/footer.jsp" /> 
</div><!-- //wrapper -->
</body>
</html>
					