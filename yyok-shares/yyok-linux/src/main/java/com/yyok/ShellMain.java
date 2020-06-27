package com.yyok;

import com.yyok.linux.ShellUtil;

import java.util.concurrent.ExecutionException;

public class ShellMain {

    static String hosts1[] = {
    "10.10.5.131 dda root hxpti",
    "10.10.5.132 ddb root hxpti",
    "10.10.5.133 ddc root hxpti",
    "10.10.5.134 ddd root hxpti",
    "10.10.5.135 dde root hxpti",
    "10.10.5.136 ddf root hxpti",
    "10.10.5.137 ddg root hxpti",
    "10.10.5.138 ddh root hxpti"
    };

    static String hosts[] = {
    "10.13.2.11 ddaa root hxpti",
    "10.13.2.12 ddab root hxpti",
    "10.13.2.13 ddac root hxpti",
    "10.13.2.14 ddba root hxpti",
    "10.13.2.15 ddbb root hxpti",
    "10.13.2.16 ddbc root hxpti",
    "10.13.2.17 ddca root hxpti",
    "10.13.2.18 ddcb root hxpti",
    "10.13.2.19 ddcc root hxpti",
    "10.13.2.20 ddda root hxpti",
    "10.13.2.21 dddb root hxpti",
    "10.13.2.22 dddc root hxpti",
    "10.13.2.23 dddd root hxpti",
    "10.13.2.24 ddea root hxpti",
    "10.13.2.25 ddeb root hxpti",
    "10.13.2.26 ddec root hxpti"
    };

    public static void main(String[] args) throws ExecutionException, InterruptedException {

    //ShellUtil.execenv(hosts1);
    //ShellUtil.execmkdir(hosts,"/ddhome");
    //ShellUtil.execchmod(hosts);
    //ShellUtil.execopt(hosts);
    //ShellUtil.exechostressh(hosts1);

    ShellUtil.exechostssh(hosts);
    //ShellUtil.execyums(hosts);
    //ShellUtil.execscps("dda",hosts,"/ddhome/bin/*", "/ddhome/bin/");
    //ShellUtil.execsdown("10.10.5.131","root","hxpti");
    //ShellUtil.exechadoopinstall(hosts,"/ddhome/bin");
    //ShellUtil.execreboot(hosts);
        //

    }
}



//10.10.5.131 dda
//10.10.5.132 ddb
//10.10.5.133 ddc
//10.10.5.134 ddd
//10.10.5.135 dde
//10.10.5.136 ddf
//10.10.5.137 ddg
//10.10.5.138 ddh


