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
var managementSchedule_columns = [[
			 					{field:'id',hidden:true},
			 					{field:'tb_name',title:'姓名',width:100,sortable:true,align:'center'},
			 					{field:'tb_schedule_date',title:'日期',width:100,sortable:true,align:'center',hidden:false},
			 					{field:'tb_status_am',title:'AM',width:150,sortable:true,align:'center',hidden:false},
			 					{field:'tb_status_pm',title:'PM',width:150,sortable:true,align:'center',hidden:false},
			 					{field:'tb_backup',title:'backup',width:150,sortable:true,align:'center',hidden:false},
			 					{field:'tb_create_user',title:'创建者',width:150,sortable:true,align:'center',hidden:false},
			 					{field:'tb_update_user',title:'修改者',width:200,sortable:true,align:'center',hidden:false},
			 					{field:'update_date',title:'操作日期',width:200,sortable:true,align:'left',hidden:false}
			 				]];
			var managementSchedule_toolbar = [			
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
						$('#tabs-a-1').attr("onclick","loadTab('tabs-1',function(){loadTab('tabs-1',function(){managementScheduleIn("+id+");});});");
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
								ids.substring(0,ids.length-1);
								var param = {};
								param['ids']=ids;
								param['state']=0;
								ajaxUrl( ctx+'/common/managementSchedule/doManagementScheduleState.do',param,function(json){
									queryResult();
								});
							}
						}
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
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/weekly_schedule/data/js/managementSchedule_data.js"></script>
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
<div id="managementSchedule_data_datagrid"></div>	