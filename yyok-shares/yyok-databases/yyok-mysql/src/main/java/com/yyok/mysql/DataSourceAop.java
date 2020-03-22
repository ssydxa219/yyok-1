package com.yyok.mysql;

import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;

@Aspect
@Component
public class DataSourceAop {

    @Pointcut("!@annotation(com.yyok.*.annotation.Master) " +
            "&& (execution(* com.yyok.*.service..*.select*(..)) " +
            "|| execution(* com.yyok.*.service..*.get*(..)))")
    public void readPointcut() {

    }

    @Pointcut("@annotation(com.yyok.*.annotation.Master) " +
            "|| execution(* com.yyok.*.service..*.insert*(..)) " +
            "|| execution(* com.yyok.*.service..*.add*(..)) " +
            "|| execution(* com.yyok.*.service..*.update*(..)) " +
            "|| execution(* com.yyok.*.service..*.edit*(..)) " +
            "|| execution(* com.yyok.*.service..*.delete*(..)) " +
            "|| execution(* com.yyok.*.service..*.remove*(..))")
    public void writePointcut() {

    }

    @Before("readPointcut()")
    public void read() {
        DBContextHolder.slave();
    }

    @Before("writePointcut()")
    public void write() {
        DBContextHolder.master();
    }


    /**
     * 另一种写法：if...else...  判断哪些需要读从数据库，其余的走主数据库
     */
//    @Before("execution(* com.cjs.*.service.impl.*.*(..))")
//    public void before(JoinPoint jp) {
//        String methodName = jp.getSignature().getName();
//
//        if (StringUtils.startsWithAny(methodName, "get", "select", "find")) {
//            DBContextHolder.slave();
//        }else {
//            DBContextHolder.master();
//        }
//    }
}