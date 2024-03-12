<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			java.security.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.google.gson.*"%>
<%
	Param param = new Param(request);
	Param result = null;

	String CST_PLATFORM         = SystemChecker.isReal() ? "service" : "test";          //LG유플러스 결제서비스 선택(test:테스트, service:서비스)
	String CST_MID              = Config.get("lgdacom.CST_MID");                      //LG유플러스로 부터 발급받으신 상점아이디를 입력하세요.
	String LGD_MERTKEY          = Config.get("lgdacom.LGD_MERTKEY");   					//상점MertKey(mertkey는 상점관리자 -> 계약정보 -> 상점정보관리에서 확인하실수 있습니다)

	if("hotel".equals(param.get("GB"))) {
		CST_MID              = Config.get("lgdacom.CST_MID2");      
		LGD_MERTKEY          = Config.get("lgdacom.LGD_MERTKEY2"); 
	} else if("exp".equals(param.get("GB"))) {
		CST_MID              = Config.get("lgdacom.CST_MID3");      
		LGD_MERTKEY          = Config.get("lgdacom.LGD_MERTKEY3"); 
	}
	
	String LGD_MID              = ("test".equals(CST_PLATFORM.trim())?"t":"")+CST_MID;  //테스트 아이디는 't'를 제외하고 입력하세요.

	System.out.println("----- xpay hash CST_MID : " + CST_MID);
	System.out.println("----- xpay hash LGD_MERTKEY : " + LGD_MERTKEY);
	
	try{
		StringBuffer sb = new StringBuffer();
		sb.append(LGD_MID);
		sb.append(param.get("LGD_OID"));
		sb.append(param.get("LGD_AMOUNT"));
		sb.append(param.get("LGD_TIMESTAMP"));
		sb.append(LGD_MERTKEY);
		
		byte[] bNoti = sb.toString().getBytes();
		MessageDigest md = MessageDigest.getInstance("MD5");
		byte[] digest = md.digest(bNoti);
		
		StringBuffer strBuf = new StringBuffer();
		for (int i=0 ; i < digest.length ; i++) {
		    int c = digest[i] & 0xff;
		    if (c <= 15){
		        strBuf.append("0");
		    }
		    strBuf.append(Integer.toHexString(c));
		}
		
		String LGD_HASHDATA = strBuf.toString();

		result = new Param("result", true, "hash", LGD_HASHDATA);
	}
	catch (Exception e) {
		e.printStackTrace();
		result = new Param("result", false, "hash", "");
	}

	session.setAttribute("DB_AMOUNT", param.get("LGD_AMOUNT"));

	Gson gson = new Gson();
	System.out.println("---------- xpay hash result : " + gson.toJson(result));
	out.print(gson.toJson(result));
%>