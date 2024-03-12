package com.sanghafarm.service.member;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.util.List;

import org.apache.commons.codec.binary.Base64;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

import com.efusioni.stone.common.SystemChecker;
import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;
import com.efusioni.stone.utils.Utils;
import com.sanghafarm.service.order.OrderService;

import modules.secure.kisa.SEED;

public class MemberService extends IbatisService {
	
	public Param getInfo(String userid) {
		return getInfo(new Param("userid", userid)); 
	}
	
	public Param getImInfo(int unfyMmbNo) {
		return super._row("Member.getImInfo", unfyMmbNo); 
	}

	public Param getImInfoById(String userid) {
		return super._row("Member.getImInfoById", userid); 
	}
		
	public Param getInfo(Param param) {
		return super._row("Member.getInfo", param); 
	}

	public String getMemGrade(String userid) {
		Param info = getInfo(userid);
		if(info == null || "".equals(info.get("userid"))) {
			try {
				System.out.println("-------------- insert gradecode");
				super._insert("Member.insertGradeCode", new Param("userid", userid, "grade_code", "001"));
			} catch(Exception e) {
				e.printStackTrace();
			}
			return "001";
		} if("".equals(info.get("grade_code"))) {
			try {
				System.out.println("-------------- update gradecode");
				super._update("Member.updateGradeCode", new Param("userid", userid, "grade_code", "001"));
			} catch(Exception e) {
				e.printStackTrace();
			}
			return "001";
		} else {
			return info.get("grade_code");
		}
	}
	
	public void modifyOrderid(String userid, String orderid) {
		super._update("Member.mergeOrderid", new Param("userid", userid, "orderid", orderid));
	}
	
	public void modifyOrderid(Param param) {
		super._update("Member.mergeOrderid", param);
	}
	
	public void modifyAdultAuth(String userid) {
		super._update("Member.mergeAdultAuth", userid);
	}
	
	public void modifyRecommender(Param param) {
		Param info = this.getInfo(param.get("userid"));
		super._update("Member.mergeRecommender", param);

		// 기존 추천인이 없는 경우에만 신규가입 포인트 지급
		if("".equals(info.get("recommender"))) {
			recommenderEvent1(param);
		}
	}
	
