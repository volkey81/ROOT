package com.sanghafarm.service.member;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

import com.efusioni.stone.annotation.Transactionable;
import com.efusioni.stone.common.SystemChecker;
import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;
import com.efusioni.stone.utils.Utils;
import com.sanghafarm.common.Env;
import com.zeroto7.sha256.Sha256Cipher;

public class ImMemberService extends IbatisService {
	public static String COOPCO_CD = "7040";
	public static String CHNL_TYP_CD = "1";
	public static String BRND_CD = "5010";
	public static String STOR_NO = "KC01620";
	
	// 로그인
	public static String CHNL_CD = "3";
	public static String NTRY_PATH = "26";
	
	@SuppressWarnings("unchecked")
	@Transactionable
	public JSONObject create(String apiNm, JSONObject json) {
		JSONObject obj = new JSONObject();
		Param param = null;

		try {
			obj.put("TRS_NO", (String) json.get("TRS_NO"));
			obj.put("OPN_MD", (String) json.get("OPN_MD"));
			obj.put("SST_CD", (String) json.get("SST_CD"));
			
			JSONObject imSbc = (JSONObject)JSONValue.parse(json.get("IM_SBC").toString());
			
			JSONObject sub = new JSONObject();
			sub.put("UNFY_MMB_NO", (String) imSbc.get("UNFY_MMB_NO"));
			obj.put("IM_SBC", sub);
			
			// insert t_immem
			param = new Param();
			param.set("unfy_mmb_no",                (String) imSbc.get("UNFY_MMB_NO"));
			param.set("cust_no",                    (String) imSbc.get("CUST_NO"));
			param.set("mmb_nm",                     (String) imSbc.get("MMB_NM"));
			param.set("mmb_id",                     (String) imSbc.get("MMB_ID"));
			param.set("frnr_dv_cd",                 (String) imSbc.get("FRNR_DV_CD"));
			param.set("btdy",                       (String) imSbc.get("BTDY"));
			param.set("btdy_lucr_socr_dv_cd",       (String) imSbc.get("BTDY_LUCR_SOCR_DV_CD"));
			param.set("gndr_dv_cd",                 (String) imSbc.get("GNDR_DV_CD"));
			param.set("sef_cert_di",                (String) imSbc.get("SEF_CERT_DI"));
			param.set("sef_cert_ci_ver",            (String) imSbc.get("SEF_CERT_CI_VER"));
			param.set("sef_cert_ci",                (String) imSbc.get("SEF_CERT_CI"));
			param.set("sef_cert_dv_cd",             (String) imSbc.get("SEF_CERT_DV_CD"));
			param.set("ntry_chnl_cd",               (String) imSbc.get("NTRY_CHNL_CD"));
			param.set("ntry_path",               	(String) imSbc.get("NTRY_PATH"));
			param.set("ntry_coopco_cd",             (String) imSbc.get("NTRY_COOPCO_CD"));
			param.set("mmb_st_cd",                  (String) imSbc.get("MMB_ST_CD"));
			param.set("soc_id",                     (String) imSbc.get("SOC_ID"));
			param.set("soc_kind_cd",                (String) imSbc.get("SOC_KIND_CD"));
			param.set("soc_mmb_yn",                 (String) imSbc.get("SOC_MMB_YN"));
			param.set("prem_mmb_yn",                (String) imSbc.get("PREM_MMB_YN"));
			param.set("prem_mmb_ntry_dtm",          (String) imSbc.get("PREM_MMB_NTRY_DTM"));
			param.set("stff_dv_cd",                 (String) imSbc.get("STFF_DV_CD"));
			param.set("stff_eml_addr",              (String) imSbc.get("STFF_EML_ADDR"));
			param.set("stff_cert_dt",               (String) imSbc.get("STFF_CERT_DT"));
			param.set("ntry_typ_cd",                (String) imSbc.get("NTRY_TYP_CD"));
			param.set("coopco_mmb_id",              (String) imSbc.get("COOPCO_MMB_ID"));
			param.set("wrls_tel_no",                (String) imSbc.get("WRLS_TEL_NO"));
			param.set("cbl_tel_no",                 (String) imSbc.get("CBL_TEL_NO"));
			param.set("eml_addr",                   (String) imSbc.get("EML_ADDR"));
			param.set("crd_no",                     (String) imSbc.get("CRD_NO"));
			param.set("crd_reg_dtm",                (String) imSbc.get("CRD_REG_DTM"));
			param.set("reg_dtm",                    (String) imSbc.get("REG_DTM"));
			param.set("asct_mmb_no",                (String) imSbc.get("ASCT_MMB_NO"));
			param.set("ntry_stor_no",               (String) imSbc.get("NTRY_STOR_NO"));
			param.set("stor_cd",                    (String) imSbc.get("STOR_CD"));
			param.set("stor_crd_no",                (String) imSbc.get("STOR_CRD_NO"));
			param.set("stor_pint_swt_yn",           (String) imSbc.get("STOR_PINT_SWT_YN"));
			param.set("agrm_yn",                    (String) imSbc.get("AGRM_YN"));
			param.set("agrm_dthr",                  (String) imSbc.get("AGRM_DTHR"));
			param.set("agrm_end_dthr",              (String) imSbc.get("AGRM_END_DTHR"));
			param.set("sms_recv_dv_cd",             (String) imSbc.get("SMS_RECV_DV_CD"));
			param.set("eml_recv_dv_cd",             (String) imSbc.get("EML_RECV_DV_CD"));
			param.set("app_push_recv_dv_cd",        (String) imSbc.get("APP_PUSH_RECV_DV_CD"));
			param.set("total_agrm_yn",              (String) imSbc.get("TOTAL_AGRM_YN"));
			param.set("addr_flag",                  (String) imSbc.get("ADDR_FLAG"));
			param.set("zip_no",                     (String) imSbc.get("ZIP_NO"));
			param.set("zip_seq",                    (String) imSbc.get("ZIP_SEQ"));
			param.set("zip_zone_no",                (String) imSbc.get("ZIP_ZONE_NO"));
			param.set("zip_base_addr",              (String) imSbc.get("ZIP_BASE_ADDR"));
			param.set("zip_dtls_addr",              (String) imSbc.get("ZIP_DTLS_ADDR"));
			param.set("rozip_no",                   (String) imSbc.get("ROZIP_NO"));
			param.set("rozip_seq",                  (String) imSbc.get("ROZIP_SEQ"));
			param.set("rozip_zone_no",              (String) imSbc.get("ROZIP_ZONE_NO"));
			param.set("rozip_base_addr",            (String) imSbc.get("ROZIP_BASE_ADDR"));
			param.set("rozip_dtls_addr",            (String) imSbc.get("ROZIP_DTLS_ADDR"));
			param.set("rozip_refn_addr",            (String) imSbc.get("ROZIP_REFN_ADDR"));
			param.set("rozip_bld_no",               (String) imSbc.get("ROZIP_BLD_NO"));
			param.set("rozip_pnu",                  (String) imSbc.get("ROZIP_PNU"));
			param.set("sttr_dong_cd",               (String) imSbc.get("STTR_DONG_CD"));
			param.set("admst_dong_cd",              (String) imSbc.get("ADMST_DONG_CD"));
			param.set("psn_x_cord",                 (String) imSbc.get("PSN_X_CORD"));
			param.set("psn_y_cord",					(String) imSbc.get("PSN_Y_CORD"));
			
			Param info = super._row("ImMember.getInfo", Integer.parseInt((String) imSbc.get("UNFY_MMB_NO")));
			
			if(info == null || "".equals(info.get("unfy_mmb_no"))) {
				super._insert("ImMember.insert", param);
			} else {
				super._update("ImMember.update", param);
			}
			
//			super._update("ImMember.merge", param);
			
			// insert t_mem_sns
			super._delete("ImMember.deleteSNS", Integer.parseInt((String) imSbc.get("UNFY_MMB_NO")));
			JSONArray socInfo = (JSONArray)imSbc.get("SOC_INFO");
			for(int i = 0; i < socInfo.size(); i++){
				JSONObject soc = (JSONObject)JSONValue.parse(socInfo.get(i).toString());
				param = new Param();
				param.set("unfy_mmb_no",		(String) imSbc.get("UNFY_MMB_NO"));
				param.set("soc_unfy_mmb_no",    (String) soc.get("SOC_UNFY_MMB_NO"));
				param.set("soc_kind_cd",        (String) soc.get("SOC_KIND_CD"));
				param.set("use_yn",             (String) soc.get("USE_YN"));
				
				super._insert("ImMember.insertSNS", param);
			}
			
			// insert t_mem_child
			super._delete("ImMember.deleteChild", Integer.parseInt((String) imSbc.get("UNFY_MMB_NO")));
			JSONArray mmbBaby = (JSONArray)imSbc.get("MMB_BABY");
			for(int i = 0; i < mmbBaby.size(); i++){
				JSONObject baby = (JSONObject)JSONValue.parse(mmbBaby.get(i).toString());
				param = new Param();
				param.set("unfy_mmb_no",			(String) imSbc.get("UNFY_MMB_NO"));
				param.set("SEQ_NO",					(String) baby.get("SEQ_NO"));
				param.set("BABY_NM",                (String) baby.get("BABY_NM"));
				param.set("BABY_SEQ",               (String) baby.get("BABY_SEQ"));
				param.set("TWIN_DV_CD",             (String) baby.get("TWIN_DV_CD"));
				param.set("BTDY",                   (String) baby.get("BTDY"));
				param.set("BTDY_LUCR_SOCR_DV_CD",	(String) baby.get("BTDY_LUCR_SOCR_DV_CD"));
				param.set("BABY_GNDR_DV_CD",        (String) baby.get("BABY_GNDR_DV_CD"));
				param.set("FEDG_TYP_CD",            (String) baby.get("FEDG_TYP_CD"));
				param.set("USE_YN",                 (String) baby.get("USE_YN"));
				
				super._insert("ImMember.insertChild", param);
			}
			
			obj.put("RES_CD", "S0017040");
			obj.put("RES_MSG", "성공적으로 수행되었습니다.");
		} catch(Exception e) {
			e.printStackTrace();
			obj.put("RES_CD", "E0097040");
			obj.put("RES_MSG", "알 수 없는 오류가 발생하였습니다. 상세 에러 메시지 : (" + e.toString() + ")");
		}
		
		// insert log
		try {
			param = new Param();
			param.set("api_nm", apiNm);
			param.set("trs_no", (String) json.get("TRS_NO"));
			param.set("opn_md", (String) json.get("OPN_MD"));
			param.set("sst_cd", (String) json.get("SST_CD"));
			param.set("param", json.toJSONString());
			param.set("response", obj.toJSONString());
			
			super._insert("ImMember.insertLog", param);
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return obj;
	}
	
	
	@SuppressWarnings("unchecked")
	@Transactionable
	public JSONObject remove(String apiNm, JSONObject json) {
		JSONObject obj = new JSONObject();
		Param param = null;

		try {
			obj.put("TRS_NO", (String) json.get("TRS_NO"));
			obj.put("OPN_MD", (String) json.get("OPN_MD"));
			obj.put("SST_CD", (String) json.get("SST_CD"));
			
			JSONObject imSbc = (JSONObject)JSONValue.parse(json.get("IM_SBC").toString());
			
			JSONObject sub = new JSONObject();
			sub.put("UNFY_MMB_NO", (String) imSbc.get("UNFY_MMB_NO"));
			obj.put("IM_SBC", sub);
			
			super._update("ImMember.delete", Integer.parseInt((String) imSbc.get("UNFY_MMB_NO")));
			
			obj.put("RES_CD", "S0017040");
			obj.put("RES_MSG", "성공적으로 수행되었습니다.");
		} catch(Exception e) {
			e.printStackTrace();
			obj.put("RES_CD", "E0097040");
			obj.put("RES_MSG", "알 수 없는 오류가 발생하였습니다. 상세 에러 메시지 : (" + e.toString() + ")");
		}
		
		// insert log
		try {
			param = new Param();
			param.set("api_nm", apiNm);
			param.set("trs_no", (String) json.get("TRS_NO"));
			param.set("opn_md", (String) json.get("OPN_MD"));
			param.set("sst_cd", (String) json.get("SST_CD"));
			param.set("param", json.toJSONString());
			param.set("response", obj.toJSONString());
			
			super._insert("ImMember.insertLog", param);
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return obj;
	}
	
	@SuppressWarnings("unchecked")
	public JSONObject getInfo(String apiNm, JSONObject json) {
		JSONObject obj = new JSONObject();
		Param param = null;

		try {
			obj.put("TRS_NO", (String) json.get("TRS_NO"));
			obj.put("OPN_MD", (String) json.get("OPN_MD"));
			obj.put("SST_CD", (String) json.get("SST_CD"));
			
			JSONObject imSbc = (JSONObject)JSONValue.parse(json.get("IM_SBC").toString());
			int unfyMmbNo = Integer.parseInt((String) imSbc.get("UNFY_MMB_NO"));
			imSbc = new JSONObject();
			Param info = super._row("ImMember.getInfo", unfyMmbNo);
			imSbc.putAll(info);
			
			List<Param> snsList = super._list("ImMember.getSnsList", unfyMmbNo);
			JSONArray socInfo = new JSONArray();
			for(Param row : snsList) {
				JSONObject o = new JSONObject();
				o.putAll(row);
				socInfo.add(o);
			}
			imSbc.put("SOC_INFO", socInfo);
			
			List<Param> childList = super._list("ImMember.getChildList", unfyMmbNo);
			JSONArray mmbBaby = new JSONArray();
			for(Param row : childList) {
				JSONObject o = new JSONObject();
				o.putAll(row);
				mmbBaby.add(o);
			}
			imSbc.put("MMB_BABY", mmbBaby);
			
			obj.put("IM_SBC", imSbc);
			obj.put("RES_CD", "S0017040");
			obj.put("RES_MSG", "성공적으로 수행되었습니다.");
		} catch(Exception e) {
			e.printStackTrace();
			obj.put("RES_CD", "E0097040");
			obj.put("RES_MSG", "알 수 없는 오류가 발생하였습니다. 상세 에러 메시지 : (" + e.toString() + ")");
		}
		
		// insert log
		try {
			param = new Param();
			param.set("api_nm", apiNm);
			param.set("trs_no", (String) json.get("TRS_NO"));
			param.set("opn_md", (String) json.get("OPN_MD"));
			param.set("sst_cd", (String) json.get("SST_CD"));
			param.set("param", json.toJSONString());
			param.set("response", obj.toJSONString());
			
			super._insert("ImMember.insertLog", param);
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return obj;
	}
	
	@SuppressWarnings("unchecked")
	public JSONObject isRemovable(String apiNm, JSONObject json) {
		JSONObject obj = new JSONObject();
		JSONObject sub = new JSONObject();
		Param param = null;

		try {
			obj.put("TRS_NO", (String) json.get("TRS_NO"));
			obj.put("OPN_MD", (String) json.get("OPN_MD"));
			obj.put("SST_CD", (String) json.get("SST_CD"));
			
			JSONObject imSbc = (JSONObject)JSONValue.parse(json.get("IM_SBC").toString());
			
			sub.put("UNFY_MMB_NO", (String) imSbc.get("UNFY_MMB_NO"));
			sub.put("COOPCO_CD", (String) imSbc.get("COOPCO_CD"));
		
			// ----------------- 탈퇴 가능 체크
			boolean isDel = true;
			
			long unfyMmbNo = Long.parseLong((String) imSbc.get("UNFY_MMB_NO"));
			// 파머스마켓 구매 진행중
			String orderid = (String) super._scalar("ImMember.getOrderStatus", unfyMmbNo);
			if(orderid != null && !"".equals(orderid)) isDel = false;
			// 농원 예약 진행중
			String torderid = (String) super._scalar("ImMember.getTorderStatus", unfyMmbNo);
			if(torderid != null && !"".equals(torderid)) isDel = false;
			// 상하가족
			Param info = super._row("FamilyMember.getInfo", unfyMmbNo);
			if(info != null && "Y".equals(info.get("family_yn"))) isDel = false;
			// --------------------------------
			
			obj.put("RES_CD", "S0017040");
			obj.put("RES_MSG", "성공적으로 수행되었습니다.");
			sub.put("ISDEL_YN", isDel ? "Y" : "N");
			sub.put("ISDEL_MSG", isDel ? "탈퇴해도 됩니다." : "탈퇴가 불가능합니다.");
		} catch(Exception e) {
			e.printStackTrace();
			obj.put("RES_CD", "E0097040");
			obj.put("RES_MSG", "알 수 없는 오류가 발생하였습니다. 상세 에러 메시지 : (" + e.toString() + ")");
			sub.put("ISDEL_YN", "N");
			sub.put("ISDEL_MSG", "오류발생");
		}

		obj.put("IM_SBC", sub);
		
		// insert log
		try {
			param = new Param();
			param.set("api_nm", apiNm);
			param.set("trs_no", (String) json.get("TRS_NO"));
			param.set("opn_md", (String) json.get("OPN_MD"));
			param.set("sst_cd", (String) json.get("SST_CD"));
			param.set("param", json.toJSONString());
			param.set("response", obj.toJSONString());
			
			super._insert("ImMember.insertLog", param);
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return obj;
	}
	

	//--------------------------------------------------------------
	// 포인트 연동
	
	@SuppressWarnings("unchecked")
	public int getMemberPoint(int unfyMmbNo) {
		int point = 0;
		String apiNm = "getMemberPoint";
		String timestamp = Utils.getTimeStampString("yyyyMMddHHmmss");
		String trcNo = timestamp + getNewTrcNo();
		JSONObject json = new JSONObject();
		
		json.put("TRSC_TYP_CD", 	"100");
		json.put("TRSC_BIZ_DV_CD", 	"11");
		json.put("COOPCO_CD", 		COOPCO_CD);
		json.put("TRSC_DT", 		timestamp.substring(0, 8));
		json.put("TRSC_HR", 		timestamp.substring(8));
		json.put("TRC_NO", 			trcNo);
		json.put("CHNL_TYP_CD", 	CHNL_TYP_CD);
		json.put("BRND_CD", 		BRND_CD);
		json.put("STOR_NO", 		STOR_NO);
		json.put("SRCH_DV", 		"I");
		json.put("SRCH_DV_VLU", 	unfyMmbNo);

		JSONObject obj = getResponse(Env.getPointMaeildoUrl() + "/maeilmembership/" + apiNm, json);
		
		// insert log
		try {
			Param p = new Param();
			p.set("api_nm", apiNm);
			p.set("trc_no", trcNo);
			p.set("param", json.toJSONString());
			p.set("response", obj.toJSONString());
			
			super._insert("ImMember.insertImPointLog", p);
		} catch(Exception e) {
			e.printStackTrace();
		}


		try {
			JSONArray results = (JSONArray)obj.get("RESULTS");
			for(int i = 0; i < results.size() && i < 1; i++){
				JSONObject result = (JSONObject)JSONValue.parse(results.get(i).toString());
				point = ((Long) result.get("RMND_PINT")).intValue();
				if(point < 0) {
					point = 0;
				}
			}
		} catch(Exception e) {
			e.printStackTrace();
			if(SystemChecker.isLocal()) {
				point = 8621;
			}
		}
		
		return point;
	}
	
	@SuppressWarnings("unchecked")
	public JSONObject useMemberPoint(Param param) {
		String apiNm = "useMemberPoint";
		String timestamp = Utils.getTimeStampString("yyyyMMddHHmmss");
		String trcNo = timestamp + getNewTrcNo();
		JSONObject json = new JSONObject();
		
		json.put("TRSC_TYP_CD", 		"300");
		json.put("TRSC_BIZ_DV_CD",		param.get("trsc_biz_dv_cd"));
		json.put("COOPCO_CD",			COOPCO_CD);
		json.put("TRSC_DT", 			timestamp.substring(0, 8));
		json.put("TRSC_HR", 			timestamp.substring(8)); 
		json.put("TRC_NO", 				trcNo);
		json.put("CHNL_TYP_CD",			CHNL_TYP_CD);
		json.put("BRND_CD",				BRND_CD);
		json.put("STOR_NO",				STOR_NO);
		json.put("TRSC_ORGN_DV_CD",		param.get("trsc_orgn_dv_cd"));
		json.put("MMB_CERT_DV_CD",		param.get("mmb_cert_dv_cd"));
		json.put("MMB_CERT_DV_VLU",		param.get("mmb_cert_dv_vlu"));	
		json.put("TOT_SEL_AMT",			param.get("tot_sel_amt"));
		json.put("TOT_DC_AMT",			param.get("tot_dc_amt"));
		json.put("MBRSH_DC_AMT",		param.get("mbrsh_dc_amt"));
		json.put("TRSC_RSN_CD",			param.get("trsc_rsn_cd", "CF01"));
		json.put("UNIQ_RCGN_NO",		param.get("uniq_rcgn_no"));
		json.put("ORG_APV_DT",			param.get("org_apv_dt"));
		json.put("ORG_APV_NO",			param.get("org_apv_no"));
		json.put("ORG_UNIQ_RCGN_NO",	param.get("org_uniq_rcgn_no"));
		json.put("PINT_USE_TYP_CD",		param.get("pint_use_typ_cd"));
		json.put("USE_PINT",			param.get("use_pint"));
		json.put("RMK",					param.get("rmk"));	

		
		JSONObject obj = getResponse(Env.getPointMaeildoUrl() + "/maeilmembership/" + apiNm, json);
		
		// insert log
		try {
			Param p = new Param();
			p.set("api_nm", apiNm);
			p.set("trc_no", trcNo);
			p.set("param", json.toJSONString());
			p.set("response", obj.toJSONString());
			
			super._insert("ImMember.insertImPointLog", p);
		} catch(Exception e) {
			e.printStackTrace();
		}

		return obj;
	}

	@SuppressWarnings("unchecked")
	public JSONObject saveMemberPoint(Param param) {
		String apiNm = "saveMemberPoint";
		String timestamp = Utils.getTimeStampString("yyyyMMddHHmmss");
		String trcNo = timestamp + getNewTrcNo();
		JSONObject json = new JSONObject();
		
		json.put("TRSC_TYP_CD", 		"200");
		json.put("TRSC_BIZ_DV_CD", 		param.get("trsc_biz_dv_cd"));
		json.put("COOPCO_CD", 			COOPCO_CD);
		json.put("TRSC_DT", 			timestamp.substring(0, 8));
		json.put("TRSC_HR", 			timestamp.substring(8));
		json.put("TRC_NO", 				trcNo);
		json.put("CHNL_TYP_CD", 		CHNL_TYP_CD);
		json.put("BRND_CD", 			BRND_CD);
		json.put("STOR_NO", 			STOR_NO);
		json.put("TRSC_ORGN_DV_CD",		param.get("trsc_orgn_dv_cd"));
		json.put("MMB_CERT_DV_CD",		param.get("mmb_cert_dv_cd"));
		json.put("MMB_CERT_DV_VLU",		param.get("mmb_cert_dv_vlu"));
		json.put("TOT_SEL_AMT",			param.get("tot_sel_amt"));
		json.put("TOT_DC_AMT",			param.get("tot_dc_amt", "0"));
		json.put("MBRSH_DC_AMT",		param.get("mbrsh_dc_amt", "0"));
		json.put("ACML_TGT_AMT",		param.get("acml_tgt_amt"));
		json.put("TRSC_RSN_CD",			param.get("trsc_rsn_cd", "RF01"));
		json.put("MMB_BABY_SEQ_NO",		param.get("mmb_baby_seq_no"));
		json.put("PRDCT_CD",			param.get("prdct_cd"));
		json.put("AFT_ACML_YN",			param.get("aft_acml_yn", "N"));
		json.put("MBRSH_PINT_SETL_YN",	param.get("mbrsh_pint_setl_yn", "N"));
		json.put("PINT_USE_TYP_CD", 	param.get("pint_use_typ_cd"));
		json.put("USE_PINT",			param.get("use_pint", "0"));
		json.put("UNIQ_RCGN_NO",		param.get("uniq_rcgn_no"));
		json.put("ORG_APV_DT",			param.get("org_apv_dt"));
		json.put("ORG_APV_NO",			param.get("org_apv_no"));
		json.put("ORG_UNIQ_RCGN_NO", 	param.get("org_uniq_rcgn_no"));
		json.put("PINT_ACML_TYP_CD",	param.get("pint_acml_typ_cd", "10"));
		json.put("ACML_PINT",			param.get("acml_pint", "0"));
		json.put("VALD_TRM_DV_CD", 		param.get("vald_trm_dv_cd", "1"));
		json.put("VALD_TRM",			param.get("vald_trm", "24"));
		json.put("RMK",					param.get("rmk"));	
		
		JSONObject obj = getResponse(Env.getPointMaeildoUrl() + "/maeilmembership/" + apiNm, json);
		
		// insert log
		try {
			Param p = new Param();
			p.set("api_nm", apiNm);
			p.set("trc_no", trcNo);
			p.set("param", json.toJSONString());
			p.set("response", obj.toJSONString());
			
			super._insert("ImMember.insertImPointLog", p);
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return obj;
	}

	public String getNewTrcNo() {
		return (String) super._scalar("ImMember.getNewNo");
	}
	
	private JSONObject getResponse(String uri, JSONObject json) {
		System.out.println(json.toJSONString());
		BufferedReader urlreader = null;
		StringBuffer sb = new StringBuffer();
    	
    	try {
    		URL url = new URL(uri);
    		String param = json.toJSONString();

    		System.out.println(url.toString());
			HttpURLConnection urlc = (HttpURLConnection) url.openConnection();
			urlc.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
			urlc.setRequestMethod("POST");
			urlc.setDoOutput(true);
			urlc.setUseCaches(false);
			
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

    			System.out.println(sb.toString().trim());
            }
    	} catch (Exception e) { 
    		e.printStackTrace();
    	} finally {
    		try { urlreader.close(); } catch (Exception e) {}
    	}
		
		return (JSONObject)JSONValue.parse(sb.toString().trim());
	}

	private JSONObject getResponse(String uri, Param param) {
		BufferedReader urlreader = null;
		StringBuffer sb = new StringBuffer();
    	
    	try {
    		URL url = new URL(uri);

    		System.out.println(url.toString());
			HttpURLConnection urlc = (HttpURLConnection) url.openConnection();
			urlc.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
			urlc.setRequestMethod("POST");
			urlc.setDoOutput(true);
			urlc.setUseCaches(false);
			
			OutputStream writer = urlc.getOutputStream();
            writer.write(param.toQueryString().getBytes("UTF-8"));
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

    			System.out.println(sb.toString().trim());
            }
            
            Param p = new Param();
            p.set("uri", uri);
            p.set("response_code", responseCode);
            p.set("request", param.toQueryString());
            p.set("response", sb.toString().trim());
            super._insert("ImMember.insertMaeildoApiLog", p);
    	} catch (Exception e) { 
    		e.printStackTrace();
    	} finally {
    		try { urlreader.close(); } catch (Exception e) {}
    	}
		
		return (JSONObject)JSONValue.parse(sb.toString().trim());
	}

	public JSONObject login(Param param) {
		Param p = new Param();
		p.set("coopcoCd", 			COOPCO_CD);
		p.set("chnlCd",				CHNL_CD);
		p.set("id", 				param.get("id"));
		p.set("pwd", 				enc(param.get("pwd")));
		p.set("clientIp",			param.get("clientIp"));
		p.set("ntryPath", 			NTRY_PATH);
		
		return getResponse(Env.getApiMaeildoUrl() + "/ptns/login/login.do", p);
	}

	private String enc(String s) {
		String key = "0to7";
		return Sha256Cipher.encrypt(s, key);
	}
	
	public JSONObject getToken(int unfyMmbNo) {
		Param p = new Param();
		p.set("coopcoCd", 			COOPCO_CD);
		p.set("chnlCd",				CHNL_CD);
		p.set("unfyMmbNo", 			unfyMmbNo);
		
		return getResponse(Env.getApiMaeildoUrl() + "/ptns/token/getToken.do", p);
		
	}

	@SuppressWarnings("unchecked")
	public List<Param> getMemberGiftcard(int unfyMmbNo) {
		String apiNm = "getPrCard";
		ArrayList<Param> list = new ArrayList<Param>();
		String timestamp = Utils.getTimeStampString("yyyyMMddHHmmss");
		String trcNo = timestamp + getNewTrcNo();
		JSONObject json = new JSONObject();
		
		json.put("TRSC_TYP_CD", 	"G10");
		json.put("TRSC_BIZ_DV_CD", 	"G1");
		json.put("COOPCO_CD", 		COOPCO_CD);
		json.put("TRSC_DT", 		timestamp.substring(0, 8));
		json.put("TRSC_HR", 		timestamp.substring(8));
		json.put("TRC_NO", 			trcNo);
		json.put("CHNL_TYP_CD", 	CHNL_TYP_CD);
		json.put("UNFY_MMB_NO", 	unfyMmbNo + "");
		json.put("BRND_CD", 		BRND_CD);
		json.put("STOR_NO", 		STOR_NO);

		JSONObject obj = getResponse(Env.getPointMaeildoUrl() + "/maeilmembership/" + apiNm, json);
		
		// insert log
		try {
			Param p = new Param();
			p.set("api_nm", apiNm);
			p.set("trc_no", trcNo);
			p.set("param", json.toJSONString());
			p.set("response", obj.toJSONString());
			
			super._insert("ImMember.insertImPointLog", p);
		} catch(Exception e) {
			e.printStackTrace();
		}

		try {
			JSONArray member = (JSONArray)obj.get("MEMBER");
			for(int i = 0; i < member.size() && i < 1; i++){
				JSONObject o = (JSONObject)JSONValue.parse(member.get(i).toString());
				JSONArray cards = (JSONArray) o.get("CARD");
				for(int j = 0; j < cards.size(); j++) {
					JSONObject card = (JSONObject) JSONValue.parse(cards.get(j).toString());
					if("N".equals(card.get("DSP_YN").toString())) {
						Param p = new Param();
						p.set("crd_id", card.get("CRD_ID"));
						p.set("actv_amt", card.get("ACTV_AMT"));
						p.set("use_amt", card.get("USE_AMT"));
						p.set("crd_st", card.get("CRD_ST"));
						p.set("crd_img", card.get("CRD_IMG"));
						p.set("reg_dt", card.get("REG_DT"));
						p.set("lst_use_dt", card.get("LST_USE_DT"));
						p.set("rps_crd_yn", card.get("RPS_CRD_YN"));
						p.set("expire_dt", card.get("EXPIRE_DT"));
						p.set("auto_actv_yn", card.get("AUTO_ACTV_YN"));
						
						list.add(p);
					}
				}
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}

	@SuppressWarnings("unchecked")
	public JSONObject useMemberGiftcard(Param param) {
		String apiNm = "usePrCard";
		String timestamp = Utils.getTimeStampString("yyyyMMddHHmmss");
		String trcNo = timestamp + getNewTrcNo();
		JSONObject json = new JSONObject();
		
		json.put("TRSC_TYP_CD", 		"G40");
		json.put("TRSC_BIZ_DV_CD", 		param.get("trsc_biz_dv_cd"));
		json.put("COOPCO_CD", 			COOPCO_CD);
		json.put("TRSC_DT", 			timestamp.substring(0, 8));
		json.put("TRSC_HR", 			timestamp.substring(8));
		json.put("TRC_NO", 				trcNo);
		json.put("CHNL_TYP_CD", 		CHNL_TYP_CD);
		json.put("CRD_ID", 				param.get("crd_id"));
		json.put("USE_DT", 				timestamp.substring(0, 8));
		json.put("SALE_DV", 			param.get("sale_dv"));
		json.put("USE_AMT", 			param.get("use_amt"));
		json.put("TOT_SEL_AMT",			param.get("tot_sel_amt"));
		json.put("ITEM_NM",				param.get("item_nm"));
		json.put("BRND_CD", 			BRND_CD);
		json.put("STOR_NO", 			STOR_NO);
		json.put("BIL_NO", 				param.get("bil_no"));
		json.put("USE_HR", 				timestamp.substring(8));
		json.put("ORG_APV_DT", 			param.get("org_apv_dt"));
		json.put("ORG_APV_NO", 			param.get("org_apv_no"));
		json.put("ORG_UNIQ_RCGN_NO",	param.get("org_uniq_rcgn_no"));
		json.put("UNIQ_RCGN_NO",		param.get("uniq_rcgn_no"));
		json.put("TRSC_ORGN_DV_CD",		param.get("trsc_orgn_dv_cd", "10"));
		
		JSONObject obj = getResponse(Env.getPointMaeildoUrl() + "/maeilmembership/" + apiNm, json);
		
		// insert log
		try {
			Param p = new Param();
			p.set("api_nm", apiNm);
			p.set("trc_no", trcNo);
			p.set("param", json.toJSONString());
			p.set("response", obj.toJSONString());
			
			super._insert("ImMember.insertImPointLog", p);
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return obj;
	}
	
	public String getOrderStatus (Long unfyMmbNo){
		return (String )super._scalar("ImMember.getOrderStatus", unfyMmbNo);
	}
	
	public String getTorderStatus (Long unfyMmbNo){
		return (String) super._scalar("ImMember.getTorderStatus", unfyMmbNo);
	}
	
	public Param getSanghaInfo (Long unfyMmbNo){
		return (Param) super._row("FamilyMember.getInfo", unfyMmbNo);
	}

	public Param getInfoById(String userid) {
		return (Param) super._row("ImMember.getInfoById", userid);
	}
}
