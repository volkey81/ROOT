<%@page import="java.util.List"%>
<%@page import="com.sanghafarm.common.FrontSession"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.efusioni.stone.utils.Param"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="calTabArea">
	<div class="date">
		<span>2018.11.05</span>
		<a href="javascript:popLayerOpen();" class="calBtn"><img src="/images/brand/play/icon_calender2.png" alt="달력아이콘"></a>
	</div>
	<p>* 체험 일정 및 시간은 일부 조정될 수 있습니다.</p>
	<a href="" class="prev"><img src="/images/btn/btn_prev8.png" alt="이전 날짜"></a>
	<a href="" class="next"><img src="/images/btn/btn_prev8.png" alt="다음 날짜"></a>
</div>
<ul class="programList2">
<%for(int i=0; i < 5; i++){ %>
	<li>
		<div class="time">09:30</div>
		<div class="cont">
			<strong>소시지 만들기<img src="/images/brand/play/img_tag01.jpg" alt="카테고리"  class="cate"></strong>
			<p>컨텐츠 내용 컨텐츠 내용</p>
			<a href="">자세히보기 &gt;</a>
		</div>
		<div class="thum"><div class="box"><img src="/sanghafarm_Data/upload/shop/board/201704/thumb_1491295074850.JPG" alt=""></div></div>
	</li>
<%} %>
</ul>
<ul class="paging">
<%-- <%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging("javascript:paging('[page]', 2)", totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeToShop(out);
	}
%> --%>
</ul>