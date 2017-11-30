package com.yq.common.pojo;

import java.io.Serializable;
import java.util.Date;

public class UploadFile implements Serializable {

   private Long id;
   private String uuid;
   private String fileType;
   private String fileName;
   private Long size;
   private Date addDate;
   private byte[] source;
   private String remark;
   private String ext1;
   private String ext2;
   private String ext3;


   public String getUuid() {
      return this.uuid;
   }

   public void setUuid(String uuid) {
      this.uuid = uuid;
   }

   public long getSize() {
      return this.size.longValue();
   }

   public void setSize(long size) {
      this.size = Long.valueOf(size);
   }

   public byte[] getSource() {
      return this.source;
   }

   public void setSource(byte[] bs) {
      this.source = bs;
   }

   public Date getAddDate() {
      return this.addDate;
   }

   public void setAddDate(Date addDate) {
      this.addDate = addDate;
   }

   public String getExt1() {
      return this.ext1;
   }

   public void setExt1(String ext1) {
      this.ext1 = ext1;
   }

   public String getExt2() {
      return this.ext2;
   }

   public void setExt2(String ext2) {
      this.ext2 = ext2;
   }

   public String getExt3() {
      return this.ext3;
   }

   public void setExt3(String ext3) {
      this.ext3 = ext3;
   }

   public String getFileName() {
      return this.fileName;
   }

   public void setFileName(String fileName) {
      this.fileName = fileName;
   }

   public String getFileType() {
      return this.fileType;
   }

   public void setFileType(String fileType) {
      this.fileType = fileType;
   }

   public long getId() {
      return this.id.longValue();
   }

   public void setId(long id) {
      this.id = Long.valueOf(id);
   }

   public String getRemark() {
      return this.remark;
   }

   public void setRemark(String remark) {
      this.remark = remark;
   }
}
