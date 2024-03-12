<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.efusioni.stone.common.*,
			com.sanghafarm.common.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.service.board.*" %>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
			
	param.set("seq", SystemChecker.isReal() ? 27 : 12);
	
	EventService svc = (new EventService()).toProxyInstance();
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 5);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);

	//게시물 리스트
	List<Param> list = svc.getCommentList(param);

	//게시물 갯수
	int totalCount = svc.getCommentListCount(param);
%>
			<ul class="list">
<%
	for(Param row : list) {
%>
				<li>
					<div class="info">
						<strong><%= row.get("userid") %></strong>
						<span class="date"><%= row.get("regist_date") %></span>
						<p class="btn">
<%
		if(row.get("userid").equals(fs.getUserId())) {
%>
							<a href="javascript:setModify('<%= row.get("sub_seq") %>')" id="modifyTxt_<%= row.get("sub_seq") %>">수정</a>
							<a href="javascript:goRemove('<%= row.get("sub_seq") %>')">삭제</a>
<%
		}
%>
						</p>
					</div>
					<div class="cont">
<%
		if(row.get("userid").equals(fs.getUserId())) {
%>
						<div class="modify" style="display:none" id="contents1_<%= row.get("sub_seq") %>">
							<textarea name="contents_<%= row.get("sub_seq") %>" id="contents_<%= row.get("sub_seq") %>"><%= row.get("contents") %></textarea>
							<a href="javascript:goModify('<%= row.get("sub_seq") %>')" class="btn">확인</a>
						</div>
						<div id="contents2_<%= row.get("sub_seq") %>"><%= Utils.safeHTML(row.get("contents"), true) %></div>
<%
		} else if("disney223".equals(fs.getUserId())) {
%>
						<div id="contents2_<%= row.get("sub_seq") %>"><%= Utils.safeHTML(row.get("contents"), true) %></div>
<%
		} else {
%>					
						비밀게시글입니다. 작성자와 관리자만 볼 수 있습니다.
<%
		}
%>
					</div>
				</li>
<%
	}

	if(totalCount == 0) {
%>
				<li class="none">+++ 댓글을 등록해주세요! +++</li>
<%
	}
%>
			</ul>
			<ul class="paging">
<%
	if(totalCount > 0) {
		MobilePaging paging = new MobilePaging("javascript:getComment([page])", totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeToShop(out);
	}
%>
			</ul>
