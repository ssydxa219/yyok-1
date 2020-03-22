package com.yyok.crawler.loader.strategy;

import com.yyok.crawler.loader.PageLoader;
import com.yyok.crawler.model.PageRequest;
import com.yyok.common.util.JsoupUtil;
import org.jsoup.nodes.Document;

public class JsoupPageLoader extends PageLoader {

    @Override
    public Document load(PageRequest pageRequest) {
        return JsoupUtil.load(pageRequest);
    }

}
