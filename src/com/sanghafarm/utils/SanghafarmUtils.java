package com.sanghafarm.utils;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.JspWriter;

import com.efusioni.stone.common.Config;
import com.efusioni.stone.common.SystemChecker;
import com.efusioni.stone.security.SecurityUtils;
import com.efusioni.stone.utils.Utils;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.sanghafarm.common.Env;

import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

public class SanghafarmUtils {
	private static String CHARSET = "utf-8";
	
	public static String[] EMAILS = {
			"naver.com",
			"hanmail.net",
			"gmail.com",
			"nate.com",
			"yahoo.com",
			"hotmail.com",
			"korea.com"
		};

	public static String[] MOBILES = {
			"010",
			"011",
			"016",
			"017",
			"018",
			"019"
		};

	public static String[] HYUNDAI_PROMOTION_CARDPREFIXS = {
			"528936",
			"558915",
			"448168",
			"454303",
			"949012",
			"949033",
			"552376",
			"558970",
			"951001",
			"419696",
			"419698",
			"414749",
			"949034",
			"523930",
			"553150",
			"552377",
			"558971",
			"419697"
		};
	
	public static String[] HYUNDAI_PROMOTION_PIDS = {
			"A0002144",
			"A0002145",
			"A0002146",
			"A0002147",
			"A0002148",
			"A0002149",
			"A0002150",
			"A0002151",
			"E0002152",
			"E0002154",
			"E0002155",
			"E0002156",
			"E0002157",
			"E0002158",
			"E0002159",
			"E0002160",
			"A0002304",
			"A0002305",
			"A0002306",
			"A0002307",
			"A0002308",
			"A0002309",
			"A0002310"
		};
	
	static {
		if(!SystemChecker.isReal()) {
			HYUNDAI_PROMOTION_PIDS = new String[] {
					"A0000007", "A0000005", "A0000410"
				};
		}
	}

	public static boolean isHyundaiPromotionCard(String cardPrefix) {
		boolean b = false;
		
		for(String s : HYUNDAI_PROMOTION_CARDPREFIXS) {
			if(s.equals(cardPrefix)) {
				b = true;
				break;
			}
		}
		
		return b;
	}
	
	public static boolean isHyundaiPromotionPid(String pid) {
		boolean b = false;
		
		for(String s : HYUNDAI_PROMOTION_PIDS) {
			if(s.equals(pid)) {
				b = true;
				break;
			}
		}
		
		return b;
	}

	public static void setCookie(HttpServletResponse response, String key, String val) {
		setCookie(response, key, val, null);
	}

	public static void setCookie(HttpServletResponse response, String key, String val, String domain) {
		setCookie(response, key, val, null, -1);
	}

