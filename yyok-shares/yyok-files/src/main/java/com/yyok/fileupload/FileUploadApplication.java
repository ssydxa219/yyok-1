package com.yyok.fileupload;

import org.springframework.boot.autoconfigure.*;
import org.springframework.boot.context.properties.*;
import com.yyok.fileupload.config.*;
import org.springframework.boot.*;

@SpringBootApplication
@EnableConfigurationProperties({ FileStorageProperties.class })
public class FileUploadApplication {
	public static void main(String[] args) {
		SpringApplication.run(FileUploadApplication.class, args);
	}
}
