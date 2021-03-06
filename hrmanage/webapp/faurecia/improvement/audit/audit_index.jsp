<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ include file="/faurecia/improvement/connector.jsp"%>
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
<script type="text/javascript" src="${ctx}/faurecia/improvement/audit/js/improve_audit_.js?v=1002"></script>
<script type="text/javascript">
var breaktime_columns = [[
   			{field:'id',hidden:true},
   			{field:'submitterDeptId',hidden:true},
   			{field:'submitEMId',hidden:true},
   			{field:'submitUserId',hidden:true},
   			{field:'status',hidden:true},
   			{field:'auditStep',hidden:true},
   			{field:'generalizaterId',hidden:true},
   			{field:'formCode',title:'单号',width:'100',align:'center',sortable:true,hidden:false},
   			{field:'submitterDept',title:'提案部门',width:'100',align:'center',sortable:true,hidden:false},
   			{field:'EMName',title:'提案人',width:'80',align:'center',sortable:true,hidden:false},
   			{field:'latestAuditName',title:'最新操作人',width:'80',align:'center',sortable:false,hidden:false},
   			{field:'nextAuditEMPName',title:'下一操作人',width:'80',align:'center',sortable:false,hidden:false},
   			{field:'statusTxt',title:'状态',width:'180',align:'center',sortable:false,hidden:false},
   			{field:'currentSituation',title:'目前状况',width:'200',align:'left',sortable:true,hidden:false},
   			{field:'proposedSolution',title:'建议方案',width:'200',align:'left',sortable:true,hidden:false},
   			{field:'generalizaterName',title:'推广人',width:'80',align:'center',sortable:false,hidden:false},
   			{field:'generalizeNum',title:'推广单号',width:'80',align:'center',sortable:false,hidden:false},
   			{field:'createdTime',title:'提交时间',width:'140',sortable:true,align:'center'},
   			{field:'updateTime',title:'更新时间',width:'140',sortable:true,align:'center'}
   		]];
var total_columns = [[
		{field:'id',hidden:true,
			formatter:function(value, rowData, rowIndex){
				return rowData.id;
			}
		},
		{field:'formName',title:'单号',width:'120',align:'center',sortable:true,hidden:false,
			formatter:function(value, rowData, rowIndex){
				return "<a style='cursor:pointer;' onclick='parent.showHtml(\"${ctx}/faurecia/common/service/breaktime/breaktime_list_view.jsp?wo_number="+value+"\",\"排班\",1024);'>"+value+"</a>";
			}
		},
		{field:'count',title:'数量',width:'80',align:'center',sortable:true,hidden:false},
		//{field:'flow_type',title:'类型',width:'80',align:'center',sortable:true,hidden:false},
		{field:'createdTime',title:'起始时间',width:'180',align:'center',sortable:true,hidden:false},
		{field:'updateTime',title:'结束时间',width:'180',align:'center',sortable:true,hidden:false},
		{field:'GAPGroup',title:'GAP',width:'180',align:'center',sortable:false,hidden:false}
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
								parent.showHtml(ctx+"<%=mi.getUrl()%>?menu_id=<%=mi.getId()%>","合理化建议 - <%=mi.getMenu_name()%>",900);
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

								if(rows[0].status != 1 || rows[0].submitEMId != '<%=employeeInfo.getId()%>' ){
									parent.showInfo('当前环节不能修改！');
									return false;
								}else{
									parent.showHtml(ctx+"<%=mi.getUrl()%>?menu_id=<%=mi.getId()%>"+"&id="+rows[0].id,"合理化建议 - <%=mi.getMenu_name()%> "+rows[0].formCode,900);
								}
							<%}%>
						<%}else if(mi.getMenu_code().indexOf("_view_")>-1){%>
							var rows = _dataGrid.datagrid("getSelections");	//获取你选择的所有行
							if(rows.length!=1){
								parent.showInfo('请选择一项进行操作！');
								return false;
							}
							parent.showHtml(ctx+"<%=mi.getUrl()%>?menu_id=<%=mi.getId()%>"+"&id="+rows[0].id,"合理化建议 - <%=mi.getMenu_name()%> "+rows[0].formCode,900);
						<%
						}else if(mi.getMenu_code().indexOf("_gene_")>-1){
						%>
							var rows = _dataGrid.datagrid("getSelections");	//获取你选择的所有行
							if(rows.length==0){
								parent.showInfo('请选择项进行操作！');
								return false;
							}
							
							if( rows[0].executorId == '<%=employeeInfo.getId()%>' || rows[0].submitEMId == '<%=employeeInfo.getId()%>' ){
								
							} else {
								parent.showInfo('所选项您不能推广！');
								return false;
							}
							if((rows[0].status != 8 ||  rows[0].status == 9)){
								parent.showInfo('当前状态不能推广！');
								return false;
							}
							
							parent.showHtml(ctx+"<%=mi.getUrl()%>?menu_id=<%=mi.getId()%>"+"&id="+rows[0].id,"合理化建议 - <%=mi.getMenu_name()%> "+rows[0].formCode,900);
						
						<%}%>
					}
				},'-',
				<%
				}
				%>
				<%-- <%=Util.getHrClose(roleCodes,"/common/breakTimeInfo/breakTimeInvalid.do")%>	 --%>		
				{
					text:'刷新',
					iconCls:'icon-reload',
					handler:function(){
						document.location.reload();
					}
				}];	
		/**
		**初始化JS 
		**
		**/
		$(function(){
			$('#search #searchBtn').click(function(){
				queryResult();
			});
			
			$('#search #searchExportBtn').click(function(){
				if($('#requestParam_dept_ids').val()==''){
					$('#requestParam_dept_ids').val('0');
				}
				var param = getParams("search");
				var u = ctx+"/common/breakTimeInfo/exportCsv.do"; //请求链接
				downFile(u,param);
			});	
			queryResult();
			
		});					
</script>
<script type="text/javascript" src="${ctx }/faurecia/improvement/audit/js/improve_audit_.js?v=10024"></script>
</head>
<body>
	<jsp:include page="/share/jsp/menuAll.jsp" />
	<jsp:include page="/faurecia/improvement/audit/audit_search.jsp" />
	<div id="audit_datagrid"></div>
</body>
</html>