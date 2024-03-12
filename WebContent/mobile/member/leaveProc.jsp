<%@page import="com.sanghafarm.service.member.ImMemberService"%>
<%@page import="com.sanghafarm.common.Env"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.efusioni.stone.utils.Utils"%>
<%@ page import="com.efusioni.stone.utils.Param"%>
<%@ page import="com.zeroto7.sha256.Sha256Cipher"%>
<%@ page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@ page import="com.sanghafarm.common.*"%>
<%@ page import="com.efusioni.stone.common.SystemChecker"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="com.efusioni.stone.common.Config"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="com.sanghafarm.service.member.MemberService"%>
<%@ page import="com.efusioni.stone.ibatis.*"%>
<%@ page import="java.net.HttpURLConnection" %>

<%
	FrontSession fs = FrontSession.getInstance(request, response);
	Param param = new Param(request);
	String msg = StringUtils.EMPTY;
	
	response.setHeader("Pragma","no-cache");				// HTTP1.0 캐쉬 방지
	response.setDateHeader("Expires",0);					// proxy 서버의 캐쉬 방지
	response.setHeader("Pragma", "no-store");				// HTTP1.1 캐쉬 방지
	
	if("HTTP/1.1".equals(request.getProtocol())){
		response.setHeader("Cache-Control", "no-cache");	// HTTP1.1 캐쉬 방지
	}

	JSONObject result = new JSONObject();
	MemberService member = (new MemberService()).toProxyInstance();
// 	Param info = member.getImInfoById(SanghafarmUtils.getCookie(request, "saveid"));
// 	Param info = member.getImInfoById(fs.getUserId());
	Param info = member.getImInfo(fs.getUserNo());
	String disAgrUrl     = Config.get("api.info.disagreeUser." + SystemChecker.getCurrentName()); //APIURL
	String strCoopcoCd   = Config.get("join.parameter.coopcoCd");                       //제휴사코드
	String strchnlCd     = Config.get("join.parameter.chnlCd");                         //채널코드
	String successUrl    = Env.getURLPath();											//성공 URL
	String failUrl       = "";                                                          //실패 URL
	String query         = "";                                                          //postQuery
	String strResult     = "";                                                          //전송결과
	String strMessage    = "";                                                          //결과메세지
	String strResultCode = "";                                                          //결과코드
	
	try{
	
		if (info == null) {	
	 		strResult = "false";
	 		strMessage = "해당하는 회원정보가 존재하지 않습니다.";	
			return;
		}
		
		String strUnfyMmbNo  = info.get("UNFY_MMB_NO");                                     //통합회원번호
		failUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/memLeave2.jsp";
		
		ImMemberService imSvc = (new ImMemberService()).toProxyInstance();
		
		String orderid = imSvc.getOrderStatus(Long.parseLong(strUnfyMmbNo));
		
		// 파머스마켓 구매 진행중
		if(orderid != null && !"".equals(orderid)){
	 		strResult = "false";
	 		strMessage = "파머스마켓에서 구매(혹은 교환, 반품)가 미완료된 상품이 있어 탈퇴가 불가능합니다.";	
			return;
		}
		
		String torderid = imSvc.getTorderStatus(Long.parseLong(strUnfyMmbNo));
		
		// 농원 예약 진행중
		if(torderid != null && !"".equals(torderid)){
	 		strResult = "false";
	 		strMessage = "상하농원 입장권(혹은 체험권)이 예약상태에 있어 탈퇴가 불가능합니다.";	
			return;
		}
		
		// 상하가족
		Param sanghaInfo = imSvc.getSanghaInfo(Long.parseLong(strUnfyMmbNo));
		if(sanghaInfo != null && "Y".equals(sanghaInfo.get("family_yn"))){
	 		strResult = "false";
	 		strMessage = "상하가족 가입중인 회원은 탈퇴가 불가능합니다.\\n고객센터에서 상하가족 철회 후 탈퇴가 가능합니다.";	
			return;
		}
		
		//API통신용 쿼리작성
		query = "coopcoCd=" + strCoopcoCd + "&chnlCd=" + strchnlCd  + "&unfyMmbNo=" + info.get("UNFY_MMB_NO");
		
		//API통신
		result = SanghafarmUtils.getAPIDataInfo(disAgrUrl, query);
		
		//결과코드 취득
		strResultCode = result.getString("resultCode");	
		
		//결과코드 판별
	 	if(strResultCode.equals("S0000")){
	 		strResult = "true";
	 	}else{
	 		strResult = "false";
	 		strMessage = result.getString("resultMessage");	
	 	}
		
	}catch(Exception e){
		System.out.println("err");
	}finally{
%>
{
 "result" : "<%=strResult %>" ,
 "message" : "<%=strMessage %>"
}
<%		
	}
%>
