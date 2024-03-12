<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.common.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.service.product.*,
				 com.sanghafarm.service.board.*" %>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%
	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);
	ProductService product = (new ProductService()).toProxyInstance();
	
	param.set("grade_code", fs.getGradeCode());
	param.set("userid", fs.getUserId());
	Param info = product.getInfo(param);
	List<Param> optList = product.getOptionList(param);
	List<Param> dayList = product.getDeliveryDayList(param.get("pid"));
	List<Param> iconList = product.getIconList(param.get("pid"));
	List<Param> refList = product.getRefList(param);
	List<Param> cateList = product.getProductCateList(param.get("pid"));

	boolean isSoldOut = ("N".equals(info.get("sale_status")) || info.getInt("stock") == 0);
	boolean isOptSoldOut = false;
	boolean isAvailable = isSoldOut ? false : true;
	
	ReviewService review = (new ReviewService()).toProxyInstance();
	int reviewCount = review.getListCount(param);

	ProductQnaService qna = (new ProductQnaService()).toProxyInstance();
	int qnaCount = qna.getListCount(param);

	
	CateService cate = (new CateService()).toProxyInstance();
	// 1차 카테고리 리스트
	List<Param> list  = cate.get1DepthList(new Param());
	
	String pCateSeq = "";
	Param cateInfo = new Param();
	if (StringUtils.isNotEmpty(param.get("cate_seq"))) {
		cateInfo = cate.getInfo(param.getInt("cate_seq"));
		
		if(cateInfo.getInt("p_cate_seq") == 0) {	// 1dept
			pCateSeq = param.get("cate_seq");
			cateList = cate.getSubDepthList(param);
		} else {
			pCateSeq = cateInfo.get("p_cate_seq");
			cateList = cate.getSubDepthList(new Param("cate_seq", cateInfo.get("p_cate_seq")));
		}
	}
	// 최근본 상품 세션/DB 셋팅 Start
	Param recentParam = new Param("pid", param.get("pid"), "userid", fs.getUserId(), "thumb", info.get("thumb"));
	if(fs.isLogin()) {
		product.mergeToRecentProduct(recentParam);			
	} else {
		List<Param> recentList = (ArrayList<Param>)session.getAttribute("recentList");
		if(!CollectionUtils.isEmpty(recentList)) {
			recentList.remove(recentParam);
		} else {
			recentList = new ArrayList<Param>();
		}
		recentList.add(0, recentParam);
		session.setAttribute("recentList", recentList);
	}
	// 최근본 상품 세션/DB 셋팅 End
	
	Param rootCateParam = new Param();
	if (StringUtils.isNotEmpty(param.get("cate_seq"))) {
		rootCateParam = product.getPidForRootCateseq(param.getInt("cate_seq"));
	} else {
		int cateSeq = product.getCateSeqForPid(param.get("pid"));
		rootCateParam = product.getPidForRootCateseq(cateSeq);
	}
	
	// 8월 정기배송 특가 상품 코드
	String eventPid = Config.get("evend1.pid." + SystemChecker.getCurrentName());
