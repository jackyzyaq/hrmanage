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
	
	//查询所有部门
	List<PlantKPI> deptList = plantKPIService.queryKPIDept();
	if(deptList==null||deptList.isEmpty()){
		return ;
	}
	int deptCount = deptList.size();
	
	//198 input
	//199 output
	int input198 = 198;
	int output199 = 199;
	MenuInfo input198Parent = Global.menuInfoMap.get(Integer.parseInt(Util.getMenuAllIdsById(input198,Global.menuInfoMap).split(",")[0]));
	MenuInfo output199Parent = Global.menuInfoMap.get(Integer.parseInt(Util.getMenuAllIdsById(output199,Global.menuInfoMap).split(",")[0]));
%>
<script type="text/javascript">
function detail(obj){
	if(typeof(obj.id) != "undefined"&&obj.id.length>0){
		var kpi_data = obj.id.split('|');
		var params = "ext_2:"+kpi_data[1]+"|kpi_type:"+kpi_data[2]+"|dept_name:"+kpi_data[3]+"|kpi_date:"+kpi_data[4];
		if(kpi_data[0]=='<%=Global.plant_kpi_io[0]%>'){
			jumpLabelPage('<%=input198Parent.getUrl()+"?ext_1="+Global.plant_kpi_io[0]%>','<%=input198Parent.getId()%>','<%=input198%>',params);
		}else if(kpi_data[0]=='<%=Global.plant_kpi_io[1]%>'){
			jumpLabelPage('<%=output199Parent.getUrl()+"?ext_1="+Global.plant_kpi_io[1]%>','<%=output199Parent.getId()%>','<%=output199%>',params);
		}
	}
}
</script>
<div style="margin-top:5px;">
	<div>
		<div id="kpi_month_data"></div>
		<div style="margin-top:5px;overflow:auto;overflow-x:true;">
			<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
				<thead>
					<tr>
						<th class="head0" style="width:3%"></th>
						<%
							int width = 97/deptList.size();
							int mod = 97%deptList.size();
							for (int i=0;i<deptList.size();i++) {
								PlantKPI pk = deptList.get(i);
								if(i==deptList.size()-1)
									width = width+mod;
						%>
						<th class="head0" style="width:<%=width%>%"><%=StringUtils.defaultIfEmpty(pk.getDept_name(), "")%></th>
						<%
							}
						%>
					</tr>
				</thead>
				<tbody>
					<%
						PlantKPI pKPI = new PlantKPI();
						for(String ext_2:Global.plant_kpi_qcdp){
					%>				
					<tr>
						<td><%=StringUtils.defaultIfEmpty(ext_2, "")%></td>
						<%
							for (PlantKPI dpk : deptList) {
								pKPI.setKpi_date(sdf.parse(kpi_date));
								pKPI.setDept_name(dpk.getDept_name());
								pKPI.setExt_2(ext_2);
								List<PlantKPI> list = plantKPIService.findByCondition(pKPI, null);
						%>
						<td valign="top" style="vertical-align: top;">
							<%
							out.print("<table cellpadding='0' cellspacing='0' border='0' class='stdtable'><thead><tr><th class='head0'></th><th class='head0'></th></tr></thead><tbody>");
							if(list!=null&&!list.isEmpty()){
								for(PlantKPI pk:list){
									String kpi_type = StringUtils.defaultIfEmpty(pk.getKpi_type(), "");
								String kpi_data = (""+pk.getExt_1()+"|"+pk.getExt_2()+"|"+kpi_type+"|"+pk.getDept_name()+"|"+sdf.format(pk.getKpi_date())+"");
								out.print("<tr id='"+kpi_data+"' onclick='detail(this);' style='cursor:pointer;'>");
								out.print("<td title='"+kpi_type+"' style='width:70%'>"+(kpi_type)+"</td>");
								out.print("<td style='width:30%'>"+(pk==null||StringUtils.isEmpty(pk.getHealth_png())||pk.getHealth_png().equals("-")?
											"N/A":"<img src='"+pk.getHealth_png())+"'</td>");
								out.print("</tr>");
								}
							}else{
								out.print("<tr><td colspan='2'>N/A</td></tr>");
							}
							out.print("</tbody></table>");%>
						</td>
						<%
							}
						%>
					</tr>			
					<%				
						}
					%>
				</tbody>
			</table>
		</div>
		<!--widgetcontent-->
	</div>
	<!--widgetbox-->
</div>