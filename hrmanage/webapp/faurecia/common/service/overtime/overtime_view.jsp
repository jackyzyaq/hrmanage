<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.authority.pojo.UserInfo" %>
<%
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	int id = Integer.parseInt(StringUtils.defaultIfEmpty(request.getParameter("id"), "0"));
	UserInfo user = (UserInfo)session.getAttribute("user");
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	OverTimeInfoService overTimeInfoService = (OverTimeInfoService) ctx.getBean("overTimeInfoService");
	EmployeeInfoService employeeInfoService = (EmployeeInfoService) ctx.getBean("employeeInfoService");
	OverTimeInfo oti = overTimeInfoService.queryById(id, null);
	EmployeeInfo employeeInfo = employeeInfoService.queryById(oti.getEmp_id(), null);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript">
$(function(){
	var param = {};
	param['root_div_id'] = 'contentwrapper';
	param['id'] = '<%=oti.getId()%>';
	param['pojo_object'] = '<%=oti.getClass().getName()%>';
	createRigthMenu(param);
});
</script>
<script type="text/javascript" src="${ctx }/faurecia/common/service/overtime/js/overtime.js"></script>
<script type="text/javascript" src="${ctx }/faurecia/common/service/overtime/js/overtime_common.js"></script>
</head>
<body>
	<div id="contentwrapper" class="contentwrapper" style="width:90%;">
		<form class="stdform stdform2" onSubmit="return false;">
			<div>
				<div class="widgetbox">
					<div class="widgetcontent padding0 statement">
				   		<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
					        <thead>
					            <tr>
					                <th class="head1" style="width:15%"></th>
					                <th class="head1" style="width:20%"></th>
					                <th class="head1" style="width:15%"></th>
					                <th class="head1" style="width:20%"></th>
					                <th class="head1" style="width:10%"></th>
					                <th class="head1" style="width:20%"></th>
					            </tr>
					        </thead>
					        <tbody>
					        <tr>
					        	<td style="font-weight:bold;" align="center">部门</td>
					        	<td>
					        		<%=Global.departmentInfoMap.get(oti.getDept_id()).getDept_name().toString() %>
					        	</td>
					        	<td style="font-weight:bold" align="center">员工</td>
					        	<td>
					        		<%=employeeInfo.getZh_name() %>
					        	</td>
					        	<td style="font-weight:bold" align="center">类型</td>
					        	<td>
					        		<select id="type" name="type">
					        			<option value="<%=Global.overtime_type[0]%>" <%=Global.overtime_type[0].equals(oti.getType())?"selected":"" %>><%=Global.overtime_type[0]%></option>
					        			<option value="<%=Global.overtime_type[1]%>" <%=Global.overtime_type[1].equals(oti.getType())?"selected":"" %>><%=Global.overtime_type[1]%></option>
					        		</select>
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold" align="center">
					        		<select name="day_or_hour" id="day_or_hour">
					        			<option value="hour" <%=StringUtils.defaultIfEmpty(oti.getDay_or_hour(),"").trim().equals("hour")?"selected":"" %>>小时</option>
					        			<option value="day" <%=StringUtils.defaultIfEmpty(oti.getDay_or_hour(),"").trim().equals("day")?"selected":"" %>>天</option>
					        		</select>
					        	</td>
					        	<td colspan="5">
					        		选择小时，自然日内任何时间，除正常上班时间外；
					        		<br />
					        		选择天，以天为单位，固定从上班时间到下班时间；
					        	</td>
					        </tr>					        
					        <tr>
					        	<td style="font-weight:bold;" align="center">开始时间</td>
					        	<td>
					        		<input class="Wdate" type="text" title="开始时间" readonly="readonly" id="begin_date" name="begin_date" value="<%=sdf.format(oti.getBegin_date()) %>"  onblur="checkTime();"/>
					        	</td>
					        	<td style="font-weight:bold" align="center">休假时数</td>
					        	<td>
					        		<input type="text" title="休假时数" name="over_hour" id="over_hour" class="smallinput" value="<%=oti.getOver_hour() %>" onblur="replaceForHalf(this);checkTime();"  onafterpaste="replaceForHalf(this);"/>&nbsp; 小时
					        	</td>
					        	<td style="font-weight:bold" align="center">结束时间</td>
					        	<td>
					        		<input class="Wdate" type="text" title="结束时间" readonly="readonly" id="end_date" name="end_date" value="<%=sdf.format(oti.getEnd_date()) %>"/>
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold" align="center">工作流</td>
					        	<td>
					        		<%=Global.flow_check_status_name[oti.getStatus()] %>
					        	</td>
					        	<td colspan="4"></td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold;" align="center">加班事由</td>
					        	<td colspan="5">
					        		<textarea rows="4" class="longinput" name="remark" id="remark" ><%=StringUtils.defaultIfEmpty(oti.getRemark(), "") %></textarea>
					        	</td>
					        </tr>
			         		</tbody>
			       		</table>
			     	</div>
			   </div>				
			</div>
			<div>
            <input type="hidden" id="id" name="id" value="<%=oti.getId()%>"/>
            <input type="hidden" id="user_id" name="user_id" value="<%=user.getId()%>"/>
            <input type="hidden" id="user_name" name="user_name" value="<%=user.getZh_name()%>"/>
            <input type="hidden" id="emp_id" name="emp_id" value="<%=employeeInfo.getId()%>"/>
			</div>
			<jsp:include page="/share/jsp/flow_step.jsp">
				<jsp:param value="<%=oti.getId() %>" name="handle_id"/>
				<jsp:param value="<%=oti.getStatus() %>" name="status"/>
				<jsp:param value="<%=oti.getNext_check_emp_id() %>" name="next_check_emp_id"/>
				<jsp:param value="<%=oti.getFlow_id() %>" name="flow_id"/>
			</jsp:include>
		</form>
	</div>
</body>
</html>