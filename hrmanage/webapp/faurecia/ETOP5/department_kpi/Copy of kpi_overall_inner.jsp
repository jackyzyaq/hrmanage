<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String kpi_date = StringUtils.defaultIfEmpty(request.getParameter("kpi_date"), "");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	if(StringUtils.isEmpty(kpi_date)){
		return ;
	}
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	DepartmentKPIService departmentKPIService = (DepartmentKPIService) ctx.getBean("departmentKPIService");
	
	Map<String,List<DepartmentKPI>> qcdpMap = new HashMap<String,List<DepartmentKPI>>();
	for(String ext_2:Global.department_kpi_qcdp){
		//qcdpMap.put(ext_2, departmentKPIService.queryKPITypeByQCDP(ext_2));
	}
	//查询所有部门
	List<DepartmentKPI> deptList = departmentKPIService.queryKPIDept();
	if(deptList==null||deptList.isEmpty()||qcdpMap==null||qcdpMap.isEmpty()){
		return ;
	}
	int deptCount = deptList.size();
%>
<script type="text/javascript">
	
</script>
<div style="margin-top:5px;">
	<div>
		<div id="kpi_month_data"></div>
		<div style="margin-top:5px;overflow:auto;overflow-x:true;">
			<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
				<thead>
					<tr>
						<th class="head0"></th>
						<th class="head0"></th>
						<%
							for (DepartmentKPI pk : deptList) {
						%>
						<th class="head0"><%=StringUtils.defaultIfEmpty(pk.getDept_name(), "")%></th>
						<%
							}
						%>
					</tr>
				</thead>
				<tbody>
					<%
						for (String ext_2:qcdpMap.keySet()) {
							List<DepartmentKPI> pkList = qcdpMap.get(ext_2);
							int row = 0;
							if(pkList!=null&&!pkList.isEmpty()){
								row = pkList.size();
								for(int i=0;i<row;i++){
									String kpi_type = pkList.get(i).getKpi_type();
									DepartmentKPI pk = null;
					%>				
					<tr>
						<%if(i==0){ %>
						<td rowspan="<%=row%>"><%=ext_2 %></td>
						<%} %>
						<td><%=StringUtils.defaultIfEmpty(kpi_type, "")%></td>
						<%
							for (DepartmentKPI dpk : deptList) {
								pk = departmentKPIService.queryByType(
											sdf.parse(kpi_date), 
											StringUtils.defaultIfEmpty(kpi_type, ""), 
											dpk.getDept_name(), 
											null);
						%>
						<td><%=pk==null||StringUtils.isEmpty(pk.getHealth_png())||pk.getHealth_png().equals("-")?"N/A":"<img src='"+pk.getHealth_png()+"'/>"%></td>
						<%
							}
						%>
					</tr>			
					<%				
								}
							}
						}
					%>
				</tbody>
			</table>
		</div>
		<!--widgetcontent-->
	</div>
	<!--widgetbox-->
</div>