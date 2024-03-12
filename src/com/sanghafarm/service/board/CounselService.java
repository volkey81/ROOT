package com.sanghafarm.service.board;

import java.util.Date;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.efusioni.stone.common.Config;
import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.FileUploader;
import com.efusioni.stone.utils.FileUploaderException;
import com.efusioni.stone.utils.Param;
import com.efusioni.stone.utils.Utils;
import com.sanghafarm.common.Env;

public class CounselService extends IbatisService {
	
	private static String[] NOT_ACCEPTABLE_EXT = {
			"html", "htm", "js", "css", "jsp", "exe", "bat", "sh"
	};

	private static String[] ACCEPTABLE_FILE_EXT = {
		"jpg", "jpeg", "gif", "png"
	};
	
	public void create(FileUploader upload) {
		Param param = new Param(upload);
		// 파일업로드
		long fileUploadLimit 	= 10 * 1024 * 1024;			// 파일의 최대 사이즈	
		String uploadPath = Env.getUploadPath();
		String subPath = Config.get("counsel.image.path") + Utils.getTimeStampString(new Date(), "yyyyMM") + "/";

		upload.setUploadPath(uploadPath + subPath);
		upload.setAcceptableExt(ACCEPTABLE_FILE_EXT);
		upload.setNotAcceptableExt(NOT_ACCEPTABLE_EXT);

		for(int i = 0; i < upload.getFileCount(); i++) {
			String fieldName = upload.getFieldName(i);
			String newFileName = StringUtils.EMPTY;
			if(!upload.isMissing(i)) {
				if(upload.getFileSize(i) > fileUploadLimit){
					throw new FileUploaderException("최대 업로드파일용량은 " + fileUploadLimit + "MB 입니다.", FileUploaderException.TOO_LARGE_SIZE);
				}
				
				newFileName = fieldName + "_" + System.currentTimeMillis() + "." + upload.getFileExt(i);
				upload.write(fieldName, newFileName);
				param.set(fieldName, Config.get("image.path") + subPath + newFileName);
			} else {
				if (StringUtils.equals(param.get("APP_YN"), "Y")) {
					newFileName = param.get(fieldName + "_app");
					if (StringUtils.isNotEmpty(newFileName)) {
						param.set(fieldName, Config.get("image.path") + subPath + newFileName);
					}
				}
			}
		}
		
		super._insert("Counsel.insert", param);
	}
	
	public Integer getListCount(Param param) {
		return (Integer)super._scalar("Counsel.getListCount", param);
	}

	public List<Param> getList(Param param) {
		return super._list("Counsel.getList", param);
	}
}
