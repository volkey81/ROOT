package com.sanghafarm.servlet.im;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

import com.efusioni.stone.common.SystemChecker;
import com.sanghafarm.service.member.ImMemberService;

public class RXISDisagreeAvailableSST extends HttpServlet {

	private static final long serialVersionUID = 5338233090998681129L;
	
	private Logger logger = Logger.getLogger(this.getClass());
	
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
	}
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setCharacterEncoding("utf-8");
		PrintWriter out = response.getWriter();
		
		logger.info("============= RXISDisagreeAvailableSST");
		
//		Param param = new Param(request);
//		String jsonStr = SystemChecker.getCurrent() == SystemChecker.LOCAL ? getSampleJson() : URLDecoder.decode(param.get("params").trim(), "utf-8");
		String jsonStr = SystemChecker.getCurrent() == SystemChecker.LOCAL ? getSampleJson() : request.getParameter("params").trim();
		JSONObject json = (JSONObject)JSONValue.parse(jsonStr);
		
		ImMemberService svc = (new ImMemberService()).toProxyInstance();
		
		JSONObject result = svc.isRemovable(this.getClass().getSimpleName(), json);
		
		out.println(result.toJSONString());
	}

	private String getSampleJson() {
		String s = "{\"TRS_NO\":\"70002016100717235306727\",\"SST_CD\":\"7040\",\"OPN_MD\":\"test\",\"IM_SBC\":{\"UNFY_MMB_NO\":\"1000000001\",\"COOPCO_CD\":\"7000\"}}";
		return s;
	}
}
