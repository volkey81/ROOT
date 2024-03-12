<%@page import="com.sanghafarm.service.product.ProductService"%>
<%@page import="org.apache.commons.collections4.CollectionUtils"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="jwork.cipher.client.JworkCrypto"%>
<%@page import="jwork.sso.agent.SSOManager"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*" %>
<%@page import="org.json.simple.*"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.*,
				com.efusioni.stone.utils.*,
				com.sanghafarm.common.*,
				com.sanghafarm.service.member.*" %>
<%-- 
    [ssologin]
    
	이 페이지는 findCookie 를 호출하여 1회용 접속 키를 얻어온 이후
	1회용 접속 키를 이용하여 통합회원 정보를 얻어오는 프로세스를 수행합니다.
    index 페이지에서 설명드린 것처럼 Ajax를 사용하는 경우는 컨트롤러에서 수행하셔도 됩니다.
    
    getSSOMemberInfoByKey API를 사용하여 사용자 정보를 얻어온 이후 해당 사용자의 정보를 이용하여
    자사 로그인 프로세스를 진행합니다. 
    
    * 내용 추가 =============================================================================
	sso 쿠키 정보를 이용하여, 통합회원번호(기존 member_no)를 가져온다.
	가져온 통합회원번호를 이용하여, 해당 사이트의 로그인 세션 및 쿠키 정보를 세팅한다.
    
	- 세션 정보
	getUserInfo(db select) 로 세션 정보를 가져온다.
	
	- 쿠키 정보
	getUserInfo(db select) 로 쿠키 정보를 가져온다.
	
 --%>

<%

	JSONObject result_json = new JSONObject();
	
	//index 페이지에서 받은 1회용 접속 키
	String j_sso_q = request.getParameter("j_sso_q");
	System.out.println("j_sso_q : " + j_sso_q);
	String responseMessage =  SSOManager.getSSOMemberInfoByKey(j_sso_q);
	System.out.println("--------------- sso response message : " + responseMessage);
	if( SSOManager.isSuccess(responseMessage)){
		//통합회원 서비스 번호
		String member_no = SSOManager.getResponseData(responseMessage);
		System.out.println("member_no : " + member_no);
		
		//-----------------------------------------------------------------------------
		// 이부분에서 통합회원 서비스 번호를 가지고 자사 DB에서 기타 회원정보를 
		// 조회하여 로그인 프로세스를 진행합니다.
		// 만일 서비스 이용 약관동의 회원이 아닌 경우는 약관동의 프로세스를 
		// 진행하시기 바랍니다.
		// 자사 DB가 없을시에는 생략
		//-----------------------------------------------------------------------------
		//SSOVO vo  = SSOUtil.getMeberInfoByUserNo(USER_NO);
		//String userId = "ssotest"; // 서비스 번호를 이용 자사 DB에서 회원정보 조회
		//String userId = vo.getUserID();
		
		//session 에 넣을 정보를 가져온다.
		MemberService svc = (new MemberService()).toProxyInstance();
		Param info = svc.getImInfo(Integer.parseInt(member_no));
		System.out.println("user_info : " + info);
		
		if(info == null || "".equals(info.get("UNFY_MMB_NO"))){
			//회원정보 찾기 실패
			result_json.put("CODE", "회원정보 찾기에 실패하였습니다.");
		}else{
			FrontSession fs = FrontSession.getInstance(request, response);
			fs.login(info);
			
			String userid = !"".equals(info.get("mmb_id")) ? info.get("mmb_id") : info.get("unfy_mmb_no") + "_" + info.get("soc_kind_cd");
			
			// 최근 본 상품 리스트가 있을경우 비회원 -> 회원로그인시 DB저장
			List<Param> recentList = (ArrayList<Param>)session.getAttribute("recentList");
			if (CollectionUtils.isNotEmpty(recentList)) {
				ProductService product = (new ProductService()).toProxyInstance();
				for (Param recentParam : recentList) {
					recentParam.set("userId", userid);
					product.mergeToRecentProduct(recentParam);
				}
			}
// 			result_json.put("user_info", info);
			result_json.put("userid", userid);
			result_json.put("CODE", "OK");
		}
		
	}else{ //getSSOMemberInfoByKey API가 정상적으로 동작하지 않은 경우
		System.out.println("[ getSSOMemberInfoByKey fail ]");
		System.out.println("code    : "+SSOManager.getResponseCode(responseMessage));
		System.out.println("message : "+SSOManager.getResponseMessage(responseMessage));
		
		result_json.put("CODE", "통합 로그인에 실패하였습니다.");
	}
	out.write(result_json.toString());
%>

