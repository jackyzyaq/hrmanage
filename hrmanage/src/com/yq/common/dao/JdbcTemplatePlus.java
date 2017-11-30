package com.yq.common.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import javax.sql.DataSource;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.ConnectionCallback;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.ParameterDisposer;
import org.springframework.jdbc.core.PreparedStatementCallback;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.core.SqlProvider;
import org.springframework.jdbc.core.StatementCallback;
import org.springframework.jdbc.datasource.DataSourceUtils;
import org.springframework.jdbc.support.JdbcUtils;
import org.springframework.util.Assert;

public class JdbcTemplatePlus extends JdbcTemplate {

   private Connection connection = null;
   private boolean useOneConnection = false;


   public JdbcTemplatePlus() {}

   public JdbcTemplatePlus(DataSource dataSource) {
      super(dataSource);
   }

   public JdbcTemplatePlus(DataSource dataSource, boolean lazyInit) {
      super(dataSource, lazyInit);
   }

   private Connection tryGetConnection() {
      if(!this.useOneConnection) {
         return DataSourceUtils.getConnection(this.getDataSource());
      } else {
         try {
            if(this.connection == null || this.connection.isClosed()) {
               this.connection = DataSourceUtils.getConnection(this.getDataSource());
            }
         } catch (SQLException var2) {
            var2.printStackTrace();
         }

         return this.connection;
      }
   }

   private void tryReleaseConnection(Connection con) {
      if(!this.useOneConnection) {
         DataSourceUtils.releaseConnection(con, this.getDataSource());
      }

   }

   public Connection getConnection() {
      return this.connection;
   }

   public void setConnection(Connection connection) {
      this.connection = connection;
   }

   public boolean isUseOneConnection() {
      return this.useOneConnection;
   }

   public void setUseOneConnection(boolean useOneConnection) {
      this.useOneConnection = useOneConnection;
   }

   public void releaseConnection() {
      DataSourceUtils.releaseConnection(this.connection, this.getDataSource());
   }

   public static String getSql(Object sqlProvider) {
      return sqlProvider instanceof SqlProvider?((SqlProvider)sqlProvider).getSql():null;
   }

   public Object execute(ConnectionCallback action) throws DataAccessException {
      Assert.notNull(action, "Callback object must not be null");
      Connection con = this.tryGetConnection();

      Object var5;
      try {
         Connection ex;
         if(this.getNativeJdbcExtractor() != null) {
            ex = this.getNativeJdbcExtractor().getNativeConnection(con);
         } else {
            ex = this.createConnectionProxy(con);
         }

         var5 = action.doInConnection(ex);
      } catch (SQLException var8) {
         this.tryReleaseConnection(con);
         con = null;
         throw this.getExceptionTranslator().translate("ConnectionCallback", getSql(action), var8);
      } finally {
         this.tryReleaseConnection(con);
      }

      return var5;
   }

   public Object execute(StatementCallback action) throws DataAccessException {
      Assert.notNull(action, "Callback object must not be null");
      Connection con = this.tryGetConnection();
      Statement stmt = null;

      Object var8;
      try {
         Connection ex = con;
         if(this.getNativeJdbcExtractor() != null && this.getNativeJdbcExtractor().isNativeConnectionNecessaryForNativeStatements()) {
            ex = this.getNativeJdbcExtractor().getNativeConnection(con);
         }

         stmt = ex.createStatement();
         this.applyStatementSettings(stmt);
         Statement stmtToUse = stmt;
         if(this.getNativeJdbcExtractor() != null) {
            stmtToUse = this.getNativeJdbcExtractor().getNativeStatement(stmt);
         }

         Object result = action.doInStatement(stmtToUse);
         this.handleWarnings(stmt.getWarnings());
         var8 = result;
      } catch (SQLException var11) {
         JdbcUtils.closeStatement(stmt);
         stmt = null;
         this.tryReleaseConnection(con);
         con = null;
         throw this.getExceptionTranslator().translate("StatementCallback", getSql(action), var11);
      } finally {
         JdbcUtils.closeStatement(stmt);
         this.tryReleaseConnection(con);
      }

      return var8;
   }

