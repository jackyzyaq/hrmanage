<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String year = StringUtils.defaultIfEmpty(request.getParameter("year"), "");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	SimpleDateFormat sdf1 = new SimpleDateFormat(Global.DATE_FORMAT_STR_D);
	Calendar cal = Calendar.getInstance();
	if(StringUtils.isEmpty(year)||StringUtils.isEmpty(year)){
		year = cal.get(Calendar.YEAR)+"";
	}
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	PlantKPIService plantKPIService = (PlantKPIService) ctx.getBean("plantKPIService");
	
	List<PlantKPI> list = plantKPIService.queryKPIType();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/plant_kpi/js/kpi.js"></script>
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/js/etop5.js"></script>
</head>
<body>
	<div id="contentwrapper" class="contentwrapper">
		<script type="text/javascript">
		$(function(){
			$("#kpi_type").change(function(){
				kpi_month_inner();
			});
			kpi_month_inner();
		});
		function kpi_month_inner(){
			var year = $("#year").val();
			var kpi_type = $("#kpi_type").val();
			var _url = ctx+'/faurecia/ETOP5/plant_kpi/kpi_month_inner.jsp';
			var params = {};
			params['menu_id']=<%=menu_id%>;
			params['year']=year;
			params['kpi_type']=kpi_type;
			inner_html(_url,params,'contentwrapper #kpi_month_inner',function(data){
				$("#contentwrapper #kpi_month_inner").html(data);
			});
		}
		function click_kpi_load_day(year,_month,kpi_type){
			parent.showHtml(ctx+'/faurecia/ETOP5/plant_kpi/kpi_day.jsp?menu_id=<%=menu_id%>&year='+year+'&month='+_month+'&kpi_type='+kpi_type,'DAY',1024,550);
		}
		</script>
		<div class="widgetbox">
			<div class="title">
				<h4>
				<input style="width: 60px;height: 18px;" type="text" readonly="readonly" id="year" name="year" value="<%=year %>"  onclick="wdateYearInstance('year',function(){if($('#year').val().Trim()==''){return false;}kpi_month_inner();});"/>
				&nbsp;|&nbsp;
				<%if(list!=null&&!list.isEmpty()){
				%>
				<select style="height:24px;" name="kpi_type" id="kpi_type">
					<%
						for(PlantKPI p:list){
					%>
					<option value="<%=p.getKpi_type()%>"><%=p.getKpi_type()%></option>
					<%} %>
				</select>
				<script type="">
				$("#kpi_type option:first").prop("selected", 'selected');
				</script>
				&nbsp;|&nbsp;
				<%} %>
				[<a id="add_data" style="cursor:pointer;font-size:20px;" onclick="validateEtopPwd('${ctx}/faurecia/ETOP5/plant_kpi/data/plant_kpi_data_add.jsp?menu_id=<%=menu_id %>','KPI 数据添加');">&nbsp;+&nbsp;</a>]
				&nbsp;|&nbsp;
				<jsp:include page="/share/jsp/screen_full.jsp" />
				</h4>
			</div>
		</div>
		<div id="kpi_month_inner"></div>
	</div>
</body>
</html>
