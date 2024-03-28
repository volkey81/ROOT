<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="java.util.*,
            java.text.*,
            com.efusioni.stone.common.*,
            com.efusioni.stone.utils.*,
            com.sanghafarm.common.*,
            com.sanghafarm.service.board.*,
            com.sanghafarm.service.code.*,
            com.sanghafarm.utils.*" %>
<%
    request.setAttribute("Depth_1", new Integer(1));
    request.setAttribute("Depth_2", new Integer(3));
    request.setAttribute("Depth_3", new Integer(2));
    request.setAttribute("MENU_TITLE", new String("체험교실"));
    
    Param param = new Param(request);
    ExpContentService svc = new ExpContentService();
    String date = param.get("date");
    List<Param> list = svc.getListByTime(date);
    
    Date today = new Date();
    Locale currentLocale = new Locale("KOREAN", "KOREA");
    String pattern1 = "yyyy.MM.dd"; 
    // 정확한 비교를 위해 24시간 형식 사용
    String pattern2 = "HHmm";
    SimpleDateFormat sdf1 = new SimpleDateFormat(pattern1, currentLocale);
    SimpleDateFormat sdf2 = new SimpleDateFormat(pattern2, currentLocale);
    Date paramdate = sdf1.parse(date);
    // 비교를 위해 시간을 24시간 형식으로 확보
    String time1 = sdf2.format(today);
//  System.out.println(formatter.format(today));
%>
    <option value="">시간 선택</option>
<%
if(!paramdate.before(today)){
	boolean firstTime=false;
    for(Param row : list) {
    	if(!firstTime){
    		firstTime=true;
        // 미래 날짜에 대해 가능한 모든 시간 표시
%>
    <option value="<%= row.get("time") %>" selected><%= row.get("time").substring(0, 2) + ":" + row.get("time").substring(2) %></option>
<%
		} else {
%>
    <option value="<%= row.get("time") %>"><%= row.get("time").substring(0, 2) + ":" + row.get("time").substring(2) %></option>
<%
		}
    }
}else{
    // 오늘 날짜에 대해 이미 지난 시간은 필터링
    boolean firstTime = false;
    for(Param row : list) {
        if(Integer.valueOf(row.get("time")) >= Integer.valueOf(time1) ){
        	if(!firstTime){
        		firstTime=true;
%>
    <option value="<%= row.get("time") %>" selected><%= row.get("time").substring(0, 2) + ":" + row.get("time").substring(2) %></option>
<%
            } else {
%>
    <option value="<%= row.get("time") %>"><%= row.get("time").substring(0, 2) + ":" + row.get("time").substring(2) %></option>
<%
            }
        }
    }
}
%>
