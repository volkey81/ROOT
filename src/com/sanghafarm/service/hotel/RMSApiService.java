package com.sanghafarm.service.hotel;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.ArrayUtils;
import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

import com.efusioni.stone.security.SecurityUtils;
import com.efusioni.stone.utils.Param;
import com.sanghafarm.utils.SanghafarmUtils;

public class RMSApiService {
	public Logger logger = Logger.getLogger(this.getClass());

	private static String HOST = "http://10.0.0.4";
	
	public static String BUSES_CD = "00";
	public static String RESV_PATH_GBCD = "02";
	public static String BUSI_PLAC_CD = "1001";
	public static String MENU_CD = "10010";

	public static Map<String, Param> STATIC_INFO = null;
	public static int ADD_ADULT = 40000;
	public static int ADD_CHILD = 20000;
	
	public static String[] ROOM_TYPE = { 
				"A", "B", "C", "D", "E", "P", "Q",
				"A914", "B914", "C914", "P915", "Q915"
			};
	
	public RMSApiService() {
		if(STATIC_INFO == null) {
			STATIC_INFO = new HashMap<String,Param>();
			STATIC_INFO.put("A", new Param("room_size", "10평", "bed_type", "2 x 싱글베드", "thumb", "roomThum01.jpg"));
			STATIC_INFO.put("B", new Param("room_size", "15평", "bed_type", "1 x 더블베드, 2 x 한실이불세트", "thumb", "roomThum03.jpg"));
			STATIC_INFO.put("C", new Param("room_size", "10평", "bed_type", "2 x 한실이불세트", "thumb", "roomThum02.jpg"));
			STATIC_INFO.put("D", new Param("room_size", "20평", "bed_type", "2 x 더블베드", "thumb", "roomThum04.jpg"));
			STATIC_INFO.put("E", new Param("room_size", "20평", "bed_type", "4 x 싱글베드, 4 X 싱글메트리스", "thumb", "roomThum07.jpg"));
			STATIC_INFO.put("P", new Param("room_size", "12평", "bed_type", "2 x 더블베드", "thumb", "roomThum05.jpg"));
			STATIC_INFO.put("Q", new Param("room_size", "12평", "bed_type", "2 x 더블베드", "thumb", "roomThum06.jpg"));
		}
	}

	public static int getAddAmt(String chkiDate, String roomType, String age) {
		/*
		if("P,Q".indexOf(roomType.substring(0, 1)) != -1) {
			return 15000;
		} else {
			if(chkiDate.compareTo("2021.07.01") >= 0) {
				if("ADULT".equals(age)) return 45000;
				else return 25000;
			} else {
				if("ADULT".equals(age)) return 40000;
				else return 20000;
			}
		}
		*/
		if("P,Q".indexOf(roomType.substring(0, 1)) != -1) {
			if(chkiDate.compareTo("2022.05.01") >= 0) {
				if("ADULT".equals(age)) return 38000;
				else return 27000;
			} else {
				return 15000;
			}
		} else {
			if(chkiDate.compareTo("2022.05.01") >= 0) {
				if("ADULT".equals(age)) return 50000;
				else return 35000;
			} else {
				if("ADULT".equals(age)) return 45000;
				else return 25000;
			}
		}
	}
	
