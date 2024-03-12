<%@ page contentType="text/html; charset=UTF-8" errorPage="/m/mall/error/error.jsp"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="java.io.InputStreamReader"%>
<%@ page import="java.net.HttpURLConnection"%>
<%@ page import="com.efusioni.stone.utils.Param" %>
<%
	Param param = new Param(request);
	
    final String URL = "https://play.google.com/store/apps/details?id=";

	int appVersion 	  = 0;
	int marketVersion = 0;
	
	String packageName 	= param.get("packageName");
	
	String result = "";
	StringBuilder html = new StringBuilder();
	HttpURLConnection conn = null;
	
	try {
	    URL url = new URL(URL + packageName);
	    conn = (HttpURLConnection) url.openConnection();
	    
	    if (conn != null) {
	        conn.setConnectTimeout(1000);
	        conn.setUseCaches(false);	        
	        if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
	            BufferedReader br = new BufferedReader( new InputStreamReader(conn.getInputStream()) );
				
	            for ( ; ; ) {
	                String line = br.readLine();
	                if (line == null)
	                    break;
	                html.append(line + '\n');
	            }
				
	            br.close();
	            
	            appVersion = Integer.parseInt(param.get("appVersion").replace(" ", "").replace(".", ""));
	            
	            int start, end;
	            if(html.indexOf("softwareVersion") > -1) {
	    	        start = html.indexOf("softwareVersion") + "softwareVersion".length() + 2;
	    	        end = html.indexOf("</div>", start);	    	        
	    	        result = html.substring(start, end);
	    	        result = result.replace(" ", "").replace(".", "");
	    	        
	    	        marketVersion = Integer.parseInt(result);
	    	    } else {
	    	    	String marketVersionName = "1.0.6";
	    	    	marketVersion = Integer.parseInt(marketVersionName.replace(" ", "").replace(".", ""));	    	    	
	    	    }
	            
	            if(appVersion < marketVersion) {
	            	out.println("Y");
	            	return;
	            }
	        }
	    }
	    
	    out.println("N");
		
	} catch (Exception e) {
		out.println("N");
		System.out.println(e);
	} finally {
	    conn.disconnect(); //접속 종료
	}
%>