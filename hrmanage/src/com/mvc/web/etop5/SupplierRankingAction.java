package com.mvc.web.etop5;

import com.util.ExcelUtil;
import com.util.Global;
import com.util.Page;
import com.util.ReflectPOJO;
import com.util.Util;
import com.yq.authority.pojo.UserInfo;
import com.yq.authority.service.UserInfoService;
import com.yq.common.pojo.Common;
import com.yq.common.pojo.UploadFile;
import com.yq.common.service.UploadFileService;
import com.yq.company.etop5.pojo.SupplierRanking;
import com.yq.company.etop5.service.SupplierRankingService;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.sf.json.JSONException;
import net.sf.json.JSONObject;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping({"/common/supplierranking/*"})
public class SupplierRankingAction extends Common {

   private static final long serialVersionUID = -3979556978770262299L;
   private static final Logger logger = Logger.getLogger(SupplierRankingAction.class);
   @Resource
   private UserInfoService userService;
   @Resource
   private SupplierRankingService supplierRankingService;
   @Resource
   private UploadFileService uploadFileService;


   @RequestMapping({"queryResult.do"})
   public void queryResult(Page page, SupplierRanking supplierRanking, HttpServletRequest request, HttpServletResponse response) throws Exception {
      page.setSidx(request.getParameter("sidx") != null && !request.getParameter("sidx").toString().equals("")?request.getParameter("sidx").toString():"update_date");
      page.setSord(request.getParameter("sord") != null && !request.getParameter("sord").toString().equals("")?request.getParameter("sord").toString():"desc");

      try {
         List e = this.supplierRankingService.findByCondition(supplierRanking, (Page)null);
         page.setTotalCount(e.size());
         StringBuffer sb = new StringBuffer("");
         sb.append("{\'totalCount\':" + page.getTotalCount() + ",\'pageSize\':" + page.getPageSize() + ",\'pageIndex\':" + page.getPageIndex() + ",");
         List result = this.supplierRankingService.findByCondition(supplierRanking, page);
         sb.append("\'rows\':[");
         Iterator var9 = result.iterator();

         while(var9.hasNext()) {
            SupplierRanking json = (SupplierRanking)var9.next();
            sb.append("{");
            ArrayList attrList = new ArrayList();
            ReflectPOJO.getAttrList(json, attrList);
            Iterator var12 = attrList.iterator();

            while(var12.hasNext()) {
               String attr = (String)var12.next();
               sb.append("\'" + attr + "\':").append("\"" + Util.convertToString(ReflectPOJO.invokGetMethod(json, attr)) + "\",");
            }

            if(attrList.size() > 0) {
               sb.deleteCharAt(sb.length() - 1);
            }

            attrList = null;
            sb.append("},");
         }

         if(result.size() > 0) {
            sb.deleteCharAt(sb.length() - 1);
         }

         sb.append("]}");
         JSONObject json1 = JSONObject.fromObject(sb.toString());
         response.setContentType("application/x-www-form-urlencoded; charset=UTF-8");
         response.setHeader("Cache-Control", "no-cache");
         response.getWriter().println(json1.toString());
      } catch (JSONException var13) {
         var13.printStackTrace();
      } catch (Exception var14) {
         var14.printStackTrace();
      }

   }

   @RequestMapping({"supplierRankingAdd.do"})
   public void supplierRankingAdd(SupplierRanking supplierRanking, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer();

      try {
         String e = "";
         UserInfo user = Global.getUserObject(request);
         supplierRanking.setOperater(Util.getOperator(user));
         this.supplierRankingService.save(supplierRanking);
         e = "操作成功！";
         sb.append("{");
         sb.append("\'msg\':\'" + e + "\'");
         sb.append("}");
      } catch (Exception var16) {
         var16.printStackTrace();
         sb.delete(0, sb.toString().length());
         sb.append("{");
         sb.append("\'msg\':\'系统原因，请稍后再试！\'");
         sb.append("}");
      } finally {
         JSONObject json = JSONObject.fromObject(sb.toString());
         response.setContentType("application/x-www-form-urlencoded; charset=UTF-8");
         response.setHeader("Cache-Control", "no-cache");

         try {
            response.getWriter().println(json.toString());
         } catch (IOException var15) {
            var15.printStackTrace();
         }

      }

   }

