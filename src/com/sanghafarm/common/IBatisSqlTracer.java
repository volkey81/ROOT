package com.sanghafarm.common;

import javax.servlet.http.HttpServletRequest;

import com.efusioni.stone.utils.Param;
import com.sanghafarm.service.common.SqlTraceService;

public class IBatisSqlTracer implements com.efusioni.stone.ibatis.IBatisSqlTracer {
	public void trace(String ibatisKey, 
					  Object ibatisParam, 
					  String executedSql,
					  String bindParams, 
					  String bindTypes) {
		
//		System.out.println("====================================== IBatisSqlTracer =============================");
		SqlTraceService svc = (new SqlTraceService()).toProxyInstance();
		HttpServletRequest request = null;
		
		if (ibatisParam instanceof Param) {
			request = ((Param)ibatisParam).getServletRequest();
		}

		svc.trace(
			new Param(
				"sessionid", request == null ? "" : cut(request.getSession().getId(), 200),
				"uri", request == null ? "" : cut(request.getRequestURI(), 255),
				"ip", request == null ? "" : request.getRemoteAddr(),
				"user_agent", request == null ? "" : cut(request.getHeader("user-agent"), 200),
				"cookie", request == null ? "" : cut(request.getHeader("cookie").replaceAll("p=[a-zA-Z0-9\\%\\/=\\|]*;\\s*", ""), 4000),
				"ibatis_key", cut(ibatisKey, 100),
				"ibatis_param", ibatisParam.toString(),
				"sql", executedSql,
				"bind_param", bindParams,
				"bind_type", cut(bindTypes, 1000)
			)
		);
	}
	
	private String cut(String str, int length) {
		if (str.length() > length) {
			return str.substring(0, length);
		}
		else return str;
	}
}
