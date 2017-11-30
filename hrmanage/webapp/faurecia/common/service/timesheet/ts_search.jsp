<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%
	String isShow = StringUtils.defaultIfEmpty(request.getParameter("isShow"), "");
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	Calendar c = Calendar.getInstance();
%>
<script type="text/javascript">
$(function(){
	$("#dept_name").css("width","50%");

	var params = {};
	params['emp_id_str']='emp_id';
	params['parent_div']='#searchUser';
	inner_html(ctx+'/share/jsp/auto_employee.jsp',params,'searchUser #auto_emp',null);
});
</script>
<div id="searchUser" class="overviewhead">
	<div>
	<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
		<thead>
			<tr>
				<th class="head1" style="width: 50%"></th>
			    <th class="head1" style="width: 50%"></th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td align="left">
					<jsp:include page="/share/jsp/dept_role_ztree_checkbox.jsp"></jsp:include>
				</td>
				<td align="left">
					员工姓名： &nbsp;
					<span id="auto_emp"></span>
					<input type="hidden" value="0" id="emp_id" name="emp_id"/>
				</td>
			</tr>
			<tr>
				<td align="left">
					开始日期：&nbsp;
					<input style="width:50%" type="text" readonly="readonly" id="begin_date" name="begin_date" value="<%=sdf.format(c.getTime()) %>"  onfocus="wdateInstance();"/>
				</td>
				<td align="left">
					结束日期：&nbsp;
					<input style="width:50%" type="text" readonly="readonly" id="end_date" name="end_date" value="<%=sdf.format(c.getTime()) %>"  onfocus="wdateInstance();"/>
				</td>
			</tr>
		</tbody>
	</table>	
	</div>
	<div style="margin-top: 5px;">
		<a id="searchBtn" style="cursor:pointer;" class="btn btn_search radius50"><span>搜索</span></a>&nbsp;&nbsp;&nbsp;
		<%if(isShow.equals("detail")){ %>
			<a id="searchExportBtn" style="cursor:pointer;" class="btn btn_search radius50"><span>导出</span></a>&nbsp;&nbsp;&nbsp;
			<a id="searchSumExportBtn" style="cursor:pointer;" class="btn btn_search radius50"><span>导出汇总</span></a>&nbsp;&nbsp;&nbsp;
		<%}else{ %>
			<a id="searchExportBtn" style="cursor:pointer;" class="btn btn_search radius50"><span>导出</span></a>&nbsp;&nbsp;&nbsp;
		<%} %>
	</div>
</div>