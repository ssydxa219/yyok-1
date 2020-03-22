package com.yyok.quote.eastmoney;

import com.yyok.common.util.MYSQLControl;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import java.util.ArrayList;
import java.util.List;

public class ExtMarketOilStockJob implements Job {

    @Override
    public void execute(JobExecutionContext arg0) throws JobExecutionException {
        //获取上次的插入股票日期，加入判断是否为节假日
        List<ExtMarketOilStockModel> randomlist = MYSQLControl.getListInfoBySQL("select stock_id,stock_price,stock_change from ext_market_oil_stock where date = (select date from ext_market_oil_stock order by date desc limit 1) ",ExtMarketOilStockModel.class);
        //表格更新时间

        List<String> urloillist=new ArrayList<String>();
        List<String> urlcarlist=new ArrayList<String>();
        List<ExtMarketOilStockModel> oilstocks=new ArrayList<ExtMarketOilStockModel>();
        List<ExtMarketOilStockModel> carstocks=new ArrayList<ExtMarketOilStockModel>();
        String url1="http://nufm.dfcfw.com/EM_Finance2014NumericApplication/JS.aspx?type=CT&cmd=C.BK04641&sty=FCOIATA&sortType=C&sortRule=-1&page=1&pageSize=20&js=var%20quote_123%3d{rank:[(x)],pages:(pc)}&token=7bc05d0d4c3c22ef9fca8c2a912d779c&jsName=quote_123&_g=0.13204790262127375";
        String url2="http://nufm.dfcfw.com/EM_Finance2014NumericApplication/JS.aspx?type=CT&cmd=C.BK04641&sty=FCOIATA&sortType=C&sortRule=-1&page=2&pageSize=20&js=var%20quote_123%3d{rank:[(x)],pages:(pc)}&token=7bc05d0d4c3c22ef9fca8c2a912d779c&jsName=quote_123&_g=0.6972178580603532";
        urloillist.add(url1);
        urloillist.add(url2);
        int judge=0;
        for (int i = 0; i < urloillist.size(); i++) {
            try {
                oilstocks=ExtMarketOilStockParse.parseurl(urloillist.get(i));
            } catch (Exception e) {
                e.printStackTrace();
            }

            for (int j = 0; j < oilstocks.size(); j++) {
                String stock_id=oilstocks.get(j).getStock_id();
                float stock_price=oilstocks.get(j).getStock_price();
                if (stock_id.equals(randomlist.get(0).getStock_id())) {
                    if (stock_price==randomlist.get(0).getStock_price()) {
                        judge++;
                    }
                }
            }
            for (int j = 0; j < oilstocks.size(); j++) {
                String stock_id=oilstocks.get(j).getStock_id();
                float stock_price=oilstocks.get(j).getStock_price();
                if (stock_id.equals(randomlist.get(1).getStock_id())) {
                    if (stock_price==randomlist.get(1).getStock_price()) {
                        judge++;
                    }
                }
            }
            for (int j = 0; j < oilstocks.size(); j++) {
                String stock_id=oilstocks.get(j).getStock_id();
                float stock_price=oilstocks.get(j).getStock_price();
                if (stock_id.equals(randomlist.get(2).getStock_id())) {
                    if (stock_price==randomlist.get(2).getStock_price()) {
                        judge++;
                    }
                }
            }
            if (judge!=3) {
                MYSQLControl.insertoilStocks(oilstocks);
            }
        }
        if (judge!=3) {
            for (int i = 1; i <6; i++) {
                String urli="http://nufm.dfcfw.com/EM_Finance2014NumericApplication/JS.aspx?type=CT&cmd=C.BK04811&sty=FCOIATA&sortType=C&sortRule=-1&page="+i+"&pageSize=20&js=var%20quote_123%3d{rank:[(x)],pages:(pc)}&token=7bc05d0d4c3c22ef9fca8c2a912d779c&jsName=quote_123&_g=0.23492960370783944";
                urlcarlist.add(urli);
            }
            for (int i = 0; i < urlcarlist.size(); i++) {
                try {
                    carstocks=ExtMarketOilStockParse.parseurl(urlcarlist.get(i));
                } catch (Exception e) {
                    e.printStackTrace();
                }
                MYSQLControl.insertcarStocks(carstocks);
            }
        }

    }

}