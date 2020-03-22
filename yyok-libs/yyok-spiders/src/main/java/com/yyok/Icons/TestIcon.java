package com.yyok.Icons;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.*;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;




public class TestIcon {
    public static void main(String[] args) {
        ExecutorService executor = Executors.newFixedThreadPool(5);
        Document doc = null;
        FileWriter writer = null;
        String rui = "index";
        List<String> alist = new ArrayList<String> ();
//int keyword = 4;
        for (int keyword = 4; keyword < 100; keyword++) {
            try {
//创建页面对象
                doc = Jsoup.connect("http://pic.yesky.com/c/6_20491_" + keyword + ".shtml").userAgent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.95 Safari/537.36").timeout(10000).get();
//根据标签和class id获取元素
                Elements div = doc.select("div.lb_box");
//根据标签获取元素
                Elements dl = div.select("dl");
                Elements dd = div.select("dd");
                Elements pages = dd.select("a");
                for (Element e : pages) {
                    System.out.println(e.text());
                    System.out.println(e.attr("href"));
                    Document imgdoc = Jsoup.connect(e.attr("href")).userAgent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.95 Safari/537.36").timeout(10000).get();
                    Elements scroll = imgdoc.select("div.effect_scroll");
                    Elements li = scroll.select("li");
                    Elements urls = li.select("a");
                    int i = 0;
                    for (Element ipage : urls) {
                        Document imgpage = Jsoup.connect(ipage.attr("href")).userAgent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.95 Safari/537.36").timeout(10000).get();
                        Elements imgediv = imgpage.select("div.l_effect_img_mid");
                        Element img = imgediv.select("img").first();
                        FileOutUtils fo = new FileOutUtils(img, e.text());
                        fo.start();
                        System.out.println(i);
                        i++;
                    }
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 单线程下载
     *
     * @param e
     * @param filepath
     * @author wangshiyu
     */
    public static void savefile(Element e, String filepath) {
String src = e.attr("src");//获取img中的src路径
 // System.out.println(src);
 //获取后缀名
String imageName = src.substring(src.lastIndexOf("/") + 1, src.length());
 //连接url
URL url;
System.out.println(src);
        try {
            url = new URL(src);
            URLConnection uri = url.openConnection();
 //获取数据流
 InputStream is = uri.getInputStream();
 //写入数据流
 File file = new File("E://imgs//" + filepath);
 if (!file.exists()) {
 file.mkdirs();
 }
 OutputStream os = new FileOutputStream(new File("E://imgs//" + filepath + "//", imageName));

 byte[] buf = new byte[1024];

            int l = 0;

            while ((l = is.read(buf)) != -1) {
                os.write(buf, 0, l);
            }
        } catch (MalformedURLException e1) {
            e1.printStackTrace();
        } catch (FileNotFoundException e1) {
            e1.printStackTrace();
        } catch (IOException e1) {
            e1.printStackTrace();
        }
    }
}
