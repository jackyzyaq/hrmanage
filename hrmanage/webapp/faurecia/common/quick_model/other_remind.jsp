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
	List<EmployeeInfo> htList = employeeInfoService.findHTRemid(first,last);
	List<EmployeeInfo> birthdayList = employeeInfoService.findBirthDayRemid(first,last);
	List<EmployeeInfo> tryoutList = employeeInfoService.findTryoutDayRemid(first,last);
	
%>
<script type="text/javascript">
$(function(){
	$("#ht_remind").click(function(){
		showHtml(ctx+"/faurecia/common/quick_model/other_ht_remind.jsp?menu_id=<%=menu_id%>","合同提醒(近一个月)",500);
	});
	$("#try_remind").click(function(){
		showHtml(ctx+"/faurecia/common/quick_model/other_tryday_remind.jsp?menu_id=<%=menu_id%>","试用期提醒(近一个月)",500);
	});
	$("#birthday_remind").click(function(){
		showHtml(ctx+"/faurecia/common/quick_model/other_birthday_remind.jsp?menu_id=<%=menu_id%>","生日提醒(近一个月)",500);
	});
});
</script>
<div class="one_half">
	<div class="widgetbox">
		<div class="title">
			<h3>合同提醒(近一个月)  &nbsp;&nbsp;&nbsp; <a id="ht_remind" title="更多" style="cursor:pointer;">>></a></h3>
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
						<th class="head0">合同开始日期</th>
						<th class="head0">合同结束日期</th>
					</tr>
				</thead>
				<tbody>
					<%
					if(htList!=null&&htList.size()>0){
						int count = 0;
						for(EmployeeInfo ei:htList){
							if(count>=5)continue;
					%>
					<tr>
						<td><%=ei.getEmp_code() %></td>
						<td><%=ei.getZh_name() %></td>
						<td><%=sdf.format(ei.getBegin_date()) %></td>
						<td><%=sdf.format(ei.getEnd_date()) %></td>
					</tr>
					<%count++;}} else {%>
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
	<div class="widgetbox">
		<div class="title">
			<h3>试用期提醒(近一个月)&nbsp;&nbsp;&nbsp; <a id="try_remind" title="更多" style="cursor:pointer;">>></a></h3>
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
						int count=0;
						for(EmployeeInfo ei:tryoutList){
						if(count>=5)continue;
					%>
					<tr>
						<td><%=ei.getEmp_code() %></td>
						<td><%=ei.getZh_name() %></td>
						<td><%=sdf.format(ei.getEmp08()) %></td>
						<td><%=ei.getTry_month() %>个月</td>
					</tr>
					<%count++;}} else {%>
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
                    
<div class="one_half last">
	<div class="widgetbox">
		<div class="title">
			<h3>生日提醒(近一个月)&nbsp;&nbsp;&nbsp; <a id="birthday_remind" title="更多" style="cursor:pointer;">>></a></h3>
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
						<th class="head0">出生年月</th>
					</tr>
				</thead>
				<tbody>
					<%
					if(birthdayList!=null&&birthdayList.size()>0){
						int count = 0;
						for(EmployeeInfo ei:birthdayList){
							if(count>=5)continue;
					%>
					<tr>
						<td><%=ei.getEmp_code() %></td>
						<td><%=ei.getZh_name() %></td>
						<td><%=sdf.format(ei.getBirthday()) %></td>
					</tr>
					<%count++;}} else {%>
							<tr>
								<td colspan="3">无数据</td>
							</tr>
							<%} %>
				</tbody>
			</table>
		</div>
		<!--widgetcontent-->
	</div>
	<!--widgetbox-->
</div><!--one_half last-->