package com.yyok;

import com.yyok.utils.ImageUtil;
import org.opencv.core.Point;
import org.opencv.core.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.objdetect.CascadeClassifier;
import org.opencv.videoio.VideoCapture;

import java.awt.*;
import java.io.IOException;

public class FaceDetectionDemo {

    static String ms1 = "haarcascade_frontalface_alt.xml";
    static String ms2 = "haarcascade_frontalcatface_extended.xml";
    static String ms3 = "haarcascade_eye.xml";
    static String ms =ms1;
    //face detection + face alignment + face featrue extraction
    public static void main(String[] args) throws IOException {
        //加载dll
        System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
        //获取resource目录下的haarcascade_frontalface_alt.xml
        CascadeClassifier faceDetector = new CascadeClassifier("D:\\ProgramFiles\\opencv\\sources\\data\\haarcascades\\"+ms1);
        CascadeClassifier faceDetectorext = new CascadeClassifier("D:\\ProgramFiles\\opencv\\sources\\data\\haarcascades\\"+ms2);

        // 打开摄像头或者视频文件
        VideoCapture capture = new VideoCapture();
        //打开摄像头
//        capture.open(0);
//        打开视频文件
        capture.open("http://10.13.4.32:11937/live/222.flv");
        // capture.open("http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/gear2/prog_index.m3u8");
        //判断是否能加载视频
        if (!capture.isOpened()) {
            System.out.println("无法加载视频数据……");
            return;
        }
        //获取帧的宽度
        int frameWidth = (int) capture.get(3);
        //获取帧的高度
        int frameHeight = (int) capture.get(4);
        //创建容器
        JFrameGUI gui = new JFrameGUI();
        gui.createWin("人脸识别器", new Dimension(frameWidth, frameHeight));
        //创建图像容器类
        Mat frame = new Mat();
        while (true) {
            //读取一帧
            boolean have = capture.read(frame);
//          会翻转
//            Core.flip(frame, frame, 1);// Win上摄像头
            // 进行人脸检测
            MatOfRect faceDetections = new MatOfRect();
            faceDetectorext.detectMultiScale(frame, faceDetections);
            faceDetector.detectMultiScale(frame, faceDetections);

            System.out.println(String.format("检测到人脸： %s", faceDetections.toArray().length));
            for (Rect rect : faceDetections.toArray()) {
                Imgproc.rectangle(frame, new Point(rect.x, rect.y), new Point(rect.x + rect.width, rect.y + rect.height),
                        new Scalar(0, 255, 0), 1);
            }
            if (!have) break;
            if (!frame.empty()) {
                //Mat转换BufferedImage并刷新
                gui.imshow(ImageUtil.conver2Image(frame));
                gui.repaint();
            }
            try {
                Thread.sleep(0);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

    }



}
