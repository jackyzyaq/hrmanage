package com.yq.faurecia.service;

import com.util.Global;
import com.util.MD5;
import com.util.Page;
import com.util.Util;
import com.yq.authority.pojo.UserInfo;
import com.yq.authority.service.UserInfoService;
import com.yq.faurecia.dao.EmployeeInfoDao;
import com.yq.faurecia.pojo.DepartmentInfo;
import com.yq.faurecia.pojo.EmployeeCard;
import com.yq.faurecia.pojo.EmployeeInfo;
import com.yq.faurecia.pojo.EmployeeInfoHistory;
import com.yq.faurecia.pojo.EmployeeLeave;
import com.yq.faurecia.pojo.PositionInfo;
import com.yq.faurecia.service.DepartmentInfoService;
import com.yq.faurecia.service.EmployeeCardService;
import com.yq.faurecia.service.EmployeeLeaveService;
import java.sql.SQLException;
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

@Service("employeeInfoService")
public class EmployeeInfoService {

   private String columns = " \tid,emp_code,zh_name,en_name,type,          \t\tdept_id,(select dept_name from tb_department_info where id=dept_id) dept_name,          \t\tposition_id,(select pos_name from tb_position_info where id=position_id) position_name,          \t\tproject_id,(select project_name from tb_project_info where id=project_id) project_name,          \t\tgap_id,(select gap_name from tb_gap_info where id=gap_id) gap_name, \t\t\t\tphoto_upload_uuid,birthday,photo,phone,mobile,education,college,\t\t\t\tprofession,graduation_date,try_month,try_state,state,begin_date,end_date,create_date,update_date,\t\t\t\temp01,emp02,emp03,emp04,emp05,emp06,emp07,emp08,emp09,emp10,emp11,emp12,emp13,emp14,emp15,\t\t\t\tlabor_type,hr_status_id,is_login,position_seniority,contract_type,age,residence,address,marry_state,emp16,emp17,emp18,emp19,emp20,emp21,emp22,emp23,pims ";
   private String columns_history = " \temp_id,emp_code,zh_name,en_name,type,          \t\tdept_id,(select dept_name from tb_department_info where id=dept_id) dept_name,          \t\tposition_id,(select pos_name from tb_position_info where id=position_id) position_name,          \t\tproject_id,(select project_name from tb_project_info where id=project_id) project_name,          \t\tgap_id,(select gap_name from tb_gap_info where id=gap_id) gap_name, \t\t\t\tphoto_upload_uuid,birthday,photo,phone,mobile,education,college,\t\t\t\tprofession,graduation_date,try_month,try_state,state,begin_date,end_date,create_date,update_date,\t\t\t\temp01,emp02,emp03,emp04,emp05,emp06,emp07,emp08,emp09,emp10,emp11,emp12,emp13,emp14,emp15,\t\t\t\tlabor_type,hr_status_id,is_login,position_seniority,contract_type,age,residence,address,marry_state,emp16,emp17,emp18,emp19,emp20,emp21,emp22,history_type,emp23,pims ";
   private String columns_history_change = " emp_id,before_change,after_change,history_type,create_date ";
   private String defaultTable = "tb_employee_info";
   private String historyTable = "tb_employee_info_history";
   private String historyChangeTable = "tb_employee_info_history_change";
   private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   @Resource
   private EmployeeInfoDao employeeInfoDao;
   @Resource
   private UserInfoService userInfoService;
   @Resource
   private EmployeeCardService employeeCardService;
   @Resource
   private EmployeeLeaveService employeeLeaveService;
   @Resource
   private DepartmentInfoService departmentInfoService;


   public EmployeeInfo queryById(int id) throws Exception {
      return this.queryById(id, Integer.valueOf(1));
   }

