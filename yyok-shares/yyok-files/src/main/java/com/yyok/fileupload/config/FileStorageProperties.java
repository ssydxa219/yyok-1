package com.yyok.fileupload.config;

import org.springframework.boot.context.properties.*;

@ConfigurationProperties(prefix = "file")
public class FileStorageProperties {
	private String uploadDir;

	public String getUploadDir() {
		return this.uploadDir;
	}

	public void setUploadDir(String uploadDir) {
		this.uploadDir = uploadDir;
	}
}
