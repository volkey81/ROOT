package com.sanghafarm.utils;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.codec.binary.Base64;
import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

import com.efusioni.stone.common.SystemChecker;
import com.efusioni.stone.utils.Param;

public class KakaopayUtil {
	private Logger logger = Logger.getLogger(this.getClass());
	private static String HOST = "https://kapi.kakao.com";
	private static String READY_PATH = "/v1/payment/ready";
	private static String APPROVE_PATH = "/v1/payment/approve";
	private static String CANCEL_PATH = "/v1/payment/cancel";
	private static String ADMIN_KEY = "db03dde616a3030ab341bbdd9aac5bb6";
	private static String CID = "";
	
	public KakaopayUtil() {
		if(CID == "") {
			if(SystemChecker.isReal()) {
				CID = "C723520180";
			} else {
				CID = "TC0ONETIME";
			}
		}
	}
	
	public JSONObject ready(Param param) {
		// 부가세 계산
		int amt = param.getInt("total_amount") - param.getInt("tax_free_amount");
		int vat = amt / 11;
		param.set("vat_amount", vat);
		return getResult(HOST + READY_PATH, param);
	}
	
	public JSONObject approve(Param param) {
		return getResult(HOST + APPROVE_PATH, param);
	}
	
	public JSONObject cancel(Param param) {
		return getResult(HOST + CANCEL_PATH, param);
	}
	
	public JSONObject getResult(String url, Param param) {
		return getResult(url, param.toQueryString());
	}
	
	@SuppressWarnings("unchecked")
	public JSONObject getResult(String url, String param) {
		JSONObject res = null;
		BufferedReader reader = null;
		OutputStreamWriter writer = null;
		StringBuffer sb = new StringBuffer();
		param = "cid=" + CID + "&" + param;
		
		try {
			logger.debug(String.format("KakaoPay URL : %s", url));
			logger.debug(String.format("KakaoPay Param : %s", param));

			HttpURLConnection urlc = (HttpURLConnection) (new URL(url).openConnection());
			urlc.setRequestProperty("Authorization", "KakaoAK " + ADMIN_KEY);
			urlc.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
			urlc.setRequestProperty("charset", "utf-8");
			urlc.setRequestMethod("POST");
            urlc.setDoOutput(true);
			urlc.setUseCaches(false);
			
			writer = new OutputStreamWriter(urlc.getOutputStream());
            writer.write(param);
            writer.flush();
            writer.close();

            int responseCode = urlc.getResponseCode();   
            logger.debug(String.format("KakaoPay Response Code : %s", responseCode));
	        
            if(responseCode == HttpURLConnection.HTTP_OK) {
	        	reader = new BufferedReader(new InputStreamReader(urlc.getInputStream(), "utf-8"));
            } else {
	        	reader = new BufferedReader(new InputStreamReader(urlc.getErrorStream(), "utf-8"));
            }

            String line = null;
			while((line = reader.readLine()) != null){
				sb.append(line);
			}

			logger.debug(String.format("KakaoPay RESULT : %s\n", sb.toString()));
			res = (JSONObject) JSONValue.parse(sb.toString());
			res.put("response_code", responseCode);
		} catch (Exception e) { 
			e.printStackTrace();
			logger.error(e.getMessage(), e);
		} finally {
			if(writer != null) try { writer.close(); } catch (Exception e) {}
			if(reader != null) try { reader.close(); } catch (Exception e) {}
		}
		
		return res;
	}


	
	
	
	/**
	 * 현재날짜를 YYYYMMDDHHMMSS로 리턴
	 */
	public static final synchronized String getyyyyMMddHHmmss(){
		/** yyyyMMddHHmmss Date Format */
		SimpleDateFormat yyyyMMddHHmmss = new SimpleDateFormat("yyyyMMddHHmmss");

		return yyyyMMddHHmmss.format(new Date());
	}

	public static String SHA256Salt(String strData, String salt) { 
		  String SHA = "";
		  
		try {
			MessageDigest sh = MessageDigest.getInstance("SHA-256");
			sh.reset();
			sh.update(salt.getBytes());
			byte byteData[] = sh.digest(strData.getBytes());
			
			//Hardening against the attacker's attack
			sh.reset();
			byteData = sh.digest(byteData);
			
			StringBuffer sb = new StringBuffer();
			for(int i = 0 ; i < byteData.length ; i++){
				sb.append(Integer.toString((byteData[i]&0xff) + 0x100, 16).substring(1));

			}
			
			SHA = sb.toString();
			byte[] raw = SHA.getBytes();
			byte[] encodedBytes = Base64.encodeBase64(raw);
			SHA = new String(encodedBytes);
		} catch(NoSuchAlgorithmException e) {
			e.printStackTrace();
			SHA = null;
		}
		
		return SHA;
	}
	
}
