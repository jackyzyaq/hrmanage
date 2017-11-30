<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	String roleCodes = StringUtils.defaultIfEmpty((String)session.getAttribute("roleCodes"), "");
	int emp_id = StringUtils.isEmpty(request.getParameter("emp_id"))?-1:Integer.parseInt(request.getParameter("emp_id"));
	String history_type = StringUtils.isEmpty(request.getParameter("history_type"))?"":request.getParameter("history_type");
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	EmployeeInfoService employeeInfoService = (EmployeeInfoService) ctx.getBean("employeeInfoService");
	List<EmployeeInfoHistory> empHisotryList = employeeInfoService.findHistoryChangeByEmpId(emp_id,history_type);
%>
<div>
	<form id="tabs-7-form" class="stdform" onSubmit="return false;">
		<div class="widgetbox">
			<%if(Util.contains(roleCodes, Global.default_role[1],",")){ %>
			<button id="editSubmit" class="submit radius2" style="margin-bottom: 3px;" onclick="click_href('${ctx}/common/employeeInfo/exportHistoryChangeCsv.do?emp_id=<%=emp_id%>&history_type=<%=history_type%>');">导出</button>
			<%} %>
			<%if(Util.contains(roleCodes, Global.default_role[1],",")){ %>
			<button id="editSubmit" class="submit radius2" style="margin-bottom: 3px;" onclick="click_href('${ctx}/common/employeeInfo/exportHistoryChangeCsv.do?emp_id=0&history_type=<%=history_type%>');">导出全部人员</button>
			<%} %>
			<div class="widgetcontent padding0 statement">
		   		<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
			        <thead>
			            <tr>
			                <th class="head1" style="width:33%">变更前</th>
			                <th class="head1" style="width:33%">变更后</th>
			                <th class="head1" style="width:34%">生效时间</th>
			            </tr>
			        </thead>
			        <tbody>
			        <%if(empHisotryList!=null&&!empHisotryList.isEmpty()){ 
			        	int count = empHisotryList.size();
			        	for(int i=0;i<count;i++){
			        		EmployeeInfoHistory eih = empHisotryList.get(i);
			        %>
			        <tr>
			        	<td >
							<%=StringUtils.defaultIfEmpty(eih.getBefore_change(),"") %>
			        	</td>
			        	<td >
							<%=StringUtils.defaultIfEmpty(eih.getAfter_change(),"") %>
			        	</td>
			        	<td >
							<%=sdf.format(eih.getCreate_date()) %>
			        	</td>
			        </tr>
			        <%}}else{ %>
			        <tr><td colspan="3">暂无数据</td></tr>
			        <%} %>
	         		</tbody>
	       		</table>
	     	</div>
	   </div>				
	</form>
</div>