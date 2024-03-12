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
			<p class="text">본 상품과 관련한 궁금한 사항을 알려드립니다.<br>배송, 주문(취소/교환/환불)관련 문의 및 개별 요청사항은 1:1 문의에 남겨주세요.</p>
			<table class="bbsList typeC">
				<caption>상품 Q&A 목록</caption>
				<colgroup>
					<col width="80"><col width="90"><col width=""><col width="100"><col width="90"><col width="120">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">no</th>
						<th scope="col">분류</th>
						<th scope="col">제목</th>
						<th scope="col">작성자</th>
						<th scope="col">답변</th>
						<th scope="col">등록일</th>
					</tr>
				</thead>
				<tbody>
<%
	int i = 1;
	for(Param row : list) {
%>
					<tr>
						<th scope="row"><%= totalCount - ((nPage - 1) * PAGE_SIZE) - row.getInt("rnum") + 1 %></th>
						<td><%= row.get("cate_name") %></td>
						<td class="tit">
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
							<%= Utils.safeHTML(row.get("title")) %></a>
						</td>
						<td><%= Utils.maskString(row.get("userid")) %></td>
						<td>
<%
		if("".equals(row.get("answer"))) {
			out.println("답변대기");
		} else {
			out.println("답변완료");
		}
%>
						</td>
						<td><%= row.get("regist_date") %></td>
					</tr>
					<tr class="qnaCont" id="qnaCont<%=i %>" style="display:none;"><td colspan="6" style="display:none;">
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
					</td></tr>
<%
	i++;
	}

	if(list.size() == 0) {
%>
					<tr><td colspan="6">+++ 작성된 Q&A가 없습니다. +++</td></tr>
<%
	}
%>
				</tbody>
			</table>
			<div class="btnArea ar">
				<a href="#none" onclick="showQnaPop(); return false" class="btnTypeB">Q&amp;A 작성</a>
				<a href="/customer/counsel.jsp" class="btnTypeA">1:1 문의</a>
			</div>
			<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging("javascript:getProductQna('[page]')", totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeTo(out);
	}
%>
			</ul>
