<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.authority.pojo.UserInfo" %>
<%
	UserInfo user = (UserInfo)session.getAttribute("user");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	
	String wo_number = StringUtils.defaultIfEmpty(request.getParameter("wo_number"),"0");
	String flow_type = StringUtils.defaultIfEmpty(request.getParameter("flow_type"),"");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />

<script type="text/javascript">
$(function(){
	var params = {};
	params['wo_number']='<%=wo_number%>';
	<%
	if(flow_type.equals(Global.flow_type[0])){
	%>
	inner_html(ctx+'/faurecia/common/service/schedule/schedule_list_view.jsp',params,'schedule_id',null);
	<%	
	}else if(flow_type.equals(Global.flow_type[1])){
	%>
	inner_html(ctx+'/faurecia/common/service/breaktime/breaktime_list_view.jsp',params,'breaktime_id',null);
	<%	
	}else if(flow_type.equals(Global.flow_type[2])){
	%>
	inner_html(ctx+'/faurecia/common/service/overtime/overtime_list_view.jsp',params,'overtime_id',null);
	<%	
	} 	
	%>
});
</script>

</head>
<body>
	<div id="contentwrapper" class="contentwrapper" style="width:90%;">
		<form class="stdform stdform2" onSubmit="return false;">
			<div id="schedule_id"></div>
            <div id="breaktime_id"></div>
            <div id="overtime_id"></div>
		</form>
	</div>
</body>
</html>