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
	EmployeeInfo employeeInfo = employeeInfoService.queryById(emp_id);
	if(employeeInfo==null)
		return ;
	String flow_type = Global.flow_type[2];
	String employee_type = Global.employee_type[1];
	
	Calendar c = Calendar.getInstance();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript">
$(function(){
});
</script>
<script type="text/javascript" src="${ctx }/faurecia/common/service/overtime/js/overtime.js"></script>
<script type="text/javascript" src="${ctx }/faurecia/common/service/overtime/js/overtime_common.js"></script>
</head>
<body>
	<div id="contentwrapper" class="contentwrapper" style="width:90%;">
		<form class="stdform stdform2" onSubmit="return false;">
			<jsp:include page="/share/jsp/flow.jsp">
				<jsp:param value="<%=emp_id %>" name="emp_id"/>
				<jsp:param value="<%=flow_type %>" name="flow_type"/>
				<jsp:param value="<%=employee_type %>" name="employee_type"/>
			</jsp:include>
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
					        		<%=StringUtils.defaultIfEmpty(employeeInfo.getDept_name(), "") %>
					        	</td>
					        	<td style="font-weight:bold" align="center">员工</td>
					        	<td>
					        		<%=employeeInfo.getZh_name() %>
					        	</td>
					        	<td style="font-weight:bold" align="center">类型</td>
					        	<td>
					        		<select id="type" name="type">
					        			<option value="<%=Global.overtime_type[0]%>" selected="selected"><%=Global.overtime_type[0]%></option>
					        			<option value="<%=Global.overtime_type[1]%>"><%=Global.overtime_type[1]%></option>
					        		</select>
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold" align="center">
					        		<select name="day_or_hour" id="day_or_hour">
					        			<option value="hour" selected>小时</option>
					        			<option value="day">天</option>
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
					        		<input class="Wdate" type="text" title="开始时间" readonly="readonly" id="begin_date" name="begin_date" value="" onblur="checkTime();"/>
					        	</td>
					        	<td style="font-weight:bold" align="center">加班时数</td>
					        	<td>
					        		<input type="text" title="加班时数" name="over_hour" id="over_hour" class="smallinput" value="0" onblur="replaceForHalf(this);checkTime();"  onafterpaste="replaceForHalf(this);"/>&nbsp; 小时
					        	</td>
					        	<td style="font-weight:bold" align="center">结束时间</td>
					        	<td>
					        		<input class="Wdate" type="text" title="结束时间" readonly="readonly" id="end_date" name="end_date" value=""/>
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold;" align="center">加班事由</td>
					        	<td colspan="5">
					        		<textarea rows="4" class="longinput" name="remark" id="remark" title="加班事由"></textarea>
					        	</td>
					        </tr>					        
			         		</tbody>
			       		</table>
			     	</div>
			   </div>				
			</div>
            <div>
            <input type="hidden" id="user_id" name="user_id" value="<%=user.getId()%>"/>
            <input type="hidden" id="user_name" name="user_name" value="<%=user.getZh_name()%>"/>
            <input type="hidden" id="dept_id" name="dept_id" value="<%=employeeInfo.getDept_id()%>"/>
            <input type="hidden" id="emp_id" name="emp_id" value="<%=employeeInfo.getId()%>"/>
			<button id="submit" class="submit radius2">提交</button>
			</div>
		</form>
	</div>
</body>
</html>