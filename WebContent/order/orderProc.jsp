<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.io.*,
				 com.efusioni.stone.utils.*,
				 com.efusioni.stone.common.*,
				 com.efusioni.stone.security.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.service.imc.*,
				 com.sanghafarm.service.order.*,
				 com.sanghafarm.service.member.*,
				 com.sanghafarm.service.promotion.*,
				 com.sanghafarm.utils.*,
				 org.json.simple.*,
				 lgdacom.XPayClient.XPayClient,
				 kr.co.lgcns.module.lite.*" %>
<%@ page import="javax.xml.ws.Response"%>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<%@ page import="com.fasterxml.jackson.core.type.TypeReference" %>
<%@page import="com.fasterxml.jackson.databind.node.ArrayNode"%>
<%@page import="com.fasterxml.jackson.databind.JsonNode"%>
<%@ include file="/order/payco/common_include.jsp" %>
<%
	request.setCharacterEncoding("utf-8"); 
	
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	OrderService order = (new OrderService()).toProxyInstance();
	MemberService member = (new MemberService()).toProxyInstance();
	ImMemberService immem = (new ImMemberService()).toProxyInstance();
	CartService cart = (new CartService()).toProxyInstance();
	CouponService coupon = (new CouponService()).toProxyInstance();
	SecondAnniversaryService sa = new SecondAnniversaryService();
	
	String orderid = param.get("orderid");
	String deviceType = param.get("device_type", "P");
	
	if(fs.isLogin()) {
		Param memInfo = member.getInfo(fs.getUserId());
		System.out.println("-------------------------- " + orderid + " : " + memInfo.get("orderid"));
		if("".equals(memInfo.get("orderid")) || !orderid.equals(memInfo.get("orderid"))) {
			System.out.println(orderid + "----------------- invalid order 유효하지 않은 주문서입니다.(1)");
			Utils.sendMessage(out, "유효하지 않은 주문서입니다.(1)", Env.getURLPath() + "/");
			return;
		}
	}
	
	// 금액검증
	/*
	String DB_AMOUNT = (String) session.getAttribute("DB_AMOUNT");
	System.out.println("---------------- " + param.getInt("LGD_AMOUNT") + " : " + DB_AMOUNT);
	if(param.getInt("LGD_AMOUNT") != 0 && !param.get("LGD_AMOUNT").equals(DB_AMOUNT)) {
		System.out.println("---------------- " + param.getInt("LGD_AMOUNT") + " : " + DB_AMOUNT);
		Utils.sendMessage(out, "유효하지 않은 주문서입니다.(2)", Env.getURLPath() + "/");
		return;"WebContent/order/orderProc.jsp"
	}
	*/

	// 쿠폰, 주문 내역 검증
	String userid = "";
	if(fs.isLogin()) userid = fs.getUserId();
	else userid = fs.getTempUserId();
	
	param.set("userid", userid);
	
	param.set("grade_code", fs.getGradeCode());
	param.set("order_yn", "Y");
	
	// 일반상품
	param.set("routine_yn", "N");
	param.set("ptype", "A");
	List<Param> list1 = cart.getList(param);
	
	// 산지직송 상품
	param.set("ptype", "C");
	List<Param> list2 = cart.getList(param);

	// 정기구매
	param.set("routine_yn", "Y");
	param.remove("ptype");
	List<Param> list3 = cart.getList(param);
	
	// 배송일 지정 상품
	param.set("routine_yn", "N");
	param.set("ptype", "D");
	List<Param> list4 = cart.getList(param);
	
	List<String> couponList = new ArrayList<String>();

	// 배송비 계산 -----------------
	int totalPrice1 = 0;
	for(Param row : list1) {
		totalPrice1 += row.getInt("sale_price") * row.getInt("qty");
	}
	int shipAmt1 = totalPrice1 == 0 ? 0 : (totalPrice1 >= Config.getInt("shipping.free.amt") ? 0 : Config.getInt("shipping.amt"));

	int totalPrice2 = 0;
	for(Param row : list2) {
		totalPrice2 += row.getInt("sale_price") * row.getInt("qty");
	}
	int shipAmt2 = totalPrice2 == 0 ? 0 : (totalPrice2 >= Config.getInt("shipping.free.amt") ? 0 : Config.getInt("shipping.amt"));

	int totalPrice4 = 0;
	for(Param row : list4) {
		totalPrice4 += row.getInt("sale_price") * row.getInt("qty");
	}
	int shipAmt4 = totalPrice4 == 0 ? 0 : (totalPrice4 >= Config.getInt("shipping.free.amt") ? 0 : Config.getInt("shipping.amt"));
	
	int shipAmt = shipAmt1 + shipAmt2 + shipAmt4;
	//-----------------------------------------
	
	int totalPrice = 0;
	int totalTaxFreeAmt = 0;
	int couponAmt = 0;
