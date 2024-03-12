<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="net.sf.json.JSONSerializer"%>
<%@ page import="com.efusioni.stone.common.Config"%>
<%@ page import="com.efusioni.stone.common.SystemChecker"%>
<%@ page import="com.sanghafarm.utils.SanghafarmUtils"%>
<%@ page import="com.sanghafarm.common.*"%>
<%@ page import="com.sanghafarm.service.member.*"%>
<%@ page import="com.efusioni.stone.utils.Param"%>
<%@ page import="com.efusioni.stone.utils.Utils"%>
<%@ page import="java.net.URLEncoder"%>
<%
    response.setHeader("Pragma", "no-cache" );
    response.setDateHeader("Expires", 0);
    response.setHeader("Pragma", "no-store");
    response.setHeader("Cache-Control", "no-cache" );
    Param param = new Param(request);

    // 변수 -------------------------------------------------------------------------------------------------------------
	String strRetInfo   = "";                                                        // 고객정보(암호화)
	String strEncPara   = "";                                                        // 통합 파라미터
	String strDecPara   = "";                                                        // 고객정보(암호화ㅌ)
    String strEncMsg    = "";                                                        // HMAC 메세지
    String reqNum       = "";                                                        // 요청번호(복호화)
    String vDiscrNo     = "";                                                        // 가상식별번호
    String name         = "";                                                        // 성명
    String strResult    = "";                                                        // 결과값 (1인경우에만 정상)
	String age          = "";                                                        // 나이
    String gender       = "";                                                        // 성별(M-남, F-여)
	String ip           = "";                                                        // 접속IP
    String authInfo     = "";														 // 발급수단정보	
    String birth        = "";                                                        // 생년월일
    String fgn          = "";                                                        // 외국인구분
	String discrHash    = "";                                                        // 중복가입확인정보
	String ciVersion	= "";														 // 연계정보 버젼
	String strCi        = "";                                                        // 연계정보
	String msgChk       = "N";                                                       // 위조/변조 검증 결과
	String strUnfyMmbNo = "";                                                        // 통합회원번호
	String query        = "";                                                        // postQuery
	String strScreenCd  = Utils.safeHTML(param.get("screenCd"));                     // 화면정보
	String successUrl   = request.getScheme() + "://" + request.getServerName();     // 처리성공시URL
	String failUrl      = request.getScheme() + "://" + request.getServerName();     // 처리실패시URL
	String strPwdFindId = Utils.safeHTML(param.get("reqId"));                        // 아이디
	
	//회원가입
	if(strScreenCd.equals("join")){
		failUrl = failUrl + "/mobile/member/joinStep2.jsp"; 
		successUrl = successUrl + "/mobile/member/joinStep3.jsp";
	//재가입
	}else if(strScreenCd.equals("reJoin")){	
		failUrl = failUrl + "/mobile/member/joinStep2.jsp?reJoin=Y";
		successUrl = successUrl + "/mobile/member/memRejoin2.jsp";
	//아이디 찾기
	}else if(strScreenCd.equals("findId")){
		failUrl = failUrl + "/mobile/member/findId1.jsp";
	//비밀번호 찾기
	}else if(strScreenCd.equals("findPwd")){
		failUrl = failUrl + "/mobile/member/findPwd1.jsp";
		successUrl = successUrl + "/mobile/member/findPwd2.jsp";
	//휴먼계정해제
	}else if(strScreenCd.equals("memInactive")){
		failUrl = failUrl + "/mobile/member/memInactive2.jsp";
		successUrl = successUrl + "/mobile/member/memRejoin2.jsp";	
	} else if("adultAuth".equals(strScreenCd)) {	// 성인인증
		
	}
	
	// API통신용 변수
	String strCoopcoCd   = Config.get("join.parameter.coopcoCd");               //제휴사코드
	String strchnlCd     = Config.get("join.parameter.chnlCd");                 //채널코드
	String strResultCode = "";                                                  //처리코드
	String resultMessage = "";                                                  //처리메세지
	String apiUrl        = "";                                                  //APIURL
	String apiData       = "";                                                  //API통신데이터
	JSONObject result    = new JSONObject();                                    //통신결과(JSONObject)

    //-----------------------------------------------------------------------------------------------------------------

    try{

		//쿠키값 가져 오기
		String tranjectionName = "";
		String tranjectionReqNum = "";
		
        // Parameter 수신 --------------------------------------------------------------------
        strRetInfo  = request.getParameter("retInfo").trim();
        tranjectionReqNum = SanghafarmUtils.getCookie(request, "reqNum");
        
        // 1. 암호화 모듈 (jar) Loading
        com.sci.v2.ipin.secu.SciSecuManager sciSecuMg = new com.sci.v2.ipin.secu.SciSecuManager();

        strRetInfo  = sciSecuMg.getDec(strRetInfo, tranjectionReqNum);

        StringBuffer retInfoTemp    = new StringBuffer("");

        // 2.1차 파싱---------------------------------------------------------------
        int inf1 = strRetInfo.indexOf("/",0);
        int inf2 = strRetInfo.indexOf("/",inf1+1);

        strEncPara  = strRetInfo.substring(0,inf1);         //암호화된 통합 파라미터
        strEncMsg   = strRetInfo.substring(inf1+1,inf2);    //암호화된 통합 파라미터의 Hash값

        // 3.위/변조 검증 ---------------------------------------------------------------
        if(sciSecuMg.getMsg(strEncPara).equals(strEncMsg)){
            msgChk="Y";
         }

		if(msgChk.equals("N")){
			return;
		}

        // 4.파라미터별 값 가져오기 ---------------------------------------------------------------
        strDecPara  = sciSecuMg.getDec(strEncPara, tranjectionReqNum);

		int info1 = strDecPara.indexOf("/",0);
        int info2 = strDecPara.indexOf("/",info1+1);
        int info3 = strDecPara.indexOf("/",info2+1);
        int info4 = strDecPara.indexOf("/",info3+1);
    	int info5 = strDecPara.indexOf("/",info4+1);
        int info6 = strDecPara.indexOf("/",info5+1);
        int info7 = strDecPara.indexOf("/",info6+1);
        int info8 = strDecPara.indexOf("/",info7+1);
        int info9 = strDecPara.indexOf("/",info8+1);
        int info10 = strDecPara.indexOf("/",info9+1);
        int info11 = strDecPara.indexOf("/",info10+1);
        int info12 = strDecPara.indexOf("/",info11+1);
        int info13 = strDecPara.indexOf("/",info12+1);
		reqNum     = strDecPara.substring(0,info1);
        vDiscrNo   = strDecPara.substring(info1+1,info2);
        name       = strDecPara.substring(info2+1,info3);
        strResult  = strDecPara.substring(info3+1,info4);
        age        = strDecPara.substring(info4+1,info5);
        gender     = strDecPara.substring(info5+1,info6);
        ip         = strDecPara.substring(info6+1,info7);
        authInfo   = strDecPara.substring(info7+1,info8);
        birth      = strDecPara.substring(info8+1,info9);
        fgn        = strDecPara.substring(info9+1,info10);
        discrHash  = strDecPara.substring(info10+1,info11);
        ciVersion  = strDecPara.substring(info11+1,info12);		//CI관련 데이터는 계약시 설정하는 값입니다.  
        strCi      = strDecPara.substring(info12+1,info13);		//데이터를 원하실 경우 영업팀을 통해 승인받으신후 주석제거 해주십시요	
 		discrHash  = sciSecuMg.getDec(discrHash, tranjectionReqNum); //중복가입확인정보는 한번더 복호화
 		strCi  = sciSecuMg.getDec(strCi, tranjectionReqNum); //연계정보는 한번더 복호화


		//회원가입 여부 체크
		if(strScreenCd.equals("join") && strResult.equals("1")){
			apiUrl = Config.get("api.join.checkJoin." + SystemChecker.getCurrentName()); //APIURL
		
			query = "coopcoCd=" + strCoopcoCd + "&chnlCd=" + strchnlCd + "&ci=" + URLEncoder.encode(strCi, "UTF-8");
			result = SanghafarmUtils.getAPIDataInfo(apiUrl, query);
			
			strResultCode = result.getString("resultCode");
			
			int today = Integer.parseInt(Utils.getTimeStampString("yyyyMMdd"));
			System.out.println("-------- birth : " + birth);
			System.out.println("-------- today : " + today);
			
			if(Integer.parseInt(birth) + 140000 > today) {
				strResult = "false";
				resultMessage = "만 14세 미만의 회원님은 가입하실 수 없습니다.";
			} else if(strResultCode.equals("E1003")){
				strResult = "reJoin";
			}else if(strResultCode.equals("E2001") ){
				strResult = "falseJoin";
				resultMessage = result.getString("resultMessage");
				failUrl = request.getScheme() + "://" + request.getServerName() + "/mobile/member/login.jsp"; 
			}else if(!strResultCode.equals("S0000") ){
				strResult = "false";
				resultMessage = result.getString("resultMessage");
			}else{
				resultMessage = "인증 되었습니다.\\n회원 가입 페이지로 이동합니다.";
			}
			
			//재가입
		}else if(strScreenCd.equals("reJoin") && strResult.equals("1")){
			apiUrl = Config.get("api.join.reJoinUser." + SystemChecker.getCurrentName()); //APIURL
		
			query = "coopcoCd=" + strCoopcoCd + "&chnlCd=" + strchnlCd + "&ci=" + URLEncoder.encode(strCi, "UTF-8");
			result = SanghafarmUtils.getAPIDataInfo(apiUrl, query);
			
			strResultCode = result.getString("resultCode");
			
			if(!strResultCode.equals("S0000") ){
				strResult = "false";
				resultMessage = result.getString("resultMessage");
			}else{
				strResult = "reJoinComplete";
			}
			
			//아이디 찾기
		}else if(strScreenCd.equals("findId") && strResult.equals("1")){
			apiUrl = Config.get("api.info.findMmbId." + SystemChecker.getCurrentName()); //APIURL
		
			query = "coopcoCd=" + strCoopcoCd + "&chnlCd=" + strchnlCd + "&ci=" + URLEncoder.encode(strCi, "UTF-8");
			result = SanghafarmUtils.getAPIDataInfo(apiUrl, query);
			
			strResultCode = result.getString("resultCode");
			
			if(!strResultCode.equals("S0000") ){
				strResult = "false";
				successUrl = successUrl + "/mobile/member/findId3.jsp";
				resultMessage = result.getString("resultMessage");
			}else{
				JSONObject id = new JSONObject();
				id = (JSONObject)JSONSerializer.toJSON(result.getString("data"));
				apiData = id.getString("mmbId");
				successUrl = successUrl + "/mobile/member/findId2.jsp";
				resultMessage = "";
			}
			//비밀번호 찾기
		}else if(strScreenCd.equals("findPwd") && strResult.equals("1")){
			apiUrl = Config.get("api.info.isSameMmb." + SystemChecker.getCurrentName()); //APIURL
		
			query = "coopcoCd=" + strCoopcoCd + "&chnlCd=" + strchnlCd + "&ci=" + URLEncoder.encode(strCi, "UTF-8") + "&id=" + strPwdFindId;
			result = SanghafarmUtils.getAPIDataInfo(apiUrl, query);
			strResultCode = result.getString("resultCode");
		
			if(!strResultCode.equals("S0000") ){
				strResult = "false";
				resultMessage = result.getString("resultMessage");
			}else{
				strResult = "true";
			}
			session.setAttribute("SCI_AUTH", "Y");
			//휴먼해제
		}else if(strScreenCd.equals("memInactive") && strResult.equals("1")){
			apiUrl = Config.get("api.info.rlsSleepUser." + SystemChecker.getCurrentName()); //APIURL
			strUnfyMmbNo= Utils.getCookie(request, "unfyMmbNo");
			query = "coopcoCd=" + strCoopcoCd + "&chnlCd=" + strchnlCd + "&unfyMmbNo=" + strUnfyMmbNo + "&socMmbYn=N" + "&ci=" + URLEncoder.encode(strCi, "UTF-8");
			result = SanghafarmUtils.getAPIDataInfo(apiUrl, query);
			strResultCode = result.getString("resultCode");
			
			if(!strResultCode.equals("S0000") ){
				strResult = "false";
				resultMessage = result.getString("resultMessage");
			}else{
				strResult = "true";
			}		
		} else if("adultAuth".equals(strScreenCd) && "1".equals(strResult)) {	// 성인인증
			if(Integer.parseInt(age) < 7) {
				resultMessage = "만 19세 미만이므로 주류 상품을 구매할 수 없습니다.";
			} else {
				FrontSession fs = FrontSession.getInstance(request, response);
				MemberService member = (new MemberService()).toProxyInstance();
				Param info = member.getImInfo(fs.getUserNo());
				
				System.out.println("----------- " + info.get("sef_cert_ci").replaceAll(" ", "+"));
				System.out.println("----------- " + strCi);
				
				if(!strCi.equals(info.get("sef_cert_ci").replaceAll(" ", "+"))) {
					resultMessage = "- 회원정보와 19세 이상 본인인증 정보가 서로 일치하지 않습니다.\\n";
					resultMessage += "- Maeil Do 회원정보와 동일한 정보로 19세 이상 본인인증하세요.\\n";
					resultMessage += "- SNS회원인 경우, 본인 확인이 어려워 해당 상품을 구매하실 수 없습니다.";
				} else {
					member.modifyAdultAuth(fs.getUserId());
					SanghafarmUtils.setCookie(response, "ADULT_AUTH", "Y", fs.getDomain(), -1);
					resultMessage = "인증이 완료되었습니다.";
				}
			}
		}
 		
    }catch(Exception ex){
          System.out.println("[IPIN] Receive Test Error -"+ex.getMessage());
    }finally {

		if(strScreenCd.equals("join") && strResultCode.equals("S0000") && !strResult.equals("false")){   	 
%>
		   <form name="reqCBAV2IpinForm" method="post" action="<%=successUrl%>">
                <input type="hidden" id="name" name="name" value="" />
                <input type="hidden" id="birth" name="birth" value="" />
                <input type="hidden" id="genderVal" name="genderVal" value="" />
                <input type="hidden" id="fgnGbn" name="fgnGbn" value="" />
                <input type="hidden" id="dupInfo" name="dupInfo" value="" />
                <input type="hidden" id="connInfo" name="connInfo" value="" />
                <input type="hidden" id="connInfoVer" name="connInfoVer" value="" />
                <input type="hidden" id="certDv" name="certDv" value="2" />
           </form>
           
		    <script type="text/javascript">
		        alert("<%=resultMessage%>");
		        var f = document.reqCBAV2IpinForm;
			    f.name.value="<%=URLEncoder.encode(name, "UTF-8") %>";
				f.birth.value="<%=birth %>";
				f.genderVal.value="<%=gender %>";
				f.fgnGbn.value="<%=fgn %>";
				f.dupInfo.value="<%=discrHash %>";
				f.connInfo.value="<%=strCi %>";
				f.connInfoVer.value="<%=ciVersion %>";
		        f.submit(); 
			</script>
<%
		}else if(strScreenCd.equals("reJoin") && strResultCode.equals("S0000")){
%>		
		    <script type="text/javascript">
			 location.href = "<%=successUrl%>";
			</script>
<%			
		}else if(strScreenCd.equals("findId") && strResultCode.equals("S0000")){
			
%>
		   <form name="reqFindId" method="post" action="<%=successUrl%>">
                <input type="hidden" id=reqId name="reqId" value="" />
           </form>
           	
           	<script type="text/javascript">
		        var f = document.reqFindId;
			    f.reqId.value="<%=apiData%>";
		        f.submit(); 
			</script>
<%			
		}else if(strScreenCd.equals("findPwd") && strResultCode.equals("S0000")){			
%>
	    	<form name="reqFindPwd" method="post" action="<%=successUrl%>">
                <input type="hidden" id="reqId" name="reqId" value="<%=strPwdFindId%>" />
            </form>
           	
            <script type="text/javascript">
		        var f = document.reqFindPwd;
		        f.submit(); 
			</script>
<%			
		}else if(strScreenCd.equals("memInactive") && strResultCode.equals("S0000")){			
%>
           	
            <script type="text/javascript">
           		 location.href = "<%=successUrl%>";
			</script>
<%
		} else if("adultAuth".equals(strScreenCd)) {	// 성인인증
%>
			<script>
				alert("<%= resultMessage %>");
				parent.location.reload();
			</script>
<%
		}else{
%>			
		    <script type="text/javascript">
			 alert("<%=resultMessage%>");
			 location.href = "<%=failUrl%>";
			</script>
<%
		}
	}
%>



