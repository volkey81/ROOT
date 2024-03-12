package com.sanghafarm.utils;

import javax.servlet.jsp.JspWriter;

import com.efusioni.stone.utils.Paging;
import com.efusioni.stone.utils.Utils;

/**
 * 페이징 삽입을 위한 클래스
 */
public class MobilePaging extends Paging {  
	public MobilePaging(String url, int totalRows, int currentPage,	int pageSize, int blockSize) {
		super(url, totalRows, currentPage, pageSize, blockSize);
	}

	public void writeTo(JspWriter out) throws Exception {
        StringBuffer buf = new StringBuffer();

        if(needPrevBlockAction) {
			buf.append("<li><a href=\"" + pageURL(nStartPage - nBlockSize) + "\"><img src=\"/mobile/images/btn/btn_pgPrev2.gif\" alt=\"이전 10페이지\"></a></li>\n");
        }
        else {
			buf.append("<li><a href=\"#none\"><img src=\"/mobile/images/btn/btn_pgPrev2.gif\" alt=\"이전 10페이지\"></a></li>\n");
        }
        
        if(needPrevPageAction) {
        	buf.append("<li class=\"btnL\"><a href=\"" + pageURL(nCurrentPage - 1) + "\"><img src=\"/mobile/images/btn/btn_pgPrev.gif\" alt=\"이전 페이지\"></a></li>\n");
        }
        else {
        	buf.append("<li class=\"btnL\"><a href=\"#none\"><img src=\"/mobile/images/btn/btn_pgPrev.gif\" alt=\"이전 페이지\"></a></li>\n");
        }

        for(int i = 0; i < nBlockSize; i++) {
            int n = i + nStartPage;

            if (n <= nTotalPages) {
                if (n == nCurrentPage) {
                    buf.append("<li><strong>" + n + "</strong></li>\n");
                }
                else {
                	buf.append("<li><a href=\"" + pageURL(n) + "\">" + n + "</a></li>\n");
                }
            } else break;
        }

        if(needNextPageAction) {
        	buf.append("<li class=\"btnR\"><a href=\"" + pageURL(nCurrentPage + 1) + "\"><img src=\"/mobile/images/btn/btn_pgNext.gif\" alt=\"다음 페이지\"></a></li>\n");
        }
        else {
        	buf.append("<li class=\"btnR\"><a href=\"#none\"><img src=\"/mobile/images/btn/btn_pgNext.gif\" alt=\"다음 페이지\"></a></li>\n");
        }

        if(needNextBlockAction) {
        	buf.append("<li><a href=\"" + pageURL(nStartPage + nBlockSize) + "\"><img src=\"/mobile/images/btn/btn_pgNext2.gif\" alt=\"다음 10페이지\"></a></li>\n");
        }
        else {
        	buf.append("<li><a href=\"#none\"><img src=\"/mobile/images/btn/btn_pgNext2.gif\" alt=\"다음 10페이지\"></a></li>\n");
        }
        out.println(buf);
	}
	public void writeToShop(JspWriter out) throws Exception {
        StringBuffer buf = new StringBuffer();

        if(needPrevBlockAction) {
			buf.append("<li class=\"btnL2\"><a href=\"" + pageURL(nStartPage - nBlockSize) + "\"></a></li>\n");
        }
        else {
			buf.append("<li class=\"btnL2\"><a href=\"#none\"></a></li>\n");
        }
        
        if(needPrevPageAction) {
        	buf.append("<li class=\"btnL\"><a href=\"" + pageURL(nCurrentPage - 1) + "\"></a></li>\n");
        }
        else {
        	buf.append("<li class=\"btnL\"><a href=\"#none\"></a></li>\n");
        }

        for(int i = 0; i < nBlockSize; i++) {
            int n = i + nStartPage;

            if (n <= nTotalPages) {
                if (n == nCurrentPage) {
                    buf.append("<li><strong>" + n + "</strong></li>\n");
                }
                else {
                	buf.append("<li><a href=\"" + pageURL(n) + "\">" + n + "</a></li>\n");
                }
            } else break;
        }

        if(needNextPageAction) {
        	buf.append("<li class=\"btnR\"><a href=\"" + pageURL(nCurrentPage + 1) + "\"></a></li>\n");
        }
        else {
        	buf.append("<li class=\"btnR\"><a href=\"#none\"></a></li>\n");
        }

        if(needNextBlockAction) {
        	buf.append("<li class=\"btnR2\"><a href=\"" + pageURL(nStartPage + nBlockSize) + "\"></a></li>\n");
        }
        else {
        	buf.append("<li class=\"btnR2\"><a href=\"#none\"></a></li>\n");
        }
        out.println(buf);
	}
	
	/**
     * HTML 페이지에 삽입해야할 페이징부분의 HTML소스를 반환한다.<br>
     * 상속클래스에서 구체화된다.
     *
     */
    private String pageURL(int page){
		String pageURL = sURL;
        if (sURL.indexOf("javascript") > -1){
        	pageURL = Utils.replace(pageURL, "[page]", String.valueOf(page));
        }else{
        	pageURL = getReturnURL(page);
        }
        
        return pageURL;
	}    
    
}