   @RequestMapping({"autoComplete.do"})
   public void autoComplete(String supplier, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer("");

      try {
         supplier = (String)StringUtils.defaultIfEmpty(supplier, "");
         HashMap e = new HashMap();
         e.put("supplier", supplier);
         List list = this.supplierRankingService.autoComplete(e);
         sb.append("[");
         if(list != null && list.size() > 0) {
            Iterator var8 = list.iterator();

            while(var8.hasNext()) {
               SupplierRanking ci = (SupplierRanking)var8.next();
               sb.append("{");
               sb.append((new StringBuilder("\"value\":")).append("\"" + ci.getSupplier() + "\""));
               sb.append("},");
            }

            sb.deleteCharAt(sb.length() - 1);
         }

         sb.append("]");
      } catch (Exception var17) {
         var17.printStackTrace();
      } finally {
         response.setContentType("application/x-www-form-urlencoded; charset=UTF-8");
         response.setHeader("Cache-Control", "no-cache");

         try {
            response.getWriter().println(sb.toString());
         } catch (IOException var16) {
            var16.printStackTrace();
         }

      }

   }

   @RequestMapping({"exportModel.do"})
   public void exportModel(HttpServletRequest request, HttpServletResponse response) {
      try {
         HSSFWorkbook e = new HSSFWorkbook();
         this.createSheet(e, "供应商月数据");
         this.createSheet(e, "质量最佳供应商");
         this.createSheet(e, "质量最差供应商");
         this.createSheet(e, "交付最佳供应商");
         this.createSheet(e, "交付最差供应商");
         response.reset();
         response.setContentType("application/msexcel;charset=UTF-8");

         try {
            response.addHeader("Content-Disposition", "attachment;filename=\"" + new String("供应商绩效管理.xls".getBytes("GBK"), "ISO8859_1") + "\"");
            ServletOutputStream e1 = response.getOutputStream();
            e.write(e1);
            e1.flush();
            e1.close();
         } catch (Exception var5) {
            var5.printStackTrace();
         }
      } catch (Exception var6) {
         var6.printStackTrace();
      }

   }

   private void createSheet(HSSFWorkbook workBook, String sheetName) {
      HSSFSheet sheet = workBook.createSheet(sheetName);
      HSSFRow row = sheet.createRow(0);

      for(int cell0 = 0; cell0 < Global.supplier_down_column.length; ++cell0) {
         row.createCell(cell0).setCellValue(new HSSFRichTextString(Global.supplier_down_column[cell0]));
      }

      row = sheet.createRow(1);
      HSSFCell var7 = row.createCell(0);
      var7.setCellValue(new HSSFRichTextString("*******"));
      HSSFCell cell1 = row.createCell(1);
      cell1.setCellValue(new HSSFRichTextString("98.0"));
   }

   @RequestMapping({"importExcel.do"})
   public void importExcel(SupplierRanking supplierRanking, String excel, HttpServletRequest request, HttpServletResponse response) {
      StringBuffer sb = new StringBuffer("");
      String msg = "";

      try {
         UserInfo e = Global.getUserObject(request);
         supplierRanking.setOperater(Util.getOperator(e));
         if(StringUtils.isEmpty(excel)) {
            msg = "找不到上传文件，请重新上传！";
         } else {
            UploadFile uf = this.uploadFileService.getUploadFileByUUId(excel);
            String filename = uf.getFileName().replace("\\", "\\\\");
            System.out.println("*****解析XLSX文件 *****");
            ExcelUtil parser = new ExcelUtil(new File(filename));
            msg = this.validateData(parser, supplierRanking).toString();
            System.out.println("*****解析XLSX文件 结束*****");
            if(msg.toString().equals("")) {
               msg = "操作成功！";
            }
         }

         sb.append("{");
         sb.append("\'flag\':\'" + Global.FLAG[1] + "\',");
         sb.append("\'msg\':\'" + msg + "\'");
         sb.append("}");
      } catch (Exception var20) {
         sb.delete(0, sb.toString().length());
         sb.append("{");
         sb.append("\'flag\':\'" + Global.FLAG[0] + "\',");
         sb.append("\'msg\':\'系统原因，请稍后再试！\'");
         sb.append("}");
         var20.printStackTrace();
      } finally {
         JSONObject json = JSONObject.fromObject(sb.toString());
         response.setContentType("application/x-www-form-urlencoded; charset=UTF-8");
         response.setHeader("Cache-Control", "no-cache");

         try {
            response.getWriter().println(json.toString());
         } catch (IOException var19) {
            var19.printStackTrace();
         }

      }

   }

