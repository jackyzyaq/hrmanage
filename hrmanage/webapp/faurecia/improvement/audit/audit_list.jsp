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
			{field:'submitterDeptId',hidden:true},
			{field:'submitEMId',hidden:true},
			{field:'submitUserId',hidden:true},
			{field:'formCode',title:'单号',width:'120',align:'center',sortable:true,hidden:false},
			{field:'submitterDept',title:'提案部门',width:'140',align:'center',sortable:true,hidden:false},
			{field:'EMName',title:'提案人',width:'80',align:'center',sortable:true,hidden:false},
			{field:'latestAuditName',title:'最新操作人',width:'80',align:'center',sortable:false,hidden:false},
			{field:'statusTxt',title:'最新操作状态',width:'80',align:'center',sortable:false,hidden:false},
			{field:'nextAuditEMPName',title:'下一操作人',width:'80',align:'center',sortable:false,hidden:false},
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
			<% if(mi.getMenu_code().indexOf("_check_")>-1){%>
				var rows = _dataGrid.datagrid("getSelections");	//获取你选择的所有行
				if(rows.length!=1){
					parent.showInfo('请选择一项进行操作！');
					return false;
				}
				parent.showHtml(ctx+"<%=mi.getUrl()%>?menu_id=<%=mi.getId()%>"+"&id="+rows[0].id,"合理化 - <%=mi.getMenu_name()%> "+rows[0].formCode,900);
			<%
			}else if(mi.getMenu_code().indexOf("_sh_")>-1){
			%>
			var rows = _dataGrid.datagrid("getSelections");	//获取你选择的所有行
			if(rows.length==0){
				parent.showInfo('请选择项进行操作！');
				return false;
			}
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
	/**
	**初始化JS方法
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
		queryResultForAudit('<%=employeeInfo.getId()%>');
		
	});							
</script>
<script type="text/javascript" src="${ctx }/faurecia/improvement/audit/js/improve_audit_.js?v=10025"></script>
</head>
<body>
	<jsp:include page="/share/jsp/menuAll.jsp" />
	<br />  
	<jsp:include page="/faurecia/improvement/audit/audit_search.jsp" >
		<jsp:param value="<%=isSH%>" name="isSH"/>
		<jsp:param value="<%=isAllEmp%>" name="isAllEmp"/>
		<jsp:param value="<%=true%>" name="isCheck"/>
	</jsp:include>
	<div id="audit_datagrid"></div>
</body>
</html>