package com.yyok;


import com.yyok.utils.ImageUtil;
import org.bytedeco.javacv.CanvasFrame;
import org.bytedeco.javacv.OpenCVFrameGrabber;
import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.imgproc.Imgproc;
import org.opencv.videoio.VideoCapture;

import javax.swing.*;
import java.awt.*;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

public class ShowVedio {

    static {
        System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
    }

    private JFrame frame;
    static JLabel label;
    static int flag = 0;


        public static void main(String[] args) throws Exception, InterruptedException{
            OpenCVFrameGrabber grabber = new OpenCVFrameGrabber(0);
            grabber.start();   //开始获取摄像头数据
            CanvasFrame canvas = new CanvasFrame("摄像头");//新建一个窗口
            canvas.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            canvas.setAlwaysOnTop(true);
            while(true){
                if(!canvas.isDisplayable()){//窗口是否关闭
                    grabber.stop();//停止抓取
                    System.exit(2);//退出
                    break;
                }
                canvas.showImage(grabber.grab());//获取摄像头图像并放到窗口上显示， 这里的Frame frame=grabber.grab(); frame是一帧视频图像
                Thread.sleep(200);//50毫秒刷新一次图像
            }
        }


    /**
     * Launch the application.
     */
    public static void main1(String[] args) {
        EventQueue.invokeLater(new Runnable() {
            public void run() {
                try {
                    ShowVedio window = new ShowVedio();
                    window.frame.setVisible(true);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
        //操作
        VideoCapture camera = new VideoCapture();
        camera.open(1);
        if (!camera.isOpened()) {
            System.out.println("Camera Error");
        } else {
            Mat frame = new Mat();
            while (flag == 0) {
                camera.read(frame);
                Mat gray = new Mat(frame.rows(), frame.cols(), frame.type());
                Imgproc.cvtColor(frame, gray, Imgproc.COLOR_RGB2GRAY);
                label.setIcon(new ImageIcon(ImageUtil.matToBufferedImage(gray)));
                try {
                    Thread.sleep(100);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * Create the application.
     */
    public ShowVedio() {
        initialize();
    }

    /**
     * Initialize the contents of the frame.
     */
    private void initialize() {
        frame = new JFrame();
        frame.setBounds(100, 100, 798, 600);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.getContentPane().setLayout(null);


        JButton btnNewButton = new JButton("拍照");
        btnNewButton.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent arg0) {
                flag = 1;
            }
        });
        btnNewButton.setBounds(20, 20, 113, 27);
        frame.getContentPane().add(btnNewButton);

        label = new JLabel("");
        label.setBounds(50, 50, 640, 480);
        frame.getContentPane().add(label);
    }

}