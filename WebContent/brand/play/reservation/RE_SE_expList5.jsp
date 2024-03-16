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

    String date = param.get("date", new SimpleDateFormat("yyyy.MM.dd", Locale.KOREA).format(new Date()));
    Date today = new Date();
    SimpleDateFormat sdfTime = new SimpleDateFormat("HHmm", Locale.KOREA);
    String defaultTime = sdfTime.format(today);
    Date paramDate = new SimpleDateFormat("yyyy.MM.dd", Locale.KOREA).parse(date);

    if(param.get("time").isEmpty()) {
        param.set("time", paramDate.before(today) ? defaultTime : "0000");
    }

    List<Param> list = svc.getListByDateOrderNM(param);
%>
<ul class="exp_list">
<%
    int rIndex = 0; // 라디오 버튼 그룹화를 위한 변수 초기화
    String previousExpTypeNm = null;
    for (Param row : list) {
        String currentExpTypeNm = row.get("exp_type_nm");
        if (!currentExpTypeNm.equals(previousExpTypeNm)) {
            // 이전 아이템이 있다면 닫기 태그 추가
            if (previousExpTypeNm != null) {
%>              </div>
                </div>
            </li>
<%
            }
            rIndex++; // 새로운 체험 유형에 대한 인덱스 증가
%>
            <li>
                <div class="exp_item flex_wrap">
                    <p class="item_img"><img src="${pageContext.request.contextPath}/image/exp_01.png" alt=""></p>
                    <div class="item_content">
                        <b><%= currentExpTypeNm %></b>
                        <span><%= row.get("summary") %></span>
                        <button type="button" onClick="popDetail('<%= row.get("seq") %>')">더보기</button>
                    </div>
                    <div class="item_time time_4">
<%
        }
        // 시간 슬롯 출력
%>
                        <div class="time_select">
                            <input type="radio" name="item<%= rIndex %>" id="item<%= rIndex %>_<%= row.get("exp_pid") %>" value="<%= row.get("exp_pid")%>">
                            <label for="item<%= rIndex %>_<%= row.get("exp_pid") %>">
                                <b><%= row.get("time").substring(0, 2) + ":" + row.get("time").substring(2) %></b>
                                <span>(잔여 : <em><%= row.getInt("seat_num") - row.getInt("reserved_num") %></em>)</span>
                            </label>
                        </div>
<%
        previousExpTypeNm = currentExpTypeNm; // 현재 체험 유형을 이전 체험 유형으로 설정
    }
    // 리스트가 비어있지 않은 경우 마지막 아이템의 닫기 태그 추가
    if (previousExpTypeNm != null) {
%>
                    </div>
                </div>
            </li>
<%
    }
%>
</ul>
