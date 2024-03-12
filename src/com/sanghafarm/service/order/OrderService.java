package com.sanghafarm.service.order;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

import com.efusioni.stone.annotation.Transactionable;
import com.efusioni.stone.common.Config;
import com.efusioni.stone.common.SystemChecker;
import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.FileUploader;
import com.efusioni.stone.utils.FileUploaderException;
import com.efusioni.stone.utils.Param;
import com.efusioni.stone.utils.Utils;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sanghafarm.common.Env;
import com.sanghafarm.common.FrontSession;
import com.sanghafarm.exception.OrderError;
import com.sanghafarm.service.member.FamilyMemberService;
import com.sanghafarm.service.member.ImMemberService;
import com.sanghafarm.service.member.MemberService;
import com.sanghafarm.utils.KakaopayUtil;
import com.sanghafarm.utils.NaverPayUtil;
import com.sanghafarm.utils.PaycoUtil;
import com.sanghafarm.utils.SanghafarmUtils;
import com.sanghafarm.utils.SmilepayUtil;

import kr.co.lgcns.module.lite.CnsPayWebConnector;
import kr.co.lgcns.module.lite.CnsPayWebConnector4NS;
import lgdacom.XPayClient.XPayClient;

public class OrderService extends IbatisService {
	
	private static String[] NOT_ACCEPTABLE_EXT = {
			"html", "htm", "js", "css", "jsp", "exe", "bat", "sh"
	};

	private static String[] ACCEPTABLE_FILE_EXT = {
		"jpg", "jpeg", "gif", "png"
	};

	public String getNewId() {
		return (String) super._scalar("Order.getNewId");
	}
	
	public void create(HttpServletRequest request, HttpServletResponse response) throws Exception {
		create(request, response, null);
	}
	
	@Transactionable
	public void create(HttpServletRequest request, HttpServletResponse response, Param payInfo) throws Exception {
		createOrderCart(request, response);
		createOrder(request, response, payInfo);
		
		Param param = new Param(request);
		
		if(payInfo != null) {	// LGD 로그
			if("005".equals(param.get("pay_type"))) {	// 카카오페이
				super._insert("Order.insertKakaoPayLog", payInfo);
			} else if("006".equals(param.get("pay_type"))) {	// 페이코
				super._insert("Order.insertPaycoLog", payInfo);
			} else if("007".equals(param.get("pay_type"))) {	// 카카오페이2
				super._insert("Order.insertKakaoPay2Log", payInfo);
			} else if("008".equals(param.get("pay_type"))) {	// 스마일페이
				super._insert("Order.insertSmilePayLog", payInfo);
			} else if("009".equals(param.get("pay_type"))) {	// 네이버페이
				super._insert("Order.insertNaverPayLog", payInfo);
			} else {
				super._insert("Order.insertLgdPaymentLog", payInfo);
			}
		}
	}
	
	@Transactionable
	public void createOrderCart(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Param param = new Param(request);
		FrontSession fs = FrontSession.getInstance(request, response);
		CartService cart = (new CartService()).toProxyInstance();
//		CouponService coupon = (new CouponService()).toProxyInstance();
		
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

		// 일반상품
		for(Param row : list1) {
			int applyPrice = 0;
			int couponSaleAmt = 0;
			int salePrice = row.getInt("sale_price") * row.getInt("qty");

			// 쿠폰
			/*
			if(!"".equals(param.get("mem_couponid_" + row.get("cartid")))) {
				Param c = coupon.getMemCouponInfo(param.get("mem_couponid_" + row.get("cartid")));
				if("A".equals(c.get("sale_type"))) {	//  정량
					couponSaleAmt = c.getInt("sale_amt");
				} else {	// 정률
					couponSaleAmt = (c.getInt("max_sale") <= (salePrice * c.getInt("sale_amt") / 100)) ? 
							c.getInt("max_sale") : (salePrice * c.getInt("sale_amt") / 100);
				}
			}
			*/
			
			applyPrice = salePrice - couponSaleAmt;
			
			row.set("sale_price", salePrice);
			row.set("apply_price", applyPrice);
			row.set("coupon_sale_amt", couponSaleAmt);
			row.set("routine_sale_amt", "0");
			row.set("orderid", param.get("orderid"));
			row.set("mem_couponid", param.get("mem_couponid_" + row.get("cartid")));
			
			super._insert("Order.insertOrderCart", row);
		}	

		// 산지직송 상품
		for(Param row : list2) {
			int applyPrice = 0;
			int couponSaleAmt = 0;
			int salePrice = row.getInt("sale_price") * row.getInt("qty");

			// 쿠폰
			/*
			if(!"".equals(param.get("mem_couponid_" + row.get("cartid")))) {
				Param c = coupon.getMemCouponInfo(param.get("mem_couponid_" + row.get("cartid")));
				if("A".equals(c.get("sale_type"))) {	//  정량
					couponSaleAmt = c.getInt("sale_amt");
				} else {	// 정률
					couponSaleAmt = (c.getInt("max_sale") <= (salePrice * c.getInt("sale_amt") / 100)) ? 
							c.getInt("max_sale") : (salePrice * c.getInt("sale_amt") / 100);
				}
			}
			*/
			
			applyPrice = salePrice - couponSaleAmt;
			
			row.set("sale_price", salePrice);
			row.set("apply_price", applyPrice);
			row.set("coupon_sale_amt", couponSaleAmt);
			row.set("routine_sale_amt", "0");
			row.set("orderid", param.get("orderid"));
			row.set("mem_couponid", param.get("mem_couponid_" + row.get("cartid")));
			
			super._insert("Order.insertOrderCart", row);
		}	

		// 정기배송 상품
		for(Param row : list3) {
			int applyPrice = 0;
			int routineSaleAmt = 0;
			int couponSaleAmt = 0;
			int salePrice = row.getInt("sale_price") * row.getInt("qty") * row.getInt("routine_cnt");

			if("A".equals(row.get("routine_sale_type"))) {
				routineSaleAmt = row.getInt("routine_sale_amt") * row.getInt("qty") * row.getInt("routine_cnt");
				
			} else {
				routineSaleAmt = row.getInt("sale_price") * row.getInt("qty") * row.getInt("routine_cnt") * row.getInt("routine_sale_amt") / 100;
			}
			
			// 쿠폰
			/*
			if(!"".equals(param.get("mem_couponid_" + row.get("cartid")))) {
				Param c = coupon.getMemCouponInfo(param.get("mem_couponid_" + row.get("cartid")));
				if("A".equals(c.get("sale_type"))) {	//  정량
					couponSaleAmt = c.getInt("sale_amt");
				} else {	// 정률
					couponSaleAmt = (c.getInt("max_sale") <= ((salePrice - routineSaleAmt) * c.getInt("sale_amt") / 100)) ?
							c.getInt("max_sale") : ((salePrice - routineSaleAmt) * c.getInt("sale_amt") / 100);
				}
			}
			*/

			applyPrice = salePrice - routineSaleAmt - couponSaleAmt;
			
			row.set("sale_price", salePrice);
			row.set("apply_price", applyPrice);
			row.set("coupon_sale_amt", couponSaleAmt);
			row.set("routine_sale_amt", routineSaleAmt);
			row.set("orderid", param.get("orderid"));
			row.set("mem_couponid", param.get("mem_couponid_" + row.get("cartid")));
			
//			System.out.println(row);
			super._insert("Order.insertOrderCart", row);
		}
		
		// 배송일 지정 상품
		for(Param row : list4) {
			int applyPrice = 0;
			int couponSaleAmt = 0;
			int salePrice = row.getInt("sale_price") * row.getInt("qty");

			// 쿠폰
			/*
			if(!"".equals(param.get("mem_couponid_" + row.get("cartid")))) {
				Param c = coupon.getMemCouponInfo(param.get("mem_couponid_" + row.get("cartid")));
				if("A".equals(c.get("sale_type"))) {	//  정량
					couponSaleAmt = c.getInt("sale_amt");
				} else {	// 정률
					couponSaleAmt = (c.getInt("max_sale") <= (salePrice * c.getInt("sale_amt") / 100)) ? 
							c.getInt("max_sale") : (salePrice * c.getInt("sale_amt") / 100);
				}
			}
			*/
			
			applyPrice = salePrice - couponSaleAmt;
			
			row.set("sale_price", salePrice);
			row.set("apply_price", applyPrice);
			row.set("coupon_sale_amt", couponSaleAmt);
			row.set("routine_sale_amt", "0");
			row.set("orderid", param.get("orderid"));
			row.set("mem_couponid", param.get("mem_couponid_" + row.get("cartid")));
			
			super._insert("Order.insertOrderCart", row);
		}	
	}
	
