package com.yyok.common.util;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.ParseException;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.*;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.impl.conn.PoolingHttpClientConnectionManager;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.protocol.HTTP;
import org.apache.http.util.EntityUtils;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * HTTP请求工具类.
 */
public class HttpClientUtils {

    private static PoolingHttpClientConnectionManager connectionManager;

    static {
        //定义个连接池的工具类对象
        connectionManager = new PoolingHttpClientConnectionManager();
        //定义连接池属性
        //定义连接池最大的属性
        connectionManager.setMaxTotal(20);
        //定义主机的最大并发数
        connectionManager.setDefaultMaxPerRoute(20);
    }

    //获取CloseableHttpClient连接对象
    private static CloseableHttpClient getCloseableHttpClient(){
        CloseableHttpClient closeableHttpClient = HttpClients.custom().setConnectionManager(connectionManager).build();
        return closeableHttpClient;
    }

    //执行请求返回HTML页面
    private static String execute(HttpRequestBase httpRequestBase) throws IOException {
        httpRequestBase.setHeader("User-Agent","Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36");
        /**
         * setConnectionRequestTimeout:设置获取请求的最长时间
         *
         * setConnectTimeout: 设置创建连接的最长时间
         *
         * setSocketTimeout: 设置传输超时的最长时间
         */
        RequestConfig config = RequestConfig.custom().setConnectionRequestTimeout(5000).setConnectTimeout(5000)
                .setSocketTimeout(10 * 1000).build();

        httpRequestBase.setConfig(config);

        //获取httpClient连接
        CloseableHttpClient httpClient = getCloseableHttpClient();
        //发送请求，得到请求返回结果response
        CloseableHttpResponse response = httpClient.execute(httpRequestBase);

        String html = EntityUtils.toString(response.getEntity(), "UTF-8");

        return html;
    }

    //使用GET方式发送请求
    public static String doGet(String url) throws IOException {
        HttpGet httpGet = new HttpGet(url);
        String html = execute(httpGet);
        return html;
    }

    //使用POST方式发送请求
    public static String doPost(String url, Map<String,String> param) throws IOException {
        HttpPost httpPost = new HttpPost(url);
        List<NameValuePair> list = new ArrayList<NameValuePair>();
        for (String key : param.keySet()) {
            list.add(new BasicNameValuePair(key,param.get(key)));
        }
        HttpEntity httpEntity = new UrlEncodedFormEntity(list);
        httpPost.setEntity(httpEntity);
        String html = execute(httpPost);
        return html;
    }

    /**
     * post方式请求.
     * @param url 请求地址.
     * @param params 请求参数
     * @return String
     */
    public static String post(String url, Map<String, String> params) {
        DefaultHttpClient httpclient = new DefaultHttpClient();
        String body = null;

        HttpPost post = postForm(url, params);

        body = invoke(httpclient, post);

        httpclient.getConnectionManager().shutdown();

        return body;
    }

    /**
     * get方式请求.
     * @param url 请求地址.
     * @return String
     */
    public static String get(String url) {
        DefaultHttpClient httpclient = new DefaultHttpClient();
        String body = null;

        HttpGet get = new HttpGet(url);
        body = invoke(httpclient, get);

        httpclient.getConnectionManager().shutdown();

        return body;
    }
    /**
     * 请求方法.
     * @param httpclient DefaultHttpClient.
     * @param httpost 请求方式.
     * @return String
     */
    private static String invoke(DefaultHttpClient httpclient,
                                 HttpUriRequest httpost) {

        HttpResponse response = sendRequest(httpclient, httpost);
        String body = paseResponse(response);

        return body;
    }

    /**
     *
     * @param response
     * @return
     */
    @SuppressWarnings({ "deprecation", "unused" })
    private static String paseResponse(HttpResponse response) {
        HttpEntity entity = response.getEntity();

        String charset = EntityUtils.getContentCharSet(entity);

        String body = null;
        try {
            body = EntityUtils.toString(entity);
        } catch (ParseException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return body;
    }

    private static HttpResponse sendRequest(DefaultHttpClient httpclient,
                                            HttpUriRequest httpost) {
        HttpResponse response = null;

        try {
            response = httpclient.execute(httpost);
        } catch (ClientProtocolException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return response;
    }

    @SuppressWarnings("deprecation")
    private static HttpPost postForm(String url, Map<String, String> params) {

        HttpPost httpost = new HttpPost(url);
        List<NameValuePair> nvps = new ArrayList<NameValuePair>();

        Set<String> keySet = params.keySet();
        for (String key : keySet) {
            nvps.add(new BasicNameValuePair(key, params.get(key)));
        }
        try {
            httpost.setEntity(new UrlEncodedFormEntity(nvps, HTTP.UTF_8));
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

        return httpost;
    }
}