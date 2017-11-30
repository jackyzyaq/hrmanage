<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%
	Map<Integer, MenuInfo> menuInfoMap = (Map<Integer, MenuInfo>) session.getAttribute("menuRole");
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	Calendar cal = Calendar.getInstance();
	cal.set(Calendar.DAY_OF_MONTH, 1);
	Date first = cal.getTime();
	cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
	Date last = cal.getTime();
	EmployeeInfoService employeeInfoService = (EmployeeInfoService) ctx.getBean("employeeInfoService");
	List<EmployeeInfo> tryoutList = employeeInfoService.findTryoutDayRemid(first,last);
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
</head>
<body>
	<div id="contentwrapper" class="contentwrapper" style="width:90%;">
		<div>
			<div class="widgetbox">
				<div class="title">
					<h3>试用期提醒(近一个月)&nbsp;&nbsp;&nbsp; </h3>
				</div>
				<div class="widgetcontent padding0 statement">
					<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
						<colgroup>
							<col class="con0" />
							<col class="con1" />
							<col class="con0" />
						</colgroup>
						<thead>
							<tr>
								<th class="head0">GV Code</th>
								<th class="head1">姓名</th>
								<th class="head0">入职日期</th>
								<th class="head0">试用期</th>
							</tr>
						</thead>
						<tbody>
							<%
							if(tryoutList!=null&&tryoutList.size()>0){
								for(EmployeeInfo ei:tryoutList){
							%>
							<tr>
								<td><%=ei.getEmp_code() %></td>
								<td><%=ei.getZh_name() %></td>
								<td><%=sdf.format(ei.getEmp08()) %></td>
								<td><%=ei.getTry_month() %>个月</td>
							</tr>
							<%}} else {%>
							<tr>
								<td colspan="4">无数据</td>
							</tr>
							<%} %>
						</tbody>
					</table>
				</div>
				<!--widgetcontent-->
			</div>
			<!--widgetbox-->
		</div><!--one_half-->
	</div>
</body>
</html>