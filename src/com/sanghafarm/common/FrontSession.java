package com.sanghafarm.common;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang.StringUtils;

import com.efusioni.stone.common.SystemChecker;
import com.efusioni.stone.utils.Param;
import com.sanghafarm.service.imc.ImcService;
import com.sanghafarm.service.member.FamilyMemberService;
import com.sanghafarm.service.member.MemberService;
import com.sanghafarm.service.order.CartService;
import com.sanghafarm.service.order.CouponService;
import com.sanghafarm.service.order.OffCouponService;
import com.sanghafarm.service.product.ProductService;
import com.sanghafarm.utils.SanghafarmUtils;

public class FrontSession {
	private HttpServletRequest request = null;
	private HttpServletResponse response = null;
	private String deviceType;
	private String domain = ".sanghafarm.co.kr";
	
	public static String LOGIN_MSG = "로그인이 필요합니다.";
	
	private FrontSession(HttpServletRequest request, HttpServletResponse response) {
		this.request = request;
		this.response = response;
		String appYn = SanghafarmUtils.getCookie(request, "APP_YN", "N");
		if("Y".equals(appYn)) {
			this.deviceType = "A";
		} else {
			this.deviceType = (request.getServletPath().indexOf("/mobile/") == 0) ? "M" : "P";
		}
	}
	
	public static FrontSession getInstance(HttpServletRequest request, HttpServletResponse response) {
		return new FrontSession(request, response);
	}
	
	public String getDeviceType() {
		return deviceType;
	}
	
	public boolean isLogin() {
		return !"".equals(SanghafarmUtils.getCookie(request, "UNFY_MMB_NO"));
	}
	
	public void login(Param info) {
		login(this.request, info, -1);
	}

	public void login(Param info, int expiry) {
		login(this.request, info, expiry);
	}

	public void login(HttpServletRequest request, Param info) {
		login(request, info, -1);
	}

	public void login(HttpServletRequest request, Param info, int expiry) {
		login(request, info, this.domain, expiry);
	}
	
