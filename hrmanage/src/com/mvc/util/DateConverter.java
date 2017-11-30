package com.mvc.util;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.core.convert.converter.Converter;

public class DateConverter implements Converter<String, Date>{

   private static final List<String> formarts = new ArrayList<String>(4);


   static {
      formarts.add("yyyy-MM");
      formarts.add("yyyy-MM-dd");
      formarts.add("yyyy-MM-dd hh:mm");
      formarts.add("yyyy-MM-dd hh:mm:ss");
   }

   public Date convert(String source) {
      String value = source.trim();
      if("".equals(value)) {
         return null;
      } else if(source.matches("^\\d{4}-\\d{1,2}$")) {
         return this.parseDate(source, (String)formarts.get(0));
      } else if(source.matches("^\\d{4}-\\d{1,2}-\\d{1,2}$")) {
         return this.parseDate(source, (String)formarts.get(1));
      } else if(source.matches("^\\d{4}-\\d{1,2}-\\d{1,2} {1}\\d{1,2}:\\d{1,2}$")) {
         return this.parseDate(source, (String)formarts.get(2));
      } else if(source.matches("^\\d{4}-\\d{1,2}-\\d{1,2} {1}\\d{1,2}:\\d{1,2}:\\d{1,2}$")) {
         return this.parseDate(source, (String)formarts.get(3));
      } else {
         throw new IllegalArgumentException("Invalid boolean value \'" + source + "\'");
      }
   }

   public Date parseDate(String dateStr, String format) {
      Date date = null;

      try {
         SimpleDateFormat dateFormat = new SimpleDateFormat(format);
         date = dateFormat.parse(dateStr);
      } catch (Exception var5) {
         ;
      }

      return date;
   }
}
