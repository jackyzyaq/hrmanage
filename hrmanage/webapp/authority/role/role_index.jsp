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
var role_columns = [[
			 					{field:'id',hidden:true},
			 					{field:'role_code',title:'角色代码',width:100,sortable:true,align:'center'},
			 					{field:'role_name',title:'角色名称',width:100,sortable:true,align:'center',hidden:false},
			 					{field:'parent_code',title:'父角色代码',width:100,sortable:false,align:'center',hidden:false},
			 					{field:'parent_name',title:'父角色名称',width:100,sortable:false,align:'center',hidden:false},
			 					{field:'description',title:'描述',width:300,sortable:false,align:'center'},
			 					{field:'state',title:'是否有效',width:'80',align:'center',sortable:false,hidden:false,
									formatter:function(value, rowData, rowIndex){
										if(value=='1'){
											return '有效';
										}else if(value=='0'){
											return '无效';
										}else{
											return '';
										}
						   			}
								},
			 					{field:'update_date',title:'更新时间',width:140,sortable:true,align:'center'},
								{field:'operation',title:'操作',width:250,sortable:false,align:'center',
			 						formatter:function(value, rowData, rowIndex){
			 							var str = '';
			 								<%
											for(Integer key:menuInfoMap.keySet()){ 
											    MenuInfo mi = menuInfoMap.get(key);
											    if(mi.getParent_id().intValue()!=Integer.parseInt(menu_id))continue;
											    if(mi.getMenu_code().indexOf("_role_info_authorization_")>-1){
											%>
			 								str+= '<a style="cursor:pointer;" onclick="parent.showHtml(\''+ctx+'<%=mi.getUrl()%>?menu_id=<%=mi.getId()%>&role_id='+rowData.id+'&role_name='+encodeURIComponent(rowData.role_name)+'\',\'<%=mi.getMenu_name()%>\');"><%=mi.getMenu_name()%></a>&nbsp;&nbsp;';
			 							 	<%
											}}
											%>
			 							return str;
			 						},
			 						styler:function(value,row,index){
			 							var color = "";//"background-color:#ffee00;color:red;";
			 							return color;
			 						}
			 					}
			 				]];
			var role_toolbar = [			
				<%
				for(Integer key:menuInfoMap.keySet()){ 
				    MenuInfo mi = menuInfoMap.get(key);
				    if(mi.getParent_id().intValue()!=Integer.parseInt(menu_id))continue;
				    if(mi.getMenu_code().indexOf("_add_")>-1||mi.getMenu_code().indexOf("_edit_")>-1||mi.getMenu_code().indexOf("_view_")>-1){
				%>
				{
				text:'<%=mi.getMenu_name()%>',
					iconCls:'<%=StringUtils.defaultIfEmpty(mi.getUrl_param(),"")%>',
					remoteSort:false,
					handler:function(){
						<%if(mi.getMenu_code().indexOf("_add_")>-1){%>
								parent.showHtml(ctx+"<%=mi.getUrl()%>?menu_id=<%=mi.getId()%>","添加<%=mi.getMenu_name()%>");
						<%}else if(mi.getMenu_code().indexOf("_edit_")>-1){%>
							var rows = _dataGrid.datagrid("getSelections");	//获取你选择的所有行
							if(rows.length!=1){
								parent.showInfo('请选择一项进行操作！');
								return false;
							}
							parent.showHtml(ctx+"<%=mi.getUrl()%>?menu_id=<%=mi.getId()%>"+"&role_id="+rows[0].id,"编辑<%=mi.getMenu_name()%>");
						<%}else if(mi.getMenu_code().indexOf("_view_")>-1){%>
							var rows = _dataGrid.datagrid("getSelections");	//获取你选择的所有行
							if(rows.length!=1){
								parent.showInfo('请选择一项进行操作！');
								return false;
							}
							parent.showHtml(ctx+"<%=mi.getUrl()%>?menu_id=<%=mi.getId()%>"+"&role_id="+rows[0].id,"查看<%=mi.getMenu_name()%>");
						<%}%>
					}
				},'-',
				<%
				}}
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
<script type="text/javascript" src="${ctx }/authority/role/js/role.js"></script>
</head>
<body>
	<jsp:include page="/share/jsp/menuAll.jsp" />
    <br />
	<jsp:include page="/authority/role/role_search.jsp" />
	<br />    
	<div id="role_datagrid"></div>
</body>
</html>  