	// 2022.05.03 10:00 까지 추천인 등록 신규가입시 6,000 포인트 지급
	// 2023.05.17 10:00 ~ 2023.06.07 18:00 까지 추천인 등록 신규가입시 5,000 포인트 지급
	public void recommenderEvent1(Param param) {
		System.out.println("------- recommenderEvent1 start ----------");
		try {
			String sdate = "20230517100000";
			String edate = "20230607180000";
			String today = Utils.getTimeStampString("yyyyMMddHHmmss");
			int point = 5000;
			
			if(today.compareTo(sdate) >= 0 && today.compareTo(edate) <= 0) {
				/*
				컬럼명	컬럼ID	코드	내용
				제휴사	COOPCO_CD	7040	상하농원
				브랜드	BRND_CD	5000	가상브랜드
				매장	STOR_NO	5000	가상매장
				유형코드	PINT_ACML_TYP_CD	20	이벤트
				거래사유	TRSC_RSN_CD	RF11	이벤트적립(상하농원)
				*/
				
				OrderService order = new OrderService();
				String orderid = order.getNewId();
				
				Param p = new Param();
				p.set("trsc_biz_dv_cd", "21");
				p.set("trsc_orgn_dv_cd", "10");
				p.set("mmb_cert_dv_cd", "2");
				p.set("mmb_cert_dv_vlu", param.get("unfy_mmb_no"));	
				p.set("tot_sel_amt", "0");
				p.set("tot_dc_amt", "0");
				p.set("mbrsh_dc_amt", 0);
				p.set("acml_tgt_amt", "0");
				p.set("trsc_rsn_cd", "RF11");
				p.set("uniq_rcgn_no", orderid);
				p.set("acml_pint", point);
				p.set("pint_acml_typ_cd", "20");
				p.set("rmk", "");
				
				ImMemberService immem = (new ImMemberService()).toProxyInstance();
				JSONObject json = immem.saveMemberPoint(p);
				
				// 포인트 로그
				p = new Param();
				p.set("orderid", 		orderid);
				p.set("ship_seq", 		"0");
				p.set("trsc_typ_cd", 	json.get("TRSC_TYP_CD"));
				p.set("trsc_biz_dv_cd", json.get("TRSC_BIZ_DV_CD"));
				p.set("coopco_cd", 		json.get("COOPCO_CD"));
				p.set("trsc_dt",		json.get("TRSC_DT"));
				p.set("trsc_hr",		json.get("TRSC_HR"));
				p.set("trc_no",			json.get("TRC_NO"));
				p.set("chnl_typ_cd",	json.get("CHNL_TYP_CD"));
				p.set("apv_dt",			json.get("APV_DT"));
				p.set("apv_no",			json.get("APV_NO"));
				p.set("acml_pint", 		json.get("ACML_PINT"));
				p.set("use_pint", 		json.get("USE_PINT"));
				p.set("rmnd_pint", 		json.get("RMND_PINT"));
				p.set("res_cd", 		json.get("RES_CD"));
				p.set("res_msg", 		json.get("RES_MSG"));
				super._insert("Order.insertPointLog", p);

				System.out.println("recommender event1 point result : (" + json.get("RES_CD") + ") " + json.get("RES_MSG") + " orderid : " + orderid);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	// 2022.05.03 10:00 까지 피추천인 구매확정시 6,000 포인트 지급
	// 2023.05.17 10:00 ~ 2023.06.07 18:00 까지 피추천인 구매확정시 5,000 포인트 지급
	public void recommenderEvent2(Param param) {
		try {
			String sdate = "20230517100000";
			String edate = "20230607180000";
			int point = 5000;
			
			List<Param> list = super._list("Member.checkRecommenderEvent1", param);
			
			if(list.size() == 1) {	// 이전 주문이 없는 경우
				Param info = list.get(0);
				if(info.get("order_date").compareTo(sdate) >= 0 
						&& info.get("order_date").compareTo(edate) <= 0 
						&& !"".equals(info.get("unfy_mmb_no"))) {
					int count170 = (int) super._scalar("Member.checkRecommenderEvent2", info.get("orderid")); 
					if(count170 == 1) {	// 구매확정 건수가 1개일 경우
						/*
						컬럼명	컬럼ID	코드	내용
						제휴사	COOPCO_CD	7040	상하농원
						브랜드	BRND_CD	5000	가상브랜드
						매장	STOR_NO	5000	가상매장
						유형코드	PINT_ACML_TYP_CD	20	이벤트
						거래사유	TRSC_RSN_CD	RF11	이벤트적립(상하농원)
						*/
						
						
						OrderService order = new OrderService();
						String orderid = order.getNewId();
						
						Param p = new Param();
						p.set("trsc_biz_dv_cd", "21");
						p.set("trsc_orgn_dv_cd", "10");
						p.set("mmb_cert_dv_cd", "2");
						p.set("mmb_cert_dv_vlu", info.get("unfy_mmb_no"));	
						p.set("tot_sel_amt", "0");
						p.set("tot_dc_amt", "0");
						p.set("mbrsh_dc_amt", 0);
						p.set("acml_tgt_amt", "0");
						p.set("trsc_rsn_cd", "RF11");
						p.set("uniq_rcgn_no", orderid);
						p.set("acml_pint", point);
						p.set("pint_acml_typ_cd", "20");
						p.set("rmk", "");
						
						ImMemberService immem = (new ImMemberService()).toProxyInstance();
						JSONObject json = immem.saveMemberPoint(p);
						
						// 포인트 로그
						p = new Param();
						p.set("orderid", 		orderid);
						p.set("ship_seq", 		"0");
						p.set("trsc_typ_cd", 	json.get("TRSC_TYP_CD"));
						p.set("trsc_biz_dv_cd", json.get("TRSC_BIZ_DV_CD"));
						p.set("coopco_cd", 		json.get("COOPCO_CD"));
						p.set("trsc_dt",		json.get("TRSC_DT"));
						p.set("trsc_hr",		json.get("TRSC_HR"));
						p.set("trc_no",			json.get("TRC_NO"));
						p.set("chnl_typ_cd",	json.get("CHNL_TYP_CD"));
						p.set("apv_dt",			json.get("APV_DT"));
						p.set("apv_no",			json.get("APV_NO"));
						p.set("acml_pint", 		json.get("ACML_PINT"));
						p.set("use_pint", 		json.get("USE_PINT"));
						p.set("rmnd_pint", 		json.get("RMND_PINT"));
						p.set("res_cd", 		json.get("RES_CD"));
						p.set("res_msg", 		json.get("RES_MSG"));
						super._insert("Order.insertPointLog", p);
		
						System.out.println("recommender event2 point result : (" + json.get("RES_CD") + ") " + json.get("RES_MSG") + " orderid : " + orderid);
					}
				}
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public Param getLoginInfo(Param param) throws Exception {
		Param info = new Param();
		
		String requestURL = "http://www.maeili.com/family_member.do";
		String joinCd = "CFS26";

		String data = "command=f_login";
		data += "&join_cd=" + joinCd;
		data += "&userid=" + param.get("userid");
		data += "&passwd=" + param.get("passwd");

		String resultStr = "";
		String str = "";

		String returnMSG = "";
		String EncValue = "";

		String charSet = "EUC-KR";
		
		try {
			URL url = new URL(requestURL);
			URLConnection conn = url.openConnection();
			// If you invoke the method setDoOutput(true) on the URLConnection, it will always use the POST method.
			conn.setDoOutput(true);
			OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
			wr.write(data);
			wr.flush();

			// Get the response
			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), charSet));
			while ((str = br.readLine()) != null) {
				resultStr += str;
			}
			resultStr = resultStr.trim(); //공백제거

			wr.close();
			br.close();
		} catch(Exception e) {
			
		}

		//원데이터
		System.out.println("=====================>>>>>>> 로그인Message resultStr = "+resultStr);

		String seed_key = "ANbfjmelem.311:njsdspemtxne"; //암호화 키
		byte[] Enc_value = decoder(resultStr);
		byte Return_Enc[]   = SEED.seedDecrypt(Enc_value,seed_key.getBytes());
		//byte Return_Enc[] = seed.decrypt(Enc_value, seed_key.getBytes());
		EncValue = new String(Return_Enc, charSet);
		//복호화 끝
		System.out.println("=====================>>>>>>> 로그인Message EncValue = "+EncValue);

		//리턴값 배열로 받고 각 값에 셋팅!!
		String arrTmp[] = EncValue.split("::");

		//통합 로그인에 필요한 값 & 리턴받을 값들
		returnMSG = arrTmp[0].trim();
		info.set("return_msg", returnMSG);
		
		if (returnMSG.equals("err03") || returnMSG.equals("login_ok")) {
			info.set("userid", arrTmp[1].trim());
			info.set("usernm", arrTmp[2].trim());
			info.set("useremail", arrTmp[3].trim());
			info.set("userphone", arrTmp[4].trim());
			info.set("usermobile", arrTmp[5].trim());
			info.set("zipcode", arrTmp[6].trim());
			info.set("addr1", arrTmp[7].trim());
			info.set("addr2", arrTmp[8].trim());
			info.set("memberno", arrTmp[9].trim());
		}
		
		return info;
	}

	public String encoder(byte Return_Inc[]) throws Exception {
		/*
		sun.misc.BASE64Encoder encoder = new sun.misc.BASE64Encoder();
		String testvalue = encoder.encodeBuffer(Return_Inc);
		return testvalue;
		*/
		return new String(Base64.encodeBase64(Return_Inc));
	}

	public byte[] decoder(String testvalue) throws Exception {
		/*
		sun.misc.BASE64Decoder decoder = new sun.misc.BASE64Decoder();
		byte[] Enc_value = decoder.decodeBuffer(testvalue);
		return Enc_value;
		*/
		return Base64.decodeBase64(testvalue);
	}
	
	public void modifyPayType(Param param) {
		super._update("Member.updatePayType", param);
	}
	
	public boolean naverEmpAuth(String naverEmpno) {
		if(SystemChecker.isLocal()) return true;
		
		String api = "https://mproxy.navercorp.com/interface/bem/sanghaEmpInfo";
		BufferedReader urlreader = null;
		StringBuffer sb = new StringBuffer();
		boolean b = false;
		
    	try {
    		URL url = new URL(api);

    		System.out.println(url.toString());
			HttpURLConnection urlc = (HttpURLConnection) url.openConnection();
			urlc.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
			urlc.setRequestMethod("POST");
			urlc.setDoOutput(true);
			urlc.setUseCaches(false);
			
			String param = "empNo=" + naverEmpno;
			OutputStream writer = urlc.getOutputStream();
            writer.write(param.getBytes("UTF-8"));
            writer.flush();
            writer.close();
            
            int responseCode = urlc.getResponseCode();   
        	System.out.println("Response Code : " + responseCode);
            if (responseCode == HttpURLConnection.HTTP_OK) {
    			urlreader = new BufferedReader(new InputStreamReader(urlc.getInputStream(), "utf-8"));

    			String line = null;
    			while((line = urlreader.readLine()) != null){
    				sb.append(line);
    			}
    			
    			System.out.println("----------- naver emp : " + naverEmpno + " : " + sb.toString());
            }
            
            JSONObject json = (JSONObject)JSONValue.parse(sb.toString().trim());
            String result = (String) json.get("result");
            
            b = "true".equals(result);
        } catch (Exception e) { 
    		e.printStackTrace();
    	} finally {
    		try { urlreader.close(); } catch (Exception e) {}
    	}
		
    	return b;
	}
	
	public Integer getNaverEmpnoCount(String naverEmpno) {
		return (Integer) super._scalar("Member.naverEmpnoCount", naverEmpno);
	}
	
	public void mergeNaverEmpno(Param param) {
		super._update("Member.mergeNaverEmpno", param);
	}
}
