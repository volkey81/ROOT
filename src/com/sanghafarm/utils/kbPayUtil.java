package com.sanghafarm.utils;

//import java.util.Base64;
import com.sanghafarm.utils.Base64Utils;

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
        byte[] keyBytes = Base64Utils.decode(ENCRYPTION_KEY);
        byte[] ivBytes = ENCRYPTION_IV.getBytes("UTF-8");

        SecretKeySpec secretKeySpec = new SecretKeySpec(keyBytes, "SEED");
        IvParameterSpec ivParameterSpec = new IvParameterSpec(ivBytes);

        cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec, ivParameterSpec);
        byte[] encrypted = cipher.doFinal(input.getBytes("UTF-8"));
        return Base64Utils.encode(encrypted);
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

    /* 결제수단 조회 sig 생성 */
    public static String payselSig(String corpMemberNo, String userMngNo, String returnUrl) throws NoSuchAlgorithmException, UnsupportedEncodingException {
    	String apiData = String.format("corpNo=%s&mertNo=%s&corpMemberNo=%s&userMngNo=%s&hashKey=%s"
        		,corpNo, mertNo, corpMemberNo, userMngNo, kbpayHashKey);
    	
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] encodedhash = digest.digest(apiData.getBytes("UTF-8"));
        return toHexString(encodedhash);
    }
    
    /* 결제수단 등록 sig 생성 */
    public static String payregSig(String corpMemberNo, String userMngNo, String returnUrl) throws NoSuchAlgorithmException, UnsupportedEncodingException {
    	String apiData = String.format("corpNo=%s&mertNo=%s&corpMemberNo=%s&userMngNo=%s&returnUrl=%s&hashKey=%s"
        		,corpNo, mertNo, corpMemberNo, userMngNo, returnUrl, kbpayHashKey);
    	
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] encodedhash = digest.digest(apiData.getBytes("UTF-8"));
        return toHexString(encodedhash);
    }
    
    /* 결제요청 sig 생성 */
    public static String payreqauthSig(String corpMemberNo, String userMngNo, String returnUrl
    		, String disPayUiType, String payReqUiType, String payUniqNo, String payMethod, String bankCardCode
    		, String orderNo, String goodsName, String goodsPrice, String products, String buyerName
    		, String buyerTel, String buyerEmail, String cardQuota, String cardInterest, String tax
    		, String taxFree, String settleAmt
    		) throws NoSuchAlgorithmException, UnsupportedEncodingException {
    	String apiData = String.format("corpNo=%s&mertNo=%s&corpMemberNo=%s&userMngNo=%s&disPayUiType=%s&payReqUiType=%s&payUniqNo=%s&payMethod=%s&bankCardCode=%s&orderNo=%s&goodsName=%s&goodsPrice=%s&products=%s&buyerName=%s&buyerTel=%s&buyerEmail=%s&cardQuota=%s&cardInterest=%s&tax=%s&taxFree=%s&settleAmt=%s&returnUrl=%s&hashKey=%s"
    		    , corpNo, mertNo, corpMemberNo, userMngNo, disPayUiType, payReqUiType, payUniqNo, payMethod, bankCardCode
    		    , orderNo, goodsName, goodsPrice, products, buyerName, buyerTel, buyerEmail, cardQuota, cardInterest, tax
    		    , taxFree, settleAmt, returnUrl, kbpayHashKey);
    	
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] encodedhash = digest.digest(apiData.getBytes("UTF-8"));
        return toHexString(encodedhash);
    }
}