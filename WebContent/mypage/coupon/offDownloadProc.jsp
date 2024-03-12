<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.service.order.*" %>
<%
	boolean result = false;
	String msg = null;

	FrontSession fs = FrontSession.getInstance(request, response);
	if(!fs.isLogin()) {
		msg = FrontSession.LOGIN_MSG;
	} else {
		Param param = new Param(request);
		param.set("userid", fs.getUserId());
		param.set("grade_code", fs.getGradeCode());
		param.set("unfy_mmb_no", fs.getUserNo());
		
		OffCouponService svc = (new OffCouponService()).toProxyInstance();
		
		if("all".equals(param.get("couponid"))) {
			List<Param> list = svc.getDownloadableList(param);
			int i = 0;
			for(Param row : list) {
				if(row.getInt("mem_down_cnt") < row.getInt("max_download") && (row.getInt("tot_down_cnt") < row.getInt("max_issue") || row.getInt("max_issue") == 0)) {
					row.set("userid", fs.getUserId());
					svc.createMemCoupon(row);
					i++;
				}
				
				result = true;
				msg = i + "개의 쿠폰이 다운되었습니다.";
			}
			if ( i == 0 ) {
				msg = "다운로드 받을 쿠폰이 없습니다.";
			}
		} else {
			Param info = svc.getDownloadableInfo(param);
			if(info == null || "".equals(info.get("couponid"))) {
				msg = "잘못된 접근입니다.";
			} else if(info.getInt("max_issue") > 0 && info.getInt("max_issue") <= info.getInt("tot_down_cnt")) {
				msg = "마감되었습니다.";
			} else if(info.getInt("max_download") <= info.getInt("mem_down_cnt")) {
				msg = "이미 다운받으셨습니다.";
			} else {
				svc.createMemCoupon(param);
				result = true;
				msg = "다운되었습니다.";
			}
		}
	}
%>
{"result" : <%= result %>, "msg" : "<%=msg %>"}