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
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<jsp:include page="/common/shareJsp/cartHeadEasyUI.jsp"/>
<script type="text/javascript">
var check_columns = [[
	{field:'id',hidden:true,
		formatter:function(value, rowData, rowIndex){
			return rowData.wo_number;
		}
	},
	{field:'wo_number',title:'单号',width:'120',align:'center',sortable:true,hidden:false},
	{field:'count',title:'数量',width:'80',align:'center',sortable:true,hidden:false},
	{field:'flow_type',title:'类型',width:'80',align:'center',sortable:true,hidden:false},
	{field:'begin_date',title:'起始时间',width:'180',align:'center',sortable:true,hidden:false},
	{field:'end_date',title:'结束时间',width:'180',align:'center',sortable:true,hidden:false},
	{field:'dept_names',title:'GAP',width:'180',align:'center',sortable:false,hidden:false}
]];
var check_toolbar = [
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
			<%if(mi.getMenu_code().indexOf("_view_")>-1){%>
			var rows = _dataGrid.datagrid("getSelections");	//获取你选择的所有行
			if(rows.length!=1){
				parent.showInfo('请选择一项进行操作！');
				return false;
			}
			if(rows[0].flow_type=='<%=Global.flow_type[0]%>'){
				parent.showHtml(ctx+"<%=mi.getUrl()%>?menu_id=<%=mi.getId()%>"+"&wo_number="+rows[0].wo_number+"&flow_type="+rows[0].flow_type,"<%=mi.getMenu_name()%> "+rows[0].wo_number,1024);
			}else if(rows[0].flow_type=='<%=Global.flow_type[1]%>'){
				parent.showHtml(ctx+"/faurecia/common/service/breaktime/breaktime_view.jsp?menu_id=<%=mi.getId()%>"+"&id="+rows[0].id,"休假<%=mi.getMenu_name()%> "+rows[0].wo_number,900);
			}else if(rows[0].flow_type=='<%=Global.flow_type[2]%>'){
				parent.showHtml(ctx+"/faurecia/common/service/overtime/overtime_view.jsp?menu_id=<%=mi.getId()%>"+"&wo_number="+rows[0].wo_number+"&flow_type="+rows[0].flow_type,"<%=mi.getMenu_name()%> "+rows[0].wo_number,1024);
			}
			<%
			}else if(mi.getMenu_code().indexOf("_sh_")>-1){
			%>
			var rows = _dataGrid.datagrid("getSelections");	//获取你选择的所有行
			if(rows.length==0){
				parent.showInfo('请选择一项进行操作！');
				return false;
			}
			parent.showInfoCheck(function(r,s){
				var param = {};
				if(s){
					param['check_state']=<%=Global.flow_check_state[1]%>;
					param['check_state_name']='<%=Global.flow_check_state_name[1]%>';
				}else{
					param['check_state']=<%=Global.flow_check_state[2]%>;
					param['check_state_name']='<%=Global.flow_check_state_name[2]%>';
				}
				param['check_remark']=r;
				var msg = '';
				for(var i=0;i<rows.length;i++){
					var search_url = '',check_url = '';
					if(rows[i].flow_type=='<%=Global.flow_type[0]%>'){
						search_url = ctx+'/common/scheduleInfo/queryResult.do';
						check_url = ctx+'/common/scheduleInfo/scheduleCheck.do';
						var tmp_param = {};
						tmp_param['wo_number']=rows[i].wo_number;
						tmp_param['pageIndex']=1;
						tmp_param['pageSize']=1000;	
						tmp_param['available']='1';
						ajaxUrlFalse(search_url,tmp_param,function(json){
							$.each(json.rows, function (n, value) {  
								param['id'] = value.id;
								ajaxUrlFalse(check_url,param,function(json){
									if(json.msg!=''){
								    	msg = "“"+param['check_state_name']+"”"+json.msg;
									}else{
									}
								});
					        });
						});
					}else if(rows[i].flow_type=='<%=Global.flow_type[1]%>'){
						//search_url = ctx+'/common/breakTimeInfo/queryResult.do';
						check_url = ctx+'/common/breakTimeInfo/breakTimeCheck.do';
						param['id'] = rows[i].id;
						ajaxUrlFalse(check_url,param,function(json){
							if(json.msg!=''){
						    	msg = "“"+param['check_state_name']+"”"+json.msg;
							}else{
							}
						});
					}else if(rows[i].flow_type=='<%=Global.flow_type[2]%>'){
						//search_url = ctx+'/common/overTimeInfo/queryResult.do';
						check_url = ctx+'/common/overTimeInfo/overTimeCheck.do';
						param['id'] = rows[i].id;
						ajaxUrlFalse(check_url,param,function(json){
							if(json.msg!=''){
						    	msg = "“"+param['check_state_name']+"”"+json.msg;
							}else{
							}
						});
					}
				}
				if(msg.Trim().length>0){
					parent.showMsgInfo(msg.Trim());
				}
				queryResult();
			});
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
<script type="text/javascript" src="${ctx }/faurecia/improvement/audit/js/improve_audit_.js"></script>
</head>
<body>
	<jsp:include page="/share/jsp/menuAll.jsp" />
	<br />  
	<jsp:include page="/faurecia/common/service/check/check_search.jsp" />
	<div id="check_datagrid"></div>
</body>
</html>