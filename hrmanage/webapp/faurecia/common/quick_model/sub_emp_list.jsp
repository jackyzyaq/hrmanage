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
	params['parent_div']='#sub_emp_list #search';
	inner_html(ctx+'/share/jsp/auto_employee.jsp',params,'sub_emp_list #auto_emp',null);
	$("#sub_emp_list #searchBtn").click(function(){
		sub_emp_list_inner();
	});
	sub_emp_list_inner();
});
function sub_emp_list_inner(){
	var params = {};
	params['emp_id']=$("#sub_emp_list #search #emp_id").val();
	inner_html(ctx+'/faurecia/common/quick_model/sub_emp_list_inner.jsp',params,'sub_emp_list_inner',null);
}
</script>
<div class="widgetbox">
	<div class="title">
		<h3>员工信息</h3>
	</div>
	<div class="widgetcontent padding0 statement">
		<div id="search" class="overviewhead" style="margin-bottom: 1px;">
			员工：&nbsp;
			<span id="auto_emp"></span>
			&nbsp;
			<input type="hidden" name="emp_id" id="emp_id" value="<%=emp_id%>"/>
			<a id="searchBtn"></a>
		</div>
		<div id="sub_emp_list_inner"></div>
	</div>
</div>
<!--widgetbox-->