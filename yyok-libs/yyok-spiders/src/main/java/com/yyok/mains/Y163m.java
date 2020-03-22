package com.yyok.mains;


import com.yyok.crawler.model.PageRequest;
import com.yyok.common.util.FileUtil;
import com.yyok.common.util.JsoupUtil;
import com.yyok.common.util.UrlUtil;
import org.jsoup.Connection;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.Map;

public class Y163m {

    static String url = "http://yuehui.163.com/searchusers.do/";
    static String orgfp = "E:\\data\\";

    static String fname = "yuehui";

    private static Map<String, String> cookies = null;

    public static void main(String[] args) throws IOException {
//
        Connection connect =JsoupUtil.login("http://yuehui.163.com/","ssydxa219@126.com","sa820219sa!@#");

        //请求url获取响应信息
        Connection.Response res = connect.ignoreContentType(true).method(Connection.Method.POST).execute();// 执行请求
        // 获取返回的cookie
        cookies = res.cookies();
        for (Map.Entry<String, String> entry : cookies.entrySet()) {
            System.out.println(entry.getKey() + "-" + entry.getValue());
        }
        System.out.println("---------华丽的分割线-----------");
        String body = res.body();// 获取响应体
        System.out.println(body);

        try {
            PageRequest pr = new PageRequest();
            pr.setUrl(url);
            Document doc = JsoupUtil.load(pr,connect);
            Elements ess = null;
            if (doc != null)
                ess = doc.getElementsByTag("a");
            for (Element ea : ess) {
                String urla = UrlUtil.gainurl(ea.attr("abs:href"));
                FileUtil.appendMethodB(orgfp + fname + ".txt", urla + "~" + ea.text() + "\n");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            BufferedReader br = new BufferedReader(new FileReader(new File(orgfp + fname + ".txt")));//构造一个BufferedReader类来读取文件
            String s = null;
            while ((s = br.readLine()) != null) {//使用readLine方法，一次读一行
                PageRequest prb = new PageRequest();
                String[] sarray = s.split("~");
                if (sarray.length > 1)
                    prb.setUrl(sarray[0]);
                Document docb = JsoupUtil.load(prb);
                Elements essb = null;
                if (docb != null) {
                    essb = docb.getElementsByTag("a");
                    for (Element eb : essb) {
                        String urlb = UrlUtil.gainurl(eb.attr("abs:href"));
                        FileUtil.appendMethodB(orgfp + fname + ".txt", urlb + "~" + eb.text() + "\n");
                    }
                }
            }
            br.close();
        } catch (Exception e) {
            e.printStackTrace();
        }


        try {
            int splitSize = 1;
            File[] files = FileUtil.splitFile(orgfp + fname + ".txt", splitSize);
            FileUtil.distinct(files, orgfp + fname + "-distinct.txt", splitSize);
            FileUtil.delFileByName(orgfp + fname + ".txt");
            File newFileName = new File(orgfp + fname + ".txt");
            File oldFile = new File(orgfp + fname + "-distinct.txt");
            synchronized (oldFile) {
                oldFile.renameTo(newFileName);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            BufferedReader br = new BufferedReader(new FileReader(new File(orgfp + fname + ".txt")));//构造一个BufferedReader类来读取文件
            String s = null;
            while ((s = br.readLine()) != null) {//使用readLine方法，一次读一行
                PageRequest prc = new PageRequest();
                String[] sarray = s.split("~");
                if (sarray.length > 1)
                    prc.setUrl(sarray[0]);
                Document docc = JsoupUtil.load(prc);
                Elements essc = null;
                if (docc != null) {
                    essc = docc.getElementsByTag("a");
                    for (Element ec : essc) {
                        String urlc = UrlUtil.gainurl(ec.attr("abs:href"));
                        FileUtil.appendMethodB(orgfp + fname + ".txt", urlc + "~" + ec.text() + "\n");
                    }
                }
            }
            br.close();
        } catch (Exception e) {
            e.printStackTrace();
        }


        try {
            int splitSize = 1;
            File[] files = FileUtil.splitFile(orgfp + fname + ".txt", splitSize);
            FileUtil.distinct(files, orgfp + fname + "-distinct.txt", splitSize);
            FileUtil.delFileByName(orgfp + fname + ".txt");
            File newFileName = new File(orgfp + fname + ".txt");
            File oldFile = new File(orgfp + fname + "-distinct.txt");
            synchronized (oldFile) {
                oldFile.renameTo(newFileName);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }


        try {
            BufferedReader br = new BufferedReader(new FileReader(new File(orgfp + fname + ".txt")));//构造一个BufferedReader类来读取文件
            String s = null;
            while ((s = br.readLine()) != null) {//使用readLine方法，一次读一行
                PageRequest prd = new PageRequest();
                String[] sarray = s.split("~");
                if (sarray.length > 1)
                    prd.setUrl(sarray[0]);
                Document docd = JsoupUtil.load(prd);
                Elements essd = null;
                if (docd != null) {
                    essd = docd.getElementsByTag("a");
                    for (Element ed : essd) {
                        String urld = UrlUtil.gainurl(ed.attr("abs:href"));
                        FileUtil.appendMethodB(orgfp + fname + ".txt", urld + "~" + ed.text() + "\n");
                    }
                }
            }
            br.close();
        } catch (Exception e) {
            e.printStackTrace();
        }


        try {
            int splitSize = 2;
            File[] files = FileUtil.splitFile(orgfp + fname + ".txt", splitSize);
            FileUtil.distinct(files, orgfp + fname + "-distinct.txt", splitSize);
            FileUtil.delFileByName(orgfp + fname + ".txt");
            File newFileName = new File(orgfp + fname + ".txt");
            File oldFile = new File(orgfp + fname + "-distinct.txt");
            synchronized (oldFile) {
                oldFile.renameTo(newFileName);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }


        try {
            BufferedReader br = new BufferedReader(new FileReader(new File(orgfp + fname + ".txt")));//构造一个BufferedReader类来读取文件
            String s = null;
            while ((s = br.readLine()) != null) {//使用readLine方法，一次读一行
                PageRequest pre = new PageRequest();
                String[] sarray = s.split("~");
                if (sarray.length > 1)
                    pre.setUrl(sarray[0]);
                Document doce = JsoupUtil.load(pre);
                Elements esse = null;
                if (doce != null) {
                    esse = doce.getElementsByTag("a");
                    for (Element ee : esse) {
                        String urle = UrlUtil.gainurl(ee.attr("abs:href"));
                        FileUtil.appendMethodB(orgfp + fname + ".txt", urle + "~" + ee.text() + "\n");
                    }
                }
            }
            br.close();
        } catch (Exception e) {
            e.printStackTrace();
        }


        try {
            int splitSize = 3;
            File[] files = FileUtil.splitFile(orgfp + fname + ".txt", splitSize);
            FileUtil.distinct(files, orgfp + fname + "-distinct.txt", splitSize);
            FileUtil.delFileByName(orgfp + fname + ".txt");
            File newFileName = new File(orgfp + fname + ".txt");
            File oldFile = new File(orgfp + fname + "-distinct.txt");
            synchronized (oldFile) {
                oldFile.renameTo(newFileName);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }


        try {
            BufferedReader br = new BufferedReader(new FileReader(new File(orgfp + fname + ".txt")));//构造一个BufferedReader类来读取文件
            String s = null;
            while ((s = br.readLine()) != null) {//使用readLine方法，一次读一行
                PageRequest prf = new PageRequest();
                String[] sarray = s.split("~");
                if (sarray.length > 1)
                    prf.setUrl(sarray[0]);
                Document docf = JsoupUtil.load(prf);
                Elements essf = null;
                if (docf != null) {
                    essf = docf.getElementsByTag("a");
                    for (Element ef : essf) {
                        String urlf = UrlUtil.gainurl(ef.attr("abs:href"));
                        FileUtil.appendMethodB(orgfp + fname + ".txt", urlf + "~" + ef.text() + "\n");
                    }
                }
            }
            br.close();
        } catch (Exception e) {
            e.printStackTrace();
        }


        try {
            int splitSize = 3;
            File[] files = FileUtil.splitFile(orgfp + fname + ".txt", splitSize);
            FileUtil.distinct(files, orgfp + fname + "-distinct.txt", splitSize);
            FileUtil.delFileByName(orgfp + fname + ".txt");
            File newFileName = new File(orgfp + fname + ".txt");
            File oldFile = new File(orgfp + fname + "-distinct.txt");
            synchronized (oldFile) {
                oldFile.renameTo(newFileName);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }


        try {
            BufferedReader br = new BufferedReader(new FileReader(new File(orgfp + fname + ".txt")));//构造一个BufferedReader类来读取文件
            String s = null;
            while ((s = br.readLine()) != null) {//使用readLine方法，一次读一行
                PageRequest prg = new PageRequest();
                String[] sarray = s.split("~");
                if (sarray.length > 1)
                    prg.setUrl(sarray[0]);
                Document docg = JsoupUtil.load(prg);
                Elements essg = null;
                if (docg != null) {
                    essg = docg.getElementsByTag("a");
                    for (Element eg : essg) {
                        String urlb = UrlUtil.gainurl(eg.attr("abs:href"));
                        FileUtil.appendMethodB(orgfp + fname + ".txt", urlb + "~" + eg.text() + "\n");
                    }
                }
            }
            br.close();
        } catch (Exception e) {
            e.printStackTrace();
        }


        try {
            int splitSize = 3;
            File[] files = FileUtil.splitFile(orgfp + fname + ".txt", splitSize);
            FileUtil.distinct(files, orgfp + fname + "-distinct.txt", splitSize);
            FileUtil.delFileByName(orgfp + fname + ".txt");
            File newFileName = new File(orgfp + fname + ".txt");
            File oldFile = new File(orgfp + fname + "-distinct.txt");
            synchronized (oldFile) {
                oldFile.renameTo(newFileName);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }


        try {
            BufferedReader br = new BufferedReader(new FileReader(new File(orgfp + fname + ".txt")));//构造一个BufferedReader类来读取文件
            String s = null;
            while ((s = br.readLine()) != null) {//使用readLine方法，一次读一行
                PageRequest prh = new PageRequest();
                String[] sarray = s.split("~");
                if (sarray.length > 1)
                    prh.setUrl(sarray[0]);
                Document doch = JsoupUtil.load(prh);
                Elements essh = null;
                if (doch != null) {
                    essh = doch.getElementsByTag("a");
                    for (Element eh : essh) {
                        String urlb = UrlUtil.gainurl(eh.attr("abs:href"));
                        FileUtil.appendMethodB(orgfp + fname + ".txt", urlb + "~" + eh.text() + "\n");
                    }
                }
            }
            br.close();
        } catch (Exception e) {
            e.printStackTrace();
        }


        try {
            int splitSize = 3;
            File[] files = FileUtil.splitFile(orgfp + fname + ".txt", splitSize);
            FileUtil.distinct(files, orgfp + fname + "-distinct.txt", splitSize);
            FileUtil.delFileByName(orgfp + fname + ".txt");
            File newFileName = new File(orgfp + fname + ".txt");
            File oldFile = new File(orgfp + fname + "-distinct.txt");
            synchronized (oldFile) {
                oldFile.renameTo(newFileName);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }


        try {
            BufferedReader br = new BufferedReader(new FileReader(new File(orgfp + fname + ".txt")));//构造一个BufferedReader类来读取文件
            String s = null;
            while ((s = br.readLine()) != null) {//使用readLine方法，一次读一行
                PageRequest prk = new PageRequest();
                String[] sarray = s.split("~");
                if (sarray.length > 1)
                    prk.setUrl(sarray[0]);
                Document dock = JsoupUtil.load(prk);
                Elements essk = null;
                if (dock != null) {
                    essk = dock.getElementsByTag("a");
                    for (Element eg : essk) {
                        String urlb = UrlUtil.gainurl(eg.attr("abs:href"));
                        FileUtil.appendMethodB(orgfp + fname + ".txt", urlb + "~" + eg.text() + "\n");
                    }
                }
            }
            br.close();
        } catch (Exception e) {
            e.printStackTrace();
        }


        try {
            int splitSize = 3;
            File[] files = FileUtil.splitFile(orgfp + fname + ".txt", splitSize);
            FileUtil.distinct(files, orgfp + fname + "-distinct.txt", splitSize);
            FileUtil.delFileByName(orgfp + fname + ".txt");
            File newFileName = new File(orgfp + fname + ".txt");
            File oldFile = new File(orgfp + fname + "-distinct.txt");
            synchronized (oldFile) {
                oldFile.renameTo(newFileName);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}

