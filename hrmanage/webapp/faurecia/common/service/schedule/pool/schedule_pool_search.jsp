<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.authority.pojo.UserInfo" %>
<%
	boolean isAllEmp = Boolean.parseBoolean(StringUtils.defaultIfEmpty(request.getParameter("isAllEmp"), "false"));

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
	Calendar c = Calendar.getInstance();
%>
<div id="search" class="overviewhead">
	<div>
		<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
			<thead>
				<tr>
					<th class="head1" style="width: 23%"></th>
				    <th class="head1" style="width: 23%"></th>
				    <th class="head1" style="width: 23%"></th>
				    <th class="head1" style="width: 21%"></th>
				    <th class="head1" style="width: 10%"></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td align="left">
						员工：&nbsp;<input type="text" id="emp_name" name="emp_name" value=""/>&nbsp;
					</td>
					<td align="left">
						单号：&nbsp;<input type="text" id="wo_number" name="wo_number" value=""/>&nbsp;
					</td>
					<td align="left">
						提交者：&nbsp;<input type="text" id="user_name" name="user_name" value="<%=user.getZh_name()%>"/>&nbsp;
					</td>
					<td align="left">
						<%if(isAllEmp){ %>
						<%}else{ %>
						<input type="hidden" id="emp_id" name="emp_id" value="<%=emp_id%>"/>
						<%} %>
						<input type="hidden" id="available" name="available" value="1"/>
					</td>
					<td align="left">
						<a id="searchBtn" style="cursor:pointer;" class="btn btn_search radius50"><span>搜索</span></a>
					</td>
				</tr>
				<tr>
					<td align="left" colspan="4">
						<jsp:include page="/share/jsp/dept_role_ztree_checkbox.jsp"></jsp:include>
					</td>
					<td align="left">
					</td>					
				</tr>
				<tr>
					<td align="left">
					排班日期：&nbsp;
					<input class="Wdate" type="text" title="排班日期" readonly="readonly" id="tmp_date" name="tmp_date" value=""  onclick="wdateInstance();"/>
					</td>
					<td align="left" colspan="4">
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>