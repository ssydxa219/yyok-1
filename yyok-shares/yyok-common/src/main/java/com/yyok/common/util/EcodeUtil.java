package com.yyok.common.util;

import java.io.UnsupportedEncodingException;

public class EcodeUtil {

    /**
     * 在将数据存入数据库前转换
     *
     * @param strVal 要转换的字符串
     * @return 从“ISO8859_1”到“GBK”得到的字符串
     * @since 1.0
     */
    public static String toChinese(String strVal) {
        try {
            if (strVal == null) {
                return "";
            } else {
                strVal = strVal.trim();
                strVal = new String(strVal.getBytes("ISO8859_1"), "GBK");
                return strVal;
            }
        } catch (Exception exp) {
            return "";
        }
    }

    /**
     * 编码转换 从UTF-8到GBK
     *
     * @param strVal
     * @return
     */
    public static String toGBK(String strVal) {
        try {
            if (strVal == null) {
                return "";
            } else {
                strVal = strVal.trim();
                strVal = new String(strVal.getBytes("UTF-8"), "GBK");
                return strVal;
            }
        } catch (Exception exp) {
            return "";
        }
    }

    /**
     * 将数据从数据库中取出后转换   *
     *
     * @param strVal 要转换的字符串
     * @return 从“GBK”到“ISO8859_1”得到的字符串
     * @since 1.0
     */
    public static String toISO(String strVal) {
        try {
            if (strVal == null) {
                return "";
            } else {
                strVal = new String(strVal.getBytes("GBK"), "ISO8859_1");
                return strVal;
            }
        } catch (Exception exp) {
            return "";
        }
    }

    public static String gbk2UTF8(String strVal) {
        try {
            if (strVal == null) {
                return "";
            } else {
                strVal = new String(strVal.getBytes("GBK"), "UTF-8");
                return strVal;
            }
        } catch (Exception exp) {
            return "";
        }
    }

    public static String ISO2UTF8(String strVal) {
        try {
            if (strVal == null) {
                return "";
            } else {
                strVal = new String(strVal.getBytes("ISO-8859-1"), "UTF-8");
                return strVal;
            }
        } catch (Exception exp) {
            return "";
        }
    }

    public static String UTF82ISO(String strVal) {
        try {
            if (strVal == null) {
                return "";
            } else {
                strVal = new String(strVal.getBytes("UTF-8"), "ISO-8859-1");
                return strVal;
            }
        } catch (Exception exp) {
            return "";
        }

    }

    /**
     * 转换编码 ISO-8859-1到GB2312
     *
     * @param text
     * @return
     */
    public static final String ISO2GB(String text) {
        String result = "";
        try {
            result = new String(text.getBytes("ISO-8859-1"), "GB2312");
        } catch (UnsupportedEncodingException ex) {
            result = ex.toString();
        }
        return result;
    }

    /**
     * 转换编码 GB2312到ISO-8859-1
     *
     * @param text
     * @return
     */
    public static final String GB2ISO(String text) {
        String result = "";
        try {
            result = new String(text.getBytes("GB2312"), "ISO-8859-1");
        } catch (UnsupportedEncodingException ex) {
            ex.printStackTrace();
        }
        return result;
    }

    /**
     * Utf8URL编码
     *
     * @param text
     * @return
     */
    public static final String Utf8URLencode(String text) {
        StringBuffer result = new StringBuffer();

        for (int i = 0; i < text.length(); i++) {

            char c = text.charAt(i);
            if (c >= 0 && c <= 255) {
                result.append(c);
            } else {

                byte[] b = new byte[0];
                try {
                    b = Character.toString(c).getBytes("UTF-8");
                } catch (Exception ex) {

                }
                for (int j = 0; j < b.length; j++) {
                    int k = b[j];
                    if (k < 0) k += 256;
                    result.append("%" + Integer.toHexString(k).toUpperCase());
                }
            }
        }
        return result.toString();
    }

    /**
     * Utf8URL解码
     *
     * @param text
     * @return
     */
    public static final String Utf8URLdecode(String text) {
        String result = "";
        int p = 0;
        if (text != null && text.length() > 0) {
            text = text.toLowerCase();
            p = text.indexOf("%e");
            if (p == -1) return text;
            while (p != -1) {
                result += text.substring(0, p);
                text = text.substring(p, text.length());
                if (text == "" || text.length() < 9) return result;
                //result += CodeToWord(text.substring(0, 9));
                text = text.substring(9, text.length());
                p = text.indexOf("%e");
            }
        }
        return result + text;

    }
}
