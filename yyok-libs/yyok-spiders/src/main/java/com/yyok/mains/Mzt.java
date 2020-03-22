package com.yyok.mains;

import org.apache.commons.io.IOUtils;
import org.apache.http.HttpEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Mzt {
    public static void main(String[] args) throws IOException {
        //1. 获取网络资源地址
        String url = "https://www.mzitu.com/20513";//修改此地址就可以获取另外的图集了
        Document document = Jsoup.connect(url).get();
        //找到表示总共多少页的 <a> 标签
        Elements elements = document.select(".pagenavi a");
        Integer span = Integer.valueOf(elements.eq(elements.size() - 2).select("span").text());

        for (Integer i = 1; i <= span; i++) {
            String url02 = url+"/"+i;//具体每张图对应的页面
            Document document02 = Jsoup.connect(url02).get();
            //找到这个图片列表对应的位置
            String src = "";
            Elements elements02 = document02.select(".main-image p a img");
            for (Element element02 : elements02) {
                //每一个a标签就对应一张图,然后拿到里面的href属性的值
                src = element02.attr("src");
                System.out.println(src);
            }

            //使用这个地址下载图片
            //1.使用Java代码模拟出一个客户端
            CloseableHttpClient httpClient = HttpClients.createDefault();

            //2.创建一个get请求
            HttpGet httpGet = new HttpGet(src);
            //添加头部信息模拟浏览器访问
            httpGet.setHeader("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8");
            httpGet.setHeader("Accept-Encoding", "gzip, deflate, sdch, br");
            httpGet.setHeader("Accept-Language", "zh-CN,zh;q=0.8");
            httpGet.setHeader("User-Agent", "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36(KHTML, like Gecko) Chrome/55.0.2883.87 Safari/537.36");
            httpGet.setHeader("Referer", "https://www.mzitu.com/");//告诉服务器women从哪里来的

            //3.使用客户端执行请求,获取响应
            CloseableHttpResponse httpResponse = httpClient.execute(httpGet);
            //4.获取响应体
            HttpEntity entity = httpResponse.getEntity();
            //5.获取响应体的内容
            InputStream is = entity.getContent();
            //创建一个字节输出流，将图片输出到硬盘中"D/aa"目录
            //解析src获取图片的后缀名
            //int i1 = src.lastIndexOf(".");//得到的是最后一个 . 的索引,然后用substring来根据索引切割
            String sub = src.substring(src.lastIndexOf("."));
            //创建一个随时间毫秒值变化的的文件名
            Date date = new Date();
            SimpleDateFormat sdf = new SimpleDateFormat("YYYYMMddHHmmssSSS");
            String imgName = sdf.format(date)+sub;
            FileOutputStream out = new FileOutputStream("E:\\imgs\\mzt\\" + imgName);//具体放在哪个地方可以由你自己确定,但是记得要这个文件夹一定要存在,否则会报错
            //将输入流中的内容拷贝到输出流
            IOUtils.copy(is,out);
            //关流
            out.close();
            is.close();


            System.out.println("下载ing.......");
        }
        System.out.println("本次下载完成了,快去打开吧...");
    }
}