	public void login(HttpServletRequest request, Param info, String domain, int expiry) {
		String userid = !"".equals(info.get("mmb_id")) ? info.get("mmb_id") : info.get("unfy_mmb_no") + "_" + info.get("soc_kind_cd");
		String snsYn = !"".equals(info.get("mmb_id")) ? "N" : "Y";
		
		SanghafarmUtils.setCookie(response, "MMB_ID", 			userid,				 			domain, expiry);
		SanghafarmUtils.setCookie(response, "MMB_NM", 			info.get("mmb_nm"), 			domain, expiry);
		SanghafarmUtils.setCookie(response, "UNFY_MMB_NO",		info.get("unfy_mmb_no"), 		domain, expiry);
		SanghafarmUtils.setCookie(response, "SOC_KIND_CD", 		info.get("soc_kind_cd"), 		domain, expiry);
		SanghafarmUtils.setCookie(response, "SOC_MMB_YN", 		info.get("soc_mmb_yn"), 		domain, expiry);
		SanghafarmUtils.setCookie(response, "WRLS_TEL_NO", 		info.get("wrls_tel_no"), 		domain, expiry);
		SanghafarmUtils.setCookie(response, "EML_ADDR", 		info.get("eml_addr"), 			domain, expiry);
		SanghafarmUtils.setCookie(response, "ADDR_FLAG", 		info.get("addr_flag"), 			domain, expiry);
		SanghafarmUtils.setCookie(response, "ZIP_ZONE_NO", 		info.get("zip_zone_no"),		domain, expiry);
		SanghafarmUtils.setCookie(response, "ZIP_BASE_ADDR", 	info.get("zip_base_addr"), 		domain, expiry);
		SanghafarmUtils.setCookie(response, "ZIP_DTLS_ADDR",	info.get("zip_dtls_addr"),		domain, expiry);
		SanghafarmUtils.setCookie(response, "ROZIP_ZONE_NO", 	info.get("rozip_zone_no"), 		domain, expiry);
		SanghafarmUtils.setCookie(response, "ROZIP_BASE_ADDR", 	info.get("rozip_base_addr"), 	domain, expiry);
		SanghafarmUtils.setCookie(response, "ROZIP_DTLS_ADDR", 	info.get("rozip_dtls_addr"), 	domain, expiry);
		SanghafarmUtils.setCookie(response, "ROZIP_REFN_ADDR", 	info.get("rozip_refn_addr"), 	domain, expiry);
		SanghafarmUtils.setCookie(response, "SNS_YN", 			snsYn, 							domain, expiry);
		SanghafarmUtils.setCookie(response, "CARD_NO",			info.get("crd_no"),				domain, expiry);
		SanghafarmUtils.setCookie(response, "STAFF_YN",			info.get("stff_dv_cd"),			domain, expiry);
		SanghafarmUtils.setCookie(response, "ADULT_AUTH",		info.get("adult_auth"),			domain, expiry);

		FamilyMemberService family = (new FamilyMemberService()).toProxyInstance();
		Param familyInfo = family.getInfo(info.getLong("unfy_mmb_no"));
		
		System.out.println("============== stff_dv_cd : " + userid + " - " + info.get("stff_dv_cd") + " ---------------");
		System.out.println("============== " + userid + " is family !!! --------------- " + familyInfo.get("family_grade_code"));

		if(!"".equals(info.get("naver_empno"))) {	// 네이버 임직원 회원 인증
			MemberService member = (new MemberService()).toProxyInstance();
			boolean b = member.naverEmpAuth(info.get("naver_empno"));
			System.out.println("============== naver auth : " + userid + " - " + b + " ---------------");
			if(b) {
				info.set("grade_code", "005");
			} else {
				member.mergeNaverEmpno(new Param("userid", userid, "naver_empno", ""));
			}
		}
		
		if("005".equals(info.get("grade_code"))) {	// 네이버
			SanghafarmUtils.setCookie(response, "GRADE_CODE", 	info.get("grade_code"), 	domain, expiry);
		} else if("1".equals(info.get("stff_dv_cd"))) {	// 임직원
			if("Y".equals(familyInfo.get("family_yn")) && "003".equals(familyInfo.get("family_grade_code"))) {
				SanghafarmUtils.setCookie(response, "GRADE_CODE", 	"003", 	domain, expiry);
			} else {
				SanghafarmUtils.setCookie(response, "GRADE_CODE", 	"002", 	domain, expiry);
			}
		} else if("Y".equals(familyInfo.get("family_yn"))) {	// 상하가족
			SanghafarmUtils.setCookie(response, "GRADE_CODE", 	familyInfo.get("family_grade_code"), 	domain, expiry);
		} else {
			SanghafarmUtils.setCookie(response, "GRADE_CODE", 	info.get("grade_code"), 	domain, expiry);
		}
		
		// chrome 80
		/*
		try {
			response.addHeader("Set-Cookie", "JSESSIONID=" + request.getSession().getId() 
				+ "; HttpOnly; Path=/; Version=0; SameSite=None; Secure;");
		} catch(Exception e) {
			e.printStackTrace();
		}
		*/
		
//		integrateCart(userid);
		mergeToRecentProduct(userid);
		mergeToCartList(userid);
		setCoupon(info);
	}
	