   private StringBuffer validateData(ExcelUtil parser, SupplierRanking supplierRanking) throws Exception {
      StringBuffer message = new StringBuffer("");
      List datas = parser.getDatasInSheet(0);
      if(datas != null && datas.size() > 0) {
         message = this.validateDataSub(datas);
         if(message.toString().trim().equals("")) {
            int rows = datas.size();

            for(int row = 1; row < rows; ++row) {
               List list = (List)datas.get(row);
               byte k = 0;
               String supplier = list.get(k).toString().trim();
               int var11 = k + 1;
               String kpi_1 = list.get(var11).toString().trim();
               ++var11;
               if(!Util.isNumeric(kpi_1)) {
                  message.append(Global.supplier_down_column[1] + "‘" + kpi_1 + "’" + "内容不正确！");
                  break;
               }

               if(message.toString().trim().equals("")) {
                  supplierRanking.setSupplier(supplier);
                  supplierRanking.setKpi_1(Double.valueOf(Util.formatDouble1(Double.valueOf(kpi_1).doubleValue())));
                  this.supplierRankingService.save(supplierRanking);
               }
            }
         }
      } else {
         message.append("没有数据！");
      }

      supplierRanking.setType(Global.supplier_ranking_type[0]);
      this.addStatus(parser.getDatasInSheet(1), supplierRanking);
      supplierRanking.setType(Global.supplier_ranking_type[1]);
      this.addStatus(parser.getDatasInSheet(2), supplierRanking);
      supplierRanking.setType(Global.supplier_ranking_type[2]);
      this.addStatus(parser.getDatasInSheet(3), supplierRanking);
      supplierRanking.setType(Global.supplier_ranking_type[3]);
      this.addStatus(parser.getDatasInSheet(4), supplierRanking);
      return message;
   }

   private StringBuffer validateDataSub(List datas) {
      StringBuffer message = new StringBuffer("");
      int count = Global.supplier_down_column.length;
      int rows = datas.size();

      for(int row = 0; row < rows && message.toString().trim().equals(""); ++row) {
         List list = (List)datas.get(row);
         if(list.size() != count) {
            message.append("第" + (row + 1) + "行格式不对或有空值！");
            break;
         }

         int cell;
         Object o;
         if(row == 0) {
            for(cell = 0; cell < count; ++cell) {
               o = list.get(cell);
               if(!Util.convertToString(o).equals(Global.supplier_down_column[cell])) {
                  message.append("第" + (row + 1) + "行文本内容格式不对！");
                  break;
               }
            }
         } else {
            for(cell = 0; cell < count; ++cell) {
               o = list.get(cell);
               if(o == null || Util.convertToString(o).equals("")) {
                  message.append(Global.supplier_down_column[cell] + "不能为空！");
                  break;
               }
            }
         }
      }

      return message;
   }

   private StringBuffer addStatus(List datas, SupplierRanking supplierRanking) throws Exception {
      StringBuffer message = new StringBuffer("");
      if(datas != null && datas.size() > 0) {
         message = this.validateDataSub(datas);
         if(message.toString().trim().equals("")) {
            int rows = datas.size();

            for(int row = 1; row < rows; ++row) {
               List list = (List)datas.get(row);
               byte k = 0;
               String supplier = list.get(k).toString().trim();
               int var10 = k + 1;
               String kpi_1 = list.get(var10).toString().trim();
               ++var10;
               if(!Util.isNumeric(kpi_1)) {
                  message.append(Global.supplier_down_column[1] + "‘" + kpi_1 + "’" + "内容不正确！");
                  break;
               }

               if(message.toString().trim().equals("")) {
                  supplierRanking.setSupplier(supplier);
                  supplierRanking.setKpi_1(Double.valueOf(kpi_1));
                  this.supplierRankingService.saveStatus(supplierRanking);
               }
            }
         }
      } else {
         message.append("没有数据！");
      }

      return message;
   }

   public SupplierRankingService getSupplierRankingService() {
      return this.supplierRankingService;
   }

   public void setSupplierRankingService(SupplierRankingService supplierRankingService) {
      this.supplierRankingService = supplierRankingService;
   }

   public UserInfoService getUserService() {
      return this.userService;
   }

   public void setUserService(UserInfoService userService) {
      this.userService = userService;
   }

   public static Logger getLogger() {
      return logger;
   }

   public static long getSerialVersionUID() {
      return -3979556978770262299L;
   }
}
