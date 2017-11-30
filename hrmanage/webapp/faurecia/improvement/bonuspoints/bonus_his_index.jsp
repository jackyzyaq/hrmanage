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
<script type="text/javascript" src="${ctx}/faurecia/improvement/rewardproducts/js/product.js?v=1002"></script>
<script type="text/javascript">
var breaktime_columns = [[
   			{field:'id',hidden:true},
   			{field:'type',title:'操作类型',width:'80',align:'center',sortable:false,hidden:false,
   				formatter:function(value, rowData, rowIndex){
   					if(value != '' && 'null' != value && 'undifinde' != value && value == -1) {
   						return "兑换";
   					}else{
   						return "增加";
   					}
	   			}	
   			},
   			{field:'BPValues',title:'积分值',width:'80',align:'center',sortable:false,hidden:false},
   			{field:'productName',title:'产品',width:'120',align:'center',sortable:false,hidden:false},
   			{field:'status',title:'状态',width:'120',align:'center',sortable:false,hidden:false,
   				formatter:function(value, rowData, rowIndex){
   					if(value != '' && 'null' != value && 'undifinde' != value && value == 1) {
   						return "提交申请";
   					}else{
   						return "已确认";
   					}
	   			}	
   			},
   			{field:'orderId',title:'订单号',width:'120',align:'center',sortable:false,hidden:false},
   			{field:'improveCode',title:'建议编号',width:'120',align:'center',sortable:false,hidden:false},
   			{field:'update_time',title:'更新时间',width:'140',sortable:false,align:'center'}
   		]];
		var breaktime_toolbar = [];	
		function queryResult(){
			_dataGridFn("audit_datagrid",'/fhr/fhrapi/bp/index?EMPId='+<%=employeeInfo.getId()%>,breaktime_columns,breaktime_toolbar);
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
	<div id="audit_datagrid"></div>
</body>
</html>