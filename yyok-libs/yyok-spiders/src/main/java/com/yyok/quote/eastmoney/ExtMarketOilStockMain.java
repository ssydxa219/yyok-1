package com.yyok.quote.eastmoney;

import com.yyok.common.util.MYSQLControl;

import java.util.ArrayList;
import java.util.List;


public class ExtMarketOilStockMain {

    public static void main(String[] args) throws Exception {
        List<String> urloillist = new ArrayList<String>();
        List<String> urlcarlist = new ArrayList<String>();
        List<ExtMarketOilStockModel> oilstocks = new ArrayList<ExtMarketOilStockModel>();
        List<ExtMarketOilStockModel> carstocks = new ArrayList<ExtMarketOilStockModel>();
        //石油相关股票就两页，对应两个地址
        String url1 = "http://nufm.dfcfw.com/EM_Finance2014NumericApplication/JS.aspx?type=CT&cmd=C.BK04641&sty=FCOIATA&sortType=C&sortRule=-1&page=1&pageSize=20&js=var%20quote_123%3d{rank:[(x)],pages:(pc)}&token=7bc05d0d4c3c22ef9fca8c2a912d779c&jsName=quote_123&_g=0.13204790262127375";
        String url2 = "http://nufm.dfcfw.com/EM_Finance2014NumericApplication/JS.aspx?type=CT&cmd=C.BK04641&sty=FCOIATA&sortType=C&sortRule=-1&page=2&pageSize=20&js=var%20quote_123%3d{rank:[(x)],pages:(pc)}&token=7bc05d0d4c3c22ef9fca8c2a912d779c&jsName=quote_123&_g=0.6972178580603532";
        urloillist.add(url1);
        urloillist.add(url2);
        for (int i = 0; i < urloillist.size(); i++) {
            //解析url
            oilstocks = ExtMarketOilStockParse.parseurl(urloillist.get(i));
            //存储每页的数据
            MYSQLControl.insertoilStocks(oilstocks);
        }
        //汽车相关股票有6页，对应6个地址
        for (int i = 1; i < 6; i++) {
            String urli = "http://nufm.dfcfw.com/EM_Finance2014NumericApplication/JS.aspx?type=CT&cmd=C.BK04811&sty=FCOIATA&sortType=C&sortRule=-1&page=" + i + "&pageSize=20&js=var%20quote_123%3d{rank:[(x)],pages:(pc)}&token=7bc05d0d4c3c22ef9fca8c2a912d779c&jsName=quote_123&_g=0.23492960370783944";
            urlcarlist.add(urli);
        }
        for (int i = 0; i < urlcarlist.size(); i++) {
            //解析url
            carstocks = ExtMarketOilStockParse.parseurl(urlcarlist.get(i));
            //存储数据
            MYSQLControl.insertcarStocks(carstocks);
        }

    }
}