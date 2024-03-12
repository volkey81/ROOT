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

public class ReviewService extends IbatisService {
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
		String subPath = Config.get("review.image.path") + Utils.getTimeStampString(new Date(), "yyyyMM") + "/";

		upload.setUploadPath(uploadPath + subPath);
		upload.setAcceptableExt(ACCEPTABLE_FILE_EXT);
		upload.setNotAcceptableExt(NOT_ACCEPTABLE_EXT);
		System.out.println("========>" + upload.getFileCount());
		for(int i = 0; i < upload.getFileCount(); i++) {
			String newFileName = StringUtils.EMPTY;
			if(!upload.isMissing(i)) {
				if(upload.getFileSize(i) > fileUploadLimit){
					throw new FileUploaderException("최대 업로드파일용량은 " + fileUploadLimit + "MB 입니다.", FileUploaderException.TOO_LARGE_SIZE);
				}
				
				String fieldName = upload.getFieldName(i);
				
				newFileName = fieldName + "_" + System.currentTimeMillis() + "." + upload.getFileExt(i);
				upload.write(fieldName, newFileName);					
				param.set(fieldName, Config.get("image.path") + subPath + newFileName);
			} else {
				if (StringUtils.equals(param.get("APP_YN"), "Y")) {
					newFileName = param.get("imgName1");
					if (StringUtils.isNotEmpty(newFileName)) {
						param.set("img1", Config.get("image.path") + subPath + newFileName);
					}
					newFileName = param.get("imgName2");
					if (StringUtils.isNotEmpty(newFileName)) {
						param.set("img2", Config.get("image.path") + subPath + newFileName);
					}
				}
			}
			
		}
		super._insert("Review.insert", param);
	}
	
	public void modify(FileUploader upload) {
		Param param = new Param(upload);
		//파일업로드
		long fileUploadLimit 	= 10 * 1024 * 1024;			// 파일의 최대 사이즈	
		String uploadPath = Env.getUploadPath();
		String subPath = Config.get("review.image.path") + Utils.getTimeStampString(new Date(), "yyyyMM") + "/";

		upload.setUploadPath(uploadPath + subPath);
		upload.setAcceptableExt(ACCEPTABLE_FILE_EXT);
		upload.setNotAcceptableExt(NOT_ACCEPTABLE_EXT);
		String newFileName = StringUtils.EMPTY;
		for(int i = 0; i < upload.getFileCount(); i++) {
			String fieldName = upload.getFieldName(i);
			if(!upload.isMissing(i)) {
				if(upload.getFileSize(i) > fileUploadLimit){
					throw new FileUploaderException("최대 업로드파일용량은 " + fileUploadLimit + "MB 입니다.", FileUploaderException.TOO_LARGE_SIZE);
				}
				
				
				newFileName = fieldName + "_" + System.currentTimeMillis() + "." + upload.getFileExt(i);
				upload.write(fieldName, newFileName);					
				param.set(fieldName, Config.get("image.path") + subPath + newFileName);
			} else {
				if (StringUtils.equals(param.get("APP_YN"), "Y")) {
					newFileName = param.get("imgName1");
					if (StringUtils.isNotEmpty(newFileName)) {
						param.set("img1", Config.get("image.path") + subPath + newFileName);
					} else {
						param.set("img1", param.get("img1_org"));
					}
					newFileName = param.get("imgName2");
					if (StringUtils.isNotEmpty(newFileName)) {
						param.set("img2", Config.get("image.path") + subPath + newFileName);
					} else {
						param.set("img2", param.get("img2_org"));
					}
				} else {
					param.set(fieldName, param.get(fieldName + "_org"));
				}
			}
		}
		
		
		super._update("Review.update", param);
	}
	
	public void remove(Param param) {
		super._update("Review.delete", param);
	}
	
	public Integer getListCount(Param param) {
		return (Integer)super._scalar("Review.getListCount", param);
	}

	public List<Param> getList(Param param) {
		return super._list("Review.getList", param);
	}

	public Param getInfo(Param param) {
		return super._row("Review.getInfo", param);
	}
	
	public Integer getProductScore(String pid) {
		return (Integer) super._scalar("Review.getProductScore", pid);
	}
	
	public List<Param> isReviewWrited(Param param) {
		return super._list("Review.isReviewWrited", param);
	}
	
	public Param getReviewSummary(String pid) {
		return super._row("Review.getReviewSummary", pid);
	}

	public Integer getWriteCount(String userid) {
		return (Integer) super._scalar("Review.getWriteCount", userid);
	}
	
	public Integer getImageCount(String pid) {
		return (Integer) super._scalar("Review.getImageCount", pid);
	}
	
	public List<Param> getImageList(Param param) {
		return super._list("Review.getImageList", param);
	}
}
