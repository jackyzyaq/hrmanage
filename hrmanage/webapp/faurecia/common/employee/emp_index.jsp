<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
    Map<Integer,MenuInfo> menuInfoMap = (Map<Integer,MenuInfo>)session.getAttribute("menuRole");
    String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<jsp:include page="/common/shareJsp/cartHeadEasyUI.jsp"/>
<script type="text/javascript">
var emp_columns = [[
								{field:'dept_id',hidden:true},
								{field:'project_id',hidden:true},
								{field:'position_id',hidden:true},
			 					{field:'id',title:'系统编号',width:60,sortable:true,align:'center'},
			 					{field:'emp_code',title:'GV code',width:100,sortable:true,align:'center'},
			 					{field:'zh_name',title:'中文姓名',width:100,sortable:true,align:'center',hidden:false},
			 					{field:'en_name',title:'英文姓名',width:100,sortable:true,align:'center',hidden:false},
			 					{field:'dept_name',title:'部门',width:100,sortable:true,align:'center',hidden:false},
			 					//{field:'leaderName',title:'直属主管',width:100,sortable:false,align:'center',hidden:false},
			 					{field:'project_name',title:'项目',width:180,sortable:true,align:'center',hidden:false},
			 					{field:'gap_name',title:'GAP',width:180,sortable:true,align:'center',hidden:false},
			 					{field:'position_name',title:'职位',width:200,sortable:true,align:'center',hidden:false},
			 					{field:'emp01',title:'合同归属',width:200,sortable:true,align:'center',hidden:false},
			 					{field:'state',title:'是否有效',width:'80',align:'center',sortable:false,hidden:false,
									formatter:function(value, rowData, rowIndex){
										if(value=='1'){
											return '在职';
										}else if(value=='2'){
											return '辞职';
										}else if(value=='3'){
											return '解雇';
										}else{
											return '';
										}
						   			}
								},
			 					{field:'update_date',title:'更新时间',width:140,sortable:true,align:'center'}
			 				]];
			var emp_toolbar = [			
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
						var width = 900;
    					var height = $(window).height()-100;
						<%if(mi.getMenu_code().indexOf("_add_")>-1){%>
								parent.showHtml(ctx+"<%=mi.getUrl()%>?menu_id=<%=mi.getId()%>","添加<%=mi.getMenu_name()%>",width,height);
						<%}else if(mi.getMenu_code().indexOf("_edit_")>-1){%>
							var rows = _dataGrid.datagrid("getSelections");	//获取你选择的所有行
							if(rows.length!=1){
								parent.showInfo('请选择一项进行操作！');
								return false;
							}
							parent.showHtml(ctx+"<%=mi.getUrl()%>?menu_id=<%=mi.getId()%>"+"&emp_id="+rows[0].id,"编辑<%=mi.getMenu_name()%>",width,height);
						<%}else if(mi.getMenu_code().indexOf("_view_")>-1){%>
							var rows = _dataGrid.datagrid("getSelections");	//获取你选择的所有行
							if(rows.length!=1){
								parent.showInfo('请选择一项进行操作！');
								return false;
							}
							parent.showHtml(ctx+"<%=mi.getUrl()%>?menu_id=<%=mi.getId()%>"+"&emp_id="+rows[0].id,"查看<%=mi.getMenu_name()%>",width,height);
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
$(function(){
	queryResult();
});
</script>
<script type="text/javascript" src="${ctx }/faurecia/common/employee/js/emp.js"></script>
</head>
<body>
	<jsp:include page="/share/jsp/menuAll.jsp" />
    <br />
	<jsp:include page="/faurecia/common/employee/emp_search.jsp" />
	<br />    
	<div id="emp_datagrid"></div>
</body>
</html>