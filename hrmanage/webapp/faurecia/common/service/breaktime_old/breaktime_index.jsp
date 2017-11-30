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
    Boolean isSH = false;
    Boolean isAllEmp = false;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<jsp:include page="/common/shareJsp/cartHeadEasyUI.jsp"/>
<script type="text/javascript">
var breaktime_columns = [[
			 					{field:'id',hidden:true},
			 					{field:'flow_id',hidden:true},
			 					{field:'dept_id',hidden:true},
			 					{field:'emp_id',hidden:true},
			 					{field:'user_id',hidden:true},
			 					{field:'check_emp_id',hidden:true},
			 					{field:'next_check_emp_id',hidden:true},
			 					{field:'wo_number',title:'单号',width:'120',align:'center',sortable:true,hidden:false},
			 					{field:'dept_name',title:'部门',width:'180',align:'center',sortable:true,hidden:false},
								{field:'emp_name',title:'申请人',width:'80',align:'center',sortable:true,hidden:false},
								{field:'begin_date',title:'开始时间',width:'140',align:'center',sortable:true,hidden:false},
								{field:'end_date',title:'结束时间',width:'140',align:'center',sortable:true,hidden:false},
			 					{field:'break_hour',title:'休假时长(h)',width:'80',align:'center',sortable:true,hidden:false},
								{field:'type',title:'休假类型',width:'100',align:'center',sortable:true,hidden:false},
								{field:'remark',title:'休假事由',width:'240',align:'center',sortable:true,hidden:false},
								{field:'status',title:'工作流',width:'80',align:'center',sortable:false,hidden:false,
									formatter:function(value, rowData, rowIndex){
										if(value=='<%=Global.flow_check_status[0]%>'){
											return '<%=Global.flow_check_status_name[0]%>';
										}else if(value=='<%=Global.flow_check_status[1]%>'){
											return '<%=Global.flow_check_status_name[1]%>';
										}else if(value=='<%=Global.flow_check_status[2]%>'){
											return '<%=Global.flow_check_status_name[2]%>';
										}else {
											return '';
										}
						   			}
								},
			 					{field:'check_emp_name',title:'审核人',width:'80',align:'center',sortable:false,hidden:false},
			 					{field:'check_state',title:'审核状态',width:'80',align:'center',sortable:false,hidden:false,
									formatter:function(value, rowData, rowIndex){
										if(value=='<%=Global.flow_check_state[0]%>'){
											return '<%=Global.flow_check_state_name[0]%>';
										}else if(value=='<%=Global.flow_check_state[1]%>'){
											return '<%=Global.flow_check_state_name[1]%>';
										}else if(value=='<%=Global.flow_check_state[2]%>'){
											return '<%=Global.flow_check_state_name[2]%>';
										}else {
											return '';
										}
						   			}
								},
								{field:'check_state_date',title:'审核时间',width:'140',align:'center',sortable:true,hidden:false},
								{field:'update_date',title:'更新时间',width:140,sortable:true,align:'center'}
			 				]];
var total_columns = [[
	{field:'id',hidden:true,
		formatter:function(value, rowData, rowIndex){
			return rowData.wo_number;
		}
	},
	{field:'wo_number',title:'单号',width:'120',align:'center',sortable:true,hidden:false,
		formatter:function(value, rowData, rowIndex){
			return "<a style='cursor:pointer;' onclick='parent.showHtml(\"${ctx}/faurecia/common/service/breaktime/breaktime_list_view.jsp?wo_number="+value+"\",\"排班\",1024);'>"+value+"</a>";
		}
	},
	{field:'count',title:'数量',width:'80',align:'center',sortable:true,hidden:false},
	{field:'flow_type',title:'类型',width:'80',align:'center',sortable:true,hidden:false},
	{field:'begin_date',title:'起始时间',width:'180',align:'center',sortable:true,hidden:false},
	{field:'end_date',title:'结束时间',width:'180',align:'center',sortable:true,hidden:false},
	{field:'dept_names',title:'GAP',width:'180',align:'center',sortable:false,hidden:false}
]];	
			var breaktime_toolbar = [			
				<%
				for(Integer key:menuInfoMap.keySet()){ 
				    MenuInfo mi = menuInfoMap.get(key);
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
								parent.showHtml(ctx+"<%=mi.getUrl()%>?menu_id=<%=mi.getId()%>","休假<%=mi.getMenu_name()%>",900);
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
								if(rows[0].status=='2'){
									parent.showInfo('审批结束不能修改！');
									return false;
								}else{
									parent.showHtml(ctx+"<%=mi.getUrl()%>?menu_id=<%=mi.getId()%>"+"&id="+rows[0].id,"休假<%=mi.getMenu_name()%> "+rows[0].wo_number,900);
								}
							<%}%>
						<%}else if(mi.getMenu_code().indexOf("_view_")>-1){%>
							var rows = _dataGrid.datagrid("getSelections");	//获取你选择的所有行
							if(rows.length!=1){
								parent.showInfo('请选择一项进行操作！');
								return false;
							}
							parent.showHtml(ctx+"<%=mi.getUrl()%>?menu_id=<%=mi.getId()%>"+"&id="+rows[0].id,"休假<%=mi.getMenu_name()%> "+rows[0].wo_number,900);
						<%
						}else if(mi.getMenu_code().indexOf("_sh_")>-1){
						%>
						var rows = _dataGrid.datagrid("getSelections");	//获取你选择的所有行
						if(rows.length==0){
							parent.showInfo('请选择项进行操作！');
							return false;
						}
						parent.showInfoCheck(function(r,s){
								var param = {};
								if(s){
									param['check_state']=<%=Global.flow_check_state[1]%>;
								}else{
									param['check_state']=<%=Global.flow_check_state[2]%>;
								}
								for(var i=0;i<rows.length;i++){
									param['id']=rows[i].id;
									param['check_remark']=r;
									ajaxUrlFalse(ctx+'/common/breakTimeInfo/breakTimeCheck.do',param,function(json){
										if(json.msg!=''){
									    	parent.showMsgInfo(json.msg);
										}else{
										}
									});
								}
								document.location.reload(true);
							});
						<%}%>
					}
				},'-',
				<%
				}
				%>
				<%=Util.getHrClose(roleCodes,"/common/breakTimeInfo/breakTimeInvalid.do")%>			
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
<script type="text/javascript" src="${ctx }/faurecia/common/service/breaktime/js/breaktime.js"></script>
</head>
<body>
	<jsp:include page="/share/jsp/menuAll.jsp" />
	<br />  
	<jsp:include page="/faurecia/common/service/breaktime/breaktime_search.jsp" >
		<jsp:param value="<%=isSH.toString() %>" name="isSH"/>
		<jsp:param value="<%=isAllEmp.toString() %>" name="isAllEmp"/>
	</jsp:include>
	<div id="breaktime_datagrid"></div>
</body>
</html>