package com.sanghafarm.service.imc;

import java.util.Calendar;

import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;
import com.efusioni.stone.utils.Utils;
import com.sanghafarm.service.order.OrderService;
import com.sanghafarm.service.order.ShipDateService;
import com.sanghafarm.service.order.TicketOrderService;

public class ImcService extends IbatisService {
	
	private static String FROM_PHONE = "1522-3698";
	private static String SENDER_KEY = "d41fe2af31684db644517c973319312c0c9bef81";
	
	public void sendTalk(Param param) {
		param.set("sender_key", SENDER_KEY);
		super._insert("IMC.insertImcAtBizMsg", param);
	}
	
	public void sendOrderTalk(String orderid, int shipSeq) {
		sendOrderTalk(orderid, shipSeq, "1");
	}	
	
	public void sendOrderTalk(String orderid, int shipSeq, String deliveryType) {
		try {
			OrderService order = (new OrderService()).toProxyInstance();
			Param info = order.getOrderMasterInfo(orderid);
			Param shipInfo = order.getOrderShipInfo(new Param("orderid", orderid, "ship_seq", shipSeq));
			
			if("110".equals(shipInfo.get("status"))) {	// 결제대기
				Calendar cal = Calendar.getInstance();
				cal.add(Calendar.DATE, 2);
				String d = Utils.getTimeStampString(cal.getTime(), "yyyy년MM월dd일");

				String message = "[상하농원] 입금 안내\n" + info.get("name") + "님의 주문은 " + d + "까지 입금을 기다리고 있습니다.\n\n";
				message += "▶ 마이페이지에서 확인하기\nhttps://goo.gl/vuAs8c\n\n문의☎ 고객센터 1522-3698";
				
				Param param = new Param();
				param.set("phone_number", "82" + info.get("mobile1").substring(1) + info.get("mobile2") + info.get("mobile3"));
				param.set("template_code", "B_SH_36_02_07545");
				param.set("message", message);
				param.set("resend_mt_from", FROM_PHONE);
				param.set("resend_mt_to", info.get("mobile1") + info.get("mobile2") + info.get("mobile3"));

				this.sendTalk(param);
			} else if("120".equals(shipInfo.get("status"))) {	// 결제완료
				String[] items = shipInfo.get("items").split("\\|");
				String[] item = items[0].split("::");
				
				String message = "[상하농원] 주문완료 안내\n";
				message += info.get("name") + " 고객님 주문이 완료되었습니다.\n\n";
				message += "◆ 배송안내\n";
				message += "- " + ("5,6".indexOf(deliveryType) != -1 ? "새벽" : "일반") + "배송으로 주문하신 상품은 " + ShipDateService.getExpectedDeliveryDay(deliveryType) + "에 받아보실 수 있습니다.\n";
				message += "(배송예정일이 일요일 혹은 공휴일인 경우, 해당 휴일을 포함하여 1~2일 더 지연 될 수 있습니다.)\n\n";
				message += "- 배송일지정하여 주문하신 상품은 선택하신 배송지정일에 받아보실 수 있습니다.\n";
				message += "- 정기배송으로 주문하신 상품은 매회차 선택하신 배송지정일에 받아보실 수 있습니다.\n";
				message += "   (배송지정일 변경은 선택하신 배송지정일 2일 전까지 마이페이지에서 직접 할 수 있습니다.)\n\n";
				message += "◆ 주문정보\n";
				message += "- 주문번호 : " + orderid + "\n";
				message += "- 주문상품 : " + item[3] + " 외 + " + (items.length - 1) + "건\n";
				message += "- 주문금액 : " + Utils.formatMoney(info.getInt("tot_amt") + info.getInt("ship_amt")) + "원\n";
				message += "- 주문배송 현황 : https://goo.gl/vuAs8c\n\n";
				message += "문의☎ 고객센터 1522-3698";
				
				Param param = new Param();
				param.set("phone_number", "82" + info.get("mobile1").substring(1) + info.get("mobile2") + info.get("mobile3"));
				param.set("template_code", "5".equals(deliveryType) ? "B_SH_003_02_31106" : "B_SH_003_02_08101");
				param.set("message", message);
				param.set("resend_mt_from", FROM_PHONE);
				param.set("resend_mt_to", info.get("mobile1") + info.get("mobile2") + info.get("mobile3"));

				this.sendTalk(param);
			} else if("290".equals(shipInfo.get("status"))) {	// 취소
				Param param = new Param();
				param.set("phone_number", "82" + info.get("mobile1").substring(1) + info.get("mobile2") + info.get("mobile3"));
				param.set("template_code", "B_SH_36_02_07539");
				param.set("message", "[상하농원] 주문취소 안내\n구매하신 제품의 취소가 완료되었습니다.\n\n▶ 마이페이지에서 확인하기\nhttps://goo.gl/vuAs8c");
				param.set("resend_mt_from", FROM_PHONE);
				param.set("resend_mt_to", info.get("mobile1") + info.get("mobile2") + info.get("mobile3"));

				this.sendTalk(param);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	public void sendReserveTalk(String orderid) {
		try {
			TicketOrderService order = (new TicketOrderService()).toProxyInstance();
			Param info = order.getOrderMasterInfo(orderid);
			
			if("02".equals(info.get("ticket_div"))) {
				if("110".equals(info.get("status"))) {	// 결제완료
					String message = "[상하농원] 체험예약 완료 안내\n";
					message += info.get("name") + "님의 " + info.get("reserve_date") + " 상하농원 체험 예약이 완료되었습니다.\n";
					message += "- 체험 시작 20분 전까지 매표소 입장부탁드립니다.\n";
					message += "- 체험이 시작되면 체험교실 입장이 제한 될 수 있습니다.";
					message += "- 체험 인원에 따라 포장시간이 지연 될 수 있습니다.\n\n";
					message += "▶찾아오시는 길\n전라북도 고창군 상하면 상하농원길 11-23\n\n";
					message += "▶ 마이페이지에서 확인하기\nhttps://goo.gl/vuAs8c\n\n문의☎ 고객센터 1522-3698";
					
					Param param = new Param();
					param.set("phone_number", "82" + info.get("mobile1").substring(1) + info.get("mobile2") + info.get("mobile3"));
					param.set("template_code", "B_SH_36_02_05593");
					param.set("message", message);
					param.set("resend_mt_from", FROM_PHONE);
					param.set("resend_mt_to", info.get("mobile1") + info.get("mobile2") + info.get("mobile3"));

					this.sendTalk(param);
				} else if("210".equals(info.get("status"))) {	// 결제취소
					String message = "[상하농원] 체험예약 취소안내\n";
					message += info.get("name") + "님의 상하농원 체험 예약이 취소되었습니다.\n\n";
					message += "▶ 마이페이지에서 확인하기\nhttps://goo.gl/vuAs8c\n\n문의☎ 고객센터 1522-3698"; 
					
					Param param = new Param();
					param.set("phone_number", "82" + info.get("mobile1").substring(1) + info.get("mobile2") + info.get("mobile3"));
					param.set("template_code", "B_SH_36_02_05594");
					param.set("message", message);
					param.set("resend_mt_from", FROM_PHONE);
					param.set("resend_mt_to", info.get("mobile1") + info.get("mobile2") + info.get("mobile3"));

					this.sendTalk(param);
				}
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public void sendJoinTalk(String userid, String telNum, String userNm) {
		try {
			String[] tel = telNum.split("-");
			
			String message = "[상하농원]사랑하는" + userNm +" 고객님,\n\n";
			message += "상하농원에 가입해 주셔서 감사합니다.\n";
			message += "가입 선물로 “온라인 파머스마켓 3천원 할인쿠폰”을 발급해드렸습니다.\n\n";
			message += "쿠폰함 바로 가기 ☞ https://bit.ly/2LVB0eB\n\n";
			message += "앞으로도 건강한 생산을 통해 먹거리의 가치를 높이는 상하농원이 되겠습니다.\n\n";
			message += "문의처: 1522-3698\n";
			message += "무료수신거부: 080-850-7019\n";
			
			Param param = new Param();
			param.set("phone_number", "82" + tel[0].substring(1) + tel[1] + tel[2]);
			param.set("template_code", "B_SH_003_02_12568");
			param.set("message", message);
			param.set("resend_mt_from", FROM_PHONE);
			param.set("resend_mt_to", tel[0].substring(1) + tel[1] + tel[2]);

			this.sendTalk(param);
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	public void sendJoinTalk2(String userid, String telNum, String userNm) {
		try {
			String[] tel = telNum.split("-");
			
			String message = "[상하농원]사랑하는" + userNm +" 고객님,\n\n";
			message += "상하농원에 가입해 주셔서 감사합니다.\n";
			message += "가입 선물로 상하농원을 다양하게 즐기실 수 있는 온/오프라인 쿠폰을 발급해드렸습니다.\n\n";
			message += "[온라인]\n";
			message += "1. 장바구니 3천원 할인 쿠폰\n";
			message += "2. 무료배송 쿠폰\n";
			message += "3. 결제 금액의 1% 적립\n\n";
			message += "[오프라인]\n";
			message += "1. 식음시설 10% 할인권(1회)\n";
			message += "2. 스파 30% 할인권(5장)\n";
			message += "3. 결제 금액의 3% 적립\n";
			message += "   * 파머스 빌리지 제외\n\n";
			message += "앞으로도 건강한 생산을 통해 먹거리의 가치를 높이는 상하농원이 되겠습니다.\n\n";
			message += "문의처: 1522-3698\n";
			message += "무료수신거부: 080-850-7019\n";
			
			Param param = new Param();
			param.set("phone_number", "82" + tel[0].substring(1) + tel[1] + tel[2]);
//			param.set("template_code", "B_SH_003_02_25317");
			param.set("template_code", "B_SH_003_02_25622");
			param.set("message", message);
			param.set("resend_mt_from", FROM_PHONE);
			param.set("resend_mt_to", tel[0].substring(1) + tel[1] + tel[2]);

			this.sendTalk(param);
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
}
