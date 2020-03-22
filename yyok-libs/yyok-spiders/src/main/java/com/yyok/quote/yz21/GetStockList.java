package com.yyok.quote.yz21;

import com.yyok.common.util.FileUtil;
import com.yyok.common.util.HttpHelper;
import org.apache.http.client.config.CookieSpecs;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class GetStockList {
    // 起始页码
    private static final int page = 200;
    private static final String USER_AGENT = "Mozilla/5.0 (Linux; Android 5.0; SM-G900P Build/LRX21T) "
            + "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Mobile Safari/537.36";
    private static final String COOKIE = "_gat=1; nsfw-click-load=off; gif-click-load=on;"
            + " _ga=GA1.2.1861846600.1423061484";

    public static void main(String[] args) {
        // HttpClient 超时配置
        RequestConfig globalConfig = RequestConfig.custom().setCookieSpec(CookieSpecs.STANDARD)
                .setConnectionRequestTimeout(6000).setConnectTimeout(6000).build();
        CloseableHttpClient httpClient = HttpClients.custom().setDefaultRequestConfig(globalConfig).build();
        String url = "http://www.yz21.org/stock/info/";
        String urlToReq = "";
        StockProxy dao = StockProxy.getInstance();
        try {
            for (int i = 167; i <= page; i++) {
                // 创建一个GET请求
                String strParams = "/stocklist_" + i + ".html";
                if (i == 1) {
                    strParams = "";
                }
                urlToReq = url + strParams;
                // 停留一秒后开始任务
                Thread.sleep(1000);
                // 发送请求，并执行
                String htmlForStock = HttpHelper.getHtmlStrByUrl(urlToReq, httpClient, COOKIE, USER_AGENT);
                if (!htmlForStock.contains("找不到文件或目录")) {
                    // 网页内容解析
                    System.out.println("该网页存在,正在解析：" + urlToReq);
                    Document doc = Jsoup.parse(htmlForStock);
                    // 获取table表的行集合元素
                    Elements trs = doc.getElementById("All_stocks1_DataGrid1").select("tr");
                    SharePo sharePo = new SharePo();
                    for (int j = 1; j < trs.size(); j++) {
                        Elements tds = trs.get(j).select("td");
                        sharePo = new SharePo();
                        Element link = tds.get(1).select("a").first();
                        String relHref = link.attr("href");
                        String strtype = "";
                        if (relHref.contains("sh")) {
                            strtype = "sh";
                        } else if (relHref.contains("sz")) {
                            strtype = "sz";
                        }
                       /* // 股票代码
                        sharePo.setSharecode(strtype + tds.get(1).text());
                        // 股票简称
                        sharePo.setSharename(tds.get(2).text());
                        // 公司名称
                        sharePo.setCompanyname(tds.get(3).text());
                        // 股票简称拼音
                        sharePo.setCompanyshort(tds.get(4).text());*/

                        FileUtil.appendMethodB("E:\\data\\quoto\\zh.txt",strtype + tds.get(1).text()+" "+tds.get(2).text()+" "+tds.get(3).text()+" "+tds.get(4).text()+"\n");
                       // dao.addShare(sharePo);
                    }

                } else {
                    System.out.println("该网页不存在：" + urlToReq);
                    break;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
