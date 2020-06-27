package com.yyok;

import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.imgcodecs.Imgcodecs;
import org.opencv.imgproc.Imgproc;

/**
 * 图像直接阈值化操作
 */
public class AdaptiveThreshold {

    public static void main(String[] args) {
        try {
            System.loadLibrary(Core.NATIVE_LIBRARY_NAME);

            //以灰度图像的方式读取图像.
            Mat src = Imgcodecs.imread("./images/Lena.jpg", Imgcodecs.IMREAD_REDUCED_GRAYSCALE_8);
            new ShowImage(src);
            Mat dst = new Mat();

            //对一个数组应用一个自适应阈值。
//            该函数根据公式将灰度图像转换为二进制图像：
            Imgproc.adaptiveThreshold(src, dst, 200,
                    Imgproc.ADAPTIVE_THRESH_GAUSSIAN_C, Imgproc.THRESH_BINARY, 7, 8);

            new ShowImage(dst);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}