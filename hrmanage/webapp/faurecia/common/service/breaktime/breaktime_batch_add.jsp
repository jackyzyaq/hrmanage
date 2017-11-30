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
	String flow_type = Global.flow_type[1];
	Calendar c = Calendar.getInstance();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/faurecia/common/service/breaktime/js/breaktime.js"></script>
<script type="text/javascript" src="${ctx }/faurecia/common/service/breaktime/js/breaktime_common.js"></script>
<script type="text/javascript">
$(function(){
	$("#file").attr("accept","<%=Global.UPLOAD_ACCEPT_2%>");
	$("#day_or_hour").trigger("change");
});
</script>
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
					        	<td style="font-weight:bold;" align="center">申请人</td>
					        	<td>
					        		<%=StringUtils.defaultIfEmpty(employeeInfo.getZh_name(), "") %>
					        	</td>
					        	<td style="font-weight:bold" align="center">员工</td>
					        	<td>
					        		<jsp:include page="/share/jsp/employee_ztree_checkbod.jsp" />
					        	</td>
					        	<td style="font-weight:bold" align="center">类型</td>
					        	<td>
					        		<select id="type" name="type">
					        			<%for(int i=0;i<Global.breaktime_type.length;i++){ 
					        			String type = Global.breaktime_type[i].split("\\|")[0];
					        			String hour = Global.breaktime_type[i].split("\\|")[1];
					        			%>
					        			<option value="<%=type%>" lowest_hour="<%=hour %>" <%=i==0?"selected":"" %>><%=type%></option>
					        			<%} %>
					        		</select>
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold;" align="center">休假类型</td>
					        	<td>
					        		<select name="day_or_hour" id="day_or_hour">
					        			<%for(int i=0;i<Global.day_or_hour.length;i++){ 
					        				String day_or_hour = Global.day_or_hour[i];
					        			%>
					        			<option value="<%=day_or_hour.split("\\|")[0] %>" <%=i==0?"selected":"" %>><%=day_or_hour.split("\\|")[1] %></option>
					        			<%} %>
					        		</select>
					        	</td>
					        	<td style="font-weight:bold;" align="center">开始时间</td>
					        	<td>
					        		<input class="Wdate" type="text" title="开始时间" readonly="readonly" id="start_date" name="start_date" value=""/>
					        	</td>
					        	<td style="font-weight:bold" align="center">时长</td>
					        	<td>
					        		<input type="text" title="时长" name="break_hour" id="break_hour" class="smallinput" value="" onblur="replaceForHalf(this);"  onafterpaste="replaceForHalf(this);"/>&nbsp;<span id="day_hour_span_id">小时</span>
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold;" align="center">休假事由</td>
					        	<td colspan="5">
					        		<textarea rows="4" class="longinput" name="remark" id="remark" title="休假事由"></textarea>
					        	</td>
					        </tr>
					        <tr>
								<td style="font-weight:bold" colspan="6">
									<div>
							        	<jsp:include page="/share/jsp/upload_file.jsp"></jsp:include>
							    	</div>
							    	<div>
						       			仅支持<%=Global.UPLOAD_ACCEPT_2 %>图片文件，且文件小于<%=Global.UPLOAD_SIZE_2/1024 %>KB
						    		</div>
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
            <input type="hidden" id="dept_id" name="dept_id" value="0"/>
            <input type="hidden" id="flow_id" name="flow_id" value="0"/>
            <input type="hidden" id="class_id" name="class_id" value="0"/>
			<button id="ok" class="submit radius2">确认</button>
			</div>
		</form>
	</div>
</body>
</html>