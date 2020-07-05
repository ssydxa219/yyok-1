package com.yyok.fileupload.controller;

import com.yyok.fileupload.entity.FileInfo;
import com.yyok.fileupload.payload.CommonResponse;
import com.yyok.fileupload.payload.UploadFileResponse;
import com.yyok.fileupload.service.FileStorageService;
import com.yyok.fileupload.util.PageResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@RestController
public class FileController {
    private static final Logger logger;

    static {
        logger = LoggerFactory.getLogger(FileController.class);
    }

    @Autowired
    private FileStorageService fileStorageService;

    @PostMapping({"/uploadFile"})
    public UploadFileResponse uploadFile(@RequestParam("file") MultipartFile file) {
        FileInfo fileInfo = this.fileStorageService.storeFile(file);
        String fileDownloadUri = ServletUriComponentsBuilder.fromCurrentContextPath().path("/downloadFile/")
                .path("" + fileInfo.getId()).toUriString();
        return new UploadFileResponse(fileInfo.getRealFileName(), fileDownloadUri, file.getContentType(),
                file.getSize());
    }

    @PostMapping({"/removeFile"})
    public CommonResponse removeFile(@RequestParam("id") Long id) {
        this.fileStorageService.removeFile(id);
        return new CommonResponse(true, "文件删除成功！", "");
    }

    @PostMapping({"/uploadMultipleFiles"})
    public List<UploadFileResponse> uploadMultipleFiles(@RequestParam("files") final MultipartFile[] files) {
        return Arrays.asList(files).stream().map(file -> this.uploadFile(file)).collect(Collectors.toList());
    }

    @GetMapping({"/downloadFile/{id}"})
    public ResponseEntity<Resource> downloadFile(@PathVariable final Long id, final HttpServletRequest request) {
        FileInfo fileInfo = this.fileStorageService.getFileInfoById(id);
        Resource resource = this.fileStorageService.loadFileAsResource(id);
        String contentType = null;
        try {
            contentType = request.getServletContext().getMimeType(resource.getFile().getAbsolutePath());
        } catch (IOException ex) {
            FileController.logger.info("Could not determine file type.");
        }
        if (contentType == null) {
            contentType = "application/octet-stream";
        }
        try {
            return ResponseEntity.ok().contentType(MediaType.parseMediaType(contentType))
                    .header("Content-Disposition",
                            "attachment; filename=\""
                                    + new String(fileInfo.getRealFileName().getBytes("GB2312"), "ISO8859-1") + "\"")
                    .body(resource);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            return null;
        }
    }

    @GetMapping({"/listAll"})
    public List<FileInfo> listAll() {
        return this.fileStorageService.loadAll();
    }

    @PostMapping({"/listByFileName"})
    public PageResult<FileInfo> listByFileName(@RequestParam("fileName") final String fileName,
                                               @RequestParam(defaultValue = "0") final String pageNo,
                                               @RequestParam(defaultValue = "10") final String pageSize) {
        return this.fileStorageService.getListByFileName(fileName, Integer.parseInt(pageNo) - 1,
                Integer.parseInt(pageSize));
    }

}
