package com.yyok.gecco;

import com.geccocrawler.gecco.GeccoEngine;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;


@SpringBootApplication
@Configuration
public class YYOKGeccoBootstrap {

    @Bean
    public SpringGeccoEngine initGecco() {
        return new SpringGeccoEngine() {
            @Override
            public void init() {
                GeccoEngine.create()
                        .pipelineFactory(springPipelineFactory)
                        .classpath("com.yyok.gecco")
                        .start("https://github.com/xtuhcy/gecco")
                        .interval(3000)
                        .loop(true)
                        .start();
            }
        };
    }

    public static void main(String[] args) throws Exception {
        SpringApplication.run(YYOKGeccoBootstrap.class, args);
    }

}
