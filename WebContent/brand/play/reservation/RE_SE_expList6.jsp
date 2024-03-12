<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.service.board.*" %>
<%
	request.setAttribute("Depth_1", new Integer(1));
	request.setAttribute("Depth_2", new Integer(3));
	request.setAttribute("Depth_3", new Integer(2));
	request.setAttribute("MENU_TITLE", new String("체험교실"));
	
	Param param = new Param(request);
	ExpContentService svc = new ExpContentService();

	if("".equals(param.get("seq"))) {
		Utils.sendMessage(out, "잘못된 경로로 접근하였습니다.");
		return;
	}
	
	Param info = svc.getInfo(param.get("seq"));
	List<Param> areaList = svc.getAreaList(param.get("seq"));
%>
					<p class="exp_label"><span><img src="/images/brand/play/img_tag0<%= info.getInt("exp_gb") %>.jpg" alt="카테고리"></span></p>
                        <b class="exp_title"><%= info.get("exp_type_nm") %></b>
                        <p class="exp_des"><%= info.get("summary") %></p>
                        <p class="divLine mt20 mb20"></p>
                        <div class="exp_content f_g">
                            <div class="fl">
                                <ul class="exp_detail">
                                    <li>
                                        <strong>체험영역</strong>
                                     
                                        <%
	for(Param row : areaList) {
		if("".equals(row.get("area"))) {
%>
								<span><%= row.get("name2") %></span>
<%
		} else {
%>
								<span class="tag_item"><%= row.get("name2") %></span>
<%
		}
	}
%>
                                    </li>
                                    <li>
                                        <strong>체험 계절</strong>
                                        <p><%= Utils.safeHTML(info.get("season")) %></p>
                                    </li>
                                    <li>
                                        <strong>체험 시간</strong>
                                        <p><%= Utils.safeHTML(info.get("time")) %></p>
                                    </li>
                                    <li>
                                        <strong>적정 연령</strong>
                                        <p><%= Utils.safeHTML(info.get("age")) %></p>
                                    </li>
                                    <li>
                                        <strong>보호자 동반</strong>
                                        <p>보호자 <%= "N".equals(info.get("protector_yn")) ? "미" : "" %>동반</p>
                                    </li>
                                    <li>
                                        <strong>알레르기 유발성분</strong>
                                        <p><%= Utils.safeHTML(info.get("alergy")) %></p>
                                    </li>
                                </ul>
                            </div>
                            <div class="fr">
                                <img src="<%= info.get("image") %>" alt="">
                            </div>
                        </div>