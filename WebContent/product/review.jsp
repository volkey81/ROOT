<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.utils.*,
				 com.sanghafarm.service.board.*" %>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);
	ReviewService review = (new ReviewService()).toProxyInstance();
	//페이징 변수 설정
	final int PAGE_SIZE = param.getInt("page_size", 5);
	final int BLOCK_SIZE = 10;
	int nPage = param.getInt("page", 1);
	param.addPaging(nPage, PAGE_SIZE);

	NoticeService notice = (new NoticeService()).toProxyInstance();
	
	List<Param> noticeList = notice.getList(new Param("status", "S", "cate", "003", "POS_STA", 0, "POS_END", Integer.MAX_VALUE));
		
	//게시물 리스트
	List<Param> list = review.getList(param);
	//게시물 갯수
	int totalCount = review.getListCount(param);

	String userId = StringUtils.EMPTY;
	if (fs.isLogin()) {
		userId = fs.getUserId();
	} else {
		userId = fs.getTempUserId();
	}
	param.set("userid", userId);
	String orderid = StringUtils.EMPTY;
	String shipSeq = StringUtils.EMPTY;
	String item	   = StringUtils.EMPTY;
	boolean isReview = false;
	String msg = StringUtils.EMPTY;
	int count = 0;
	List<Param> isReviewList = review.isReviewWrited(param);
	if (CollectionUtils.isEmpty(isReviewList)) {
		msg = "상품을 구매하시고, 배송이 완료된 회원께서 작성하실 수 있습니다.";
	}
	for (Param row : isReviewList) {
		count = review.getListCount(new Param("orderId", row.get("ORDERID"), "shipSeq", row.get("SHIP_SEQ")));
		if (StringUtils.equals("160", row.get("status"))
				|| StringUtils.equals("170", row.get("status"))) {
			if (count <= 0) {
				String[] items = row.get("ITEMS").split("::", 8);
				orderid = row.get("ORDERID");
				shipSeq = row.get("SHIP_SEQ");
				item = items[0];
				isReview = true;
				break;
			} else {
				msg = "이미 상품평을 작성하셨습니다.";
			}
		} else {
			if (count <= 0) {
				msg = "상품을 구매하시고, 배송이 완료된 회원께서 작성하실 수 있습니다.";
			} else {
				msg = "이미 상품평을 작성하셨습니다.";
			}
		}
	}
	
	// 이미지
	Param p = new Param();
	p.set("pid", param.get("pid"));
	p.addPaging(1, 15);
	List<Param> imageList = review.getImageList(p);
%>
<script>
function goReview(){
	if ('<%= isReview%>' == 'true') {
		showPopupLayer('/popup/review.jsp?pid=<%= param.get("pid") %>&orderid=<%= orderid%>&ship_seq=<%=shipSeq%>&item_seq=<%=item%>', '630');
	} else {
		alert('<%= msg%>');
	}		
}
</script>
			<h3 class="typeA">고객상품평</h3>
			<p class="text">사용후기를 남겨주세요. 게시판 성격과 다른 글은 사전동의 없이 다른 게시판으로 이동될 수 있습니다.<br>배송관련, 주문(취소/교환/환불)관련 문의 및 요청사항은 1:1 문의에 남겨주세요.</p>
<%
	if(imageList.size() > 0) {
%>
			<div class="photoReview">
				<ul>
<%
		for(int i = 0; i < imageList.size() && i < 8; i++) {
			Param row = imageList.get(i);
%>
					<li><a href="#" onclick="showPopupLayer('/popup/photoReview.jsp?pid=<%= param.get("pid") %>', '882'); return false"><img src="<%= row.get("img") %>" alt=""></a></li>
<%
		}
%>
				</ul>
<%
		if(imageList.size() > 8) {
%>
				<p class="more"><a href="#" onclick="showPopupLayer('/popup/photoReview.jsp?pid=<%= param.get("pid") %>', '882'); return false"><strong>5</strong><br>더보기 ></a></p>
<%
		}
%>
			</div><!-- //photoReview -->
<%
	}
