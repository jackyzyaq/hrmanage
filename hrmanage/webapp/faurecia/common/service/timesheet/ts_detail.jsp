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
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<jsp:include page="/common/shareJsp/cartHeadEasyUI.jsp"/>
<script type="text/javascript">
var tsd_columns = [[
								{field:'id',hidden:true},
								{field:'emp_id',hidden:true},
			 					{field:'emp_name',title:'中文姓名',width:80,sortable:true,align:'center',hidden:false},
			 					{field:'dept_name',title:'部门',width:200,sortable:true,align:'center',hidden:false},
			 					{field:'class_date',title:'归属日期',width:120,sortable:true,align:'center',hidden:false,
			 						formatter:function(value, rowData, rowIndex){
										return value.replace(" 00:00:00","");
									}
			 					},
			 					{field:'class_name',title:'所属班次',width:100,sortable:true,align:'center',hidden:false},
			 					{field:'class_begin_date',title:'班次开始时间',width:160,sortable:true,align:'center',hidden:false},
			 					{field:'class_end_date',title:'班次结束时间',width:160,sortable:true,align:'center',hidden:false},
			 					{field:'ts_begin_date',title:'打卡开始时间',width:160,sortable:true,align:'center',hidden:false},
			 					{field:'ts_end_date',title:'打卡结束时间',width:160,sortable:true,align:'center',hidden:false},
			 					{field:'should_work_hours',title:'应出勤小时数',width:160,sortable:true,align:'center',hidden:false},
			 					{field:'arrive_work_hours',title:'实际出勤小时数',width:160,sortable:true,align:'center',hidden:false},
			 					{field:'absence_hours',title:'缺勤小时数',width:80,sortable:true,align:'center',hidden:false},
			 					{field:'ot1_hours',title:'OT1',width:60,sortable:true,align:'center',hidden:false},
			 					{field:'ot2_hours',title:'OT2',width:60,sortable:true,align:'center',hidden:false},
			 					{field:'ot3_hours',title:'OT3',width:60,sortable:true,align:'center',hidden:false},
			 					{field:'deficit_hours',title:'Deficit',width:60,sortable:true,align:'center',hidden:false},
			 					{field:'ts_number',title:'刷卡次数',width:60,sortable:true,align:'center',hidden:false},
			 					{field:'tb_01',title:'应就餐次数',width:60,sortable:true,align:'center',hidden:false},
			 					{field:'tb_02',title:'实就餐次数',width:60,sortable:true,align:'center',hidden:false},
			 					{field:'abnormal_cause',title:'异常',width:400,sortable:true,align:'center',hidden:false},
			 					{field:'class_date',title:'归属时间',width:140,sortable:true,align:'center'}
			 				]];
			var tsd_toolbar = [
				<%
				for(Integer key:menuInfoMap.keySet()){ 
				    MenuInfo mi = menuInfoMap.get(key);
				    if(mi.getParent_id().intValue()!=Integer.parseInt(menu_id))continue;
				%>
				{
				text:'<%=mi.getMenu_name()%>',
					iconCls:'<%=StringUtils.defaultIfEmpty(mi.getUrl_param(),"")%>',
					remoteSort:false,
					handler:function(){
						<%if(mi.getMenu_code().indexOf("_handle_")>-1){%>
							<%if(employeeInfo==null){ %>
								parent.showInfo("用户与员工没有关联，请联系HR！");
							<%}else{%>
								parent.showHtml(ctx+"<%=mi.getUrl()%>?menu_id=<%=mi.getId()%>","<%=mi.getMenu_name()%>");
							<%}%>
						<%} else if(mi.getMenu_code().indexOf("_sync_")>-1){%>
							<%if(employeeInfo==null){ %>
								parent.showInfo("用户与员工没有关联，请联系HR！");
							<%}else{%>
								parent.showHtml(ctx+"<%=mi.getUrl()%>?menu_id=<%=mi.getId()%>","<%=mi.getMenu_name()%>");
							<%}%>
						<%}%>
					}
				},'-',
				<%
				}
				%>			
				{
					text:'刷新',
					iconCls:'icon-reload',
					handler:function(){
						document.location.reload();
					}
				}];	
</script>
<script type="text/javascript" src="${ctx }/faurecia/common/service/timesheet/js/ts_detail.js"></script>
</head>
<body>
	<jsp:include page="/share/jsp/menuAll.jsp" />
    <br />
	<jsp:include page="/faurecia/common/service/timesheet/ts_search.jsp">
		<jsp:param value="detail" name="isShow"/>
	</jsp:include>
	<br />    
	<div id="tsd_datagrid"></div>
</body>
</html>