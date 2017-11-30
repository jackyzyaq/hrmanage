<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	SimpleDateFormat sdf1 = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	PlantKPIService plantKPIService = (PlantKPIService) ctx.getBean("plantKPIService");
	List<PlantKPI> listDept = plantKPIService.queryKPIDept();
	Calendar c = Calendar.getInstance();
%>
<script type="text/javascript">
var kpi_columns = [[
			 					{field:'id',hidden:true},
			 					{field:'kpi_type',title:'KPI',width:100,sortable:true,align:'center'},
			 					{field:'kpi_date',title:'Date',width:100,sortable:true,align:'center',hidden:false},
			 					{field:'dept_name',title:'Department',width:100,sortable:true,align:'center',hidden:false},
			 					{field:'ext_1',title:'Input/Output',width:100,sortable:true,align:'center',hidden:false},
			 					{field:'target',title:'Target',width:100,sortable:true,align:'center',hidden:false},
			 					{field:'actual',title:'Actual',width:100,sortable:true,align:'center',hidden:false},
			 					{field:'cum',title:'Cum',width:100,sortable:true,align:'center',hidden:false},
			 					{field:'ext_3',title:'Correct/Opposite',width:100,sortable:true,align:'center',hidden:false},
			 					{field:'health_png',title:'ISOK',width:100,sortable:true,align:'center',hidden:false},
			 					{field:'ext_2',title:'QCDPN',width:'80',align:'center',sortable:false,hidden:false},
			 					{field:'ext_4',title:'IssueDescription',width:100,sortable:true,align:'center',hidden:false},
			 					{field:'ext_5',title:'ActionPlan',width:100,sortable:true,align:'center',hidden:false},
			 					{field:'ext_6',title:'Resp',width:100,sortable:true,align:'center',hidden:false},
			 					{field:'ext_7',title:'Deadline',width:100,sortable:true,align:'center',hidden:false},
			 					{field:'ext_10',title:'分类原因',width:100,sortable:true,align:'center',hidden:false},
			 					{field:'update_date',title:'UpdateDate',width:140,sortable:true,align:'center'}
			 				]];
			var kpi_toolbar = [			
				{
					text:'刷新',
					iconCls:'icon-reload',
					handler:function(){
						queryResult();
					}
				}];	
</script>
<jsp:include page="/common/shareJsp/cartHeadEasyUI.jsp"/>
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/plant_kpi/data/js/kpi_data.js"></script>
<script type="text/javascript">
$(function(){
		$("#searchUser #dept_name").change(function(){
			if($(this).val().length>0){
				loadKpiType('searchUser #kpi_type',$(this).val());
			}
		});
	});
</script>
<div id="searchUser" class="overviewhead">
	日期：&nbsp;
	<input class="Wdate" type="text" title="日期" style="width:80px" readonly="readonly" id="start_date" name="start_date" value="<%=sdf1.format(c.getTime()) %>"  onclick="wdateInstance2();"/>
	&nbsp;~&nbsp;
	<input class="Wdate" type="text" title="日期" style="width:80px" readonly="readonly" id="over_date" name="over_date" value="<%=sdf1.format(c.getTime()) %>"  onclick="wdateInstance2();"/>
	&nbsp;Department：&nbsp;
	<select id="dept_name" name="dept_name" style="height:30px;width:80px">
		<option value="" selected="selected">---Select---</option>
		<%for(PlantKPI pk:listDept){ %>
		<option value="<%=pk.getDept_name()%>"><%=pk.getDept_name()%></option>
		<%} %>
	</select>
	&nbsp;KPI：&nbsp;
	<select id="kpi_type" name="kpi_type" style="height:30px;width:120px">
		<option value="" selected="selected">---Select---</option>
	</select>
	&nbsp;I/O：&nbsp;
	<select id="ext_1" name="ext_1" title="INPUT、OUTPUT" style="height:30px;width:50px">
		<option value="" selected></option>
		<option value="<%=Global.plant_kpi_io[0]%>"><%=Global.plant_kpi_io[0]%></option>
		<option value="<%=Global.plant_kpi_io[1]%>"><%=Global.plant_kpi_io[1]%></option>
	</select>
	&nbsp;QCDPN：&nbsp;
	<select id="ext_2" name="ext_2" title="QCDPN" style="height:30px;width:50px">
		<option value="" selected></option>
		<%for(String t:Global.plant_kpi_qcdp){ %>
		<option value="<%=t%>"><%=t%></option>
		<%} %>
	</select>
	&nbsp;	
	<a id="searchBtn" style="cursor:pointer;" class="btn btn_search radius50"><span>搜索</span></a>
	&nbsp;
	<a id="exportBtn" style="cursor:pointer;" class="btn btn_search radius50"><span>导出</span></a>
</div>
<div id="kpi_data_datagrid"></div>	