%>
			<table class="bbsList typeC">
				<caption>상품평 목록</caption>
				<colgroup>
					<col width="80"><!-- <col width="130"> --><col width=""><col width="90"><col width="120">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">no</th>
						<!-- <th scope="col">별점</th> -->
						<th scope="col">제목</th>
						<th scope="col">작성자</th>
						<th scope="col">등록일</th>
					</tr>
				</thead>
				<tbody>
<%
	int i = 1;
	for(Param row : noticeList) {
%>
					<tr>
						<th scope="row"> - </th>
						<!-- <td></td> -->
						<td class="tit"><a href="#reviewAdminCont<%=i %>" onclick="showTab2(this, 'reviewAdminCont'); return false">
						<%= Utils.safeHTML(row.get("title")) %></a></td>
						<td><%= Utils.maskString(row.get("regist_user")) %></td>
						<td><%= row.get("regist_date") %></td>
					</tr>
					<tr class="reviewAdminCont" id="reviewAdminCont<%=i %>" style="display:none;"><td colspan="4" style="display:none;">
						<%= row.get("contents") %>
					</td></tr>
<%
	i++;
	} 				
	i = 1;
	int cnt = totalCount - ((nPage - 1) * PAGE_SIZE);
	for(Param row : list) {
%>
					<tr>
						<th scope="row"><%= cnt-- %></th>
						<%-- <td><p class="assess"><span class="assess<%= row.get("score") %>"><img src="/images/common/ico_assess.png" alt="평점<%= row.get("score") %>"></span></p></td> --%>
						<td class="tit"><a href="#reviewCont<%=i %>" onclick="showTab2(this, 'reviewCont'); return false">
<%
						if (StringUtils.isNotEmpty(row.get("best"))) {
							if (StringUtils.equals("1", row.get("best"))) {
%>
						<span class="icon recommend">
							추천
						</span> 
<%
							} else if (StringUtils.equals("2", row.get("best"))) {
%>
						<span class="icon best">
							베스트
						</span> 
<%
							}
						}
%>
						<%= Utils.safeHTML(row.get("title")) %></a></td><!-- best:베스트, recommend:추천 -->
						<td><%= Utils.maskString(row.get("userid")) %></td>
						<td><%= row.get("regist_date") %></td>
					</tr>
					<tr class="reviewCont" id="reviewCont<%=i %>" style="display:none;"><td colspan="4" style="display:none;">
						<%= Utils.safeHTML(row.get("contents"), true) %><br/>
						<%
							if (StringUtils.isNotEmpty(row.get("img1"))) {
						%>
						<img alt="" src="<%= row.get("img1") %>"><br/>
						<%
							}
							if (StringUtils.isNotEmpty(row.get("img2"))) {
						%>
						<img alt="" src="<%= row.get("img2") %>"> <br/>
						<%
							}
						%>
						<%
							if (StringUtils.isNotEmpty(row.get("answer"))) {
						%>
						<div class="answer">
							답변 : <%= Utils.safeHTML(row.get("answer"), true) %>
						</div>
						<%
							}
						%>
					</td></tr>
<%
	i++;
	} 

	if(list.size() == 0) {
%>
					<tr><td colspan="4">+++ 작성된 상품평이 없습니다. +++</td></tr>
<%
	}
%>
				</tbody>
			</table>
			<div class="btnArea ar">
<!-- 				<a href="javascript:goReview();"class="btnTypeB">상품평 작성</a> -->
			</div>
			<ul class="paging">
<%
	if(totalCount > 0){
		FrontPaging paging = new FrontPaging("javascript:getReview('[page]')", totalCount, nPage, PAGE_SIZE, BLOCK_SIZE);
		paging.writeTo(out);
	}
%>
			</ul>

<script>
$("body").imagesLoaded(function(){
	$(".photoReview li").each(function(){
		if($(this).find("img").height() < $(this).find("img").width()){
			$(this).addClass("vertical")
		}
	});
});
</script>