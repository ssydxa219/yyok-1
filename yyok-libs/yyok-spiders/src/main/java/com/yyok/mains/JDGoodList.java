package com.yyok.mains;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.*;
import java.net.URL;
import java.net.URLConnection;

public class JDGoodList {

    public static void main(String[] args) throws IOException {
        //本地文件的路径
        File html = new File("C:/Users/asus/Desktop/1.html");
        //获取网页文本
        Document document = Jsoup.parse(html, "UTF-8");
        //指定存储文件的路径
        File path = new File("G:/study/jdimg");
        if (!path.exists()) {
            path.mkdirs();
        }
        //根据类名选择商品
        Elements items = document.getElementsByClass("gl-i-wrap");
        for (Element element : items) {
            //获取图片标签信息
            Element p_img = element.getElementsByClass("p-img").first();
            //获取图片中的a标签
            Element p_img_a = p_img.getElementsByTag("a").first();
            //获取a标签中的title值，对应的商品标题
            String itemTitle = p_img_a.attr("title");
            //获取a标签中的url值，对应的商品连接
            String itemUrl = p_img_a.attr("href");
            //获取价格信息   --获取价格标签，然后找到价格中的i标签，获取文本信息
            String p_price = element.getElementsByClass("p-price").first().getElementsByTag("i").first().text();
            //获取评价信息
            String p_commit = element.getElementsByClass("p-commit").first().getElementsByTag("strong").first().text();
            //获取卖家信息
            String p_shop = element.getElementsByClass("p-shop").first().getElementsByTag("a").first().text();
            //下载图片
            //刚才我们拿到的是商品的详情界面，我们连接这个页面，分析页面可以知道商品的图片信息就在id=spec-img的标签中
            //拿到这个dom元素后，获取图片的地址
            Document itemInfo = Jsoup.connect(itemUrl).get();
            Element itemImg = itemInfo.getElementById("spec-img");
            URL url = new URL("http:" + itemImg.attr("data-origin"));
            String filename = "" + System.currentTimeMillis();
            // 获得连接
            URLConnection connection = url.openConnection();
            // 设置10秒的相应时间
            connection.setConnectTimeout(10 * 1000);
            // 获得输入流
            InputStream in = connection.getInputStream();
            // 获得输出流
            BufferedOutputStream out = new BufferedOutputStream(new FileOutputStream(path + "/" + filename + ".png"));
            // 构建缓冲区
            byte[] buf = new byte[1024];
            int size;
            // 写入到文件
            while (-1 != (size = in.read(buf))) {
                out.write(buf, 0, size);
            }
            out.close();
            in.close();
            System.out.println("图片地址:" + itemUrl +
                    "商品标题:" + itemTitle +
                    "商品价格:" + p_price + "评价人数：" + p_commit + "卖家信息:" + p_shop + "文件名称：" + filename);
            System.out.println("---------------------------");


        }


    }
}