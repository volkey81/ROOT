package com.sanghafarm.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import com.efusioni.stone.common.SystemChecker;
import com.efusioni.stone.utils.Param;
import com.efusioni.stone.utils.Utils;
import com.sanghafarm.service.order.TicketOrderService;

public class TmsUtil {
//	private static String MAIL_CONN_STRING = "jdbc:oracle:thin:@172.16.10.48:3306:tms30";
	private static String MAIL_CONN_STRING = "jdbc:oracle:thin:@10.0.10.6:3306:tms30";
	private static String MAIL_USERID = "tms";
	private static String MAIL_PASSWD = "tms123!@";
//	private static String SMS_CONN_STRING = "jdbc:oracle:thin:@172.16.10.79:1521:WEBDBP";
	private static String SMS_CONN_STRING = "jdbc:oracle:thin:@10.0.10.5:1521:WEBDBP";
	private static String SMS_USERID = "CRM";
	private static String SMS_PASSWD = "CRM";
	
	
	private static String FROM_NAME = "상하농원";
	private static String FROM_EMAIL = "shop@sanghafarm.co.kr";
	private static String FROM_PHONE = "1522-3698";
	private static String SMS_SUBJECT = "상하농원 알림";
			
	public static String SMS_ID = "shadmin";	// 파머스마켓
	public static String SMS_ID_01 = "shadmin01";	// 농원
	public static String SMS_ID_02 = "shadmin02";	// 빌리지

	static {
		if(SystemChecker.isLocal()) {
			MAIL_CONN_STRING = "jdbc:oracle:thin:@localhost:33060:tms30";
			SMS_CONN_STRING = "jdbc:oracle:thin:@localhost:33061:WEBDBP";
		}
	}
	
	public void sendMail(Param param) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = getConnection("MAIL");
			StringBuffer sql = new StringBuffer()
				.append(" INSERT INTO TMS_QUEUE ")
				.append(" 	(SEQ, MSG_CODE, TO_ID, TO_NAME, TO_EMAIL, FROM_NAME, FROM_EMAIL, SUBJECT, REG_DATE, TARGET_DATE, UDT_DATE, MAP_CONTENT) ")
				.append(" VALUES (SEQ_QUEUE.NEXTVAL, '001', ?, ?, ?, ?, ?, ?, SYSDATE, SYSDATE, SYSDATE, ?) ");
			
			pstmt = conn.prepareStatement(sql.toString());
			int i = 1;
			pstmt.setString(i++, param.get("to_id"));
			pstmt.setString(i++, param.get("to_name"));
			pstmt.setString(i++, param.get("to_email"));
			pstmt.setString(i++, FROM_NAME);
			pstmt.setString(i++, FROM_EMAIL);
			pstmt.setString(i++, param.get("subject"));
			pstmt.setString(i++, param.get("content"));
			
			pstmt.executeUpdate();
			
