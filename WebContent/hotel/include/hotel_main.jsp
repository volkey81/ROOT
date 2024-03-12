<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.service.hotel.*" %>
<% 
	Param param = new Param(request);
	String position = param.get("position");
	
	HotelMainService svc = (new HotelMainService()).toProxyInstance();
	
	param.set("POS_STA", "0");
	List<Param> list = svc.getList(param);
	
	if("001".equals(position)) {
		for(Param row : list) {
%>
			<div class="visual">
<%
			if(!"".equals(row.get("banner_movie"))) {
%>
				<video width="100%" height="100%" poster="<%-- <%= row.get("banner_img") %> --%>" muted="muted" class="sort">
				  <source src="<%= row.get("banner_movie") %>" type='video/<%= row.get("banner_movie").substring(row.get("banner_movie").lastIndexOf(".") + 1) %>' />
				</video>
<%
			} else {
%>
				<a href="<%= row.get("link") %>" class="sort"><img src="<%= row.get("banner_img") %>" alt=""></a>
<%
			}
%>
			</div>
<%
		}
	} else if("002,003,004".indexOf(position) != -1) {
		int i = 1;
		for(Param row : list) {
			String n = i < 10 ? "0" + i : "" + i;
			i++;
%>
						<li class="swiper-slide" num="<%= n %>">
							<div class="bg">
								<img src="<%= row.get("banner_img") %>" alt="">
							</div>
							<div class="galleryName ico01" >
<%
			if(!"".equals(row.get("link"))){
%>
								<a href="<%= row.get("link") %>" target="<%= row.get("target") %>"><%= row.get("title") %>
									<span><img src="<%= row.get("icon") %>" alt=""></span>
								</a>
<%
			} else {
%>
								<a href="#none" onclick="return false"><%= row.get("title") %>
									<span><img src="<%= row.get("icon") %>" alt=""></span>
								</a>
<%
			}
%>
							</div>
							<p class="sTxt"><%= row.get("sub_title") %></p>
						</li>
<%
		}
	} else if("005,006,007".indexOf(position) != -1) {
		for(Param row : list) {
%>
				<li><a href="<%= row.get("link") %>" target="<%= row.get("target") %>"><p><img src="<%= row.get("banner_img") %>" alt=""></p>
						<dl>
							<dt><%= row.get("title") %></dt>
							<dd><%= row.get("sub_title") %></dd>
						</dl>
						<span><img src="<%= row.get("icon") %>" alt=""></span>
					</a>
				</li>
<%
		}
	} else if("008".equals(position)) {
		for(Param row : list) {
%>
				<li class="swiper-slide"><img src="<%= row.get("banner_img") %>" alt=""></li>
<%
		}
	} else if("009,010,011".indexOf(position) != -1) {
		int i = 1;
		for(Param row : list) {
			String n = i < 10 ? "0" + i : "" + i;
			i++;
%>
						<%-- <li class="swiper-slide slide" num="<%= n %>"><img src="<%= row.get("banner_img") %>" alt=""></li>  --%>
						<li class="swiper-slide" num="<%= n %>">
							<a href="<%= row.get("link") %>" target="<%= row.get("target") %>">
								<div class="bg">
									<img src="<%= row.get("banner_img") %>" alt="">
								</div>
								<div class="galleryName ico01" >
									<span class="tit"><%= row.get("title") %></span>
									<span class="ico"><img src="<%= row.get("icon") %>" alt=""></span>
								</div>
							</a>
							<%-- <p class="sTxt"><%= row.get("sub_title") %></p> --%>
						</li>
		
<%
		}
	} else if("012,013,014".indexOf(position) != -1) {
		for(Param row : list) {
%>
				<li><a href="<%= row.get("link") %>" target="<%= row.get("target") %>"><img src="<%= row.get("banner_img") %>" alt="">
					<div class="txtArea">
						<dl>
							<dt><%= row.get("title") %></dt>
							<dd><%= row.get("sub_title") %></dd>
						</dl>
						<span class="ico"><img src="<%= row.get("icon") %>" alt=""></span>
					</div>
				</a></li>
<%
		}
	}
%>