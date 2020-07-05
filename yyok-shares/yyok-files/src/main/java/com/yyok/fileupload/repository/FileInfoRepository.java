package com.yyok.fileupload.repository;

import com.yyok.fileupload.entity.FileInfo;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface FileInfoRepository extends JpaRepository<FileInfo, Long> {
    @Query(value = "select * from t_fileinfo t where t.real_file_name like %:fileName%", nativeQuery = true)
    Page<FileInfo> findByFileName(@Param("fileName") String fileName, Pageable pageable);
}
