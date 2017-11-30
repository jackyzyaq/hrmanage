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
var qrci_line_columns = [[
			 					{field:'id',hidden:true},
			 					{field:'number1',title:'LINE QRCI',width:100,sortable:true,align:'center'},
			 					{field:'number2',title:'NO.',width:50,sortable:true,align:'center'},
			 					{field:'opening_date',title:'召开日期',width:100,sortable:true,align:'center',hidden:false},
			 					{field:'dept_name',title:'GAP',width:150,sortable:true,align:'center',hidden:false},
			 					//{field:'problem_discription',title:'问题描述',width:150,sortable:true,align:'center',hidden:false},
			 					//{field:'standards_check',title:'标准检查',width:150,sortable:true,align:'center',hidden:false},
			 					//{field:'cause_analysis',title:'原因分析',width:150,sortable:true,align:'center',hidden:false},
			 					//{field:'action',title:'行动措施',width:200,sortable:true,align:'center',hidden:false},
			 					//{field:'handler',title:'责任人',width:200,sortable:true,align:'left',hidden:false},
			 					//{field:'deadline',title:'日期',width:200,sortable:true,align:'left',hidden:false},
			 					//{field:'val_date',title:'验证日期',width:200,sortable:true,align:'left',hidden:false},
			 					//{field:'class_name',title:'班次',width:200,sortable:true,align:'left',hidden:false},
			 					//{field:'is_ok',title:'结果',width:200,sortable:true,align:'left',hidden:false},
			 					//{field:'updates',title:'是否更新/是否培训',width:200,sortable:true,align:'left',hidden:false},
			 					{field:'signed_by_employee',title:'签字',width:200,sortable:true,align:'left',hidden:false},
			 					{field:'remark',title:'备注',width:200,sortable:true,align:'left',hidden:false},
			 					{field:'is_close',title:'是否关闭',width:200,sortable:true,align:'left',hidden:false},
			 					{field:'is_re_happend',title:'是否重复发生',width:200,sortable:true,align:'left',hidden:false},
			 					{field:'is_up',title:'是否上升',width:200,sortable:true,align:'left',hidden:false},
			 					{field:'up_number',title:'上升的UAP QRCI编号',width:200,sortable:true,align:'left',hidden:false},
			 					{field:'update_date',title:'UpdateDate',width:140,sortable:true,align:'center'}
			 				]];
			var qrci_line_toolbar = [			
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
						$('#tabs-a-1').attr("onclick","loadTab('tabs-1',function(){loadTab('tabs-1',function(){qrci_lineIn("+id+");});});");
						$("#tabs-a-1").click();
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
						showHtml(ctx+'/faurecia/ETOP5/qrci_line/data/sign.jsp?id='+id,'签字',800,400);
					}
				},'-',{
					text:'删除',
					iconCls:'icon-edit',
					handler:function(){
						var rows = _dataGrid.datagrid("getSelections");	//获取你选择的所有行
						if(rows.length==0){
							showMsgInfo('请至少选择一项进行操作！');
							return false;
						}
						var ids = '';
						for(var i=0;i<rows.length;i++){
							ids +=rows[i].id+',';
						}
						if(ids!=''){
							ids = ids.substring(0,ids.length-1);
							var param = {};
							param['ids']=ids;
							ajaxUrl(ctx+'/common/qrci_line/doDel.do',param,function(json){
								showMsgInfo(json.msg);
								queryResult();
							});
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
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/qrci_line/data/js/index_data.js"></script>
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
<div id="qrci_line_data_datagrid"></div>	