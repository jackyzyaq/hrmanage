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
$(function(){
			var action_columns = [[ 
						        	{field:'id',title:'编号',width:'80',align:'center',sortable:true,hidden:true}, 
						        	{field:'action_code',title:'动作代码',width:'150',align:'center',sortable:true,hidden:false},
									{field:'action_name',title:'动作名称',width:'120',align:'center',sortable:true,hidden:false},
									{field:'action_menu_id',title:'菜单代码',width:'150',align:'center',sortable:false,hidden:true},
									{field:'action_menu_name',title:'菜单名称',width:'150',align:'center',sortable:false,hidden:false},
									{field:'viewmode',title:'是否可见',width:'100',align:'center',sortable:false,hidden:false,
										formatter:function(value, rowData, rowIndex){
											if(value=='1'){
												return '可见';
											}else if(value=='0'){
												return '不可见';
											}else{
												return '';
											}
							   			}
									},
									{field:'update_date',title:'更新时间',width:'135',align:'center',sortable:true,hidden:false}
						        ]];
			var action_toolbar = [			
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
								parent.showHtml(ctx+"<%=mi.getUrl()%>?menu_id=<%=mi.getId()%>","添加<%=mi.getMenu_name()%>");
						<%}else if(mi.getMenu_code().indexOf("_edit_")>-1){%>
							var rows = _dataGrid.datagrid("getSelections");	//获取你选择的所有行
							if(rows.length!=1){
								parent.showInfo('请选择一项进行操作！');
								return false;
							}
							parent.showHtml(ctx+"<%=mi.getUrl()%>?menu_id=<%=mi.getId()%>"+"&action_id="+rows[0].id,"编辑<%=mi.getMenu_name()%>");
						<%}else if(mi.getMenu_code().indexOf("_view_")>-1){%>
							var rows = _dataGrid.datagrid("getSelections");	//获取你选择的所有行
							if(rows.length!=1){
								parent.showInfo('请选择一项进行操作！');
								return false;
							}
							parent.showHtml(ctx+"<%=mi.getUrl()%>?menu_id=<%=mi.getId()%>"+"&action_id="+rows[0].id,"查看<%=mi.getMenu_name()%>");
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
			 	_dataGridFn("action_datagrid",ctx+'/authority/actionInfo/queryResult.do',action_columns,action_toolbar);
});
</script>
<script type="text/javascript" src="${ctx }/authority/action/js/action.js"></script>
</head>
<body>
	<jsp:include page="/share/jsp/menuAll.jsp" />
	<br />
	<div id="action_datagrid"></div>
</body>
</html>

        
