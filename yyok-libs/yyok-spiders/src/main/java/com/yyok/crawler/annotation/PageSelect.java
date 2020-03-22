package com.yyok.crawler.annotation;

import java.lang.annotation.*;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
@Documented
public @interface PageSelect {

    /**
     * CSS-like query, like "#body"
     *
     * CSS选择器, 如 "#body"
     *
     * @return String
     */
    public String cssQuery() default "";

}
