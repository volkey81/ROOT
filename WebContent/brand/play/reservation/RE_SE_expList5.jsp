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
	Param param = new Param(request);
	ExpContentService svc = new ExpContentService();
	param.keepQuery(response);

	//String date = param.get("date", Utils.getTimeStampString(new Date(), "yyyy.MM.dd"));
	String date = param.get("date");
	
	Date today = new Date();
	Locale currentLocale = new Locale("KOREAN", "KOREA");
	String pattern1 = "yyyy.MM.dd"; 
	String pattern2 = "hhmm";
	SimpleDateFormat sdf1 = new SimpleDateFormat(pattern1, currentLocale);
	SimpleDateFormat sdf2 = new SimpleDateFormat(pattern2, currentLocale);
	Date paramdate = sdf1.parse(date);
	String time1 = sdf2.format(today);
	
	if(param.get("time").isEmpty()){
	
		if(!paramdate.before(today)){ // 오늘이 아니면
			param.set("time","0000");
		}else{		
			param.set("time",time1);
		}
	}
	
	
	List<Param> list = svc.getListByDateOrderNM(param);	
%>
<ul class="exp_list">
<%
int currentIndex = 0; // 인덱스 
int rIndex = 1; // radio 버튼을 위한 인덱스
String previousValue = null; // 이전값 저장 변수
for(Param row : list) {
	
		if(previousValue != null){
			if(row.get("exp_type_nm").equals(previousValue)){ // 이전 제목과 동이하면 시간만 출력
%>
					<div class="time_select">
                        <input type="radio" name="item<%= rIndex %>" id="item<%= rIndex %>_<%= currentIndex %>" value="<%= row.get("exp_pid")%>">
                        <label for="item<%= rIndex %>_<%= currentIndex %>">
                            <b><%= row.get("time").substring(0, 2) + ":" + row.get("time").substring(2) %></b>
                            <span>(잔여 : <em><%= row.getInt("seat_num") - row.getInt("reserved_num") %></em>)</span>
                        </label>
                    </div> 

<%				
			}else{//이전값과 다르면 새롭게 
	rIndex++; 
%>
<li>
            <div class="exp_item flex_wrap">
                <p class="item_img"><img src="${pageContext.request.contextPath}/image/exp_01.png" alt=""></p>
                <div class="item_content">
                    <b><%= row.get("exp_type_nm") %></b>
                    <span><%= row.get("summary") %></span>
                    <button type="button" onClick="popDetail('<%= row.get("seq") %>')">더보기</button>
                </div>
                <div class="item_time time_4">
                    <div class="time_select">
                        <input type="radio" name="item<%= rIndex %>" id="item<%= rIndex %>_<%= currentIndex %>" value="<%= row.get("exp_pid")%>">
                        <label for="item<%= rIndex %>_<%= currentIndex %>">
                            <b><%= row.get("time").substring(0, 2) + ":" + row.get("time").substring(2) %></b>
                            <span>(잔여 : <em><%=row.getInt("seat_num") - row.getInt("reserved_num")%></em>)</span>
                        </label>
                    </div>
<%				
			}
		}else{//처음 시작부분
%>
 		<li>
            <div class="exp_item flex_wrap">
                <p class="item_img"><img src="${pageContext.request.contextPath}/image/exp_01.png" alt=""></p>
                <div class="item_content">
                    <b><%= row.get("exp_type_nm") %></b>
                    <span><%= row.get("summary") %></span>
                    <button type="button" onClick="popDetail('<%= row.get("seq") %>')">더보기</button>
                </div>
                <div class="item_time time_4">
                    <div class="time_select">
                        <input type="radio" name="item<%= rIndex %>" id="item<%= rIndex %>_<%= currentIndex %>"  value="<%= row.get("exp_pid")%>">
                        <label for="item<%= rIndex %>_<%= currentIndex %>">
                            <b><%= row.get("time").substring(0, 2) + ":" + row.get("time").substring(2) %></b>
                            <span>(잔여 : <em><%=row.getInt("seat_num") - row.getInt("reserved_num")%></em>)</span>
                        </label>
                    </div>
<%			
		}
	
%>
        
   <%
   previousValue = row.get("exp_type_nm");
   currentIndex++;
}
   %>     
    </ul>