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
	SimpleDateFormat sdf2 = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
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
	DepartmentKPIService departmentKPIService = (DepartmentKPIService) ctx.getBean("departmentKPIService");
	
	DepartmentKPI departmentKPI = new DepartmentKPI();
	departmentKPI.setKpi_type(kpi_type);
	departmentKPI.setStart_date(year+"-01-01");
	departmentKPI.setOver_date(year+"-12-31");
	departmentKPI.setExt_1(ext_1);
	departmentKPI.setExt_2(ext_2);
	departmentKPI.setDept_name(dept_name);
	List<DepartmentKPI> list = departmentKPIService.findMonthByCondition(departmentKPI);
	Map<Integer,Object> monthData = Util.getMonthObject(null);
	if(list!=null&&!list.isEmpty()){
		for(DepartmentKPI p:list){
			if(monthData.containsKey(p.getMonth())){
				monthData.put(p.getMonth(), p);
			}
		}
	}
%>
<script type="text/javascript">
var month_target = [],month_actual = [],month_unactual = [];
<%
String month_target= "",month_actual="",month_unactual="",months="",month_cum="",unit = "",ext_3 = "",target_flag="";
for(Integer month : monthData.keySet()){
	DepartmentKPI ptmp = departmentKPIService.queryByType(sdf2.parse(year+"-"+(month)+"-01"), kpi_type, dept_name, ext_1, ext_2);
	if(ptmp==null){
		target_flag = "-";
	}else{
		unit = (ptmp.getExt_8());
		ext_3 = StringUtils.defaultIfEmpty(ptmp.getExt_3(), "");
		target_flag = (ptmp.getTarget_flag()==null?"-":ptmp.getTarget_flag().toString());
	}
	Object obj = monthData.get(month);
	DepartmentKPI p = null;
	if(obj instanceof DepartmentKPI){
		if(month<nowMonth){
			p = (DepartmentKPI)obj;
		}else{
			p = null;
		}
	}
	month_target += ((p==null)?0:p.getTarget())+",";
	month_actual += ((p==null)?0:p.getActual())+",";
	month_unactual += ((p==null)?0:p.getCum())+",";
	month_cum += ((p==null)?0:p.getCum())+",";
	months += (month)+",";
	
	String health = "-";
	if(ext_3.equals("正向")){
		if((target_flag.equals("1")?((p==null)?0:p.getCum()):((p==null)?0:p.getActual()))>=((p==null)?0:p.getTarget())){
			health = (request.getContextPath()+"/images/"+Global.department_kpi_health[0]+".png");
		}else{
			health = (request.getContextPath()+"/images/"+Global.department_kpi_health[1]+".png");
		}
	}else if(ext_3.equals("反向")){
		if((target_flag.equals("1")?((p==null)?0:p.getCum()):((p==null)?0:p.getActual()))<=((p==null)?0:p.getTarget())){
			health = (request.getContextPath()+"/images/"+Global.department_kpi_health[0]+".png");
		}else{
			health = (request.getContextPath()+"/images/"+Global.department_kpi_health[1]+".png");
		}
	}
	if(health.indexOf(Global.department_kpi_health[0])>-1){
		if(target_flag.equals("0")){
			out.print("month_actual.push(["+month+", "+(p==null?"null":p.getActual())+"]),");
		}else if(target_flag.equals("1")){
			out.print("month_actual.push(["+month+", "+(p==null?"null":p.getCum())+"]),");
		}
		out.print("month_unactual.push(["+month+", null]),");
	}else if(health.indexOf(Global.department_kpi_health[1])>-1){
		out.print("month_actual.push(["+month+", null]),");
		if(target_flag.equals("0")){
			out.print("month_unactual.push(["+month+", "+(p==null?"null":p.getActual())+"]),");
		}else if(target_flag.equals("1")){
			out.print("month_unactual.push(["+month+", "+(p==null?"null":p.getCum())+"]),");
		}
	}else{
	}	
%>
month_target.push([<%=month%>, <%=(p==null)?"null":p.getTarget()%>]);
<%
}
month_target = month_target.substring(0,month_target.length()-1);
month_actual = month_actual.substring(0,month_actual.length()-1);
month_unactual = month_unactual.substring(0,month_unactual.length()-1);
month_cum = month_cum.substring(0,month_cum.length()-1);
months = months.substring(0,months.length()-1);
%>
</script>
<ul id="kpi_month_table" class="toplist">
	<li>
		<div>
		<table id="kpi_month_table" cellpadding='0' cellspacing='0' border='0' class='stdtable'><thead><tr><th colspan='2'  class="gradient"><font style="font-size:16px;color: <%=Global.colors[3]%>">
			<%=dept_name+"-"+kpi_type %>
		</font></th></tr></thead>
			<tbody>
		</tbody>
		</table>
		</div>
		<div style="height:24px;margin: 5px 0px 0px 5px;"></div>		
			<div class="widgetbox">
				<div style="margin:5px;">
					<div id="kpi_month_data"></div>		
				</div>
			</div>
			<div class="widgetbox" style="overflow:auto;overflow-x:scroll !important;">
				<div style="margin:5px;">
					<div>
						<div>
							<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
								<colgroup>
									<col class="con0" />
									<col class="con0" />
									<col class="con0" />
									<col class="con0" />
									<col class="con0" />
									<col class="con0" />
									<col class="con0" />
									<col class="con0" />
									<col class="con0" />
									<col class="con0" />
									<col class="con0" />
									<col class="con0" />
									<col class="con0" />
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
		                                    double d = Util.formatDouble1(Double.valueOf(t));
		                                    %>
		                                    <td class="center"><%=(d+(unit.equals("%")?"%":"")) %></td>
		                                    <%} %>
		                                </tr>
		                                 <tr>
		                                    <td>Actual</td>
		                                    <%for(String a:month_actual.split(",")){ 
		                                    double d = Util.formatDouble1(Double.valueOf(a));
		                                    %>
		                                    <td class="center"><%=(d+(unit.equals("%")?"%":"")) %></td>
		                                    <%} %>
		                                </tr>
		                                <tr>
		                                    <td>Cum</td>
		                                    <%for(String a:month_cum.split(",")){ 
		                                    double d = Util.formatDouble1(Double.valueOf(a));
		                                    %>
		                                    <td class="center"><%=(d+(unit.equals("%")?"%":"")) %></td>
		                                    <%} %>
		                                </tr>
		                       	</tbody>
		                	</table>
						</div><!--widgetcontent-->	
					</div><!--widgetbox-->			
				</div>
			</div>		
	</li>
</ul>                           
<script type="text/javascript">
$("#kpi_month_table").css("width",(parseInt($("#kpi_month_inner").css('width').replace('px',''))-7)+"px");
$("#kpi_month_data").css("height",window.screen.availHeight/2-60);
load_kpi_data('kpi_month_data','m',month_target,month_actual,month_unactual,'',new Array("<%=Global.colors[0]%>","<%=Global.colors[1]%>","<%=Global.colors[2]%>"),'<%=(unit.equals("%")?"%":"")%>');
</script>