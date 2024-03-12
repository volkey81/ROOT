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
	
	boolean isReview = false;
	String msg = StringUtils.EMPTY;
	String orderid = StringUtils.EMPTY;
	String shipSeq = StringUtils.EMPTY;
	String item	   = StringUtils.EMPTY;
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
var imageDivision = "1";
function goReview(){
	if ('<%= isReview%>' == 'true') {
		showPopupLayer('/mobile/popup/review.jsp?pid=<%= param.get("pid") %>&orderid=<%= orderid%>&ship_seq=<%=shipSeq%>&item_seq=<%=item%>');
	} else {
		alert('<%= msg%>');
	}	
}
<%
if(fs.isApp() && "Y".equals(fs.getAppOS())){
%>
function sendFileData(orgName, image, division){
	var params = {
			"image": image,
			"orgName" : orgName,
			"board" : "01"
	}
	$.ajax({
	  type: "POST",
	  url: "/mobile/popup/appProc.jsp",
	  dataType:'json',
	  contentType: "application/x-www-form-urlencoded; charset=utf-8",
	  data: params,
	  success: function(data) {
		  if(data.isOk == "true"){
			  var ifra = document.getElementById("iframePopLayer113").contentWindow;
			  ifra.sendData(division, data.imagename);
		  } else {
			  alert(data.msg);  
		  }
		},
		error: function(data) {
			alert(data.msg);
		} 
	});
}
<%
}
%>

</script>
			<h3 class="typeA">고객상품평</h3>
			<p class="text">상품을 구매하신 고객들이 남기신 후기입니다.</p>
			<div class="btnArea">
<!-- 				<span><a href="javascript:goReview();" class="btnTypeB">상품평쓰기</a></span> -->
			</div>
<%
	if(imageList.size() > 0) {
%>
			<div class="photoReview">
				<ul>
<%
		for(int i = 0; i < imageList.size() && i < 8; i++) {
			Param row = imageList.get(i);
%>
					<li><a href="#" onclick="showPopupLayer('/mobile/popup/photoReview.jsp?pid=<%= param.get("pid") %>'); return false"><img src="<%= row.get("img") %>" alt=""></a></li>
<%
		}
%>
				</ul>
<%
		if(imageList.size() > 8) {
%>
				<p class="more"><a href="#" onclick="showPopupLayer('/mobile/popup/photoReview.jsp?pid=<%= param.get("pid") %>'); return false"><strong>5</strong><br>더보기 ></a></p>
<%
		}
%>
			</div><!-- //photoReview -->
<%
	}
%>
			<ol class="reviewList">
<%
	int i = 1;
	for(Param row : noticeList) {
%>
				<li>
					<div class="head"><a href="#reviewAdminCont<%=i %>" onclick="showTab2(this, 'reviewAdminCont'); return false">
						<p class="tit">					
						<%= Utils.safeHTML(row.get("title")) %></p>
						<p></p>
						<p class="user"><%= Utils.maskString(row.get("regist_user")) %><span class="date"><%= row.get("regist_date") %></span></p>
					</a></div>
					<div class="reviewAdminCont" id="reviewAdminCont<%=i %>" style="display:none;">
						<%= row.get("contents") %><br/>
					</div>
				</li>				
<%
	i++;
	} 
	i = 1;
	for(Param row : list) {
%>
				<li>
					<div class="head"><a href="#reviewCont<%=i %>" onclick="showTab2(this, 'reviewCont'); return false">
						<p class="tit">
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
						<%= Utils.safeHTML(row.get("title")) %></p>
						<%-- <p class="assess"><span class="assess<%= row.get("score") %>"><img src="/mobile/images/common/ico_assess.png" alt="평점<%= row.get("score") %>"></span></p> --%>
						<p class="user"><%= Utils.maskString(row.get("userid")) %><span class="date"><%= row.get("regist_date") %></span></p>
					</a></div>
					<div class="reviewCont" id="reviewCont<%=i %>">
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
						<% } %>
					</div>
				</li>				
<%
	i++;
	} 

	if(list.size() == 0) {
%>
				<li class="none">+++ 작성된 상품평이 없습니다. +++</li>
<%
	}
%>
			</ol>
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