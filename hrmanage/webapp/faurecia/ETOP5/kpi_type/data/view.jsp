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
var kpiType_columns = [[
			 					{field:'id',hidden:true},
			 					{field:'parent_id',hidden:true},
			 					{field:'state',hidden:true},
			 					{field:'name',title:'名称',width:80,sortable:true,align:'center'},
			 					{field:'parent_name',title:'上级',width:80,sortable:true,align:'center',hidden:false},
			 					{field:'create_user',title:'创建者',width:80,sortable:true,align:'center',hidden:false},
			 					{field:'operater',title:'操作者',width:80,sortable:true,align:'center',hidden:false},
			 					//{field:'state_name',title:'状态',width:60,sortable:true,align:'center',hidden:false},
			 					{field:'update_date',title:'UpdateDate',width:140,sortable:true,align:'center'}
			 				]];
			var kpiType_toolbar = [			
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
						$('#tabs-a-1').attr("onclick","loadTab('tabs-1',function(){loadTab('tabs-1',function(){kpiTypeIn("+id+");});});");
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
								ajaxUrl(ctx+'/common/kpiType/dokpiTypeState.do',param,function(json){
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
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/kpi_type/data/js/index_data.js"></script>
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
<div id="kpiType_data_datagrid"></div>	