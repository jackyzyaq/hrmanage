<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.authority.pojo.UserInfo"%>
<%
	Map<Integer, MenuInfo> menuInfoMap = (Map<Integer, MenuInfo>) session.getAttribute("menuRole");
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	int emp_id = Integer.parseInt(StringUtils.defaultIfEmpty(request.getParameter("emp_id"), "0"));
	
	EmployeeInfoService employeeInfoService = (EmployeeInfoService) ctx.getBean("employeeInfoService");
	EmployeeInfo employeeInfo = employeeInfoService.queryById(emp_id);
%>
		<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
			<colgroup>
				<col class="con0" />
				<col class="con1" />
				<col class="con0" />
			</colgroup>
			<thead>
				<tr>
					<th class="head0">年份</th>
					<th class="head1">类型</th>
					<th class="head0">应享有小时数(h)</th>
					<th class="head0">已休小时数(h)</th>
					<th class="head0">剩余小时数(h)</th>
				</tr>
			</thead>
			<tbody>
				<%
					//查询主数据的公司假和年假数
					Calendar c = Calendar.getInstance();
					int nowYear = c.get(Calendar.YEAR);
					c.add(Calendar.YEAR,-1);
					int priYear = c.get(Calendar.YEAR);
					String annual_leave = Global.breaktime_type[2].split("\\|")[0];
					String company_leave = Global.breaktime_type[3].split("\\|")[0];
					EmployeeLeaveService employeeLeaveService = (EmployeeLeaveService) ctx.getBean("employeeLeaveService");
					double totalNowAnnual = employeeLeaveService.findTotalAnnualDays(emp_id, nowYear)*8.0;
					double totalNowCompany = employeeLeaveService.findTotalCompanyDays(emp_id, nowYear)*8.0;
					double breakNowAnnual = employeeLeaveService.findBreakHours(emp_id, nowYear,annual_leave);
					double breakNowCompany = employeeLeaveService.findBreakHours(emp_id, nowYear,company_leave);
					
					
					double totalPriAnnual = employeeLeaveService.findTotalAnnualDays(emp_id, priYear)*8.0;
					double totalPriCompany = employeeLeaveService.findTotalCompanyDays(emp_id, priYear)*8.0;
					double breakPriAnnual = employeeLeaveService.findBreakHours(emp_id, priYear,annual_leave);
					double breakPriCompany = employeeLeaveService.findBreakHours(emp_id, priYear,company_leave);
					
				%>			
				<tr>
					<td><%=nowYear %></td>
					<td><%=annual_leave %></td>
					<td><%=totalNowAnnual %></td>
					<td><%=breakNowAnnual %></td>
					<td><%=totalNowAnnual-breakNowAnnual<0?0:totalNowAnnual-breakNowAnnual %></td>
				</tr>
				<tr>
					<td><%=nowYear %></td>
					<td><%=company_leave %></td>
					<td><%=totalNowCompany %></td>
					<td><%=breakNowCompany %></td>
					<td><%=totalNowCompany-breakNowCompany<0?0:totalNowCompany-breakNowCompany %></td>
				</tr>
				
				<tr>
					<td><%=priYear %></td>
					<td><%=annual_leave %></td>
					<td><%=totalPriAnnual %></td>
					<td><%=breakPriAnnual %></td>
					<td><%=totalPriAnnual-breakPriAnnual<0?0:totalPriAnnual-breakPriAnnual %></td>
				</tr>
				<tr>
					<td><%=priYear %></td>
					<td><%=company_leave %></td>
					<td><%=totalPriCompany %></td>
					<td><%=breakPriCompany %></td>
					<td><%=totalPriCompany-breakPriCompany<0?0:totalPriCompany-breakPriCompany %></td>
				</tr>				
			</tbody>
		</table>