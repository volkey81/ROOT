<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			java.text.*,
			com.efusioni.stone.common.*,
			com.sanghafarm.common.*" %>
<%
	SimpleDateFormat dateformat = new SimpleDateFormat("yyyyMMdd HH:mm:ss");
	
	String sellerKey 			= Env.getPaycoSellerKey();       	// 가맹점 코드 - 파트너센터에서 알려주는 값으로, 초기 연동 시 PAYCO에서 쇼핑몰에 값을 전달한다.
	String cpId 				= Env.getPaycoCpId();	// 상점ID
	String productId 			= Env.getPaycoProductId();		// 상품ID
	String deliveryId 			= Env.getPaycoDeliveryId();	// 배송비상품ID
	String deliveryReferenceKey = Env.getPaycoDeliveryReferenceKey();			// 가맹점에서 관리하는 배송비상품 연동 키
	String serverType 			= SystemChecker.isReal() ? "REAL" : "DEV";			// 서버유형. DEV:개발, REAL:운영
	String logYn 				= Env.getPaycoLogYn();				// 로그Y/N
	
	
	//도메인명 or 서버IP  
	// String domainName = "xxx.xxx.xxx.xxx";   
	String domainName = request.getScheme() + "://" + request.getServerName();   
	
	boolean isMobile;
	String userAgent = request.getHeader("user-agent");
	boolean mobile1 = userAgent.matches(".*(iPhone|iPod|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mni|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson).*");
	boolean mobile2 = userAgent.matches(".*(LG|SAMSUNG|Samsung).*");
	if(mobile1||mobile2){
		isMobile = true;
	}else{
		isMobile = false;
	}
%>
