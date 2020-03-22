package com.yyok.common.util;

import com.yyok.crawler.conf.XxlCrawlerConf;
import com.yyok.crawler.model.PageRequest;
import org.jsoup.Connection;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;
import java.net.Authenticator;
import java.net.InetSocketAddress;
import java.net.PasswordAuthentication;
import java.net.Proxy;
import java.util.HashSet;
import java.util.Map;
import java.util.Random;
import java.util.Set;
import java.util.regex.Pattern;


public class JsoupUtil {
    private static Logger logger = LoggerFactory.getLogger(JsoupUtil.class);
    // 代理隧道验证信息
    final static String ProxyUser = "16KASDA";

    final static String ProxyPass = "1231321";

    // 代理服务器
    final static String ProxyHost = "t.16yun.cn";

    final static Integer ProxyPort = 31111;


    // 设置IP切换头
    final static String ProxyHeadKey = "Proxy-Tunnel";

    public static String getUrlProxyContent(String url) {
        Authenticator.setDefault(new Authenticator() {
            public PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(ProxyUser, ProxyPass.toCharArray());
            }
        });
        // 设置Proxy-Tunnel
        Random random = new Random();
        int tunnel = random.nextInt(10000);
        String ProxyHeadVal = String.valueOf(tunnel);
        Proxy proxy = new Proxy(Proxy.Type.HTTP, new InetSocketAddress(ProxyHost, ProxyPort));
        try {
            // 处理异常、其他参数
            Document doc = Jsoup.connect(url).timeout(3000).header(ProxyHeadKey, ProxyHeadVal).proxy(proxy).get();
            if (doc != null) {
                System.out.println(doc.body().html());
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static String httpGetHeader(String url, String cook, String header) throws IOException {
        //获取请求连接
        Connection con = Jsoup.connect(url);
        //请求头设置，特别是cookie设置
        con.header("Accept", "text/html, application/xhtml+xml, */*");
        con.header("Content-Type", "application/x-www-form-urlencoded");
        con.header("Accept-Language", "zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3");
        con.header("User-Agent", "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0))");
        //con.header("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:48.0) Gecko/20100101 Firefox/48.0")
        con.timeout(5000);
        con.header("Cookie", cook);
        //发送请求
        Connection.Response resp = con.method(Connection.Method.GET).ignoreContentType(true).execute();
        //获取cookie名称为__bsi的值
        String cookieValue = resp.cookie("__bsi");
        System.out.println("cookie  __bsi值：  " + cookieValue);
        //获取返回cookie所值
        Map<String, String> cookies = resp.cookies();
        System.out.println("所有cookie值：  " + cookies);
        //获取返回头文件值
        String headerValue = resp.header(header);
        System.out.println("头文件" + header + "的值：" + headerValue);
        //获取所有头文件值
        Map<String, String> headersOne = resp.headers();
        System.out.println("所有头文件值：" + headersOne);
        return headerValue;
    }

    /**
     * 根据元素id获取HTML元素
     *
     * @param document
     * @param id
     * @return
     */
    public static Element getElementById(Document document, String id) {
        Element element = null;
        if (document != null && id != null && !"".equals(id.trim())) {
            element = document.getElementById(id);
        }
        return element;
    }

    /**
     * 根据id获取HTML元素
     *
     * @param element
     * @param id
     * @return
     */
    public static Element getElementById(Element element, String id) {
        Element resultElement = null;
        if (element != null) {
            resultElement = element.getElementById(id);
        }
        return resultElement;
    }

    /**
     * 根据元素标签(tagName)获取HTMl元素
     *
     * @param document
     * @param tagName
     * @return
     */
    public static Elements getElementsByTagName(Document document, String tagName) {
        Elements elements = null;
        if (document != null && tagName != null && !"".equals(tagName)) {
            elements = document.getElementsByTag(tagName);
        }
        return elements;
    }

    /**
     * 根据元素标签(tagName)获取HTMl元素
     *
     * @param element
     * @param tagName
     * @return
     */
    public static Elements getElementsByTagName(Element element, String tagName) {
        Elements resultElements = null;
        if (element != null && tagName != null && !"".equals(tagName)) {
            resultElements = element.getElementsByTag(tagName);
        }
        return resultElements;
    }

    /**
     * 根据className(样式名称)获取HTML元素集合
     *
     * @param document
     * @param className
     * @return
     */
    public static Elements getElementsByClassName(Document document, String className) {
        Elements elements = null;
        if (document != null && className != null && !"".equals(className.trim())) {
            elements = document.getElementsByClass(className);
        }
        return elements;
    }

    /**
     * 根据className(样式名称)获取HTML元素集合
     *
     * @param element
     * @param className
     * @return
     */
    public static Elements getElementsByClassName(Element element, String className) {
        Elements resultElements = null;
        if (element != null && className != null && !"".equals(className)) {
            resultElements = element.getElementsByClass(className);
        }
        return resultElements;
    }

    /**
     * 根据元素是否具有属性元素key返回元素集合
     *
     * @param document
     * @param attributeNameKey 元素属性key值
     * @return
     */
    public static Elements getElementsByAttributeNameKey(Document document, String attributeNameKey) {
        Elements elements = null;
        if (document != null && attributeNameKey != null && !"".equals(attributeNameKey)) {
            elements = document.getElementsByAttribute(attributeNameKey);
        }
        return elements;
    }

    /**
     * 根据元素是否具有属性元素key返回元素集合
     *
     * @param element
     * @param attributeNameKey 元素属性key值
     * @return
     */
    public static Elements getElementsByAttributeNameKey(Element element, String attributeNameKey) {
        Elements resultElements = null;
        if (element != null && attributeNameKey != null && !"".equals(attributeNameKey)) {
            resultElements = element.getElementsByAttribute(attributeNameKey);
        }
        return resultElements;
    }

    /**
     * 根据元素是否具有属性元素key并且key对应的值为value获取元素集合
     *
     * @param document
     * @param attributeKey
     * @param attributeValue
     * @return
     */
    public static Elements getElementsByAttributeNameValue(Document document, String attributeKey, String attributeValue) {
        Elements elements = null;
        if (document != null && attributeKey != null && !"".equals(attributeKey.trim()) && attributeValue != null && !"".equals(attributeValue.trim())) {
            elements = document.getElementsByAttributeValue(attributeKey, attributeValue);
        }
        return elements;
    }

    /**
     * 根据元素是否具有属性元素key并且key对应的值为value获取元素集合
     *
     * @param element
     * @param attributeKey
     * @param attributeValue
     * @return
     */
    public static Elements getElementsByAttributeNameValue(Element element, String attributeKey, String attributeValue) {
        Elements resultElements = null;
        if (element != null && attributeKey != null && !"".equals(attributeKey.trim()) && attributeValue != null && !"".equals(attributeValue.trim())) {
            resultElements = element.getElementsByAttributeValue(attributeKey, attributeValue);
        }
        return resultElements;
    }

    /**
     * 根据属性key值是否以特定字符串开头获取元素集合
     *
     * @param document
     * @param keyValue
     * @return
     */
    public static Elements getElementsByAttributeNameStartWithValue(Document document, String keyValue) {
        Elements elements = null;
        if (document != null && keyValue != null && !"".equals(keyValue.trim())) {
            elements = document.getElementsByAttributeStarting(keyValue);
        }
        return elements;
    }

    /**
     * 根据属性key值是否以特定字符串开头获取元素集合
     *
     * @param element
     * @param keyValue
     * @return
     */
    public static Elements getElementsByAttributeNameStartWithValue(Element element, String keyValue) {
        Elements elements = null;
        if (element != null && keyValue != null && !"".equals(keyValue.trim())) {
            elements = element.getElementsByAttributeStarting(keyValue);
        }
        return elements;
    }

    /**
     * 根据属性value值是否被包含在某个元素的某个属性中获取元素集合
     *
     * @param document
     * @param containValue
     * @return
     */
    public static Elements getElementsByAttributeValueContaining(Document document, String attributeKey, String containValue) {
        Elements elements = null;
        if (document != null && containValue != null && !"".equals(containValue)) {
            elements = document.getElementsByAttributeValueContaining(attributeKey, containValue);
        }
        return elements;
    }

    /**
     * 根据属性value值是否被包含在某个元素的某个属性中获取元素集合
     *
     * @param element
     * @param attributeKey
     * @param containValue
     * @return
     */
    public static Elements getElementsByAttributeValueContaining(Element element, String attributeKey, String containValue) {
        Elements elements = null;
        if (element != null && containValue != null && !"".equals(containValue)) {
            elements = element.getElementsByAttributeValueContaining(attributeKey, containValue);
        }
        return elements;
    }

    /**
     * 根据属性的value值是否以某个字符串结尾获取元素集合
     *
     * @param document
     * @param attributeKey
     * @param valueSuffix
     * @return
     */
    public static Elements getElementsByAttributeValueEnding(Document document, String attributeKey, String valueSuffix) {
        Elements elements = null;
        if (document != null && attributeKey != null && !"".equals(attributeKey) && valueSuffix != null && !"".equals(valueSuffix)) {
            elements = document.getElementsByAttributeValueEnding(attributeKey, valueSuffix);
        }
        return elements;
    }

    /**
     * 根据属性的value值是否以某个字符串结尾获取元素集合
     *
     * @param element
     * @param attributeKey
     * @param valueSuffix
     * @return
     */
    public static Elements getElementsByAttributeValueEnding(Element element, String attributeKey, String valueSuffix) {
        Elements elements = null;
        if (element != null && attributeKey != null && !"".equals(attributeKey) && valueSuffix != null && !"".equals(valueSuffix)) {
            elements = element.getElementsByAttributeValueEnding(attributeKey, valueSuffix);
        }
        return elements;
    }

    /**
     * 根据属性值value的正则表达式获取元素集合
     *
     * @param document
     * @param attributeKey
     * @param pattern
     * @return
     */
    public static Elements getElementsByAttributeValueMatching(Document document, String attributeKey, Pattern pattern) {
        Elements elements = null;
        if (document != null && attributeKey != null && !"".equals(attributeKey) && pattern != null) {
            elements = document.getElementsByAttributeValueMatching(attributeKey, pattern);
        }
        return elements;
    }

    /**
     * 根据属性值value的正则表达式获取元素集合
     *
     * @param element
     * @param attributeKey
     * @param pattern
     * @return
     */
    public static Elements getElementsByAttributeValueMatching(Element element, String attributeKey, Pattern pattern) {
        Elements elements = null;
        if (element != null && attributeKey != null && !"".equals(attributeKey) && pattern != null) {
            elements = element.getElementsByAttributeValueMatching(attributeKey, pattern);
        }
        return elements;
    }

    /**
     * 根据属性值的value的正则表达式获取元素集合
     *
     * @param document
     * @param attributeKey
     * @param regualRegx
     * @return
     */
    public static Elements getElementsByAttributeValueMatching(Document document, String attributeKey, String regualRegx) {
        Elements elements = null;
        if (document != null && attributeKey != null && !"".equals(attributeKey) && regualRegx != null && !"".equals(regualRegx)) {
            elements = document.getElementsByAttributeValueMatching(attributeKey, regualRegx);
        }
        return elements;
    }

    /**
     * 根据属性值的value的正则表达式获取元素集合
     *
     * @param element
     * @param attributeKey
     * @param regualRegx
     * @return
     */
    public static Elements getElementsByAttributeValueMatching(Element element, String attributeKey, String regualRegx) {
        Elements elements = null;
        if (element != null && attributeKey != null && !"".equals(attributeKey) && regualRegx != null && !"".equals(regualRegx)) {
            elements = element.getElementsByAttributeValueMatching(attributeKey, regualRegx);
        }
        return elements;
    }

    /**
     * 返回属性键attributeKey不等于值attributeValue的元素集合
     *
     * @param document
     * @param attributeKey
     * @param attributeValue
     * @return
     */
    public static Elements getElementsByAttributeValueNot(Document document, String attributeKey, String attributeValue) {
        Elements elements = null;
        if (document != null && attributeKey != null && !"".equals(attributeKey) && attributeValue != null && !"".equals(attributeValue)) {
            elements = document.getElementsByAttributeValueNot(attributeKey, attributeValue);
        }
        return elements;
    }

    /**
     * 返回属性键attributeKey不等于值attributeValue的元素集合
     *
     * @param element
     * @param attributeKey
     * @param attributeValue
     * @return
     */
    public static Elements getElementsByAttributeValueNot(Element element, String attributeKey, String attributeValue) {
        Elements elements = null;
        if (element != null && attributeKey != null && !"".equals(attributeKey) && attributeValue != null && !"".equals(attributeValue)) {
            elements = element.getElementsByAttributeValueNot(attributeKey, attributeValue);
        }
        return elements;
    }

    /**
     * 根据选择器匹配的字符串返回
     * Elements(元素集合)
     *
     * @param document
     * @param selectStr 选择器(类似于JQuery)
     * @return
     */
    public static Elements getMoreElementsBySelectStr(Document document, String selectStr) {
        if (document == null || selectStr == null || "".equals(selectStr.trim())) {
            return null;
        } else {
            Elements elements = document.select(selectStr);
            if (elements != null && elements.size() > 0) {
                return elements;
            } else {
                return null;
            }
        }
    }

    /**
     * 根据选择器匹配的字符串返回
     * Elements(元素集合)
     *
     * @param element
     * @param selectStr
     * @return
     */
    public static Elements getMoreElementsBySelectStr(Element element, String selectStr) {
        if (element == null || selectStr == null || "".equals(selectStr.trim())) {
            return null;
        } else {
            Elements elements = element.select(selectStr);
            if (elements != null && elements.size() > 0) {
                return elements;
            } else {
                return null;
            }
        }
    }

    /**
     * 根据选择器匹配的字符串返回
     * Element(单个元素)
     *
     * @param document
     * @param selectStr 选择器(类似于JQuery)
     * @return
     */
    public static Element getSingleElementBySelectStr(Document document, String selectStr) {
        Elements elements = getMoreElementsBySelectStr(document, selectStr);
        if (elements != null && elements.size() > 0) {
            return elements.get(0);
        } else {
            return null;
        }
    }

    /**
     * 根据选择器匹配的字符串返回
     * Element(单个元素)
     *
     * @param element
     * @param selectStr
     * @return
     */
    public static Element getSingleElementBySelectStr(Element element, String selectStr) {
        Elements elements = getMoreElementsBySelectStr(element, selectStr);
        if (elements != null && elements.size() > 0) {
            return elements.get(0);
        } else {
            return null;
        }
    }

    /**
     * 根据选择器匹配的字符串返回单个元素的Html字符串
     *
     * @param document
     * @param selectStr 选择器(类似于JQuery)
     * @return
     */
    public static String getSingleElementHtmlBySelectStr(Document document, String selectStr) {
        Element element = getSingleElementBySelectStr(document, selectStr);
        if (element != null) {
            return element.html();
        } else {
            return null;
        }
    }

    /**
     * 根据选择器匹配的字符串返回单个元素的Html字符串
     *
     * @param element
     * @param selectStr
     * @return
     */
    public static String getSingleElementHtmlBySelectStr(Element element, String selectStr) {
        Element ele = getSingleElementBySelectStr(element, selectStr);
        if (ele != null) {
            return ele.html();
        } else {
            return null;
        }
    }

    /**
     * 根据元素属性名key获取元素属性名value
     *
     * @param element
     * @param attributeName
     * @return
     */
    public static String getAttributeValue(Element element, String attributeName) {
        String attributeValue = null;
        if (element != null && attributeName != null && !"".equals(attributeName)) {
            attributeValue = element.attr(attributeName);
        }
        return attributeValue;
    }

    /**
     * 从elements集合中获取element并解析成HTML字符串
     *
     * @param elements
     * @return
     */
    public static String getSingElementHtml(Elements elements) {
        Element ele = null;
        String htmlStr = null;
        if (elements != null && elements.size() > 0) {
            ele = elements.get(0);
            htmlStr = ele.html();
        }
        return htmlStr;
    }

    /**
     * 从elements集合中获取element并解析成Text字符串
     *
     * @param elements
     * @return
     */
    public static String getSingElementText(Elements elements) {
        Element ele = null;
        String htmlStr = null;
        if (elements != null && elements.size() > 0) {
            ele = elements.get(0);
            htmlStr = ele.text();
        }
        return htmlStr;
    }

    public static void main(String[] args) {
        File file = new File("F:/example.htm");
        try {
            Document document = Jsoup.parse(file, "GB2312");
            Pattern pattern = Pattern.compile("");
//	document.getElementsByAttributeValueMatching("", pattern);
            Element element = getElementById(document, "personal-uplayer");


        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 加载页面
     *
     * @param pageRequest
     * @return Document
     */
    public static Document load(PageRequest pageRequest) {
        if (!UrlUtil.isURL(pageRequest.getUrl())) {
            return null;
        }
        try {
            // 请求设置
            Connection conn = Jsoup.connect(pageRequest.getUrl());
            if (pageRequest.getParamMap() != null && !pageRequest.getParamMap().isEmpty()) {
                conn.data(pageRequest.getParamMap());
            }
            if (pageRequest.getCookieMap() != null && !pageRequest.getCookieMap().isEmpty()) {
                conn.cookies(pageRequest.getCookieMap());
            }
            if (pageRequest.getHeaderMap() != null && !pageRequest.getHeaderMap().isEmpty()) {
                conn.headers(pageRequest.getHeaderMap());
            }
            if (pageRequest.getUserAgent() != null) {
                conn.userAgent(pageRequest.getUserAgent());
            }
            if (pageRequest.getReferrer() != null) {
                conn.referrer(pageRequest.getReferrer());
            }
            conn.timeout(pageRequest.getTimeoutMillis());
            conn.validateTLSCertificates(pageRequest.isValidateTLSCertificates());
            conn.maxBodySize(0);    // 取消默认1M限制

            // 代理
            if (pageRequest.getProxy() != null) {
                conn.proxy(pageRequest.getProxy());
            }

            // 发出请求
            Document html = null;
            if (pageRequest.isIfPost()) {
                html = conn.post();
            } else {
                html = conn.get();
            }
            return html;
        } catch (IOException e) {
            logger.error(e.getMessage(), e);
            return null;
        }
    }

    /**
     * 加载页面
     *
     * @param pageRequest
     * @return Document
     */
    public static Document load(PageRequest pageRequest, Connection conn) {
        if (!UrlUtil.isURL(pageRequest.getUrl())) {
            return null;
        }
        try {
            // 请求设置
            conn = Jsoup.connect(pageRequest.getUrl());
            if (pageRequest.getParamMap() != null && !pageRequest.getParamMap().isEmpty()) {
                conn.data(pageRequest.getParamMap());
            }
            if (pageRequest.getCookieMap() != null && !pageRequest.getCookieMap().isEmpty()) {
                conn.cookies(pageRequest.getCookieMap());
            }
            if (pageRequest.getHeaderMap() != null && !pageRequest.getHeaderMap().isEmpty()) {
                conn.headers(pageRequest.getHeaderMap());
            }
            if (pageRequest.getUserAgent() != null) {
                conn.userAgent(pageRequest.getUserAgent());
            }
            if (pageRequest.getReferrer() != null) {
                conn.referrer(pageRequest.getReferrer());
            }
            conn.timeout(pageRequest.getTimeoutMillis());
            conn.validateTLSCertificates(pageRequest.isValidateTLSCertificates());
            conn.maxBodySize(0);    // 取消默认1M限制

            // 代理
            if (pageRequest.getProxy() != null) {
                conn.proxy(pageRequest.getProxy());
            }

            // 发出请求
            Document html = null;
            if (pageRequest.isIfPost()) {
                html = conn.post();
            } else {
                html = conn.get();
            }
            return html;
        } catch (IOException e) {
            logger.error(e.getMessage(), e);
            return null;
        }
    }

    public static String loadPageSource(PageRequest pageRequest) {
        if (!UrlUtil.isURL(pageRequest.getUrl())) {
            return null;
        }
        try {
            // 请求设置
            Connection conn = Jsoup.connect(pageRequest.getUrl());
            if (pageRequest.getParamMap() != null && !pageRequest.getParamMap().isEmpty()) {
                conn.data(pageRequest.getParamMap());
            }
            if (pageRequest.getCookieMap() != null && !pageRequest.getCookieMap().isEmpty()) {
                conn.cookies(pageRequest.getCookieMap());
            }
            if (pageRequest.getHeaderMap() != null && !pageRequest.getHeaderMap().isEmpty()) {
                conn.headers(pageRequest.getHeaderMap());
            }
            if (pageRequest.getUserAgent() != null) {
                conn.userAgent(pageRequest.getUserAgent());
            }
            if (pageRequest.getReferrer() != null) {
                conn.referrer(pageRequest.getReferrer());
            }
            conn.timeout(pageRequest.getTimeoutMillis());
            conn.validateTLSCertificates(pageRequest.isValidateTLSCertificates());
            conn.maxBodySize(0);    // 取消默认1M限制

            // 代理
            if (pageRequest.getProxy() != null) {
                conn.proxy(pageRequest.getProxy());
            }

            conn.ignoreContentType(true);
            conn.method(pageRequest.isIfPost() ? Connection.Method.POST : Connection.Method.GET);

            // 发出请求
            Connection.Response resp = conn.execute();
            String pageSource = resp.body();
            return pageSource;
        } catch (IOException e) {
            logger.error(e.getMessage(), e);
            return null;
        }
    }

    /**
     * 抽取元素数据
     *
     * @param fieldElement
     * @param selectType
     * @param selectVal
     * @return String
     */
    public static String parseElement(Element fieldElement, XxlCrawlerConf.SelectType selectType, String selectVal) {
        String fieldElementOrigin = null;
        if (XxlCrawlerConf.SelectType.HTML == selectType) {
            fieldElementOrigin = fieldElement.html();
        } else if (XxlCrawlerConf.SelectType.VAL == selectType) {
            fieldElementOrigin = fieldElement.val();
        } else if (XxlCrawlerConf.SelectType.TEXT == selectType) {
            fieldElementOrigin = fieldElement.text();
        } else if (XxlCrawlerConf.SelectType.ATTR == selectType) {
            fieldElementOrigin = fieldElement.attr(selectVal);
        } else if (XxlCrawlerConf.SelectType.HAS_CLASS == selectType) {
            fieldElementOrigin = String.valueOf(fieldElement.hasClass(selectVal));
        } else {
            fieldElementOrigin = fieldElement.toString();
        }
        return fieldElementOrigin;
    }

    /**
     * 获取页面上所有超链接地址 （<a>标签的href值）
     *
     * @param html 页面文档
     * @return Set<String>
     */
    public static Set<String> findLinks(Document html) {

        if (html == null) {
            return null;
        }

        // element
        /**
         *
         * Elements resultSelect = html.select(tagName);	// 选择器方式
         * Element resultId = html.getElementById(tagName);	// 元素ID方式
         * Elements resultClass = html.getElementsByClass(tagName);	// ClassName方式
         * Elements resultTag = html.getElementsByTag(tagName);	// html标签方式 "body"
         *
         */
        Elements hrefElements = html.select("a[href]");

        // 抽取数据
        Set<String> links = new HashSet<String>();
        if (hrefElements != null && hrefElements.size() > 0) {
            for (Element item : hrefElements) {
                String href = item.attr("abs:href");    // href、abs:href
                if (UrlUtil.isURL(href)) {
                    links.add(href);
                }
            }
        }
        return links;
    }

    /**
     * 获取页面上所有图片地址 （<a>标签的href值）
     *
     * @param html
     * @return Set<String>
     */
    public static Set<String> findImages(Document html) {

        Elements imgs = html.getElementsByTag("img");

        Set<String> images = new HashSet<String>();
        if (imgs != null && imgs.size() > 0) {
            for (Element element : imgs) {
                String imgSrc = element.attr("abs:src");
                images.add(imgSrc);
            }
        }

        return images;
    }

    private static Map<String, String> cookies = null;

    /**
     * 模拟登录获取cookie和sessionid
     */
    public static Connection login(String urlLogin, String username, String password) throws IOException {
        //String urlLogin = "http://qiaoliqiang.cn/Exam/user_login.action";
        Connection connect = Jsoup.connect(urlLogin);
        // 伪造请求头
        connect.header("Accept", "application/json, text/javascript, */*; q=0.01")
                .header("Accept-Encoding", "gzip, deflate")
                .header("Accept-Language", "zh-CN,zh;q=0.9")
                .header("Connection", "keep-alive")
                .header("Content-Length", "72")
                .header("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8")
                //.header("Host", "qiaoliqiang.cn")
                //.header("Referer", "http://qiaoliqiang.cn/Exam/")
                .header("User-Agent", "Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36")
                .header("X-Requested-With", "XMLHttpRequest")
                // 携带登陆信息
                .data("email", username)
                .data("password", password)
                .data("user_type", "2")
                .data("isRememberme", "yes");

        //请求url获取响应信息
        //Response res = connect.ignoreContentType(true).method(Connection.Method.POST).execute();// 执行请求
        // 获取返回的cookie
        //cookies = res.cookies();
        return connect;
    }

}
