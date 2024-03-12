package com.sanghafarm.common;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet Filter implementation class PreFilter
 */
public class PreFilter implements Filter {

    /**
     * Default constructor. 
     */
    public PreFilter() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see Filter#destroy()
	 */
	public void destroy() {
		// TODO Auto-generated method stub
	}

	/**
	 * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse res = (HttpServletResponse) response;

		String url = req.getRequestURI();
		String ret = "/servicestop.jsp";
		if(!url.equals(ret)) {
			String ip = req.getRemoteAddr();
			
			if(!checkIp(ip)) {
				System.out.println(String.format("------------- PreFilter : %s, %s", url, ip));
				res.sendRedirect(ret);
				return;
			}
		}
		
		chain.doFilter(request, response);
	}

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {
		// TODO Auto-generated method stub
	}

	public boolean checkIp(String ip) {
		/*
		String[] ips = { 
				"127.0.0.1"
				, "1.235.120."
		};
		
		for(String s : ips) {
			if(ip.startsWith(s)) return true;
		}
		
		return false;
		*/
		
		return true;
	}
}
