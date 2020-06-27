package com.yyok.admin.security;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;


@Configuration
public class WebConfiguration implements WebMvcConfigurer {

	public static final String API_PATH = "/api/**";

	private Logger logger = LoggerFactory.getLogger(WebConfiguration.class);

	@Autowired
	private SecurityInterceptor securityInterceptor;

	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		logger.debug("Add interceptor securityInterceptor");
		registry.addInterceptor(securityInterceptor).addPathPatterns(API_PATH);
	}

}
