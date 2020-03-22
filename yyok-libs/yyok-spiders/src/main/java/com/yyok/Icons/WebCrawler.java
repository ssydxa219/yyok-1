package com.yyok.Icons;


import org.apache.http.HttpEntity;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;

public class WebCrawler {

    ArrayList<String> allurlSet = new ArrayList<String>();
    ArrayList<String> notCrawlurlSet = new ArrayList<String>();
    HashMap<String, Integer> depth = new HashMap<String, Integer>();
    int crawDepth = 2;
    int threadCount = 10;
    int count = 0;
    public static final Object signal = new Object();// 线程间通信

    public static void main(String args[]) {
        final WebCrawler wc = new WebCrawler();
        wc.addUrl("http://www.csdn.net", 1);
        long start = System.currentTimeMillis();
        System.out.println("**************开始爬虫**************");
        wc.begin();

        while(true){
            if(wc.notCrawlurlSet.isEmpty()&& Thread.activeCount() == 1||wc.count==wc.threadCount){
                long end = System.currentTimeMillis();
                System.out.println("总共爬了"+wc.allurlSet.size()+"个网页");
                System.out.println("总共耗时"+(end-start)/1000+"秒");
                System.exit(1);
//	              break;
            }
        }

    }

    private void begin() {
        for (int i = 0; i < threadCount; ++i) {
            new Thread(new Runnable() {
                public void run() {

                    while (true) {
                        String tmp = getAUrl();
                        if (tmp != null) {
                            crawler(tmp);
                        } else {
                            synchronized (signal) {
                                try {
                                    count++;
                                    System.out.println(Thread.currentThread().getName() + ": 等待");
                                    signal.wait();
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }

                            }
                        }
                    }

                }
            }, "thread-" + i).start();
        }
    }

    public void crawler(String sUrl) {
        URL url;
        try {
            HttpClient client = HttpClients.createDefault();
            HttpGet get = new HttpGet(sUrl);
            get.setHeader("User-Agent",
                    "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36");
            CloseableHttpResponse response = (CloseableHttpResponse) client.execute(get);
            HttpEntity entity = response.getEntity();
            String content = EntityUtils.toString(entity);
            int d = depth.get(sUrl);
            System.out.println("爬网页" + sUrl + "成功，深度为" + d + " 是由线程" + Thread.currentThread().getName() + "来爬");

            if (d < crawDepth) {
                Document doc = Jsoup.parseBodyFragment(content);
                Elements es = doc.select("a");
                String temp = "";
                for (Element e : es) {
                    temp = e.attr("href");
                    if (temp != null) {
                        synchronized (signal) {
                            addUrl(temp, d + 1);
                            if (count > 0) {
                                signal.notify();
                                count--;
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public synchronized String getAUrl() {
        if (notCrawlurlSet.isEmpty())
            return null;
        String tmpAUrl;
        tmpAUrl = notCrawlurlSet.get(0);
        notCrawlurlSet.remove(0);
        return tmpAUrl;
    }

    public synchronized void addUrl(String url, int d) {
        notCrawlurlSet.add(url);
        allurlSet.add(url);
        depth.put(url, d);
    }

}