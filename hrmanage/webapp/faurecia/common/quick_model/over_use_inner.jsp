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
					<th class="head0">总小时数(h)</th>
					<th class="head0">调休小时数(h)</th>
					<th class="head0">剩余小时数(h)</th>
				</tr>
			</thead>
			<tbody>
				<%
					//查询主数据的公司假和年假数
					OverTimeInfoService overTimeInfoService = (OverTimeInfoService) ctx.getBean("overTimeInfoService");
					Map<Integer,Map<String,Object>> elMap = overTimeInfoService.findStandardOverHour(emp_id);
					
					if(elMap!=null&&elMap.size()>0){
						for(Integer year:elMap.keySet()){
							Map<String,Object> el = elMap.get(year);
				%>
				<tr>
					<td><%=year %></td><td><%=el.get("overtime_type").toString() %></td><td><%=el.get("standard_over_hour").toString() %></td><td><%=el.get("over_hour").toString() %></td><td><%=el.get("surplus_over_hour").toString() %></td>
				</tr>
				<%} }else{%>
				<tr>
					<td colspan="5">无数据</td>
				</tr>
				<%} %>
			</tbody>
		</table>