	public static void setCookie(HttpServletResponse response, String key, String val, String domain, int expiry) {
		try {
			if (val == null) return;
			// 암호화
			String s = SecurityUtils.encodeAES(val);
			Cookie cookie = new Cookie(key, URLEncoder.encode(s, CHARSET));
//			Cookie cookie = new Cookie(key, URLEncoder.encode(val, CHARSET));
			cookie.setPath("/");
			cookie.setMaxAge(expiry);
			if (domain != null) cookie.setDomain(domain);
			response.addCookie(cookie);
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	public static String getCookie(HttpServletRequest request, String key) {
		return getCookie(request, key, "");
	}
	
	public static String getCookie(HttpServletRequest request, String key, String defaultValue) {
		try {
			Cookie cookies[] = request.getCookies();
			for (int i = 0; i < cookies.length; i++) {
				if (cookies[i].getName().equals(key)) {
					try {
						String s = URLDecoder.decode(cookies[i].getValue(), CHARSET);
						// 복호화
						return SecurityUtils.decodeAES(s);
					} catch(Exception e) {
//						System.out.println("------------------ cookie decoding fail -------- " + e.toString());
						try {	// 복호화 실패시 평문
							return URLDecoder.decode(cookies[i].getValue(), CHARSET);
						} catch(Exception e2) {
							e2.printStackTrace();
						}
					}
				}
			}
		} catch (NullPointerException e) {
//			return defaultValue;
		}

		return defaultValue;
	}

	public static void deleteCookie(HttpServletRequest request, HttpServletResponse response, String key) {
		Cookie acookie[] = request.getCookies();
		for (int i = 0; i < acookie.length; i++) {
			Cookie cookie = new Cookie(acookie[i].getName(), "");
			if (cookie.getName().equals(key)) {
				cookie.setMaxAge(0);
				cookie.setPath("/");
				response.addCookie(cookie);
			}
		}
	}

	public static List<Date> getDeliveryDates(String[] days, int period, int count) {
		List<Date> list = new ArrayList<Date>();
		
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.WEEK_OF_YEAR, 1);
		cal.add(Calendar.DATE, 1 - cal.get(Calendar.DAY_OF_WEEK));	// 다음주 일요일
		
		int idx = 0;
		
		for(int i = 0; i < count; i++) {
			for(int j = 0; j < days.length; j++) {
				Calendar c = (Calendar) cal.clone(); 
				c.add(Calendar.DATE, Integer.parseInt(days[j]) - 1);
				list.add(idx, c.getTime());
				idx++;
				
				if(idx == count) break;
			}

			if(idx == count) break;
			cal.add(Calendar.WEEK_OF_YEAR, period);
		}
		
		return list;
	}
	
	public static List<Date> getDeliveryDates(String[] days, int period, int count, String basisDate) {
		List<Date> list = new ArrayList<Date>();
		
		Calendar cal = Calendar.getInstance();
		cal.set(Calendar.YEAR, Integer.parseInt(basisDate.substring(0, 4)));
		cal.set(Calendar.MONTH, Integer.parseInt(basisDate.substring(4, 6)) - 1);
		cal.set(Calendar.DATE, Integer.parseInt(basisDate.substring(6, 8)));
		
		int idx = 0;
		
		for(int i = 0; i < count; i++) {
			for(int j = 0; j < 7; j++) {
				Calendar c = (Calendar) cal.clone(); 
				c.add(Calendar.DATE, j);
				for(int m = 0; m < days.length; m++) {
					if(c.get(Calendar.DAY_OF_WEEK) == Integer.parseInt(days[m])) {
						list.add(idx, c.getTime());
						idx++;
						if(idx == count) break;
					}
				}
			}
			
			if(idx == count) break;			
			cal.add(Calendar.DATE, period * 7);
		}
		
		return list;
	}
	
	public static String getFirstDeliveryDate(String[] days) {
		return getFirstDeliveryDate(days, "yyyyMMdd");
	}

	public static String getFirstDeliveryDate(String[] days, String format) {
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.WEEK_OF_YEAR, 1);
		cal.add(Calendar.DATE, 1 - cal.get(Calendar.DAY_OF_WEEK));	// 다음주 일요일
		
		Calendar c = (Calendar) cal.clone(); 
		c.add(Calendar.DATE, Integer.parseInt(days[0]) - 1);
		return Utils.getTimeStampString(c.getTime(), format);
	}
	
	public static String getFirstDeliveryDate(String[] days, String format, String basisDate ) {
		Calendar cal = Calendar.getInstance();
		cal.set(Calendar.YEAR, Integer.parseInt(basisDate.substring(0, 4)));
		cal.set(Calendar.MONTH, Integer.parseInt(basisDate.substring(4, 6)) - 1);
		cal.set(Calendar.DATE, Integer.parseInt(basisDate.substring(6, 8)));

		for(int i = 0; i < 7; i++) {
			Calendar c = (Calendar) cal.clone(); 
			c.add(Calendar.DATE, i);
			for(int j = 0; j < days.length; j++) {
				if(c.get(Calendar.DAY_OF_WEEK) == Integer.parseInt(days[j])) {
					return Utils.getTimeStampString(c.getTime(), format);
				}
			}
		}
		
		return null;
	}
	
	public static String toKOR(String s) throws UnsupportedEncodingException {
		if(s == null) return s;
		if(SystemChecker.isReal()) return new String(s.getBytes("8859_1"), "euc-kr");
		else return s;
	}
	
	public static String formatDate(Date date) {
		return formatDate(date, "yyyy-MM-dd HH:mm:ss");
	}

	public static String formatMinute(Date date) {
		return formatDate(date, "yyyy-MM-dd HH:mm");
	}

