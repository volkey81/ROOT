<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.common.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*" %>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="imagetoolbar" content="no">
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">
        <meta name="viewport" content="width=device-width, initial-scale=1,user-scalable=no">
        <meta name="title" content="">
        <meta name="publisher" content="">
        <meta name="author" content="">
        <meta name="robots" content="index,follow">
        <meta name="keywords" content="">
        <meta name="description" content="">
        <meta name="twitter:card" content="summary_large_image">
        <meta property="og:title" content="">
        <meta property="og:site_name" content="">
        <meta property="og:author" content="">
        <meta property="og:type" content="">
        <meta property="og:description" content="">
        <meta property="og:url" content="">
        <title>상하목장</title>
        <!--[if lte IE 8]>
        <script src="http://carvecat.com/js/html5.js"></script>
        <![endif]-->

        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link rel="stylesheet" href="./css/reset.css">
        <link rel="stylesheet" href="./css/new_common.css">
        <link rel="stylesheet" href="./css/main_style.css">

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
        <!-- <script src="./js/main.js"></script> -->
        <script src="./js/full-page-scroll.js"></script>
        
        <link rel="stylesheet" href="http://code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" type="text/css" />
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
        <script src="http://code.jquery.com/ui/1.8.18/jquery-ui.min.js"></script>
        
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
        <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
    </head>
    <body>
        <!-- 전체 메뉴 START -->
        <div class="popup_g popup_allmenu">
            <div id="allMenu" class="popup_wrap">
                <div class="popup_header">
                    <a href="/brand/index.jsp" class="allmenu_logo"><span class="g_alt">상하농원</span></a>
                    <button type="button" onClick="popupClose()" class="btn_close">닫기</button>
                </div>
                <div class="popup_body">
                    <ul class="allmenu_tab">
                        <li id="tab1" class="tabContent_wrap">
                            <input type="radio" checked name="allmenu" id="tabMenu1">
                            <label for="tabMenu1">고창, 상하농원</label>
                            <div class="tabContent_item">
                                <div class="tabContent_title">
                                    <p>고창의 아름다운 자연환경을 기반으로 <br/>행복한 동물들과 교감 체험이 가득한 테마공원</p>
                                    <b>고창, 상하농원</b>
                                </div>
                                <div class="groupMenu_title">농원소개</div>
                                <ul class="groupMenu_list">
                                    <li><a href="/brand/introduce/story.jsp">상하농원은</a></li>
                                    <li><a href="/brand/introduce/guide.jsp">이용안내</a></li>
                                    <li><a href="/brand/introduce/tour.jsp">주변관광</a></li>
                                    <li><a href="/brand/introduce/history.jsp">걸어온길</a></li>
                                    <li><a href="/brand/introduce/facility.jsp">시설소개</a></li>
                                    <li><a href="/brand/introduce/location.jsp">오시는길</a></li>
                                </ul>
                                <div class="groupMenu_title">짓다</div>
                                <ul class="groupMenu_list">
                                    <li><a href="/brand/workshop/ham.jsp">햄공방</a></li>
                                    <li><a href="/brand/workshop/fruit.jsp">과일공방</a></li>
                                    <li><a href="/brand/workshop/bread.jsp">빵공방</a></li>
                                    <li><a href="/brand/workshop/ferment.jsp">발효공방</a></li>
                                    <li><a href="/brand/workshop/oil.jsp">참기름공방</a></li>
                                    <li><a href="/brand/workshop/cheese.jsp">치즈공방</a></li>
                                </ul>
                                <div class="groupMenu_title">놀다</div>
                                <ul class="groupMenu_list">
                                    <li><a href="/brand/play/gallery.jsp">전시관</a></li>
                                    <li><a href="/brand/play/experience/list.jsp">체험교실</a></li>
                                    <li><a href="/brand/play/animal.jsp">동물농장</a></li>
                                    <li><a href="/brand/play/sheep.jsp">양떼목장</a></li>
                                    <li><a href="/brand/play/organic.jsp">젖소목장</a></li>
                                    <li><a href="/brand/play/farm.jsp">스마트팜</a></li>
                                    <li><a href="/brand/play/hotel.jsp">파머스빌리지</a></li>
                                </ul>
                                <div class="groupMenu_title">먹다</div>
                                <ul class="groupMenu_list">
                                    <li><a href="/brand/food/store1.jsp">상하키친</a></li>
                                    <li><a href="/brand/food/store2.jsp">농원식당</a></li>
                                    <li><a href="/brand/food/store3.jsp">파머스카페 상하</a></li>
                                    <li><a href="/brand/food/store5.jsp">파머스마켓</a></li>
                                </ul>
                                <div class="groupMenu_title">농원이야기</div>
                                <ul class="groupMenu_list">
                                    <li><a href="/brand/bbs/news/list.jsp">농원소식</a></li>
                                    <li><a href="/brand/bbs/diary/list.jsp">농부의일기</a></li>
                                    <li><a href="/brand/bbs/notice/list.jsp">공지사항</a></li>
                                </ul>
                            </div>
                        </li>
                        <li id="tab2" class="tabContent_wrap">
                            <input type="radio" name="allmenu" id="tabMenu2">
                            <label for="tabMenu2">파머스 빌리지</label>
                            <div class="tabContent_item">
                                <div class="tabContent_title">
                                    <p>여유를 즐길 수 있는 글램핑과 <br/>SNS에 올리기 좋은 감각적인 프리미엄 객실예약</p>
                                    <b>파머스 빌리지</b>
                                </div>
                                <div class="groupMenu_title">예약</div>
                                <ul class="groupMenu_list">
                                    <li><a href="/hotel/room/index.jsp">객실</a></li>
                                    <li><a href="/hotel/offer/list.jsp">스페셜오퍼</a></li>
                                    <li><a href="/brand/play/experience/list.jsp">입장&체험</a></li>
                                </ul>
                                <div class="groupMenu_title">객실예약</div>
                                <ul class="groupMenu_list">
                                    <li><a href="/hotel/room/index.jsp">전체보기</a></li>
                                    <li><a href="/hotel/room/suite.jsp">파머스빌리지</a></li>
                                    <li><a href="/hotel/room/glamping.jsp">파머스글램핑</a></li>
                                    <li><a href="/hotel/room/reservation/date.jsp">예약하기</a></li>
                                </ul>
                                <div class="groupMenu_title">다이닝</div>
                                <ul class="groupMenu_list">
                                    <li><a href="/hotel/dining/breakfast.jsp">파머스테이블</a></li>
                                    <li><a href="/hotel/dining/lounge.jsp">웰컴라운지</a></li>
                                    <li><a href="/hotel/dining/restaurant.jsp">농원식당</a></li>
                                    <li><a href="/hotel/dining/kitchen.jsp">상하키친</a></li>
                                </ul>
                                <div class="groupMenu_title">스페셜오퍼</div>
                                <ul class="groupMenu_list">
                                    <li><a href="/hotel/offer/list.jsp">Weekly특가</a></li>
                                    <li><a href="/hotel/offer/list.jsp?gubun=P">패키지</a></li>
                                    <li><a href="/hotel/village/promotion/list.jsp">프로모션</a></li>
                                </ul>
                                <div class="groupMenu_title">웨딩&세미나</div>
                                <ul class="groupMenu_list">
                                    <li><a href="/hotel/wedding/wedding.jsp">웨딩&연회</a></li>
                                    <li><a href="/hotel/wedding/seminar.jsp">세미나</a></li>
                                </ul>
                                <div class="groupMenu_title">즐길거리</div>
                                <ul class="groupMenu_list">
                                    <li><a href="/hotel/enjoy/farm.jsp">상하농원</a></li>
                                    <li><a href="/hotel/enjoy/spa.jsp">노천스파</a></li>
                                    <li><a href="/hotel/enjoy/pool.jsp">수영장</a></li>
                                    <li><a href="/hotel/enjoy/healthcare.jsp">셀렉스헬스케어</a></li>
                                    <li><a href="/hotel/enjoy/campaign.jsp">에코기부참여</a></li>
                                </ul>
                                <div class="groupMenu_title">빌리지소개</div>
                                <ul class="groupMenu_list">
                                    <li><a href="/hotel/village/introduction.jsp">소개</a></li>
                                    <li><a href="/hotel/village/location.jsp">오시는길</a></li>
                                    <li><a href="/hotel/village/notice/list.jsp">문의사항</a></li>
                                </ul>
                            </div>
                        </li>
                        <li id="tab3" class="tabContent_wrap">
                            <input type="radio" name="allmenu" id="tabMenu3">
                            <label for="tabMenu3">파머스 마켓</label>
                            <div class="tabContent_item">
                                <div class="tabContent_title">
                                    <p>자연이 주는 선물과 상하농원 농부들의 정성으로 <br/>만들어진 친환경 먹거리</p>
                                    <b>파머스 마켓</b>
                                </div>
                                <div class="groupMenu_title">전체 카테고리</div>
                                <ul class="groupMenu_list col3">
                                    <li><a href="/product/list.jsp?cate_seq=150">선물세트</a></li>
                                    <li><a href="/product/list.jsp?cate_seq=118">상하브랜드관</a></li>
                                    <li><a href="/product/list.jsp?cate_seq=160">상하파머스</a></li>
                                    <li><a href="/product/list.jsp?cate_seq=120">로컬푸드</a></li>
                                    <li><a href="/product/list.jsp?cate_seq=119">친환경</a></li>
                                    <li><a href="/product/list.jsp?cate_seq=128">정기배송</a></li>
                                    <li><a href="/product/list.jsp?cate_seq=166">국내산 과일</a></li>
                                    <li><a href="/product/list.jsp?cate_seq=79">계란/정육/유제품</a></li>
                                    <li><a href="/product/list.jsp?cate_seq=80">수산물</a></li>
                                    <li><a href="/product/list.jsp?cate_seq=81">국/반찬/요리</a></li>
                                    <li><a href="/product/list.jsp?cate_seq=82">간편식/식사대용식</a></li>
                                    <li><a href="/product/list.jsp?cate_seq=136">음료/건강</a></li>
                                    <li><a href="/product/list.jsp?cate_seq=83">요리양념/파우더류</a></li>
                                    <li><a href="/product/list.jsp?cate_seq=137">간식/과자</a></li>
                                    <li><a href="/product/list.jsp?cate_seq=163">쌀/잡곡</a></li>
                                    <li><a href="/product/list.jsp?cate_seq=141">건강/선식</a></li>
                                </ul>
                                <div class="groupMenu_title"><a href="/product/list.jsp?cate_seq=118">상하 브랜드관</a></div>
                                <ul class="groupMenu_list">
                                </ul>
                                <div class="groupMenu_title"><a href="/product/list.jsp?sort=date">신상품</a></div>
                                <ul class="groupMenu_list">
                                </ul>
                                <div class="groupMenu_title"><a href="/product/best.jsp">베스트</a></div>
                                <ul class="groupMenu_list">
                                </ul>
                                <div class="groupMenu_title"><a href="/product/list.jsp?cate_seq=38">알뜰상품</a></div>
                                <ul class="groupMenu_list">
                                </ul>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
        <!-- 전체 메뉴 END -->
        
        <div class="body_wrap" id="main">
            <section class="section_wrap pc_section" data-index="1">
                <div class="header_wrap">
                    <a href="/index2.jsp" class="gnb_logo"><span class="g_alt">상하농원</span></a>
                    <!-- 24.03.14 add button -->
                    <button type="button" onClick="popupOpen('allMenu')" class="btn_allmenu mo_only"><span class="g_alt">전체메뉴</span></button>
                    <div class="gnb_menu">
                        <a href="/index2.jsp">상하농원</a>
                        <a href="/brand/play/reservation/RE_SE_0002.jsp">체험활동</a>
                        <a href="/hotel/index.jsp">객실예약</a>
                        <a href="/main.jsp">쇼핑하기</a>
                        <button type="button" onClick="popupOpen('allMenu')" class="icn_allmenu pc_only">전체메뉴</button>
                    </div>
                </div>
                <div class="main_float">
                    <!-- 24.02.28 Modify span > 텍스트 -->
                    <a href="/index2.jsp" class="btn_1 active"><span>상하농원</span></a>
                    <a href="/brand/play/reservation/RE_SE_0002.jsp" class="btn_2"><span>체험활동</span></a>
                    <a href="/hotel/room/index.jsp" class="btn_3"><span>객실예약</span></a>
                    <a href="/main.jsp" class="btn_4"><span>쇼핑하기</span></a>
                </div>
                <div class="reserve_wrap">
                    <p class="reserve_info"><a href="/hotel/index.jsp" target="_self">빌리지 정보</a></p>
                    <form id="reservationForm" action="/hotel/room/reservation/room.jsp" class="reserve" method="POST">
                        <div class="notice"><span class="fs14 fcGray">HOTEL</span><br/>파머스빌리지</div>
                        <div class="date">
                            <div class="checkinout">
                                <span class="areatitle">체크인</span>
                                <p class="areainput">
                                    <input type="text" id="checkin" name="checkin">
                                </p>
                            </div>
                            <div class="checkinout">
                                <span class="areatitle">체크아웃</span>
                                <p class="areainput">
                                    <input type="text" id="checkout" name="checkout">
                                </p>
                            </div>
                        </div>
                        <div class="room">
                            <span class="areatitle">객실</span>
                            <p class="areainput"><em>1</em></p>
                        </div>
                        <div class="adult">
                            <span class="areatitle">성인</span>
                            <div class="areainput">
                                <select name="adults" id="adults" class="main_select">
                                    <option value="1">1</option>
                                    <option value="2" selected>2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                </select>
                            </div>
                        </div>
                        <div class="child">
                            <span class="areatitle">소인</span>
                            <div class="areainput">
                                <select name="children" id="children" class="main_select">
                                	<option value="0">0</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                </select>
                            </div>
                        </div>
                        <div><button type="submit" class="btn_reserve">예약하기</button></div>
                    </form>
                </div>
                <div class="swiper sec01">
                    <div class="swiper-wrapper">
                        <div class="swiper-slide sec01_01">
                            <div class="title_wrap">
                                <div class="subtitle">
                                    <span>짓다 ∙ 놀다 ∙ 먹다</span>
                                </div>
                                <div class="title">
                                    <span>상하농원</span>
                                </div>
                            </div>
                        </div>
                        <div class="swiper-slide sec01_02">
                            <div class="title_wrap">
                                <div class="subtitle">
                                    <span>여유로운 라운딩과 힐링을 동시에</span>
                                </div>
                                <div class="title">
                                    <span>골프패키지</span>
                                </div>
                            </div>
                        </div>
                        <div class="swiper-slide sec01_03">
                            <div class="title_wrap">
                                <div class="subtitle">
                                    <span>자연 속 고즈넉한 농부의 쉼터</span>
                                </div>
                                <div class="title">
                                    <span>파머스빌리지</span>
                                </div>
                            </div>
                        </div>
                        <div class="swiper-slide sec01_04">
                            <div class="title_wrap">
                                <div class="subtitle">
                                    <span>건강한 먹거리를 즐기는</span>
                                </div>
                                <div class="title">
                                    <span>체험교실</span>
                                </div>
                            </div>
                        </div>
                        <div class="swiper-slide sec01_05">
                            <div class="title_wrap">
                                <div class="subtitle">
                                    <span>자연 속에서 만나는 휴식</span>
                                </div>
                                <div class="title">
                                    <span>파머스빌리지 수영장</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- 24.03.13 add START -->
                    <div class="swiper-button-prev"></div>
                    <div class="swiper-button-next"></div>
                    <!-- 24.03.13 add END -->
                    <!-- 24.03.14 add -->
                    <div class="swiper-pagination"></div>
                </div>
                <script>
	                var swiper1 = new Swiper(".sec01", {
	                    pagination: {
	                        clickable: true,
	                        el: ".swiper-pagination",
	                        type: "fraction",
	                    },
	                    navigation: {
	                        nextEl: '.swiper-button-next',
	                        prevEl: '.swiper-button-prev',
	                    },
	                    autoplay: {
	                        delay: 3000,
	                        disableOnInteraction: false,
	                    },
	                });
                </script>
            </section>
            <section class="section_wrap pc_section section_product" data-index="6">
                <div class="product_wrap">
                    <div class="swiper sec06">
                        <div class="left_wrap">
                            <p class="left_title">파머스마켓</p>
                            <div class="swiper-pagination"></div>
                            <a href="main.jsp" target="_blank" class="left_btn pc_only">상품더보기</a>
                        </div>
                        <div class="swiper-wrapper">
                            <div class="swiper-slide">
                                <a href="" class="product_item">
                                    <p class="product_img"><img src="./image/sec6_pro_01.png" alt=""></p>
                                    <div class="product_info">
                                        <span class="info_text">건강한 닭이 낳은</span>
                                        <p class="info_name">노른자가 진하고 맛있는 1+등급란 10구</p>
                                        <p class="info_price"><em>5,980</em>원</p>
                                    </div>
                                </a>
                                <a href="" class="product_item">
                                    <p class="product_img"><img src="./image/sec6_pro_02.png" alt=""></p>
                                    <div class="product_info">
                                        <span class="info_text">국산 오징어의 쫄깃한 식감과 단맛</span>
                                        <p class="info_name">상하농원 오징어젓 2종</p>
                                        <p class="info_price"><em>7,500</em>원</p>
                                    </div>
                                </a>
                                <a href="" class="product_item">
                                    <p class="product_img"><img src="./image/sec6_pro_03.png" alt=""></p>
                                    <div class="product_info">
                                        <span class="info_text">딸기의 맛과 향을 그대로 담은 상하농원 딸기잼</span>
                                        <p class="info_name">상하농원 딸기잼 150g</p>
                                        <p class="info_price"><em>7,200</em>원</p>
                                    </div>
                                </a>
                                <a href="" class="product_item">
                                    <p class="product_img"><img src="./image/sec6_pro_04.png" alt=""></p>
                                    <div class="product_info">
                                        <span class="info_text">옛 방식 그대로 우리 햅쌀을 담은</span>
                                        <p class="info_name">상하농원 우리쌀 식혜 500ml</p>
                                        <p class="info_price"><em>3,000</em>원</p>
                                    </div>
                                </a>
                            </div>
                            <div class="swiper-slide">
                                <a href="" class="product_item">
                                    <p class="product_img"><img src="./image/sec6_pro_02.png" alt=""></p>
                                    <div class="product_info">
                                        <span class="info_text">건강한 닭이 낳은</span>
                                        <p class="info_name">노른자가 진하고 맛있는 1+등급란 10구</p>
                                        <p class="info_price"><em>5,980</em>원</p>
                                    </div>
                                </a>
                                <a href="" class="product_item">
                                    <p class="product_img"><img src="./image/sec6_pro_03.png" alt=""></p>
                                    <div class="product_info">
                                        <span class="info_text">건강한 닭이 낳은</span>
                                        <p class="info_name">노른자가 진하고 맛있는 1+등급란 10구</p>
                                        <p class="info_price"><em>5,980</em>원</p>
                                    </div>
                                </a>
                                <a href="" class="product_item">
                                    <p class="product_img"><img src="./image/sec6_pro_04.png" alt=""></p>
                                    <div class="product_info">
                                        <span class="info_text">건강한 닭이 낳은</span>
                                        <p class="info_name">노른자가 진하고 맛있는 1+등급란 10구</p>
                                        <p class="info_price"><em>5,980</em>원</p>
                                    </div>
                                </a>
                                <a href="" class="product_item">
                                    <p class="product_img"><img src="./image/sec6_pro_01.png" alt=""></p>
                                    <div class="product_info">
                                        <span class="info_text">건강한 닭이 낳은</span>
                                        <p class="info_name">노른자가 진하고 맛있는 1+등급란 10구</p>
                                        <p class="info_price"><em>5,980</em>원</p>
                                    </div>
                                </a>
                            </div>
                            <div class="swiper-slide">
                                <a href="" class="product_item">
                                    <p class="product_img"><img src="./image/sec6_pro_03.png" alt=""></p>
                                    <div class="product_info">
                                        <span class="info_text">건강한 닭이 낳은</span>
                                        <p class="info_name">노른자가 진하고 맛있는 1+등급란 10구</p>
                                        <p class="info_price"><em>5,980</em>원</p>
                                    </div>
                                </a>
                                <a href="" class="product_item">
                                    <p class="product_img"><img src="./image/sec6_pro_04.png" alt=""></p>
                                    <div class="product_info">
                                        <span class="info_text">건강한 닭이 낳은</span>
                                        <p class="info_name">노른자가 진하고 맛있는 1+등급란 10구</p>
                                        <p class="info_price"><em>5,980</em>원</p>
                                    </div>
                                </a>
                                <a href="" class="product_item">
                                    <p class="product_img"><img src="./image/sec6_pro_01.png" alt=""></p>
                                    <div class="product_info">
                                        <span class="info_text">건강한 닭이 낳은</span>
                                        <p class="info_name">노른자가 진하고 맛있는 1+등급란 10구</p>
                                        <p class="info_price"><em>5,980</em>원</p>
                                    </div>
                                </a>
                                <a href="" class="product_item">
                                    <p class="product_img"><img src="./image/sec6_pro_02.png" alt=""></p>
                                    <div class="product_info">
                                        <span class="info_text">건강한 닭이 낳은</span>
                                        <p class="info_name">노른자가 진하고 맛있는 1+등급란 10구</p>
                                        <p class="info_price"><em>5,980</em>원</p>
                                    </div>
                                </a>
                            </div>
                            <div class="swiper-slide">
                                <a href="" class="product_item">
                                    <p class="product_img"><img src="./image/sec6_pro_04.png" alt=""></p>
                                    <div class="product_info">
                                        <span class="info_text">건강한 닭이 낳은</span>
                                        <p class="info_name">노른자가 진하고 맛있는 1+등급란 10구</p>
                                        <p class="info_price"><em>5,980</em>원</p>
                                    </div>
                                </a>
                                <a href="" class="product_item">
                                    <p class="product_img"><img src="./image/sec6_pro_01.png" alt=""></p>
                                    <div class="product_info">
                                        <span class="info_text">건강한 닭이 낳은</span>
                                        <p class="info_name">노른자가 진하고 맛있는 1+등급란 10구</p>
                                        <p class="info_price"><em>5,980</em>원</p>
                                    </div>
                                </a>
                                <a href="" class="product_item">
                                    <p class="product_img"><img src="./image/sec6_pro_02.png" alt=""></p>
                                    <div class="product_info">
                                        <span class="info_text">건강한 닭이 낳은</span>
                                        <p class="info_name">노른자가 진하고 맛있는 1+등급란 10구</p>
                                        <p class="info_price"><em>5,980</em>원</p>
                                    </div>
                                </a>
                                <a href="" class="product_item">
                                    <p class="product_img"><img src="./image/sec6_pro_03.png" alt=""></p>
                                    <div class="product_info">
                                        <span class="info_text">건강한 닭이 낳은</span>
                                        <p class="info_name">노른자가 진하고 맛있는 1+등급란 10구</p>
                                        <p class="info_price"><em>5,980</em>원</p>
                                    </div>
                                </a>
                            </div>
                            <div class="swiper-slide">
                                <a href="" class="product_item">
                                    <p class="product_img"><img src="./image/sec6_pro_01.png" alt=""></p>
                                    <div class="product_info">
                                        <span class="info_text">건강한 닭이 낳은</span>
                                        <p class="info_name">노른자가 진하고 맛있는 1+등급란 10구</p>
                                        <p class="info_price"><em>5,980</em>원</p>
                                    </div>
                                </a>
                                <a href="" class="product_item">
                                    <p class="product_img"><img src="./image/sec6_pro_02.png" alt=""></p>
                                    <div class="product_info">
                                        <span class="info_text">건강한 닭이 낳은</span>
                                        <p class="info_name">노른자가 진하고 맛있는 1+등급란 10구</p>
                                        <p class="info_price"><em>5,980</em>원</p>
                                    </div>
                                </a>
                                <a href="" class="product_item">
                                    <p class="product_img"><img src="./image/sec6_pro_03.png" alt=""></p>
                                    <div class="product_info">
                                        <span class="info_text">건강한 닭이 낳은</span>
                                        <p class="info_name">노른자가 진하고 맛있는 1+등급란 10구</p>
                                        <p class="info_price"><em>5,980</em>원</p>
                                    </div>
                                </a>
                                <a href="" class="product_item">
                                    <p class="product_img"><img src="./image/sec6_pro_04.png" alt=""></p>
                                    <div class="product_info">
                                        <span class="info_text">건강한 닭이 낳은</span>
                                        <p class="info_name">노른자가 진하고 맛있는 1+등급란 10구</p>
                                        <p class="info_price"><em>5,980</em>원</p>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </div>
                    <script>
                        var sec6_tabname = ['상하브랜드관','신상품','베스트','알뜰상품','상하파머스'];
                        var swiper6 = new Swiper(".sec06", {
                            direction: "vertical",
                            pagination: {
                                el: ".swiper-pagination",
                                clickable: true,
                                renderBullet: function (index, className) {
                                return '<span class="' + className + '">' + (sec6_tabname[index]) + "</span>";
                                },
                            },
                        });
                    </script>
                </div>
                <div class="product_wrap">
                    <!-- 24.03.13 add : a tag / add link -->
                    <a href="/main.jsp" target="_blank" class="left_btn mo_only mb50">상품더보기</a>
                    <!-- 24.03.13 add link -->
                    <a href="/product/list.jsp?cate_seq=128" target="_self" class="banner_wrap">
                        <img src="./image/sec6_banner.png" class="pc_only" alt="">
                        <img src="./image/sec6_banner_mo.png" class="mo_only" alt="">
                    </a>
                </div>
            </section>
            <section class="section_wrap pc_section section_promotion" data-index="3">
                <div class="section_title">
                    <b>이벤트와 프로모션</b>
                    <span>365일 풍성한 이벤트와 프로모션을 알려드려요!</span>
                </div>
                <div class="flex_wrap">
                    <div class="fix_content flex_wrap">
                        <div class="sec3_con">
                            <!-- 24.03.13 add link -->
                            <a href="/brand/bbs/news/view.jsp?seq=369" target="_self" class="con_img"><img src="./image/sec3_con_01.png" alt=""></a>
                            <!-- 24.03.13 add link -->
                            <a href="/brand/bbs/news/view.jsp?seq=369" target="_self" class="con_title">
                                <b>상하의 숲</b>
                                <span>팽나무 가득한 숲속나들이 즐기기</span>
                            </a>
                        </div>
                        <div class="sec3_con">
                            <!-- 24.03.13 add link -->
                            <a href="/event/view.jsp?seq=362&type=view" target="_self" class="con_img"><img src="./image/sec3_con_02.png" alt=""></a>
                            <!-- 24.03.13 add link -->
                            <a href="/event/view.jsp?seq=362&type=view" target="_self" class="con_title">
                                <b>상하농원 계란 이야기 </b>
                                <span>건강한 닭이 낳은 건강한 계란</span>
                            </a>
                        </div>
                    </div>
                    <div class="swiper sec03">
                        <div class="swiper-pagination"></div>
                        <div class="swiper-wrapper">
                            <div class="swiper-slide">
                                <div class="slide_content slide01">
                                    <div class="slide_subject">
                                        <b class="subject_title">상하농원 달력 +<br>상하농원의 1년 몰아보기!</b>
                                    </div>
                                    <img src="./image/sec3_slide_01.png" alt="">
                                    <a href="/brand/bbs/news/view.jsp?seq=367" class="slide_btn">자세히 보기</a>
                                </div>
                            </div>
                            <div class="swiper-slide">
                                <div class="slide_content slide02">
                                    <div class="slide_subject">
                                        <b class="subject_title">자연을 오감으로 느끼는<br>먹거리 만들기 체험</b>
                                    </div>
                                    <img src="./image/sec3_slide_02.png" alt="">
                                    <a href="/brand/bbs/news/view.jsp?seq=367" class="slide_btn">자세히 보기</a>
                                </div>
                            </div>
                            <div class="swiper-slide">
                                <div class="slide_content slide03">
                                    <div class="slide_subject">
                                        <b class="subject_title">파머스빌리지에서 준비한<br>특별한 프로모션</b>
                                    </div>
                                    <img src="./image/sec3_slide_03.png" alt="">
                                    <a href="/brand/bbs/news/view.jsp?seq=367" class="slide_btn">자세히 보기</a>
                                </div>
                            </div>
                            <div class="swiper-slide">
                                <div class="slide_content slide04">
                                    <div class="slide_subject">
                                        <b class="subject_title">신선한 우유와 치즈가<br>만들어지는 현장</b>
                                    </div>
                                    <img src="./image/sec3_slide_04.png" alt="">
                                    <a href="/brand/play/experience/view.jsp?seq=3" class="slide_btn">자세히 보기</a>
                                </div>
                            </div>
                        </div>
                        <div class="swiper-button-prev"></div>
                        <div class="swiper-button-next"></div>
                    </div>
                </div>
                <script>
	                var sec3_tabname = ['연간캘린더','체험교실','빌리지 프로모션','공장견학'];
	                var swiper3 = new Swiper(".sec03", {
	                    pagination: {
	                        el: ".swiper-pagination",
	                        clickable: true,
	                        renderBullet: function (index, className) {
	                        return '<span class="' + className + '">' + (sec3_tabname[index]) + "</span>";
	                        },
	                        navigation: {
	                            nextEl: '.swiper-button-next',
	                            prevEl: '.swiper-button-prev',
	                        },
	                    },
	                });
                </script>
            </section>
            <section class="section_wrap pc_section section_story" data-index="4">
                <div class="section_title">
                    <b>소중한 사람들과 상하농원에서</b>
                    <span>아름다운 추억을 만들어 보세요</span>
                </div>
                <div class="flex_wrap">
                    <div class="swiper sec04">
                        <div class="swiper-pagination"></div>
                        <div class="swiper-wrapper">
                            <div class="swiper-slide">
                            	<a href="/hotel/wedding/wedding.jsp" target="_self" class="inB"><img src="./image/sec4_slide_01.png" alt=""></a>
                            </div>
                            <div class="swiper-slide">
                                <a href="/hotel/wedding/seminar.jsp" target="_self" class="inB"><img src="./image/sec4_slide_02.png" alt=""></a>
                            </div>
                            <div class="swiper-slide">
                                <a href="/hotel/enjoy/spa.jsp" target="_self" class="inB"><img src="./image/sec4_slide_03.png" alt=""></a>
                            </div>
                            <div class="swiper-slide">
                                <a href="/hotel/enjoy/pool.jsp" target="_self" class="inB"><img src="./image/sec4_slide_04.png" alt=""></a>
                            </div>
                        </div>
                    </div>
                    <div class="swiper_content">
                    	<a id="sec4_link" href="/hotel/wedding/wedding.jsp" target="_blank" class="inB">
                        	<img id="sec4_imgS" src="./image/sec4_slide_01_s.png" alt="">
                        </a>
                        <p id="sec4_con">아름답게 새 출발하는 결혼식, 가족의 특별한 모임<br>소중한 순간을 함께 하겠습니다</p>
                        <a href="https://pf.kakao.com/_GtCKb/chat" class="btn_kakao inB" target="_blank" class="btn_kakao inB">궁금하신 게 있으신가요? <br>카카오톡 문의하기로 이어집니다</a>
                    </div>
                </div>
                <script>
                    var sec4_tabname = ['웨딩&연회','세미나/워크숍','노천스파','수영장'];
                    var sec4_content = ['아름답게 새 출발하는 결혼식, 가족의 특별한 모임<br>소중한 순간을 함께 하겠습니다','답답한 도심을 벗어나 자연속에서 편안한 세미나를<br>진행할 수 있도록 정성을 다해 준비하겠습니다','자연과 하나되어 즐기는 숲 속에서의 재충전','자연 속에서 품격 있는 휴식을 즐길 수 있는<br>파머스빌리지 수영장에서 재충전의 시간을 가져보세요']
                    var sec4_links = [
                        '/hotel/wedding/wedding.jsp',
                        '/hotel/wedding/seminar.jsp',
                        '/hotel/enjoy/spa.jsp',
                        '/hotel/enjoy/pool.jsp'
                    ];
                    var swiper4 = new Swiper(".sec04", {
                        pagination: {
                            el: ".swiper-pagination",
                            clickable: true,
                            renderBullet: function (index, className) {
                            	return '<span class="' + className + '">' + (sec4_tabname[index]) + "</span>";
                            },
                        },
                        on: {
                            activeIndexChange : function() {
                                console.log('now index :::', swiper4.realIndex);
                                var newIndex = swiper4.realIndex;
                                document.getElementById("sec4_imgS").src = "./image/sec4_slide_0" + (swiper4.realIndex + 1) + "_s.png";
                                document.getElementById("sec4_con").innerHTML = sec4_content[swiper4.realIndex];
                                document.getElementById("sec4_link").href = sec4_links[newIndex];
                            },
                        },
                    });
                </script>
            </section>
            <section class="section_wrap pc_section section_intro" data-index="5">
                <div class="swiper sec05">
                    <div class="swiper-pagination"></div>
                    <div class="swiper-wrapper">
                        <div class="swiper-slide slide01">
                            <div class="slide_title">
                            	<div class="l">
	                                <b>힐링, 그 자체</b>
	                                <span>바람과 자연을 느끼며 <br>가족, 연인과 편안하게</span>
                                </div>
                                <div class="r"></div>
                            </div>
                            <a href="/hotel/room/suite.jsp" class="slide_btn">객실 정보 더보기</a>
                        </div>
                        <div class="swiper-slide slide02">
                            <div class="slide_title">
                                <b>자연 속 농부의 쉼터</b>
                                <span>따뜻한 햇살 속 반려견과 <br>함께 추억을 만들어 보세요</span>
                            </div>
                            <a href="/hotel/room/glamping.jsp" class="slide_btn">글램핑 정보 더보기</a>
                        </div>
                        <div class="swiper-slide slide03">
                            <div class="slide_title">
                                <b>오직 회원에게만</b>
                                <span>특별한 객실 프로모션을 <br>만나보세요</span>
                            </div>
                            <a href="/hotel/offer/list.jsp" class="slide_btn">스페셜오퍼 정보 더보기</a>
                        </div>
                        <div class="swiper-slide slide04">
                            <div class="slide_title">
                                <b>산뜻한 아침 식사</b>
                                <span>상하의 제철 채소로 <br>차려진 건강한 농부의 밥상</span>
                            </div>
                            <a href="/hotel/dining/breakfast.jsp" class="slide_btn">파머스테이블 정보 더보기</a>
                        </div>
                        <div class="swiper-slide slide05">
                            <div class="slide_title">
                                <b>AI 맞춤 추천 운동</b>
                                <span>상하의 건강한 식단과 <br>더불어 누리는 운동 밸런스</span>
                            </div>
                            <a href="/hotel/enjoy/healthcare.jsp" class="slide_btn">셀렉스헬스케어 정보 더보기</a>
                        </div>
                    </div>
                </div>
                <div class="footer_g">
                    <div class="footer_wrap flex_wrap">
                        <div class="footer_group_mo mo_only">
                            <div class="groupWrap">
                                <div class="groupLine icn_cs">
                                    <span>상하농원 고객센터</span>
                                    <p><a href="tel:1522-3698">1522-3698</a></p>
                                </div>
                                <div class="groupLine icn_reserv">
                                    <span>파머스 빌리지 예약</span>
                                    <p><a href="tel:063-563-6611">063-563-6611</a></p>
                                </div>
                            </div>
                            <div class="groupWrap">
                                <div class="groupLine icn_and">
                                    <span>상하농원</span>
                                    <p><a href="">안드로이드 다운로드</a></p>
                                </div>
                                <div class="groupLine icn_ios">
                                    <span>다운로드</span>
                                    <p><a href="">iOS 다운로드</a></p>
                                </div>
                            </div>
                        </div>
                        <p class="fotter_logo"><img src="./image/footer_logo.png" alt=""></p>
                        <div class="footer_info">
                            <div class="info_link">
                                <a href="">입점/제휴문의</a>
                                <a href="">이용약관</a>
                                <a href="">개인정보취급방침</a>
                                <a href="">고객센터</a>
                                <a href="">윤리 HOT-LINE</a>
                            </div>
                            <div class="info_company">
                                <!-- 24.03.05 modify : .info_company 태그 및 내용 변경 -->
                                <div class="companyLine">
                                    <p><span>전라북도 고창군 상하면 상하농원길 11-23</span><span>대표 : 최승우</span></p>
                                    <p><span>개인정보 보호 책임자 : 최승우</span><span>사업자등록번호 : 415-86-00211</span></p>
                                </div>
                                <div class="companyLine">
                                    <p><span>통신판매업신고번호 : 제2016-4780085-30-2-00015호</span></p>
                                    <p><span>상담이용시간 : 09:30~18:00</span><span>농원운영시간 : 연중무휴 09:30~21:00</span></p>
                                </div>
                            </div>
                            <div class="info_extra">
                                <p>상하농원(유)은 매일유업(주)과의 제휴를 통해 공동으로 서비스를 운영하고 있습니다.</p>
                                <p>@ 2021 SANGHA FARM CO. ALL RIGHTS RESERVED</p>
                            </div>
                        </div>
                        <!-- 24.03.03 add class : pc_only -->
                        <div class="footer_btn flex_wrap pc_only">
                            <div class="footer_contact">
                                <div class="contact_cs"><b>고객센터</b><span>1522-3698</span></div>
                                <div class="contact_res"><b>빌리지예약</b><span>063-563-6611</span></div>
                            </div>
                            <div class="btn_wrap flex_wrap">
                                <p>상하농원 <br>앱 다운로드</p>
                                <div>
                                    <p class="btn_and">안드로이드</p>
                                    <p class="btn_ios">iOS</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <script>
	                var sec5_tabname = ['호텔 예약','글램핑 예약','스페셜오퍼','파머스테이블(조식)','셀렉스헬스케어'];
	                var swiper = new Swiper(".sec05", {
                        direction: "vertical",
                        grabCursor: true,
                        pagination: {
                            el: ".swiper-pagination",
                            clickable: true,
                            renderBullet: function (index, className) {
                            return '<span class="' + className + '">' + (sec5_tabname[index]) + "</span>";
                            },
                        },
                        touchRatio: 0,
                    });
                </script>
            </section>
        </div>
        <script class="pc_only">
            $(document).ready(function(){
                var urlChk = window.location.href;
                var hashChk = window.location.hash;
                var newUrl = urlChk.replace(hashChk, "");
                console.log(urlChk);
                if(hashChk != "#0"){
                    location.href = newUrl;
                }
            })
            new fullScroll({
                displayDots: false,
                animateTime: 1,
                animateFunction: 'ease',
                resetSliders: true,
                currentPosition: 2
            });
            
            $(function() {
                var today = new Date(); // 오늘 날짜 생성
                var tomorrow = new Date(today);
                tomorrow.setDate(tomorrow.getDate() + 1); // 내일 날짜 생성 (오늘 날짜 + 1)

                // checkin datepicker 설정
                $("#checkin").datepicker({
                    dateFormat: "yy.mm.dd",
                    showOn: "both",
                    buttonImage: "./image/icn_cal.png",
                    buttonImageOnly: true,
                    monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'],
                    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
                    dayNamesMin: ['일','월','화','수','목','금','토'],
                    dayNames: ['일','월','화','수','목','금','토'],
                    defaultDate: today, // 기본 날짜를 오늘로 설정
                    minDate: today, // 최소 선택 가능 날짜를 오늘로 설정
                    onClose: function(selectedDate) {
                        // checkin 날짜가 선택되면 checkout의 최소 날짜를 checkin + 1로 설정
                        var minDate = $(this).datepicker('getDate');
                        minDate.setDate(minDate.getDate() + 1); // checkout의 최소 날짜를 설정
                        $("#checkout").datepicker("option", "minDate", minDate);
                        $("#checkout").datepicker("setDate", minDate); // checkout 날짜를 자동으로 설정
                    }
                }).datepicker("setDate", today); // checkin 날짜를 오늘로 초기 설정

                // checkout datepicker 설정
                $("#checkout").datepicker({
                    dateFormat: "yy.mm.dd",
                    showOn: "both",
                    buttonImage: "./image/icn_cal.png",
                    buttonImageOnly: true,
                    monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'],
                    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
                    dayNamesMin: ['일','월','화','수','목','금','토'],
                    dayNames: ['일','월','화','수','목','금','토'],
                    minDate: tomorrow // checkout의 최소 날짜를 내일로 설정
                }).datepicker("setDate", tomorrow); // checkout 날짜를 내일로 초기 설정

                // Datepicker 버튼에 alt 속성 추가
                $(".ui-datepicker-trigger").attr("alt", "달력 보기");
                $(".ui-datepicker-trigger").attr("title", "달력 보기");
            });
            
            function popupOpen(popId){
                $('.popup_g').show();
                if (popId != ''){
                    $('.popup_wrap').hide();
                    $('#' + popId + '.popup_wrap').show();
                }
            }
            function popupClose(){
                $('.popup_g').hide();
            }
            $(".dim_g").click(function(){
                $('.popup_g').hide();
            });
            
            ///hotel/room/reservation/room.jsp, chki_date, chot_date
        </script>
    </body>
</html>