	public void logout() {
		int expiry = 0;
		
		SanghafarmUtils.setCookie(response, "MMB_ID", 			"", domain, expiry);
		SanghafarmUtils.setCookie(response, "MMB_NM", 			"", domain, expiry);
		SanghafarmUtils.setCookie(response, "UNFY_MMB_NO",		"", domain, expiry);
		SanghafarmUtils.setCookie(response, "SOC_KIND_CD", 		"", domain, expiry);
		SanghafarmUtils.setCookie(response, "SOC_MMB_YN", 		"", domain, expiry);
		SanghafarmUtils.setCookie(response, "WRLS_TEL_NO", 		"", domain, expiry);
		SanghafarmUtils.setCookie(response, "EML_ADDR", 		"", domain, expiry);
		SanghafarmUtils.setCookie(response, "ADDR_FLAG", 		"", domain, expiry);
		SanghafarmUtils.setCookie(response, "ZIP_ZONE_NO",		"", domain, expiry);
		SanghafarmUtils.setCookie(response, "ZIP_BASE_ADDR", 	"", domain, expiry);
		SanghafarmUtils.setCookie(response, "ZIP_DTLS_ADDR",	"", domain, expiry);
		SanghafarmUtils.setCookie(response, "ROZIP_ZONE_NO",	"", domain, expiry);
		SanghafarmUtils.setCookie(response, "ROZIP_BASE_ADDR", 	"", domain, expiry);
		SanghafarmUtils.setCookie(response, "ROZIP_DTLS_ADDR", 	"", domain, expiry);
		SanghafarmUtils.setCookie(response, "ROZIP_REFN_ADDR", 	"", domain, expiry);
		SanghafarmUtils.setCookie(response, "SNS_YN", 			"", domain, expiry);
		SanghafarmUtils.setCookie(response, "CARD_NO", 			"", domain, expiry);
		SanghafarmUtils.setCookie(response, "STAFF_YN", 		"", domain, expiry);
		SanghafarmUtils.setCookie(response, "ADULT_AUTH", 		"", domain, expiry);

		// 부가정보
		SanghafarmUtils.setCookie(response, "GRADE_CODE", 		"", domain, expiry);
		SanghafarmUtils.setCookie(response, "TEMP_ID", 			"", domain, expiry);
	}
	
	public int getUserNo() {
		return Integer.parseInt(SanghafarmUtils.getCookie(request, "UNFY_MMB_NO", "0"));
	}

	public long getUserNoLong() {
		return Long.parseLong(SanghafarmUtils.getCookie(request, "UNFY_MMB_NO", "0"));
	}

	public String getUserId() {
		if(isLogin()) {
			return SanghafarmUtils.getCookie(request, "MMB_ID");
		} else {
			return "";
		}
	}

	public String getUserNm() {
		return SanghafarmUtils.getCookie(request, "MMB_NM");
	}

	public String getEmail() {
		return SanghafarmUtils.getCookie(request, "EML_ADDR");
	}
	
	public String getEmail1() {
		String email = SanghafarmUtils.getCookie(request, "EML_ADDR");
		if(email != null && email.indexOf("@") != -1) {
			return email.substring(0, email.indexOf("@"));
		} else {
			return "";
		}
	}
	
	public String getEmail2() {
		String email = SanghafarmUtils.getCookie(request, "EML_ADDR");
		if(email != null && email.indexOf("@") != -1) {
			return email.substring(email.indexOf("@") + 1);
		} else {
			return "";
		}
	}
	
	public String getMobile() {
		return SanghafarmUtils.getCookie(request, "WRLS_TEL_NO");
	}
	
	public String getMobileWithoutHyphen() {
		return SanghafarmUtils.getCookie(request, "WRLS_TEL_NO").replaceAll("-", "");
	}
	
	public String getMobile1() {
		String mobile = SanghafarmUtils.getCookie(request, "WRLS_TEL_NO");
		if(mobile != null && mobile.indexOf("-") != -1) {
			return mobile.substring(0, mobile.indexOf("-"));
		} else {
			return "";
		}
	}
	
	public String getMobile2() {
		String mobile = SanghafarmUtils.getCookie(request, "WRLS_TEL_NO");
		if(mobile != null && mobile.indexOf("-") != -1) {
			return mobile.substring(mobile.indexOf("-") + 1, mobile.lastIndexOf("-"));
		} else {
			return "";
		}
	}
	
	public String getMobile3() {
		String mobile = SanghafarmUtils.getCookie(request, "WRLS_TEL_NO");
		if(mobile != null && mobile.indexOf("-") != -1) {
			return mobile.substring(mobile.lastIndexOf("-") + 1);
		} else {
			return "";
		}
	}
	
