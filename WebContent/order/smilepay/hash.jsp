<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			java.security.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.utils.*,
			com.google.gson.*"%>
<%
	Param param = new Param(request);

	Param result = null;
	
	try{
		String md_src = param.get("edi_date") + SmilepayUtil.MID + param.get("amt");
		String hash_String  = SmilepayUtil.SHA256Salt(md_src, SmilepayUtil.ENCODE_KEY);

		result = new Param("result", true, "hash", hash_String);
	}
	catch (Exception e) {
		e.printStackTrace();
		result = new Param("result", false, "hash", "");
	}

	session.setAttribute("DB_AMOUNT", param.get("amt"));

	Gson gson = new Gson();
	out.print(gson.toJson(result));
%>