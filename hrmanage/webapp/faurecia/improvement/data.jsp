<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.authority.pojo.UserInfo"%>
<%@ page import="net.sf.json.JSONObject"%>
<%
    ServletContext st = request.getSession().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(st);
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A); 
	EmployeeInfoService employeeInfoService = (EmployeeInfoService) ctx.getBean("employeeInfoService");
	DepartmentInfoService departmentInfoService = (DepartmentInfoService) ctx.getBean("departmentInfoService");
	
	 Integer deptid = Integer.valueOf(StringUtils.defaultIfEmpty(request.getParameter("deptid"), "-1"));
	 Integer empid = Integer.valueOf(StringUtils.defaultIfEmpty(request.getParameter("empid"), "-1"));
	 EmployeeInfo eminfo = new EmployeeInfo();
	 DepartmentInfo dinfo = new DepartmentInfo();
	 JSONObject jsonObj = new JSONObject();
	 if(empid != -1){
		 eminfo = Global.employeeInfoMap.get(empid);
		 dinfo = Global.departmentInfoMap.get(eminfo.getDept_id());
	 }else if(deptid != -1) {
		 dinfo = Global.departmentInfoMap.get(deptid);
		 String leader = employeeInfoService.getLeaderIdByDeptId(dinfo.getId());
		 if(StringUtils.isNotEmpty(leader)){
			String ld[] = leader.split(",");
			if(leader.split(",").length > 0) {
				eminfo = employeeInfoService.queryById(Integer.parseInt(ld[0]));
			}
		}
	 } else {
		jsonObj.put("code", "F");
		jsonObj.put("msg", "S");
	 }
	 StringBuffer sb = new StringBuffer();
	 sb.append("{\"empinfo\":");
	 sb.append(JSONObject.fromObject(eminfo));
	 sb.append(",");
	 sb.append("\"deptinfo\":");
	 sb.append(JSONObject.fromObject(dinfo));
	 sb.append("}");
	 System.out.println(sb.toString());
	 out.print(sb.toString());
%>