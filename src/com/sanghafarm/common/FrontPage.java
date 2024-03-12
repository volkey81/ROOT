package com.sanghafarm.common;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sanghafarm.exception.NotAuthorizedError;

public class FrontPage {
	HttpServletRequest request = null;
	HttpServletResponse response = null;
	FrontSession frontSession = null;
	int lSeq, mSeq, sSeq;
	
	public FrontPage(HttpServletRequest req, HttpServletResponse res) {
		request = req;
		response = res;
		frontSession = FrontSession.getInstance(req, res);
	}
	
	public static FrontPage getInstance(HttpServletRequest req, HttpServletResponse res) {
		return new FrontPage(req, res);
	}
	
	public void setLocation(int l, int m, int s) {
		request.setAttribute("l_seq", l);
		request.setAttribute("m_seq", m);
		request.setAttribute("s_seq", s);
	}
	
	public void setRequireAuth(boolean requireAuth) {
		if (requireAuth) {
			if (!frontSession.isLogin()) {
				throw new NotAuthorizedError();
			}
		}
	}
	
	public int getLSeq() {
		return (Integer)request.getAttribute("l_seq");
	}

	public int getMSeq() {
		return (Integer)request.getAttribute("m_seq");
	}

	public int getSSeq() {
		return (Integer)request.getAttribute("s_seq");
	}

	public String[] getPath() {
		return null;
	}
	
	public FrontSession getSession() {
		return frontSession;
	}
	
	public boolean checkLogin() throws Exception {
		return checkLogin("", "");
	}
	
	public boolean checkLogin(String returnUrl) throws Exception {
		return checkLogin(returnUrl, "");
	}
	
	public boolean checkLogin(String returnUrl, String prefix) throws Exception {
		if(!frontSession.isLogin()) {
			String loginUrl = prefix + "/member/login.jsp";
			StringBuffer buff = new StringBuffer();
			buff.append("<script type=\"text/javascript\">\n")
				.append("alert(\"로그인이 필요합니다\\n로그인 페이지로 이동합니다.\");\n")
				.append("document.location.href=\"" + loginUrl + "?returnURL=" + returnUrl + "\";\n")
				.append("</script>\n");
			response.getWriter().println(buff.toString());
			return false;
		} else {
			return true;
		}
	}
	
	public boolean checkMobileLogin() throws Exception {
		return checkMobileLogin("", "");
	}
	
	public boolean checkMobileLogin(String returnUrl) throws Exception {
		return checkMobileLogin(returnUrl, "");
	}
	
	public boolean checkMobileLogin(String returnUrl, String prefix) throws Exception {
		if(!frontSession.isLogin()) {
			String loginUrl = prefix + "/m/member/login.jsp";
			StringBuffer buff = new StringBuffer();
			buff.append("<script type=\"text/javascript\">\n")
				.append("alert(\"로그인이 필요합니다\\n로그인 페이지로 이동합니다.\");\n")
				.append("document.location.href=\"" + loginUrl + "?returnURL=" + returnUrl + "\";\n")
				.append("</script>\n");
			response.getWriter().println(buff.toString());
			return false;
		} else {
			return true;
		}
	}

	public void setTitle(String title) {
		request.setAttribute("title", title);
	}

	public String getTitle() {
		return (String)request.getAttribute("title");
	}
}
