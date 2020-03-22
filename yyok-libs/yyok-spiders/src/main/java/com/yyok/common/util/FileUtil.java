package com.yyok.common.util;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.HashSet;
import java.util.Set;


public class FileUtil extends File {
    private static Logger logger = LoggerFactory.getLogger(FileUtil.class);

    public FileUtil(String pathname) {
        super(pathname);
    }


    /**
     * 根据 url 和 contentType 生成文件名, 去除非文件名字符
     *
     * @param url
     * @param contentType
     * @return String
     */
    public static String getFileNameByUrl(String url, String contentType) {
        url = url.replaceAll("[\\?/:*|<>\"]", "_");
        if (contentType != null && contentType.lastIndexOf("/") > -1) {
            url += "." + contentType.substring(contentType.lastIndexOf("/") + 1);    // text/html、application/pdf
        }
        return url;
    }

    public static void delFileByName(String url) {
        File tmpFile = new File(url);
        tmpFile.delete();
    }

    public static void renameTxt(File file) {
        if (file.isDirectory()) {
            File[] files = file.listFiles();
            System.out.println(files.length);
            for (File f : files) {
                System.out.println(f.getName());
                String originalName = f.getName();
                System.out.println(originalName);
                String newName = "10" + originalName;
                String newFilePath = "F:\\Develop_Code\\workspace\\Research\\3.特征选择\\TrainingSet\\C000010";
                File newFileName = new File(newFilePath + "\\" + newName);
                synchronized (f) {
                    f.renameTo(newFileName);
                }
            }
        }
    }

    /**
     * 保存文本文件
     *
     * @param fileData
     * @param filePath
     * @param fileName
     */
    public static void saveFile(String fileData, String filePath, String fileName) {
        try {
            DataOutputStream out = new DataOutputStream(new FileOutputStream(new File(filePath, fileName)));
            out.writeChars(fileData);
            out.flush();
            out.close();
        } catch (IOException e) {
            logger.error("", e);
        }
    }

