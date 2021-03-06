<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.authority.pojo.UserInfo" %>
<%
	boolean isSH = Boolean.parseBoolean(StringUtils.defaultIfEmpty(request.getParameter("isSH"), "false"));
	boolean isAllEmp = Boolean.parseBoolean(StringUtils.defaultIfEmpty(request.getParameter("isAllEmp"), "false"));

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
%>
<div id="search" class="overviewhead">
	<jsp:include page="/share/jsp/dept_role_ztree_checkbox.jsp"></jsp:include>
	单号：&nbsp;<input type="text" id="wo_number" name="wo_number" value=""/>&nbsp;
	申请人：&nbsp;<input type="text" id="emp_name" name="emp_name" value=""/>&nbsp;
	类型：&nbsp;<select id="type" name="type" style="height: 30px">
					<option value="" selected>---请选择---</option>
					<%for(int i=0;i<Global.breaktime_type.length;i++){ 
					String type = Global.breaktime_type[i].split("\\|")[0];
					String hour = Global.breaktime_type[i].split("\\|")[1];
					%>
					<option value="<%=type%>"><%=type%></option>
					<%} %>
				</select>
	审核状态：&nbsp;<select id="check_state" name="check_state" style="height: 30px">
							<option value="" <%=StringUtils.isEmpty(check_state)?"selected":"" %>>---请选择---</option>
							<option value="<%=Global.flow_check_state[0]%>" <%=check_state.equals(Global.flow_check_state[0]+"")?"selected":"" %>>待审批</option>
							<option value="<%=Global.flow_check_state[1]%>" <%=check_state.equals(Global.flow_check_state[1]+"")?"selected":"" %>><%=Global.flow_check_state_name[1]%></option>
							<option value="<%=Global.flow_check_state[2]%>" <%=check_state.equals(Global.flow_check_state[2]+"")?"selected":"" %>><%=Global.flow_check_state_name[2]%></option>
						</select>				
	<br/>
	<%if(isSH){ %>
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
	<%} %>
	<input type="hidden" id="available" name="available" value="1"/>
	<input type="radio" id="search_type1" name="search_type" value="1" checked/>&nbsp;明细&nbsp;
	<input type="radio" id="search_type2" name="search_type" value="2"/>&nbsp;汇总&nbsp;
	<a id="searchBtn" style="cursor:pointer;" class="btn btn_search radius50"><span>搜索</span></a>
	<a id="searchExportBtn" style="cursor:pointer;" class="btn btn_search radius50"><span>导出</span></a>
</div>