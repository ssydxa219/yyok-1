package com.yyok.common.util;

import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;

import java.io.InputStream;

public class HttpHelper {

    public static String getHtmlStrByUrl(String url, CloseableHttpClient httpClient, String COOKIE, String USER_AGENT) {
        HttpGet httpGetForFName = new HttpGet(url);
        httpGetForFName.addHeader("User-Agent", USER_AGENT);
        httpGetForFName.addHeader("Cookie", COOKIE);
        httpGetForFName.addHeader("Content-Type", "text/html;charset=UTF-8");
        // 发送请求，并执行
        CloseableHttpResponse response;
        String html = "";
        try {
            response = httpClient.execute(httpGetForFName);
            InputStream in = response.getEntity().getContent();
            html = StreamToString.streamToStr(in,"utf-8");
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return html;
    }

}