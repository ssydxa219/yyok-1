package com.yyok.common.bean;

import com.yyok.common.constants.CommonConstants;
import lombok.*;
import lombok.experimental.Accessors;

import java.io.Serializable;

/**
 * @Description //TODO 返回参数包装类
 * @param <T>
 */

@Builder
@ToString
@Accessors(chain = true)
@AllArgsConstructor
public class Bean<T> implements Serializable {

    @Getter
    @Setter
    public int code = CommonConstants.HTTP_OK;

    @Getter
    @Setter
    public String message = "success";

    @Getter
    @Setter
    public T data;

    public Bean() {
        super();
    }

    public Bean(T data) {
        super();
        this.data = data;
    }

    public Bean(T data, String message) {
        super();
        this.data = data;
        this.message = message;
    }

    public Bean(Throwable e) {
        super();
        this.message = e.getMessage();
        this.code = CommonConstants.HTTP_INTERNAL_ERROR;
    }

    public static Bean ok(){
        return Bean
                .builder()
                .code(CommonConstants.HTTP_OK)
                .message("success")
                .build();
    }

    public static Bean error(){
        return Bean
                .builder()
                .code(CommonConstants.HTTP_INTERNAL_ERROR)
                .message("error")
                .build();
    }

    public static Bean errorParam(Object param){
        return Bean
                .builder()
                .code(CommonConstants.HTTP_INTERNAL_ERROR)
                .message("param error :" + param)
                .build();
    }

    public static Bean error(String message){
        return Bean
                .builder()
                .code(CommonConstants.HTTP_INTERNAL_ERROR)
                .message(message)
                .build();
    }

    public static Bean error(int code,String message){
        return Bean
                .builder()
                .code(code)
                .message(message)
                .build();
    }

    public static Bean ok(Object data){
        return Bean
                .builder()
                .code(CommonConstants.HTTP_OK)
                .data(data)
                .message("success")
                .build();
    }
}
