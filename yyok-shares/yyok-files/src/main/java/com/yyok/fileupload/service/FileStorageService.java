package com.yyok.fileupload.service;

import com.yyok.fileupload.config.FileStorageProperties;
import com.yyok.fileupload.entity.FileInfo;
import com.yyok.fileupload.exception.FileStorageException;
import com.yyok.fileupload.exception.MyFileNotFoundException;
import com.yyok.fileupload.repository.FileInfoRepository;
import com.yyok.fileupload.util.FileHelper;
import com.yyok.fileupload.util.PageResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Date;
import java.util.List;
import java.util.NoSuchElementException;

/**
 * 文件操作服务类
 *
 */
@Service
public class FileStorageService {
	private final Path uploadPath;
	@Autowired
	private FileInfoRepository fileInfoRepository;

	public FileStorageService(FileStorageProperties fileStorageProperties) {
		this.uploadPath = Paths.get(FileHelper.getUploadPath(fileStorageProperties), new String[0]).toAbsolutePath()
				.normalize();
		try {
			Files.createDirectories(this.uploadPath);
		} catch (Exception ex) {
			throw new FileStorageException("Could not create the directory where the uploaded files will be stored.",
					ex);
		}
	}
	
	/**
	 * 存储文件
	 * @param file
	 * @return
	 */
	public FileInfo storeFile(MultipartFile file) {
		String fileName = StringUtils.cleanPath(file.getOriginalFilename());
		try {
			if (fileName.contains("..")) {
				throw new FileStorageException("Sorry! Filename contains invalid path sequence " + fileName);
			}
			String fileExtensionName = FileHelper.getExtFromFileName(fileName);
			String randomFileName = FileHelper.createRandomFileName(fileExtensionName);
			Path targetLocation = Paths.get(this.uploadPath + File.separator + randomFileName, new String[0]);
			Files.copy(file.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);
			FileInfo fileInfo = new FileInfo(file.getSize(), randomFileName, fileName, fileExtensionName,
					this.uploadPath.toString());
			fileInfo.setCreateTime(new Date());
			fileInfo.setCreator("admin");
			fileInfo.setUpdateTime(new Date());
			fileInfo.setUpdater("admin");
			this.fileInfoRepository.save(fileInfo);
			return fileInfo;
		} catch (IOException ex) {
			throw new FileStorageException("Could not store file " + fileName + ". Please try again!", ex);
		}
	}
	
	/**
	 * 根据id加载文件资源
	 * @param id
	 * @return
	 */
	public Resource loadFileAsResource(Long id) {
		try {
			FileInfo fileInfo = this.getFileInfoById(id);
			Path filePath = Paths.get(fileInfo.getFilePath() + File.separator + fileInfo.getFileName(), new String[0])
					.normalize();
			Resource resource = (Resource) new UrlResource(filePath.toUri());
			if (resource.exists()) {
				return resource;
			}
			throw new MyFileNotFoundException("File not found " + fileInfo.getRealFileName());
		} catch (NoSuchElementException | MalformedURLException ex3) {
			throw new MyFileNotFoundException("File not found " + id);
		}
	}
	
	/**
	 * 删除文件
	 * @param id
	 * @return
	 */
	public Boolean removeFile(Long id) {
		Resource resource = this.loadFileAsResource(id);
		try {
			this.fileInfoRepository.deleteById(id);
			return resource.getFile().delete();
		} catch (IOException e) {
			e.printStackTrace();
			return false;
		}
	}
	
	/**
	 * 根据id获取文件信息
	 * @param id
	 * @return
	 */
	public FileInfo getFileInfoById(Long id) {
		FileInfo fileInfo = this.fileInfoRepository.findById(id).get();
		return fileInfo;
	}
	
	/**
	 * 加载所有文件列表
	 * @return
	 */
	public List<FileInfo> loadAll() {
		return (List<FileInfo>) this.fileInfoRepository.findAll();
	}
	
	/**
	 * 根据文件名查询文件列表
	 * @param fileName
	 * @param pageNo
	 * @param pageSize
	 * @return
	 */
	public PageResult<FileInfo> getListByFileName(String fileName, int pageNo, int pageSize) {
		Pageable pageable = (Pageable) PageRequest.of(pageNo, pageSize, Sort.Direction.DESC, "create_time");
		Page<FileInfo> page = this.fileInfoRepository.findByFileName(fileName, pageable);
		PageResult<FileInfo> result = new PageResult(pageNo, page.getNumberOfElements(), page.getTotalPages(),
				page.getContent());
		return result;
	}
}
