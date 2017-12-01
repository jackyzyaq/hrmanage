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
   			{field:'EMPId',hidden:true},
   			{field:'productId',hidden:true},
   			{field:'orderId',title:'订单号',width:'120',align:'center',sortable:false,hidden:false},
   			{field:'EMPName',title:'申请员工',width:'120',align:'center',sortable:false,hidden:false},
   			{field:'deptName',title:'所在部门',width:'120',align:'center',sortable:false,hidden:false},
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
   			{field:'productName',title:'礼品',width:'80',align:'center',sortable:false,hidden:false},
   			{field:'status',title:'状态',width:'120',align:'center',sortable:false,hidden:false,
   				formatter:function(value, rowData, rowIndex){
   					if(value != '' && 'null' != value && 'undifinde' != value && value == 1) {
   						return "提交申请";
   					}else{
   						return "已确认";
   					}
	   			}	
   			},
   			{field:'updateTime',title:'更新时间',width:'140',sortable:false,align:'center'}
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
				<%if(mi.getMenu_code().indexOf("_impbpoint_audit_")>-1){%>
					<%if(employeeInfo==null){ %>
						parent.showInfo("用户与员工没有关联，请联系HR！");
					<%}else{%>
					var rows = _dataGrid.datagrid("getSelections");	//获取你选择的所有行
					if(rows.length!=1){
						parent.showInfo('请选择一项进行操作！');
						return false;
					}
					 if(confirm('所选礼品【'+ rows[0].productName+'】须使用【'+rows[0].BPValues+'】积分，是否确认兑换？')){
						var params = {};
						params['status']='2';
						params['id']=rows[0].id;
						params['editstatus']='true';
						var url  = '${improve}'+'/fhrapi/bp/save'
						$.ajax({
							url : url, // 请求链接
							data: params,
							type:"POST",     // 数据提交方式
							cache: false,
							timeout: 5000,
							async:false,
							dataType: 'json',
							success:function(data){
								if(data.code == "S")
									parent.showInfo(data.msg);
								else
									parent.showInfo(data.msg+",请检查库存或积分不够！");
								
								window.setTimeout(
								function() {
										document.location.reload();
								}, 1500);
							},
							error:function(data){
								parent.showInfo("操作不成功，如重复出现请联系IT！");
							}
						});	
					   }
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
				_dataGridFn("audit_datagrid",'/fhr/fhrapi/bp/index?'+param+'&type=-1',breaktime_columns,breaktime_toolbar);
				
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
	<br />  
	<jsp:include page="/faurecia/improvement/rewardproducts/product_search.jsp" >
		<jsp:param value="<%=isSH%>" name="isSH"/>
		<jsp:param value="<%=isAllEmp%>" name="isAllEmp"/>
	</jsp:include>
	<div id="audit_datagrid"></div>
</body>
</html>