// 	int couponAmt1 = 0;
// 	int couponAmt2 = 0;
// 	int couponAmt3 = 0;

	List<Param> soldOutList = new ArrayList<Param>();
	
	// 장바구니 쿠폰 검증을 위한 상품 리스트
	List<Param> itemList = new ArrayList<Param>();
	
	// 현대카드 프로모션 상품 존재 여부
	boolean existsHyundaiCardPid = false;

	// 2주년 프로모션 정보
	Param saInfo = sa.getInfo();
	List<String> saList = sa.getProductList(saInfo.getLong("seq"));
	
	// 2주년 프로모션 체크용 List
	List<Param> saList1 = new ArrayList<Param>();
	List<Param> saList2 = new ArrayList<Param>();
	List<Param> saList3 = new ArrayList<Param>();
	List<Param> saList4 = new ArrayList<Param>();

	// 지정배송일 오류 체크
	boolean isInvalidDdate = false;

	// 쿠폰정보
	Param couponInfo = new Param();
	int couponApplyAmt = 0;
	if(!"".equals(param.get("mem_couponid"))) {
		couponInfo = coupon.getInfoByMemCoupon(param.get("mem_couponid"));
	}

	// 일반상품
	for(Param row : list1) {
		Param item = new Param();
		int _couponAmt = 0;

		// 재고수량이 주문수량보다 적을 경우
		if(row.getInt("qty") > row.getInt("stock")) {
			soldOutList.add(row);
		}

		int amt = row.getInt("sale_price") * row.getInt("qty");
		totalPrice += amt;

		// 쿠폰
		/* 2021.11.05 쿠폰 변경 by hassel
		if(!"".equals(param.get("mem_couponid_" + row.get("cartid")))) {
			Param p = new Param();
			p.set("userid", fs.getUserId());
			p.set("device_type", deviceType);
			p.set("grade_code", fs.getGradeCode());
			p.set("pid", row.get("sub_pid"));
			p.set("min_price", amt);
			
			List<Param> cList = coupon.getApplyableList(p);
			boolean isValidCoupon = false;
			for(Param c : cList) {
				if(param.get("mem_couponid_" + row.get("cartid")).equals(c.get("mem_couponid"))) {
					if(couponList.contains(c.get("mem_couponid"))) {
						break;
					} else {
						couponList.add(c.get("mem_couponid"));
						if("A".equals(c.get("sale_type"))) {	//  정량
							_couponAmt = c.getInt("sale_amt");
						} else {	// 정률
							_couponAmt = (c.getInt("max_sale") <= (amt * c.getInt("sale_amt") / 100)) ? 
									c.getInt("max_sale") : (amt * c.getInt("sale_amt") / 100);
						}
						
						couponAmt1 += _couponAmt;
						isValidCoupon = true;
						break;
					}
				}
			}
			
			if(!isValidCoupon) {
				System.out.println(orderid + "----------------- invalid order 유효하지 않은 주문서입니다.(3)");
				Utils.sendMessage(out, "유효하지 않은 주문서입니다.(3)", Env.getURLPath() + "/");
				return;
			}
		}
		*/

		if("001".equals(couponInfo.get("coupon_type"))) {
			if(coupon.isApplyableProduct(
					new Param(
						"userid", fs.getUserId(), "device_type", fs.getDeviceType(), "grade_code", fs.getGradeCode(),
						"mem_couponid", param.get("mem_couponid"), "pid", row.get("sub_pid")))) {
				couponApplyAmt += row.getInt("sale_price") * row.getInt("qty");
			}
		}
		
		item.set("pid", row.get("sub_pid"));
		item.set("amt", amt);
		item.set("coupon_amt", _couponAmt);
		itemList.add(item);

		// 현대카드 할인상품
		if(SanghafarmUtils.isHyundaiPromotionPid(row.get("sub_pid"))) {
			existsHyundaiCardPid = true;
		}

		// 2주년 프로모션 체크
		if("S".equals(saInfo.get("status"))) {
			if(!fs.isLogin()) { 
				if(saList.contains(row.get("sub_pid"))) {
					saList1.add(row);
				}
			} else {
				if(saList.contains(row.get("sub_pid"))) {
					List<Param> l = sa.getOrderList(new Param("userid", fs.getUserId(), "pid", row.get("sub_pid")));
					if(l != null && l.size() > 0) {
						saList2.add(row);
					}
				}
				
				if(saList.contains(row.get("sub_pid")) && row.getInt("qty") > saInfo.getInt("buy_avail_qty")) {
					saList3.add(row);
				}
			}
			
			// 동일 상품 체크
			boolean isSame = false;
			for(int j = 0; j < saList4.size(); j++) {
				Param p = saList4.get(j);
				if(p.get("sub_pid").equals(row.get("sub_pid"))) {
					p.set("qty", p.getInt("qty") + row.getInt("qty"));
					saList4.remove(j);
					saList4.add(j, p);
					isSame = true;
					break;
				}
			}
			
			if(!isSame) {
				Param p = new Param("pid", row.get("pid"), "sub_pid", row.get("sub_pid"), "qty", row.get("qty"));
				saList4.add(p);
			}
		}
	}	

	// 산지직송 상품
	for(Param row : list2) {
		Param item = new Param();
		int _couponAmt = 0;

		// 재고수량이 주문수량보다 적을 경우
		if(row.getInt("qty") > row.getInt("stock")) {
			soldOutList.add(row);
		}

		int amt = row.getInt("sale_price") * row.getInt("qty");
		totalPrice += amt;

		// 쿠폰
		/*
		if(!"".equals(param.get("mem_couponid_" + row.get("cartid")))) {
			Param p = new Param();
			p.set("userid", fs.getUserId());
			p.set("device_type", deviceType);
			p.set("grade_code", fs.getGradeCode());
			p.set("pid", row.get("sub_pid"));
			p.set("min_price", amt);
			
			List<Param> cList = coupon.getApplyableList(p);
			boolean isValidCoupon = false;
			for(Param c : cList) {
				if(param.get("mem_couponid_" + row.get("cartid")).equals(c.get("mem_couponid"))) {
					if(couponList.contains(c.get("mem_couponid"))) {
						break;
					} else {
						couponList.add(c.get("mem_couponid"));

						if("A".equals(c.get("sale_type"))) {	//  정량
							_couponAmt = c.getInt("sale_amt");
						} else {	// 정률
							_couponAmt = (c.getInt("max_sale") <= (amt * c.getInt("sale_amt") / 100)) ? 
									c.getInt("max_sale") : (amt * c.getInt("sale_amt") / 100);
						}

						couponAmt1 += _couponAmt;
						isValidCoupon = true;
						break;
					}
				}
			}
			
			if(!isValidCoupon) {
				System.out.println(orderid + "----------------- invalid order 유효하지 않은 주문서입니다.(4)");
				Utils.sendMessage(out, "유효하지 않은 주문서입니다.(4)", Env.getURLPath() + "/");
				return;
			}
		}
		*/
		
		if("001".equals(couponInfo.get("coupon_type"))) {
			if(coupon.isApplyableProduct(
					new Param(
						"userid", fs.getUserId(), "device_type", fs.getDeviceType(), "grade_code", fs.getGradeCode(),
						"mem_couponid", param.get("mem_couponid"), "pid", row.get("sub_pid")))) {
				couponApplyAmt += row.getInt("sale_price") * row.getInt("qty");
			}
		}


		item.set("pid", row.get("sub_pid"));
		item.set("amt", amt);
		item.set("coupon_amt", _couponAmt);
		itemList.add(item);

		// 현대카드 할인상품
		if(SanghafarmUtils.isHyundaiPromotionPid(row.get("sub_pid"))) {
			existsHyundaiCardPid = true;
		}

		// 2주년 프로모션 체크
		if("S".equals(saInfo.get("status"))) {
			if(!fs.isLogin()) { 
				if(saList.contains(row.get("sub_pid"))) {
					saList1.add(row);
				}
			} else {
				if(saList.contains(row.get("sub_pid"))) {
					List<Param> l = sa.getOrderList(new Param("userid", fs.getUserId(), "pid", row.get("sub_pid")));
					if(l != null && l.size() > 0) {
						saList2.add(row);
					}
				}
				
				if(saList.contains(row.get("sub_pid")) && row.getInt("qty") > saInfo.getInt("buy_avail_qty")) {
					saList3.add(row);
				}
			}
			
			// 동일 상품 체크
			boolean isSame = false;
			for(int j = 0; j < saList4.size(); j++) {
				Param p = saList4.get(j);
				if(p.get("sub_pid").equals(row.get("sub_pid"))) {
					p.set("qty", p.getInt("qty") + row.getInt("qty"));
					saList4.remove(j);
					saList4.add(j, p);
					isSame = true;
					break;
				}
			}
			
			if(!isSame) {
				Param p = new Param("pid", row.get("pid"), "sub_pid", row.get("sub_pid"), "qty", row.get("qty"));
				saList4.add(p);
			}
		}
	}

	// 정기배송상품
	for(Param row : list3) {
		Param item = new Param();
		int _couponAmt = 0;

		int routineSaleAmt = 0;
		int couponSaleAmt = 0;
		int price = row.getInt("sale_price") * row.getInt("qty") * row.getInt("routine_cnt");

		if("A".equals(row.get("routine_sale_type"))) {
			routineSaleAmt = row.getInt("routine_sale_amt") * row.getInt("qty") * row.getInt("routine_cnt");
		} else {
			routineSaleAmt = row.getInt("sale_price") * row.getInt("qty") * row.getInt("routine_cnt") * row.getInt("routine_sale_amt") / 100;
		}
		
		int amt = price - routineSaleAmt - couponSaleAmt;
		totalPrice += amt;

		// 쿠폰
		/*
		if(!"".equals(param.get("mem_couponid_" + row.get("cartid")))) {
			Param p = new Param();
			p.set("userid", fs.getUserId());
			p.set("device_type", deviceType);
			p.set("grade_code", fs.getGradeCode());
			p.set("pid", row.get("sub_pid"));
			p.set("min_price", amt);
			
			List<Param> cList = coupon.getApplyableList(p);
			boolean isValidCoupon = false;
			for(Param c : cList) {
				if(param.get("mem_couponid_" + row.get("cartid")).equals(c.get("mem_couponid"))) {
					if(couponList.contains(c.get("mem_couponid"))) {
						break;
					} else {
						couponList.add(c.get("mem_couponid"));

						if("A".equals(c.get("sale_type"))) {	//  정량
							_couponAmt = c.getInt("sale_amt");
						} else {	// 정률
							_couponAmt = (c.getInt("max_sale") <= (amt * c.getInt("sale_amt") / 100)) ?
									c.getInt("max_sale") : (amt * c.getInt("sale_amt") / 100);
						}
						
						couponAmt1 += _couponAmt;
						isValidCoupon = true;
						break;
					}
				}
			}
			
			if(!isValidCoupon) {
				System.out.println(orderid + "----------------- invalid order 유효하지 않은 주문서입니다.(5)");
				Utils.sendMessage(out, "유효하지 않은 주문서입니다.(5)", Env.getURLPath() + "/");
				return;
			}
		}
		*/
		if("001".equals(couponInfo.get("coupon_type"))) {
			if(coupon.isApplyableProduct(
					new Param(
						"userid", fs.getUserId(), "device_type", fs.getDeviceType(), "grade_code", fs.getGradeCode(),
						"mem_couponid", param.get("mem_couponid"), "pid", row.get("sub_pid")))) {
				int _routineSaleAmt = 0;
				int _price = row.getInt("sale_price") * row.getInt("qty") * row.getInt("routine_cnt");

				if("A".equals(row.get("routine_sale_type"))) {
					_routineSaleAmt = row.getInt("routine_sale_amt") * row.getInt("qty") * row.getInt("routine_cnt");
				} else {
					_routineSaleAmt = row.getInt("sale_price") * row.getInt("qty") * row.getInt("routine_cnt") * row.getInt("routine_sale_amt") / 100;
				}
				
				couponApplyAmt += _price - _routineSaleAmt;
			}
		}

		item.set("pid", row.get("sub_pid"));
		item.set("amt", amt);
		item.set("coupon_amt", _couponAmt);
		itemList.add(item);

		// 현대카드 할인상품
		if(SanghafarmUtils.isHyundaiPromotionPid(row.get("sub_pid"))) {
			existsHyundaiCardPid = true;
		}
	}

	// 배송일 지정 상품
	Calendar cal = Calendar.getInstance();
	int hour = cal.get(Calendar.HOUR_OF_DAY);
	if(hour < 10) cal.add(Calendar.DATE, 1);
	else cal.add(Calendar.DATE, 2);
	String minDate = Utils.getTimeStampString(cal.getTime(), "yyyy.MM.dd");

	for(Param row : list4) {
		Param item = new Param();
		int _couponAmt = 0;

		// 재고수량이 주문수량보다 적을 경우
		if(row.getInt("qty") > row.getInt("stock")) {
			soldOutList.add(row);
		}

		int amt = row.getInt("sale_price") * row.getInt("qty");
		totalPrice += amt;

		// 쿠폰
		/*
		if(!"".equals(param.get("mem_couponid_" + row.get("cartid")))) {
			Param p = new Param();
			p.set("userid", fs.getUserId());
			p.set("device_type", deviceType);
			p.set("grade_code", fs.getGradeCode());
			p.set("pid", row.get("sub_pid"));
			p.set("min_price", amt);
			
			List<Param> cList = coupon.getApplyableList(p);
			boolean isValidCoupon = false;
			for(Param c : cList) {
				if(param.get("mem_couponid_" + row.get("cartid")).equals(c.get("mem_couponid"))) {
					if(couponList.contains(c.get("mem_couponid"))) {
						break;
					} else {
						couponList.add(c.get("mem_couponid"));
						if("A".equals(c.get("sale_type"))) {	//  정량
							_couponAmt = c.getInt("sale_amt");
						} else {	// 정률
							_couponAmt = (c.getInt("max_sale") <= (amt * c.getInt("sale_amt") / 100)) ? 
									c.getInt("max_sale") : (amt * c.getInt("sale_amt") / 100);
						}
						
						couponAmt1 += _couponAmt;
						isValidCoupon = true;
						break;
					}
				}
			}
			
			if(!isValidCoupon) {
				System.out.println(orderid + "----------------- invalid order 유효하지 않은 주문서입니다.(11)");
				Utils.sendMessage(out, "유효하지 않은 주문서입니다.(11)", Env.getURLPath() + "/");
				return;
			}
		}
		*/
		if("001".equals(couponInfo.get("coupon_type"))) {
			if(coupon.isApplyableProduct(
					new Param(
						"userid", fs.getUserId(), "device_type", fs.getDeviceType(), "grade_code", fs.getGradeCode(),
						"mem_couponid", param.get("mem_couponid"), "pid", row.get("sub_pid")))) {
				couponApplyAmt += row.getInt("sale_price") * row.getInt("qty");
			}
		}


		item.set("pid", row.get("sub_pid"));
		item.set("amt", amt);
		item.set("coupon_amt", _couponAmt);
		itemList.add(item);

		// 현대카드 할인상품
		if(SanghafarmUtils.isHyundaiPromotionPid(row.get("sub_pid"))) {
			existsHyundaiCardPid = true;
		}

		// 2주년 프로모션 체크
		if("S".equals(saInfo.get("status"))) {
			if(!fs.isLogin()) { 
				if(saList.contains(row.get("sub_pid"))) {
					saList1.add(row);
				}
			} else {
				if(saList.contains(row.get("sub_pid"))) {
					List<Param> l = sa.getOrderList(new Param("userid", fs.getUserId(), "pid", row.get("sub_pid")));
					if(l != null && l.size() > 0) {
						saList2.add(row);
					}
				}
				
				if(saList.contains(row.get("sub_pid")) && row.getInt("qty") > saInfo.getInt("buy_avail_qty")) {
					saList3.add(row);
				}
			}
			
			// 동일 상품 체크
			boolean isSame = false;
			for(int j = 0; j < saList4.size(); j++) {
				Param p = saList4.get(j);
				if(p.get("sub_pid").equals(row.get("sub_pid"))) {
					p.set("qty", p.getInt("qty") + row.getInt("qty"));
					saList4.remove(j);
					saList4.add(j, p);
					isSame = true;
					break;
				}
			}
			
			if(!isSame) {
				Param p = new Param("pid", row.get("pid"), "sub_pid", row.get("sub_pid"), "qty", row.get("qty"));
				saList4.add(p);
			}
		}
		
		// 지정배송일 체크
		if(minDate.compareTo(row.get("delivery_date")) > 0) {
			isInvalidDdate = true;
		}
	}
	
	if(soldOutList.size() > 0) {
		String msg = "주문서의 일부 상품 재고가 부족합니다.\\n\\n주문이 가능한 수량은\\n";
		for(Param row : soldOutList) {
			msg += row.get("opt_pnm") + " " + row.getInt("stock") + "개\\n";
		}
		msg += "입니다.\\n\\n주문 수량을 조정하시거나, 해당 상품을 제외하시고\\n주문 부탁드립니다.";
		
		Utils.sendMessage(out, msg, ("P".equals(deviceType) ? "" : "/mobile") + "/order/cart.jsp");
		return;
	}
	
	if(saList1 != null && saList1.size() > 0) {
		String msg = "비회원은 주문할 수 없는 프로모션상품이 있습니다.\\n";
		for(Param row : saList1) {
			msg += "   -" + row.get("pnm") + " - " + row.get("sub_opt_pnm") + "\\n";
		}
		msg += "\\n로그인 후 이용하시거나 해당 상품을 제외하고 비회원 주문이 가능합니다.";

		Utils.sendMessage(out, msg, ("P".equals(deviceType) ? "" : "/mobile") + "/order/cart.jsp");
		return;
	}

	if(saList2 != null && saList2.size() > 0) {
		String msg = "오늘 구매이력이 있어 주문할 수 없는 상품이 있습니다.\\n";
		for(Param row : saList2) {
			msg += "   -" + row.get("pnm") + " - " + row.get("sub_opt_pnm") + "\\n";
		}
		msg += "\\n프로모션 상품은 1일 1회 주문 가능합니다. 해당상품을 제외하고 주문해 주세요.";

		Utils.sendMessage(out, msg, ("P".equals(deviceType) ? "" : "/mobile") + "/order/cart.jsp");
		return;
	}

	if(saList3 != null && saList3.size() > 0) {
		String msg = "1일 최대 " + saInfo.getInt("buy_avail_qty") + "개까지 주문이 가능한 상품이 있습니다.\\n";
		for(Param row : saList3) {
			msg += "   -" + row.get("pnm") + " - " + row.get("sub_opt_pnm") + "\\n";
		}
		msg += "\\n프로모션 상품 수량을 " + saInfo.getInt("buy_avail_qty") + "개 이하로 조정한 후 주문해 주세요.";

		Utils.sendMessage(out, msg, ("P".equals(deviceType) ? "" : "/mobile") + "/order/cart.jsp");
		return;
	}

	if(isInvalidDdate) {
		String msg = "유효하지 않은 배송일이 지정되었습니다.\\n배송일 지정상품을 제외하고 주문하세요.";
		Utils.sendMessage(out, msg, ("P".equals(deviceType) ? "" : "/mobile") + "/order/cart.jsp");
		return;
	}
	
	String s = "";
	List<String> temp = null;
	for(Param row : saList4) {
		if(row.getInt("qty") > saInfo.getInt("buy_avail_qty")) {
			temp = new ArrayList<String>();
			for(Param r : list1) {
				if(row.get("sub_pid").equals(r.get("sub_pid"))) {
					temp.add(r.get("pnm") + " - " + r.get("sub_opt_pnm"));
				}
			}
			for(Param r : list2) {
				if(row.get("sub_pid").equals(r.get("sub_pid"))) {
					temp.add(r.get("pnm") + " - " + r.get("sub_opt_pnm"));
				}
			}
			for(Param r : list4) {
				if(row.get("sub_pid").equals(r.get("sub_pid"))) {
					temp.add(r.get("pnm") + " - " + r.get("sub_opt_pnm"));
				}
			}
			
			if(temp.size() > 1) {
				for(int i = 0; i < temp.size(); i++) {
					s += "   " + temp.get(i);
					if(i == temp.size() - 1) {
						s += "은 같은 상품입니다.\\n\\n";
					} else {
						s += "와(과)\\n";
					}
				}
			}
		}
	}
	
	if(!"".equals(s)) {
		String msg = "동일한 상품으로 합계수량이 " + saInfo.getInt("buy_avail_qty") + "개를 초과하였습니다.\\n";
		msg += s + "합계 수량을 " + saInfo.getInt("buy_avail_qty") + "개 이하로 조정한 후 주문해 주세요.";

		Utils.sendMessage(out, msg, ("P".equals(deviceType) ? "" : "/mobile") + "/order/cart.jsp");
		return;
	}

	// 쿠폰검증
	if("001".equals(couponInfo.get("coupon_type"))) {
		if(couponApplyAmt >= couponInfo.getInt("min_price")) {
			if("A".equals(couponInfo.get("sale_type"))) {	// 정액
				couponAmt = couponApplyAmt > couponInfo.getInt("sale_amt") ? couponInfo.getInt("sale_amt") : couponApplyAmt;
			} else {
				couponAmt = couponApplyAmt * couponInfo.getInt("sale_amt") / 100;
				couponAmt = couponAmt > couponInfo.getInt("max_sale") ? couponInfo.getInt("max_sale") : couponAmt;
				couponAmt = couponAmt > couponApplyAmt ? couponApplyAmt : couponAmt;
			}
		}
	} else if("003".equals(couponInfo.get("coupon_type"))) {
		if("A".equals(couponInfo.get("sale_type"))) {	// 정액
			couponAmt = shipAmt > couponInfo.getInt("sale_amt") ? couponInfo.getInt("sale_amt") : shipAmt;
		} else {
			couponAmt = shipAmt * couponInfo.getInt("sale_amt") / 100;
			couponAmt = couponAmt > couponInfo.getInt("max_sale") ? couponInfo.getInt("max_sale") : couponAmt;
			couponAmt = couponAmt > shipAmt ? shipAmt : couponAmt;
		}
	}

	// 장바구니 쿠폰
	/*
	if(!"".equals(param.get("mem_couponid_cart"))) {
		Param p = new Param();
		p.set("userid", fs.getUserId());
		p.set("device_type", deviceType);
		p.set("grade_code", fs.getGradeCode());
		p.set("coupon_type", "002");
		p.set("min_price", totalPrice);
		
// 		List<Param> cList = coupon.getApplyableList2(p);
		List<Param> cList = coupon.getCartApplyableList(p);
		boolean isValidCoupon = false;
		for(Param c : cList) {
			if(param.get("mem_couponid_cart").equals(c.get("mem_couponid"))) {
				if(couponList.contains(c.get("mem_couponid"))) {
					break;
				} else {
					couponList.add(c.get("mem_couponid"));

					if("A".equals(c.get("sale_type"))) {	//  정량
						couponAmt2 = c.getInt("sale_amt");
					} else {	// 정률
// 						couponAmt2 = (c.getInt("max_sale") <= ((totalPrice - couponAmt1 - couponAmt2) * c.getInt("sale_amt") / 100)) ? 
// 								c.getInt("max_sale") : ((totalPrice - couponAmt1 - couponAmt2) * c.getInt("sale_amt") / 100);

						int _totAmt = 0;
						List<Param> exList = coupon.getApplyProductList(new Param("couponid", c.get("couponid"), "ie_code", "E"));
						// 제외상품 처리
						for(Param r : itemList) {
							System.out.println(orderid + " ItemList : " + r);
							if(exList.size() > 0) {
								boolean isExclude = false;
								for(Param e : exList) {
									if(r.get("pid").equals(e.get("pid"))) {
										isExclude = true;
										break;
									}
								}
								
								if(!isExclude) {
									_totAmt += r.getInt("amt") - r.getInt("coupon_amt");
								}
							} else {
								_totAmt += r.getInt("amt") - r.getInt("coupon_amt");
							}
						}
						System.out.println(orderid + " _totamt : " + _totAmt);
						System.out.println(orderid + " CouponInfo : " + c);
 						couponAmt2 = (c.getInt("max_sale") <= (_totAmt * c.getInt("sale_amt") / 100)) ? 
							c.getInt("max_sale") : (_totAmt * c.getInt("sale_amt") / 100);
					}
					
					isValidCoupon = true;
					break;
				}
			}
		}

		if(!isValidCoupon) {
			System.out.println(orderid + "----------------- invalid order 유효하지 않은 주문서입니다.(6)");
			Utils.sendMessage(out, "유효하지 않은 주문서입니다.(6)", Env.getURLPath() + "/");
			return;
		}
	}
	*/
	
	// 배송비 쿠폰
	/*
	if(!"".equals(param.get("mem_couponid_ship"))) {
		Param p = new Param();
		p.set("userid", fs.getUserId());
		p.set("device_type", deviceType);
		p.set("grade_code", fs.getGradeCode());
		p.set("coupon_type", "003");
		
		List<Param> cList = coupon.getApplyableList2(p);
		boolean isValidCoupon = false;
		for(Param c : cList) {
			if(param.get("mem_couponid_ship").equals(c.get("mem_couponid"))) {
				if(couponList.contains(c.get("mem_couponid"))) {
					break;
				} else {
					couponList.add(c.get("mem_couponid"));

					if("A".equals(c.get("sale_type"))) {	//  정량
						couponAmt3 += c.getInt("sale_amt");
					} else {	// 정률
// 						couponAmt3 += (c.getInt("max_sale") <= (Config.getInt("shipping.amt") * c.getInt("sale_amt") / 100)) ?
// 								c.getInt("max_sale") : (Config.getInt("shipping.amt") * c.getInt("sale_amt") / 100);
						couponAmt3 += (c.getInt("max_sale") <= (shipAmt * c.getInt("sale_amt") / 100)) ?
								c.getInt("max_sale") : (shipAmt * c.getInt("sale_amt") / 100);
					}
					
					isValidCoupon = true;
					break;
				}
			}
		}

		if(!isValidCoupon) {
			System.out.println(orderid + "----------------- invalid order 유효하지 않은 주문서입니다.(7)");
			Utils.sendMessage(out, "유효하지 않은 주문서입니다.(7)", Env.getURLPath() + "/");
			return;
		}
	}
	*/
	
