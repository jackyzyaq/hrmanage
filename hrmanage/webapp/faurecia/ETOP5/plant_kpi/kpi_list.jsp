<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	Calendar cal = Calendar.getInstance();
	cal.add(Calendar.DAY_OF_MONTH, -1);
	
	
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	PlantKPIService plantKPIService = (PlantKPIService) ctx.getBean("plantKPIService");
	
	
	String ext_1 = request.getParameter("ext_1");
	String ext_2 = request.getParameter("ext_2");
	String kpi_month = request.getParameter("kpi_month");
	
	if(StringUtils.isEmpty(ext_1)||StringUtils.isEmpty(ext_2)||StringUtils.isEmpty(kpi_month)){
		return ;
	}
	String start_date = kpi_month+"-01";
	String end_date = kpi_month + "-"+Util.getMaxDay(Integer.parseInt(kpi_month.split("-")[0]), Integer.parseInt(kpi_month.split("-")[1]));
	List<PlantKPI> list = plantKPIService.findBy(start_date, end_date, ext_1, ext_2);
%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/plant_kpi/js/kpi.js"></script>
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/js/etop5.js"></script>
<script type="text/javascript">
	$(function(){
	});
</script>
</head>
<body>
	<table cellpadding='0' cellspacing='0' border='0' class='stdtable'>
		<thead>
			<tr>
				<th class="gradient">
					<div style="margin-left: 0px;margin-bottom:10px;" >
					Input\Output
					</div>
				</th>
				<th class="gradient">
					<div style="margin-left: 0px;margin-bottom:10px;" >
					Q/C/D/P
					</div>
				</th>
				<th class="gradient">
					<div style="margin-left: 0px;margin-bottom:10px;" >
					KPI
					</div>
				</th>
				<th class="gradient">
					<div style="margin-left: 0px;margin-bottom:10px;" >
					Department
					</div>
				</th>
			</tr>
		</thead>
		<tbody>
		<%if(list!=null&&!list.isEmpty()){ 
			for(PlantKPI pk:list){
		%>
		<tr style="cursor:pointer;" onclick="parent.setPlant_kpi_id('<%=StringUtils.defaultIfEmpty(pk.getExt_1(), "") %>','<%=StringUtils.defaultIfEmpty(pk.getExt_2(), "") %>','<%=StringUtils.defaultIfEmpty(pk.getKpi_type(), "") %>','<%=StringUtils.defaultIfEmpty(pk.getDept_name(), "-") %>');parent.jClose();">
			<td>
				<%=StringUtils.defaultIfEmpty(pk.getExt_2(), "-") %>
			</td>
			<td>
				<%=StringUtils.defaultIfEmpty(pk.getExt_1(), "-") %>
			</td>
			<td>
				<%=StringUtils.defaultIfEmpty(pk.getKpi_type(), "-") %>
			</td>
			<td>
				<%=StringUtils.defaultIfEmpty(pk.getDept_name(), "-") %>
			</td>
		</tr>
		<%}}%>
		</tbody>
	</table>
</body>
</html>
