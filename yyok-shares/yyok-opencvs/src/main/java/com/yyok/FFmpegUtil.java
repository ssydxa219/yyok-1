package com.yyok;

import org.bytedeco.javacpp.opencv_core;
import org.bytedeco.javacpp.opencv_imgcodecs;
import org.bytedeco.javacv.FFmpegFrameGrabber;
import org.bytedeco.javacv.Frame;
import org.bytedeco.javacv.OpenCVFrameConverter;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class FFmpegUtil {

    static String imageMat = "png";
    static String filePath = "D:\\imgs";
    static String inputFilePth = "http://10.13.4.32:11937/live/222.flv";
    static String fileNamestr = "face.png";

    public static void main(String[] args) throws Exception {
        randomGrabberFFmpegImage(inputFilePth, 5);
    }

    /**
     *
     * @param filePath 视频输入流
     * @param randomSize
     * @throws Exception
     */
    public static void randomGrabberFFmpegImage(String filePath, int randomSize)
            throws Exception {
        FFmpegFrameGrabber ff = FFmpegFrameGrabber.createDefault(filePath);
        ff.start();

        int ffLength = ff.getLengthInFrames();
        List<Integer> randomGrab = random(ffLength, randomSize);
        int maxRandomGrab = randomGrab.get(randomGrab.size() - 1);
        Frame f;
        int i = 0;
        while (i < ffLength) {
            f = ff.grabImage();
            if (randomGrab.contains(i)) {
                doExecuteFrame(f, i);
            }
            if (i >= maxRandomGrab) {
                break;
            }
            i++;
        }
        ff.stop();
    }

    public static void doExecuteFrame(Frame f, int index) {
        if (null == f || null == f.image) {
            return;
        }
        OpenCVFrameConverter.ToIplImage converter = new OpenCVFrameConverter.ToIplImage();

        opencv_core.Mat mat = converter.convertToMat(f);
        opencv_imgcodecs.imwrite(filePath + index + fileNamestr, mat);//存储图像
    }

    public static List<Integer> random(int baseNum, int length) {
        List<Integer> list = new ArrayList<>(length);
        while (list.size() < length) {
            Integer next = (int) (Math.random() * baseNum);
            if (list.contains(next)) {
                continue;
            }
            list.add(next);
        }
        Collections.sort(list);
        return list;
    }


}