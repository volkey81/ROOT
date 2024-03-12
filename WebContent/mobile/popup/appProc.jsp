<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="org.apache.commons.codec.binary.*"%>
<%@page import="com.sanghafarm.common.Env"%>
<%@page import="java.security.SecureRandom"%>
<%@ page contentType="text/html; charset=UTF-8" errorPage="/m/brand/error/error.jsp"%>
<%@ page import="java.util.*,
				 java.io.*,
     			 javax.imageio.ImageIO,
				 java.awt.image.BufferedImage,
				 org.apache.commons.codec.binary.Base64, 
				 com.efusioni.stone.utils.*,
				 com.efusioni.stone.exception.*,
				 com.efusioni.stone.common.Config" %>
			 
<%

	Param param = new Param(request);

	String uploadPath 	= Env.getUploadPath();
	String subPath 		= StringUtils.EMPTY;
	String savePath 	= StringUtils.EMPTY;
	String newFileName 	= StringUtils.EMPTY;
	
	//BASE64Decoder decoder = new BASE64Decoder();
	
	String orgName = Utils.safeHTML(param.get("orgName"));
	String ext = orgName.substring(orgName.lastIndexOf(".") + 1);
	
	boolean isOk = true;
	String msg   = StringUtils.EMPTY;
	if (StringUtils.equals("01", Utils.safeHTML(param.get("board")))) {
		subPath = Config.get("review.image.path") + Utils.getTimeStampString(new Date(), "yyyyMM") + "/";
	} else if (StringUtils.equals("02", Utils.safeHTML(param.get("board")))) {
		subPath = Config.get("counsel.image.path") + Utils.getTimeStampString(new Date(), "yyyyMM") + "/";
	}
	savePath = uploadPath + subPath;
	if(StringUtils.isNotEmpty(savePath)){
		File outputFile = new File(savePath);			        
		if(!outputFile.isDirectory())
			outputFile.mkdirs();
		try {	
// 			byte[] bt = decoder.decodeBuffer(Utils.safeHTML(param.get("image")));	
			byte[] bt = Base64.decodeBase64(Utils.safeHTML(param.get("image")));	
			
			if(bt != null){
				BufferedImage im = ImageIO.read(new ByteArrayInputStream(bt));
				
				String 	sTime 		= Utils.getTimeStampString("yyyyMMddHHmmSSss");
		
				newFileName = sTime + "." + ext;
				System.out.println("------------- appProc.jsp new file name : " + savePath + newFileName);
				ImageIO.write(im, ext, new File(savePath + newFileName));
				System.out.println("------------- appProc.jsp new file name : " + newFileName + " saved!!");
			}	
	
		} catch (Exception e) {
			e.printStackTrace();
			isOk = false;
			msg = "파일업로드중 오류가 발생했습니다.";
		}
	}else{
		isOk = false;
		msg = "잘못된 접근입니다.";				
	}
	System.out.println("------------- appProc.jsp result : " + isOk + ", " + msg);
%>
{"isOk" : "<%=isOk %>", "msg" : "<%=msg %>", "imagename" : "<%=newFileName %>"}