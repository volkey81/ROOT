package com.sanghafarm.utils;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

import com.efusioni.stone.common.SystemChecker;
import com.efusioni.stone.utils.Param;

public class NaverPayUtil {
	private Logger logger = Logger.getLogger(this.getClass());
	private static String API_DOMAIN = "https://apis.naver.com";
	private static String APPROVE_PATH = "/naverpay/payments/v2.2/apply/payment";
	private static String CANCEL_PATH = "/naverpay/payments/v1/cancel";
	
	public NaverPayUtil() {
		if(!SystemChecker.isReal()) {
			API_DOMAIN = "https://dev.apis.naver.com";
		}
	}
	
	public JSONObject approve(String partnerId, String clientId, String clientSecret, Param param) {
		return getResult(API_DOMAIN + "/" + partnerId + APPROVE_PATH, clientId, clientSecret, param);
	}
	
	public JSONObject cancel(String partnerId, String clientId, String clientSecret, Param param) {
		return getResult(API_DOMAIN + "/" + partnerId + CANCEL_PATH, clientId, clientSecret, param);
	}
	
	public JSONObject getResult(String url, String clientId, String clientSecret, Param param) {
		return getResult(url, clientId, clientSecret, param.toQueryString());
	}
	
	@SuppressWarnings("unchecked")
	public JSONObject getResult(String url, String clientId, String clientSecret, String param) {
		JSONObject res = null;
		BufferedReader reader = null;
		OutputStreamWriter writer = null;
		StringBuffer sb = new StringBuffer();
		
		try {
			logger.debug(String.format("NaverPay URL : %s", url));
			logger.debug(String.format("NaverPay Param : %s", param));

			HttpURLConnection urlc = (HttpURLConnection) (new URL(url).openConnection());
			urlc.setConnectTimeout(60 * 1000);
			urlc.setRequestProperty("X-Naver-Client-Id", clientId);
			urlc.setRequestProperty("X-Naver-Client-Secret", clientSecret);
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
            logger.debug(String.format("NaverPay Response Code : %s", responseCode));
	        
            if(responseCode == HttpURLConnection.HTTP_OK) {
	        	reader = new BufferedReader(new InputStreamReader(urlc.getInputStream(), "utf-8"));
            } else {
	        	reader = new BufferedReader(new InputStreamReader(urlc.getErrorStream(), "utf-8"));
            }

            String line = null;
			while((line = reader.readLine()) != null){
				sb.append(line);
			}

			logger.debug(String.format("NaverPay RESULT : %s\n", sb.toString()));
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

}
