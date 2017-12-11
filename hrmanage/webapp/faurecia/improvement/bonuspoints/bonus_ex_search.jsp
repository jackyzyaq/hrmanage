<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.authority.pojo.UserInfo" %>
<%@ include file="/faurecia/improvement/connector.jsp"%>
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
%><script type="text/javascript">
<!--

//-->
function wdateInstanceforImp(){
	WdatePicker({dateFmt:'yyyy-MM',alwaysUseStartDate:false});
}
</script>
<div id="search" class="overviewhead">
	礼品名：&nbsp;<input id="proname" name="proname" value=""/>&nbsp;
	积分（小于）：&nbsp;<input id="BPValues" name="BPValues" value=""/>&nbsp;
	库存（大于）：&nbsp;<input id="prostock" name="prostock" value=""/>&nbsp;
	<!-- 申请人：&nbsp;<input type="text" id="EMName" name="EMName" value=""/>&nbsp; -->
	<%-- 类型：&nbsp;<select id="type" name="type" style="height: 30px">
					<option value="" selected>---请选择---</option>
					<%for(int i=0;i<Global.breaktime_type.length;i++){ 
					String type = Global.breaktime_type[i].split("\\|")[0];
					String hour = Global.breaktime_type[i].split("\\|")[1];
					%>
					<option value="<%=type%>"><%=type%></option>
					<%} %>
				</select> --%>
	<br/>
	<%-- <%if(isSH){ %>
	<input type="hidden" id="next_check_emp_id" name="next_check_emp_id" value="<%=emp_id%>"/>
	<input type="hidden" id="check_states" name="check_states" value="<%=Global.flow_check_state[0]+","+Global.flow_check_state[1]%>"/>
	<%} else{ %>
		工作流：&nbsp;
		<select id="overviewselect" name="status">
			<option value="" selected>---请选择---</option>
			<%for(Integer status:Global.flow_check_status){ %>
			<option value="<%=status%>"><%=Global.flow_check_status_name[status] %></option>
			<%} %>
		</select>&nbsp;		
		<%if(isAllEmp){ %>
		<%}else{ %>
			<input type="hidden" id="emp_id" name="emp_id" value="<%=emp_id%>"/>
		<%} %>
	<%} %> --%>
	<input type="hidden" id="available" name="available" value="1"/>
	
	<!-- <input type="radio" id="search_type1" name="search_type" value="1" checked/>&nbsp;明细&nbsp;
	<input type="radio" id="search_type2" name="search_type" value="2"/>&nbsp;汇总&nbsp; -->
	<a id="searchBtn" style="cursor:pointer;" class="btn btn_search radius50"><span>搜索</span></a>
	<!-- <a id="searchExportBtn" style="cursor:pointer;" class="btn btn_search radius50"><span>导出</span></a> -->
</div>