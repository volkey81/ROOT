package com.sanghafarm.utils;

import java.io.File;
import java.io.FileOutputStream;

import com.efusioni.stone.common.Config;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.oned.Code128Writer;
import com.sanghafarm.common.Env;

public class Barcode {
	public String getBarcode(String code) {
		return getBarcode(code, 220, 71);
	}
	
	public String getBarcode(String code, int width, int height) {
		try {
			File file = new File(Env.getUploadPath() + Config.get("barcode.path") + code + ".png");
			if(!file.exists()) {
				file = new File(Env.getUploadPath() + Config.get("barcode.path"));
				if(!file.exists()) {
					file.mkdir();
				}
				
				Code128Writer writer = new Code128Writer();
				BitMatrix matrix = writer.encode(code, BarcodeFormat.CODE_128, width, height);
				FileOutputStream os = new FileOutputStream(new File(Env.getUploadPath() + Config.get("barcode.path") + "/" + code + ".png"));
				MatrixToImageWriter.writeToStream(matrix, "png", os);
				os.flush();
				os.close();
			}
		} catch(Exception e) {
			
		}
		
		return Config.get("image.path") + Config.get("barcode.path") + code + ".png";
	}

}