%>
<%
	request.setAttribute("Depth_1", new Integer(2));
	request.setAttribute("Depth_2", new Integer(1));
	request.setAttribute("Depth_3", new Integer(1));
	request.setAttribute("MENU_TITLE", info.get("pnm"));
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<jsp:include page="/mobile/include/head.jsp" /> 
<meta property="og:type" content="website">
<meta property="og:site_name" content="상하농원">
<meta property="og:title" content="상하농원 | 쇼핑몰 | <%= info.get("pnm") %>">
<meta name="og:url" content="">
<meta property="og:description" content="<%= info.get("summary") %>">
<meta name="twitter:site" content="상하농원"/>
<meta name="twitter:title" content="상하농원 | 쇼핑몰 | <%= info.get("pnm") %>"/>
<meta name="twitter:description" content="<%= info.get("summary") %>">
<meta charset="utf-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0, maximum-scale=3.0, minimum-scale=1.0">
<meta name='tas:productName' content='<%= info.get("pnm") %>'>
<meta name='tas:productCode' content='<%= info.get("pid") %>'>
<meta name='tas:productPrice' content='<%= info.get("sale_price") %>'>
<meta name='tas:productUrl' content='http://<%= request.getServerName() %>/product/detail.jsp?pid=<%= info.get("pid") %>'>
<meta name='tas:productImg' content='http://<%= request.getServerName() %><%= info.get("image1") %>'>
<script type="text/javascript" src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<%-- <link rel="stylesheet" href="/mobile/css/swiper.min.css?t=<%=System.currentTimeMillis()%>"> --%>
<script type="text/javascript" src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script>
	$(function(){
		getReview('1');
		getProductQna('1');
// 		Kakao.init('875eb70060bda09cc2d0a3dfc9998a05');    	
//     	Kakao.init("c707efb5a7e6b40706594364f10a5b18");
		Kakao.init('b0f34396ce9620b05e6814cac819e2d0');    	

<%
	if(eventPid.equals(param.get("pid"))) {	// 8월 정기배송 특가 상품
%>
		alert("본 상품은 8월 3일 이후 첫 배송일이 지정되는 프로모션 상품입니다.\n\n‘첫 배송예정일’을 꼭 확인하세요");
<%
	}
%>
	});

	function sendSns(sns){
	    var _url = encodeURIComponent(location.href);
// 	    var _txt = encodeURIComponent(document.title);
	    var _txt = encodeURIComponent("상하농원 | 쇼핑몰 | <%= info.get("pnm") %>");
	    var imgSrc = location.protocol + '//' + location.hostname  + '<%= info.get("image1") %>';
	    switch(sns){
	        case 'facebook':
	           	window.open('http://www.facebook.com/sharer/sharer.php?u=' + _url + '&target=web');
		        break;
	        case 'twitter':
				window.open('http://twitter.com/intent/tweet?text=' + _txt + '&url=' + _url + '&target=web');
	            break;
	        case 'kakao' :
	        	/*
	        	Kakao.Link.sendTalkLink({
	     			label: "상하농원 | 쇼핑몰 | <%= info.get("pnm") %>",
	     			webLink : {
	     				text : "상하농원 | 쇼핑몰 | <%= info.get("pnm") %>",
	     				url  : location.href
	     			},
	      			image : {
	     				src : imgSrc,
	     				width : "240",
	     				height : "260"			
	     			}
     			});
	        	*/
	        	Kakao.Link.sendDefault({
// 	        		container: '#kakao-link-btn',
	        		objectType: 'feed',
	        		content: {
	        			title: "상하농원 | 쇼핑몰 | <%= info.get("pnm") %>",
	        			description: "상하농원 | 쇼핑몰 | <%= info.get("pnm") %>",
	        			imageUrl: location.protocol + '//' + location.hostname  + '<%= info.get("image1") %>',
	        			link: {
	        				mobileWebUrl: location.href,
	        				webUrl: location.href
	        			}
	        		}
	        	});
	        	break;
	    }
	}
	
	function shareStory() {
	    var _url = location.href;
// 	    var _txt = document.title;
	    var _txt = "상하농원 | 쇼핑몰 | <%= info.get("pnm") %>";
	    
		Kakao.Story.share({
			url: _url,
			text: _txt
		});
	}

	function setQty(dir, pid) {
		if(dir == 'up') {
			$("#qty_" + pid).val(parseInt($("#qty_" + pid).val()) + 1);
		} else {
			if($("#qty_" + pid).val() != 0) {
				$("#qty_" + pid).val(parseInt($("#qty_" + pid).val()) - 1);
			}
		}
		
		var price = parseInt($("#qty_" + pid).val()) * parseInt($("#sale_price_" + pid).val());
		$("#sale_price_txt_" + pid).html(price.formatMoney() + " 원");
		calculatePrice();
	}
	
	function calculatePrice() {
		var totalAmt = 0;
		var arrPid = $.makeArray($("input[name=sub_pid]"));
		var arrPrice = $.makeArray($("input[name=sale_price]"));
 		var arrQty = $.makeArray($("input[name=qty]"));

		for(var i = 0; i < arrPid.length; i++) {
// 			totalAmt += parseInt($(arrPrice[i]).val()) * parseInt($(arrQty[i]).val());	
			totalAmt += parseInt($(arrPrice[i]).val()) * parseInt($("input[name=qty_" + $(arrPid[i]).val() + "]").val());	
		}
		
// 		alert(totalAmt);
		$("#total_price").empty().html(totalAmt.formatMoney());
	}

	//장바구니담기 완료
	function addCart(orderYn) {
<%
	if("Y".equals(info.get("adult_auth")) && !fs.isLogin()) {
%>
		showPopupLayer('/mobile/popup/noMinors.jsp');	//성인 인증 레이어팝업
<%
	} else if("Y".equals(info.get("adult_auth")) && !fs.isAdult()) {
%>
		showPopupLayer('/mobile/member/adultCertification.jsp');		
	
<%
	} else {
%>
		if($(".pdtQuick .close").is(":hidden")) {
			showQuick();
			return;
		}

		var totQty = 0;
		$("input[name=sub_pid]").each(function() {
			totQty += parseInt($("#qty_" + $(this).val()).val());
		});
	
		if(totQty == 0) {
			alert("상품 수량을 선택하세요.");
			showQuick();
			return;
		}

		/*
		if($(":input[name=sub_pid]").size() == 0) {
			alert("상품 옵션을 선택하세요.");
			showQuick();
			return;
		}
		*/
<%
		if("D".equals(info.get("ptype"))) {
%>
		if($("select[name=delivery_date]").val() == "") {
			alert("배송일을 지정하세요.");
			showQuick();
			return;
		}
<%
		}
%>
		$("#cartForm").attr("action", "/order/cartProc.jsp");
		$("#cartForm").attr("target", "");
		$("#cartForm input[name=mode]").val("CREATE");
		$("#cartForm input[name=order_yn]").val(orderYn);

		ajaxSubmit($("#cartForm"), function(json) {
// 			alert(json.result);
			if(json.result) {
				/*
				var arrPnm = [];
				var etEx = ET.getElementDataExtractor();
<%
		if(!"Y".equals(info.get("routine_yn")) && optList.size() > 0) {
%>
				$("#cartForm input[name=sub_pnm]").each(function() {
					//기존소스
					//arrPnm.push('<%= info.get("pnm") %>' + " - " + $(this).val());
					arrPnm.push({
						productName: '<%= info.get("pnm") %>' + " - " + $(this).val(),
						productPrice: etEx.extractValue("#total_price"),
						productUrl: etEx.extractValue("meta[name='tas:productUrl']",'content'),
						productImg: etEx.extractValue("meta[name='tas:productImg']",'content')
					});
				});
<%
		} else {
%>
				//기존소스
				//arrPnm.push('<%= info.get("pnm") %>');
				arrPnm.push({
					productName: '<%= info.get("pnm") %>',
					productPrice: etEx.extractValue("#total_price"),
					productUrl: etEx.extractValue("meta[name='tas:productUrl']",'content'),
					productImg: etEx.extractValue("meta[name='tas:productImg']",'content')
				});
<%
		}
%>
		
				var arrCate = [];
<%
		for(Param r : cateList) {
%>
				arrCate.push('<%= r.get("cate_name") %>');
<%
		}
%>
				ET.exec('cart', arrPnm, arrCate);
				*/
				
				if(orderYn == 'Y') {
<%
		if(fs.isLogin()) {
%>
					document.location.href="/mobile/order/payment.jsp";
<%
		} else {
%>
					showPopupLayer('/mobile/popup/memberGate.jsp');
<%
		}
%>
				} else {
					hideQuick();
					showMessage('장바구니에 상품을 담았습니다');
					getCartCount();
//					showPopupLayer('/mobile/popup/cartComplete.jsp');
// 					showPopupLayer('/mobile/popup/noMinors.jsp');//성인 인증 레이어팝업
				}
			} else {
				alert(json.msg);
			}
		});
<%
	}
%>
	}

	function routinePop() {
		showPopupLayer('/mobile/popup/regularOption.jsp?pid=<%= info.get("pid") %>&qty=' + $("#qty_<%= info.get("pid") %>").val(), 'fix');
	}

	var wish = "<%= info.get("wish_yn") %>";
	function addWish() {
		if(wish == "N") {
			$("#cartForm").attr("action", "/mypage/wishProc.jsp");
			$("#cartForm").attr("target", "");
			$("#cartForm input[name=mode]").val("CREATE");
	
			ajaxSubmit($("#cartForm"), function(json) {
	 			//alert(json.result);
				if(json.result) {
					wish = "Y";
					$("#btnWish").addClass("on");
// 					alert("본 상품을 단골상품으로 등록하였습니다.");
				}

				if(json.msg == '<%= FrontSession.LOGIN_MSG %>') {
					fnt_login('R');
				}
			});
		} else {
			if(confirm("이 상품을 단골상품에서 등록 취소하시겠습니까?")) {
				$("#cartForm").attr("action", "/mypage/wishProc.jsp");
				$("#cartForm").attr("target", "");
				$("#cartForm input[name=mode]").val("REMOVE");
		
				ajaxSubmit($("#cartForm"), function(json) {
					if(json.result) {
						wish = "N";
						$("#btnWish").removeClass("on");
// 						alert("취소되었습니다.");
					}
				});
			}
		}
	}

	function getReview(p) {
		$.ajax({
			method : "POST",
			url : "review.jsp",
			data : { pid : "<%= param.get("pid") %>", page : p },
			dataType : "html"
		})
		.done(function(html) {
			$("#pdtDetail2").html(html);
		});
	}

	function getProductQna(p) {
		$.ajax({
			method : "POST",
			url : "productQna.jsp",
			data : { pid : "<%= param.get("pid") %>", page : p },
			dataType : "html"
		})
		.done(function(html) {
			$("#pdtDetail3").html(html);
		});
	}

	function showQnaPop(){
<%
	if(fs.isLogin()) {
%>
		showPopupLayer('/mobile/popup/qna.jsp?pid=<%= info.get("pid") %>');
<%
	} else {
%>
		confirmLogin();
<%
	}
%>
	}
	
	<%
	if(fs.isApp() && "android".equals(fs.getAppOS())){
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
	
// 	ET.exec('view');
</script>
<style>
#footer {padding-bottom:92px;}
</style>
</head>  
<body>
<div id="wrapper" class="">
	<jsp:include page="/mobile/include/header.jsp" />
	<div id="container">
	<!-- 내용영역 -->
	<%-- <h1><%=cateInfo.get("cate_name") %></h1> --%>
<%
		if (StringUtils.isEmpty(param.get("mode"))) {
%>
		<!-- <div class="pdtCate typeB">
			<ul class="swiper-wrapper">
				<li class="swiper-slide<%= pCateSeq.equals(param.get("cate_seq")) ? " on" : "" %>"><a href="/mobile/product/list.jsp?cate_seq=<%= pCateSeq %>">전체보기</a></li>
<%
	for(Param row : cateList) {
%>
				<li class="swiper-slide<%= row.get("cate_seq").equals(param.get("cate_seq")) ? " on" : "" %>"><a href="/mobile/product/list.jsp?cate_seq=<%= row.get("cate_seq") %>"><%= row.get("cate_name") %></a></li>
<%
	}
%>
			</ul>
		</div> -->
<%
	}
%>	
		<div class="pdtHead">
			<div class="thumbArea">
				<p class="thumb"><img src="<%= info.get("image1") %>" alt=""></p>
				<p class="icon">
					<span><%= info.get("icon") %></span>
				</p>
			</div><!-- //thumbArea -->
			<div class="titArea">
			<h2><%= info.get("pnm") %></h2>
				<p class="summary"><%= info.get("summary") %></p>
					<div class="snsArea">
					<a href="#" onclick="addWish()" <%= "Y".equals(info.get("wish_yn")) ? "class='on'" : "" %> id="btnWish"><img src="/mobile/images/product/btn_wish.png?ver=1" alt="단골상품"></a>
					<a href="#" onclick="showSns(this); return false"><img src="/mobile/images/product/btn_sns.png" alt="sns 공유하기"></a>
				</div>
				<p class="price">
					<strong><%= Utils.formatMoney(info.get("sale_price")) %></strong>원
<%
	if(info.getInt("default_price") > info.getInt("sale_price")) {
%>
					<span class="discount"><strong><%= (info.getInt("default_price") - info.getInt("sale_price")) * 100 / info.getInt("default_price") %></strong>%</span>
<%
	}
%>				
				</p>
				<p class="original">
<%
	if(info.getInt("default_price") > info.getInt("sale_price")) {
%>
					<strike><%= Utils.formatMoney(info.get("default_price")) %>원</strike>
<%
	}
%>				
				</p>
			</div>
			<div class="pdtInfo">
				<dl>
					<dt>판매단위</dt><dd><%= info.get("sale_unit") %></dd>
					<dt>중량/용량</dt><dd><%= info.get("weight") %></dd>
<%
	String deliveryTypeName = "";
	if(info.get("delivery_type2").length() > 0 && "Y".equals(info.get("delivery_type2").subSequence(0, 1))) deliveryTypeName += ", 일반";
	if(info.get("delivery_type2").length() > 1 && "Y".equals(info.get("delivery_type2").subSequence(1, 2))) deliveryTypeName += ", 새벽";
	if(info.get("delivery_type2").length() > 2 && "Y".equals(info.get("delivery_type2").subSequence(2, 3))) deliveryTypeName += ", 산지";
	if(deliveryTypeName.length() > 2) {
		deliveryTypeName = deliveryTypeName.substring(2);
%>
					<dt>배송구분</dt><dd><%= deliveryTypeName %></dd>
<%
	}
	String keepMethod = "";
	if(info.get("keep_method2").length() > 0 && "Y".equals(info.get("keep_method2").subSequence(0, 1))) keepMethod += ", 냉장";
	if(info.get("keep_method2").length() > 1 && "Y".equals(info.get("keep_method2").subSequence(1, 2))) keepMethod += ", 냉동";
	if(info.get("keep_method2").length() > 2 && "Y".equals(info.get("keep_method2").subSequence(2, 3))) keepMethod += ", 상온";
	if(keepMethod.length() > 2) {
		keepMethod = keepMethod.substring(2);
%>
					<dt>보관방법</dt><dd><%= keepMethod %></dd>
<%
	}
	if(StringUtils.isNotEmpty(info.get("origin"))) {
%>
					<dt>원산지</dt><dd><%= info.get("origin") %></dd>
<%
	}
	if(StringUtils.isNotEmpty(info.get("expiration"))) {
%>
					<dt>유통기한</dt><dd><%= info.get("expiration") %></dd>
<%
	}
	if(StringUtils.isNotEmpty(info.get("info"))) {
%>
					<dt>안내사항</dt><dd><%= info.get("info") %></dd>
<%
	}
%>
<%-- 					<dt>상품번호</dt><dd><%= info.get("pid") %></dd> --%>
				</dl>		
<%
	if("Y".equals(info.get("adult_auth"))) {
%>
				<div class="noMinors">
					<img src="/images/product/adultMark.png" alt="미성년자 제한">
					<p><strong>주류의 통신판매에 관한 명령위임고시</strong>관계법령에 따라  미성년자는 구매할 수 없으며,<br>19세 이상 성인인증을 하셔야 구매 가능한 상품입니다.</p>
				</div>			
<%
	}

	if("A".equals(info.get("ptype"))) {
%>
				<div class="early">
					<p class="tit">새벽배송</p>
					<p class="text">주 6일 출고(일~금)</p>
					<p class="text">오후 6시까지 주문시 내일 아침 7시 전 도착</p>
					<p class="text">*상품별 배송방법 부분적용은 불가합니다.</p>
					<a href="#" onclick="execDaumPostcode(); return false" class="btn">새벽 배송 가능지역 확인하기</a>					
				</div>
<%
	}
%>
			</div><!-- //pdtInfo -->
		</div><!-- //pdtHead -->
		
		<div class="tabArea">
			<ul class="tabTypeB tabNum4">
				<li class="on"><a href="#pdtDetail1" onclick="goFloatingTab(this); return false">상세정보</a></li>
				<li><a href="#pdtDetail2" onclick="goFloatingTab(this); return false">고객상품평</a></li>
				<li><a href="#pdtDetail3" onclick="goFloatingTab(this); return false">상품 Q&amp;A</a></li>
				<li><a href="#pdtDetail4" onclick="goFloatingTab(this); return false">배송안내</a></li>
			</ul>
		</div>
		<div class="pdtDetail" id="pdtDetail1">
			<!-- <h3 class="typeA">상세정보</h3> -->
			<div class="ac"><%= info.get("mcontents") %></div>
			<table class="bbsForm typeC">
				<caption>상품 상세정보</caption>
				<colgroup>
					<col width="100"><col width="">
				</colgroup>
				<tr>
					<th scope="row">상품명</th>
					<td><%= info.get("pnm") %></td>
				</tr>
				<tr>
					<th scope="row">인증여부</th>
					<td><%= info.get("auth") %></td>
				</tr>
				<tr>
					<th scope="row">포장단위</th>
					<td><%= info.get("pack_unit") %></td>
				</tr>
				<tr>
					<th scope="row">관련법상 표기사항</th>
					<td><%= info.get("declared") %></td>
				</tr>
				<tr>
					<th scope="row">생산자</th>
					<td><%= info.get("maker") %></td>
				</tr>
				<tr>
					<th scope="row">보관방법</th>
					<td><%= info.get("keep_method") %></td>
				</tr>
				<tr>
					<th scope="row">원산지</th>
					<td><%= info.get("origin") %></td>
				</tr>
				<tr>
					<th scope="row">소비자상담실 전화</th>
					<td><%= info.get("counsel_tel") %></td>
				</tr>
				<tr>
					<th scope="row">제조일자(포장일)</th>
					<td><%= info.get("dom") %></td>
				</tr>
				<tr>
					<th scope="row"></th>
					<td></td>
				</tr>
			</table>
		</div><!-- //상세정보 -->
		<div class="pdtDetail" id="pdtDetail2">
		</div><!-- //고객상품평 -->
		<div class="pdtDetail" id="pdtDetail3">
		</div><!-- //상품 Q&A -->

		<div class="pdtDetail otherProduct">
			<p class="tit">이 상품을 조회한 사람이 관심있는 다른 상품입니다.</p>
			<div class="slideCont">
				<ul class="swiper-wrapper">
<%
	for(int i = 0; i < refList.size() && i < 5; i++) {
		Param row = refList.get(i);
%>
					<li class="swiper-slide"><a href="detail.jsp?pid=<%= row.get("pid") %>">
						<p class="thumb"><img src="<%= row.get("image1") %>" alt=""></p>
						<p class="tit"><%= row.get("pnm") %></p>
						<p class="txt"><%= Utils.formatMoney(row.get("sale_price")) %>원</p>
					</a></li>
<%
	}
%>
				</ul>
			</div>
		</div>
		 		
		<div class="pdtDetail" id="pdtDetail4">
			<h3 class="typeA">꼭 아셔야 해요!</h3>
			<div class="deleveryInfo">
				<h4>상하농원 배송정책</h4>
				<p class="srmy">상하농원은 우수한 농산물과 가공제품을 신선하게 배송하고 고객님들이 쇼핑에 대한 다양한 경험을 누릴 수 있도록 차별화 된 배송정책을 수립하였습니다.</p>
				<h5>진심을 담은 포장</h5>
				<p>상하농원은 농부,어부,생산자의 땀과 그분들의 진심을 잘 전달하기 위해 상품 하나하나를 정성 껏 포장 하였습니다.</p>
				<h5>택배배송 15시, 새벽배송 18시 주문 마감</h5>
				<p>상하농원은 주 6일(일~금/공휴일 제외), 택배배송 15시, 새벽배송 18시 이전 주문 건까지 당일 발송하며, 산지직송 및 지정일배송 상품은 새벽배송이 불가합니다.</p>
				<p>산지직송 상품은 주 5일(월~금/공휴일 제외) 10시 이전 주문 건까지 당일 택배 발송하며, 상하농원 물류센터에 입고되지 않고 산지에서 직송으로 발송되어 상품의 특성에 따라 농가 및 어가의 차별화된 방식으로 포장, 배송됩니다.</p>
				
				<h4>상하농원 취소/교환/반품 정책</h4>
				<p class="srmy">상하농원은 고객님들이 이용하시는 상품에 대해 최대한 만족하실 수 있도록 취소/교환/반품 정책을 마련하였습니다.</p>
				<h5>주문 취소 안내</h5>
				<p>[결제완료] 이전 단계 : [마이페이지>주문배송조회>상세보기]에서 직접 취소 가능<br>[상품준비중] 단계 : 이미 생산, 배송이 진행된 상태로 주문 취소 불가</p>
				<h6><a href="#" onclick="$('.moreText').toggle(); return false">+ 더보기</a></h6>
				<div class="moreText" style="display:none">
					<ul class="caution">
						<li>주문상품의 부분취소는 불가합니다. 전체 주문취소 후 재구매 해주세요.</li>
						<li>비회원 주문 시 온라인 주문취소, 주문배송 조회, 상품평작성, 포인트 작동 적립 등이 제한됩니다.</li>
						<li>카드 환불은 카드사 정책에 따르며, 자세한 사항은 카드사에 문의해주세요.</li>
					</ul>
				</div>
				<h5>교환 반품</h5>
				<p>고객님의 단순 변심으로 인한 반품은 어려울 수 있으니 양해부탁드립니다.</p>
				<h6><a href="#" onclick="$('.moreText2').toggle(); return false">+ 더보기</a></h6>
				<div class="moreText2" style="display:none">
					<ul class="caution">
						<li>수령 즉시, 모든 상품의 상태를 확인해 주세요.</li>
						<li>단순 변심으로 인한 반품은 어려우며, 이에 따라 발생한 배송비는 전액 고객 부담됩니다.</li>
						<li>아래와 같은 경우 교환 및 반품이 불가합니다.
							<ul>
								<li>개인적 취향에 따른 맛, 냄새, 모양 등으로 인한 반품 불가</li>
								<li>수령인의 부재로 인해 반품되거나 상품이 훼손되었을 경우</li>
								<li>하자가 발생한 상품의 사진을 첨부하지 않은 경우</li>
								<li>문제가 발생한 상품을 임의로 폐기한 경우</li>
								<li>보관 부주의로 인해 상품 하자가 발생한 경우</li>
								<li>주문 실수 또는 수령지 주소 입력오류로 오배송 된 경우</li>
							</ul>
						</li>
						<li>상품 문제로 교환 및 반품을 하실 경우 사유, 문제가 발생한 부분을 확인할 수 있는 사진과 함께 고객센터(1522-3698) 또는 [마이페이지 > 1:1 문의하기]에 남겨주세요.
							<ul>
								<li>신선(냉장)식품 : 수령일로부터 7일 이내, 사진과 함께 1:1문의 또는 카카오톡 문의</li>
								<li>그 외 상품 : 수령일로부터 3개월 이내 또는 문제를 알 수 있었던 날로부터 30일 이내, 사진과 함께 1:1 문의</li>
							</ul>
						</li>
						<li>환불은 최초 결제 방식에 따라 진행됩니다.
							<ul>
								<li>카드 결제 시 카드 취소, 가상 계좌 입금 시 계좌 환불</li>
								<li>환불 소요시간<br>
									(1) 신용카드 : 카드사 사정에 따라 환불 접수일로부터 영업일 기준 3~7일 소요 (자세한 사항은 카드사에 문의)<br>
									(2) 가상 계좌 입금 : 고객님 계좌 정보로 영업일 기준 2~3일 내 입금<br>
									(3) 포인트 : 주문 취소 후 24시간 이내 지급
								</li>
							</ul>
						</li> 
					</ul>
				</div>
			</div><!-- //deleveryInfo -->
		</div><!-- //꼭 아셔야 해요 -->
		
		<div class="pdtQuick">				
			<form name="cartForm" id="cartForm" method="post">
				<input type="hidden" name="mode" value="CREATE" />
				<input type="hidden" name="pid" value="<%= param.get("pid") %>" />
				<input type="hidden" name="order_yn" value="N" />	
			<!-- <div class="control">
				<p class="open"><a href="#" onclick="showQuick(); return false">열기</a></p>
				<p class="close"><a href="#" onclick="hideQuick(); return false">닫기</a></p>
			</div> -->
			<div class="priceArea">
				<h2>옵션선택</h2>
				<p class="close"><a href="#" onclick="hideQuick(); return false"><img src="/mobile/images/btn/btn_close3.png" alt="닫기"></a></p>
				<h3><%= info.get("pnm") %></h3>
				<div class="countArea">
					<div class="count">
						<p class="tit"><%= !"Y".equals(info.get("routine_yn")) && optList.size() > 0 ? info.get("opt_pnm") : info.get("pnm") %></p>
<%
	if(!isAvailable) {
%>
					품절
<%
	} else {
%>
						<p class="price">
							<span><strong><%= Utils.formatMoney(info.get("sale_price")) %></strong>원</span>
<%
		if(info.getInt("default_price") > info.getInt("sale_price")) {
%>
							<strike><%= Utils.formatMoney(info.get("default_price")) %>원</strike>
<%
		}
%>				
						</p>
						<p class="countNum typeB">
							<input type="hidden" name="sub_pid" id="sub_pid_<%= info.get("pid") %>" value="<%= info.get("pid") %>" />
							<input type="hidden" name="sub_pnm" id="sub_pnm_<%= info.get("pid") %>" value="<%= info.get("pnm") %>" />
							<input type="hidden" name="default_price" id="default_price_<%= info.get("pid") %>" value="<%= info.get("default_price") %>" />
							<input type="hidden" name="sale_price" id="sale_price_<%= info.get("pid") %>" value="<%= info.get("sale_price") %>" />
							<a href="#none" onclick="setQty('down', '<%= info.get("pid") %>'); return false;"><img src="/mobile/images/btn/btn_minus2.png" alt="-"></a>
							<input type="text" name="qty_<%= info.get("pid") %>" id="qty_<%= info.get("pid") %>" value="1">
							<a href="#none" onclick="setQty('up', '<%= info.get("pid") %>'); return false;"><img src="/mobile/images/btn/btn_plus2.png" alt="+"></a>
						</p>
<%
	}
%>
					</div>
<%				
	if(!"Y".equals(info.get("routine_yn")) && optList.size() > 0) {
		for(Param row : optList) {
			isOptSoldOut = false;
			int price = row.getInt("sale_price") - info.getInt("sale_price");
			boolean b = "N".equals(row.get("sale_status")) || row.getInt("stock") == 0;
			if(b) isOptSoldOut = b;
			else isAvailable = true;
%>
					<div class="count">
						<p class="tit"><%= row.get("opt_pnm") %></p>
<%
			if(b) {
				out.println("품절");
			} else {
%>
						<p class="price">
							<span><strong><%= Utils.formatMoney(row.get("sale_price")) %></strong>원</span>
<%
				if(row.getInt("default_price") > row.getInt("sale_price")) {
%>
							<strike><%= Utils.formatMoney(row.get("default_price")) %>원</strike>
<%
				}
%>				
						</p>
						<p class="countNum typeB">
							<input type="hidden" name="sub_pid" id="sub_pid_<%= row.get("opt_pid") %>" value="<%= row.get("opt_pid") %>" />
							<input type="hidden" name="sub_pnm" id="sub_pnm_<%= row.get("opt_pid") %>" value="<%= row.get("opt_pnm") %>" />
							<input type="hidden" name="default_price" id="default_price_<%= row.get("opt_pid") %>" value="<%= row.get("default_price") %>" />
							<input type="hidden" name="sale_price" id="sale_price_<%= row.get("opt_pid") %>" value="<%= row.get("sale_price") %>" />
							<a href="#none" onclick="setQty('down', '<%= row.get("opt_pid") %>'); return false;"><img src="/mobile/images/btn/btn_minus2.png" alt="-"></a>
							<input type="text" name="qty_<%= row.get("opt_pid") %>" id="qty_<%= row.get("opt_pid") %>" value="0">
							<a href="#none" onclick="setQty('up', '<%= row.get("opt_pid") %>'); return false;"><img src="/mobile/images/btn/btn_plus2.png" alt="+"></a>
						</p>
<%
			}
%>
					</div>
<%		
		}
	}
%>
				</div><!-- countArea -->
<%
	if("D".equals(info.get("ptype"))) {
		List<Param> deliveryDateList = product.getDeliveryDateList(param.get("pid"));
%>
				<div class="deliveryDate">	
					<strong>배송일지정</strong>
					<select name="delivery_date" title="배송일 선택">
<!-- 						<option value="">배송일 선택</option> -->
<%
		for(Param row : deliveryDateList) {
%>
						<option value="<%= row.get("delivery_date") %>"><%= row.get("delivery_date") %></option>
<%
		}
%>
					</select>
				</div>
<%
	}
%>
				<p class="total">총 상품 금액 <strong><span id="total_price"><%= optList.size() > 0 ? "0" : Utils.formatMoney(info.get("sale_price")) %></span></strong>원</p>
			</div>
			<div class="btnArea">
<%
	if(!isAvailable) {
%>
				<!-- <span><a href="#none" onclick="return false" class="btnTypeA sizeL fl">품절</a></span> -->
<%
	} else {
		if("Y".equals(info.get("routine_yn"))) {
%>
				<span><a href="#none" onclick="routinePop(); return false" class="btnTypeB sizeL fl">정기구매 주기 설정을 위한 <strong>배송일 선택</strong></a></span>
<%
		} else {
%>
				<span><a href="#none" onclick="addCart('N');return false" class="btnTypeG sizeL fl">장바구니</a></span>
				<span><a href="#none" onclick="addCart('Y');return false" class="btnTypeB sizeL fl">바로구매</a></span>
<%
		}
	}
%>
				
<%
	if(isSoldOut || isOptSoldOut) {
%>					
				<span class="pdtBtn"><a href="#none" onclick="showPopupLayer('/mobile/popup/restock.jsp?pid=<%= param.get("pid") %>'); return false" class="restock">재입고알림</a></span>
<%
	} else {
%>
<!-- 				<span class="pdtBtn"><em class="restock dimmed">재입고알림</em></span> -->
<%
		if("Y".equals(info.get("routine_yn"))) {
%>
<!-- 				<span class="pdtBtn naverPay"><a href="#none" onclick="routinePop(); return false"><img src="/mobile/images/btn/btn_naverPay2.png" alt="네이버페이"></a></span> -->
<%
		} else {
%>
<!-- 				<span class="pdtBtn naverPay"><a href="#none" onclick="addCart('Y')"><img src="/mobile/images/btn/btn_naverPay2.png" alt="네이버페이"></a></span> -->
<%
		}
	}
%>
				
				
			</div>
			</form>
		</div><!-- //pdtQuick -->
<%
	if(fs.isApp() && "ios".equals(fs.getAppOS())){
%>
		<!-- <p class="back"><a href="#" onclick="history.back(); return false"><img src="/mobile/images/btn/btn_back.png" alt="뒤로"></a></p> -->
<%
	}
%>
	<!-- //내용영역 -->
	</div><!-- //container -->
	<jsp:include page="/mobile/include/footer.jsp" /> 
</div><!-- //wrapper -->
<div class="snsLayer">
	<div class="head">
		<h2>SNS공유</h2>
		<p class="close"><a href="#" onclick="hideSns(); return false"><img src="/mobile/images/btn/btn_close3.png" alt="닫기"></a></p>
	</div>
	<ul class="sns">
		<li class="kakao"><a href="#none" onclick="sendSns('kakao');return false;">카카오톡</a></li>
		<li class="facebook"><a href="#none" onclick="sendSns('facebook');return false;">페이스북</a></li>
		<li class="twitter"><a href="#none" onclick="sendSns('twitter');return false;">트위터</a></li>
	</ul>
</div>
<div class="popEarly popLayer">
	<h2><p id="popEarlyTxt">새벽배송 + 택배배송<br> 가능 지역 입니다.</p></h2>
	<p class="close"><a href="#" onclick="hideLayerPopup(this); return false"><img src="/mobile/images/btn/btn_close3.png" alt="닫기"></a></p>
	<div class="popCont">
		<div id="earlyDiv">
			<h3 class="first"><img src="/mobile/images/common/ico_early2.png" alt="">새벽 배송</h3>
			<dl>
				<dt>출고일</dt>
				<dd>주 6일 출고(일~금)</dd>
				<dt>배송일</dt>
				<dd>오후 6시까지 주문시 내일 아침 7시 전 도착</dd>
				<dt>배송지역</dt>
				<dd>서울 전역, 경기/인천 일부 지역</dd>
			</dl>
		</div>
		<h3><img src="/mobile/images/common/ico_early3.png" alt="">택배 배송</h3>
		<dl>
			<dt>출고일</dt>
			<dd>주6일 출고(일,월,화,수,목,금)</dd>
			<dt>배송일</dt>
			<dd>오후 3시까지 주문 시 다음날 도착</dd>
			<dt>배송지역</dt>
			<dd>전국, 제주 및 도서산간 지역 (배송시간은 지역마다 다를 수 있습니다)</dd>
		</dl>
	</div>	
</div><!-- //popEarly -->
<div id="layer" class="zipcodeLayer" style="display:none;-webkit-overflow-scrolling:touch;">
<h2>주소검색</h2>
<img src="/mobile/images/btn/btn_close3.png" id="btnCloseLayer" onclick="closeDaumPostcode()" alt="닫기 버튼">
</div>
<form name="earlyForm" id="earlyForm" method="post" action="">
	<input type="hidden" name="addr">
</form>
<script>
//공방장소개
var cSwiper = new Swiper($(".otherProduct .slideCont"), {
	slidesPerView: 'auto',
    spaceBetween: 10,		
	onSlideChangeEnd: function(swiper){	
		var idx = swiper.activeIndex;
	}
});
var wHeight = 0;
$(".otherProduct .slideCont li img").imgpreload(function(){
	var $this = $(this).parents("li");
	if(wHeight < $this.height()){
		wHeight = $this.height();
	}
	$(".otherProduct .slideCont li").height(wHeight);
});

setSwiper($(".pdtCate")); //스위퍼 기능 유무 셋팅
setSwiper($(".tabTypeA")); //스위퍼 기능 유무 셋팅
if(!$(".pdtCate").find(".swiper-wrapper").hasClass("noSwiper")){
	var pSwiper = new Swiper($(".pdtCate"), {
		slidesPerView: 'auto',
		onSlideChangeEnd: function(swiper){	
			var idx = swiper.activeIndex;
		}
	});
	$(".pdtCate").find(".swiper-slide").each(function(){
		if($(this).hasClass("on")){
			pSwiper.slideTo($(this).index(), 0);			
		}
	});
}
if(!$(".tabTypeA").find(".swiper-wrapper").hasClass("noSwiper")){
	var cSwiper = new Swiper($(".tabTypeA"), {
		slidesPerView: 'auto',
		onSlideChangeEnd: function(swiper){	
			var idx = swiper.activeIndex;
		}
	});
	$(".tabTypeA").find(".swiper-slide").each(function(){
		if($(this).hasClass("on")){
			cSwiper.slideTo($(this).index(), 0);			
		}
	});
}
$(".thumbArea ul li").on("click", function(){
	var obj = $(this).find("img").clone();
	$(this).parents(".thumbArea").find(".thumb").empty().append(obj);
});
function showQuick(){
	//$(".control .open").hide().siblings().show();
	$(".pdtQuick .priceArea").slideDown(150, "easeInOutQuint");	
}
function hideQuick(){
	//$(".control .close").hide().siblings().show();
	//$(".pdtQuick .priceArea").slideUp(100, "easeInOutQuint");
	$(".pdtQuick .priceArea").hide();
}

var tTop;
var sec = ["#pdtDetail1", "#pdtDetail2", "#pdtDetail3", "#pdtDetail4"];
var cutline, j;
var clickNav = false;
var pdtCateHeight= $(".pdtCate").height() ? parseInt($(".pdtCate").height()) : 0
tTop = $(".tabArea").offset().top - parseInt($("#header").height()) - pdtCateHeight;
setTab();
$(window).on("scroll", function(){
	if(clickNav == false){
		setTab();
	}
});
function setTab(){
	if(tTop <= $(window).scrollTop()){
		$(".tabArea").addClass("fix");
	} else {
		$(".tabArea").removeClass("fix");
	}
		
	cutline = $(window).scrollTop() + $(".tabTypeB").height() + parseInt($("#header").height()) + pdtCateHeight + 10;
	if($(sec[0]).offset().top <= cutline){
		for(var i = 0; i < $(sec).length; i++){
			if($(sec[i]).offset().top <= cutline){
				j = i;
			} 
		}
		$(".tabArea li:eq("+ j +")").addClass("on").siblings().removeClass("on");
	}
}
function goFloatingTab(obj){
	clickNav = true;
	var idx = $(obj).parent().index();
	var sTop = $(sec[idx]).offset().top - parseInt($(".tabArea").height()) - parseInt($("#header").height()) - pdtCateHeight + 1;
	$("html, body").stop().animate({scrollTop:sTop}, 300, "easeInOutQuint", function(){
		clickNav = false;
		if(tTop <= $(window).scrollTop()){
			$(".tabArea").addClass("fix");
		} else {
			$(".tabArea").removeClass("fix");
		}
	});
	$(obj).parent().addClass("on").siblings().removeClass("on");
}

function checkEarly() {
// 	console.log($("#earlyForm input[name=addr]").val());
	$.ajax({
		type: "POST",
		url : "/api/searchDeliveryArea.jsp",
		data : $("#earlyForm").serialize(),
		cache: false,
		dataType : "json"
	})
	.done(function(json) {
		console.log(json);
		if(json.resultCode == '0000') {
			if(json.result.delyverYn == '1') {
				$("#earlyDiv").show();
				$(".popEarly h3").removeClass("first");
				$("#earlyDiv h3").addClass("first");
				$("#popEarlyTxt").html("새벽배송 + 택배배송<br> 가능 지역 입니다.");
			} else {
				$("#earlyDiv").hide();
				$(".popEarly h3").addClass("first");
				$("#popEarlyTxt").html("택배배송<br> 가능 지역 입니다.");
			}
			showLayerPopup('.popEarly', 'setTop');
		} else {
			alert("새벽 배송 가능지역 확인중 오류가 발생했습니다.");
		}
	});
}
</script>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    // 우편번호 찾기 화면을 넣을 element
    var element_layer = document.getElementById('layer');

    function closeDaumPostcode() {
        // iframe을 넣은 element를 안보이게 한다.
        $(".bgLayer").hide();
        element_layer.style.display = 'none';
    }

    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                var addr = ''; // 주소 변수
                addr = data.roadAddress;
                $("#earlyForm input[name=addr]").val(addr);
				checkEarly();
				
                element_layer.style.display = 'none';
            },
            width : '100%',
            height : '100%',
            maxSuggestItems : 5
        }).embed(element_layer);

        // iframe을 넣은 element를 보이게 한다.
        $(".bgLayer").css("height", $(document).height() + "px").show();
        element_layer.style.display = 'block';

        // iframe을 넣은 element의 위치를 화면의 가운데로 이동시킨다.
        initLayerPosition();
    }

    // 브라우저의 크기 변경에 따라 레이어를 가운데로 이동시키고자 하실때에는
    // resize이벤트나, orientationchange이벤트를 이용하여 값이 변경될때마다 아래 함수를 실행 시켜 주시거나,
    // 직접 element_layer의 top,left값을 수정해 주시면 됩니다.
    function initLayerPosition(){
        /* var width = 300; //우편번호서비스가 들어갈 element의 width
        var height = 400; //우편번호서비스가 들어갈 element의 height
        var borderWidth = 5; //샘플에서 사용하는 border의 두께

        // 위에서 선언한 값들을 실제 element에 넣는다.
        element_layer.style.width = width + 'px';
        element_layer.style.height = height + 'px';
        element_layer.style.border = borderWidth + 'px solid';
        // 실행되는 순간의 화면 너비와 높이 값을 가져와서 중앙에 뜰 수 있도록 위치를 계산한다.
        element_layer.style.left = (((window.innerWidth || document.documentElement.clientWidth) - width)/2 - borderWidth) + 'px';
        element_layer.style.top = (((window.innerHeight || document.documentElement.clientHeight) - height)/2 - borderWidth) + 'px'; */
    	if(element_layer.clientHeight > ((window.innerHeight || document.documentElement.clientHeight) - 20)){
    		element_layer.style.height = (window.innerHeight || document.documentElement.clientHeight) - 20 + 'px'
    		element_layer.style.marginTop = '-' + (parseInt(element_layer.style.height) / 2) + 'px'
    	}

        
    }
</script>

</body>
</html>