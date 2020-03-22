package com.yyok.jobs;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.yyok.common.util.HttpClientUtils;
import org.apache.commons.lang3.ArrayUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * 智联招聘爬虫(大数据)
 */
public class AdvertiseForSpider {
    private static SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    private static ProductDao productDao = new ProductDao();
    private static int numFound;
    //阻塞队列
    private static BlockingQueue<Map<String, Object>> blockingQueue = new ArrayBlockingQueue(1000);
    //线程池
    private static ExecutorService executorService = Executors.newFixedThreadPool(35);

    public static void main(String[] args) throws IOException, ParseException, InterruptedException {
        watch();
        manyThread();
        manyPage();
    }

    /**
     * 监控当前队列个数
     */
    public static void watch() {
        new Thread(new Runnable() {
            @Override
            public void run() {
                while (true) {
                    try {
                        Thread.sleep(1000);
                        System.out.println("当前队列个数：" + blockingQueue.size());
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            }
        }).start();
    }

    public static void manyThread() {
        for (int i = 0; i < 30; i++) {
            executorService.execute(new Runnable() {
                @Override
                public void run() {
                    while (true) {
                        try {
                            Map<String, Object> map = blockingQueue.take();
                            productDao.addCompany(getCompany(map));
                            productDao.addPostInfo(getPostInfo(map));
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }
            });
        }
    }

    /**
     * 多页解析
     *
     * @throws IOException
     * @throws ParseException
     */
    public static void manyPage() throws IOException, ParseException, InterruptedException {
        Gson gson = new Gson();
        for (int i = 0; i < numFound / 60 + 1; i++) {
            String url = "https://fe-api.zhaopin.com/c/i/sou?start=" + (60 * i) + "&pageSize=60&cityId=530" +
                    "&workExperience=-1&education=-1&companyType=-1&employmentType=-1&jobWelfareTag=-1" +
                    "&kw=%E5%A4%A7%E6%95%B0%E6%8D%AE%E5%B7%A5%E7%A8%8B%E5%B8%88&kt=3" +
                    "&lastUrlQuery=%7B%22p%22:2,%22pageSize%22:%2260%22,%22jl%22:%22530%22,%22kw%22:%22%E5%A4%A7%E6%95%B0%E6%8D%AE%E5%B7%A5%E7%A8%8B%E5%B8%88%22,%22kt%22:%223%22%7D";
            String priceJsonStr = HttpClientUtils.doGet(url);
            JsonObject object = new JsonParser().parse(priceJsonStr).getAsJsonObject();
            if (i == 0) {
                numFound = object.get("data").getAsJsonObject().get("numFound").getAsInt();
            }
            String results = object.get("data").getAsJsonObject().get("results").toString();
            List<Map<String, Object>> list = gson.fromJson(results, List.class);
            for (Map<String, Object> map : list) {
                blockingQueue.put(map);
            }
        }
    }

    /**
     * 封装公司信息
     *
     * @param map
     * @return
     */
    public static Company getCompany(Map<String, Object> map) {
        Company company = new Company();
        Map<String, Object> city = (Map<String, Object>) map.get("city");
        map = (Map<String, Object>) map.get("company");
        company.setCid(map.get("number").toString());
        company.setCname(map.get("name").toString());
        company.setUrl(map.get("url").toString());
        company.setSize(((Map<String, Object>) map.get("size")).get("name").toString());
        company.setType(((Map<String, Object>) map.get("type")).get("name").toString());
        company.setCity(city.get("display").toString());
        return company;
    }

    /**
     * 封装岗位信息
     *
     * @param map
     * @return
     */
    public static PostInfo getPostInfo(Map<String, Object> map) throws IOException, ParseException {
        if ("校招".equals(map.get("salary").toString()) || "校园".equals(map.get("emplType").toString())) {
            return getPostInfo2(map);
        }
        PostInfo postInfo = new PostInfo();
        String positionURL = map.get("positionURL").toString();
        postInfo.setPid(UUID.randomUUID().toString());
        //岗位URL
        postInfo.setPositionURL(positionURL);
        String html = HttpClientUtils.doGet(positionURL);
        Document document = Jsoup.parse(html);
        //岗位名称
        Elements name = document.select("[class=inner-left fl] h1");
        postInfo.setJobName(name.text());
        //岗位薪资
        Elements price = document.select(".terminalpage-left>ul>li:first-child strong");
        postInfo.setSalary(price.text());
        //上班地点
        Elements addres = document.select(".tab-inner-cont:first-child h2");
        postInfo.setPostAddres(addres.text());
        //工作经验年限
        Elements workingExp = document.select(".terminalpage-left>ul>li:nth-child(5) strong");
        postInfo.setWorkingExp(workingExp.text());
        //学历要求
        Elements eduLevel = document.select(".terminalpage-left>ul>li:nth-child(6) strong");
        postInfo.setEduLevel(eduLevel.text());
        //岗位性质
        Elements emplType = document.select(".terminalpage-left>ul>li:nth-child(4) strong");
        postInfo.setEmplType(emplType.text());
        //招聘人数
        Elements peopleNum = document.select(".terminalpage-left>ul>li:nth-child(7) strong");
        postInfo.setPeopleNum(peopleNum.text());
        //职位福利
        ArrayList<String> welfares = (ArrayList<String>) map.get("welfare");
        postInfo.setWelfare(ArrayUtils.toString(welfares, ","));
        //职位信息
        Elements positionInfo = document.select("[class=terminalpage-main clearfix] .tab-inner-cont p");
        postInfo.setPositionInfo(positionInfo.text());
        //公司
        postInfo.setCid(((Map<String, Object>) map.get("company")).get("number").toString());
        //岗位创建时间
        postInfo.setCreateDate(sdf.parse(map.get("createDate").toString()));
        //岗位更新时间
        postInfo.setUpdateDate(sdf.parse(map.get("updateDate").toString()));
        //招聘结束时间
        postInfo.setEndDate(sdf.parse(map.get("endDate").toString()));
        //公司简介
        Elements introduce = document.select(".tab-inner-cont:nth-child(2) p");
        postInfo.setIntroduce(introduce.text());
        return postInfo;
    }

    /**
     * 校招封装岗位信息
     *
     * @param map
     * @return
     */
    public static PostInfo getPostInfo2(Map<String, Object> map) throws IOException, ParseException {
        PostInfo postInfo = new PostInfo();
        postInfo.setPid(UUID.randomUUID().toString());
        postInfo.setJobName(map.get("jobName").toString());
        postInfo.setSalary(map.get("salary") != null ? map.get("salary").toString() : null);
        postInfo.setPostAddres(((Map<String, Object>) map.get("city")).get("display").toString());
        postInfo.setWorkingExp(((Map<String, Object>) map.get("workingExp")).get("name").toString());
        postInfo.setEmplType(map.get("emplType").toString());
        String positionURL = map.get("positionURL").toString();
        postInfo.setPositionURL(positionURL);
        String html = HttpClientUtils.doGet(positionURL);
        Document document = Jsoup.parse(html);
        Elements peopleNum = document.select(".cJobDetailInforBotWrap>li:nth-child(6)");
        postInfo.setPeopleNum(peopleNum.text());
        List<String> welfares = (List<String>) map.get("welfare");
        postInfo.setWelfare(ArrayUtils.toString(welfares, ","));
        Elements positionInfo = document.select("[class=cJob_Detail f14] p");
        postInfo.setPositionInfo(positionInfo.text());
        postInfo.setCid(((Map<String, Object>) map.get("company")).get("number").toString());
        postInfo.setCreateDate(sdf.parse(map.get("createDate").toString()));
        postInfo.setUpdateDate(sdf.parse(map.get("updateDate").toString()));
        postInfo.setEndDate(sdf.parse(map.get("endDate").toString()));
        Elements edulevel = document.select(".cJobDetailInforBotWrap>li:last-child");
        postInfo.setEduLevel(edulevel.text());
        String[] urls = ((Map<String, Object>) map.get("company")).get("url").toString().split("/");
        String htmlDetail = HttpClientUtils.doGet("https://xiaoyuan.zhaopin.com/jobdetail/GetCompanyIntro/" + postInfo.getCid() + "?subcompanyid=" + urls[urls.length - 1] + "&showtype=2");
        JsonObject object = new JsonParser().parse(htmlDetail).getAsJsonObject();
        postInfo.setIntroduce(java.net.URLDecoder.decode(object.get("intro").toString(), "UTF-8"));
        return postInfo;
    }
}