   public Object execute(PreparedStatementCreator psc, PreparedStatementCallback action) throws DataAccessException {
      Assert.notNull(psc, "PreparedStatementCreator must not be null");
      Assert.notNull(action, "Callback object must not be null");
      if(this.logger.isDebugEnabled()) {
         String con = getSql(psc);
         this.logger.debug("Executing prepared SQL statement" + (con != null?" [" + con + "]":""));
      }

      Connection con1 = this.tryGetConnection();
      PreparedStatement ps = null;

      Object var9;
      try {
         Connection ex = con1;
         if(this.getNativeJdbcExtractor() != null && this.getNativeJdbcExtractor().isNativeConnectionNecessaryForNativePreparedStatements()) {
            ex = this.getNativeJdbcExtractor().getNativeConnection(con1);
         }

         ps = psc.createPreparedStatement(ex);
         this.applyStatementSettings(ps);
         PreparedStatement sql1 = ps;
         if(this.getNativeJdbcExtractor() != null) {
            sql1 = this.getNativeJdbcExtractor().getNativePreparedStatement(ps);
         }

         Object result = action.doInPreparedStatement(sql1);
         this.handleWarnings(ps.getWarnings());
         var9 = result;
      } catch (SQLException var12) {
         if(psc instanceof ParameterDisposer) {
            ((ParameterDisposer)psc).cleanupParameters();
         }

         String sql = getSql(psc);
         psc = null;
         JdbcUtils.closeStatement(ps);
         ps = null;
         this.tryReleaseConnection(con1);
         con1 = null;
         throw this.getExceptionTranslator().translate("PreparedStatementCallback", sql, var12);
      } finally {
         if(psc instanceof ParameterDisposer) {
            ((ParameterDisposer)psc).cleanupParameters();
         }

         JdbcUtils.closeStatement(ps);
         this.tryReleaseConnection(con1);
      }

      return var9;
   }

   public Object execute(CallableStatementCreator csc, CallableStatementCallback action) throws DataAccessException {
      Assert.notNull(csc, "CallableStatementCreator must not be null");
      Assert.notNull(action, "Callback object must not be null");
      if(this.logger.isDebugEnabled()) {
         String con = getSql(csc);
         this.logger.debug("Calling stored procedure" + (con != null?" [" + con + "]":""));
      }

      Connection con1 = this.tryGetConnection();
      CallableStatement cs = null;

      Object var9;
      try {
         Connection ex = con1;
         if(this.getNativeJdbcExtractor() != null) {
            ex = this.getNativeJdbcExtractor().getNativeConnection(con1);
         }

         cs = csc.createCallableStatement(ex);
         this.applyStatementSettings(cs);
         CallableStatement sql1 = cs;
         if(this.getNativeJdbcExtractor() != null) {
            sql1 = this.getNativeJdbcExtractor().getNativeCallableStatement(cs);
         }

         Object result = action.doInCallableStatement(sql1);
         this.handleWarnings(cs.getWarnings());
         var9 = result;
      } catch (SQLException var12) {
         if(csc instanceof ParameterDisposer) {
            ((ParameterDisposer)csc).cleanupParameters();
         }

         String sql = getSql(csc);
         csc = null;
         JdbcUtils.closeStatement(cs);
         cs = null;
         this.tryReleaseConnection(con1);
         con1 = null;
         throw this.getExceptionTranslator().translate("CallableStatementCallback", sql, var12);
      } finally {
         if(csc instanceof ParameterDisposer) {
            ((ParameterDisposer)csc).cleanupParameters();
         }

         JdbcUtils.closeStatement(cs);
         this.tryReleaseConnection(con1);
      }

      return var9;
   }

   protected void finalize() throws Throwable {
      super.finalize();
      this.releaseConnection();
   }
}
