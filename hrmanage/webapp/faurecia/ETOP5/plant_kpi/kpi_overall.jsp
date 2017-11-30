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
	
	List<PlantKPI> listDept = plantKPIService.queryKPIDept();
%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/plant_kpi/js/kpi.js"></script>
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/js/etop5.js"></script>
<script type="text/javascript">
	$(function(){
		kpi_overall_inner();
	});
	function kpi_overall_inner(){
		var kpi_date = $("#kpi_date").val();
		var _url = ctx+'/faurecia/ETOP5/plant_kpi/kpi_overall_inner.jsp';
		var params = {};
		params['kpi_date']=kpi_date;
		inner_html(_url,params,'kpi_overall',function(data){
			$("#kpi_overall").html(data);
		});
	}
</script>
</head>
<body>
	<table cellpadding='0' cellspacing='0' border='0' class='stdtable'>
		<thead>
			<tr>
				<th colspan='2' class="gradient">
					<div style="margin-left: 0px;margin-bottom:10px;" >
						<div class="one_hlaf">
							<div style="float: left">
								<h4><font style="color: <%=Global.colors[3]%>"><%=Global.plant_kpi_io[1]%></font></h4>
							</div>
						</div>		
						<div class="one_hlaf last">
							<div style="float: right">
								<h5>
								<input style="width: 80px;height: 18px;" type="text" readonly="readonly" id="kpi_date" name="kpi_date" value="<%=sdf.format(cal.getTime()) %>"  onfocus="wdateInstance2(function(){if($('#kpi_date').val().Trim()==''){return false;}kpi_overall_inner();});"/>
								&nbsp;|&nbsp;
								[<a id="add_data" style="cursor:pointer;font-size:20px;" onclick="validateEtopPwd('${ctx}/faurecia/ETOP5/plant_kpi/data/plant_kpi_data_add.jsp?menu_id=<%=menu_id %>','KPI 数据添加');">&nbsp;+&nbsp;</a>]
								&nbsp;|&nbsp;
								<jsp:include page="/share/jsp/screen_full_open.jsp" />
								</h5>
							</div>
						</div>
					</div>
					<div class="clearall"></div>
				</th>
			</tr>
		</thead>
		<tbody>
		<tr>
			<td>
				<div id="kpi_overall" style="margin-left: 0px;margin-right:0px;"></div>
			</td>
		</tr>
		</tbody>
	</table>
</body>
</html>