			conn.commit();
		} catch(Exception e) {
			try { conn.rollback(); } catch(Exception se) {}
			e.printStackTrace();
		} finally {
			if(pstmt != null) try {pstmt.close();} catch(Exception e) {};
			if(conn != null) try {conn.close();} catch(Exception e) {};
		}
	}
	
	public void sendSms(Param param) {
//		System.out.println("++++++++++++++ sendSMS : " + param);
		
		if(!SystemChecker.isLocal()) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			
			try {
				conn = getConnection("SMS");
				StringBuffer sql = new StringBuffer()
					.append(" INSERT INTO MMS_MSG ")
					.append(" 	(MSGKEY, SUBJECT, PHONE, CALLBACK, STATUS, REQDATE, MSG, ID) ")
					.append(" VALUES (MMS_MSG_SEQ.NEXTVAL, ?, ?, ?, '0', SYSDATE, ?, ?) ");
				
				pstmt = conn.prepareStatement(sql.toString());
				int i = 1;
				pstmt.setString(i++, param.get("subject", SMS_SUBJECT));
				pstmt.setString(i++, param.get("phone"));
				pstmt.setString(i++, FROM_PHONE);
				pstmt.setString(i++, param.get("content"));
				pstmt.setString(i++, param.get("sms_id", SMS_ID));
				
				pstmt.executeUpdate();
				
				conn.commit();
			} catch(Exception e) {
				try { conn.rollback(); } catch(Exception se) {}
				e.printStackTrace();
			} finally {
				if(pstmt != null) try {pstmt.close();} catch(Exception e) {};
				if(conn != null) try {conn.close();} catch(Exception e) {};
			}
		}
	}
	
	private Connection getConnection(String div) throws Exception {
		Class.forName("oracle.jdbc.driver.OracleDriver");
		Connection conn = null;
		if("MAIL".equals(div)) {
			conn = DriverManager.getConnection(MAIL_CONN_STRING, MAIL_USERID, MAIL_PASSWD);
		} else if("SMS".equals(div)) {
			conn = DriverManager.getConnection(SMS_CONN_STRING, SMS_USERID, SMS_PASSWD);
		}
		return conn;
	}
	
	public void sendOrderSms(String orderid, int shipSeq) {
		/* 2018-09-20 LMS 사용안함
		try {
			OrderService order = (new OrderService()).toProxyInstance();
			Param info = order.getOrderMasterInfo(orderid);
			Param shipInfo = order.getOrderShipInfo(new Param("orderid", orderid, "ship_seq", shipSeq));
			
			if("120".equals(shipInfo.get("status"))) {	// 결제완료
//				String[] items = shipInfo.get("items").split("\\|");
//				String[] item = items[0].split("::");
//				
//				String content = "[상하농원]\n" + info.get("name") + " 고객님\n";
//				content += "주문이 완료되었습니다.\n\n";
//				content += "주문하신 상품은 " + ShipDateService.getExpectedDeliveryDay();
//				content += "에 받아보실 수 있습니다.\n";
//				content += "(배송예정일이 일요일 혹은 공휴일인 경우, 해당 휴일을 포함하여 1~2일 더 지연 될 수 있습니다.)\n\n";
//				content += "주문번호 : " + orderid + "\n";
//				content += "주문상품 : " + item[3] + " 외 " + (items.length - 1) + "건\n";
//				content += "주문금액 : " + Utils.formatMoney(info.getInt("tot_amt") + info.getInt("ship_amt")) + "원\n";
//				content += "주문배송 현황 : https://goo.gl/vuAs8c\n\n";
//				content += "문의사항이 있으시면\n고객센터 1522-3698로 연락주세요.";
//				
//				Param param = new Param();
//				param.set("content", content);
//				param.set("phone", info.get("mobile1") + info.get("mobile2") + info.get("mobile3"));
//				this.sendSms(param);
			} else if("290".equals(shipInfo.get("status"))) {	// 취소
				Param param = new Param();
				param.set("content", "[상하농원] 구매하신 제품의 취소가 완료되었습니다.\n\n▶ Mypage에서 확인하기\nhttps://goo.gl/vuAs8c");
				param.set("phone", info.get("mobile1") + info.get("mobile2") + info.get("mobile3"));
				this.sendSms(param);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		*/
	}
	
	public void sendReserveSms(String orderid) {
		try {
			TicketOrderService order = (new TicketOrderService()).toProxyInstance();
			Param info = order.getOrderMasterInfo(orderid);
			
//			if("02".equals(info.get("ticket_div"))) {
				if("110".equals(info.get("status"))) {	// 결제완료
					String today = Utils.getTimeStampString("yyyyMMdd");
					
					Param param = new Param();
					String contents = "[상하농원] " + info.get("name") + "님의 " + info.get("reserve_date") + " 상하농원 체험 예약이 완료되었습니다. "
							+ "아래 사항에 해당하는 체험 내용을 확인해 주시기 바랍니다.\n"
							+ "★체험교실 체험 안내★ \r\n"
							+ "- 체험 시작 10분 전까지 체험교실 입장부탁드립니다. \r\n"
							+ "- 체험이 시작되면 체험교실 입장이 제한 될 수 있습니다. \r\n"
							+ "- 체험 인원에 따라 포장시간이 지연 될 수 있습니다. \r\n"
							+ "\r\n"
							+ "★공장견학 체험 안내★ \r\n"
							+ "- 예약이 확인될 시에만 견학이 가능합니다. \r\n"
							+ "- 견학은 반드시 셔틀버스를 통해 이동해야 합니다. (자차 금지) \r\n"
							+ "- 버스 미 탑승 시, 예약 취소로 간주됩니다. \r\n"
							+ "- 10분 전 탑승장 대기 바랍니다. (매표소 앞) \r\n"
							+ "- 단 토요일 09시 30분과 16시 공장견학의 경우 자차로 매일유업 상하공장 주차장으로 이동 하셔야 견학이 가능합니다.(해당 시간 셔틀 운행 없음)\r\n"
							+ "\r\n"
							+ "★딸기 수확 체험 안내★\r\n"
							+ "- 체험 시작 10분 전까지 스마트팜 입장 부탁드립니다.\r\n"
							+ "- 1인 수확량이 정해져 있으며, 초과 시 일부 회수됩니다.\r\n"
							+ "- 딸기 수확 시 온실 내부에서 시식을 할 수 없습니다.\r\n"
							+ "- 딸기 수정을 위해 벌이 돌아다니니, 만지거나 위협하지 않도록 주의 바랍니다.\r\n"
							+ "- 딸기하우스 내 가습기가 가동중으로 바닥이 일부 젖어있으니, 장화 또는 방수 신발을 구비 하시기 바랍니다.\r\n"
							+ " \r\n"
							+ "★찾아오시는 길★\r\n"
							+ "전라북도 고창군 상하면 상하농원길 11-23\r\n"
							+ "★예약확인★\r\n"
							+ "상하농원사이트>마이페이지>체험예약 확인"
							+ " \r\n"
							+ "▶ Mypage에서 확인하기\r\n"
							+ "https://goo.gl/vuAs8c";

//					param.set("content", "[상하농원] " + info.get("name") + "님의 " + info.get("reserve_date") + " 상하농원 체험 예약이 완료되었습니다.\n- 체험 시작 20분 전까지 매표소 입장부탁드립니다.\n- 체험이 시작되면 체험교실 입장이 제한 될 수 있습니다.\n- 체험 인원에 따라 포장시간이 지연 될 수 있습니다.\n★찾아오시는 길★\n전라북도 고창군 상하면 상하농원길 11-23\n★예약확인★\n상하농원사이트 > 마이페이지 > 체험예약 확인\n\n▶ Mypage에서 확인하기\nhttps://goo.gl/vuAs8c");
					param.set("content", contents);
					param.set("phone", info.get("mobile1") + info.get("mobile2") + info.get("mobile3"));
					param.set("sms_id", SMS_ID_01);
					this.sendSms(param);
				} else if("210".equals(info.get("status"))) {	// 결제취소
					Param param = new Param();
					param.set("content", "[상하농원] " + info.get("name") + "님의 상하농원 체험 예약이 취소되었습니다.\n\n▶ Mypage에서 확인하기\nhttps://goo.gl/vuAs8c");
					param.set("phone", info.get("mobile1") + info.get("mobile2") + info.get("mobile3"));
					param.set("sms_id", SMS_ID_01);
					this.sendSms(param);
				}
//			}
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
}
