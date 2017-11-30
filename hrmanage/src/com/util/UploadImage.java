package com.util;

import com.util.MD5;
import com.util.ServiceUtils;
import com.yq.common.service.CommonService;
import com.yq.common.service.UploadFileService;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.Date;

public class UploadImage {

   public boolean storeImage(String sqlstr, File file) {
      try {
         FileInputStream e = new FileInputStream(file);
         ByteBuffer nbf = ByteBuffer.allocate((int)file.length());
         byte[] array = new byte[1024];
         int offset = 0;

         int length1;
         for(boolean length = false; (length1 = e.read(array)) > 0; offset += length1) {
            if(length1 != 1024) {
               nbf.put(array, 0, length1);
            } else {
               nbf.put(array);
            }
         }

         e.close();
         byte[] content = nbf.array();
         return this.setImage(sqlstr, content);
      } catch (FileNotFoundException var9) {
         var9.printStackTrace();
      } catch (IOException var10) {
         var10.printStackTrace();
      }

      return false;
   }

   private boolean setImage(String sqlstr, byte[] in) {
      boolean flag = true;
      CommonService commonService = (CommonService)ServiceUtils.getService("commonService");
      String sql = "INSERT INTO [testproject].[dbo].[tb_user] (name,zh_name,pwd,state,upload_uuid,create_date,update_date) values (?,?,?,?,?,?,?);";

      try {
         int id = commonService.insert(sql, new Object[]{"nijian1", "倪健", MD5.encrypt("123456"), Integer.valueOf(1), "d22863a8-7372-4292-8f17-cdcf24a957f2,d22863a8737242928f17cdcf24a957f2", new Date(), new Date()});
         System.out.println(id);
      } catch (Exception var10) {
         var10.printStackTrace();
      }

      UploadFileService uploadFileService = (UploadFileService)ServiceUtils.getService("uploadFileService");

      try {
         uploadFileService.insertFile("QQ图片20150717143234", "image/pjpeg", in, "");
      } catch (Exception var9) {
         var9.printStackTrace();
      }

      return flag;
   }

   public static void main(String[] args) {
      UploadImage upload = new UploadImage();

      try {
         File e = new File("F:\\nijian\\照片\\身份证\\QQ图片20150717143234.jpg");
         if(upload.storeImage((String)null, e)) {
            System.out.print("true");
         } else {
            System.out.print("False");
         }
      } catch (Exception var3) {
         var3.printStackTrace();
      }

   }
}
