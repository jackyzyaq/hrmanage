<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	Calendar cal = Calendar.getInstance();
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	GapKPIService gapKPIService = (GapKPIService) ctx.getBean("gapKPIService");
	//gapKPIService.findMaxDayofMonth(kpi_type, start_date, end_date);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/gap_kpi/js/kpi.js"></script>
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/js/etop5.js"></script>
<script type="text/javascript">
	$(function(){
		var height = window.screen.availHeight/6;
		var width = window.screen.availWidth/3-30;
		
		for(var i=1;i<=9;i++){
			$("#kpi_chart_view #td_"+i+" #kpi_month_data").css("width",width);
			$("#kpi_chart_view #td_"+i+" #kpi_month_data").css("height",height);
			$("#kpi_chart_view #td_"+i+" #kpi_day_data").css("width",width);
			$("#kpi_chart_view #td_"+i+" #kpi_day_data").css("height",height);
			$("#kpi_chart_view #td_"+i+" #kpi_day_data").css("margin-bottom",30);
			
			
			load_kpi_data_1('td_'+i+' #kpi_month_data','m');
			load_kpi_data_1('td_'+i+' #kpi_day_data','d');
		}
	});
</script>
</head>
<body>
	<table id="kpi_chart_view" cellpadding="0" cellspacing="0" border="0" class="stdtable" width="98%">
		<tr>
			<td id="td_1">
				<div class="widgetcontent" id="kpi_month_data" ></div>
				<div class="widgetcontent" id="kpi_day_data" ></div>
			</td>
			<td id="td_2">
				<div class="widgetcontent" id="kpi_month_data" ></div>
				<div class="widgetcontent" id="kpi_day_data" ></div>
			</td>
			<td id="td_3">
				<div class="widgetcontent" id="kpi_month_data" ></div>
				<div class="widgetcontent" id="kpi_day_data" ></div>
			</td>
		</tr>
		<tr>
			<td id="td_4">
				<div class="widgetcontent" id="kpi_month_data" ></div>
				<div class="widgetcontent" id="kpi_day_data" ></div></td>
			<td id="td_5">
				<div class="widgetcontent" id="kpi_month_data" ></div>
				<div class="widgetcontent" id="kpi_day_data" ></div></td>
			<td id="td_6">
				<div class="widgetcontent" id="kpi_month_data" ></div>
				<div class="widgetcontent" id="kpi_day_data" ></div>
			</td>
		</tr>
		<tr>
			<td id="td_7">
				<div class="widgetcontent" id="kpi_month_data" ></div>
				<div class="widgetcontent" id="kpi_day_data" ></div>
			</td>
			<td id="td_8">
				<div class="widgetcontent" id="kpi_month_data" ></div>
				<div class="widgetcontent" id="kpi_day_data" ></div>
			</td>
			<td id="td_9">
				<div class="widgetcontent" id="kpi_month_data" ></div>
				<div class="widgetcontent" id="kpi_day_data" ></div>
			</td>
		</tr>
	</table>
</body>
</html>