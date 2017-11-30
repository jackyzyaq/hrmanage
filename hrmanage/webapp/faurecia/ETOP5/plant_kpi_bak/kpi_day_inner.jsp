<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	PlantKPIService plantKPIService = (PlantKPIService) ctx.getBean("plantKPIService");
	String ext_1 = null,dept_name = null,ext_2 = StringUtils.defaultIfEmpty(request.getParameter("ext_2"), "");
	if(StringUtils.isEmpty(request.getParameter("ext_1"))||
		StringUtils.isEmpty(request.getParameter("dept_name"))){
		return ;
	}else{
		ext_1 = request.getParameter("ext_1");
		dept_name = request.getParameter("dept_name");
	}
	String kpi_date = StringUtils.defaultIfEmpty(request.getParameter("kpi_date"), "");
	String kpi_type = StringUtils.defaultIfEmpty(request.getParameter("kpi_type"), "");
	
	String year = StringUtils.defaultIfEmpty(request.getParameter("year"), "");
	String month = StringUtils.defaultIfEmpty(request.getParameter("month"), "");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	Calendar cal = Calendar.getInstance();
	Date now = sdf.parse(sdf.format(cal.getTime()));
	if(StringUtils.isEmpty(year)){
		year = cal.get(Calendar.YEAR)+"";
	}
	if(StringUtils.isEmpty(month)){
		month = cal.get(Calendar.MONTH)+1+"";
	}
	PlantKPI plantKpi = null;
	if(StringUtils.isEmpty(kpi_date)){
		plantKpi = plantKPIService.findMaxDayofMonth(kpi_type,year+"-"+month+"-01",year+"-"+month+"-"+Util.getMaxDay(Integer.valueOf(year),Integer.valueOf(month)),dept_name,ext_1,ext_2);
		if(plantKpi!=null){
			kpi_date = sdf.format(plantKpi.getKpi_date());
		}else{
			kpi_date = year+"-"+month+"-01";
		}
	}else{
		plantKpi = plantKPIService.queryByType(sdf.parse(kpi_date), kpi_type, dept_name, ext_1);
	}
	if(StringUtils.isEmpty(kpi_type)){
		return ;
	}
	
	PlantKPI plantKPI = new PlantKPI();
	plantKPI.setKpi_type(kpi_type);
	plantKPI.setStart_date(year+"-"+month+"-01");
	plantKPI.setOver_date(year+"-"+month+"-"+Util.getMaxDay(Integer.valueOf(year),Integer.valueOf(month)));
	plantKPI.setExt_1(ext_1);
	plantKPI.setExt_2(ext_2);
	plantKPI.setDept_name(dept_name);
	List<PlantKPI> list = plantKPIService.findByCondition(plantKPI,null);
	Map<Integer,Object> dayData = Util.getDayObject(null,sdf.parse(kpi_date));
	if(list!=null&&!list.isEmpty()){
		for(PlantKPI p:list){
			if(dayData.containsKey(p.getDay())){
				dayData.put(p.getDay(), p);
			}
		}
	}
	
%>
<script type="text/javascript">
var target = [],actual = [],unactual = [];
var remark = {};
<%
String target= "",actual="",unactual="",days="";
for(Integer day : dayData.keySet()){ 
	Object obj = dayData.get(day);
	PlantKPI p = null;
	if(obj instanceof PlantKPI){
		p = (PlantKPI)obj;
	}
	target += ((p==null)?0:p.getTarget())+",";
	actual += ((p==null)?0:p.getActual())+",";
	unactual += ((p==null)?0:p.getCum())+",";
	days += (day)+",";
%>
target.push([<%=day%>, <%=(p==null)?0:p.getTarget()%>]),
<%
if(p!=null&&p.getKpi_date().getTime()<now.getTime()){
	if(StringUtils.isEmpty(p.getHealth_png())||p.getHealth_png().equals("-")){
		//out.print("actual.push(["+day+", 0]),");
		//out.print("unactual.push(["+day+", 0]),");
	}else{
		if(p.getHealth_png().indexOf(Global.plant_kpi_health[0])>-1){
			out.print("actual.push(["+day+", "+p.getActual()+"]),");
			out.print("unactual.push(["+day+", null]),");
		}else if(p.getHealth_png().indexOf(Global.plant_kpi_health[1])>-1){
			out.print("actual.push(["+day+", null]),");
			out.print("unactual.push(["+day+", "+p.getActual()+"]),");
		}else{
			//out.print("actual.push(["+day+", 0]),");
			//out.print("unactual.push(["+day+", 0]),");
		}
	}
}
%>
remark['<%=day%>'] =  '<%=(p==null)?"":StringUtils.defaultIfEmpty(p.getRemark(), "").replace("\r", "").replace("\n", "")%>';
<%}
target = target.substring(0,target.length()-1);
actual = actual.substring(0,actual.length()-1);
unactual = unactual.substring(0,unactual.length()-1);
days = days.substring(0,days.length()-1);
%>
</script>
		<div class="widgetbox">
				<div class="title"><h4><%=kpi_date %></h4></div>
				<%if(plantKpi!=null&&!StringUtils.isEmpty(plantKpi.getHealth_png())&&!plantKpi.getHealth_png().equals("-")){ %>
					<div style="float: right"><img src="<%=plantKpi.getHealth_png() %>" style="padding: 5px;margin-left: 15px;"/></div>
				<%} %>
			</div>
		<div style="margin-top:5px;">
			<div>
				<div  id="kpi_day_data"></div>
				<div style="margin-top:5px;overflow:auto;overflow-x:true;">
					<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
						<colgroup>
							<col class="con0" width="7%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
							<col class="con0" width="3%" />
						</colgroup>
						<thead>																									
                                <tr>
                                    <th class="head0">DATE</th>
                                    <%for(String d:days.split(",")){ 
                                    %>
                                    <th class="head0"><%=d %></th>
                                    <%} %>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>Target</td>
                                    <%for(String t:target.split(",")){ 
                                    %>
                                    <td class="center"><%=Util.formatDouble1(Double.valueOf(t)) %></td>
                                    <%} %>
                                </tr>
                                <tr>
                                    <td>Actual</td>
                                    <%for(String a:actual.split(",")){ 
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
$("#kpi_day_data").css("height",height);
load_kpi_data('kpi_day_data','d',target,actual,unactual,remark);
</script>