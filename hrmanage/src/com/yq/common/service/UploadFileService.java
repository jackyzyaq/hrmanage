package com.yq.common.service;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.util.Util;
import com.yq.common.pojo.UploadFile;
import com.yq.common.service.SequenceService;
import java.sql.SQLException;
import java.util.Date;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UploadFileService {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;
   @Resource
   private SequenceService sequenceService;
   private UploadFile uploadFile = new UploadFile();


   public UploadFile getUploadFileById(long id) throws SQLException {
      return (UploadFile)this.sqlMapClient.queryForObject(this.uploadFile.getClass().getName() + ".getUploadFileById", Long.valueOf(id));
   }

   public UploadFile getUploadFileByUUId(String uuid) throws SQLException {
      return (UploadFile)this.sqlMapClient.queryForObject(this.uploadFile.getClass().getName() + ".getUploadFileByUUId", uuid);
   }

   public void deleteById(long id) throws SQLException {
      this.sqlMapClient.delete(this.uploadFile.getClass().getName() + ".deleteById", Long.valueOf(id));
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int insertFile(String fileName, String fileType, byte[] source, String remark) throws Exception {
      UploadFile uploadFile = new UploadFile();
      uploadFile.setAddDate(new Date());
      uploadFile.setFileName(fileName);
      uploadFile.setFileType(fileType);
      uploadFile.setUuid(Util.getUUID());
      uploadFile.setSize((long)source.length);
      uploadFile.setSource(source);
      uploadFile.setRemark(remark);
      int fileId = ((Integer)this.sqlMapClient.insert(uploadFile.getClass().getName() + ".insert", uploadFile)).intValue();
      return fileId;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int insertFile(UploadFile uploadFile) throws Exception {
      int fileId = ((Integer)this.sqlMapClient.insert(uploadFile.getClass().getName() + ".insert", uploadFile)).intValue();
      return fileId;
   }
}
