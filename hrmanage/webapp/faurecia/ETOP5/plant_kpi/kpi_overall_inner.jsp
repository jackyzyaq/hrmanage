<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String kpi_date = StringUtils.defaultIfEmpty(request.getParameter("kpi_date"), "");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	if(StringUtils.isEmpty(kpi_date)){
		return ;
	}
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	PlantKPIService plantKPIService = (PlantKPIService) ctx.getBean("plantKPIService");
	
	String ext_1 = Global.plant_kpi_io[1];
	
%>
<script type="text/javascript" src="${ctx }/share/js/circle.js"></script>
<script type="text/javascript">
function detail(obj){
	if(typeof(obj.id) != "undefined"&&obj.id.length>0){
		var kpi_data = obj.id.split('|');
		var params = ("ext_2:"+kpi_data[1]+"|kpi_type:"+kpi_data[2]+"|dept_name:"+kpi_data[3]+"|kpi_date:"+kpi_data[4]+"|color:"+kpi_data[5]+"|ext_2_name:"+kpi_data[6]).replace('#','%23');
		if(kpi_data[0]=='<%=Global.plant_kpi_io[0]%>'){
			click_href('${ctx}/faurecia/ETOP5/plant_kpi/kpi_index.jsp?ext_1=<%=Global.plant_kpi_io[0]%>&params='+params);
		}else if(kpi_data[0]=='<%=Global.plant_kpi_io[1]%>'){
			click_href('${ctx}/faurecia/ETOP5/plant_kpi/kpi_index.jsp?ext_1=<%=Global.plant_kpi_io[1]%>&params='+params);
		}
	}
}
</script>
<div style="margin-top:0px;">
	<div class="one_fourth">
		<jsp:include page="/faurecia/ETOP5/plant_kpi/kpi_overall_inner_output.jsp">
			<jsp:param value="<%=ext_1 %>" name="ext_1"/>
			<jsp:param value="<%=Global.plant_kpi_qcdp[0] %>" name="ext_2"/>
			<jsp:param value="<%=Global.plant_kpi_qcdp_name[0] %>" name="ext_2_name"/>
			<jsp:param value="<%=kpi_date %>" name="kpi_date"/>
			<jsp:param value="#FFFF6F" name="background"/>
		</jsp:include>
	</div><!--one_half-->
	<div class="one_fourth">
		<jsp:include page="/faurecia/ETOP5/plant_kpi/kpi_overall_inner_output.jsp">
			<jsp:param value="<%=ext_1 %>" name="ext_1"/>
			<jsp:param value="<%=Global.plant_kpi_qcdp[1] %>" name="ext_2"/>
			<jsp:param value="<%=Global.plant_kpi_qcdp_name[1] %>" name="ext_2_name"/>
			<jsp:param value="<%=kpi_date %>" name="kpi_date"/>
			<jsp:param value="#C2FF68" name="background"/>
		</jsp:include>
	</div><!--one_half-->
	<div class="one_fourth">
		<jsp:include page="/faurecia/ETOP5/plant_kpi/kpi_overall_inner_output.jsp">
			<jsp:param value="<%=ext_1 %>" name="ext_1"/>
			<jsp:param value="<%=Global.plant_kpi_qcdp[3] %>" name="ext_2"/>
			<jsp:param value="<%=Global.plant_kpi_qcdp_name[3] %>" name="ext_2_name"/>
			<jsp:param value="<%=kpi_date %>" name="kpi_date"/>
			<jsp:param value="#CA8EFF" name="background"/>
		</jsp:include>
	</div>
	<div class="one_fourth last">
		<jsp:include page="/faurecia/ETOP5/plant_kpi/kpi_overall_inner_output.jsp">
			<jsp:param value="<%=ext_1 %>" name="ext_1"/>
			<jsp:param value="<%=Global.plant_kpi_qcdp[4] %>" name="ext_2"/>
			<jsp:param value="<%=Global.plant_kpi_qcdp_name[4] %>" name="ext_2_name"/>
			<jsp:param value="<%=kpi_date %>" name="kpi_date"/>
			<jsp:param value="#81C0C0" name="background"/>
		</jsp:include>
	</div>	
</div>