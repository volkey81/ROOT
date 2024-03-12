package com.sanghafarm.servlet.im;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

import com.efusioni.stone.common.SystemChecker;
import com.sanghafarm.service.member.ImMemberService;

public class RXCreateUser extends HttpServlet {

	private static final long serialVersionUID = 5338233090998681129L;
	
	private Logger logger = Logger.getLogger(this.getClass());
	
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
	}
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setCharacterEncoding("utf-8");
		PrintWriter out = response.getWriter();
		
		logger.info("============= RXCreateUser");
		
//		Param param = new Param(request);
//		String jsonStr = SystemChecker.getCurrent() == SystemChecker.LOCAL ? getSampleJson() : URLDecoder.decode(param.get("params").trim(), "utf-8");
		String jsonStr = SystemChecker.getCurrent() == SystemChecker.LOCAL ? getSampleJson() : request.getParameter("params").trim();
		JSONObject json = (JSONObject)JSONValue.parse(jsonStr);
		
		ImMemberService svc = (new ImMemberService()).toProxyInstance();
		
		JSONObject result = svc.create(this.getClass().getSimpleName(), json);
		
		out.println(result.toJSONString());
	}

	private String getSampleJson() {
		String s = "{ "
			+ "	\"TRS_NO\": \"70002016102417094861280\",                                                                             "
			+ " \"SST_CD\": \"7040\",                                                                                                "
			+ " \"OPN_MD\": \"test\",                                                                                               "
			+ " \"IM_SBC\": {                                                                                                        "
			+ " 	\"UNFY_MMB_NO\": \"1000000001\",                                                                                 "
			+ " 	\"CUST_NO\": \"1512220200001\",                                                                                  "
			+ " 	\"MMB_NM\": \"매일\",                                                                                             "
			+ " 	\"MMB_ID\": \"testid\",                                                                                          "
			+ " 	\"FRNR_DV_CD\": \"1\",                                                                                           "
			+ " 	\"BTDY\": \"19861212\",                                                                                          "
			+ " 	\"BTDY_LUCR_SOCR_DV_CD\": \"1\",                                                                                 "
			+ " 	\"GNDR_DV_CD\": \"1\",                                                                                           "
			+ " 	\"SEF_CERT_DI\": \"test/test\",                                                                                  "
			+ " 	\"SEF_CERT_CI_VER\": \"1\",                                                                                      "
			+ " 	\"SEF_CERT_CI\": \"YenzYlPAXM0rg8iwI6D73ltIibBRpEkGDEsQ6sG9lmBZTXeLKTuMGvYFxSr0OaMEfFukPh5IuMi6U/hUnZ5ntg==\",   "
			+ " 	\"SEF_CERT_DV_CD\": \"1\",                                                                                       "
			+ " 	\"NTRY_CHNL_CD\": \"3\",                                                                                         "
			+ " 	\"NTRY_PATH\": \"41\",                                                                                           "
			+ " 	\"NTRY_COOPCO_CD\": \"7000\",                                                                                        "
			+ " 	\"MMB_ST_CD\": \"1\",                                                                                            "
			+ " 	\"SOC_ID\": null,                                                                                                "
			+ " 	\"SOC_KIND_CD\": null,                                                                                           "
			+ " 	\"SOC_MMB_YN\": \"N\",                                                                                           "
			+ " 	\"PREM_MMB_YN\": \"Y\",                                                                                          "
			+ " 	\"PREM_MMB_NTRY_DTM\": \"20151111052222\",                                                                       "
			+ " 	\"STFF_DV_CD\": \"0\",                                                                                           "
			+ " 	\"STFF_EML_ADDR\": null,                                                                                         "
			+ " 	\"STFF_CERT_DT\": null,                                                                                          "
			+ " 	\"WRLS_TEL_NO\": \"010-1234-5678\",                                                                              "
			+ " 	\"CBL_TEL_NO\": \"031-5678-1234\",                                                                               "
			+ " 	\"EML_ADDR\": \"testmail@test.com\",                                                                             "
			+ " 	\"CRD_NO\": \"11111111111111111111\",                                                                            "
			+ " 	\"CRD_REG_DTM\": \"20161010104947\",                                                                             "
			+ " 	\"REG_DTM\": \"20160825112758\",                                                                                 "
			+ " 	\"ASCT_MMB_NO\": null,                                                                                           "
			+ " 	\"STOR_CD\": null,                                                                                               "
			+ " 	\"STOR_CRD_NO\": null,                                                                                           "
			+ " 	\"STOR_PINT_SWT_YN\": null,                                                                                      "
			+ " 	\"AGRM_YN\": \"Y\",                                                                                              "
			+ " 	\"AGRM_DTHR\": \"20160906120102\",                                                                               "
			+ " 	\"AGRM_END_DTHR\": null,                                                                                         "
			+ " 	\"EML_RECV_DV_CD\": \"1\",                                                                                       "
			+ " 	\"SMS_RECV_DV_CD\": \"2\",                                                                                       "
			+ " 	\"APP_PUSH_RECV_DV_CD\": \"1\",                                                                                  "
			+ " 	\"ZIP_NO\": \"1\",                                                                                               "
			+ " 	\"ZIP_SEQ\": \"2\",                                                                                              "
			+ " 	\"ZIP_ZONE_NO\": \"3\",                                                                                          "
			+ " 	\"ZIP_BASE_ADDR\": \"4\",                                                                                        "
			+ " 	\"ZIP_DTLS_ADDR\": \"5\",                                                                                        "
			+ " 	\"ROZIP_NO\": \"6\",                                                                                             "
			+ " 	\"ROZIP_SEQ\": \"7\",                                                                                            "
			+ " 	\"ROZIP_ZONE_NO\": \"8\",                                                                                        "
			+ " 	\"ROZIP_BASE_ADDR\": \"9\",                                                                                      "
			+ " 	\"ROZIP_DTLS_ADDR\": \"10\",                                                                                     "
			+ " 	\"ROZIP_REFN_ADDR\": \"11\",                                                                                     "
			+ " 	\"ROZIP_BLD_NO\": \"12\",                                                                                        "
			+ " 	\"ROZIP_PNU\": \"13\",                                                                                           "
			+ " 	\"STTR_DONG_CD\": \"14\",                                                                                        "
			+ " 	\"ADMST_DONG_CD\": \"15\",                                                                                       "
			+ " 	\"PSN_X_CORD\": \"16\",                                                                                          "
			+ " 	\"PSN_Y_CORD\": \"17\",                                                                                          "
			+ " 	\"MMB_BABY\": [{                                                                                                 "
			+ " 		\"SEQ_NO\": \"1\",                                                                                           "
			+ " 		\"BABY_NM\": \"일명\",                                                                                       "
			+ " 		\"BABY_SEQ\": \"1\",                                                                                         "
			+ " 		\"TWIN_DV_CD\": \"1\",                                                                                       "
			+ " 		\"BTDY\": \"19750505\",                                                                                      "
			+ " 		\"BTDY_LUCR_SOCR_DV_CD\": \"1\",                                                                             "
			+ " 		\"BABY_GNDR_DV_CD\": \"1\",                                                                                  "
			+ " 		\"FEDG_TYP_CD\": \"001\",                                                                                    "
			+ " 		\"USE_YN\": \"Y\"                                                                                            "
			+ " 	}, {                                                                                                             "
			+ " 		\"SEQ_NO\": \"2\",                                                                                           "
			+ " 		\"BABY_NM\": \"이명\",                                                                                       "
			+ " 		\"BABY_SEQ\": \"2\",                                                                                         "
			+ " 		\"TWIN_DV_CD\": \"2\",                                                                                       "
			+ " 		\"BTDY\": \"19800201\",                                                                                      "
			+ " 		\"BTDY_LUCR_SOCR_DV_CD\": \"1\",                                                                             "
			+ " 		\"BABY_GNDR_DV_CD\": \"1\",                                                                                  "
			+ " 		\"FEDG_TYP_CD\": \"002\",                                                                                    "
			+ " 		\"USE_YN\": \"Y\"                                                                                            "
			+ " 	}],                                                                                                              "
			+ " 	\"SOC_INFO\": [{                                                                                                 "
			+ " 		\"SOC_UNFY_MMB_NO\": \"1000000002\",                                                                         "
			+ " 		\"SOC_KIND_CD\": \"F\",                                                                                      "
			+ " 		\"USE_YN\": \"Y\"                                                                                            "
			+ " 	}, {                                                                                                             "
			+ " 		\"SOC_UNFY_MMB_NO\": \"1000000003\",                                                                         "
			+ " 		\"SOC_KIND_CD\": \"K\",                                                                                      "
			+ " 		\"USE_YN\": \"Y\"                                                                                            "
			+ " 	}]                                                                                                               "
			+ "  }																													 "
			+ " }";                                                                                                                  

		return s;
	}
}