// 	couponAmt = couponAmt1 + couponAmt2 + couponAmt3;
// 	System.out.println(orderid + " couponAmt : " + couponAmt1 + " , " + couponAmt2 + " , " + couponAmt3);
	System.out.println(orderid + " couponAmt : " + couponAmt + " , " + Integer.parseInt(param.get("coupon_amt", "0").replaceAll(",", "")));
	if(couponAmt != Integer.parseInt(param.get("coupon_amt", "0").replaceAll(",", ""))) {
		System.out.println(orderid + "----------------- invalid order 유효하지 않은 주문서입니다.(8)");
		Utils.sendMessage(out, "유효하지 않은 주문서입니다.(8)", Env.getURLPath() + "/");
		return;
	}
	
	// 포인트
	int pointAmt = Integer.parseInt(param.get("point_amt", "0").replaceAll(",", ""));
	if(pointAmt > 0) {	
		int point = immem.getMemberPoint(fs.getUserNo());
		if(point < pointAmt) {
			System.out.println(orderid + "----------------- invalid order 유효하지 않은 주문서입니다.(9) " + point + " : " + pointAmt);
			Utils.sendMessage(out, "유효하지 않은 주문서입니다.(9)", Env.getURLPath() + "/");
			return;
		}
	}
	
	// 기프트카드
	int giftcardAmt = Integer.parseInt(param.get("giftcard_amt", "0").replaceAll(",", ""));
	if(giftcardAmt > 0 && "".equals(param.get("giftcard_id"))) {
		System.out.println(orderid + "----------------- invalid order 유효하지 않은 주문서입니다.(12)");
		Utils.sendMessage(out, "유효하지 않은 주문서입니다.(12)", Env.getURLPath() + "/");
		return;
	}
	
	System.out.println(orderid + " PAY_AMT : " + (totalPrice + shipAmt - couponAmt - pointAmt - giftcardAmt) + " : " + param.get("LGD_AMOUNT"));
	if((totalPrice + shipAmt - couponAmt - pointAmt - giftcardAmt) != param.getInt("LGD_AMOUNT")) {
		System.out.println(orderid + "----------------- invalid order 유효하지 않은 주문서입니다.(10)");
		Utils.sendMessage(out, "유효하지 않은 주문서입니다.(10)", Env.getURLPath() + "/");
		return;
	}
	
