<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	SimpleDateFormat sdf1 = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	Calendar c = Calendar.getInstance();
%>
<script type="text/javascript">
var change_management_columns = [[
			 					{field:'id',hidden:true},
			 					{field:'dept_name',title:'Gap',width:100,sortable:true,align:'center'},
			 					{field:'emp_name',title:'GAP Leader',width:100,sortable:true,align:'center',hidden:false},
			 					{field:'report_date',title:'日期',width:150,sortable:true,align:'center',hidden:false},
			 					{field:'type',title:'变化点分类',width:150,sortable:true,align:'center',hidden:false},
			 					{field:'ext_1',title:'变化点内容',width:150,sortable:true,align:'center',hidden:false},
			 					{field:'ext_2',title:'变更可能产生的风险',width:150,sortable:true,align:'center',hidden:false},
			 					{field:'ext_3',title:'变更的确认内容及方法',width:200,sortable:true,align:'center',hidden:false},
			 					{field:'ext_4',title:'文件更新',width:200,sortable:true,align:'left',hidden:false},
			 					{field:'update_date',title:'UpdateDate',width:140,sortable:true,align:'center'}
			 				]];
			var change_management_toolbar = [			
				{
					text:'修改',
					iconCls:'icon-edit',
					handler:function(){
						var rows = _dataGrid.datagrid("getSelections");	//获取你选择的所有行
						if(rows.length!=1){
							showMsgInfo('请选择一项进行操作！');
							return false;
						}
						var id = rows[0].id;
						$('#tabs-a-1').attr("onclick","loadTab('tabs-1',function(){loadTab('tabs-1',function(){change_managementIn("+id+");});});");
						$("#tabs-a-1").click();
					}
				},'-',{
					text:'设为无效',
					iconCls:'icon-edit',
					handler:function(){
						var rows = _dataGrid.datagrid("getSelections");	//获取你选择的所有行
						if(rows.length==0){
						}else{
							var ids = '';
							for(var i=0;i<rows.length;i++){
								ids +=rows[i].id+',';
							}
							if(ids!=''){
								ids = ids.substring(0,ids.length-1);
								var param = {};
								param['ids']=ids;
								param['state']=0;
								ajaxUrl( ctx+'/common/change_management/doChangeManagementState.do',param,function(json){
									queryResult();
								});
							}
						}
					}
				},'-',{
					text:'签字',
					iconCls:'icon-edit',
					handler:function(){
						var rows = _dataGrid.datagrid("getSelections");	//获取你选择的所有行
						if(rows.length!=1){
							showMsgInfo('请选择一项进行操作！');
							return false;
						}
						var id = rows[0].id;
						showHtml(ctx+'/faurecia/ETOP5/change_management/data/sign.jsp?id='+id,'签字',800,400);
					}
				},'-',{
					text:'刷新',
					iconCls:'icon-reload',
					handler:function(){
						queryResult();
					}
				}];	
</script>
<jsp:include page="/common/shareJsp/cartHeadEasyUI.jsp"/>
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/change_management/data/js/index_data.js"></script>
<script type="text/javascript">
$(function(){
});
</script>
<div id="searchUser" class="overviewhead">
	状态：&nbsp;
	<select id="state" name="state" style="height:32px;">
		<option value="1" selected>有效</option>
		<option value="0">无效</option>
	</select>
	&nbsp;
	<a id="searchBtn" style="cursor:pointer;" class="btn btn_search radius50"><span>搜索</span></a>
</div>
<div id="change_management_data_datagrid"></div>	