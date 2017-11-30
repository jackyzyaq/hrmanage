<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String year = StringUtils.defaultIfEmpty(request.getParameter("year"), "");
	String month = StringUtils.defaultIfEmpty(request.getParameter("month"), "");
	String kpi_type = StringUtils.defaultIfEmpty(request.getParameter("kpi_type"), "");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	SimpleDateFormat sdf1 = new SimpleDateFormat(Global.DATE_FORMAT_STR_D);
	Calendar cal = Calendar.getInstance();
	if(StringUtils.isEmpty(year)){
		year = cal.get(Calendar.YEAR)+"";
	}
	if(StringUtils.isEmpty(month)){
		month = cal.get(Calendar.MONTH)+1+"";
	}
	if(StringUtils.isEmpty(kpi_type)){
		return ;
	}
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	PlantKPIService plantKPIService = (PlantKPIService) ctx.getBean("plantKPIService");
	PlantKPI plantKPI = new PlantKPI();
	plantKPI.setKpi_type(kpi_type);
	plantKPI.setStart_date(year+"-"+month+"-01");
	plantKPI.setOver_date(year+"-"+month+"-"+Util.getMaxDay(Integer.valueOf(year),Integer.valueOf(month)));
	PlantKPI plantKpi = plantKPIService.findMaxDayofMonth(plantKPI);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/plant_kpi/js/kpi.js"></script>
</head>
<body>
	<div id="contentwrapper" class="contentwrapper">
		<script type="text/javascript">
		$(function(){
			kpi_day_inner(ctx+'/faurecia/ETOP5/plant_kpi/kpi_day_inner.jsp');
		});
		function kpi_day_inner(_url){
			var params = {};
			params['menu_id']=<%=menu_id%>;
			params['year']=<%=year%>;
			params['month']=<%=month%>;
			params['kpi_type']='<%=kpi_type%>'
			inner_html(_url,params,'contentwrapper #kpi_day_inner',function(data){
				$("#contentwrapper #kpi_day_inner").html(data);
			});
		}
		</script>
		<%if(plantKpi!=null){ %>
		<div><img src="${ctx }<%=plantKpi.getHealth_png() %>" style="padding: 5px;margin-left: 15px;"/></div>
		<%} %>
		<div id="kpi_day_inner"></div>
	</div>
</body>
</html>
