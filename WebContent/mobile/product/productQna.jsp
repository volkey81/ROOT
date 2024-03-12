<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.utils.*,
				 com.sanghafarm.service.board.*" %>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);
	ProductQnaService qna = (new ProductQnaService()).toProxyInstance();
		
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 5);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);

	//게시물 리스트
	List<Param> list = qna.getList(param);
	//게시물 갯수
	int totalCount = qna.getListCount(param);
%>
			<h3 class="typeA">상품 Q&amp;A</h3>
			<p class="text">배송, 주문(취소/교환/환불)관련 문의 등은 1:1 문의에 남겨주세요.</p>
			<div class="btnArea">
				<span><a href="#" onclick="showQnaPop(); return false" class="btnTypeB">Q&amp;A 작성</a></span>
				<span><a href="/mobile/customer/counsel.jsp" class="btnTypeG">1:1 문의</a></span>
			</div>
			<ol class="qnaList">
<%
	int i = 1;
	for(Param row : list) {
%>
				<li>
					<div class="head">
<%
		if(!"Y".equals(row.get("secret_yn")) || row.get("userid").equals(fs.getUserId())) {
%>								
						<a href="#qnaCont<%=i %>" onclick="showTab2(this, 'qnaCont');return false">
<%
		} else {
%>
						<a href="#none" onclick="alert('비밀글로 설정된 게시물은 본인 만 조회 가능합니다.\n본인이신 경우, 로그인 후 조회하세요')" class="secret">
<%
		}
%>
							<p class="tit"><span class="fontTypeA">[<%= row.get("cate_name") %>]</span> <%= Utils.safeHTML(row.get("title")) %></p>
							<p class="ico">
<%
		if("".equals(row.get("answer"))) {
			out.println("답변대기");
		} else {
			out.println("답변완료");
		}
%>						
							
							</p>
							<p class="user"><%= Utils.maskString(row.get("userid")) %><span class="date"><%= row.get("regist_date") %></span></p>
						</a>
					</div>
					<div class="qnaCont" id="qnaCont<%=i %>">
<%
		if(!"Y".equals(row.get("secret_yn")) || row.get("userid").equals(fs.getUserId())) {
%>
					<%= Utils.safeHTML(row.get("question"), true) %>
<%
			if(!"".equals(row.get("answer"))) {
%>
						<div class="answer">
							<%= Utils.safeHTML(row.get("answer"), true) %>
						</div>
<%
			}
		}
%>
					</div>
				</li>

<%
	i++;
	}

	if(list.size() == 0) {
%>
				<li class="none">+++ 작성된 Q&A가 없습니다. +++</li>
<%
	}
%>				
			</ol>
			<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging("javascript:getProductQna('[page]')", totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeTo(out);
	}
%>
			</ul>
