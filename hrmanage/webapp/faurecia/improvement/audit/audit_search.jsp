<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.authority.pojo.UserInfo" %>
<%
	boolean isSH = Boolean.parseBoolean(StringUtils.defaultIfEmpty(request.getParameter("isSH"), "false"));
	boolean isAllEmp = Boolean.parseBoolean(StringUtils.defaultIfEmpty(request.getParameter("isAllEmp"), "false"));
	boolean isCheck = Boolean.parseBoolean(StringUtils.defaultIfEmpty(request.getParameter("isCheck"), "false"));

	UserInfo user = (UserInfo)session.getAttribute("user");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	EmployeeInfoService employeeInfoService = (EmployeeInfoService) ctx.getBean("employeeInfoService");
	int emp_id=0;
	try{
		emp_id = Integer.parseInt(user.getName());
	}catch(Exception e){
	}
	
	String params = StringUtils.defaultIfEmpty(request.getParameter("params"),"");
	String check_state = (params.indexOf(":")==-1?"":params.split(":")[1]);
	
	EmployeeInfo employeeInfo = employeeInfoService.queryById(emp_id);
	DepartmentInfoService departmentInfoService = (DepartmentInfoService) ctx.getBean("departmentInfoService");
	String deptIds = departmentInfoService.getSubIdsById(employeeInfo.getDept_id(), null);
%>
<div id="search" class="overviewhead">
	<%if(!isCheck){%>
		<%-- <jsp:include page="/share/jsp/dept_role_ztree_checkbox.jsp"></jsp:include> --%>
		<input type="hidden" id="depts" name="depts" value="<%=deptIds%>"/>
		<input type="hidden" id="submitEMId" name="submitEMId" value="<%=emp_id%>"/>
		<input type="hidden" id="executorId" name="executorId" value="<%=emp_id%>"/>
		<input type="hidden" id="executorMgrId" name="executorMgrId" value="<%=emp_id%>"/>
	<% } %>
	
	单号：&nbsp;<input type="text" id="formCode" name="formCode" value=""/>&nbsp;
	申请人：&nbsp;<input type="text" id="EMName" name="EMName" value=""/>&nbsp;
	<a id="searchBtn" style="cursor:pointer;" class="btn btn_search radius50"><span>搜索</span></a>
</div>