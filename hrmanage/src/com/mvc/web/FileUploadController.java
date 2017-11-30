package com.mvc.web;

import com.util.Global;
import com.util.Util;
import com.yq.common.pojo.UploadFile;
import com.yq.common.service.UploadFileService;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletResponse;
import net.sf.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.ServletContextAware;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

@Controller
@RequestMapping({"/common/fileUpload/*"})
public class FileUploadController implements ServletContextAware {

   private ServletContext servletContext;
   @Resource
   private UploadFileService uploadFileService;


   public void setServletContext(ServletContext context) {
      this.servletContext = context;
   }

   @RequestMapping(
      value = {"upload.do"},
      method = {RequestMethod.POST}
   )
   public void handleUploadData(@RequestParam("file") CommonsMultipartFile file, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer("");
      String path = this.servletContext.getRealPath("/upload/");
      File tmpFile = new File(path);
      if(!tmpFile.exists()) {
         tmpFile.mkdir();
      }

      try {
         if(!file.isEmpty()) {
            String e = Util.getUUID();
            String fileName = file.getOriginalFilename();
            String fileType = fileName.substring(fileName.lastIndexOf("."));
            path = path + "\\" + e + fileType;
            if(".jpg,.JPG,.gif,.GIF,.png".indexOf(fileType) > -1) {
               if(file.getSize() > Global.UPLOAD_SIZE_1.longValue()) {
                  sb.append("{\'flag\':\'0\',\'msg\':\'文件超过指定大小！\'}");
               }
            } else if(file.getSize() > Global.UPLOAD_SIZE_2.longValue()) {
               sb.append("{\'flag\':\'0\',\'msg\':\'文件超过指定大小！\'}");
            }

            if(sb.length() == 0) {
               BufferedOutputStream stream = new BufferedOutputStream(new FileOutputStream(new File(path)));
               stream.write(file.getBytes());
               stream.flush();
               stream.close();
               UploadFile uploadFile = new UploadFile();
               uploadFile.setFileName(path);
               uploadFile.setFileType(file.getContentType());
               uploadFile.setUuid(e);
               uploadFile.setSize(file.getSize());
               uploadFile.setSource(file.getBytes());
               uploadFile.setRemark("");
               this.uploadFileService.insertFile(uploadFile);
               sb.append("{\'flag\':\'1\',\'upload_uuid\':\'" + e + "\'}");
            }
         } else {
            sb.append("{\'flag\':\'0\'}");
         }
      } catch (Exception var19) {
         sb.delete(0, sb.length());
         sb.append("{\'flag\':\'0\'}");
         var19.printStackTrace();
      } finally {
         response.setContentType("application/x-www-form-urlencoded; charset=UTF-8");
         response.setHeader("Cache-Control", "no-cache");

         try {
            JSONObject e1 = JSONObject.fromObject(sb.toString());
            response.setContentType("text/html");
            response.setHeader("Cache-Control", "no-cache");
            response.getWriter().println(e1.toString());
         } catch (IOException var18) {
            var18.printStackTrace();
         }

      }

   }
}
