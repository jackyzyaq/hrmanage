package com.yq.common.pojo;

import java.io.Serializable;

public class Sequence implements Serializable {

   private static final long serialVersionUID = 1L;
   private String name;
   private long nextId;


   public Sequence() {}

   public Sequence(String name, long nextId) {
      this.name = name;
      this.nextId = nextId;
   }

   public String getName() {
      return this.name;
   }

   public void setName(String name) {
      this.name = name;
   }

   public long getNextId() {
      return this.nextId;
   }

   public void setNextId(long nextId) {
      this.nextId = nextId;
   }
}
