<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%
	EmployeeInfo employeeInfo = (EmployeeInfo)session.getAttribute("employeeInfo");
    Map<Integer,MenuInfo> menuInfoMap = (Map<Integer,MenuInfo>)session.getAttribute("menuRole");
    
    String roleCodes = StringUtils.defaultIfEmpty((String)session.getAttribute("roleCodes"), "");
    String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
    Boolean isAllEmp = false;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<jsp:include page="/common/shareJsp/cartHeadEasyUI.jsp"/>
<script type="text/javascript">
var schedule_pool_columns = [[
			 					{field:'id',hidden:true},
			 					{field:'dept_id',hidden:true},
			 					{field:'emp_id',hidden:true},
			 					{field:'user_id',hidden:true},
			 					{field:'wo_number',title:'单号',width:'120',align:'center',sortable:true,hidden:false},
			 					{field:'operation',title:'操作',width:140,sortable:true,align:'center',
									formatter:function(value, rowData, rowIndex){
			 							var str = '';
			 							str+= '<a style="cursor:pointer;" onclick="innerFlow(\''+rowData.id+'\');">进入工作流</a>&nbsp;&nbsp;';
			 							return str;
			 						},
			 						styler:function(value,row,index){
			 							var color = "";//"background-color:#ffee00;color:red;";
			 							return color;
			 						}
								},
			 					{field:'dept_name',title:'部门',width:'180',align:'center',sortable:true,hidden:false},
								{field:'emp_name',title:'员工',width:'80',align:'center',sortable:true,hidden:false},
								{field:'type',title:'排班类型',width:'100',align:'center',sortable:true,hidden:false},
								{field:'class_name',title:'班次',width:'100',align:'center',sortable:true,hidden:false},
								{field:'begin_date',title:'排班开始时间',width:'160',align:'center',sortable:true,hidden:false,
									formatter:function(value, rowData, rowIndex){
										return value.replaceAll(' 00:00:00','')+' '+rowData.begin_time;
						   			}
								},
								{field:'end_date',title:'排班结束时间',width:'160',align:'center',sortable:true,hidden:false,
									formatter:function(value, rowData, rowIndex){
										return value.replaceAll(' 00:00:00','')+' '+rowData.end_time;
						   			}
								},
			 					{field:'meals',title:'工作餐',width:'100',align:'center',sortable:true,hidden:false},
								{field:'have_meals',title:'用餐时间',width:'80',align:'center',sortable:true,hidden:false},
								{field:'over_hour',title:'加班时数',width:'80',align:'center',sortable:true,hidden:false},
								{field:'remark',title:'备注',width:'240',align:'center',sortable:true,hidden:false},
								{field:'user_name',title:'提交者',width:140,sortable:true,align:'center'},
								{field:'update_date',title:'更新时间',width:140,sortable:true,align:'center'}
			 				]];
			var schedule_pool_toolbar = [			
				<%
				for(Integer key:menuInfoMap.keySet()){ 
				    MenuInfo mi = menuInfoMap.get(key);
				    if(mi.getParent_id().intValue()!=Integer.parseInt(menu_id))continue;
				    if(mi.getIs_menu().intValue()==2){
				     	if(mi.getMenu_code().indexOf("_all_employee_")>-1) {
					   		isAllEmp = true;
				    	}
				    	continue;
				    }
				   
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
								parent.showHtml(ctx+"<%=mi.getUrl()%>?menu_id=<%=mi.getId()%>","排班池<%=mi.getMenu_name()%>",1024);
							<%}%>
						<%}else if(mi.getMenu_code().indexOf("_edit_")>-1){%>
							<%if(employeeInfo==null){ %>
								parent.showInfo("用户与员工没有关联，请联系HR！");
							<%}else{%>
								var rows = _dataGrid.datagrid("getSelections");	//获取你选择的所有行
								if(rows.length!=1){
									parent.showInfo('请选择一项进行操作！');
									return false;
								}
								parent.showHtml(ctx+"<%=mi.getUrl()%>?menu_id=<%=mi.getId()%>"+"&id="+rows[0].id,"排班池<%=mi.getMenu_name()%> "+rows[0].wo_number,1024);
							<%}%>
						<%}else if(mi.getMenu_code().indexOf("_view_")>-1){%>
							var rows = _dataGrid.datagrid("getSelections");	//获取你选择的所有行
							if(rows.length!=1){
								parent.showInfo('请选择一项进行操作！');
								return false;
							}
							parent.showHtml(ctx+"<%=mi.getUrl()%>?menu_id=<%=mi.getId()%>"+"&id="+rows[0].id,"排班池<%=mi.getMenu_name()%> "+rows[0].wo_number,1024);
						<%}else if(mi.getMenu_code().indexOf("_batch_inner_flow_")>-1){%>
							var rows = _dataGrid.datagrid("getSelections");	//获取你选择的所有行
							if(rows.length==0){
								parent.showInfo('请选择一项进行操作！');
								return false;
							}
							var ids = '';
							for(var i=0;i<rows.length;i++){
								ids +=rows[i].id+',';
							}
							innerFlow(ids.substr(0,ids.length-1));
						<%}%>
					}
				},'-',
				<%
				}
				%>
				<%=Util.getHrClose(roleCodes,"/common/scheduleInfoPool/schedulePoolInvalid.do")%>
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
<script type="text/javascript" src="${ctx }/faurecia/common/service/schedule/pool/js/schedule_pool.js"></script>
</head>
<body>
	<jsp:include page="/share/jsp/menuAll.jsp" />
	<br />  
	<jsp:include page="/faurecia/common/service/schedule/pool/schedule_pool_search.jsp" >
		<jsp:param value="<%=isAllEmp.toString() %>" name="isAllEmp"/>
	</jsp:include>
	<div id="schedule_pool_datagrid"></div>
</body>
</html>