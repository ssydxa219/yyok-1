package com.yyok.htmls;

import com.yyok.crawler.model.PageRequest;
import com.yyok.common.util.JsoupUtil;
import org.jsoup.nodes.Document;

public class GaitHtml {

    static String url = "http://www.12333sb.com/yanglao/zhejiang/hangzhou.html";
    public static void main(String[] args) {
        PageRequest pageRequest =new PageRequest();
        pageRequest.setUrl(url);
        Document dcs = JsoupUtil.load(pageRequest);
        System.out.println(dcs.getElementsByTag("a"));
        System.out.println(dcs.getElementsByTag("img"));
        System.out.println(dcs.text());
        //System.out.println(dcs.html());
    }

}
