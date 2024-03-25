package com.sanghafarm.utils;

import java.util.Base64;
import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import javax.crypto.spec.IvParameterSpec;
import java.security.Security;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class kbPayUtil {

    private static final String ENCRYPTION_KEY = "6KqZs3sjyyuFcONy9GOrnA=="; //Seedkey
    private static final String ENCRYPTION_IV = "STDP185861074960"; //SeeIV
    private static final String kbpayHashKey = "F3149950A7B6289723F325833F581858";
    private static final String corpNo= "1858";
    private static final String mertNo= "1858-00001";
    private static final String kbPayBaseUrl = "https://dev-stdpay.kbstar.com/std";
    
    public static String getKbpaybaseurl() {
		return kbPayBaseUrl;
	}

	public static String getCorpNo() {
        return corpNo;
    }

    public static String getMertNo() {
        return mertNo;
    }

    public static String getKbpayHashKey() {
        return kbpayHashKey;
    }
    
    

    static {
        Security.addProvider(new BouncyCastleProvider());
    }

    public static String encrypt(String input) throws Exception {
        Cipher cipher = Cipher.getInstance("SEED/CBC/PKCS5Padding", "BC");
        byte[] key = Base64.getDecoder().decode(ENCRYPTION_KEY);
        byte[] iv = ENCRYPTION_IV.getBytes("UTF-8");

        SecretKeySpec secretKeySpec = new SecretKeySpec(key, "SEED");
        IvParameterSpec ivParameterSpec = new IvParameterSpec(iv);

        cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec, ivParameterSpec);
        byte[] encrypted = cipher.doFinal(input.getBytes("UTF-8"));
        return Base64.getEncoder().encodeToString(encrypted);
    }
    
    public static String toHexString(byte[] hash) {
        StringBuilder hexString = new StringBuilder(2 * hash.length);
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if(hex.length() == 1) hexString.append('0');
            hexString.append(hex);
        }
        return hexString.toString();
    }

    public static String generateSignature(String corpMemberNo, String userMngNo, String returnUrl) throws NoSuchAlgorithmException, UnsupportedEncodingException {
        // 이 메소드 내에서 필요한 모든 데이터를 조합하여 signature를 생성
    	System.out.println("generateSignature corpNo : "+ corpNo+ "mertNo : "+ mertNo+"corpMemberNo : "+ corpMemberNo+"userMngNo : "+ userMngNo+"returnUrl : "+ returnUrl);

    	String apiData = String.format("corpNo=%s&mertNo=%s&corpMemberNo=%s&userMngNo=%s&returnUrl=%s&hashKey=%s"
        		,corpNo, mertNo, corpMemberNo, userMngNo, returnUrl, kbpayHashKey);

        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] encodedhash = digest.digest(apiData.getBytes("UTF-8"));
        return toHexString(encodedhash);
    }
}