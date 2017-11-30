package com.util;

import com.util.Util;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import org.apache.log4j.Logger;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;

public class ExcelUtil {

   private Logger logger = Logger.getLogger(ExcelUtil.class);
   private Workbook workbook;
   private InputStream is = null;
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");


   public ExcelUtil(File file) {
      try {
         this.is = new FileInputStream(file);
         this.workbook = WorkbookFactory.create(this.is);
      } catch (Exception var3) {
         var3.printStackTrace();
      }

   }

   public void close() {
      if(this.is != null) {
         try {
            this.is.close();
         } catch (IOException var2) {
            var2.printStackTrace();
         }
      }

   }

   public List getDatasInSheet(int sheetNumber) {
      ArrayList result = new ArrayList();
      Sheet sheet = this.workbook.getSheetAt(sheetNumber);
      int rowCount = sheet.getLastRowNum();
      this.logger.info("found excel rows count:" + rowCount);
      if(rowCount < 1) {
         return result;
      } else {
         boolean cellCount = false;

         for(int rowIndex = 0; rowIndex <= rowCount; ++rowIndex) {
            Row row = sheet.getRow(rowIndex);
            if(row != null) {
               short var14 = row.getLastCellNum();
               ArrayList rowData = new ArrayList();
               int cellNull = 0;

               for(short cellIndex = 0; cellIndex < var14; ++cellIndex) {
                  Cell cell = row.getCell(cellIndex);
                  if(cell == null) {
                     rowData.add("");
                     ++cellNull;
                  } else {
                     Object cellStr = this.getCellString(cell);
                     if(cellStr != null && !cellStr.toString().trim().equals("")) {
                        if(cellStr.toString().indexOf(".") > -1 && cellStr.toString().indexOf("E") > -1 && Util.isInt(cellStr.toString().substring(cellStr.toString().indexOf("E") + 1, cellStr.toString().length())) && Util.isNumeric(cellStr.toString().substring(0, cellStr.toString().indexOf("E")))) {
                           BigDecimal bd = new BigDecimal(cellStr.toString());
                           cellStr = bd.toPlainString();
                        }
                     } else {
                        ++cellNull;
                     }

                     rowData.add(cellStr);
                  }
               }

               if(cellNull != var14) {
                  result.add(rowData);
               }
            }
         }

         return result;
      }
   }

   private Object getCellString(Cell cell) {
      Object result = null;

      try {
         if(cell != null) {
            int e = cell.getCellType();
            switch(e) {
            case 0:
               if(DateUtil.isCellDateFormatted(cell)) {
                  result = this.sdf1.format(cell.getDateCellValue());
               } else {
                  result = String.valueOf(cell.getNumericCellValue());
               }
               break;
            case 1:
               result = cell.getStringCellValue();
               break;
            case 2:
               result = Double.valueOf(cell.getNumericCellValue());
               break;
            case 3:
               result = null;
               break;
            case 4:
               result = Boolean.valueOf(cell.getBooleanCellValue());
               break;
            case 5:
               result = null;
               break;
            default:
               System.out.println("枚举了所有类型");
            }
         }
      } catch (Exception var4) {
         result = null;
      }

      return result;
   }

   public int getSheetsCount() {
      return this.workbook.getNumberOfSheets();
   }

   public String getSheetName(int sheetNumber) {
      return this.workbook.getSheetAt(sheetNumber).getSheetName();
   }

   public int getSheetIndex(String sheetName) {
      return this.workbook.getSheetIndex(sheetName);
   }

   public static void main(String[] args) {
      File file = new File("f:\\导入指标.xlsx");
      ExcelUtil parser = new ExcelUtil(file);
      List datas = parser.getDatasInSheet(0);

      for(int i = 0; i < datas.size(); ++i) {
         List row = (List)datas.get(i);

         for(short j = 0; j < row.size(); ++j) {
            Object value = row.get(j);
            String data = String.valueOf(value);
            System.out.print(data + "\t");
         }

         System.out.println();
      }

   }
}