	public String getGradeCode() {
		String gradeCode = SanghafarmUtils.getCookie(request, "GRADE_CODE");
		
		/*
		if(gradeCode == null || "".equals(gradeCode)) {
			if(isLogin()) {
				MemberService member = (new MemberService()).toProxyInstance();
				Param imInfo = member.getImInfo(getUserNo());
				
				// 임직원 체크
				System.out.println("============== getGradeCode() stff_dv_cd : " + imInfo.get("stff_dv_cd") + " ---------------");
				if("1".equals(imInfo.get("stff_dv_cd"))) {	// 임직원
					gradeCode = "002";
				} else {
					gradeCode = imInfo.get("grade_code");
				}
			} else {
				gradeCode = "";
			}

			SanghafarmUtils.setCookie(response, "GRADE_CODE", gradeCode, domain, -1);
		}
		*/

//		return gradeCode;
		return isLogin() ? gradeCode : "006";
	}

	public String getZipCode() throws UnsupportedEncodingException {
		return "1".equals(SanghafarmUtils.getCookie(request, "ADDR_FLAG")) ? SanghafarmUtils.getCookie(request, "ROZIP_ZONE_NO") : SanghafarmUtils.getCookie(request, "ZIP_ZONE_NO");
	}

	public String getAddr1() throws UnsupportedEncodingException {
		return "1".equals(SanghafarmUtils.getCookie(request, "ADDR_FLAG")) ? SanghafarmUtils.getCookie(request, "ROZIP_BASE_ADDR") : SanghafarmUtils.getCookie(request, "ZIP_BASE_ADDR");
	}

	public String getAddr2() throws UnsupportedEncodingException {
		String addr = "";
		if("1".equals(SanghafarmUtils.getCookie(request, "ADDR_FLAG"))) {
			addr = SanghafarmUtils.getCookie(request, "ROZIP_DTLS_ADDR");
			if(!"".equals(SanghafarmUtils.getCookie(request, "ROZIP_REFN_ADDR"))) {
//				addr += "(" + SanghafarmUtils.getCookie(request, "ROZIP_REFN_ADDR") + ")";
			}
		} else {
			addr = SanghafarmUtils.getCookie(request, "ZIP_DTLS_ADDR");
		}
		return addr;
	}

	public String getDomain() {
		return this.domain;
	}
	
	public String getTempUserId() {
		String temp = SanghafarmUtils.getCookie(request, "TEMP_ID");
		if(temp == null || "".equals(temp)) {
			CartService cart = (new CartService()).toProxyInstance();
			temp = cart.getNewId();
			
			SanghafarmUtils.setCookie(response, "TEMP_ID", temp, this.domain, -1);
		}
		
		return temp;
	}
	
	public String getCardNo() {
		String crdNo = SanghafarmUtils.getCookie(request, "CARD_NO");
		if((crdNo == null || "".equals(crdNo)) && this.isLogin()) {
			MemberService svc = (new MemberService()).toProxyInstance();
			Param memInfo = svc.getImInfo(this.getUserNo());
			crdNo = memInfo.get("crd_no");
			SanghafarmUtils.setCookie(response, "CARD_NO", crdNo, domain, -1);
		}
		
		return crdNo;
	}
	
	public void integrateCart(String userid) {
		String temp = SanghafarmUtils.getCookie(request, "TEMP_ID");

		if(temp != null && !"".equals(temp)) {
//			CartService cart = (new CartService()).toProxyInstance();
//			cart.modifyUserid(new Param("userid", userid, "temp_userid", temp));
			SanghafarmUtils.setCookie(response, "TEMP_ID", "", this.domain, -1);
		}
	}
	
	@SuppressWarnings("unchecked")
	public void mergeToRecentProduct(String userid) {
		HttpSession session = request.getSession();
		// 최근 본 상품 리스트가 있을경우 비회원 -> 회원로그인시 DB저장
		List<Param> recentList = (ArrayList<Param>) session.getAttribute("recentList");
		if (CollectionUtils.isNotEmpty(recentList)) {
			ProductService product = (new ProductService()).toProxyInstance();
			for (Param recentParam : recentList) {
				recentParam.set("userid", userid);
				product.mergeToRecentProduct(recentParam);
			}
		}
	}
	
