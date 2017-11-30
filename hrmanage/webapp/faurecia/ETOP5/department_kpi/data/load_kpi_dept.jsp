<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%@ page import="net.sf.json.JSONException"%>
<%@ page import="net.sf.json.JSONObject"%>
<%
	String ext_2 = StringUtils.defaultIfEmpty(request.getParameter("ext_2"), "");
	String ext_1 = StringUtils.defaultIfEmpty(request.getParameter("ext_1"), "");
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	DepartmentKPIService departmentKPIService = (DepartmentKPIService) ctx.getBean("departmentKPIService");
	StringBuffer sb = new StringBuffer("{'rows':[");
	List<DepartmentKPI> listType = departmentKPIService.queryKPIDeptByQCDPAndInOrOut(ext_2, ext_1);
	if(listType==null||listType.size()==0){
	}else{
		String v = "";
		for(DepartmentKPI pk:listType){
			sb.append("{'dept_name':'"+pk.getDept_name()+"'},");
		}
		if(listType.size()>0)sb.deleteCharAt(sb.length()-1);
	}
	sb.append("]}");
	out.print(JSONObject.fromObject(sb.toString()).toString());
%>