	@SuppressWarnings("unchecked")
	public JSONObject forecast(Param param) {
		String s = "";
		JSONObject res = null;
		
		try {
			URL url = new URL(HOST + "/api/internet/xpRetrieveForecast.do");
//			URL url = new URL(HOST + "/api/internet/xpRetrieveForecast.do?pkg=Y");
	
			JSONObject json = new JSONObject();
			json.put("BUSES_CD", BUSES_CD);
			json.put("CHKI_DATE", param.get("chki_date").replaceAll("\\.", ""));
			json.put("CHOT_DATE", param.get("chot_date").replaceAll("\\.", ""));
	
			s = getResult(url, json.toString());
			res = (JSONObject) JSONValue.parse(s);
		} catch(Exception e) {
			System.out.println(param);
			e.printStackTrace();
		}
		
		return res;		
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List<Param> getRoomList(Param param, JSONObject json) {
		List<Param> list = new ArrayList<Param>();
		
		try {
			String result = (String) json.get("RESULT");
			if("Y".equals(result)) {
				JSONArray rows = (JSONArray) json.get("LIST");
				List[] arr = new ArrayList[RMSApiService.ROOM_TYPE.length];
				for(int i = 0; i < arr.length; i++) {
					arr[i] = new ArrayList<Param>();
				}
				
				for(int i = 0; i < rows.size(); i++) {
					JSONObject row = (JSONObject) JSONValue.parse(rows.get(i).toString());
					
					if(!row.get("APLY_DATE").equals(param.get("chot_date").replaceAll("\\.", ""))) {	// 체크아웃일 제외
						Param p = new Param();
						p.set("aply_date",			row.get("APLY_DATE"));
						p.set("ssn_gbcd", 			row.get("SSN_GBCD"));
						p.set("room_knd_gbcd", 		row.get("ROOM_KND_GBCD"));
						p.set("room_knd_nm", 		row.get("ROOM_KND_NM"));
						p.set("forcasting_qty", 	row.get("FORCASTING_QTY"));
						p.set("basic_prsn", 		row.get("BASIC_PRSN"));
						p.set("max_prsn", 			row.get("MAX_PRSN"));
						p.set("chrg_grup_gbcd_01", 	row.get("CHRG_GRUP_GBCD_01"));
						p.set("room_amt_01", 		row.get("ROOM_AMT_01"));
						p.set("chrg_grup_gbcd_02", 	row.get("CHRG_GRUP_GBCD_02"));
						p.set("room_amt_02", 		row.get("ROOM_AMT_02"));
					
						int idx = ArrayUtils.indexOf(RMSApiService.ROOM_TYPE, p.get("room_knd_gbcd"));
						if(idx != -1) {
							arr[idx].add(p);
						}
						
						/*
						if("A".equals(p.get("room_knd_gbcd"))) {
							arr[0].add(p);
						} else if("B".equals(p.get("room_knd_gbcd"))) {
							arr[1].add(p);
						} else if("C".equals(p.get("room_knd_gbcd"))) {
							arr[2].add(p);
						} else if("D".equals(p.get("room_knd_gbcd"))) {
							arr[3].add(p);
						} else if("P".equals(p.get("room_knd_gbcd"))) {
							arr[4].add(p);
						} else if("Q".equals(p.get("room_knd_gbcd"))) {
							arr[5].add(p);
						}
						*/
					}					
				}
				
				int dateDiff = SanghafarmUtils.getDateDiff(param.get("chki_date"), param.get("chot_date"));
				
				for(int i = 0; i < arr.length; i++) {
					List<Param> l = arr[i];
					if(l.size() == dateDiff) {
						int price1 = 0;
						int price2 = 0;
						int qty = Integer.MAX_VALUE;
						
						for(int j = 0; j < l.size(); j++) {
							Param r = l.get(j);
							price1 += r.getInt("room_amt_01");
							price2 += r.getInt("room_amt_02");
							qty = (qty < r.getInt("forcasting_qty")) ? qty : r.getInt("forcasting_qty");
							
							if(j == l.size() - 1) {	// last of list
								if(qty > 0) {
									r.set("room_amt_01", price1);
									r.set("room_amt_02", price2);
									r.set("forcasting_qty", qty);
									
									list.add(r);
								}
							}
						}
					}
				}
			}
		} catch(Exception e) {
			System.out.println(param);
			System.out.println(json.toJSONString());
			e.printStackTrace();
		}
		
		return list;
	}

	public Param getDateList(String chkiDate, String chotDate) {
		Param param = new Param();
		param.set("chki_date", chkiDate);
		param.set("chot_date", chotDate);
		
		return getDateList(param);
	}
	
	public Param getDateList(Param param) {
		JSONObject json = forecast(param);

		Param p = new Param();
		
		try {
			String result = (String) json.get("RESULT");
			if("Y".equals(result)) {
				JSONArray rows = (JSONArray) json.get("LIST");

				for(int i = 0; i < rows.size(); i++) {
					JSONObject row = (JSONObject) JSONValue.parse(rows.get(i).toString());
					if("A,B,C,D".indexOf(row.get("ROOM_KND_GBCD").toString()) != -1) {
						if(Integer.parseInt(row.get("FORCASTING_QTY").toString()) > 0) {
							p.set(row.get("APLY_DATE").toString(), p.getInt(row.get("APLY_DATE").toString(), 0) + Integer.parseInt(row.get("FORCASTING_QTY").toString()));
						}
					}
				}
			}
		} catch(Exception e) {
			System.out.println(param);
			e.printStackTrace();
		}
		
		return p;
	}
	
	public JSONObject reserve(JSONObject json) {
		String s = "";
		JSONObject res = null;
		
		try {
			URL url = new URL(HOST + "/api/internet/xpSaveRmResv.do");
	
			s = getResult(url, json.toString());
			res = (JSONObject) JSONValue.parse(s);
		} catch(Exception e) {
			System.out.println(json.toJSONString());
			e.printStackTrace();
		}
		
		return res;		
	}

	@SuppressWarnings("unchecked")
	public JSONObject info(Param param) {
		String s = "";
		JSONObject res = null;
		
		try {
			URL url = new URL(HOST + "/api/internet/xpRetrieveRmResvInfo.do");
//			URL url = new URL(HOST + "/api/internet/xpRetrieveRmResvInfo.do?pkg=1");
	
			JSONObject json = new JSONObject();
			json.put("BUSES_CD", BUSES_CD);
			json.put("MEM_NO", param.get("unfy_mmb_no"));
			json.put("RESV_ST_GBCD", param.get("resv_st_gbcd"));
			json.put("CHKI_DATE", param.get("chki_date"));
			json.put("CHOT_DATE", param.get("chot_date"));
	
			s = getResult(url, json.toString());
			res = (JSONObject) JSONValue.parse(s);
		} catch(Exception e) {
			System.out.println(param);
			e.printStackTrace();
		}
		
		return res;		
	}

	@SuppressWarnings("unchecked")
	public JSONObject detail(Param param) {
		String s = "";
		JSONObject res = null;
		
		try {
			URL url = new URL(HOST + "/api/internet/xpRetrieveRmResvInfoDtl.do");
//			URL url = new URL(HOST + "/api/internet/xpRetrieveRmResvInfoDtl.do?pkg=1");
	
			JSONObject json = new JSONObject();
			json.put("BUSES_CD", BUSES_CD);
			json.put("INTG_RESV_NO", param.get("intg_resv_no"));
	
			s = getResult(url, json.toString());
			res = (JSONObject) JSONValue.parse(s);
		} catch(Exception e) {
			System.out.println(param);
			e.printStackTrace();
		}
		
		return res;		
	}

	@SuppressWarnings("unchecked")
	public JSONObject cancel(Param param) {
		String s = "";
		JSONObject res = null;
		
		try {
			URL url = new URL(HOST + "/api/internet/xpSaveRmResvCancel.do");
	
			JSONObject json = new JSONObject();
			json.put("BUSES_CD", BUSES_CD);
			json.put("INTG_RESV_NO", param.get("intg_resv_no"));
	
			s = getResult(url, json.toString());
			res = (JSONObject) JSONValue.parse(s);
		} catch(Exception e) {
			System.out.println(param);
			e.printStackTrace();
		}
		
		return res;		
	}

	public String getResult(URL url, String param) {
		BufferedReader urlreader = null;
		StringBuffer sb = new StringBuffer();
		String s = "";
		
		long start = System.currentTimeMillis();
		
		try {
			String enc = SecurityUtils.encodeAES(param);

			int timeout = 300 * 1000;	// 2022.04.28 20 -> 90초로 변경, 2022.05.20 -> 300초로 변경 
			HttpURLConnection urlc = (HttpURLConnection) url.openConnection();
			urlc.setConnectTimeout(timeout);
			urlc.setReadTimeout(timeout);
			urlc.setRequestMethod("POST");
			urlc.setDoOutput(true);
			urlc.setUseCaches(false);
			
			OutputStream writer = urlc.getOutputStream();
            writer.write(("param=" + enc).getBytes("UTF-8"));
            writer.flush();
            writer.close();

            int responseCode = urlc.getResponseCode();   
			logger.debug(start + " URL : " + url);
			logger.debug(start + " Param1 : " + param);
//			logger.debug("Param2 : " + enc);
            logger.debug(start + " Response Code : " + responseCode);
//            logger.debug("Content Length : " + urlc.getContentLength());
	        if (responseCode == HttpURLConnection.HTTP_OK) {
				urlreader = new BufferedReader(new InputStreamReader(urlc.getInputStream(), "utf-8"));
	
				String line = null;
				while((line = urlreader.readLine()) != null){
					sb.append(line);
				}
	
				logger.debug(start + " RESULT1 : " + sb.toString());
				s = SecurityUtils.decodeAES(sb.toString());
				logger.debug(start + " RESULT2 : " + s + "\n");
	        }
		} catch (Exception e) { 
			logger.error(start + " URL : " + url);
			logger.error(start + " Param1 : " + param);
//			e.printStackTrace();
			logger.error(e.getMessage(), e);
		} finally {
			try { urlreader.close(); } catch (Exception e) {}
		}
		
		long end = System.currentTimeMillis();
    	logger.debug(start + " DURATION : " + (end - start) + " ms");

		return s;
	}

}
