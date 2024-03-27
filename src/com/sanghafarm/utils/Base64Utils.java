package com.sanghafarm.utils;

import java.io.ByteArrayOutputStream;

public class Base64Utils {

    private static final String BASE64_CODES = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

    public static String encode(byte[] data) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < data.length; i += 3) {
            int b1 = data[i] & 0xFF;
            int b2 = (i + 1 < data.length) ? data[i + 1] & 0xFF : 0;
            int b3 = (i + 2 < data.length) ? data[i + 2] & 0xFF : 0;

            sb.append(BASE64_CODES.charAt(b1 / 4));
            sb.append(BASE64_CODES.charAt((b1 % 4) * 16 + b2 / 16));
            sb.append((i + 1 < data.length) ? BASE64_CODES.charAt((b2 % 16) * 4 + b3 / 64) : "=");
            sb.append((i + 2 < data.length) ? BASE64_CODES.charAt(b3 % 64) : "=");
        }
        return sb.toString();
    }

    public static byte[] decode(String s) {
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        try {
            for (int i = 0; i < s.length(); i += 4) {
                int y = BASE64_CODES.indexOf(s.charAt(i));
                int y2 = BASE64_CODES.indexOf(s.charAt(i + 1));
                int y3 = BASE64_CODES.indexOf(s.charAt(i + 2));
                int y4 = BASE64_CODES.indexOf(s.charAt(i + 3));

                byte b1 = (byte) ((y << 2) | (y2 >> 4));
                byte b2 = (byte) ((y2 << 4) | (y3 >> 2));
                byte b3 = (byte) ((y3 << 6) | y4);

                bos.write(b1);
                if (s.charAt(i + 2) != '=') bos.write(b2);
                if (s.charAt(i + 3) != '=') bos.write(b3);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bos.toByteArray();
    }
}
