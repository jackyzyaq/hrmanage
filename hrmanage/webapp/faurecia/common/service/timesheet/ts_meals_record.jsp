<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%
	EmployeeInfo employeeInfo = (EmployeeInfo)session.getAttribute("employeeInfo");
    Map<Integer,MenuInfo> menuInfoMap = (Map<Integer,MenuInfo>)session.getAttribute("menuRole");
    String roleCodes = (String)session.getAttribute("roleCodes");
    String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String isShow = StringUtils.defaultIfEmpty(request.getParameter("isShow"), "");
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	Calendar c = Calendar.getInstance();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<jsp:include page="/common/shareJsp/cartHeadEasyUI.jsp"/>
<script type="text/javascript">
var ts_meals_columns = [[
								{field:'id',hidden:true},
			 					{field:'source',title:'类型',width:100,sortable:false,align:'center',hidden:false},
			 					{field:'count',title:'数量',width:100,sortable:false,align:'center',hidden:false}
			 				]];
</script>
<script type="text/javascript" src="${ctx }/faurecia/common/service/timesheet/js/ts_meals.js"></script>
</head>
<body>
	<jsp:include page="/share/jsp/menuAll.jsp" />
    <br />
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
		</div>
	</div>
	<br />    
	<div id="ts_meals_datagrid"></div>
</body>
</html>