   public EmployeeInfo queryById(int id, Integer state) throws Exception {
      String state_s = "";
      if(state != null) {
         state_s = " and state=" + state + " ";
      }

      String sql = " select " + this.columns + " from " + this.defaultTable + " t " + " where id = " + id + state_s;
      return this.employeeInfoDao.queryObjectBySql(sql);
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public int save(EmployeeInfo employeeInfo, String card) throws Exception {
      int id = employeeInfo.getId().intValue();
      employeeInfo.setEmp10(Integer.valueOf(id));
      this.employeeInfoDao.save(employeeInfo);
      EmployeeCard employeeCard = new EmployeeCard();
      employeeCard.setEmp_id(Integer.valueOf(id));
      employeeCard.setCard(card);
      employeeCard.setId(Integer.valueOf(this.employeeCardService.save(employeeCard)));
      EmployeeLeave el = Util.getEmployeeLeave(Util.getAnnualLeaveDays(employeeInfo));
      if(el != null) {
         this.employeeLeaveService.save(el);
      }

      String userName = Util.alternateZero(id);
      UserInfo userInfo = this.userInfoService.queryByName(userName, (Integer)null);
      if(employeeInfo.getIs_login().intValue() == 0) {
         if(userInfo != null && userInfo.getState().intValue() == 1) {
            userInfo.setState(Integer.valueOf(0));
            this.userInfoService.update(userInfo);
         }
      } else if(employeeInfo.getIs_login().intValue() == 1) {
         if(userInfo == null) {
            userInfo = new UserInfo();
            userInfo.setName(userName);
            userInfo.setPwd(MD5.encrypt("123456"));
            userInfo.setZh_name(employeeInfo.getZh_name());
            userInfo.setUpload_uuid(employeeInfo.getPhoto_upload_uuid());
            userInfo.setState(Integer.valueOf(1));
            this.userInfoService.save(userInfo);
         } else if(userInfo != null && userInfo.getState().intValue() == 0) {
            userInfo.setState(Integer.valueOf(1));
            this.userInfoService.update(userInfo);
         }
      }

      Global.loadData(employeeInfo);
      return id;
   }

   @Transactional(
      rollbackFor = {Exception.class}
   )
   public void update(EmployeeInfo employeeInfo) throws Exception {
      EmployeeInfo tmpEI = this.queryById(employeeInfo.getId().intValue(), (Integer)null);
      if(employeeInfo.getState().intValue() == 1) {
         employeeInfo.setEmp03((Date)null);
         employeeInfo.setEmp04((Date)null);
         employeeInfo.setEmp05((String)null);
      }

      this.employeeInfoDao.update(employeeInfo);
      this.employeeInfoDao.saveHistory(new EmployeeInfoHistory(tmpEI.getId().intValue(), Global.employee_history_type[7], tmpEI));
      if(!Util.convertToString(employeeInfo.getPosition_id()).equals(Util.convertToString(tmpEI.getPosition_id()))) {
         this.employeeInfoDao.saveHistoryChange(new EmployeeInfoHistory(tmpEI.getId().intValue(), Global.employee_history_type[0], ((PositionInfo)Global.positionInfoMap.get(tmpEI.getPosition_id())).getPos_name(), ((PositionInfo)Global.positionInfoMap.get(employeeInfo.getPosition_id())).getPos_name(), employeeInfo.getEmp16()));
      }

      if(!Util.convertToString(employeeInfo.getHr_status_id()).equals(Util.convertToString(tmpEI.getHr_status_id()))) {
         this.employeeInfoDao.saveHistoryChange(new EmployeeInfoHistory(tmpEI.getId().intValue(), Global.employee_history_type[1], (String)Global.hrStatusMap.get(tmpEI.getHr_status_id()), (String)Global.hrStatusMap.get(employeeInfo.getHr_status_id()), employeeInfo.getEmp17()));
      }

      if(!Util.convertToString(employeeInfo.getEmp01()).equals(Util.convertToString(tmpEI.getEmp01()))) {
         this.employeeInfoDao.saveHistoryChange(new EmployeeInfoHistory(tmpEI.getId().intValue(), Global.employee_history_type[2], Util.convertToString(tmpEI.getEmp01()), Util.convertToString(employeeInfo.getEmp01()), employeeInfo.getEmp18()));
      }

      if(!Util.convertToString(employeeInfo.getLabor_type()).equals(Util.convertToString(tmpEI.getLabor_type()))) {
         this.employeeInfoDao.saveHistoryChange(new EmployeeInfoHistory(tmpEI.getId().intValue(), Global.employee_history_type[3], Util.convertToString(tmpEI.getLabor_type()), Util.convertToString(employeeInfo.getLabor_type()), employeeInfo.getEmp19()));
      }

      if(!Util.convertToString(employeeInfo.getContract_type()).equals(Util.convertToString(tmpEI.getContract_type()))) {
         this.employeeInfoDao.saveHistoryChange(new EmployeeInfoHistory(tmpEI.getId().intValue(), Global.employee_history_type[4], Util.convertToString(tmpEI.getContract_type()), Util.convertToString(employeeInfo.getContract_type()), employeeInfo.getEmp20()));
      }

      if(!Util.convertToString(employeeInfo.getDept_id()).equals(Util.convertToString(tmpEI.getDept_id()))) {
         this.employeeInfoDao.saveHistoryChange(new EmployeeInfoHistory(tmpEI.getId().intValue(), Global.employee_history_type[5], ((DepartmentInfo)Global.departmentInfoMap.get(tmpEI.getDept_id())).getDept_name(), ((DepartmentInfo)Global.departmentInfoMap.get(employeeInfo.getDept_id())).getDept_name(), employeeInfo.getEmp21()));
      }

      if(employeeInfo.getBegin_date().getTime() != tmpEI.getBegin_date().getTime() || employeeInfo.getEnd_date().getTime() != tmpEI.getEnd_date().getTime()) {
         this.employeeInfoDao.saveHistoryChange(new EmployeeInfoHistory(tmpEI.getId().intValue(), Global.employee_history_type[6], this.sdf.format(tmpEI.getBegin_date()) + "~" + this.sdf.format(tmpEI.getEnd_date()), this.sdf.format(employeeInfo.getBegin_date()) + "~" + this.sdf.format(employeeInfo.getEnd_date()), employeeInfo.getEmp22()));
      }

      if(!Util.convertToString(tmpEI.getHr_status_id()).equals(Util.convertToString(employeeInfo.getHr_status_id())) || !Util.convertToString(tmpEI.getEmp06()).equals(Util.convertToString(employeeInfo.getEmp06())) || !Util.convertToString(tmpEI.getEmp08()).equals(Util.convertToString(employeeInfo.getEmp08()))) {
         EmployeeLeave userName = Util.getEmployeeLeave(Util.getAnnualLeaveDays(employeeInfo));
         if(userName != null) {
            this.employeeLeaveService.updateByEmpIdAndYear(userName);
         }
      }

      String userName1 = Util.alternateZero(employeeInfo.getId().intValue());
      UserInfo userInfo = this.userInfoService.queryByName(userName1, (Integer)null);
      if(employeeInfo.getIs_login().intValue() == 0) {
         if(userInfo != null && userInfo.getState().intValue() == 1) {
            userInfo.setState(Integer.valueOf(0));
            this.userInfoService.update(userInfo);
         }
      } else if(employeeInfo.getIs_login().intValue() == 1) {
         if(userInfo == null) {
            userInfo = new UserInfo();
            userInfo.setName(userName1);
            userInfo.setPwd(MD5.encrypt("123456"));
            userInfo.setZh_name(employeeInfo.getZh_name());
            userInfo.setUpload_uuid(employeeInfo.getPhoto_upload_uuid());
            userInfo.setState(Integer.valueOf(1));
            this.userInfoService.save(userInfo);
         } else if(userInfo != null && userInfo.getState().intValue() == 0) {
            userInfo.setState(Integer.valueOf(1));
            this.userInfoService.update(userInfo);
         }
      }

      Global.loadData(employeeInfo);
   }

   public EmployeeInfoDao getEmployeeInfoDao() {
      return this.employeeInfoDao;
   }

   public void setEmployeeInfoDao(EmployeeInfoDao employeeInfoDao) {
      this.employeeInfoDao = employeeInfoDao;
   }

   public List findByCondition(EmployeeInfo employeeInfo, Page page) throws Exception {
      Object result = new ArrayList();
      if(employeeInfo != null) {
         String orderby = "";
         String rownumber = "";
         if(page != null && page.getTotalCount() > 0) {
            int sql = page.getPageSize();
            int fr = (page.getPageIndex() - 1) * sql;
            if(fr < 0) {
               fr = 0;
            }

            orderby = "  order by t." + page.getSidx() + " " + page.getSord() + " ";
            rownumber = " and  RowNumber > " + fr + " and RowNumber <=" + (fr + sql) + " ";
         } else {
            orderby = "  order by t.update_date desc ";
         }

         StringBuffer sql1 = new StringBuffer("");
         sql1.append("select * from ( ");
         sql1.append(" select " + this.columns + " ");
         sql1.append("        ,ROW_NUMBER() OVER (" + orderby + ") AS RowNumber   ");
         sql1.append(" from " + this.defaultTable + " t   ");
         sql1.append(" where 1=1 ");
         if(!StringUtils.isEmpty(employeeInfo.getEmp_code())) {
            sql1.append(" and t.emp_code = \'" + employeeInfo.getEmp_code() + "\' ");
         }

         if(!StringUtils.isEmpty(employeeInfo.getTry_state())) {
            sql1.append(" and t.try_state = \'" + employeeInfo.getTry_state() + "\' ");
         }

         if(employeeInfo.getEmp08_begin() != null) {
            sql1.append(" and t.emp08 >= \'" + this.sdf.format(employeeInfo.getEmp08_begin()) + "\' ");
         }

         if(employeeInfo.getEmp08_end() != null) {
            sql1.append(" and t.emp08 <= \'" + this.sdf.format(employeeInfo.getEmp08_end()) + "\' ");
         }

         if(employeeInfo.getEmp03_begin() != null) {
            sql1.append(" and t.emp03 >= \'" + this.sdf.format(employeeInfo.getEmp03_begin()) + "\' ");
         }

         if(employeeInfo.getEmp03_end() != null) {
            sql1.append(" and t.emp03 <= \'" + this.sdf.format(employeeInfo.getEmp03_end()) + "\' ");
         }

         if(employeeInfo.getEnd_date() != null) {
            sql1.append(" and t.end_date <= \'" + this.sdf.format(employeeInfo.getEnd_date()) + "\' ");
         }

         if(employeeInfo.getEmp04_begin() != null) {
            sql1.append(" and t.emp04 >= \'" + this.sdf.format(employeeInfo.getEmp04_begin()) + "\' ");
         }

         if(employeeInfo.getEmp04_end() != null) {
            sql1.append(" and t.emp04 <= \'" + this.sdf.format(employeeInfo.getEmp04_end()) + "\' ");
         }

         if(!StringUtils.isEmpty(employeeInfo.getZh_name())) {
            sql1.append(" and t.zh_name like \'%" + employeeInfo.getZh_name() + "%\' ");
         }

         if(employeeInfo.getDept_id() != null) {
            sql1.append(" and t.dept_id in(" + employeeInfo.getDept_id() + ") ");
         }

         if(employeeInfo.getGap_id() != null) {
            sql1.append(" and t.gap_id in(" + employeeInfo.getGap_id() + ") ");
         }

         if(!StringUtils.isEmpty(employeeInfo.getDept_ids())) {
            sql1.append(" and t.dept_id in(" + employeeInfo.getDept_ids() + ") ");
         }

         if(employeeInfo.getPosition_id() != null) {
            sql1.append(" and t.position_id =" + employeeInfo.getPosition_id() + " ");
         }

         if(employeeInfo.getBegin_date() != null) {
            sql1.append(" and t.begin_date >= \'" + this.sdf.format(employeeInfo.getBegin_date()) + "\' ");
         }

         if(employeeInfo.getEnd_date() != null) {
            sql1.append(" and t.end_date <= \'" + this.sdf.format(employeeInfo.getEnd_date()) + "\' ");
         }

         if(employeeInfo.getPosition_id() != null) {
            sql1.append(" and t.position_id =" + employeeInfo.getPosition_id() + " ");
         }

         if(!StringUtils.isEmpty(employeeInfo.getType())) {
            sql1.append(" and t.type = \'" + employeeInfo.getType() + "\' ");
         }

         if(!StringUtils.isEmpty(employeeInfo.getEmp09())) {
            sql1.append(" and t.emp09 = \'" + employeeInfo.getEmp09() + "\' ");
         }

         if(employeeInfo.getState() != null) {
            sql1.append(" and t.state =" + employeeInfo.getState() + " ");
         }

         if(!StringUtils.isEmpty(employeeInfo.getStates())) {
            sql1.append(" and t.state in(" + employeeInfo.getStates() + ") ");
         }

         sql1.append(" ) t where 1=1 " + rownumber);
         result = this.employeeInfoDao.findBySql(sql1.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public List autoComplete(Map params) throws Exception {
      List result = null;
      if(params != null && params.size() > 0) {
         StringBuffer sql = new StringBuffer("");
         sql.append("select * from (");
         sql.append(" select " + this.columns + ",ROW_NUMBER() OVER (order by t.id) AS RowNumber ");
         sql.append(" from " + this.defaultTable + " t   ");
         sql.append(" where 1=1 ");
         if(!StringUtils.isEmpty((CharSequence)params.get("emp_name"))) {
            sql.append(" and t.zh_name like \'%" + (String)params.get("emp_name") + "%\' ");
         }

         if(!StringUtils.isEmpty((CharSequence)params.get("emp_id"))) {
            sql.append(" and t.id =" + (String)params.get("emp_id") + " ");
         }

         if(!StringUtils.isEmpty((CharSequence)params.get("dept_ids"))) {
            sql.append(" and t.dept_id in(" + (String)params.get("dept_ids") + ") ");
         }

         if(!StringUtils.isEmpty((CharSequence)params.get("emp_code"))) {
            sql.append(" and t.emp_code in(" + (String)params.get("emp_code") + ") ");
         }

         sql.append(" ) t where RowNumber > 0 and RowNumber <=10 ");
         result = this.employeeInfoDao.findBySql(sql.toString());
      }

      return (List)(result == null?new ArrayList():result);
   }

   public List findHTRemid(Date startDate, Date endDate) throws Exception {
      if(startDate != null && endDate != null) {
         StringBuffer sql = new StringBuffer("");
         sql.append(" select " + this.columns + " ");
         sql.append(" from " + this.defaultTable + " t   ");
         sql.append(" where state = 1 ");
         sql.append(" and \'" + this.sdf.format(startDate) + "\' <= t.end_date ");
         sql.append(" and \'" + this.sdf.format(endDate) + "\' >= t.end_date ");
         sql.append("  order by t.end_date desc ");
         return this.employeeInfoDao.findBySql(sql.toString());
      } else {
         return null;
      }
   }

   public List findBirthDayRemid(Date startDate, Date endDate) throws Exception {
      if(startDate != null && endDate != null) {
         StringBuffer sql = new StringBuffer("");
         sql.append(" select " + this.columns + " ");
         sql.append(" from " + this.defaultTable + " t   ");
         sql.append(" where state = 1 ");
         sql.append(" and \'" + this.sdf.format(startDate) + "\' <= t.birthday ");
         sql.append(" and \'" + this.sdf.format(endDate) + "\' >= t.birthday ");
         sql.append("  order by t.birthday desc ");
         return this.employeeInfoDao.findBySql(sql.toString());
      } else {
         return null;
      }
   }

   public List findTryoutDayRemid(Date startDate, Date endDate) throws Exception {
      if(startDate != null && endDate != null) {
         StringBuffer sql = new StringBuffer("");
         sql.append(" select " + this.columns + " ");
         sql.append(" from " + this.defaultTable + " t   ");
         sql.append(" where state = 1 ");
         sql.append(" and \'" + this.sdf.format(startDate) + "\' <= dateadd(month,t.try_month,t.emp08) ");
         sql.append(" and \'" + this.sdf.format(endDate) + "\' >= dateadd(month,t.try_month,t.emp08) ");
         sql.append("  order by dateadd(month,t.try_month,t.emp08) desc ");
         return this.employeeInfoDao.findBySql(sql.toString());
      } else {
         return null;
      }
   }

   public EmployeeInfo findByEmpCode(String emp_code) throws Exception {
      String sql = " select " + this.columns + " from " + this.defaultTable + " t " + " where state=1 and emp_code = \'" + emp_code + "\' ";
      return this.employeeInfoDao.queryObjectBySql(sql);
   }

   public boolean checkEmpCode(String emp_code) throws Exception {
      boolean isTrue = false;
      EmployeeInfo employeeInfo = new EmployeeInfo();
      employeeInfo.setEmp_code(emp_code);
      List mis = this.findByCondition(employeeInfo, (Page)null);
      if(mis != null && mis.size() > 0) {
         isTrue = true;
      }

      return isTrue;
   }

   public boolean checkEmpCarNum(String emp09) throws Exception {
      boolean isTrue = false;
      EmployeeInfo employeeInfo = new EmployeeInfo();
      employeeInfo.setEmp09(emp09);
      List mis = this.findByCondition(employeeInfo, (Page)null);
      if(mis != null && mis.size() > 0) {
         isTrue = true;
      }

      return isTrue;
   }

   public int getMaxId() {
      String sql = "select max(id) id from " + this.defaultTable;
      EmployeeInfo ei = null;

      try {
         ei = this.employeeInfoDao.queryObjectBySql(sql);
      } catch (SQLException var4) {
         var4.printStackTrace();
      }

      return ei != null && ei.getId() != null?ei.getId().intValue():0;
   }

   public String getLeaderAllNameByDeptId(Integer deptId, String allName) throws Exception {
      DepartmentInfo am = this.departmentInfoService.findById(deptId);
      int dept_parent_id = am.getParent_id().intValue();
      if(dept_parent_id == 0) {
         return allName;
      } else {
         EmployeeInfo ei = new EmployeeInfo();
         ei.setState(Integer.valueOf(1));
         ei.setDept_id(Integer.valueOf(dept_parent_id));
         List eiList = this.findByCondition(ei, (Page)null);
         EmployeeInfo tmpEi = eiList != null && eiList.size() > 0?(EmployeeInfo)eiList.get(0):null;
         if(tmpEi != null) {
            allName = tmpEi.getZh_name() + " >> " + allName;
         }

         return this.getLeaderAllNameByDeptId(Integer.valueOf(dept_parent_id), allName);
      }
   }

   public String getLeaderAllIDByDeptId(Integer deptId, String allID) throws Exception {
      DepartmentInfo am = this.departmentInfoService.findById(deptId);
      int dept_parent_id = am.getParent_id().intValue();
      if(dept_parent_id == 0) {
         return allID;
      } else {
         EmployeeInfo ei = new EmployeeInfo();
         ei.setState(Integer.valueOf(1));
         ei.setDept_id(Integer.valueOf(dept_parent_id));
         List eiList = this.findByCondition(ei, (Page)null);
         if(eiList != null && eiList.size() > 0) {
            String leaderIds = "";

            EmployeeInfo tmpEi;
            for(Iterator var9 = eiList.iterator(); var9.hasNext(); leaderIds = leaderIds + tmpEi.getId() + ",") {
               tmpEi = (EmployeeInfo)var9.next();
            }

            if(leaderIds.endsWith(",")) {
               leaderIds = leaderIds.substring(0, leaderIds.length() - 1);
            }

            allID = leaderIds + " >> " + allID;
         }

         return this.getLeaderAllIDByDeptId(Integer.valueOf(dept_parent_id), allID);
      }
   }

   public String getLeaderNameByDeptId(Integer deptId) throws Exception {
      String allName = this.getLeaderAllNameByDeptId(deptId, "");
      if(!StringUtils.isEmpty(allName)) {
         allName = allName.replace(" ", "");
         if(allName.lastIndexOf(">>") > -1) {
            allName = allName.substring(0, allName.lastIndexOf(">>"));
         }

         String[] names = allName.split(">>");
         return names[names.length - 1];
      } else {
         return "";
      }
   }

   public String getLeaderIdByDeptId(Integer deptId) throws Exception {
      String allId = this.getLeaderAllIDByDeptId(deptId, "");
      if(!StringUtils.isEmpty(allId)) {
         allId = allId.replace(" ", "");
         if(allId.lastIndexOf(">>") > -1) {
            allId = allId.substring(0, allId.lastIndexOf(">>"));
         }

         String[] ids = allId.split(">>");
         return ids[ids.length - 1];
      } else {
         return "0";
      }
   }

   public List findByDeptId(String deptIds) throws Exception {
      if(StringUtils.isEmpty(deptIds)) {
         return null;
      } else {
         StringBuffer sql = new StringBuffer();
         sql.append(" select " + this.columns + " from " + this.defaultTable + " t   ");
         sql.append(" where t.state = 1 and t.dept_id in(" + deptIds + ")");
         return this.employeeInfoDao.findBySql(sql.toString());
      }
   }

   public List findHistoryByEmpId(int empId, String history_type) throws Exception {
      String sql = " select " + this.columns_history + " from " + this.historyTable + " t " + " where emp_id = " + empId + " and history_type=\'" + history_type + "\' order by t.create_date desc ";
      return this.employeeInfoDao.findHistoryBySql(sql);
   }

   public List findHistoryChangeByEmpId(int empId, String history_type) throws Exception {
      String sql = " select " + this.columns_history_change + " from " + this.historyChangeTable + " t " + " where 1=1 " + (empId == 0?"":" and emp_id = " + empId + " ") + " and history_type=\'" + history_type + "\' order by t.emp_id asc ,t.create_date desc ";
      return this.employeeInfoDao.findHistoryBySql(sql);
   }
}
