package com.yq.common.service;

import com.yq.common.dao.SequenceDao;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;

@Service
public class SequenceService {

   @Resource
   private SequenceDao sequenceDao;


   public long getNextId(String name) {
      return this.sequenceDao.getNextId(name);
   }

   public SequenceDao getSequenceDao() {
      return this.sequenceDao;
   }

   public void setSequenceDao(SequenceDao sequenceDao) {
      this.sequenceDao = sequenceDao;
   }
}