	private void mergeToCartList(String userid) {
		String temp = SanghafarmUtils.getCookie(request, "TEMP_ID");
		if (StringUtils.isNotEmpty(temp)) {
			CartService cart = (new CartService()).toProxyInstance();
			List<Param> tempCartList = cart.getAllList(new Param("grade_code", getGradeCode(), "userid", temp));
			if (CollectionUtils.isNotEmpty(tempCartList)) {
				cart.removeAll(temp);
				for (Param param : tempCartList) {
					param.set("userid", userid);
					cart.mergeToCartList(param);
				}
			}
		}
		SanghafarmUtils.setCookie(response, "TEMP_ID", "", this.domain, -1);
	}
	
	private void setCoupon(Param info) {
		CouponService coupon = (new CouponService()).toProxyInstance();
		OffCouponService off = (new OffCouponService()).toProxyInstance();
		String userid = !"".equals(info.get("mmb_id")) ? info.get("mmb_id") : info.get("unfy_mmb_no") + "_" + info.get("soc_kind_cd");
		ImcService imc = (new ImcService()).toProxyInstance();

		// 2021.04.05 ~ 04.30 가입자 -------------------------------------------------
		/*
		try {
			String sdate = "20210405000000";
			String edate = "20210430235959";

			if(sdate.compareTo(info.get("reg_dtm")) <= 0 && edate.compareTo(info.get("reg_dtm")) >= 0) {
				String[] coupons = {
						"2021033110054585242",
						"2021033110043685221",
						"2021033110033885174"
					};

				for(String couponid : coupons) {
					Param p = new Param("userid", userid, "couponid", couponid);
					
					int cnt = coupon.getDownloadedCnt(p);
					if(cnt == 0) {
						coupon.createMemCoupon(p);
						System.out.println("---------- " + userid + " 2021.04.05 ~ 04.30 신규가입 쿠폰 발행 완료 " + couponid + " ----------");
					}
				}
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		*/
		
		// 2021.03.01 이후 가입자 ----------------------------------------------------
		try {
			String sdate = SystemChecker.isReal() ? "20210301000000" : "20210217000000";

			if(sdate.compareTo(info.get("reg_dtm")) <= 0) {
				String couponid = "2021021511144174601";
				Param p = new Param("userid", userid, "couponid", couponid);
				
				int cnt = coupon.getDownloadedCnt(p);
				if(cnt == 0) {
					coupon.createMemCoupon(p);

					
					// 2022.04.06 10:00 ~ 2022.05.03 10:00 가입자는 2021021511144174601 하나 더 지급
					if("20220406100000".compareTo(info.get("reg_dtm")) <= 0 && "20220503100000".compareTo(info.get("reg_dtm")) >= 0) {
						coupon.createMemCoupon(p);
						System.out.println("~~~~~~~~~~~~~~ one more 2021021511144174601 ~~~~~~~~~~~ " + userid);
					}
					// --------
					
					/* 2024.01.19 오프라인 쿠폰 발행 중단
					String[] coupons = {
							"2021022504131887968",
							"2021022516374798703",
							"2021022615373119570",
							"2021022615404719636",
							"2021022615414019659",
							"2021022615425719683"
						};
					
					for(String c : coupons) {
						p = new Param("unfy_mmb_no", info.get("unfy_mmb_no"), "couponid", c);
						off.createMemCoupon(p);
					}
					*/

					imc.sendJoinTalk2(userid, info.get("wrls_tel_no"), info.get("mmb_nm"));
					System.out.println("---------- " + userid + " 신규가입 감사쿠폰(무료배송) 발행 완료 " + couponid + " ----------");
				}
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		// 2019.05.28 이후 가입자 ----------------------------------------------------
		// 신규가입감사쿠폰 : 운영-2019052116031644798, 개발-2019052213570070901
		// 신규가입감사 무료입장권 : 운영-2019051715362785474, 개발-2019052213593870902
		try {
			String sdate = SystemChecker.isReal() ? "20190522000000" : "20190522000000";
			
			if(sdate.compareTo(info.get("reg_dtm")) <= 0) {
				String couponid = SystemChecker.isReal() ? "2019052116031644798" : "2019052213570070901";
				Param p = new Param("userid", userid, "couponid", couponid);
				
				int cnt = coupon.getDownloadedCnt(p);
				if(cnt == 0) {
					coupon.createMemCoupon(p);

					/* 20201019 김은아대리 요청
					couponid = SystemChecker.isReal() ? "2019051715362785474" : "2019052213593870902";
					p = new Param("unfy_mmb_no", info.get("unfy_mmb_no"), "couponid", couponid);
					off.createMemCoupon(p);
					off.createMemCoupon(p);	// 무료입장권2매
					*/

//					imc.sendJoinTalk(userid, info.get("wrls_tel_no"), info.get("mmb_nm"));
					System.out.println("---------- " + userid + " 신규가입 감사쿠폰 발행 완료 " + couponid + " ----------");
				}
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		// 2020.04.06 10시 이후 가입자
		// 쿠폰번호 : 운영-2020040317341600270, 개발-x
		/* 2020.05.06 삭제
		try {
			if(SystemChecker.isReal() && "20200406100000".compareTo(info.get("reg_dtm")) <= 0) {
				String couponid = "2020040317341600270";
				Param p = new Param("userid", userid, "couponid", couponid);
				
				int cnt = coupon.getDownloadedCnt(p);
				if(cnt == 0) {
					coupon.createMemCoupon(p);
					System.out.println("---------- " + userid + " 2020.04.06 10시 이후 가입자 쿠폰 발행 완료 " + couponid + " ----------");
				}
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		*/
		
		// 2017.04.12 이후 가입자
		// 쿠폰번호 : 운영-2017041121472786319, 개발-2017041121443884599
		/* 2018.10.25
		try {
			if("20170412000000".compareTo(info.get("reg_dtm")) <= 0) {
				String couponid = SystemChecker.isReal() ? "2017041121472786319" : "2017041121443884599";
				Param p = new Param("userid", userid, "couponid", couponid);
				
				int cnt = svc.getDownloadedCnt(p);
				if(cnt == 0) {
					svc.createMemCoupon(p);
					System.out.println("---------- " + userid + " 2017.04.12 이후 가입자 쿠폰 발행 완료 " + couponid + " ----------");
				}
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		*/
		
		// 2017.04.12 이후 구매이력이 있는 회원
		// (리뉴얼 후 구매 감사) 재구매쿠폰, 쿠폰번호 : 운영-2017042517353150373, 개발-2017042110172189946
		/* 2018.10.25
		try {
			if(svc.getPromotionCondition1(userid)) {
				String couponid = SystemChecker.isReal() ? "2017042517353150373" : "2017042110172189946";
				Param p = new Param("userid", userid, "couponid", couponid);
				
				int cnt = svc.getDownloadedCnt(p);
				if(cnt == 0) {
					svc.createMemCoupon(p);
					System.out.println("---------- " + userid + " 2017.04.12 이후 구매 회원 쿠폰 발행 완료 " + couponid + " ----------");
				}
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		*/
	}
	
	public boolean isApp(){
		return !"".equals(SanghafarmUtils.getCookie(request, "APP_YN"));
	}
	
	public String getAppOS(){
		String userAgent = request.getHeader("User-Agent").toLowerCase();
		String os = StringUtils.EMPTY;
		if(userAgent.indexOf("android") > -1) os = "android";
		else os = "ios";
		return os;
	}

	public String getSnsYn() {
		return SanghafarmUtils.getCookie(request, "SNS_YN");
	}
	
	public void setGradeCode(String gradeCode) {
		SanghafarmUtils.setCookie(response, "GRADE_CODE", gradeCode, this.domain, -1);
	}
	
	public boolean isSns() {
		return "Y".equals(SanghafarmUtils.getCookie(request, "SNS_YN"));
	}
	
	public boolean isStaff() {
		return "1".equals(SanghafarmUtils.getCookie(request, "STAFF_YN"));
	}
	
	public boolean isAdult() {
		return "Y".equals(SanghafarmUtils.getCookie(request, "ADULT_AUTH"));
	}
}
