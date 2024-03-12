package com.sanghafarm.common;

import java.io.File;

import com.efusioni.stone.common.Config;
import com.efusioni.stone.common.SystemChecker;
import com.efusioni.stone.utils.Utils;

public class Env {
	public static String getDocRoot() {
		return Config.get("docroot." + SystemChecker.getCurrentName());
	}
	
	public static String getSSLPath() {
		return Config.get("path.ssl." + SystemChecker.getCurrentName());
	}
	
	public static String getURLPath() {
		return Config.get("path.url." + SystemChecker.getCurrentName());
	}
	
	public static String getImagePath() {
		return Config.get("path.image." + SystemChecker.getCurrentName());
	}
	
	public static String getUploadPath() {
		return Config.get("path.upload." + SystemChecker.getCurrentName());
	}
	
	public static String getPointMaeildoUrl() {
		System.out.println("==================== : "+SystemChecker.getCurrentName());
		return Config.get("point.maeildo.url." + SystemChecker.getCurrentName());
	}
	
	public static String getMaeildoUrl() {
		return Config.get("maeildo.url." + SystemChecker.getCurrentName());
	}
	
	public static String getApiMaeildoUrl() {
		return Config.get("api.maeildo.url." + SystemChecker.getCurrentName());
	}
	
	
	// kakaopay
	public static String getKakaoMid() {
		return Config.get("kakaopay.mid." + SystemChecker.getCurrentName());
	}

	public static String getKakaoCancelPwd() {
		return Config.get("kakaopay.cancelpwd." + SystemChecker.getCurrentName());
	}

	public static String getKakaoMerchantEncKey() {
		return Config.get("kakaopay.merchantenckey." + SystemChecker.getCurrentName());
	}

	public static String getKakaoMerchantHashKey() {
		return Config.get("kakaopay.merchanthashkey." + SystemChecker.getCurrentName());
	}

	public static String getKakaoEncodeKey() {
		return Config.get("kakaopay.encodekey." + SystemChecker.getCurrentName());
	}

	public static String getKakaoLogHome() {
		return Utils.replace(Config.get("kakaopay.loghome." + SystemChecker.getCurrentName()), "/", File.separator);
	}

	public static String getKakaoCnsPayHome() {
		return Utils.replace(Config.get("kakaopay.cnspayhome." + SystemChecker.getCurrentName()), "/", File.separator);
	}
	// -------------------------
	
	// payco
	public static String getPaycoSellerKey() {
		return Config.get("payco.sellerkey." + SystemChecker.getCurrentName());       	
	}
	
	public static String getPaycoCpId() {
		return Config.get("payco.cpid." + SystemChecker.getCurrentName());
	}
	
	public static String getPaycoProductId() {
		return Config.get("payco.productid." + SystemChecker.getCurrentName());
	}
	
	public static String getPaycoDeliveryId() {
		return Config.get("payco.deliveryid." + SystemChecker.getCurrentName());
	}
	
	public static String getPaycoDeliveryReferenceKey() {
		return Config.get("payco.deliveryreferencekey." + SystemChecker.getCurrentName());
	}
	
	public static String getPaycoLogYn() {
		return Config.get("payco.logyn." + SystemChecker.getCurrentName());
	}
	// -------------------------

	
}
