<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	int menu_id = Integer.valueOf(StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0"));
	Calendar cal = Calendar.getInstance();
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	PlantKPIService plantKPIService = (PlantKPIService) ctx.getBean("plantKPIService");
	
	String deptStr = "",kpiStr = "";
	List<PlantKPI> deptList = plantKPIService.queryKPIDept();
	if(deptList!=null&&!deptList.isEmpty()){
		for(PlantKPI pk : deptList){
			deptStr += pk.getDept_name()+"|";
		}
		deptStr.substring(0,deptStr.length()-1);
	}
	
	List<PlantKPI> kpiList = plantKPIService.queryKPIType();
	if(kpiList!=null&&!kpiList.isEmpty()){
		for(PlantKPI pk : kpiList){
			kpiStr += pk.getKpi_type()+"|";
		}
		kpiStr.substring(0,kpiStr.length()-1);
	}
%>
<form class="stdform" onSubmit="return false;">
<div class="widgetcontent padding0 statement">
	<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
	     <thead>
	         <tr>
	             <th class="head1" style="width: 10%"></th>
	             <th class="head1" style="width: 20%"></th>
	             <th class="head1" style="width: 10%"></th>
	             <th class="head1" style="width: 20%"></th>
	             <th class="head1" style="width: 10%"></th>
	             <th class="head1" style="width: 30%"></th>
	         </tr>
	     </thead>
	     <tbody>
			<tr>
				<td style="font-weight:bold" align="center">月份</td>
				<td>
					<input class="mediuminput" type="text" readonly="readonly" id="kpi_month" title="日期" name="kpi_month" value=""  onfocus="wdateYearMonthInstance('kpi_month');"/>
					<input type="hidden" name="title" id="title" class="mediuminput" title="标题" value="无"/>
				</td>
				<td style="font-weight:bold" align="center">部门</td>
				<td>
			    	<jsp:include page="/share/jsp/input_select.jsp">
			 			<jsp:param value="kpitarget" name="parent_div"/>
			 			<jsp:param value="dept_name" name="input_div"/>
			 			<jsp:param value="dept_name_select" name="select_div"/>
			 			<jsp:param value="<%=deptStr %>" name="data"/>
			 		</jsp:include>
				</td>
				<td style="font-weight:bold" align="center">类型</td>
				<td>
					<jsp:include page="/share/jsp/input_select.jsp">
			 			<jsp:param value="kpitarget" name="parent_div"/>
			 			<jsp:param value="kpi_type" name="input_div"/>
			 			<jsp:param value="kpi_type_select" name="select_div"/>
			 			<jsp:param value="<%=kpiStr %>" name="data"/>
			 		</jsp:include>
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold" align="center">INPUT/OUTPUT</td>
				<td>
					<select id="ext_1" name="ext_1" title="INPUT、OUTPUT">
						<option value="" selected>---请选择---</option>
						<option value="<%=Global.plant_kpi_io[0]%>"><%=Global.plant_kpi_io[0]%></option>
						<option value="<%=Global.plant_kpi_io[1]%>"><%=Global.plant_kpi_io[1]%></option>
					</select>
				</td>
				<td style="font-weight:bold" align="center">QCDP</td>
				<td>
					<select id="ext_2" name="ext_2" title="QCDP">
						<option value="" selected>---请选择---</option>
						<%for(String t:Global.plant_kpi_qcdp){ %>
						<option value="<%=t%>"><%=t%></option>
						<%} %>
					</select>
				</td>			
				<td style="font-weight:bold" align="center">TARGET</td>
				<td>
			    	<input type="text" name="target_start" id="target_start"  class="smallinput" title="TARGET" value="0"/>
			    	~
			    	<input type="text" name="target_end" id="target_end"  class="smallinput" title="TARGET" value="0"/>
				</td>
			</tr>
	         <tr>
	         	<td style="font-weight:bold" align="center">正反向</td>
				<td colspan="5">
					<input type="radio" name="ext_3" id="ext_3_1" value="正向" checked="checked"/> &nbsp;
					正向
					<input type="radio" name="ext_3" id="ext_3_2" value="反向" /> &nbsp;
					反向
					<div><strong>正向代表actual&nbsp;&gt;=&nbsp;target，绿脸；</strong></div>
					<div><strong>反向代表actual&nbsp;&lt;=&nbsp;target，绿脸；</strong></div>
				</td>
	         </tr>			
	         <tr>
	         	<td colspan="6">
		         	<div class="stdformbutton">
					<button id="plantKPISubmit" class="submit radius2">提交</button>
					</div>
	         	</td>
	         </tr>
	     </tbody>
	 </table>
</div><!--widgetcontent-->
</form>