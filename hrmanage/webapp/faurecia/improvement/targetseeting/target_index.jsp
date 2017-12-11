<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ include file="/faurecia/improvement/connector.jsp"%>
<%
	EmployeeInfo employeeInfo = (EmployeeInfo)session.getAttribute("employeeInfo");
    Map<Integer,MenuInfo> menuInfoMap = (Map<Integer,MenuInfo>)session.getAttribute("menuRole");
    String roleCodes = StringUtils.defaultIfEmpty((String)session.getAttribute("roleCodes"), "");
    String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
    Boolean isSH = false;
    Boolean isAllEmp = false;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<jsp:include page="/common/shareJsp/cartHeadEasyUI.jsp"/>
<script type="text/javascript" src="${ctx}/faurecia/improvement/audit/js/improve_audit_.js?v=1002"></script>
<script type="text/javascript">
var breaktime_columns = [[
   			{field:'id',hidden:true},
   			{field:'targetDeptId',hidden:true},
   			{field:'empId',hidden:true},
   			{field:'targetYear',hidden:true},
   			{field:'targetDay',hidden:true},
   			{field:'targetMonth',title:'月份',width:'120',align:'center',sortable:true,hidden:false},
   			{field:'targetDeptName',title:'部门',width:'140',align:'center',sortable:true,hidden:false},
   			{field:'targetValue',title:'目标值',width:'80',align:'center',sortable:true,hidden:false},
   			{field:'empName',title:'操作人',width:'80',align:'center',sortable:false,hidden:false},
   			{field:'createdTime',title:'提交时间',width:'140',sortable:true,align:'center'},
   			{field:'updateTime',title:'更新时间',width:'140',sortable:true,align:'center'}
   		]];
			var breaktime_toolbar = [			
				<%
				for(Integer key:menuInfoMap.keySet()){ 
				    MenuInfo mi = menuInfoMap.get(key);
				    //System.out.println(mi.getMenu_name());
				    if(mi.getParent_id().intValue()!=Integer.parseInt(menu_id))continue;
				    if(mi.getMenu_code().indexOf("_sh_")>-1) isSH = true;
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
								parent.showHtml(ctx+"<%=mi.getUrl()%>?menu_id=<%=mi.getId()%>","合理化建议目标设定 - <%=mi.getMenu_name()%>",900,260);
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
 								parent.showHtml(ctx+"<%=mi.getUrl()%>?menu_id=<%=mi.getId()%>"+"&id="+rows[0].id,"合理化建议目标设定- <%=mi.getMenu_name()%> ",900,260);
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
			
			
			/**
			 * 列表
			 * @returns
			 */
			function queryResult(){
				if($('#requestParam_dept_ids').val()==''){
					$('#requestParam_dept_ids').val('0');
				}
				
				var param = getParams("search");
				_dataGridFn("audit_datagrid",'/fhr/fhrapi/itarget/index?'+param,breaktime_columns,breaktime_toolbar);
				
			}
		/**
		**初始化JS 
		**
		**/
		$(function(){
			$('#search #searchBtn').click(function(){
				queryResult();
			});
			queryResult();
		});					
</script>
</head>
<body>
	<jsp:include page="/share/jsp/menuAll.jsp" />
	<jsp:include page="/faurecia/improvement/targetseeting/target_search.jsp" />
	<div id="audit_datagrid"></div>
</body>
</html>