package com.yyok.jobs;


import com.google.gson.Gson;
import com.yyok.common.util.HttpClientUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

//获取搜索内存条的pid
public class IndexJdSpider {

    private static String url = "https://search.jd.com/search?keyword=8g%E5%86%85%E5%AD%98%E6%9D%A1%20ddr4&enc=utf-8&qrst=1&rt=1&stop=1&vt=2&suggest=2.def.0.V07&wq=8G&uc=0#J_searchWrap";
    private static ProductDao productDao = new ProductDao();
    private static boolean isEnd = false;
    //阻塞队列
    private static BlockingQueue<String> blockingQueue = new ArrayBlockingQueue(1000);
    //线程池
    private static ExecutorService executorService = Executors.newFixedThreadPool(30);

    public static void main(String[] args) throws IOException, InterruptedException {
        new Thread(new Runnable() {
            @Override
            public void run() {
                while (true){
                    try {
                        Thread.sleep(1000);
                        System.out.println("当前队列个数："+blockingQueue.size());
                        if(isEnd == true){
                            break;
                        }
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            }
        }).start();
        manyThreadRun();
        manyPage();
    }

    public static void manyThreadRun(){
        for(int i=0;i<30;i++){
            executorService.execute(new Runnable() {
                @Override
                public void run() {
                    while (true){
                        try {
                            String pid = blockingQueue.take();
                            if(blockingQueue.peek() == null && isEnd){
                                break;
                            }
                            productDao.addProduct(parseProduct(pid));
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }
            });
        }
    }

    /**
     * 爬取100页面的指定内容的数据
     * @throws IOException
     */
    public static void manyPage() {
        try {
            for(int i=1;i<=100;i++) {
                String nextPageUrl = "https://search.jd.com/search?keyword=8g%E5%86%85%E5%AD%98%E6%9D%A1%20ddr4&page=" + (i * 2 - 1);
                String html = null;
                html = HttpClientUtils.doGet(nextPageUrl);
                parseProductListHtml(html);
                if(i==100){
                    isEnd = true;
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 解析整个商品列表页面数据并保存数据
     * @param html
     * @throws IOException
     */
    public static void parseProductListHtml(String html) {
        Document document = Jsoup.parse(html);
        Elements liEl = document.select("#J_goodsList ul li");
        for (Element li : liEl) {
            try {
                blockingQueue.put(li.attr("data-sku"));
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 根据Pid封装商品信息
     * @param pid
     * @return
     */
    public static Product parseProduct(String pid)  {
        Product product = new Product();
        try {
            String iter_url = "https://item.jd.com/"+pid+".html";
            String html = null;
            html = HttpClientUtils.doGet(iter_url);

            Document document = Jsoup.parse(html);
            //获取title
            Elements title = document.select(".sku-name");
            product.setTitle(title.text());
            //设置商品url
            product.setUrl(iter_url);
            //设置商品pid
            product.setPid(pid);
            //设置商品品牌
            Elements brand = document.select("#parameter-brand");
            product.setBrand(brand.text());
            //设置商品名称
            Elements name = document.select("[class=parameter2 p-parameter-list] li:first-child");
            product.setPname(name.attr("title"));
            //设置商品价格，jd的商品价格单独获取
            String priceUrl = "https://p.3.cn/prices/mgets?skuIds=J_"+pid;
            String priceJsonStr = HttpClientUtils.doGet(priceUrl);
            Gson gson = new Gson();
            System.out.println(priceUrl);
            List<Map<String,String>> list = gson.fromJson(priceJsonStr, List.class);
            if(list != null && !list.isEmpty()){
                product.setPrice(Double.parseDouble(list.get(0).get("p")));
            }
            //        product.setPrice(Double.parseDouble("22"));
        } catch (IOException e) {
            e.printStackTrace();
        }finally {
            if(product.getPrice()==null){
                product.setPrice(-1.0);
            }
            return product;
        }
    }

}