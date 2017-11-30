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
var plant_columns = [[
			 					{field:'id',hidden:true},
			 					{field:'begin_year',title:'月份',width:80,sortable:true,align:'center'},
			 					{field:'type',title:'类型',width:80,sortable:true,align:'center',hidden:false},
			 					{field:'level1',title:'Level',width:80,sortable:true,align:'center',hidden:false},
			 					{field:'plant',title:'PLANT',width:450,sortable:true,align:'center',hidden:false},
			 					//{field:'state',title:'状态',width:60,sortable:true,align:'center',hidden:false},
			 					{field:'update_date',title:'UpdateDate',width:140,sortable:true,align:'center'}
			 				]];
			var plant_toolbar = [			
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
						$('#tabs-a-1').attr("onclick","loadTab('tabs-1',function(){loadTab('tabs-1',function(){plantIn("+id+");});});");
						$("#tabs-a-1").click();
					}
				},'-',{
					text:'删除',
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
								ajaxUrl(ctx+'/common/plant/doPlantState.do',param,function(json){
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
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/plant/data/js/index_data.js"></script>
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
	Level：&nbsp;
	<select id="level1" name="level1" style="height:32px;">
		<option value="" selected>---请选择---</option>
		<option value="<%=Global.level[0] %>" ><%=Global.level[0] %></option>
		<option value="<%=Global.level[1] %>" ><%=Global.level[1] %></option>
		<option value="<%=Global.level[2] %>" ><%=Global.level[2] %></option>
	</select>
	&nbsp;
	<a id="searchBtn" style="cursor:pointer;" class="btn btn_search radius50"><span>搜索</span></a>
</div>
<div id="plant_data_datagrid"></div>	