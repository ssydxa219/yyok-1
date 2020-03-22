package com.yyok.Icons;


import org.jsoup.nodes.Element;

import java.io.*;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;

public class FileOutUtils extends Thread {
    private Element e;
    private String filepath;


    public FileOutUtils(Element e, String filepath) {
        this.e = e;
        this.filepath = filepath;
    }

    /**
     * 多线程下载
     *
     * @param e
     * @param filepath
     * @author wangshiyu
     */
    public void savefile(Element e, String filepath) {
        String src = e.attr("src");//获取img中的src路径
        // System.out.println(src);
        //获取后缀名
        String imageName = src.substring(src.lastIndexOf("/") + 1, src.length());
        //连接url
        URL url;
        try {
            url = new URL(src);
            URLConnection uri = url.openConnection();
//获取数据流
            InputStream is = uri.getInputStream();
//写入数据流
            File file = new File("E://imgs//" + filepath);
            if (!file.exists()) {
                file.mkdirs();
            }
            OutputStream os = new FileOutputStream(new File("E://imgs//" + filepath + "//", imageName));
            byte[] buf = new byte[1024];
            int l = 0;
            while ((l = is.read(buf)) != -1) {
                os.write(buf, 0, l);
            }

        } catch (MalformedURLException e1) {
            e1.printStackTrace();
        } catch (FileNotFoundException e1) {
            e1.printStackTrace();
        } catch (IOException e1) {
            e1.printStackTrace();
        }
    }

    public void run() {
        this.savefile(this.e, this.filepath);
    }
}
