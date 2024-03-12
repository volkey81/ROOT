package com.sanghafarm.service.api;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

public class TmsapiService {
	private static String HOST = "https://tmsapi.teamfresh.co.kr";
//	private static String APIACCESSKEY = "jHM/Y2SOTxpoUDa2q3E9UXPX8ZzZ+UUDloOqmd5jGgFcPKv7aiSPb9N1p8dK28KK";
	private static String APIACCESSKEY = "26cOGVUfEMxeVGjNF2Dxypuca/cZseOXd2rH0X+KgQgkWiDtlv7kMkDP695JyKF7q84q0isWIhoxBQtruouv8mGOaQnkOS6zQNJOFnlARck=";
	
	public String searchDeliveryArea(String addr) throws Exception {
		BufferedReader reader = null;
		StringBuffer sb = new StringBuffer();
		
		try {
			URL url = new URL(TmsapiService.HOST + "/api/area/searchDeliveryArea");
			System.out.println("url : " + url.toString());
			String apiaccesskey = TmsapiService.APIACCESSKEY;
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("POST");
			conn.setDoOutput(true);
			conn.setUseCaches(false);
			conn.setRequestProperty("apiaccesskey", apiaccesskey);
			conn.setRequestProperty("Content-Type", "application/json");
			
			OutputStream writer = conn.getOutputStream();
			String param = "{ \"addrBasic\" : \"" + addr + "\" }";
			System.out.println("apiaccesskey : " + apiaccesskey);
			System.out.println("parameter : " + param);
            writer.write(param.getBytes("UTF-8"));
            writer.flush();
            writer.close();

            int responseCode = conn.getResponseCode();   
            System.out.println("Response : " + responseCode + " " + conn.getResponseMessage());
	        if(responseCode == HttpURLConnection.HTTP_OK) {
	        	reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
	
				String line = null;
				while((line = reader.readLine()) != null){
					sb.append(line);
				}
	
				System.out.println("RESULT : " + sb.toString());
	        }
	        
			conn.disconnect();
			
		} catch(Exception e) { 
			e.printStackTrace();
			System.err.println(e.getMessage());
		} finally {
			try { reader.close(); } catch (Exception e) {}
		}

		return sb.toString();
	}
}
