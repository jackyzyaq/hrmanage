<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.authority.pojo.UserInfo" %>
<%
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	SimpleDateFormat sdf1 = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	UserInfo user = (UserInfo)session.getAttribute("user");
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	ScheduleInfoService scheduleInfoService = (ScheduleInfoService) ctx.getBean("scheduleInfoService");
	
	String wo_number = StringUtils.defaultIfEmpty(request.getParameter("wo_number"),"0");
	ScheduleInfo si = new ScheduleInfo();
	si.setWo_number(wo_number);
	si.setAvailable(1);
	List<ScheduleInfo> list = scheduleInfoService.findByCondition(si, null);
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<jsp:include page="/common/shareJsp/cartZTreeHead.jsp" />

<script type="text/javascript">

</script>

</head>
<body>
	<div id="contentwrapper" class="contentwrapper" style="width:90%;">
		<form class="stdform stdform2" onSubmit="return false;">
			<div class="widgetbox">
			    <div class="title"><h3>排班列表</h3></div>
			    <div class="widgetcontent padding0 statement">
			       <table cellpadding="0" cellspacing="0" border="0" class="stdtable">
			            <colgroup>
			                <col class="con0" />
			                <col class="con1" />
			                <col class="con0" />
			            </colgroup>
			            <thead>
			                <tr>
			                    <th class="head0">序号</th>
			                    <th class="head0">员工</th>
			                    <th class="head0">部门</th>
			                    <th class="head1">开始时间</th>
			                    <th class="head0">结束时间</th>
			                    <th class="head1">时长</th>
			                    <th class="head1">加班</th>
			                    <th class="head0">用餐</th>
			                </tr>
			            </thead>
			            <tbody>
			            	<%
			            	if(list!=null&&list.size()>0){ 
			            		for(int i=0;i<list.size();i++){
			            			ScheduleInfo bti = list.get(i);
			            	%>
			            	<tr>
			                    <td><%=(i+1) %></td>
			                    <td><%=bti.getEmp_name() %></td>
			                    <td><%=bti.getDept_name()%></td>
			                    <td><%=sdf.format(bti.getBegin_date())+" "+bti.getBegin_time() %></td>
			                    <td><%=sdf.format(bti.getEnd_date())+" "+bti.getEnd_time() %></td>
			                    <td><%=bti.getHours() %></td>
			                    <td><%=bti.getOver_hour() %></td>
			                    <td><%=StringUtils.defaultIfEmpty(bti.getMeals(),"") %></td>
			                </tr>
			            	<%} }%>
			            </tbody>
			        </table>
			    </div><!--widgetcontent-->
			</div>
		</form>
	</div>
</body>
</html>