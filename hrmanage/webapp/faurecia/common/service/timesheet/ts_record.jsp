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
var ts_columns = [[
								{field:'id',hidden:true},
			 					{field:'emp_name',title:'中文姓名',width:100,sortable:true,align:'center',hidden:false},
			 					{field:'emp_id',title:'ID',width:100,sortable:true,align:'center',hidden:false},
			 					{field:'card',title:'CARD',width:100,sortable:true,align:'center',hidden:false},
			 					{field:'dept_name',title:'部门',width:200,sortable:true,align:'center',hidden:false},
			 					{field:'type',title:'类型',width:100,sortable:true,align:'center',hidden:false},
			 					{field:'operater',title:'操作者',width:200,sortable:true,align:'center',hidden:false},
			 					{field:'source',title:'来源',width:100,sortable:true,align:'center',hidden:false},
			 					{field:'inner_date',title:'打卡时间',width:140,sortable:true,align:'center'}
			 				]];
			var ts_toolbar = [
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
						<%if(mi.getMenu_code().indexOf("_add_")>-1){%>
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
						<%} else if(mi.getMenu_code().indexOf("_del_")>-1){%>
							<%if(employeeInfo==null){ %>
								parent.showInfo("用户与员工没有关联，请联系HR！");
							<%}else{%>
								var rows = _dataGrid.datagrid("getSelections");	//获取你选择的所有行
								if(rows.length==0){
									parent.showInfo('请选择一项进行操作！');
									return false;
								}
								var ids = '';
								for(var i=0;i<rows.length;i++){
									ids +=rows[i].id+',';
								}
								delTS(ids.substr(0,ids.length-1));								
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
<script type="text/javascript" src="${ctx }/faurecia/common/service/timesheet/js/ts.js"></script>
</head>
<body>
	<jsp:include page="/share/jsp/menuAll.jsp" />
    <br />
	<jsp:include page="/faurecia/common/service/timesheet/ts_search.jsp" />
	<br />    
	<div id="ts_datagrid"></div>
</body>
</html>