	public static String formatDate(Date date, String format) {
		SimpleDateFormat formatter = new SimpleDateFormat(format, java.util.Locale.KOREA);
		return formatter.format(date);
	}
	public static String formatDate(String date, String format) {
		SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date to = null;
		try {
			to = transFormat.parse(date);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return formatDate(to, "yyyy-MM-dd HH:mm");
	}
	
	public static String removeHtml(String str) {
		  StringBuffer t = new StringBuffer();
		  StringBuffer t2 = new StringBuffer();
		  
		 
		  char[] c = str.toCharArray();
		  char ch;
		  int d = 0;
		  boolean check = false;
		  boolean scriptChkeck = false;
		  boolean styleCheck = false;
		  for(int i=0,len = c.length;i<len;i++) {
		   ch = c[i];
		   if(ch=='<') {
		    check = true;
		   }
		   
		   if(!check&!scriptChkeck&&!styleCheck){
		    
		    t.append(ch);
		   }

		    d++;
		    t2.append(ch);
		    if(d>9){
		     t2.delete(0,1);

		    }
		    
		    
		    if(!scriptChkeck) {
		     if(t2.toString().toLowerCase().indexOf("<script")==0){
		      scriptChkeck = true; 
		     }
		     
		    }
		    if(scriptChkeck) {
		     if(t2.toString().toLowerCase().indexOf("</script>")==0){
		     
		      scriptChkeck = false; 
		     }

		    }
		    
		    
		    if(!styleCheck) {
		     if(t2.toString().toLowerCase().indexOf("<style")==0){
		      styleCheck = true; 
		     }
		     
		    }
		    if(styleCheck) {
		     
		     if(t2.toString().toLowerCase().indexOf("</style>")==0){
		      styleCheck = false; 
		     }

		    }
		    
		    if(ch=='>') {
		     check = false;
		    }
		   }
		  
		    
		  return  t.toString();  
		 }
	
	public static void sendLoginMessage(JspWriter out, String message, HttpServletRequest request) throws Exception {
		String callUrl = request.getRequestURI();
		if(request.getQueryString() != null && !"".equals(request.getQueryString())) {
			callUrl += "?" + request.getQueryString();
		}

		String loginUrl = "/mobile/member/login.jsp?returnUrl=" + URLEncoder.encode(callUrl, "utf-8");
		
		StringBuffer sb = new StringBuffer();
		sb.append("<script type=\"text/javascript\">\n");
		sb.append("\talert(\"" + message + "\");\n");
		
		if(SystemChecker.isLocal()) {
			sb.append("\tdocument.location.href='/integration/login.jsp';");
		} else {
			sb.append("\twindow.open('" + loginUrl + "','popupMaeildoLogin','width=450,height=604,toolbar=no,menubar=no,status=no,scrollbars=yes,resizable=no');\n");
			sb.append("\t\thistory.back();\n");
		}

		sb.append("</script>");

		out.println(sb.toString());
	}

	public static void sendLoginMessageMobile(JspWriter out, String message, HttpServletRequest request) throws Exception {
		StringBuffer sb = new StringBuffer();
		sb.append("<script type=\"text/javascript\">\n");
		sb.append("\talert(\"" + message + "\");\n");

		String callUrl = request.getRequestURI();
		if(request.getQueryString() != null && !"".equals(request.getQueryString())) {
			callUrl += "?" + request.getQueryString();
		}
		
		String loginUrl = "/mobile/member/login.jsp?returnUrl=" + URLEncoder.encode(callUrl, "utf-8");

		if(SystemChecker.isLocal()) {
			sb.append("\tdocument.location.href='/integration/login.jsp';");
		} else {
			sb.append("\tdocument.location.href='" + loginUrl + "'");
		}

		sb.append("</script>");

		out.println(sb.toString());
	}
	
	public static boolean isValidApiParameter(String timestamp) {
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.MINUTE, -10);
		String exp = Utils.getTimeStampString(cal.getTime(), "yyyyMMddHHmm");
		
		if(exp.compareTo(timestamp) > 0) {	// 파라미터 유효기간 만료
			return false;
		} else {
			return true;
		}
	}

	public static String getBarcode(String code, String path) {
		return getBarcode(code, path, 220, 71);
	}
	