//  	if(SystemChecker.isLocal()) return;

// 	boolean nopg = true;
	boolean nopg = false;

	if(param.getInt("LGD_AMOUNT") == 0 || (nopg && SystemChecker.isLocal())) {	// 0원 결제
		try {
			order.create(request, response);
		} catch(Exception e) {
			Utils.sendMessage(out, e.getLocalizedMessage(), Env.getURLPath() + "/");
			return;
		}
	} else if("009".equals(param.get("pay_type"))) {	// NaverPay
	    String partnerId = Config.get("npay.shop.partnerid");
	    String clientId = Config.get("npay.shop.clientid");
	    String clientSecret = Config.get("npay.shop.clientsecret");

	    Param p = new Param();
	    p.set("paymentId", param.get("paymentId"));
	    NaverPayUtil npay = new NaverPayUtil();
	    JSONObject json = npay.approve(partnerId, clientId, clientSecret, p);
	    int responseCode = (Integer) json.get("response_code");
	    String code = (String) json.get("code");
	    
	    if(responseCode == 200 && "Success".equals(code)) {	// 결제성공
	    	Param payInfo = new Param();
			payInfo.set("orderid", 				orderid);
			payInfo.set("code", 				code);
			payInfo.set("message",				json.get("message"));
			
			JSONObject body = (JSONObject) json.get("body");
			payInfo.set("payment_id",			body.get("paymentId"));
			
			JSONObject detail = (JSONObject) body.get("detail");
			payInfo.set("pay_hist_id",				detail.get("payHistId"));
			payInfo.set("merchant_id",				detail.get("merchantId"));
			payInfo.set("merchant_name",			detail.get("merchantName"));
			payInfo.set("merchant_pay_key",			detail.get("merchantPayKey"));
			payInfo.set("merchant_user_key",		detail.get("merchantUserKey"));
			payInfo.set("admission_type_code",		detail.get("admissionTypeCode"));
			payInfo.set("admission_ymdt",			detail.get("admissionYmdt"));
			payInfo.set("trade_confirm_ymdt",		detail.get("tradeConfirmYmdt"));
			payInfo.set("admission_state",			detail.get("admissionState"));
			payInfo.set("total_pay_amount",			detail.get("totalPayAmount"));
			payInfo.set("primary_pay_amount",		detail.get("primaryPayAmount"));
			payInfo.set("npoint_pay_amount",		detail.get("npointPayAmount"));
			payInfo.set("primary_pay_means",		detail.get("primaryPayMeans"));
			payInfo.set("card_corp_code",			detail.get("cardCorpCode"));
			payInfo.set("card_no",					detail.get("cardNo"));
			payInfo.set("card_auth_no",				detail.get("cardAuthNo"));
			payInfo.set("card_inst_count",			detail.get("cardInstCount"));
			payInfo.set("bank_corp_code",			detail.get("bankCorpCode"));
			payInfo.set("bank_account_no",			detail.get("bankAccountNo"));
			payInfo.set("product_name",				detail.get("productName"));
			payInfo.set("settle_expected",			detail.get("settleExpected"));
			payInfo.set("settle_expect_amount",		detail.get("settleExpectAmount"));
			payInfo.set("pay_commission_amount",	detail.get("payCommissionAmount"));
			payInfo.set("extra_deduction",			detail.get("extraDeduction"));
			payInfo.set("use_cfm_ymdt",				detail.get("useCfmYmdt"));

			try {
				if(param.getInt("LGD_AMOUNT") != Integer.parseInt(payInfo.get("total_pay_amount"))) {
					throw new Exception("결제금액 상이");
				}
				order.create(request, response, payInfo);
	    	} catch(Exception e) {
	    		e.printStackTrace();
	    		
	    		// 결제 취소
	    		int taxAmt = param.getInt("LGD_AMOUNT") - param.getInt("LGD_TAXFREEAMOUNT");
	    		int taxFree = param.getInt("LGD_TAXFREEAMOUNT");
				if(taxAmt < 0) {
					taxAmt = 0;
					taxFree = param.getInt("LGD_AMOUNT");
				}

				p = new Param();
	    		p.set("paymentId",				body.get("paymentId"));
	    		p.set("cancelAmount",			param.getInt("LGD_AMOUNT"));
	    		p.set("cancelReason",			"DB ERROR");
	    		p.set("cancelRequester",		"2");
	    		p.set("taxScopeAmount",			taxAmt);
	    		p.set("taxExScopeAmount",		taxFree);
	    		
	    		json = npay.cancel(partnerId, clientId, clientSecret, p);
	    		code = (String) json.get("code");
			    if(!"Success".equals(code)) {
                 	System.out.println(orderid + " : " + json.toJSONString());
                	Utils.sendMessage(out, "결제중 오류가 발생했지만 승인취소가 정상적으로 처리되지 않았습니다. 관리자에게 문의 하세요.", Env.getURLPath() + "/");
                	return;
			    }

			    System.out.println(orderid + " 네이버 결제 중 오류가 발생했습니다. (DB Transaction Fail) " + param.get("pay_type"));
            	Utils.sendMessage(out, "결제 중 오류가 발생했습니다. (DB Transaction Fail) " + param.get("pay_type"), Env.getURLPath() + "/");
            	return;
	    		
	    	}
	    } else {
        	System.out.println(orderid + "-------- 네이버 결제가 실패하였습니다.(" + json.get("code") + " : " + json.get("message"));
        	Utils.sendMessage(out, "결제가 실패하였습니다.(" + json.get("code") + " : " + json.get("message"), Env.getURLPath() + "/");
        	return;
	    }
	} else if("008".equals(param.get("pay_type"))) {	// SmilePay
	    //부인방지토큰값
	    String nonRepToken = param.get("NON_REP_TOKEN");
	    String txnId = param.get("txnId");
	    String binNumber = param.get("BIN_NUMBER");
	    System.out.println(orderid + "^^^^^^^^^^^^^^^ smilepay nonRepToken : " + nonRepToken);
	    System.out.println(orderid + "^^^^^^^^^^^^^^^ smilepay txnId : " + txnId);
	    System.out.println(orderid + "^^^^^^^^^^^^^^^ smilepay binNumber : " + binNumber);
		
		// 현대카드 프로모션 체크
		if(existsHyundaiCardPid) {
			System.out.println(orderid + "kakao ------------------------------- if 1----------------");
			if("".equals(binNumber) || !SanghafarmUtils.isHyundaiPromotionCard(binNumber.substring(0, 6))) {
				System.out.println(orderid + "kakao ------------------------------- if 2----------------");
// 				Utils.sendMessage(out, "현대카드 블랙/퍼플 전용 할인 상품이 있습니다.\\n해당 카드로 주문하셔야 합니다.\\n결제를 취소합니다.", Env.getURLPath() + (!"P".equals(deviceType) ? "/mobile" : "") + "/order/cart.jsp");
				Utils.sendMessage(out, "현대카드 프로모션 상품으로 the Black, the Purple카드 결제 시 20% 할인 혜택이 제공됩니다. 그 외 카드 결제 시 승인 후 자동 취소됩니다.", Env.getURLPath() + (!"P".equals(deviceType) ? "/mobile" : "") + "/order/cart.jsp");
				return;
			}
		}

// 		if(!SystemChecker.isReal()) return;
		
	    // 모듈이 설치되어 있는 경로 설정
	    CnsPayWebConnector connector = new CnsPayWebConnector();
	    
	    // 환경설정 및 로그 디렉토리 생성(incKakaopayCommon.jsp에서 설정한 값 사용)
	    connector.setLogHome(SmilepayUtil.LOG_HOME);
	    connector.setCnsPayHome(SmilepayUtil.CNSPAY_HONE);
	    
	    // 요청 페이지 파라메터 셋팅
	    connector.setRequestData(request);
	    
	    // 추가 파라메터 셋팅
	    connector.addRequestData("actionType", "PY0");              // actionType : CL0 취소, PY0 승인
	    connector.addRequestData("MallIP", request.getRemoteAddr());// 가맹점 고유 ip
	    
	    //가맹점키 셋팅 (MID 별로 틀림) 

	    connector.addRequestData("EncodeKey", SmilepayUtil.ENCODE_KEY);
	    
	    // CNSPAY Lite 서버 접속하여 처리
	    connector.requestAction();

	    // 결과 처리
 	    String resultCode = connector.getResultData("ResultCode");      // 결과코드 (정상 :3001 , 그 외 에러)
	    String resultMsg = connector.getResultData("ResultMsg");        // 결과메시지
	    
	    String errorCD = connector.getResultData("ErrorCD");  			// 원천사 오류코드 (참조용)
	    String errorMsg = connector.getResultData("ErrorMsg");  		// 원천사 오류 메세지 (참조용)
	    
	    String authDate = connector.getResultData("AuthDate");          // 승인일시 YYMMDDHH24mmss
	    String authCode = connector.getResultData("AuthCode");          // 승인번호

	    String buyerName = connector.getResultData("BuyerName");        // 구매자명
	    String goodsName = connector.getResultData("GoodsName");        // 상품명
	    String payMethod = connector.getResultData("PayMethod");        // 결제수단
	    String mid = connector.getResultData("MID");                    // 가맹점ID
	    String tid = connector.getResultData("TID");                    // 거래ID
	    String moid = connector.getResultData("Moid");                  // 주문번호
	    String amt = connector.getResultData("Amt");                    // 금액
	    String cardCode = connector.getResultData("CardCode");          // 카드사 코드
	    String acquCardCode = connector.getResultData("AcquCardCode");
	    String cardName = connector.getResultData("CardName");          // 결제카드사명
	    String cardQuota = connector.getResultData("CardQuota");        // 할부개월수 ex) 00:일시불,02:2개월
	    String cardInterest = connector.getResultData("CardInterest");  // 무이자 여부 (0:일반, 1:무이자)
	    String cardCl = connector.getResultData("CardCl");              // 체크카드여부 (0:일반, 1:체크카드)
	    String cardBin = connector.getResultData("CardBin");            // 카드BIN번호
	    String cardPoint = connector.getResultData("CardPoint");        // 카드사포인트사용여부 (0:미사용, 1:포인트사용, 2:세이브포인트사용)

	    String ccPartCl = connector.getResultData("CcPartCl");  		// 부분취소 가능 여부 (0:부분취소불가, 1:부분취소가능)
	    String promotionCcPartCl = connector.getResultData("PromotionCcPartCl");
	    String vanCode = connector.getResultData("VanCode");
	    String fnNo = connector.getResultData("FnNo");
	    String cardNo = connector.getResultData("CardNo");				// 마스킹된 카드 번호

	    String SmileCash = connector.getResultData("SmileCash");		// CI 연동가맹점 필수 파라미터

	 	// SMILEPAY를 위한 결과 처리
	    String promotionCd = connector.getResultData("PromotionCd");    // 프로모션 코드
	    String discountAmt = connector.getResultData("DiscountAmt");    // 프로모션 할인 금액
	    String possiBin = connector.getResultData("possiBin");    		// 선할인제휴카드 BIN
	    String blockBin = connector.getResultData("blockBin");    		// 특정제한카드 BIN
	    
		Param payInfo = new Param();
		payInfo.set("orderid", orderid);
		payInfo.set("result_code", resultCode);
		payInfo.set("result_msg", resultMsg);
		payInfo.set("error_cd", errorCD);
		payInfo.set("error_msg", errorMsg);
		payInfo.set("auth_date", authDate);
		payInfo.set("auth_code", authCode);
		payInfo.set("buyer_name", buyerName);
		payInfo.set("goods_name", goodsName);
		payInfo.set("pay_method", payMethod);
		payInfo.set("mid", mid);
		payInfo.set("tid", tid);
		payInfo.set("moid", moid);
		payInfo.set("amt", amt);
		payInfo.set("card_code", cardCode);
		payInfo.set("acqu_card_code", acquCardCode);
		payInfo.set("card_name", cardName);
		payInfo.set("card_quota", cardQuota);
		payInfo.set("card_interest", cardInterest);
		payInfo.set("card_cl", cardCl);
		payInfo.set("card_bin", cardBin);
		payInfo.set("card_point", cardPoint);
		payInfo.set("cc_part_cl", ccPartCl);
		payInfo.set("promotion_cc_part_cl", promotionCcPartCl);
		payInfo.set("van_code", vanCode);
		payInfo.set("fn_no", fnNo);
		payInfo.set("card_no", cardNo);
		payInfo.set("smile_cash", SmileCash);
		payInfo.set("promotion_cd", promotionCd);
		payInfo.set("discount_amt", discountAmt);
		payInfo.set("possi_bin", possiBin);
		payInfo.set("block_bin", blockBin);

	    System.out.println(orderid + "^^^^^^^^^^^^^^^ smilepay result ^^^^^^^^^^^^^^^");
// 	    System.out.println("resultCode         	: " + resultCode           );
// 	    System.out.println("resultMsg          	: " + resultMsg            );
// 	    System.out.println("errorCD         	: " + errorCD           	);
// 	    System.out.println("errorMsg          	: " + errorMsg            );
// 	    System.out.println("authDate           	: " + authDate             );
// 	    System.out.println("authCode           	: " + authCode             );
// 	    System.out.println("buyerName         	: " + buyerName             );
// 	    System.out.println("goodsName          	: " + goodsName             );
// 	    System.out.println("payMethod          	: " + payMethod            );
// 	    System.out.println("mid             	: " + mid                  );
// 	    System.out.println("tid                	: " + tid                  );
// 	    System.out.println("moid               	: " + moid                 );
// 	    System.out.println("amt                	: " + amt                  );
// 	    System.out.println("cardCode           	: " + cardCode             );
// 	    System.out.println("acquCardCode       	: " + acquCardCode         );
// 	    System.out.println("cardName           	: " + cardName             );
// 	    System.out.println("cardQuota          	: " + cardQuota            );
// 	    System.out.println("cardInterest       	: " + cardInterest         );
// 	    System.out.println("cardCl             	: " + cardCl               );
// 	    System.out.println("cardBin            	: " + cardBin              );
// 	    System.out.println("cardPoint          	: " + cardPoint            );
// 	    System.out.println("ccPartCl          	: " + ccPartCl            );
// 	    System.out.println("promotionCcPartCl  	: " + promotionCcPartCl    );
// 	    System.out.println("vanCode            	: " + vanCode              );
// 	    System.out.println("fnNo               	: " + fnNo                 );
// 	    System.out.println("cardNo              : " + cardNo                 );
// 	    System.out.println("SmileCash           : " + SmileCash                 );
// 	    System.out.println("promotionCd         : " + promotionCd                 );
// 	    System.out.println("discountAmt        	: " + discountAmt          );
// 	    System.out.println("possiBin            : " + possiBin                 );
// 	    System.out.println("blockBin            : " + blockBin                 );
		System.out.println(payInfo);
	    System.out.println("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
	    
	    boolean paySuccess = false;                                     // 결제 성공 여부
	    
        if(resultCode.equals("3001")) paySuccess = true;            // 결과코드 (정상 :3001 , 그 외 에러)
	    
	    if(paySuccess){
			Boolean doCancel = false;

			try {
				if(!doCancel) {
					if(param.getInt("LGD_AMOUNT") != Integer.parseInt(payInfo.get("amt"))) {
						throw new Exception("결제금액 상이");
					}

					order.create(request, response, payInfo);
				}
	    	}
	    	catch (Exception e) {
	    		e.printStackTrace();
	    		doCancel = true;
	    	}
			
			if(doCancel) {
	    		// DB 입력 실패시 결제 취소
				connector.addRequestData("actionType", "CL0");
				connector.addRequestData("MID", mid);
				connector.addRequestData("TID", tid);
				connector.addRequestData("CancelAmt", amt);
				connector.addRequestData("CancelMsg", "Transaction rolled back.");
				connector.addRequestData("PartialCancelCode", "0");
				connector.addRequestData("CancelIP", request.getRemoteAddr());
				
				connector.requestAction();
				
				payInfo = new Param();
				resultCode = connector.getResultData("ResultCode");
				
			    payInfo.set("orderid", param.get("orderid"));
			    payInfo.set("result_code", connector.getResultData("ResultCode"));
			    payInfo.set("result_msg", connector.getResultData("ResultMsg"));
			    payInfo.set("error_cd", connector.getResultData("ErrorCD"));
			    payInfo.set("error_msg", connector.getResultData("ErrorMsg"));
			    payInfo.set("cancel_amt", connector.getResultData("CancelAmt"));
			    payInfo.set("cancel_date", connector.getResultData("CancelDate"));
			    payInfo.set("cancel_time", connector.getResultData("CancelTime"));
			    payInfo.set("pay_method", connector.getResultData("PayMethod"));
			    payInfo.set("mid", connector.getResultData("MID"));
			    payInfo.set("tid", connector.getResultData("TID"));
			    payInfo.set("auth_date", connector.getResultData("AuthDate"));
			    payInfo.set("state_cd", connector.getResultData("StateCD"));
			    payInfo.set("van_code", connector.getResultData("VanCode"));
			    payInfo.set("smile_cash", connector.getResultData("SmileCash"));

			    if (!resultCode.equals("2001")) {
                 	System.out.println(orderid + "smilepay 2001");
                	Utils.sendMessage(out, "결제중 오류가 발생했지만 승인취소가 정상적으로 처리되지 않았습니다. 관리자에게 문의 하세요.", Env.getURLPath() + "/");
                	return;
			    }
			    System.out.println(orderid + "smilepay 결제 중 오류가 발생했습니다. (DB Transaction Fail) " + param.get("pay_type"));
            	Utils.sendMessage(out, "결제 중 오류가 발생했습니다. (DB Transaction Fail) " + param.get("pay_type"), Env.getURLPath() + "/");
            	return;
	    	}
	    }
	    else{
        	System.out.println(orderid + "-------- smilepay 결제가 실패하였습니다.(" + payInfo.get("result_code") + " : " + payInfo.get("result_msg") + ")");
        	Utils.sendMessage(out, "결제가 실패하였습니다.(" + payInfo.get("result_code") + " : " + payInfo.get("result_msg") + ")", Env.getURLPath() + "/");
        	return;
	    }
	} else if("007".equals(param.get("pay_type"))) {	// 카카오페이2
	    Param p = new Param();
	    p.set("tid", SecurityUtils.decodeAES(param.get("tid")));
	    p.set("partner_order_id", orderid);
	    p.set("partner_user_id", userid);
		p.set("pg_token", param.get("pg_token"));
	    KakaopayUtil kakao = new KakaopayUtil();
	    JSONObject json = kakao.approve(p);
	    int responseCode = (Integer) json.get("response_code");
	    
	    if(responseCode == 200) {	// 결제성공
	    	Param payInfo = new Param();
			payInfo.set("orderid", 				orderid);
			payInfo.set("aid", 					json.get("aid"));
			payInfo.set("tid", 					json.get("tid"));
			payInfo.set("cid", 					json.get("cid"));
			payInfo.set("sid", 					json.get("sid"));
			payInfo.set("partner_order_id", 	json.get("partner_order_id"));
			payInfo.set("partner_user_id", 		json.get("partner_user_id"));
			payInfo.set("payment_method_type",	json.get("payment_method_type"));
			payInfo.set("item_name", 			json.get("item_name"));
			payInfo.set("item_code", 			json.get("item_code"));
			payInfo.set("quantity", 			json.get("quantity"));
			payInfo.set("created_at", 			json.get("created_at"));
			payInfo.set("approved_at", 			json.get("approved_at"));
			payInfo.set("payload", 				json.get("payload"));
			
			JSONObject amt = (JSONObject) json.get("amount");
			payInfo.set("amount", 	amt.toJSONString());
			payInfo.set("total",	amt.get("total"));
			payInfo.set("tax_free",	amt.get("tax_free"));

			JSONObject card = (JSONObject) json.get("card_info");
			payInfo.set("card_info",	(card == null ? null : card.toJSONString()));

			try {
				if(param.getInt("LGD_AMOUNT") != Integer.parseInt(payInfo.get("total"))) {
					throw new Exception("결제금액 상이");
				}
				order.create(request, response, payInfo);
	    	}
	    	catch(Exception e) {
	    		e.printStackTrace();
	    		
	    		// 결제 취소
	    		p = new Param();
	    		p.set("cid",					json.get("cid"));
	    		p.set("tid",					json.get("tid"));
	    		p.set("cancel_amount",			amt.get("total"));
	    		p.set("cancel_tax_free_amount",	amt.get("tax_free"));
	    		
	    		json = kakao.cancel(p);
	    		responseCode = (Integer) json.get("response_code");
			    if(responseCode != 200) {
                 	System.out.println(orderid + " : " + json.toJSONString());
                	Utils.sendMessage(out, "결제중 오류가 발생했지만 승인취소가 정상적으로 처리되지 않았습니다. 관리자에게 문의 하세요.", Env.getURLPath() + "/");
                	return;
			    }

			    System.out.println(orderid + "kakao 결제 중 오류가 발생했습니다. (DB Transaction Fail) " + param.get("pay_type"));
            	Utils.sendMessage(out, "결제 중 오류가 발생했습니다. (DB Transaction Fail) " + param.get("pay_type"), Env.getURLPath() + "/");
            	return;
	    		
	    	}
	    } else {
        	System.out.println(orderid + "-------- kakao 결제가 실패하였습니다.(" + json.get("result_code") + " : " + json.get("result_msg"));
        	Utils.sendMessage(out, "결제가 실패하였습니다.(" + json.get("result_code") + " : " + json.get("result_msg"), Env.getURLPath() + "/");
        	return;
	    }
	} else if("006".equals(param.get("pay_type"))) {	// 페이코
		ObjectMapper mapper = new ObjectMapper();
		PaycoUtil    util   = new PaycoUtil(serverType);
		
		Boolean doCancel    = false;
		String cancelMsg	= "";
		String orderCertifyKey = "";
		String orderNo = "";
		
		Map<String,Object> sendMap = new HashMap<String,Object>(); 
		sendMap.put("sellerKey", sellerKey);
		sendMap.put("reserveOrderNo", param.get("reserveOrderNo"));
		sendMap.put("sellerOrderReferenceKey", param.get("sellerOrderReferenceKey"));
		sendMap.put("paymentCertifyToken", param.get("paymentCertifyToken"));
		sendMap.put("totalPaymentAmt", param.get("LGD_AMOUNT"));
		/* payco 결제승인 API 호출 */
		String json = util.payco_approval(sendMap,logYn);
		
		// jackson Tree 이용
		JsonNode node = mapper.readTree(json);
		String msg = node.path("message").textValue();
		String code = node.path("code").toString();
		
		if(code.equals("0")){
			// 예시
			try{
				/* 결제승인 후 리턴된 데이터 중 필요한 정보를 추출하여
				 * 가맹점 에서 필요한 작업을 실시합니다.(예 주문서 작성 등..)
				 * 결제연동시 리턴되는 PAYCO주문번호(orderNo)와 주문인증키(orderCertifyKey)에 대해 
				 * 가맹점 DB 저장이 필요합니다.
				 */
				JsonNode result = mapper.readTree(node.path("result").toString());
				System.out.println(orderid + "-------- payco : " + result);
				Param payInfo = new Param();
				payInfo.set("seller_order_reference_key",		result.path("sellerOrderReferenceKey").textValue());
				payInfo.set("reserve_order_no",					result.path("reserveOrderNo").textValue());
				payInfo.set("order_no",							result.path("orderNo").textValue());
				payInfo.set("member_name", 						result.path("memberName").textValue());
				payInfo.set("member_email",				 		result.path("memberEmail").textValue());
				payInfo.set("order_channel", 					result.path("orderChannel").textValue());
				payInfo.set("total_order_amt", 					result.path("totalOrderAmt").intValue());
				payInfo.set("total_delivery_fee_amt",			result.path("totalDeliveryFeeAmt").intValue());
				payInfo.set("total_remote_area_delivery_amt", 	result.path("totalRemoteAreaDeliveryAmt").intValue());
				payInfo.set("total_payment_amt", 				result.path("totalPaymentAmt").intValue());
				payInfo.set("payment_completion_yn", 			result.path("paymentCompletionYn").textValue());
				payInfo.set("delivery_place", 					result.path("deliveryPlace").textValue());
				payInfo.set("order_products", 					result.path("orderProducts").toString());
				payInfo.set("payment_details", 					result.path("paymentDetails").toString());
				payInfo.set("order_certify_key", 				result.path("orderCertifyKey").textValue());
				payInfo.set("code", 							code);
				payInfo.set("message", 							msg);
				
				orderNo = result.path("orderNo").textValue();
				orderCertifyKey = result.path("orderCertifyKey").textValue();
        	
				// 현대카드 프로모션 체크
				if(existsHyundaiCardPid) {
					JsonNode paymentDetail = mapper.readTree(payInfo.get("payment_details"));
					String cardNo = "";
					for(int i = 0; i < paymentDetail.size(); i++) {
						JsonNode cardSettleInfo = paymentDetail.get(i).path("cardSettleInfo");
						String c = cardSettleInfo.path("cardNo").textValue();
						if(!"".equals(c)) cardNo = c;
					}
					System.out.println(orderid + "+++++++++ payco cardNo : " + cardNo);
					if("".equals(cardNo) || !SanghafarmUtils.isHyundaiPromotionCard(cardNo.substring(0, 6))) {
// 						cancelMsg = "현대카드 블랙/퍼플 전용 할인 상품이 있습니다.\\n해당 카드로 주문하셔야 합니다.\\n결제를 취소합니다.";
						cancelMsg = "현대카드 프로모션 상품으로 the Black, the Purple카드 결제 시 20% 할인 혜택이 제공됩니다. 그 외 카드 결제 시 승인 후 자동 취소됩니다.";
						doCancel = true;
					}
				}

				if(param.getInt("LGD_AMOUNT") != Integer.parseInt(payInfo.get("total_payment_amt"))) {
					throw new Exception("결제금액 상이");
				}
				
				if(!doCancel) {
					order.create(request, response, payInfo);
				}
			}catch(Exception e){
				e.printStackTrace();
				doCancel = true;
			}
		}else{
        	Utils.sendMessage(out, "결제가 실패하였습니다.(" + code + " : " + msg, Env.getURLPath() + "/");
			return;
		}
		
		if(doCancel){
			/*★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
			#  PAYCO 결제 승인이 완료되고 아래와 같은 상황이 발생하였을경우 예외 처리가 필요합니다.
			1. 가맹점 DB 처리중 오류 발생시
			2. 통신 장애로 인하여 결과를 리턴받지 못했을 경우
			
			위와 같은 상황이 발생하였을 경우 이미 승인 완료된 주문건에 대하여 주문 취소처리(전체취소)가 필요합니다.
			 - PAYCO에서는 주문승인(결제완료) 처리 되었으나 가맹점은 해당 주문서가 없는 경우가 발생
			 - PAYCO에서는 승인 완료된 상태이므로 주문 상세정보 API를 이용해 결제정보를
			   조회하여 취소요청 파라미터에 셋팅합니다.
			★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★*/
			
			/*
			// 결제상세 조회 필수값 셋팅 
			Map<String, Object> verifyPaymentMap = new HashMap<String, Object>();
			verifyPaymentMap.put("sellerKey", sellerKey);
			verifyPaymentMap.put("reserveOrderNo", orderid);						// 주문예약번호
			verifyPaymentMap.put("sellerOrderReferenceKey", orderid);	// 가맹점주문연동키
			
			// 결제상세 조회 API 호출
			String verifyPaymentResult = util.payco_verifyPayment(verifyPaymentMap, logYn);
			
			// jackson Tree 이용
			JsonNode verifyPayment_node = mapper.readTree(verifyPaymentResult);
			
			String cancel_orderNo		  = verifyPayment_node.path("result").get("orderNo").textValue(); 
			String cancel_orderCertifyKey = verifyPayment_node.path("result").get("orderCertifyKey").textValue();
			String cancel_cancelTotalAmt  = verifyPayment_node.path("result").get("totalPaymentAmt").toString();
			
			// 설정한 주문취소 정보로 Json String 을 작성합니다.
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("sellerKey", sellerKey);										//[필수]가맹점 코드
			params.put("orderNo", cancel_orderNo);									//[필수]주문번호
			params.put("orderCertifyKey", cancel_orderCertifyKey);					//[필수]주문인증 key
			params.put("cancelTotalAmt", Integer.parseInt(cancel_cancelTotalAmt));  	//[필수]취소할 총 금액(전체취소, 부분취소 전부다)
			*/
			
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("sellerKey", sellerKey);										//[필수]가맹점 코드
			params.put("orderNo", orderNo);									//[필수]주문번호
			params.put("orderCertifyKey", orderCertifyKey);					//[필수]주문인증 key
			params.put("cancelTotalAmt", param.getInt("LGD_AMOUNT"));  	//[필수]취소할 총 금액(전체취소, 부분취소 전부다)

			/* 주문 결제 취소 API 호출 */
			String cancelResult = util.payco_cancel(params,logYn,"Y");
			
			JsonNode cancelNode = mapper.readTree(cancelResult);
			
			if(!"".equals(cancelMsg)) {
				Utils.sendMessage(out, cancelMsg, Env.getURLPath() + (!"P".equals(deviceType) ? "/mobile" : "") + "/order/cart.jsp");
				return;
			} else if(!cancelNode.path("code").toString().equals("0")){
				Utils.sendMessage(out, "결제 중 오류가 발생했습니다. (DB Transaction Fail)", Env.getURLPath() + "/");
				return;
			}
		}
		
	} else {	// UPLUS
		// 현대카드 체크
// 		if("001,004".indexOf(param.get("pay_type")) != -1 && existsHyundaiCardPid && !SanghafarmUtils.isHyundaiPromotionCard(param.get("LGD_CARDPREFIX"))) {
		if(existsHyundaiCardPid && !SanghafarmUtils.isHyundaiPromotionCard(param.get("LGD_CARDPREFIX"))) {
// 			Utils.sendMessage(out, "현대카드 블랙/퍼플 전용 할인 상품이 있습니다.\\n해당 카드로 주문하셔야 합니다.\\n결제를 취소합니다.", Env.getURLPath() + (!"P".equals(deviceType) ? "/mobile" : "") + "/order/cart.jsp");
			Utils.sendMessage(out, "현대카드 프로모션 상품으로 the Black, the Purple카드 결제 시 20% 할인 혜택이 제공됩니다. 그 외 카드 결제 시 승인 후 자동 취소됩니다.", Env.getURLPath() + (!"P".equals(deviceType) ? "/mobile" : "") + "/order/cart.jsp");
			return;
		}
		
	    /*
	     * [최종결제요청 페이지(STEP2-2)]
	     *
	     * LG유플러스으로 부터 내려받은 LGD_PAYKEY(인증Key)를 가지고 최종 결제요청.(파라미터 전달시 POST를 사용하세요)
	     */
	
		/* ※ 중요
		* 환경설정 파일의 경우 반드시 외부에서 접근이 가능한 경로에 두시면 안됩니다.
		* 해당 환경파일이 외부에 노출이 되는 경우 해킹의 위험이 존재하므로 반드시 외부에서 접근이 불가능한 경로에 두시기 바랍니다. 
		* 예) [Window 계열] C:\inetpub\wwwroot\lgdacom ==> 절대불가(웹 디렉토리)
		*/
		
	//     String configPath = getServletContext().getRealPath(Config.get("lgdacom.config")) + File.separator + SystemChecker.getCurrentName().toLowerCase();  //LG유플러스에서 제공한 환경파일("/conf/lgdacom.conf,/conf/mall.conf") 위치 지정.
		String configPath = Env.getDocRoot() + Config.get("lgdacom.config") + SystemChecker.getCurrentName().toLowerCase();
		System.out.println(orderid + "============= LGD configPath : " + configPath);
	
	    /*
	     *************************************************
	     * 1.최종결제 요청 - BEGIN
	     *  (단, 최종 금액체크를 원하시는 경우 금액체크 부분 주석을 제거 하시면 됩니다.)
	     *************************************************
	     */
	    
	    String CST_PLATFORM                 = request.getParameter("CST_PLATFORM");
	    String CST_MID                      = request.getParameter("CST_MID");
	    String LGD_MID                      = ("test".equals(CST_PLATFORM.trim())?"t":"")+CST_MID;
	    String LGD_PAYKEY                   = request.getParameter("LGD_PAYKEY");
	
	    //해당 API를 사용하기 위해 WEB-INF/lib/XPayClient.jar 를 Classpath 로 등록하셔야 합니다. 
	    XPayClient xpay = new XPayClient();
	   	boolean isInitOK = xpay.Init(configPath, CST_PLATFORM);   	
	
	   	if( !isInitOK ) {
	    	//API 초기화 실패 화면처리
	        System.out.println(orderid +  "결제요청을 초기화 하는데 실패하였습니다.<br>");
	    	Utils.sendMessage(out, "결제요청이 실패하였습니다. -1", Env.getURLPath() + "/");
	        return;
	   	
	   	}else{      
	   		try{
	   			/*
	   	   	     *************************************************
	   	   	     * 1.최종결제 요청(수정하지 마세요) - END
	   	   	     *************************************************
	   	   	     */
		    	xpay.Init_TX(LGD_MID);
		    	xpay.Set("LGD_TXNAME", "PaymentByKey");
		    	xpay.Set("LGD_PAYKEY", LGD_PAYKEY);
		    
		    	//금액을 체크하시기 원하는 경우 아래 주석을 풀어서 이용하십시요.
		    	//String DB_AMOUNT = "DB나 세션에서 가져온 금액"; //반드시 위변조가 불가능한 곳(DB나 세션)에서 금액을 가져오십시요.
	 	    	xpay.Set("LGD_AMOUNTCHECKYN", "Y");
	 	    	xpay.Set("LGD_AMOUNT", param.get("LGD_AMOUNT"));
		    
	    	}catch(Exception e) {
	    		System.out.println(orderid + "sanghafarmshop ------------- LG유플러스 제공 API를 사용할 수 없습니다. 환경파일 설정을 확인해 주시기 바랍니다. ");
	    		System.out.println(orderid + " " + e.getMessage());    	
	        	Utils.sendMessage(out, "결제요청이 실패하였습니다. -2", Env.getURLPath() + "/");
	    		return;
	    	}
	   	}
	
	    /*
	     * 2. 최종결제 요청 결과처리
	     *
	     * 최종 결제요청 결과 리턴 파라미터는 연동메뉴얼을 참고하시기 바랍니다.
	     */
	     if ( xpay.TX() ) {
	         //1)결제결과 화면처리(성공,실패 결과 처리를 하시기 바랍니다.)
	         System.out.println(orderid + "sanghafarmshop ------------- 결제요청이 완료되었습니다.  <br>");
	         System.out.println(orderid + "TX 결제요청 Response_code = " + xpay.m_szResCode + "<br>");
	         System.out.println(orderid + "TX 결제요청 Response_msg = " + xpay.m_szResMsg + "<p>");
	         
	         System.out.println(orderid + "거래번호 : " + xpay.Response("LGD_TID",0) + "<br>");
	         System.out.println(orderid + "상점아이디 : " + xpay.Response("LGD_MID",0) + "<br>");
	         System.out.println(orderid + "상점주문번호 : " + xpay.Response("LGD_OID",0) + "<br>");
	         System.out.println(orderid + "결제금액 : " + xpay.Response("LGD_AMOUNT",0) + "<br>");
	         System.out.println(orderid + "결과코드 : " + xpay.Response("LGD_RESPCODE",0) + "<br>");
	         System.out.println(orderid + "결과메세지 : " + xpay.Response("LGD_RESPMSG",0) + "<p>");
	         
	         Param lgdInfo = new Param();
	         for (int i = 0; i < xpay.ResponseNameCount(); i++)
	         {
	             System.out.println(orderid + " : " + xpay.ResponseName(i) + " = ");
	             for (int j = 0; j < xpay.ResponseCount(); j++)
	             {
	                 System.out.println("\t" + xpay.Response(xpay.ResponseName(i), j) + "<br>");
	                 if(j == 0) {
	                	 lgdInfo.set(xpay.ResponseName(i).toLowerCase(), xpay.Response(xpay.ResponseName(i), j));
	                 }
	             }
	         }
	         System.out.println("<p>");
	         
	         if( "0000".equals( xpay.m_szResCode ) ) {
	         	//최종결제요청 결과 성공 DB처리
	         	System.out.println(orderid + "sanghafarmshop ------------- 최종결제요청 결과 성공 DB처리하시기 바랍니다.<br>");
	         	//최종결제요청 결과 성공 DB처리 실패시 Rollback 처리
	         	boolean isDBOK = true; //DB처리 실패시 false로 변경해 주세요.
	
	         	try {
					if(param.getInt("LGD_AMOUNT") != Integer.parseInt(lgdInfo.get("lgd_amount"))) {
						throw new Exception("결제금액 상이");
					}

					order.create(request, response, lgdInfo);
	         	} catch(Exception e) {
	             	System.out.println(orderid + "sanghafarmshop orderProc.jsp ------------- " + e.toString());
	         		e.printStackTrace();
	         		isDBOK = false;
	         	}
	         	
	         	if( !isDBOK ) {
	         		xpay.Rollback("상점 DB처리 실패로 인하여 Rollback 처리 [TID:" +xpay.Response("LGD_TID",0)+",MID:" + xpay.Response("LGD_MID",0)+",OID:"+xpay.Response("LGD_OID",0)+"]");
	         		
	                 System.out.println(orderid + "sanghafarmshop ------------- TX Rollback Response_code = " + xpay.Response("LGD_RESPCODE",0) + "<br>");
	                 System.out.println(orderid + "sanghafarmshop ------------- TX Rollback Response_msg = " + xpay.Response("LGD_RESPMSG",0) + "<p>");
	         		
	                 if( "0000".equals( xpay.m_szResCode ) ) {
	                 	System.out.println(orderid + "sanghafarmshop ------------- 자동취소가 정상적으로 완료 되었습니다.<br>");
	                	Utils.sendMessage(out, "결제 중 오류가 발생했습니다. (DB Transaction Fail) " + param.get("pay_type"), Env.getURLPath() + "/");
	                	return;
	                 }else{
	         			System.out.println(orderid + "sanghafarmshop ------------- 자동취소가 정상적으로 처리되지 않았습니다.<br>");
	                	Utils.sendMessage(out, "결제중 오류가 발생했지만 승인취소가 정상적으로 처리되지 않았습니다. 관리자에게 문의 하세요.", Env.getURLPath() + "/");
	         	    	return;
	                 }
	         	}
	         	
	         }else{
	         	//최종결제요청 결과 실패 DB처리
	         	System.out.println(orderid + "sanghafarmshop ------------- 최종결제요청 결과 실패 DB처리하시기 바랍니다.");            	
		        System.out.println(orderid + "sanghafarmshop ------------- TX 결제요청 Response_code = " + xpay.m_szResCode + "<br>");
		        System.out.println(orderid + "sanghafarmshop ------------- TX 결제요청 Response_msg = " + xpay.m_szResMsg + "<p>");
	        	Utils.sendMessage(out, "결제요청이 실패하였습니다. -5", Env.getURLPath() + "/");
	        	return;
	         }
	     }else {
	         //2)API 요청실패 화면처리
	         System.out.println(orderid + "sanghafarmshop ------------- 결제요청이 실패하였습니다.  <br>");
	         System.out.println(orderid + "sanghafarmshop ------------- TX 결제요청 Response_code = " + xpay.m_szResCode + "<br>");
	         System.out.println(orderid + "sanghafarmshop ------------- TX 결제요청 Response_msg = " + xpay.m_szResMsg + "<p>");
	         
	     	//최종결제요청 결과 실패 DB처리
	     	System.out.println(orderid + "sanghafarmshop ------------- 최종결제요청 결과 실패 DB처리하시기 바랍니다.<br>");            	            
	    	Utils.sendMessage(out, "결제요청이 실패하였습니다. -6", Env.getURLPath() + "/");
	    	return;
	     }
	}

	// 현금영수증 처리
	System.out.println(orderid + "################################## -------------- cashreceipt");
	if(giftcardAmt > 0 && !"".equals(param.get("LGD_CASHRECEIPTUSE"))) {
		System.out.println(orderid + "################################## -------------- cashreceipt2");
		try {
			String configPath = Env.getDocRoot() + Config.get("lgdacom.config") + SystemChecker.getCurrentName().toLowerCase();
			String CST_PLATFORM                 = SystemChecker.isReal() ? "service" : "test";
			String CST_MID                      = Config.get("lgdacom.CST_MID");
			String LGD_MID                      = ("test".equals(CST_PLATFORM.trim())?"t":"")+CST_MID;
		    
		    XPayClient xpay = new XPayClient();
		    xpay.Init(configPath, CST_PLATFORM);
		    xpay.Init_TX(LGD_MID);
		    xpay.Set("LGD_TXNAME", "CashReceipt");
		    xpay.Set("LGD_METHOD", "AUTH");
		    xpay.Set("LGD_PAYTYPE", "SC0100");
	    	xpay.Set("LGD_OID", orderid);
	    	xpay.Set("LGD_CUSTOM_MERTNAME", "상하농원");
	     	xpay.Set("LGD_CUSTOM_BUSINESSNUM", "4158600211");
	    	xpay.Set("LGD_CASHCARDNUM", param.get("LGD_CASHCARDNUM"));
			xpay.Set("LGD_AMOUNT", giftcardAmt + "");
	    	xpay.Set("LGD_CASHRECEIPTUSE", param.get("LGD_CASHRECEIPTUSE"));
    		xpay.Set("LGD_PRODUCTINFO", param.get("LGD_PRODUCTINFO"));

    	    if (xpay.TX()) {
    	        //1)현금영수증 발급/취소결과 화면처리(성공,실패 결과 처리를 하시기 바랍니다.)
    	        System.out.println(orderid + "현금영수증 발급/취소 요청처리가 완료되었습니다.  <br>");
    	        System.out.println(orderid + "TX Response_code = " + xpay.m_szResCode + "<br>");
    	        System.out.println(orderid + "TX Response_msg = " + xpay.m_szResMsg + "<p>");
    	        
    	        System.out.println(orderid + "응답코드 : " + xpay.Response("LGD_RESPCODE",0) + "<br>");
    	        System.out.println(orderid + "응답메세지 : " + xpay.Response("LGD_RESPMSG",0) + "<p>");
    	        System.out.println(orderid + "주문번호 : " + xpay.Response("LGD_OID",0) + "<br>");
    	        System.out.println(orderid + "거래번호 : " + xpay.Response("LGD_TID",0) + "<br>");
    	        System.out.println(orderid + "현금영수증 거래번호 : " + xpay.Response("LGD_CASHRECEIPTNUM",0) + "<br>");
    	        System.out.println(orderid + "발급일시 : " + xpay.Response("LGD_RESPDATE",0) + "<br>");
    	        
    	        for (int i = 0; i < xpay.ResponseNameCount(); i++) {
    	        	System.out.println(xpay.ResponseName(i) + " = ");
    	            for (int j = 0; j < xpay.ResponseCount(); j++) {
    	            	System.out.println(xpay.Response(xpay.ResponseName(i), j) + "<br>");
    	            }
    	        }
    	        
    	        Param p = new Param();
    	        p.set("lgd_method", "AUTH");
    	        p.set("lgd_respcode", xpay.Response("LGD_RESPCODE",0));
    	        p.set("lgd_respmsg", xpay.Response("LGD_RESPMSG",0));
    	        p.set("lgd_oid", xpay.Response("LGD_OID",0));
    	        p.set("lgd_tid", xpay.Response("LGD_TID",0));
    	        p.set("lgd_cashreceiptnum", xpay.Response("LGD_CASHRECEIPTNUM",0));
    	        p.set("lgd_respdate", xpay.Response("LGD_RESPDATE",0));
    	        p.set("lgd_amount", giftcardAmt);
    	        p.set("lgd_cashcardnum", param.get("LGD_CASHCARDNUM"));
    	       	p.set("lgd_cashreceiptuse", param.get("LGD_CASHRECEIPTUSE"));
	    	        
				order.createLgdCashreceiptLog(p);
    	    } else {
    	        //2)API 요청 실패 화면처리
    	    	System.out.println(orderid + "현금영수증 발급/취소 요청처리가 실패되었습니다.  <br>");
    	    	System.out.println(orderid + "TX Response_code = " + xpay.m_szResCode + "<br>");
    	    	System.out.println(orderid + "TX Response_msg = " + xpay.m_szResMsg);
    	    }
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	/*
	try {
		TmsUtil tms = new TmsUtil();
		tms.sendOrderSms(orderid, 1);
	} catch(Exception e) {
		e.printStackTrace();
	}
	*/

	try {
		ImcService imc = (new ImcService()).toProxyInstance();
// 		imc.sendOrderTalk(orderid, 1);
		imc.sendOrderTalk(orderid, 1, param.get("delivery_type"));
	} catch(Exception e) {
		e.printStackTrace();
	}
	
	String nextUrl = Env.getURLPath();
	if(!"P".equals(deviceType)) nextUrl += "/mobile";
	nextUrl += "/order/complete.jsp";
%>
<form name="orderForm" id="orderForm" action="<%= nextUrl %>" method="POST">
	<input type="hidden" name="orderid" value="<%= param.get("orderid") %>" />
</form>

<script>
document.getElementById("orderForm").submit();
</script>