    /**
     * 下载文件
     *
     * @param fileUrl
     * @param timeoutMillis
     * @param filePath
     * @param fileName
     */
    public static boolean downFile(String fileUrl, int timeoutMillis, String filePath, String fileName) {

        try {
            URL url = new URL(fileUrl);
            URLConnection connection = url.openConnection();
            connection.setConnectTimeout(timeoutMillis);

            InputStream inputStream = connection.getInputStream();
            BufferedOutputStream bufferedOutputStream = new BufferedOutputStream(new FileOutputStream(new File(filePath, fileName)));

            byte[] buf = new byte[1024];
            int size;
            while (-1 != (size = inputStream.read(buf))) {
                bufferedOutputStream.write(buf, 0, size);
            }
            bufferedOutputStream.close();
            inputStream.close();

            return true;
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * A方法追加文件：使用RandomAccessFile
     */
    public static void appendMethodA(String fileName, String content) {
        try {
            // 打开一个随机访问文件流，按读写方式
            RandomAccessFile randomFile = new RandomAccessFile(fileName, "rw");
            // 文件长度，字节数
            long fileLength = randomFile.length();
            //将写文件指针移到文件尾。在该位置发生下一个读取或写入操作。
            randomFile.seek(fileLength);
            //按字节序列将该字符串写入该文件。
            randomFile.writeBytes(content);
            //关闭此随机访问文件流并释放与该流关联的所有系统资源。
            randomFile.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * B方法追加文件：使用FileWriter
     */
    public static void appendMethodB(String fileName, String content) {
        try {
            //打开一个写文件器，构造函数中的第二个参数true表示以追加形式写文件,如果为 true，则将字节写入文件末尾处，而不是写入文件开始处
            FileWriter writer = new FileWriter(fileName, true);
            writer.write(content);
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    /**
     * 将文件hash取模之后放到不同的小文件中
     *
     * @param targetFile 要去重的文件路径
     * @param splitSize  将目标文件切割成多少份hash取模的小文件个数
     * @return
     */
    public static File[] splitFile(String targetFile, int splitSize) {
        File file = new File(targetFile);
        BufferedReader reader = null;
        PrintWriter[] pws = new PrintWriter[splitSize];
        File[] littleFiles = new File[splitSize];
        String parentPath = file.getParent();
        File tempFolder = new File(parentPath + File.separator + "test");
        if (!tempFolder.exists()) {
            tempFolder.mkdir();
        }
        for (int i = 0; i < splitSize; i++) {
            littleFiles[i] = new File(tempFolder.getAbsolutePath() + File.separator + i + ".txt");
            if (littleFiles[i].exists()) {
                littleFiles[i].delete();
            }
            try {
                pws[i] = new PrintWriter(littleFiles[i]);
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            }
        }
        try {
            reader = new BufferedReader(new FileReader(file));
            String tempString = null;
            while ((tempString = reader.readLine()) != null) {
                tempString = tempString.trim();
                if (tempString != "") {
                    //关键是将每行数据hash取模之后放到对应取模值的文件中，确保hash值相同的字符串都在同一个文件里面
                    int index = Math.abs(tempString.hashCode() % splitSize);
                    pws[index].println(tempString);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e1) {
                    e1.printStackTrace();
                }
            }
            for (int i = 0; i < splitSize; i++) {
                if (pws[i] != null) {
                    pws[i].close();
                }
            }
        }
        return littleFiles;
    }

    /**
     * 对小文件进行去重合并
     *
     * @param littleFiles      切割之后的小文件数组
     * @param distinctFilePath 去重之后的文件路径
     * @param splitSize        小文件大小
     */
    public static void distinct(File[] littleFiles, String distinctFilePath, int splitSize) {
        File distinctedFile = new File(distinctFilePath);
        FileReader[] frs = new FileReader[splitSize];
        BufferedReader[] brs = new BufferedReader[splitSize];
        PrintWriter pw = null;
        try {
            if (distinctedFile.exists()) {
                distinctedFile.delete();
            }
            distinctedFile.createNewFile();
            pw = new PrintWriter(distinctedFile);
            Set<String> unicSet = new HashSet<String>();
            for (int i = 0; i < splitSize; i++) {
                if (littleFiles[i].exists()) {
                    System.out.println("开始对小文件：" + littleFiles[i].getName() + "去重");
                    frs[i] = new FileReader(littleFiles[i]);
                    brs[i] = new BufferedReader(frs[i]);
                    String line = null;
                    while ((line = brs[i].readLine()) != null) {
                        if (line != "") {
                            unicSet.add(line);
                        }
                    }
                    for (String s : unicSet) {
                        pw.println(s);
                    }
                    unicSet.clear();
                    System.gc();
                }
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e1) {
            e1.printStackTrace();
        } finally {
            for (int i = 0; i < splitSize; i++) {
                try {
                    if (null != brs[i]) {
                        brs[i].close();
                    }
                    if (null != frs[i]) {
                        frs[i].close();
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
                //合并完成之后删除临时小文件
                if (littleFiles[i].exists()) {
                    littleFiles[i].delete();
                }
            }
            if (null != pw) {
                pw.close();
            }
        }
    }

    public static void distinct(String orgfp, String newfd) {
        File ff = new File(orgfp);
        File distinctedFile = new File(newfd);
        PrintWriter pw = null;
        Set<String> allHash = null;
        FileReader fr = null;
        BufferedReader br = null;
        try {
            pw = new PrintWriter(distinctedFile);
            allHash = new HashSet<String>();
            fr = new FileReader(ff);
            br = new BufferedReader(fr);
            String line = null;
            while ((line = br.readLine()) != null) {
                line = line.trim();
                if (line != "") {
                    allHash.add(line);
                }
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (null != fr) {
                    fr.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            try {
                if (null != br) {
                    br.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        for (String s : allHash) {
            pw.println(s);
        }
        pw.close();
    }

    /**
     * @author 戴尔电脑   * @date 2018-1-19 下午4:02:38
     * 读取txt文件的内容 * @param file 想要读取的文件对象

     *  course.txt
     *  1,数据库
     *  2,数学
     *  3,信息系统
     *  4,操作系统
     *  5,数据结构
     *  6,数据处理
     * @return 返回文件内容
     */
    public static String readContext(File file){
        StringBuilder result = new StringBuilder();
        try{
            BufferedReader br = new BufferedReader(new FileReader(file));//构造一个BufferedReader类来读取文件
            String s = null;
            while((s = br.readLine())!=null){//使用readLine方法，一次读一行
                result.append(System.lineSeparator()+s);
            }
            br.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        return result.toString();
    }

    public static String nameFile(File file){
        StringBuilder result = new StringBuilder();
        try{
            BufferedReader br = new BufferedReader(new FileReader(file));//构造一个BufferedReader类来读取文件
            String s = null;
            while((s = br.readLine())!=null){//使用readLine方法，一次读一行
                result.append(System.lineSeparator()+s);
            }
            br.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        return result.toString();
    }

}