<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String ext_1 = null,dept_name = null,ext_2 = StringUtils.defaultIfEmpty(request.getParameter("ext_2"), "");
	if(StringUtils.isEmpty(request.getParameter("ext_1"))||
		StringUtils.isEmpty(request.getParameter("dept_name"))){
		return ;
	}else{
		ext_1 = request.getParameter("ext_1");
		dept_name = request.getParameter("dept_name");
	}
	String year = StringUtils.defaultIfEmpty(request.getParameter("year"), "");
	String kpi_type = StringUtils.defaultIfEmpty(request.getParameter("kpi_type"), "");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	SimpleDateFormat sdf1 = new SimpleDateFormat(Global.DATE_FORMAT_STR_D);
	Calendar cal = Calendar.getInstance();
	int nowMonth = cal.get(Calendar.MONTH)+1;
	if(StringUtils.isEmpty(year)){
		year = String.valueOf(cal.get(Calendar.YEAR));
	}
	if(StringUtils.isEmpty(kpi_type)){
		return ;
	}
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	PlantKPIService plantKPIService = (PlantKPIService) ctx.getBean("plantKPIService");
	
	PlantKPI plantKPI = new PlantKPI();
	plantKPI.setKpi_type(kpi_type);
	plantKPI.setStart_date(year+"-01-01");
	plantKPI.setOver_date(year+"-12-31");
	plantKPI.setExt_1(ext_1);
	plantKPI.setExt_2(ext_2);
	plantKPI.setDept_name(dept_name);
	List<PlantKPI> list = plantKPIService.findMonthByCondition(plantKPI);
	Map<Integer,Object> monthData = Util.getMonthObject(null);
	if(list!=null&&!list.isEmpty()){
		for(PlantKPI p:list){
			if(monthData.containsKey(p.getMonth())){
				monthData.put(p.getMonth(), p);
			}
		}
	}
%>
<script type="text/javascript">
var month_target = [],month_actual = [],month_unactual = [];
<%
String month_target= "",month_actual="",month_unactual="",months="";
for(Integer month : monthData.keySet()){ 
	Object obj = monthData.get(month);
	PlantKPI p = null;
	if(obj instanceof PlantKPI){
		p = (PlantKPI)obj;
	}
	month_target += ((p==null)?0:p.getTarget())+",";
	month_actual += ((p==null)?0:p.getActual())+",";
	month_unactual += ((p==null)?0:p.getCum())+",";
	months += (month)+",";
	
	if(month<=nowMonth){
%>
<%
		if(p==null||StringUtils.isEmpty(p.getHealth_png())||p.getHealth_png().equals("-")){
			//out.print("month_actual.push(["+month+", 0]),");
			//out.print("month_unactual.push(["+month+", 0]),");
		}else{
			if(p.getHealth_png().indexOf(Global.plant_kpi_health[0])>-1){
				out.print("month_actual.push(["+month+", "+p.getActual()+"]),");
				out.print("month_unactual.push(["+month+", null]),");
			}else if(p.getHealth_png().indexOf(Global.plant_kpi_health[1])>-1){
				out.print("month_actual.push(["+month+", null]),");
				out.print("month_unactual.push(["+month+", "+p.getActual()+"]),");
			}else{
				//out.print("month_actual.push(["+month+", 0]),");
				//out.print("month_unactual.push(["+month+", 0]),");
			}
		}
%>
month_target.push([<%=month%>, <%=(p==null)?0:p.getTarget()%>]);
<%	}
}
month_target = month_target.substring(0,month_target.length()-1);
month_actual = month_actual.substring(0,month_actual.length()-1);
month_unactual = month_unactual.substring(0,month_unactual.length()-1);
months = months.substring(0,months.length()-1);
%>
</script>
		<div style="margin-top:5px;">
			<div>
				<div id="kpi_month_data"></div>
				<div style="margin-top:5px;overflow:auto;overflow-x:true;">
					<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
						<colgroup>
							<col class="con0" width="4%" />
							<col class="con0" width="8%" />
							<col class="con0" width="8%" />
							<col class="con0" width="8%" />
							<col class="con0" width="8%" />
							<col class="con0" width="8%" />
							<col class="con0" width="8%" />
							<col class="con0" width="8%" />
							<col class="con0" width="8%" />
							<col class="con0" width="8%" />
							<col class="con0" width="8%" />
							<col class="con0" width="8%" />
							<col class="con0" width="8%" />
						</colgroup>
						<thead>																									
                                <tr>
                                    <th class="head0">Month</th>
                                    <th class="head0"><a style="cursor:pointer" onclick="kpi_day_inner(<%=year%>,1,'<%=kpi_type%>');">Jan</a></th>
                                    <th class="head0"><a style="cursor:pointer" onclick="kpi_day_inner(<%=year%>,2,'<%=kpi_type%>');">Feb</a></th>
                                    <th class="head0"><a style="cursor:pointer" onclick="kpi_day_inner(<%=year%>,3,'<%=kpi_type%>');">Mar</a></th>
                                    <th class="head0"><a style="cursor:pointer" onclick="kpi_day_inner(<%=year%>,4,'<%=kpi_type%>');">Apr</a></th>
                                    <th class="head0"><a style="cursor:pointer" onclick="kpi_day_inner(<%=year%>,5,'<%=kpi_type%>');">May</a></th>
                                    <th class="head0"><a style="cursor:pointer" onclick="kpi_day_inner(<%=year%>,6,'<%=kpi_type%>');">Jun</a></th>
                                    <th class="head0"><a style="cursor:pointer" onclick="kpi_day_inner(<%=year%>,7,'<%=kpi_type%>');">Jul</a></th>
                                    <th class="head0"><a style="cursor:pointer" onclick="kpi_day_inner(<%=year%>,8,'<%=kpi_type%>');">Aug</a></th>
                                    <th class="head0"><a style="cursor:pointer" onclick="kpi_day_inner(<%=year%>,9,'<%=kpi_type%>');">Sep</a></th>
                                    <th class="head0"><a style="cursor:pointer" onclick="kpi_day_inner(<%=year%>,10,'<%=kpi_type%>');">Oct</a></th>
                                    <th class="head0"><a style="cursor:pointer" onclick="kpi_day_inner(<%=year%>,11,'<%=kpi_type%>');">Nov</a></th>
                                    <th class="head0"><a style="cursor:pointer" onclick="kpi_day_inner(<%=year%>,12,'<%=kpi_type%>');">Dec</a></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>Target</td>
                                    <%for(String t:month_target.split(",")){ 
                                    %>
                                    <td class="center"><%=Util.formatDouble1(Double.valueOf(t)) %></td>
                                    <%} %>
                                </tr>
                                 <tr>
                                    <td>Actual</td>
                                    <%for(String a:month_actual.split(",")){ 
                                    %>
                                    <td class="center"><%=Util.formatDouble1(Double.valueOf(a)) %></td>
                                    <%} %>
                                </tr>
                            </tbody>
                        </table>
				</div><!--widgetcontent-->	
			</div><!--widgetbox-->			
		</div>
<script type="text/javascript">
var height = window.screen.availHeight/4-60;
$("#kpi_month_data").css("height",height);
load_kpi_data('kpi_month_data','m',month_target,month_actual,month_unactual);
</script>