	public static String getBarcode(String code, String path, int width, int height) {
		try {
			File file = new File(Env.getUploadPath() + path + code + ".png");
			if(!file.exists()) {
				file = new File(Env.getUploadPath() + path);
				if(!file.exists()) {
					file.mkdir();
				}

				BarcodeFormat format = BarcodeFormat.CODE_128;
				MultiFormatWriter writer = new MultiFormatWriter();
				BitMatrix matrix = writer.encode(code, format, width, height);
				FileOutputStream os = new FileOutputStream(new File(Env.getUploadPath() + path + code + ".png"));
				MatrixToImageWriter.writeToStream(matrix, "png", os);
				os.flush();
				os.close();
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return Config.get("image.path") + path + code + ".png";
	}

	// 배송도착 예정일자
	public static String getExpectedDeliveryDay() {
		return getExpectedDeliveryDay("yyyy.MM.dd");
	}
	
	public static String getExpectedDeliveryDay(String format) {
		Calendar cal = Calendar.getInstance();
		switch(cal.get(Calendar.DAY_OF_WEEK)) {
			case 1 :
				cal.add(Calendar.DATE, 2);
				break;
			case 2 :
			case 3 :
			case 4 :
			case 5 :
				if(cal.get(Calendar.HOUR_OF_DAY) < 10) {
					cal.add(Calendar.DATE, 1);
				} else {
					cal.add(Calendar.DATE, 2);
				}
				break;
			case 6 :
				if(cal.get(Calendar.HOUR_OF_DAY) < 10) {
					cal.add(Calendar.DATE, 1);
				} else {
					cal.add(Calendar.DATE, 4);
				}
				break;
			case 7 :
				cal.add(Calendar.DATE, 3);
				break;
		}
		
		return Utils.getTimeStampString(cal.getTime(), format);
	}
	
	public static JSONObject getAPIDataInfo(String apiUrl, String query) {
		
		JSONObject result_json = new JSONObject();
		int responseCode = 200;
		
		try {
			System.out.println("------------------- getAPIDataInfo api url : " + apiUrl);
			System.out.println("------------------- getAPIDataInfo api query : " + query);

			URL url = new URL(apiUrl);						
		
		    HttpURLConnection conn = (HttpURLConnection)url.openConnection();
		    conn.setConnectTimeout(5 * 1000);
		    conn.setReadTimeout(5 * 1000);
		    
		    conn.setRequestProperty("Content-type", "application/x-www-form-urlencoded");		    
		    conn.setRequestMethod("POST");
		    conn.setDoOutput(true);
		    conn.setDoInput(true);
		    conn.setUseCaches(false);
		    conn.setDefaultUseCaches(false);
		
		    OutputStreamWriter stream = new OutputStreamWriter(conn.getOutputStream());
		    PrintWriter writer = new PrintWriter(stream);

			writer.write(query);
			writer.flush();

			BufferedReader urlreader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
		
			StringBuffer result = new StringBuffer();
		
			while(true){
				String tmp = urlreader.readLine();
				if(tmp == null) break;
				result.append(tmp);
			}
		
			result_json = (JSONObject)JSONSerializer.toJSON(result.toString());
			responseCode = conn.getResponseCode();
			
			if (responseCode != 200) {
				String errMsg = "{'resultCode' : 'E5000', 'resultMessage' : '응답시간이 초과되었습니다. 다시 시도해주세요'}";
				result_json = (JSONObject)JSONSerializer.toJSON(errMsg);
				return result_json;
			}

			System.out.println("------------------- getAPIDataInfo : " + result_json.toString());
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("통신이 실패했습니다. 서버의 상태를 확인해야 합니다. [ responseCode : "+ responseCode+"]");

		}
		return result_json;
	}

	public static String maskingName(String name) {
		String s = "";
		
		for(int i = 0; i < name.length(); i++) {
			if(i % 2 == 1) {
				s += "*";
			} else {
				s += name.substring(i, i + 1);
			}
		}
		
		return s;
	}
	
	public static String maskingId(String id) {
		String s = "";
		
		for(int i = 0; i < id.length(); i++) {
			if(i >= 3) {
				s += "*";
			} else {
				s += id.substring(i, i + 1);
			}
		}
		
		return s;
	}
	
	public static int getDateDiff(String sd, String ed) throws Exception {
		return getDateDiff(sd, ed, "yyyy.MM.dd");
	}
	
	public static int getDateDiff(String sd, String ed, String form) throws Exception {
		SimpleDateFormat format = new SimpleDateFormat(form);
		
		Date d1 = format.parse(sd);
		Date d2 = format.parse(ed);
		
		long diff = d2.getTime() - d1.getTime();
		long diffDays = diff / (24 * 60 * 60 * 1000);
		return (int) diffDays;
	}
	
	public static String getChnlCd(HttpServletRequest request) {
		String appYn = SanghafarmUtils.getCookie(request, "APP_YN", "N");
		if("Y".equals(appYn)) {
			return "42";
		} else {
			String ua=request.getHeader("User-Agent").toLowerCase();
			if (ua.matches(".*(android|avantgo|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\\/|plucker|pocket|psp|symbian|treo|up\\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino).*")||ua.substring(0,4).matches("1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\\-(n|u)|c55\\/|capi|ccwa|cdm\\-|cell|chtm|cldc|cmd\\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\\-s|devi|dica|dmob|do(c|p)o|ds(12|\\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\\-|_)|g1 u|g560|gene|gf\\-5|g\\-mo|go(\\.w|od)|gr(ad|un)|haie|hcit|hd\\-(m|p|t)|hei\\-|hi(pt|ta)|hp( i|ip)|hs\\-c|ht(c(\\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\\-(20|go|ma)|i230|iac( |\\-|\\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\\/)|klon|kpt |kwc\\-|kyo(c|k)|le(no|xi)|lg( g|\\/(k|l|u)|50|54|e\\-|e\\/|\\-[a-w])|libw|lynx|m1\\-w|m3ga|m50\\/|ma(te|ui|xo)|mc(01|21|ca)|m\\-cr|me(di|rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\\-2|po(ck|rt|se)|prox|psio|pt\\-g|qa\\-a|qc(07|12|21|32|60|\\-[2-7]|i\\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\\-|oo|p\\-)|sdk\\/|se(c(\\-|0|1)|47|mc|nd|ri)|sgh\\-|shar|sie(\\-|m)|sk\\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\\-|v\\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\\-|tdg\\-|tel(i|m)|tim\\-|t\\-mo|to(pl|sh)|ts(70|m\\-|m3|m5)|tx\\-9|up(\\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|xda(\\-|2|g)|yas\\-|your|zeto|zte\\-")){
				if(ua.indexOf("v901") > -1 || ua.indexOf("v500") > -1 || ua.indexOf("v525") > -1 || ua.indexOf("lg-v700n") > -1 || ua.indexOf("lg-v607l") > -1) { 
					return "3";
				} else {
					return "41";
				}
			} else {
				return "3";
			}
		}
	}

	public static String getNtryPath(HttpServletRequest request) {
		String appYn = SanghafarmUtils.getCookie(request, "APP_YN", "N");
		if("Y".equals(appYn)) {
			return "402";
		} else {
			String ua=request.getHeader("User-Agent").toLowerCase();
			if (ua.matches(".*(android|avantgo|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\\/|plucker|pocket|psp|symbian|treo|up\\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino).*")||ua.substring(0,4).matches("1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\\-(n|u)|c55\\/|capi|ccwa|cdm\\-|cell|chtm|cldc|cmd\\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\\-s|devi|dica|dmob|do(c|p)o|ds(12|\\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\\-|_)|g1 u|g560|gene|gf\\-5|g\\-mo|go(\\.w|od)|gr(ad|un)|haie|hcit|hd\\-(m|p|t)|hei\\-|hi(pt|ta)|hp( i|ip)|hs\\-c|ht(c(\\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\\-(20|go|ma)|i230|iac( |\\-|\\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\\/)|klon|kpt |kwc\\-|kyo(c|k)|le(no|xi)|lg( g|\\/(k|l|u)|50|54|e\\-|e\\/|\\-[a-w])|libw|lynx|m1\\-w|m3ga|m50\\/|ma(te|ui|xo)|mc(01|21|ca)|m\\-cr|me(di|rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\\-2|po(ck|rt|se)|prox|psio|pt\\-g|qa\\-a|qc(07|12|21|32|60|\\-[2-7]|i\\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\\-|oo|p\\-)|sdk\\/|se(c(\\-|0|1)|47|mc|nd|ri)|sgh\\-|shar|sie(\\-|m)|sk\\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\\-|v\\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\\-|tdg\\-|tel(i|m)|tim\\-|t\\-mo|to(pl|sh)|ts(70|m\\-|m3|m5)|tx\\-9|up(\\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|xda(\\-|2|g)|yas\\-|your|zeto|zte\\-")){
				if(ua.indexOf("v901") > -1 || ua.indexOf("v500") > -1 || ua.indexOf("v525") > -1 || ua.indexOf("lg-v700n") > -1 || ua.indexOf("lg-v607l") > -1) { 
					return "26";
				} else {
					return "401";
				}
			} else {
				return "26";
			}
		}
	}
}
