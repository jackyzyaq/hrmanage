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
	String emp_id = StringUtils.defaultIfEmpty(request.getParameter("emp_id"), "0");
	String zh_name = StringUtils.defaultIfEmpty(request.getParameter("zh_name"), "0");
%>
<script type="text/javascript">
$(function(){
	var params = {};
	params['emp_name']='<%=zh_name %>';
	params['emp_id_str']='emp_id';
	params['searchBtn_str']='searchBtn';
	params['parent_div']='#other_leave_use #search';
	inner_html(ctx+'/share/jsp/auto_employee.jsp',params,'other_leave_use #auto_emp',null);
	$("#other_leave_use #searchBtn").click(function(){
		other_leave_use_inner();
	});
	other_leave_use_inner();
});
function other_leave_use_inner(){
	var params = {};
	params['emp_id']=$("#other_leave_use #search #emp_id").val();
	inner_html(ctx+'/faurecia/common/quick_model/other_leave_use_inner.jsp',params,'other_leave_use_inner',null);
}
</script>
<div class="widgetbox">
	<div class="title">
		<h3>病 假 及 事 假 使 用 情 况</h3>
	</div>
	<div class="widgetcontent padding0 statement">
		<div id="search" class="overviewhead" style="margin-bottom: 1px;">
			员工：&nbsp;
			<span id="auto_emp"></span>
			&nbsp;
			<input type="hidden" name="emp_id" id="emp_id" value="<%=emp_id%>"/>
			<a id="searchBtn"></a>
		</div>
		<div id="other_leave_use_inner"></div>
	</div>
</div>
<!--widgetbox-->