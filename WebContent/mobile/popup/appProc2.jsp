<%@ page contentType="text/html; charset=UTF-8" errorPage="/m/brand/error/error.jsp"
	import="java.util.*,
			com.efusioni.stone.common.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			org.apache.commons.lang.*" %>
			 
<%
	FileUploader upload = new FileUploader(request, "", 25 * 1024 * 1024);
	Param param = new Param(upload); 

	String[] ACCEPTABLE_FILE_EXT = {
			"jpg", "jpeg", "gif", "png", "heic"
		};
	
	long fileUploadLimit 	= 10 * 1024 * 1024;			// 파일의 최대 사이즈	
	String uploadPath = Env.getUploadPath();
	String subPath = StringUtils.EMPTY;
	String newFileName 	= StringUtils.EMPTY;

	if (StringUtils.equals("01", Utils.safeHTML(param.get("board")))) {
		subPath = Config.get("review.image.path") + Utils.getTimeStampString(new Date(), "yyyyMM") + "/";
	} else if (StringUtils.equals("02", Utils.safeHTML(param.get("board")))) {
		subPath = Config.get("counsel.image.path") + Utils.getTimeStampString(new Date(), "yyyyMM") + "/";
	}

	boolean isOk = true;
	String msg   = StringUtils.EMPTY;

	try {
		upload.setUploadPath(uploadPath + subPath);
		upload.setAcceptableExt(ACCEPTABLE_FILE_EXT);
		
		if(upload.getFileSize("image") > fileUploadLimit){
			throw new FileUploaderException("최대 업로드파일용량은 " + fileUploadLimit + "MB 입니다.", FileUploaderException.TOO_LARGE_SIZE);
		}
		
		newFileName = Utils.getTimeStampString("yyyyMMddHHmmSSss") + "." + upload.getFileExt("image");
		upload.write("image", newFileName);
		param.set("image", Config.get("image.path") + subPath + newFileName);

	} catch(Exception e) {
		e.printStackTrace();
		
		isOk = false;
		msg = e.getMessage();
	}

	System.out.println("------------- appProc2.jsp result : " + newFileName + ", " + isOk + ", " + msg);
%>
{"isOk" : "<%=isOk %>", "msg" : "<%=msg %>", "imagename" : "<%=newFileName %>"}