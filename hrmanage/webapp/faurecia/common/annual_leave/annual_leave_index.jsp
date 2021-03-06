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
var leave_columns = [[
			 					{field:'id',hidden:true},
			 					{field:'hr_status_id',hidden:true},
			 					{field:'status_code',title:'编码',width:100,sortable:true,align:'center'},
			 					{field:'work_down',title:'社会工龄',width:100,sortable:true,align:'center',hidden:false,
			 						formatter:function(value, rowData, rowIndex){
										return '&gt;='+value;
						   			}
			 					},
			 					{field:'work_up',title:'社会工龄',width:100,sortable:true,align:'center',hidden:false,
			 						formatter:function(value, rowData, rowIndex){
										return '&lt;'+value;
						   			}
			 					},
			 					{field:'leave01',title:'法定年假',width:100,sortable:true,align:'center',hidden:false},
			 					{field:'leave02',title:'公司年假',width:100,sortable:true,align:'center',hidden:false},
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
			 					{field:'update_date',title:'更新时间',width:140,sortable:true,align:'center'}
			 				]];
			var leave_toolbar = [			
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
							parent.showHtml(ctx+"<%=mi.getUrl()%>?menu_id=<%=mi.getId()%>&annual_leave_id="+rows[0].id,"编辑<%=mi.getMenu_name()%>");
						<%}else if(mi.getMenu_code().indexOf("_view_")>-1){%>
							var rows = _dataGrid.datagrid("getSelections");	//获取你选择的所有行
							if(rows.length!=1){
								parent.showInfo('请选择一项进行操作！');
								return false;
							}
							parent.showHtml(ctx+"<%=mi.getUrl()%>?menu_id=<%=mi.getId()%>&annual_leave_id="+rows[0].id,"查看<%=mi.getMenu_name()%>");
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
<script type="text/javascript" src="${ctx }/faurecia/common/annual_leave/js/annual_leave.js"></script>
</head>
<body>
	<jsp:include page="/share/jsp/menuAll.jsp" />
    <br />
	<jsp:include page="/faurecia/common/annual_leave/annual_leave_search.jsp" />
	<br />    
	<div id="annual_leave_datagrid"></div>
</body>
</html>