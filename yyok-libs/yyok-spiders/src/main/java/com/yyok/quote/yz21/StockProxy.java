package com.yyok.quote.yz21;

import com.yyok.common.util.FileUtil;

public class StockProxy {

    public static StockProxy getInstance() {

        return new StockProxy() ;
    }

    public void addShare(SharePo sharePo) {
        FileUtil.appendMethodA("E:\\data\\quoto\\zh.txt",sharePo.getShareid()+ " " +
        sharePo.getCompanyname()+ " " +
        sharePo.getCompanyshort()+ " " +
        sharePo.getSharecode()+ " " +
        sharePo.getSharename()+ " " +
        sharePo.getTodaybeginprice()+ " " +
        sharePo.getYesterdaycloseprice()+ " " +
        sharePo.getNowprice()+ " " +
        sharePo.getHighprice()+ " " +
        sharePo.getLowprice()+ "\n"
        );

    }
}