	@Transactionable
	public void createOrder(HttpServletRequest request, HttpServletResponse response, Param payInfo) throws Exception {
		FrontSession fs = FrontSession.getInstance(request, response);
		CouponService coupon = (new CouponService()).toProxyInstance();
		ImMemberService immem = (new ImMemberService()).toProxyInstance();
		
		Param param = new Param(request);
		boolean earlyYn = "5".equals(param.get("delivery_type"));
//		param.set("device_type", fs.getDeviceType());
		param.set("email", param.get("email1") + "@" + param.get("email2"));
		param.set("ship_email", param.get("ship_email1") + "@" + param.get("ship_email2"));
		param.set("early_note1", param.get("early_note1") + " " + param.get("early_pw"));

		String orderid = param.get("orderid");
		String status = "003".equals(param.get("pay_type")) ? "110" : "120";
		
		if("006".equals(param.get("pay_type")) && payInfo != null && "N".equals(payInfo.get("payment_completion_yn"))) { // payco 무통장입금
			status = "110";
		}

		if(param.getInt("LGD_AMOUNT") == 0) status = "120";
		
		// 8월 정기배송 특가 상품 코드
		String eventPid = Config.get("evend1.pid." + SystemChecker.getCurrentName());

		int shipSeq = 1;
		int itemSeq = 1;
		
		// 총금액
		int totAmt = 0;
		int totAmt1 = 0;
		int totAmt2 = 0;
		int totAmt3 = 0;
		int totAmt4 = 0;
		
		// 면세금액
		int totTaxFreeAmt = 0;
		
		// 배송비
		int shipAmt = 0;
		int shipAmt1 = 0;
		int shipAmt2 = 0;
		int shipAmt3 = 0;
		int shipAmt4 = 0;

		// 쿠폰할인 총액
		int couponSaleAmt = 0;
		// 정기배송 할인 총액
		int routineSaleAmt = 0;
		// 장바구니 할인
		int couponCartAmt = 0;
		// 배송비 할인
		int couponShipAmt = 0;
		// 포인트
		int pointAmt = Integer.parseInt(param.get("point_amt", "0").replace(",", ""));
		// 기프트카드
		int giftcardAmt = Integer.parseInt(param.get("giftcard_amt", "0").replace(",", ""));
		
		// 장바구니 쿠폰 검증을 위한 상품 리스트
		List<Param> itemList = new ArrayList<Param>();

		// 일반상품
		List<Param> list1 = super._list("Order.getOrderCartList", new Param("orderid", orderid, "routine_yn", "N", "ptype", "A"));
		if(list1 != null && list1.size() > 0) {
			itemSeq = 1;
			for(Param row : list1) {
				totAmt1 += row.getInt("sale_price");
				couponSaleAmt += row.getInt("coupon_sale_amt");
				
				if("N".equals(row.get("tax_yn"))) {
					totTaxFreeAmt += row.getInt("apply_price");
				}

				int unitPrice = row.getInt("apply_price") / row.getInt("qty");
				row.set("orderid", orderid);
				row.set("ship_seq", shipSeq);
				row.set("item_seq", itemSeq++);
				row.set("unit_price", unitPrice);
				
				super._insert("Order.insertItem", row);
				
				// 재고 차감
				super._update("Product.updateStock", new Param("pid", row.get("sub_pid"), "qty", row.get("qty")));

				// 쿠폰사용 등록
				if(!"".equals(row.get("mem_couponid"))) {
					super._update("Coupon.useMemCoupon", row.get("mem_couponid"));
				}
				
				// 장바구니 삭제
				super._delete("Cart.delete", new Param("cartid", row.get("cartid")));
				
				itemList.add(row);
			}
			
			shipAmt1 = totAmt1 >= Config.getInt("shipping.free.amt") ? 0 : Config.getInt("shipping.amt");
			
			param.set("ship_seq", shipSeq++);
			param.set("status", status);
			param.set("delivery_date", "");
//			param.set("delivery_type", "1");	
			param.set("delivery_type", earlyYn ? "5" : "1");
			param.set("ship_amt", shipAmt1);
			
			super._insert("Order.insertShip", param);
			
			param.set("regist_user", fs.getUserId());
			super._insert("Order.insertStatusLog", param);
		}
		
		// 산지직송 상품
		List<Param> list2 = super._list("Order.getOrderCartList", new Param("orderid", orderid, "routine_yn", "N", "ptype", "C"));
		if(list2 != null && list2.size() > 0) {
			itemSeq = 1;
			for(Param row : list2) {
				totAmt2 += row.getInt("sale_price");
				couponSaleAmt += row.getInt("coupon_sale_amt");
				
				if("N".equals(row.get("tax_yn"))) {
					totTaxFreeAmt += row.getInt("apply_price");
				}

				int unitPrice = row.getInt("apply_price") / row.getInt("qty");
				row.set("orderid", orderid);
				row.set("ship_seq", shipSeq);
				row.set("item_seq", itemSeq++);
				row.set("unit_price", unitPrice);
				
				super._insert("Order.insertItem", row);
				
				// 재고 차감
				super._update("Product.updateStock", new Param("pid", row.get("sub_pid"), "qty", row.get("qty")));

				// 쿠폰사용 등록
				if(!"".equals(row.get("mem_couponid"))) {
					super._update("Coupon.useMemCoupon", row.get("mem_couponid"));
				}
				
				// 장바구니 삭제
				super._delete("Cart.delete", new Param("cartid", row.get("cartid")));

				itemList.add(row);
			}
			
			shipAmt2 = totAmt2 >= Config.getInt("shipping.free.amt") ? 0 : Config.getInt("shipping.amt");

			param.set("ship_seq", shipSeq++);
			param.set("status", status);
			param.set("delivery_date", "");
			param.set("delivery_type", "3");
			param.set("ship_amt", shipAmt2);
			
			super._insert("Order.insertShip", param);
			
			param.set("regist_user", fs.getUserId());
			super._insert("Order.insertStatusLog", param);
		}
		
		// 정기배송
		List<Param> list3 = super._list("Order.getOrderCartList", new Param("orderid", orderid, "routine_yn", "Y"));
		for(Param row : list3) {
			itemSeq = 1;

			totAmt3 += row.getInt("sale_price");
			couponSaleAmt += row.getInt("coupon_sale_amt");
			routineSaleAmt += row.getInt("routine_sale_amt");
			
			if("N".equals(row.get("tax_yn"))) {
				totTaxFreeAmt += row.getInt("apply_price");
			}
			
			List<Date> dList = null;
			
			if(eventPid.equals(row.get("sub_pid"))) {
				dList = SanghafarmUtils.getDeliveryDates(row.get("routine_day").split(","), row.getInt("routine_period"), row.getInt("routine_cnt"), "20170803");
			} else {
				dList = SanghafarmUtils.getDeliveryDates(row.get("routine_day").split(","), row.getInt("routine_period"), row.getInt("routine_cnt"));
			}
			
			for(Date d : dList) {
				int unitPrice = row.getInt("apply_price") / row.getInt("routine_cnt") / row.getInt("qty");
				row.set("orderid", orderid);
				row.set("ship_seq", shipSeq);
				row.set("item_seq", itemSeq);
				row.set("unit_price", unitPrice);

				super._insert("Order.insertItem", row);
				
				param.set("ship_seq", shipSeq++);
				param.set("status", status);
				param.set("delivery_date", Utils.getTimeStampString(d, "yyyy.MM.dd"));
//				param.set("delivery_type", "2");
//				param.set("delivery_type", earlyYn ? "6" : "2");
				param.set("delivery_type", "C".equals(row.get("ptype")) ? "2" : (earlyYn ? "6" : "2"));
				param.set("ship_amt", "0");
				
				super._insert("Order.insertShip", param);

				param.set("regist_user", fs.getUserId());
				super._insert("Order.insertStatusLog", param);
			}

			// 재고 차감
			super._update("Product.updateStock", new Param("pid", row.get("sub_pid"), "qty", row.getInt("qty") * row.getInt("routine_cnt")));

			// 쿠폰사용 등록
			if(!"".equals(row.get("mem_couponid"))) {
				super._update("Coupon.useMemCoupon", row.get("mem_couponid"));
			}
			
			// 장바구니 삭제
			super._delete("Cart.delete", new Param("cartid", row.get("cartid")));

			itemList.add(row);
		}
		
		// 배송일 지정 상품
		List<Param> list4 = super._list("Order.getOrderCartList", new Param("orderid", orderid, "routine_yn", "N", "ptype", "D"));
		for(int i = 0; i < list4.size(); i++) {
			Param row = list4.get(i);
			
			totAmt4 += row.getInt("sale_price");
			couponSaleAmt += row.getInt("coupon_sale_amt");
			
			if("N".equals(row.get("tax_yn"))) {
				totTaxFreeAmt += row.getInt("apply_price");
			}

			int unitPrice = row.getInt("apply_price") / row.getInt("qty");
			row.set("orderid", orderid);
			row.set("ship_seq", shipSeq);
			row.set("item_seq", 1);
			row.set("unit_price", unitPrice);
			
			super._insert("Order.insertItem", row);
			
			if(i == list4.size() - 1) {
				shipAmt4 = totAmt4 >= Config.getInt("shipping.free.amt") ? 0 : Config.getInt("shipping.amt");
			}
			
			param.set("ship_seq", shipSeq++);
			param.set("status", status);
			param.set("delivery_date", row.get("delivery_date"));
			param.set("delivery_type", "4");
			param.set("ship_amt", shipAmt4);
			
			super._insert("Order.insertShip", param);
			
			param.set("regist_user", fs.getUserId());
			super._insert("Order.insertStatusLog", param);

			// 재고 차감
			super._update("Product.updateStock", new Param("pid", row.get("sub_pid"), "qty", row.get("qty")));

			// 쿠폰사용 등록
			if(!"".equals(row.get("mem_couponid"))) {
				super._update("Coupon.useMemCoupon", row.get("mem_couponid"));
			}
			
			// 장바구니 삭제
			super._delete("Cart.delete", new Param("cartid", row.get("cartid")));

			itemList.add(row);
		}
			
		totAmt = totAmt1 + totAmt2 + totAmt3 + totAmt4;
		shipAmt = shipAmt1 + shipAmt2 + shipAmt3 + shipAmt4;
		
		/*
		// 장바구니 쿠폰
		if(!"".equals(param.get("mem_couponid_cart"))) {
			Param c = coupon.getMemCouponInfo(param.get("mem_couponid_cart"));
			if("A".equals(c.get("sale_type"))) {	//  정량
				couponCartAmt = c.getInt("sale_amt");
			} else {	// 정률
//				couponCartAmt += (c.getInt("max_sale") <= ((totAmt - routineSaleAmt - couponSaleAmt) * c.getInt("sale_amt") / 100)) ? 
//						c.getInt("max_sale") : ((totAmt - routineSaleAmt - couponSaleAmt) * c.getInt("sale_amt") / 100);
				
				int _totAmt = 0;
				List<Param> exList = coupon.getApplyProductList(new Param("couponid", c.get("couponid"), "ie_code", "E"));
				// 제외상품 처리
				for(Param r : itemList) {
					System.out.println("ItemList : " + r);
					if(exList.size() > 0) {
						boolean isExclude = false;
						for(Param e : exList) {
							if(r.get("sub_pid").equals(e.get("pid"))) {
								isExclude = true;
								break;
							}
						}
						
						if(!isExclude) {
							_totAmt += r.getInt("apply_price");
						}
					} else {
						_totAmt += r.getInt("apply_price");
					}
				}
				System.out.println(orderid + " _totamt : " + _totAmt);
				System.out.println(orderid + " CouponInfo : " + c);
				
				couponCartAmt = (c.getInt("max_sale") <= (_totAmt * c.getInt("sale_amt") / 100)) ? 
					c.getInt("max_sale") : (_totAmt * c.getInt("sale_amt") / 100);
			}
		}
		
		// 배송비 쿠폰
		if(!"".equals(param.get("mem_couponid_ship"))) {
			Param c = coupon.getMemCouponInfo(param.get("mem_couponid_ship"));
			if("A".equals(c.get("sale_type"))) {	//  정량
				couponShipAmt = c.getInt("sale_amt");
			} else {	// 정률
				couponShipAmt += (c.getInt("max_sale") <= (shipAmt * c.getInt("sale_amt") / 100)) ?  c.getInt("max_sale") : (shipAmt * c.getInt("sale_amt") / 100);
			}
		}
		*/
		
		// 쿠폰정보
		Param couponInfo = new Param();
		String memCouponidCart = "";
		String memCouponidShip = "";
		if(!"".equals(param.get("mem_couponid"))) {
			couponInfo = coupon.getInfoByMemCoupon(param.get("mem_couponid"));
			if("001".equals(couponInfo.get("coupon_type"))) {
				couponCartAmt = Integer.parseInt(param.get("coupon_amt").replaceAll(",", ""));
				memCouponidCart = param.get("mem_couponid");
			} else {
				couponShipAmt = Integer.parseInt(param.get("coupon_amt").replaceAll(",", ""));
				memCouponidShip = param.get("mem_couponid");
			}
		}
		
		
		int payAmt = totAmt + shipAmt - couponSaleAmt - couponCartAmt - couponShipAmt - routineSaleAmt - pointAmt - giftcardAmt;
//		if(payAmt < totTaxFreeAmt) totTaxFreeAmt = payAmt;
		
		param.set("userid", fs.getUserId());
		param.set("tot_amt", totAmt);
		param.set("ship_amt", shipAmt);
		param.set("coupon_sale_amt", couponSaleAmt);
		param.set("routine_sale_amt", routineSaleAmt);
		param.set("pay_amt", payAmt);
		param.set("tax_free_amt", totTaxFreeAmt);
		param.set("coupon_cart_amt", couponCartAmt);
		param.set("coupon_ship_amt", couponShipAmt);
		param.set("mem_couponid_cart", memCouponidCart);
		param.set("mem_couponid_ship", memCouponidShip);
		param.set("point_amt", pointAmt);
		param.set("email_yn", param.get("email_yn", "N"));
		param.set("sms_yn", param.get("sms_yn", "N"));
		param.set("giftcard_amt", giftcardAmt);

		/*
		if(!"".equals(param.get("passwd"))) {
			param.set("passwd", SecurityUtils.encodeSHA256(param.get("passwd")));
		}
		*/
		
		super._insert("Order.insertMaster", param);
		
		// 쿠폰사용 등록
		if(!"".equals(param.get("mem_couponid_cart"))) {
			super._update("Coupon.useMemCoupon", param.get("mem_couponid_cart"));
		}
		if(!"".equals(param.get("mem_couponid_ship"))) {
			super._update("Coupon.useMemCoupon", param.get("mem_couponid_ship"));
		}
		
		if(pointAmt > 0) {	// 포인트 차감
			Param p = new Param();
			p.set("trsc_biz_dv_cd", 	"31");
			p.set("trsc_orgn_dv_cd", 	"10");
			p.set("mmb_cert_dv_cd", 	"2");
			p.set("mmb_cert_dv_vlu", 	fs.getUserNo());	
			p.set("tot_sel_amt", 		totAmt);
			p.set("tot_dc_amt", 		couponSaleAmt + couponCartAmt + couponShipAmt + routineSaleAmt + pointAmt);
			p.set("mbrsh_dc_amt", 		0);
			p.set("trsc_rsn_cd", 		"CF01");
			p.set("uniq_rcgn_no", 		orderid);
			p.set("org_apv_dt", 		"");
			p.set("org_apv_no", 		"");
			p.set("org_uniq_rcgn_no", 	"");
			p.set("pint_use_typ_cd", 	"11");
			p.set("use_pint", 			pointAmt);
			p.set("rmk", 				"");
			
			JSONObject json = immem.useMemberPoint(p);
			
			if(!"00000".equals((String) json.get("RES_CD"))) {
				System.out.println(orderid + " use point result : (" + json.get("RES_CD") + ") " + json.get("RES_MSG"));
				throw new OrderError("포인트 사용에 오류가 발생했습니다. (" + json.get("RES_CD") + ") " + json.get("RES_MSG"));
			}

			// 포인트 로그
			p = new Param();
			p.set("orderid", 		orderid);
			p.set("ship_seq", 		"1");
			p.set("trsc_typ_cd", 	json.get("TRSC_TYP_CD"));
			p.set("trsc_biz_dv_cd", json.get("TRSC_BIZ_DV_CD"));
			p.set("coopco_cd", 		json.get("COOPCO_CD"));
			p.set("trsc_dt",		json.get("TRSC_DT"));
			p.set("trsc_hr",		json.get("TRSC_HR"));
			p.set("trc_no",			json.get("TRC_NO"));
			p.set("chnl_typ_cd",	json.get("CHNL_TYP_CD"));
			p.set("apv_dt",			json.get("APV_DT"));
			p.set("apv_no",			json.get("APV_NO"));
			p.set("acml_pint", 		json.get("ACML_PINT"));
			p.set("use_pint", 		json.get("USE_PINT"));
			p.set("rmnd_pint", 		json.get("RMND_PINT"));
			p.set("res_cd", 		json.get("RES_CD"));
			p.set("res_msg", 		json.get("RES_MSG"));
			super._insert("Order.insertPointLog", p);
		}
		
		// 기프트카드 
		if(giftcardAmt > 0) {
			Param p = new Param();
			p.set("trsc_biz_dv_cd", 	"G5");
			p.set("crd_id", 			param.get("giftcard_id"));
			p.set("sale_dv", 			"1");
			p.set("use_amt", 			param.get("giftcard_amt"));
			p.set("tot_sel_amt", 		totAmt + shipAmt);
			p.set("item_nm", 			itemList.get(0).get("pnm"));
			p.set("uniq_rcgn_no", 		orderid);
			p.set("trsc_orgn_dv_cd", 	"10");
			
			JSONObject json = immem.useMemberGiftcard(p);
			
			if(!"00000".equals((String) json.get("RES_CD"))) {
				System.out.println(orderid + " use giftcard result : (" + json.get("RES_CD") + ") " + json.get("RES_MSG"));
				throw new OrderError("기프트카드 사용에 오류가 발생했습니다. (" + json.get("RES_CD") + ") " + json.get("RES_MSG"));
			}

			// 기프트카드 로그
			p = new Param();
			p.set("orderid", 		orderid);
			p.set("ship_seq", 		"1");
			p.set("trsc_typ_cd", 	json.get("TRSC_TYP_CD"));
			p.set("trsc_biz_dv_cd", json.get("TRSC_BIZ_DV_CD"));
			p.set("coopco_cd", 		json.get("COOPCO_CD"));
			p.set("trsc_dt",		json.get("TRSC_DT"));
			p.set("trsc_hr",		json.get("TRSC_HR"));
			p.set("trc_no",			json.get("TRC_NO"));
			p.set("chnl_typ_cd",	json.get("CHNL_TYP_CD"));
			p.set("crd_id",			json.get("CRD_ID"));
			p.set("crd_bal",		json.get("CRD_BAL"));
			p.set("apv_dt",			json.get("APV_DT"));
			p.set("apv_no",			json.get("APV_NO"));
			p.set("res_cd", 		json.get("RES_CD"));
			p.set("res_msg", 		json.get("RES_MSG"));
			super._insert("Order.insertGiftcardLog", p);
		}
		
		/* 2017-10-18 결제수단 저장 */
		try {
			super._update("Member.updatePayType", 
						 	new Param("userid", fs.getUserId(), 
									  "pay_type", "Y".equals(param.get("save_pay_type")) ? param.get("pay_type") : "001"));
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public Param getOrderMasterInfo(String orderid) {
		return super._row("Order.getOrderMaster", new Param("orderid", orderid));
	}

	public Param getOrderShipInfo(String orderid) {
		return getOrderShipInfo(new Param("orderid", orderid));
	}
	
	public Param getOrderShipInfo(Param param) {
		return super._row("Order.getOrderShip", param);
	}
	
	public Param getOrderItemInfo(Param param) {
		return super._row("Order.getOrderItem", param);
	}
	
	public List<Param> getOrderCartList(Param param) {
		return super._list("Order.getOrderCartList", param);
	}
	
	@Transactionable
	public void modifyStatus(Param param) {
		String orderid = param.get("orderid");
		String shipSeq = param.get("ship_seq");
		
		if("".equals(shipSeq)) {
			List<Param> list = super._list("Order.getOrderShip", new Param("orderid", orderid));
			for(Param row : list) {
				row.set("regist_user", param.get("regist_user"));
				row.set("status", param.get("status"));

				super._update("Order.updateStatus", row);
				super._insert("Order.insertStatusLog", row);
			}
		} else {
			super._update("Order.updateStatus", param);
			super._insert("Order.insertStatusLog", param);
		}
	}

	public List<Param> getOrderList(Param param) {
		return super._list("Order.getOrderList", param);
	}

	public Integer getOrderListCount(Param param) {
		return (Integer) super._scalar("Order.getOrderListCount", param);
	}
	
	public List<Param> getOrderListIndexCount(Param param) {
		return super._list("Order.getOrderListIndexCount", param);
	}
	
	@Transactionable
	public void cancelOrder(Param param) {
		param.addPaging(1, Integer.MAX_VALUE);
		param.set("status_type", "1");
		System.out.println("==================================>" + param);
		List<Param> list = getOrderList(param);
		String orderid = param.get("orderid");
		
		Param info = null;
		if(list.size() == 0) {
			throw new OrderError("잘못된 접근입니다.");
		} else {
			info = list.get(0);
			if(!"Y".equals(info.get("is_cancelable"))) {
				throw new OrderError("취소가 불가능한 주문입니다.");
			}
		}

	    /*가상계좌 입급전 취소*/
	    boolean bSettlement = "003".equals(info.get("pay_type")) && "110".equals(info.get("status"));
	    System.out.println(orderid + " ++++++++++++++" + info.get("pay_type") + " : " + info.get("status"));

	    for(Param row : list) {
    		row.set("regist_user", param.get("userid"));
    		row.set("status", "290");
			super._update("Order.updateStatus", row);
			super._insert("Order.insertStatusLog", row);
    	}
		
		// 쿠폰 복원
		super._update("Coupon.resetMemCouponByOrderid", orderid);
		
		// 재고 복원
		List<Param> items = super._list("Order.getOrderItem", new Param("orderid", orderid));
		for(Param item : items) {
			super._update("Product.updateStock", new Param("pid", item.get("sub_pid"), "qty", (item.getInt("qty") * -1)));
		}
		
		if(info.getInt("point_amt") > 0) {	// 포인트 복원
			// 회원정보 검색
			Param memInfo = super._row("Member.getImInfoById", info.get("userid"));
			
			// 포인트 사용 내역
			Param pointInfo = super._row("Order.getPointLogInfo", new Param("orderid", orderid, "trsc_typ_cd", "310", "trsc_biz_dv_cd", "31")); 
					
			Param p = new Param();
			p.set("trsc_biz_dv_cd", "32");
			p.set("trsc_orgn_dv_cd", "10");
			p.set("mmb_cert_dv_cd", "2");
			p.set("mmb_cert_dv_vlu", memInfo.get("unfy_mmb_no"));	
			p.set("trsc_rsn_cd", "CF01");
			p.set("uniq_rcgn_no", orderid);
			p.set("org_apv_dt", pointInfo.get("apv_dt"));
			p.set("org_apv_no", pointInfo.get("apv_no"));
			p.set("org_uniq_rcgn_no", orderid);
			p.set("pint_use_typ_cd", "11");
			p.set("use_pint", info.getInt("point_amt"));
			p.set("rmk", "");
			
			ImMemberService immem = (new ImMemberService()).toProxyInstance();
			JSONObject json = immem.useMemberPoint(p);
			
			// 포인트 로그
			p = new Param();
			p.set("orderid", 		orderid);
			p.set("trsc_typ_cd", 	json.get("TRSC_TYP_CD"));
			p.set("trsc_biz_dv_cd", json.get("TRSC_BIZ_DV_CD"));
			p.set("coopco_cd", 		json.get("COOPCO_CD"));
			p.set("trsc_dt",		json.get("TRSC_DT"));
			p.set("trsc_hr",		json.get("TRSC_HR"));
			p.set("trc_no",			json.get("TRC_NO"));
			p.set("chnl_typ_cd",	json.get("CHNL_TYP_CD"));
			p.set("apv_dt",			json.get("APV_DT"));
			p.set("apv_no",			json.get("APV_NO"));
			p.set("acml_pint", 		json.get("ACML_PINT"));
			p.set("use_pint", 		json.get("USE_PINT"));
			p.set("rmnd_pint", 		json.get("RMND_PINT"));
			p.set("res_cd", 		json.get("RES_CD"));
			p.set("res_msg", 		json.get("RES_MSG"));
			super._insert("Order.insertPointLog", p);
			
			if(!"00000".equals((String) json.get("RES_CD"))) {
				System.out.println(orderid + " use point result : (" + json.get("RES_CD") + ") " + json.get("RES_MSG"));
				throw new OrderError("포인트 복원에 오류가 발생했습니다. (" + json.get("RES_CD") + ") " + json.get("RES_MSG"));
			}
		}

		if(info.getInt("giftcard_amt") > 0) {	// 기프트카드 복원
			// 기프트카드 사용 내역
			Param giftcardInfo = super._row("Order.getGiftcardLogInfo", new Param("orderid", orderid, "trsc_typ_cd", "G41", "trsc_biz_dv_cd", "G5")); 
			int canceledAmt = (int) super._scalar("Order.getGiftcardCancelAmt", orderid);
			
			Param p = new Param();
			p.set("trsc_biz_dv_cd", 	"G6");
			p.set("crd_id", 			info.get("giftcard_id"));
			p.set("sale_dv", 			"2");
			p.set("use_amt", 			(info.getInt("giftcard_amt") - canceledAmt) * -1);
			p.set("tot_sel_amt", 		info.getInt("tot_amt") + info.getInt("ship_amt"));
			p.set("item_nm", 			items.get(0).get("pnm"));
			p.set("org_apv_dt", 		giftcardInfo.get("apv_dt"));
			p.set("org_apv_no", 		giftcardInfo.get("apv_no"));
			p.set("org_uniq_rcgn_no", 	giftcardInfo.get("orderid"));
			p.set("uniq_rcgn_no", 		giftcardInfo.get("orderid"));
			p.set("trsc_orgn_dv_cd", 	"10");

			ImMemberService immem = (new ImMemberService()).toProxyInstance();
			JSONObject json = immem.useMemberGiftcard(p);
			
			// 기프트카드 로그
			p = new Param();
			p.set("orderid", 		giftcardInfo.get("orderid"));
			p.set("ship_seq", 		"1");
			p.set("trsc_typ_cd", 	json.get("TRSC_TYP_CD"));
			p.set("trsc_biz_dv_cd", json.get("TRSC_BIZ_DV_CD"));
			p.set("coopco_cd", 		json.get("COOPCO_CD"));
			p.set("trsc_dt",		json.get("TRSC_DT"));
			p.set("trsc_hr",		json.get("TRSC_HR"));
			p.set("trc_no",			json.get("TRC_NO"));
			p.set("chnl_typ_cd",	json.get("CHNL_TYP_CD"));
			p.set("crd_id",			json.get("CRD_ID"));
			p.set("crd_bal",		json.get("CRD_BAL"));
			p.set("apv_dt",			json.get("APV_DT"));
			p.set("apv_no",			json.get("APV_NO"));
			p.set("res_cd", 		json.get("RES_CD"));
			p.set("res_msg", 		json.get("RES_MSG"));
			super._insert("Order.insertGiftcardLog", p);
			
			if(!"00000".equals((String) json.get("RES_CD"))) {
				System.out.println(orderid + " use giftcard result : (" + json.get("RES_CD") + ") " + json.get("RES_MSG"));
				throw new OrderError("기프트카드 복원에 오류가 발생했습니다. (" + json.get("RES_CD") + ") " + json.get("RES_MSG"));
			}
			
			// 현금영수증 취소
			try {
				Param cashInfo = super._row("Order.getLgdCashreceiptLogInfo", new Param("lgd_oid", orderid, "lgd_method", "AUTH", "lgd_respcode", "0000"));
				if(cashInfo != null && !"".equals(cashInfo.get("lgd_tid"))) {
					String configPath = Env.getDocRoot() + Config.get("lgdacom.config") + SystemChecker.getCurrentName().toLowerCase();
					String CST_PLATFORM = SystemChecker.isReal() ? "service" : "test";
					String CST_MID = Config.get("lgdacom.CST_MID");
					String LGD_MID = ("test".equals(CST_PLATFORM.trim())?"t":"")+CST_MID;
					
					XPayClient xpay = new XPayClient();
					
					xpay.Init(configPath, CST_PLATFORM);
					xpay.Init_TX(LGD_MID);
					xpay.Set("LGD_TXNAME", "CashReceipt");
					xpay.Set("LGD_MID", LGD_MID);
					xpay.Set("LGD_PAYTYPE", "SC0100");
					xpay.Set("LGD_METHOD", "CANCEL");
					xpay.Set("LGD_TID", cashInfo.get("lgd_tid"));
	
					if (xpay.TX()) {
					    //1)현금영수증 발급/취소결과 화면처리(성공,실패 결과 처리를 하시기 바랍니다.)
					    System.out.println(orderid + " 현금영수증 발급/취소 요청처리가 완료되었습니다.  <br>");
					    System.out.println( "TX Response_code = " + xpay.m_szResCode + "<br>");
					    System.out.println( "TX Response_msg = " + xpay.m_szResMsg + "<p>");
					    
					    System.out.println("응답코드 : " + xpay.Response("LGD_RESPCODE",0) + "<br>");
					    System.out.println("응답메세지 : " + xpay.Response("LGD_RESPMSG",0) + "<p>");
					    System.out.println("주문번호 : " + xpay.Response("LGD_OID",0) + "<br>");
					    System.out.println("거래번호 : " + xpay.Response("LGD_TID",0) + "<br>");
					    System.out.println("현금영수증 거래번호 : " + xpay.Response("LGD_CASHRECEIPTNUM",0) + "<br>");
					    System.out.println("발급일시 : " + xpay.Response("LGD_RESPDATE",0) + "<br>");
					    
					    for (int i = 0; i < xpay.ResponseNameCount(); i++) {
					    	System.out.println(xpay.ResponseName(i) + " = ");
					        for (int j = 0; j < xpay.ResponseCount(); j++) {
					        	System.out.println(xpay.Response(xpay.ResponseName(i), j) + "<br>");
					        }
					    }

					    Param pp = new Param();
		    	        pp.set("lgd_method", "CANCEL");
		    	        pp.set("lgd_respcode", xpay.Response("LGD_RESPCODE",0));
		    	        pp.set("lgd_respmsg", xpay.Response("LGD_RESPMSG",0));
		    	        pp.set("lgd_oid", xpay.Response("LGD_OID",0));
		    	        pp.set("lgd_tid", xpay.Response("LGD_TID",0));
		    	        pp.set("lgd_cashreceiptnum", xpay.Response("LGD_CASHRECEIPTNUM",0));
		    	        pp.set("lgd_respdate", xpay.Response("LGD_RESPDATE",0));
		    	        
						super._insert("Order.insertLgdCashreceiptLog", pp);
					} else {
					    //2)API 요청 실패 화면처리
						System.out.println(orderid + " 현금영수증 발급/취소 요청처리가 실패되었습니다.  <br>");
						System.out.println( "TX Response_code = " + xpay.m_szResCode + "<br>");
						System.out.println( "TX Response_msg = " + xpay.m_szResMsg);
					}
				}
			} catch(Exception e) {
				e.printStackTrace();
			}
		}

		if(info.getInt("pay_amt") > 0) {	// 결제 취소
			if("009".equals(info.get("pay_type"))) {	// naverpay
				System.out.println(orderid + " ------------- naverpay cancel ------------");
				Param payInfo = super._row("Order.getNaverPayInfo", orderid);
				if (payInfo == null) {
					throw new OrderError("결제 정보가 존재하지 않습니다. 관리자에 문의하세요.");
				}
	
				int payAmt = payInfo.getInt("total_pay_amount");
				int taxFreeAmt = info.getInt("tax_free_amt");
				if(payAmt < taxFreeAmt) taxFreeAmt = payAmt;
				
	    		Param p = new Param();
	    		p.set("paymentId",				payInfo.get("payment_id"));
	    		p.set("cancelAmount",			payAmt);
	    		p.set("cancelReason",			"ORDER CANCEL");
	    		p.set("cancelRequester",		"1");
	    		p.set("taxScopeAmount",			payAmt - taxFreeAmt);
	    		p.set("taxExScopeAmount",		taxFreeAmt);

	    	    String partnerId = Config.get("npay.shop.partnerid");
	    	    String clientId = Config.get("npay.shop.clientid");
	    	    String clientSecret = Config.get("npay.shop.clientsecret");
	    		
	    		NaverPayUtil npay = new NaverPayUtil();
	    		JSONObject json = npay.cancel(partnerId, clientId, clientSecret, p);
	    		
	    		int responseCode = (Integer) json.get("response_code");
	    	    String code = (String) json.get("code");
	    	    System.out.println(orderid + " ----------- naver pay cancel responseCode : " + responseCode + ", code : " + code);


	    	    /*
	    	    int today = Integer.parseInt(Utils.getTimeStampString("yyyyMMdd"));
	    	    if(today >= 20210401) {
		    	    if(responseCode != 200 || (!"Success".equals(code) && !"CancelNotComplete".equals(code))) {
//		    	    	System.out.println(json.toJSONString());
						throw new OrderError("결제 취소요청이 실패하였습니다.(" + json.get("code") + " : " + json.get("message") + ")");
				    }
	    	    } else {
		    	    if(responseCode != 200 || !"Success".equals(code)) {
//		    	    	System.out.println(json.toJSONString());
						throw new OrderError("결제 취소요청이 실패하였습니다.(" + json.get("code") + " : " + json.get("message") + ")");
				    }
	    	    }
	    	    */
			    
	    	    if(responseCode != 200 || !"Success".equals(code)) {
//	    	    	System.out.println(json.toJSONString());
					throw new OrderError("결제 취소요청이 실패하였습니다.(" + json.get("code") + " : " + json.get("message") + ")");
			    }

	    	    p = new Param();
				p.set("orderid", 					orderid);
				p.set("code", 						code);
				p.set("message", 					json.get("message"));
				
				JSONObject body = (JSONObject) json.get("body");
				p.set("payment_id", 				body.get("paymentId"));
				p.set("pay_hist_id", 				body.get("payHistId"));
				p.set("primary_pay_means", 			body.get("primaryPayMeans"));
				p.set("primary_pay_cancel_amount",	body.get("primaryPayCancelAmount"));
				p.set("primary_pay_rest_amount",	body.get("primaryPayRestAmount"));
				p.set("npoint_cancel_amount",		body.get("npointCancelAmount"));
				p.set("npoint_rest_amount",			body.get("npointRestAmount"));
				p.set("cancel_ymdt",				body.get("cancelYmdt"));
				p.set("total_rest_amount",			body.get("totalRestAmount"));
				
				super._insert("Order.insertNaverPayCancelLog", p);

			} else if("005".equals(info.get("pay_type"))) {	// kakaopay
				System.out.println(orderid + " ------------- kakaopay cancel ------------");
				Param payInfo = super._row("Order.getKakaoPayInfo", orderid);
				if (payInfo == null) {
					throw new OrderError("결제 정보가 존재하지 않습니다. 관리자에 문의하세요.");
				}
				
				String ediDate = KakaopayUtil.getyyyyMMddHHmmss(); // 전문생성일시
				String md_src = ediDate + Env.getKakaoMid() + info.get("pay_amt");
			    String hash_String = KakaopayUtil.SHA256Salt(md_src, Env.getKakaoEncodeKey());
			    
				CnsPayWebConnector4NS connector = new CnsPayWebConnector4NS();
			    connector.setLogHome(Env.getKakaoLogHome());
			    connector.setCnsPayHome(Env.getKakaoCnsPayHome());
			    
			    connector.addRequestData("actionType", "CL0");
				connector.addRequestData("CancelPwd", Env.getKakaoCancelPwd());
				connector.addRequestData("EncodeKey", Env.getKakaoEncodeKey());

				connector.addRequestData("EdiDate", ediDate);
				connector.addRequestData("MID", Env.getKakaoMid());
			    connector.addRequestData("TID", payInfo.get("tid"));
			    connector.addRequestData("CancelAmt", info.get("pay_amt"));
			    connector.addRequestData("EncryptData", hash_String);
				connector.addRequestData("PartialCancelCode", "0");
			    connector.addRequestData("CancelMsg", "주문취소");

				connector.requestAction();
				
				Param p = new Param();
				p.set("orderid", orderid);
				p.set("result_code", connector.getResultData("ResultCode"));
			    p.set("result_msg", connector.getResultData("ResultMsg"));
			    p.set("error_cd", connector.getResultData("ErrorCD"));
			    p.set("error_msg", connector.getResultData("ErrorMsg"));
			    p.set("cancel_amt", connector.getResultData("CancelAmt"));
			    p.set("cancel_date", connector.getResultData("CancelDate"));
			    p.set("cancel_time", connector.getResultData("CancelTime"));
			    p.set("pay_method", connector.getResultData("PayMethod"));
			    p.set("mid", connector.getResultData("MID"));
			    p.set("tid", connector.getResultData("TID"));
			    p.set("stateCD", connector.getResultData("StateCD"));
			    p.set("cc_part_cl", connector.getResultData("CcPartCl"));
			    p.set("cancel_num", connector.getResultData("CancelNum"));
			    p.set("van_code", connector.getResultData("VanCode"));

			    super._insert("Order.insertKakaoPayCancelLog", p);
				
			    if(!"2001".equals(connector.getResultData("ResultCode"))) {
					throw new OrderError("결제 취소요청이 실패하였습니다.(" + connector.getResultData("ResultCode") + " : " + connector.getResultData("ResultMsg") + ")");
				}
			} else if("008".equals(info.get("pay_type"))) {	// smilepay
				System.out.println(orderid + " ------------- smilepay cancel ------------");
				Param payInfo = super._row("Order.getSmilePayInfo", orderid);
				if (payInfo == null) {
					throw new OrderError("결제 정보가 존재하지 않습니다. 관리자에 문의하세요.");
				}
				
				String ediDate = SmilepayUtil.getyyyyMMddHHmmss(); // 전문생성일시
				String md_src = ediDate + SmilepayUtil.MID + info.get("pay_amt");
			    String hash_String = KakaopayUtil.SHA256Salt(md_src, Env.getKakaoEncodeKey());
			    
				CnsPayWebConnector connector = new CnsPayWebConnector();
			    connector.setLogHome(SmilepayUtil.LOG_HOME);
			    connector.setCnsPayHome(SmilepayUtil.CNSPAY_HONE);
			    
			    connector.addRequestData("actionType", "CL0");
				connector.addRequestData("EdiDate", ediDate);
				connector.addRequestData("MID", SmilepayUtil.MID);
			    connector.addRequestData("TID", payInfo.get("tid"));
			    connector.addRequestData("CancelAmt", info.get("pay_amt"));
			    connector.addRequestData("EncryptData", hash_String);
				connector.addRequestData("PartialCancelCode", "0");
			    connector.addRequestData("CancelMsg", "주문취소");

				connector.requestAction();
				
				Param p = new Param();
				p.set("orderid", orderid);
			    p.set("result_code", connector.getResultData("ResultCode"));
			    p.set("result_msg", connector.getResultData("ResultMsg"));
			    p.set("error_cd", connector.getResultData("ErrorCD"));
			    p.set("error_msg", connector.getResultData("ErrorMsg"));
			    p.set("cancel_amt", connector.getResultData("CancelAmt"));
			    p.set("cancel_date", connector.getResultData("CancelDate"));
			    p.set("cancel_time", connector.getResultData("CancelTime"));
			    p.set("pay_method", connector.getResultData("PayMethod"));
			    p.set("mid", connector.getResultData("MID"));
			    p.set("tid", connector.getResultData("TID"));
			    p.set("auth_date", connector.getResultData("AuthDate"));
			    p.set("state_cd", connector.getResultData("StateCD"));
			    p.set("van_code", connector.getResultData("VanCode"));
			    p.set("smile_cash", connector.getResultData("SmileCash"));

			    System.out.println(orderid + " --------- smilepay cancel result : " + p);
			    super._insert("Order.insertSmilePayCancelLog", p);
				
			    if(!"2001".equals(connector.getResultData("ResultCode"))) {
					throw new OrderError("결제 취소요청이 실패하였습니다.(" + connector.getResultData("ResultCode") + " : " + connector.getResultData("ResultMsg") + ")");
				}
			} else if("007".equals(info.get("pay_type"))) {	// kakaopay2
				System.out.println(orderid + " ------------- kakaopay2 cancel ------------");
				Param payInfo = super._row("Order.getKakaoPay2Info", orderid);
				if (payInfo == null) {
					throw new OrderError("결제 정보가 존재하지 않습니다. 관리자에 문의하세요.");
				}

	    		Param p = new Param();
	    		JSONObject amount = (JSONObject) JSONValue.parse(payInfo.get("amount"));
	    		p.set("cid",					payInfo.get("cid"));
	    		p.set("tid",					payInfo.get("tid"));
	    		p.set("cancel_amount",			amount.get("total"));
	    		p.set("cancel_tax_free_amount",	amount.get("tax_free"));
	    		
	    	    KakaopayUtil kakao = new KakaopayUtil();
	    		JSONObject json = kakao.cancel(p);
	    		int responseCode = (Integer) json.get("response_code");
			    if(responseCode != 200) {
//                 	System.out.println(json.toJSONString());
					throw new OrderError("결제 취소요청이 실패하였습니다.(" + json.get("code") + " : " + json.get("msg") + ")");
			    }
			    
				JSONObject amt1 = (JSONObject) json.get("amount");
				JSONObject amt2 = (JSONObject) json.get("canceled_amount");
				JSONObject amt3 = (JSONObject) json.get("cancel_available_amount");
				
			    p = new Param();
				p.set("orderid", 					orderid);
				p.set("aid", 						json.get("aid"));
				p.set("tid", 						json.get("tid"));
				p.set("cid", 						json.get("cid"));
				p.set("status", 					json.get("status"));
				p.set("partner_order_id", 			json.get("partner_order_id"));
				p.set("partner_user_id",			json.get("partner_user_id"));
				p.set("payment_method_type",		json.get("payment_method_type"));
				p.set("amount", 					amt1.toJSONString());
				p.set("canceled_amount",			amt2.toJSONString());
				p.set("cancel_available_amount",	amt3.toJSONString());
				p.set("item_name", 					json.get("item_name"));
				p.set("item_code", 					json.get("item_code"));
				p.set("quantity", 					json.get("quantity"));
				p.set("created_at", 				json.get("created_at"));
				p.set("approved_at", 				json.get("approved_at"));
				p.set("canceled_at", 				json.get("canceled_at"));
				p.set("payload", 					json.get("payload"));
				
				super._insert("Order.insertKakaoPayCancel2Log", p);

			} else if("006".equals(info.get("pay_type"))) {	// payco
				System.out.println(orderid + " ------------- payco cancel ------------");
				Param payInfo = super._row("Order.getPaycoInfo", orderid);
				if (payInfo == null) {
					throw new OrderError("결제 정보가 존재하지 않습니다. 관리자에 문의하세요.");
				}
				
				String code = "";
				String msg = "";

				try {
					ObjectMapper mapper = new ObjectMapper();
					JsonNode node = mapper.readTree(payInfo.get("payment_details"));

					/* 설정한 주문취소 정보로 Json String 을 작성합니다. */
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("sellerKey", Env.getPaycoSellerKey());								//[필수]가맹점 코드
					map.put("orderNo", payInfo.get("order_no"));									//[필수]주문번호
					map.put("cancelTotalAmt", info.getInt("pay_amt"));  //[필수]취소할 총 금액(전체취소, 부분취소 전부다)
					map.put("orderCertifyKey", payInfo.get("order_certify_key"));					//[필수]주문인증 key
					
					int taxableAmt = 0;
					int vatAmt = 0;
					int taxfreeAmt = 0;
					
					for(int i = 0; i < node.size(); i++) {
						taxableAmt += node.get(i).path("taxableAmt").asInt();
						vatAmt += node.get(i).path("vatAmt").asInt();
						taxfreeAmt += node.get(i).path("taxfreeAmt").asInt();
					}
					System.out.println(orderid + " -------- taxableamt : " + taxableAmt);
					System.out.println(orderid + " -------- vatamt : " + vatAmt);
					System.out.println(orderid + " -------- taxfreeamt : " + taxfreeAmt);

//					map.put("totalCancelTaxableAmt", node.get(0).path("taxableAmt"));
//					map.put("totalCancelVatAmt", node.get(0).path("vatAmt"));
//					map.put("totalCancelTaxfreeAmt", node.get(0).path("taxfreeAmt"));
					map.put("totalCancelTaxableAmt", taxableAmt);
					map.put("totalCancelVatAmt", vatAmt);
					map.put("totalCancelTaxfreeAmt", taxfreeAmt);

					PaycoUtil util = new PaycoUtil(SystemChecker.isReal() ? "REAL" : "DEV");
					String strResult = util.payco_cancel(map, Env.getPaycoLogYn(), "N");
					System.out.println("payco cancel result : " + strResult);

					// jackson Tree 이용
					mapper = new ObjectMapper();
					node = mapper.readTree(strResult);
					code = node.path("code").toString();
					msg = node.path("message").textValue();
					JsonNode result = mapper.readTree(node.path("result").toString());
					
					Param p = new Param();
					p.set("orderid", orderid);
					p.set("order_no", result.path("orderNo").textValue());
					p.set("cancel_trade_seq", result.path("cancelTradeSeq").toString());
					p.set("total_cancel_payment_amt", result.path("totalCancelPaymentAmt").toString());
					p.set("remain_cancel_possible_amt", result.path("remainCancelPossibleAmt").toString());
					p.set("cancel_payment_details", result.path("cancelPaymentDetails").toString());
					p.set("code", code);
					p.set("message", msg);
				    super._insert("Order.insertPaycoCancelLog", p);
				} catch(Exception e) {
					e.printStackTrace();
				}

				if(!code.equals("0")){
					throw new OrderError(orderid + " 결제 취소요청이 실패하였습니다.(" + code + " : " + msg + ")");
				}
				
			} else {	// xpay
				Param paymentInfo = super._row("Order.getLGDPaymentInfo", orderid);
				
				if (paymentInfo == null) {
					throw new OrderError("결제 정보가 존재하지 않습니다. 관리자에 문의하세요.");
				}
		
				String configPath = Env.getDocRoot() + Config.get("lgdacom.config") + SystemChecker.getCurrentName().toLowerCase();
				System.out.println(orderid + " ============= LGD configPath : " + configPath);
		
				String CST_PLATFORM         = SystemChecker.isReal() ? "service" : "test";          //LG유플러스 결제서비스 선택(test:테스트, service:서비스)
				String CST_MID              = Config.get("lgdacom.CST_MID");                      //LG유플러스로 부터 발급받으신 상점아이디를 입력하세요.
				String LGD_MID              = ("test".equals(CST_PLATFORM.trim())?"t":"")+CST_MID;  //테스트 아이디는 't'를 제외하고 입력하세요.
			    String LGD_TID = paymentInfo.get("LGD_TID");
			    
			    XPayClient xpay = new XPayClient();
			    xpay.Init(configPath, CST_PLATFORM);
			    xpay.Init_TX(LGD_MID);
			    xpay.Set("LGD_TXNAME", bSettlement ? "Settlement" : "Cancel"); // "Cancel" : 주문 취소, "Settlement" : 가상계좌반납(정산요청)
			    xpay.Set("LGD_TID", LGD_TID);
			    
			    System.out.println(orderid + " ================================= bSettlement : " + bSettlement);
			    
			    //가상계좌 결제 환불, 입금 이후 파라미터 추가
			    if ("003".equals(info.get("pay_type")) && !"110".equals(info.get("status"))) {
			        String LGD_RFBANKCODE     		= param.get("lgd_rfbankcode"); 		    //환불계좌 은행코드 (가상계좌환불은 필수)
			        String LGD_RFACCOUNTNUM     	= param.get("lgd_rfaccountnum"); 		//환불계좌 번호 (가상계좌환불은 필수)
			        String LGD_RFCUSTOMERNAME     	= param.get("lgd_rfcustomername"); 		//환불계좌 예금주 (가상계좌환불은 필수)
			        String LGD_RFPHONE     			= param.get("lgd_rfphone"); 		    //요청자 연락처 (가상계좌환불은 필수)
			        
			        xpay.Set("LGD_RFBANKCODE", LGD_RFBANKCODE);
			        xpay.Set("LGD_RFACCOUNTNUM", LGD_RFACCOUNTNUM);
			        xpay.Set("LGD_RFCUSTOMERNAME", LGD_RFCUSTOMERNAME);
			        xpay.Set("LGD_RFPHONE", LGD_RFPHONE);
			    }
			    
			    /*
			     * 1. 결제취소 요청 결과처리
			     *
			     * 취소결과 리턴 파라미터는 연동메뉴얼을 참고하시기 바랍니다.
				 *
				 * [[[중요]]] 고객사에서 정상취소 처리해야할 응답코드
				 * 1. 신용카드 : 0000, AV11  
				 * 2. 계좌이체 : 0000, RF00, RF10, RF09, RF15, RF19, RF23, RF25 (환불진행중 응답건-> 환불결과코드.xls 참고)
				 * 3. 나머지 결제수단의 경우 0000(성공) 만 취소성공 처리
				 *
			     */
			    	    
			    boolean success = xpay.TX();
		
		        Param lgdInfo = new Param();
		        for (int i = 0; i < xpay.ResponseNameCount(); i++) {
		            System.out.print(xpay.ResponseName(i) + " = ");
		            for (int j = 0; j < xpay.ResponseCount(); j++) {
		                System.out.println("\t" + xpay.Response(xpay.ResponseName(i), j));
		                if(j == 0) {
		                	lgdInfo.set(xpay.ResponseName(i).toLowerCase(), xpay.Response(xpay.ResponseName(i), j));
		                }
		            }
		        }
		
				if("SC0010".equals(paymentInfo.get("lgd_paytype"))){
					if("0000,AV11".indexOf(lgdInfo.get("lgd_respcode")) == -1) {
						success = false;
					}
				} else if("SC0030".equals(paymentInfo.get("lgd_paytype"))) {
					if("0000,RF00,RF10,RF09,RF15,RF19,RF23,RF25".indexOf(lgdInfo.get("lgd_respcode")) == -1) {
						success = false;
					}
				} else {
					if(!"0000".equals(lgdInfo.get("lgd_respcode"))) {
						success = false;
					}
				}
		
				// 결제 로그
				if(lgdInfo != null) {	// LGD 로그
					lgdInfo.set("lgd_oid", lgdInfo.get("lgd_oid", orderid));
					lgdInfo.set("lgd_paydate", lgdInfo.get("lgd_paydate", Utils.getTimeStampString("yyyyMMddHHmmss")));
					super._insert("Order.insertLgdPaymentLog", lgdInfo);
				}
		
			    if(!success) {
			        throw new OrderError("결제 취소요청이 실패하였습니다.(" + xpay.m_szResCode + ")");
			    }
			}
		}
	}
	
	@Transactionable
	public void confirmOrder(Param param) {
		Param masterInfo = super._row("Order.getOrderMaster", param);
		Param info = super._row("Order.getOrderShip", param);
		
		if(info == null || "150,160".indexOf(info.get("status")) == -1) {
			throw new OrderError("잘못된 접근입니다.");
		}
		
		param.set("regist_user", param.get("userid"));
		param.set("status", "170");
		super._update("Order.updateStatus", param);
		super._insert("Order.insertStatusLog", param);
		
		if(!"".equals(masterInfo.get("unfy_mmb_no"))) {
			// 포인트 적립
			// 포인트 적립 내역
			Param pointInfo = super._row("Order.getPointLogInfo", 
								new Param("orderid", param.get("orderid"), 
											"trsc_typ_cd", "210", 
											"trsc_biz_dv_cd", "21")); 
		
			// 포인트 적립 내역이 없을 경우에만 적립
			if(pointInfo == null || "".equals(pointInfo.get("orderid"))) {
				int selAmt = masterInfo.getInt("tot_amt") + masterInfo.getInt("ship_amt");
				int dcAmt = masterInfo.getInt("coupon_sale_amt") + masterInfo.getInt("routine_sale_amt") + masterInfo.getInt("coupon_cart_amt") + masterInfo.getInt("coupon_ship_amt") + masterInfo.getInt("point_amt");
				int tgtAmt = masterInfo.getInt("tot_amt") - masterInfo.getInt("coupon_sale_amt") - masterInfo.getInt("routine_sale_amt") - masterInfo.getInt("coupon_cart_amt") - masterInfo.getInt("point_amt");
				int acmlPoint = tgtAmt / 100;
				
				FamilyMemberService family = (new FamilyMemberService()).toProxyInstance();
				Param familyInfo = family.getInfo(masterInfo.getLong("unfy_mmb_no"));
				if("Y".equals(familyInfo.get("family_yn")) && "004".equals(familyInfo.get("family_grade_code"))) {
					acmlPoint = acmlPoint * 5;
				}

				if(acmlPoint > 0) {
					Param p = new Param();
					p.set("trsc_biz_dv_cd", "21");
					p.set("trsc_orgn_dv_cd", "10");
					p.set("mmb_cert_dv_cd", "2");
					p.set("mmb_cert_dv_vlu", masterInfo.get("unfy_mmb_no"));	
					p.set("tot_sel_amt", selAmt);
					p.set("tot_dc_amt", dcAmt);
					p.set("mbrsh_dc_amt", 0);
					p.set("acml_tgt_amt", tgtAmt);
					p.set("trsc_rsn_cd", "RF01");
					p.set("uniq_rcgn_no", param.get("orderid"));
					p.set("acml_pint", acmlPoint);
					p.set("rmk", "");
					
					ImMemberService immem = (new ImMemberService()).toProxyInstance();
					JSONObject json = immem.saveMemberPoint(p);
					
					if(!"00000".equals((String) json.get("RES_CD"))) {
						System.out.println("use point result : (" + json.get("RES_CD") + ") " + json.get("RES_MSG"));
						throw new OrderError("포인트 적립에 오류가 발생했습니다. (" + json.get("RES_CD") + ") " + json.get("RES_MSG"));
					}
		
					// 포인트 로그
					p = new Param();
					p.set("orderid", 		param.get("orderid"));
					p.set("ship_seq", 		"1");
					p.set("trsc_typ_cd", 	json.get("TRSC_TYP_CD"));
					p.set("trsc_biz_dv_cd", json.get("TRSC_BIZ_DV_CD"));
					p.set("coopco_cd", 		json.get("COOPCO_CD"));
					p.set("trsc_dt",		json.get("TRSC_DT"));
					p.set("trsc_hr",		json.get("TRSC_HR"));
					p.set("trc_no",			json.get("TRC_NO"));
					p.set("chnl_typ_cd",	json.get("CHNL_TYP_CD"));
					p.set("apv_dt",			json.get("APV_DT"));
					p.set("apv_no",			json.get("APV_NO"));
					p.set("acml_pint", 		json.get("ACML_PINT"));
					p.set("use_pint", 		json.get("USE_PINT"));
					p.set("rmnd_pint", 		json.get("RMND_PINT"));
					p.set("res_cd", 		json.get("RES_CD"));
					p.set("res_msg", 		json.get("RES_MSG"));
					super._insert("Order.insertPointLog", p);
				}
			}
		}
		
		// 2022.05.03 10:00 까지 피추천인 구매확정시 6,000 포인트 지급
		MemberService member = (new MemberService()).toProxyInstance();
		member.recommenderEvent2(masterInfo);
	}
	
	public Param getLGDPaymentInfo(String orderid) {
		return super._row("Order.getLGDPaymentInfo", orderid);
	}
	
	@Transactionable
	public void modifyDeliveryDate(Param param) {
		super._update("Order.updateDeliveryDate", param);
		super._insert("Order.insertDeliveryDateLog", param);
	}
	
	@Transactionable
	public void createReturn(FileUploader upload) {
		Param param = new Param(upload);
		
		// 파일업로드
		long fileUploadLimit 	= 10 * 1024 * 1024;			// 파일의 최대 사이즈	
		String uploadPath = Env.getUploadPath();
		String subPath = Config.get("order.image.path") + Utils.getTimeStampString(new Date(), "yyyyMM") + "/";

		upload.setUploadPath(uploadPath + subPath);
		upload.setAcceptableExt(ACCEPTABLE_FILE_EXT);
		upload.setNotAcceptableExt(NOT_ACCEPTABLE_EXT);

		for(int i = 0; i < upload.getFileCount(); i++) {
			if(!upload.isMissing(i)) {
				if(upload.getFileSize(i) > fileUploadLimit){
					throw new FileUploaderException("최대 업로드파일용량은 " + fileUploadLimit + "MB 입니다.", FileUploaderException.TOO_LARGE_SIZE);
				}
				
				String fieldName = upload.getFieldName(i);
				String newFileName = fieldName + "_" + System.currentTimeMillis() + "." + upload.getFileExt(i);
				upload.write(fieldName, newFileName);
				param.set(fieldName, Config.get("image.path") + subPath + newFileName);
			}
		}

		super._insert("Order.insertReturn", param);
		param.set("status", "C".equals(param.get("rtype")) ? "210" : "240");
		param.set("regist_user", param.get("userid"));
		super._update("Order.updateStatus", param);
		super._insert("Order.insertStatusLog", param);
	}
	
	public void createKakaoPayCancelLog(Param param) {
		super._insert("Order.insertKakaoPayCancelLog", param);
	}
	
	public Param getPaycoInfo(String orderid) {
		return super._row("Order.getPaycoInfo", orderid);
	}
	
	public Param getKakaoPayInfo(String orderid) {
		return super._row("Order.getKakaoPayInfo", orderid);
	}
	
	public Param getSmilePayInfo(String orderid) {
		return super._row("Order.getSmilePayInfo", orderid);
	}
	
	public List<Param> getOrderShipSeqInfo(Param param) {
		return super._list("Order.getOrderShipSeqInfo", param);
	}
	
	public void createOrderForm(Param param) {
		super._insert("Order.insertOrderForm", param);
	}
	
	public void modifyOrderForm(Param param) {
		super._update("Order.updateOrderForm", param);
	}
	
	public Param getOrderFormInfo(String orderid) {
		return super._row("Order.getOrderFormInfo", orderid);
	}
	
	public void createLgdCashreceiptLog(Param param) {
		super._insert("Order.insertLgdCashreceiptLog", param);
	}
	
	public List<Param> getOrderItemList(String orderid) {
		return super._list("Order.getOrderItemList", orderid);
	}
	
	public List<Param> getMemoList(String orderid) {
		return super._list("Order.getMemoList", orderid);
	}
}
