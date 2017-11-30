package com.yq.common.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.stereotype.Service;

@Service
public class CommonDao {

   @Resource(
      name = "jdbcTemplate"
   )
   private JdbcTemplate jdbcTemplate;
   @Resource(
      name = "jdbcTemplate_ts"
   )
   private JdbcTemplate jdbcTemplate_ts;


   public JdbcTemplate getJdbcTemplate() {
      return this.jdbcTemplate;
   }

   public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
      this.jdbcTemplate = jdbcTemplate;
   }

   public int insert(final String sql, final Object[] obj) throws SQLException {
      GeneratedKeyHolder keyHolder = new GeneratedKeyHolder();
      this.jdbcTemplate.update(new PreparedStatementCreator() {
         public PreparedStatement createPreparedStatement(Connection con) throws SQLException {
            PreparedStatement ps = con.prepareStatement(sql, 1);
            if(obj != null && obj.length > 0) {
               for(int i = 0; i < obj.length; ++i) {
                  Object o = obj[i];
                  if(o instanceof String) {
                     ps.setString(i + 1, (String)o);
                  }

                  if(o instanceof Integer) {
                     ps.setInt(i + 1, ((Integer)o).intValue());
                  }

                  if(o instanceof Date) {
                     ps.setTimestamp(i + 1, new Timestamp(((Date)o).getTime()));
                  }

                  if(o instanceof BigDecimal) {
                     ps.setBigDecimal(i + 1, (BigDecimal)o);
                  }

                  if(o instanceof Byte) {
                     ps.setByte(i + 1, ((Byte)o).byteValue());
                  }

                  if(o instanceof Long) {
                     ps.setLong(i + 1, ((Long)o).longValue());
                  }

                  if(o instanceof Float) {
                     ps.setFloat(i + 1, ((Float)o).floatValue());
                  }

                  if(o instanceof Double) {
                     ps.setDouble(i + 1, ((Double)o).doubleValue());
                  }
               }
            }

            return ps;
         }
      }, keyHolder);
      return keyHolder.getKey().intValue();
   }

   public int operate(String sql, Object[] obj) {
      return this.jdbcTemplate.update(sql, obj);
   }

   public void createTableBySQL(String sql) {
      this.jdbcTemplate.execute(sql);
   }

   public void executeBySQL(String sql) {
      this.jdbcTemplate.execute(sql);
   }

   public List findBySQL(String sql) {
      return this.jdbcTemplate.queryForList(sql);
   }

   public int findRowCountBySQL(String sql) {
      return this.jdbcTemplate.queryForInt(sql);
   }

   public List findRemoteBySQL(String sql) {
      return this.jdbcTemplate_ts.queryForList(sql);
   }

   public void executeRemoteBySQL(String sql) {
      this.jdbcTemplate_ts.execute(sql);
   }
}
