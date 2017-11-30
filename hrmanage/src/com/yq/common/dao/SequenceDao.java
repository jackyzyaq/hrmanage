package com.yq.common.dao;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.yq.common.pojo.Sequence;
import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;
import org.springframework.stereotype.Repository;

@Repository
public class SequenceDao extends SqlMapClientDaoSupport {

   @Resource(
      name = "sqlMapClient"
   )
   private SqlMapClient sqlMapClient;


   @PostConstruct
   public void initSqlMapClient() {
      super.setSqlMapClient(this.sqlMapClient);
   }

   public synchronized long getNextId(String name) {
      Sequence seq = new Sequence(name, 0L);
      seq = (Sequence)this.getSqlMapClientTemplate().queryForObject(seq.getClass().getName() + ".selectByName", name);
      if(seq == null) {
         seq = new Sequence(name, 0L);
         this.getSqlMapClientTemplate().insert(seq.getClass().getName() + ".insert", seq);
      }

      seq.setNextId(seq.getNextId() + 1L);
      this.getSqlMapClientTemplate().update(seq.getClass().getName() + ".updateByName", seq);
      return seq.getNextId();
   }
}
