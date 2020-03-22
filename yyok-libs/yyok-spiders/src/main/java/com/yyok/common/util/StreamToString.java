package com.yyok.common.util;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

public class StreamToString {

    public static String streamToStr(InputStream inputStream, String chartSet){

        StringBuilder builder=new StringBuilder();
        try {
            BufferedReader br=new BufferedReader(new InputStreamReader(inputStream,chartSet));
            String con;
            while ((con=br.readLine())!=null){
                builder.append(con);
            }

            br.close();
            return builder.toString();


        } catch (Exception e) {
            e.printStackTrace();
        }

        return "";
    }
}