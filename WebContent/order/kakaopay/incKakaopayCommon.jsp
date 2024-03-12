<%@ page import="com.sanghafarm.common.*" %>
<%!
	//1. 로그 디렉토리 위치 
	// ex) C:\\KMpay (windows는 \\ 사용, 유닉스와 리눅스는 / 사용에 주의)
	public static String logHome = Env.getKakaoLogHome();
	
	//2. 환경설정 파일(cnspay.properties)가 포함된 디렉토리 경로 설정
	// properties 파일의 실제 소스위치까지만 기록하고 파일명까지는 입력하지 않도록 주의
	// ex) C:\\KMPay\\workspace\\KMpay\\WebContent
	public static String cnsPayHome = Env.getKakaoCnsPayHome();
	
	//3. 가맹점키 세팅(MID 별로 상이함)
	public static String encodeKey = Env.getKakaoEncodeKey();
	
	//4. 결제요청용 키값
	public static String MID = Env.getKakaoMid();
	
	//5. TXN_ID 호출전용 키값
	public static String merchantEncKey = Env.getKakaoMerchantEncKey();
	public static String merchantHashKey = Env.getKakaoMerchantHashKey();
	
	public static String cancelPwd = Env.getKakaoCancelPwd();
%>
