<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.exception.*,
				 com.sanghafarm.service.member.*" %>
<%
	Param param = new Param(request);
	FrontSession fs = FrontSession.getInstance(request, response);
	AddrBookService addr = (new AddrBookService()).toProxyInstance();
	
	boolean result = false;
	String msg = "";
	String mode = param.get("mode");
	String name = "";
	String postNo = "";
	String addr1 = "";
	String addr2 = "";
	String mobile1 = "";
	String mobile2 = "";
	String mobile3 = "";
	String tel1 = "";
	String tel2 = "";
	String tel3 = "";
	
	param.set("userid", fs.getUserId());
	
	if(!fs.isLogin()) {
		msg = "로그인이 필요합니다.";
	} else if("COPY".equals(mode) || "CREATE".equals(mode)) {
		param.set("userid", fs.getUserId());
		addr.create(param);
		msg = "등록되었습니다.";
		result = true;
	} else if("MODIFY".equals(mode)) {
		param.set("userid", fs.getUserId());
		addr.modify(param);
		msg = "수정되었습니다.";
		result = true;
	} else if("REMOVE".equals(mode)) {
		param.set("userid", fs.getUserId());
		addr.remove(param);
		msg = "삭졔되었습니다.";
		result = true;
	} else if("DEFAULT".equals(mode)) {
		param.set("userid", fs.getUserId());
		addr.modifyDefault(param);
		msg = "변경되었습니다.";
		result = true;
	} else if("SET_DEFAULT".equals(mode)) {
		Param info = addr.getDefaultInfo(fs.getUserId());
		if(info == null) info = new Param();
		name = info.get("name");
		postNo = info.get("post_no");
		addr1 = info.get("addr1");
		addr2 = info.get("addr2");
		mobile1 = info.get("mobile1");
		mobile2 = info.get("mobile2");
		mobile3 = info.get("mobile3");
		tel1 = info.get("tel1");
		tel2 = info.get("tel2");
		tel3 = info.get("tel3");
		result = true;
	} else if("SET_LATEST".equals(mode)) {
		Param info = addr.getLatestInfo(fs.getUserId());
		if(info == null) info = new Param();
		name = info.get("ship_name");
		postNo = info.get("ship_post_no");
		addr1 = info.get("ship_addr1");
		addr2 = info.get("ship_addr2");
		mobile1 = info.get("ship_mobile1");
		mobile2 = info.get("ship_mobile2");
		mobile3 = info.get("ship_mobile3");
		tel1 = info.get("ship_tel1");
		tel2 = info.get("ship_tel2");
		tel3 = info.get("ship_tel3");
		result = true;
	}
%>
{
	"result" : <%= result %>,
	"msg" : "<%= msg %>",
	"name" : "<%= name %>",
	"post_no" : "<%= postNo %>",
	"addr1" : "<%= addr1 %>",
	"addr2" : "<%= addr2 %>",
	"mobile1" : "<%= mobile1 %>",
	"mobile2" : "<%= mobile2 %>",
	"mobile3" : "<%= mobile3 %>",
	"tel1" : "<%= tel1 %>",
	"tel2" : "<%= tel2 %>",
	"tel3" : "<%= tel3 %>"
}
