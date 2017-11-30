package com.yq.common.service;

import com.util.ContextTree;
import com.util.Global;
import com.util.Util;
import com.yq.authority.pojo.UserInfo;
import com.yq.common.dao.CommonDao;
import com.yq.common.service.CommonRemoteService;
import com.yq.faurecia.pojo.DepartmentInfo;
import com.yq.faurecia.pojo.EmployeeCard;
import com.yq.faurecia.pojo.EmployeeInfo;
import com.yq.faurecia.pojo.TimeSheet;
import com.yq.faurecia.pojo.TimeSheetDetail;
import com.yq.faurecia.service.BreakTimeInfoService;
import com.yq.faurecia.service.EmployeeCardService;
import com.yq.faurecia.service.EmployeeInfoService;
import com.yq.faurecia.service.EmployeeLeaveService;
import com.yq.faurecia.service.NationalHolidayService;
import com.yq.faurecia.service.OverTimeInfoService;
import com.yq.faurecia.service.ScheduleInfoService;
import com.yq.faurecia.service.TimeSheetDetailService;
import com.yq.faurecia.service.TimeSheetService;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CommonService {

   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   @Resource
   private CommonDao commonDao;
   @Resource
   private CommonRemoteService commonRemoteService;
   @Resource
   private ScheduleInfoService scheduleInfoService;
   @Resource
   private TimeSheetService timeSheetService;
   @Resource
   private TimeSheetDetailService timeSheetDetailService;
   @Resource
   private BreakTimeInfoService breakTimeInfoService;
   @Resource
   private OverTimeInfoService overTimeInfoService;
   @Resource
   private NationalHolidayService nationalHolidayService;
   @Resource
   private EmployeeLeaveService employeeLeaveService;
   @Resource
   private EmployeeInfoService employeeInfoService;
   @Resource
   private EmployeeCardService employeeCardService;


   public CommonDao getCommonDao() {
      return this.commonDao;
   }

   public void setCommonDao(CommonDao commonDao) {
      this.commonDao = commonDao;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int insert(String sql, Object[] obj) throws Exception {
      return this.commonDao.insert(sql, obj);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int operate(String sql, Object[] obj) throws Exception {
      return this.commonDao.operate(sql, obj);
   }

   public List findBySql(String sql) {
      return this.commonDao.findBySQL(sql);
   }

   public void runEmpTimeSheet(Date class_date, UserInfo user) {
      try {
         Iterator var4 = Global.employeeInfoMap.keySet().iterator();

         while(var4.hasNext()) {
            Integer e = (Integer)var4.next();
            this.runEmpTimeSheet(class_date, e.intValue(), user);
         }
      } catch (Exception var5) {
         var5.printStackTrace();
      }

   }

   public void runEmpTimeSheet(Date class_date, int emp_id, UserInfo user) {
      try {
         EmployeeInfo e = (EmployeeInfo)Global.employeeInfoMap.get(Integer.valueOf(emp_id));
         if(e != null) {
            List cardList = this.employeeCardService.findByEmpId(e.getId(), (Integer)null);
            List timeSheetList;
            if(cardList != null && !cardList.isEmpty()) {
               for(Iterator var7 = cardList.iterator(); var7.hasNext(); timeSheetList = null) {
                  EmployeeCard ec = (EmployeeCard)var7.next();
                  timeSheetList = this.syncTimeSheet(ec == null?"0":ec.getCard(), (String)StringUtils.defaultIfEmpty(e.getEmp09(), ""), class_date);
                  this.innerTimeSheet(e.getId().intValue(), ec == null?0:ec.getId().intValue(), timeSheetList, user);
               }
            }
         }
      } catch (Exception var9) {
         var9.printStackTrace();
      }

   }

   public List syncTimeSheet(String icCard, String car, Date class_date) {
      return this.commonRemoteService.syncTimeSheet(icCard, car, class_date);
   }

   public boolean updateTimeSheet(EmployeeInfo ei, int type, String oldCar) {
      boolean isTrue = false;
      switch(type) {
      case 1:
         isTrue = this.commonRemoteService.addICCard(ei.getId().intValue(), ei.getZh_name(), ei.getDept_name(), ei.getCard(), ei.getEmp09());
         break;
      case 2:
         isTrue = this.commonRemoteService.overICard(ei.getState().intValue(), ei.getCard(), ei.getEmp03());
         break;
      case 3:
         isTrue = this.commonRemoteService.updateICard(ei.getId().intValue(), ei.getCard(), ei.getEmp09());
         break;
      case 4:
         isTrue = this.commonRemoteService.updateCar(ei.getZh_name(), ei.getCard(), oldCar, ei.getEmp09());
      }

      return isTrue;
   }

   public void innerTimeSheet(int emp_id, int card_id, List timeSheetList, UserInfo user) {
      String operateName = user == null?"系统录入":Util.getOperator(user);
      int count = timeSheetList == null?0:timeSheetList.size();
      if(count > 0) {
         for(int i = 0; i < count; ++i) {
            Map map = (Map)timeSheetList.get(i);
            TimeSheet ts = new TimeSheet();
            ts.setEmp_id(Integer.valueOf(emp_id));
            ts.setCard_id(Integer.valueOf(card_id));
            ts.setInner_date((Date)map.get("inner_date"));
            ts.setType((String)map.get("type"));
            ts.setSource((String)map.get("source"));
            ts.setOperater(operateName);

            try {
               this.timeSheetService.insertTimeSheet(ts);
            } catch (Exception var11) {
               var11.printStackTrace();
            }
         }
      }

   }

   public Map runTimeSheetDetail(EmployeeInfo ei, Date class_date, int range) throws Exception {
      return this.timeSheetDetailService.runTimeSheetDetailNew(ei, class_date, range);
   }

   public void innerTimeSheetDetail(Map detailMap) {
      int count = detailMap == null?0:detailMap.size();
      if(count > 0) {
         TimeSheetDetail tsd = new TimeSheetDetail();
         tsd.setEmp_id((Integer)detailMap.get("emp_id"));
         tsd.setClass_date((Date)detailMap.get("class_date"));
         tsd.setClass_name((String)detailMap.get("class_name"));
         tsd.setClass_begin_date((Date)detailMap.get("class_begin_date"));
         tsd.setClass_end_date((Date)detailMap.get("class_end_date"));
         tsd.setTs_begin_date((Date)detailMap.get("ts_begin_date"));
         tsd.setTs_end_date((Date)detailMap.get("ts_end_date"));
         tsd.setShift1_number((Double)detailMap.get("shift1_number"));
         tsd.setShift2_number((Double)detailMap.get("shift2_number"));
         tsd.setAbnormal_cause(detailMap.get("abnormal_cause") == null?"":detailMap.get("abnormal_cause").toString());
         tsd.setTs_number((Integer)detailMap.get("ts_number"));
         tsd.setTb_01((Integer)detailMap.get("tb_01"));
         tsd.setTb_02((Integer)detailMap.get("tb_02"));
         tsd.setArrive_work_hours(Double.valueOf(detailMap.get("arrive_work_hours") == null?0.0D:((Double)detailMap.get("arrive_work_hours")).doubleValue()));
         tsd.setOt1_hours(Double.valueOf(detailMap.get("ot1_hours") == null?0.0D:((Double)detailMap.get("ot1_hours")).doubleValue()));
         tsd.setOt2_hours(Double.valueOf(detailMap.get("ot2_hours") == null?0.0D:((Double)detailMap.get("ot2_hours")).doubleValue()));
         tsd.setOt3_hours(Double.valueOf(detailMap.get("ot3_hours") == null?0.0D:((Double)detailMap.get("ot3_hours")).doubleValue()));
         tsd.setDeficit_hours(Double.valueOf(detailMap.get("deficit_hours") == null?0.0D:((Double)detailMap.get("deficit_hours")).doubleValue()));
         tsd.setAbsence_hours(Double.valueOf(detailMap.get("absence_hours") == null?0.0D:((Double)detailMap.get("absence_hours")).doubleValue()));
         tsd.setClass_type(detailMap.get("class_type") == null?"":detailMap.get("class_type").toString());
         tsd.setOver_hour(Double.valueOf(detailMap.get("over_hour") == null?0.0D:((Double)detailMap.get("over_hour")).doubleValue()));
         tsd.setShould_work_hours(Double.valueOf(detailMap.get("should_work_hours") == null?0.0D:((Double)detailMap.get("should_work_hours")).doubleValue()));
         tsd.setShift3_number((Double)detailMap.get("shift3_number"));
         tsd.setHour50(Double.valueOf(detailMap.get("hour50") == null?0.0D:((Double)detailMap.get("hour50")).doubleValue()));

         try {
            this.timeSheetService.insertTimeSheetDetail(tsd);
         } catch (Exception var5) {
            var5.printStackTrace();
         }
      }

   }

   public List queryMeals(String mealsName) {
      String sql = "select * from tb_meals_info where 1=1 ";
      if(!StringUtils.isEmpty(mealsName)) {
         sql = sql + " and name=\'" + mealsName + "\'";
      }

      return this.findBySql(sql);
   }

   public void updateMeals(String mealsName, String beginTime, String endTime) throws Exception {
      String sql = "update tb_meals_info set begin_time=\'" + beginTime + "\',end_time=\'" + endTime + "\' where name=\'" + mealsName + "\'";
      this.operate(sql, (Object[])null);
   }

   public List getEmployeeByDeptId(String deptIds, EmployeeInfo defaultEI) throws Exception {
      int rootId = defaultEI.getId().intValue();
      ArrayList listTree = new ArrayList();
      listTree.add(this.loadContextTree(defaultEI, 0));
      List eiList = this.employeeInfoService.findByDeptId(deptIds);
      if(eiList != null && !eiList.isEmpty()) {
         Iterator var7 = eiList.iterator();

         while(var7.hasNext()) {
            EmployeeInfo ei = (EmployeeInfo)var7.next();
            listTree.add(this.loadContextTree(ei, rootId));
         }
      }

      return listTree;
   }

   public ContextTree loadContextTree(EmployeeInfo ei, int parentId) throws Exception {
      String name = ei.getZh_name() + "|" + ((DepartmentInfo)Global.departmentInfoMap.get(ei.getDept_id())).getDept_name();
      String content = "0";
      if(!StringUtils.isEmpty(ei.getPhoto_upload_uuid())) {
         content = ei.getPhoto_upload_uuid();
      }

      return new ContextTree(ei.getId().intValue(), parentId, name, content);
   }
}
