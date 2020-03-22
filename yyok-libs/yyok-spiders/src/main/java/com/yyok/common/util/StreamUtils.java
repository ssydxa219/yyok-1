package com.yyok.common.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

public class StreamUtils {

    public static String convertStreamToString(InputStream in) {
        StringBuilder sb = new StringBuilder();
        try {

            InputStreamReader isr = new InputStreamReader(in, "UTF-8");
            BufferedReader reader = new BufferedReader(isr);
            String line = null;
            while ((line = reader.readLine()) != null) {
                sb.append(line + "/n");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                in.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return sb.toString();

    }
}