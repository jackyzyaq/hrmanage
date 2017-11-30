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
	
	Map<Integer,Object> monthData = Util.getMonthObject(null);
	for(Integer month:monthData.keySet()){
		monthData.put(month, departmentKPIService.queryByType(sdf2.parse(year+"-"+month+"-"+Util.getMaxDay(Integer.parseInt(year), month)), kpi_type, dept_name, ext_1, ext_2));
	}
%>
<script type="text/javascript">
var month_target = [],month_actual = [],month_unactual = [];
<%
double pri_cum_month = 0;
Integer target_flag = null;
String month_target= "",month_actual="",months="",month_cum="",unit = "",ext_3 = "";
for(Integer month : monthData.keySet()){
	Object obj = monthData.get(month);
	double target_v=0;
	DepartmentKPI p = null;
	if(obj instanceof DepartmentKPI){
		p = (DepartmentKPI)obj;
		target_v = (p==null||p.getTarget()==null?0:Util.formatDouble1(p.getTarget()));
		if(month>=nowMonth){
			p=null;
		}
	}
	if(p==null){
		ext_3 = "";
		target_flag = null;
	}else{
		unit = (p.getExt_8());
		ext_3 = (p.getExt_3());
		target_flag = p.getTarget_flag();
	}
	month_target += (target_v)+",";
	month_actual += ((p==null)?0:p.getCum())+",";
	
	
	double d = 0;
	String a = ((p==null)?0:p.getCum())+"";
	if(month.intValue()<nowMonth){
		d = Util.formatDouble1(Double.valueOf(a));
		if(month.intValue()>0){//不是第一个月
			double now_month = Util.formatDouble1(Double.valueOf(a));
			d = pri_cum_month+now_month;
			if(unit.equals("%")){
				d = Util.formatDouble1(Double.valueOf(((d)/(month))+""));
			}
		}
		pri_cum_month += Util.formatDouble1(Double.valueOf(a));
	}
	
	month_cum += (d)+",";
	months += (month)+",";
	
	String health = "";
    double actual= ((p==null)?0:p.getCum());
    double cum = d;
    if(ext_3.equals("正向")){
		if((actual)>=(target_v)){
			health = (request.getContextPath()+"/images/"+Global.department_kpi_health[0]+".png");
		}else{
			health = (request.getContextPath()+"/images/"+Global.department_kpi_health[1]+".png");
		}
	}else if(ext_3.equals("反向")){
		if((actual)<=(target_v)){
			health = (request.getContextPath()+"/images/"+Global.department_kpi_health[0]+".png");
		}else{
			health = (request.getContextPath()+"/images/"+Global.department_kpi_health[1]+".png");
		}
	}	
	
	
	if(health.indexOf(Global.department_kpi_health[0])>-1){
		out.print("month_actual.push(["+month+", "+(p==null?"null":p.getCum())+"]),");
		out.print("month_unactual.push(["+month+", null]),");
	}else if(health.indexOf(Global.department_kpi_health[1])>-1){
		out.print("month_actual.push(["+month+", null]),");
		out.print("month_unactual.push(["+month+", "+(p==null?"null":p.getCum())+"]),");
	}else{
	}	
%>
month_target.push([<%=month%>, <%=(target_v)%>]);
<%
}
month_target = month_target.substring(0,month_target.length()-1);
month_actual = month_actual.substring(0,month_actual.length()-1);
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
		                                    <%
		                                    //CUM把名字改成Actual 要求的
		                                    for(String a:month_actual.split(",")){ 
		                                    double d = Util.formatDouble1(Double.valueOf(a));
		                                    %>
		                                    <td class="center"><%=(d+(unit.equals("%")?"%":"")) %></td>
		                                    <%} %>
		                                </tr>
		                                 <tr>
		                                    <td>Cum</td>
		                                    <%
		                                    for(String a:month_cum.split(",")){ 
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