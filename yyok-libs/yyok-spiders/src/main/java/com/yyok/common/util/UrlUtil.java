package com.yyok.common.util;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.*;
import java.util.Iterator;
import java.util.Map;
import java.util.regex.Pattern;

public class UrlUtil {

    static String urlRegex = "^((https|http|ftp|rtsp|mms)?://)" //https、http、ftp、rtsp、mms
            + "?(([0-9a-z_!~*'().&=+$%-]+: )?[0-9a-z_!~*'().&=+$%-]+@)?" //ftp的user@  
            + "(([0-9]{1,3}\\.){3}[0-9]{1,3}" // IP形式的URL- 例如：199.194.52.184  
            + "|" // 允许IP和DOMAIN（域名）
            + "([0-9a-z_!~*'()-]+\\.)*" // 域名- www.  
            + "([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\\." // 二级域名  
            + "[a-z]{2,6})" // first level domain- .com or .museum  
            + "(:[0-9]{1,5})?" // 端口号最大为65535,5位数
            + "((/?)|" // a slash isn't required if there is no file name  
            + "(/[0-9a-z_!~*'().;?:@&=+$,%#-]+)+/?)$";

    public static String encodeURL(String url) {
        try {
            return URLEncoder.encode(url, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static String decodeURL(String url) {
        try {
            return URLDecoder.decode(url, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static boolean isURLExist(String url) {
        try {
            URL u = new URL(url);
            HttpURLConnection urlconn = (HttpURLConnection) u.openConnection();
            int state = urlconn.getResponseCode();
            if (state == 200) {
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            return false;
        }
    }

    public static String getParamString(Map params) {
        StringBuffer queryString = new StringBuffer(256);
        Iterator it = params.keySet().iterator();
        int count = 0;
        while (it.hasNext()) {
            String key = (String) it.next();
            String[] param = (String[]) params.get(key);
            for (int i = 0; i < param.length; i++) {
                if (count == 0) {
                    count++;
                } else {
                    queryString.append("&");
                }
                queryString.append(key);
                queryString.append("=");
                try {
                    queryString.append(URLEncoder.encode((String) param[i], "UTF-8"));
                } catch (UnsupportedEncodingException e) {
                }
            }
        }
        return queryString.toString();
    }

    public static String getRequestURL(HttpServletRequest request) {
        StringBuffer originalURL = new StringBuffer(request.getServletPath());
        Map parameters = request.getParameterMap();
        if (parameters != null && parameters.size() > 0) {
            originalURL.append("?");
            originalURL.append(getParamString(parameters));
        }
        return originalURL.toString();
    }

    public static String url2Str(String urlString) {
        try {
            StringBuffer html = new StringBuffer();
            URL url = new URL(urlString);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            URLConnection c = url.openConnection();
            c.connect();
            String contentType = c.getContentType();
            String characterEncoding = null;
            int index = contentType.indexOf("charset=");
            if (index == -1) {
                characterEncoding = "UTF-8";
            } else {
                characterEncoding = contentType.substring(index + 8, contentType.length());
            }
            InputStreamReader isr = new InputStreamReader(conn.getInputStream(), characterEncoding);
            BufferedReader br = new BufferedReader(isr);
            String temp;
            while ((temp = br.readLine()) != null) {
                html.append(temp).append("\n");
            }
            br.close();
            isr.close();
            return html.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static String gainurl(String urlString) {
        //String regex = "^([hH][tT]{2}[pP]:/*|[hH][tT]{2}[pP][sS]:/*|[fF][tT][pP]:/*)(([A-Za-z0-9-~]+).)+([A-Za-z0-9-~\\/])+(\\?{0,1}(([A-Za-z0-9-~]+\\={0,1})([A-Za-z0-9-~]*)\\&{0,1})*)$";
        Pattern pattern = Pattern.compile(urlRegex);
        if (pattern.matcher(urlString).matches()) {
            //System.out.println("是正确的网址");
        } else {
            //urlString = orgurl + urlString;
            System.out.println("非法网址" + urlString);
        }
        return urlString;
    }

    public static boolean isURL(String str) {
//转换为小写
        if (str==null) {
            return false;
        }
        str = str.toLowerCase();

        return str.matches(urlRegex);
    }

    public static void main(String[] args) {
        String content = UrlUtil.url2Str("http://www.baidu.com");
        System.out.println(content);
    }


}
