<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.authority.pojo.UserInfo" %>
<%
	UserInfo user = (UserInfo)session.getAttribute("user");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	EmployeeInfoService employeeInfoService = (EmployeeInfoService) ctx.getBean("employeeInfoService");
	int emp_id=0;
	try{
		emp_id = Integer.parseInt(user.getName());
	}catch(Exception e){
	}
	String params = StringUtils.defaultIfEmpty(request.getParameter("params"),"");
	String flow_type = (params.indexOf(":")==-1?Global.flow_type[0]:params.split(":")[1]);
	String check_url_ = "",check_column = "";
    Calendar c = Calendar.getInstance();
%>
<div id="search" class="overviewhead">
	<div>
		<jsp:include page="/share/jsp/dept_role_ztree_checkbox.jsp"></jsp:include>
		单号：&nbsp;<input type="text" id="wo_number" name="wo_number" value=""/>&nbsp;
		员工：&nbsp;<input type="text" id="emp_name" name="emp_name" value=""/>&nbsp;
		提交者：&nbsp;<input type="text" id="user_name" name="user_name" value=""/>&nbsp;
		<input type="hidden" id="next_check_emp_id" name="next_check_emp_id" value="<%=emp_id%>"/>
		<input type="hidden" id="check_states" name="check_states" value="<%=Global.flow_check_state[0]+","+Global.flow_check_state[1]%>"/>
	
		<input type="hidden" id="available" name="available" value="1"/>
		<a id="searchBtn" style="cursor:pointer;" class="btn btn_search radius50"><span>搜索</span></a>
	</div>
	<div style="margin-top: 5px;">
		类型：&nbsp;
			<%
			for(String type:Global.flow_type){
				if(type.equals(Global.flow_type[0])){
			    	check_url_ = "/common/scheduleInfo/queryWOResult.do?";
			    	check_column = "check_columns";
			    }else if(type.equals(Global.flow_type[1])){
			    	check_url_ = "/common/breakTimeInfo/queryResult.do?";
			    	check_column = "breaktime_columns";
			    }else if(type.equals(Global.flow_type[2])){
			    	check_url_ = "/common/overTimeInfo/queryResult.do?";
			    	check_column = "overtime_columns";
			    } 
			%>
			<input type="radio" id="flow_type" name="flow_type" flow_type_column="<%=check_column %>" flow_type_url="<%=check_url_ %>" value="<%=type%>" <%=flow_type.equals(type)?"checked":"" %>/>&nbsp;<%=type%>
			<%} %>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			起始日期：&nbsp;
			<input class="Wdate" type="text" title="起始日期" readonly="readonly" id="start_date" name="start_date" value=""  onclick="wdateBeginInstance('over_date');"/>&nbsp;
			~
			截止日期：&nbsp;
			<input class="Wdate" type="text" title="截止日期" readonly="readonly" id="over_date" name="over_date" value=""  onclick="wdateEndInstance('start_date');"/>&nbsp;
	</div>
</div>