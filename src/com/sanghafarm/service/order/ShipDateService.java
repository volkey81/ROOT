package com.sanghafarm.service.order;

import java.util.Calendar;

import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Utils;

public class ShipDateService extends IbatisService {
	
	public String getShipDate(String deliveryType, String format) {
		int hour = "5,6".indexOf(deliveryType) != -1 ? 18 : 15;
		Calendar cal = Calendar.getInstance();
		String day = (String) super._scalar("ShipDate.getShipDate", hour);
		
		if(day == null || "".equals(day)) {
			switch(cal.get(Calendar.DAY_OF_WEEK)) {
				case 1 :
					cal.add(Calendar.DATE, 2);
					break;
				case 2 :
				case 3 :
				case 4 :
				case 5 :
					if(cal.get(Calendar.HOUR_OF_DAY) < hour) {
						cal.add(Calendar.DATE, 1);
					} else {
						cal.add(Calendar.DATE, 2);
					}
					break;
				case 6 :
					if(cal.get(Calendar.HOUR_OF_DAY) < hour) {
						cal.add(Calendar.DATE, 1);
					} else {
						cal.add(Calendar.DATE, 4);
					}
					break;
				case 7 :
					cal.add(Calendar.DATE, 3);
					break;
			}
		} else {
			cal.set(Calendar.YEAR, Integer.parseInt(day.substring(0, 4)));
			cal.set(Calendar.MONTH, Integer.parseInt(day.substring(4, 6)) - 1);
			cal.set(Calendar.DATE, Integer.parseInt(day.substring(6)));
		}
		
		System.out.println(cal);
		return Utils.getTimeStampString(cal.getTime(), format);
	}
	
	/*
	public static String getExpectedDeliveryDay() {
		return ShipDateService.getExpectedDeliveryDay("1", "yyyy년MM월dd일");
	}
	*/

	public static String getExpectedDeliveryDay(String deliveryType) {
		return getExpectedDeliveryDay(deliveryType, "yyyy년MM월dd일");
	}

	public static String getExpectedDeliveryDay(String deliveryType, String format) {
		ShipDateService ship = new ShipDateService();
		return ship.getShipDate(deliveryType, format);
	}
}
