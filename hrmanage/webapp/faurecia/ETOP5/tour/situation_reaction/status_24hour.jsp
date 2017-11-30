<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String report_date = StringUtils.defaultIfEmpty(request.getParameter("report_date"), "");
	String tour_info_id = StringUtils.defaultIfEmpty(request.getParameter("tour_info_id"), "0");
	SimpleDateFormat sdfA = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	SimpleDateFormat sdfE = new SimpleDateFormat(Global.DATE_FORMAT_STR_E);
	SimpleDateFormat sdfB = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	if(StringUtils.isEmpty(report_date)){
		return ;
	}
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	TourRecordService tourRecordService = (TourRecordService) ctx.getBean("tourRecordService");
	
	
	Calendar cal = Calendar.getInstance();
	cal.setTime(sdfA.parse(report_date));
	cal.add(Calendar.DAY_OF_MONTH,1);
	
	TourRecord tc = new TourRecord();
	tc.setStart_date(report_date+" 07:00:00");
	tc.setOver_date(sdfA.format(cal.getTime())+" 06:00:00");
	tc.setTour_info_id(Integer.parseInt(tour_info_id));
	List<TourRecord> list = tourRecordService.find24HourByCondition(tc, null);
	
	Map<Integer,Object> day24HourData = Util.get7To7HourObject(null);
	if(list!=null&&!list.isEmpty()){
		for(TourRecord p:list){
			if(day24HourData.containsKey(p.getHour())){
				day24HourData.put(p.getHour(), p);
			}
		}
	}
	
%>
<script type="text/javascript">
var target = [];
var remark = {};
<%
String target="",hours="",unit="";
int count = 1;
for(Integer hour : day24HourData.keySet()){ 
	Object obj = day24HourData.get(hour);
	TourRecord p = null;
	if(obj instanceof TourRecord){
		p = (TourRecord)obj;
	}
	if(p==null){
	}else{
		unit = (p.getUnit());
	}
	target += ((p==null)?0:p.getData24())+",";
	hours += (hour)+",";
	
	out.print("target.push(["+hour+", "+(p==null?"null":p.getData24().toString())+"])"+(count<24?",":""));
	count ++;
}
target = target.substring(0,target.length()-1);
hours = hours.substring(0,hours.length()-1);
%>
</script>
<ul id="kpi_hour_table" class="toplist">
	<li>
		<div class="gradient">
	        <table cellpadding='0' cellspacing='0' border='0' class='stdtable'>
	        	<thead>
	        		<tr>
	        			<th colspan='2'  class="gradient">
	        				<font style="font-size:16px;color: <%=Global.colors[3]%>"><%=report_date %></font>
	        				<span style="cursor:pointer;font-size:16px;color: <%=Global.colors[3]%>" id="add_data" onclick="validateEtopPwd('${ctx}/faurecia/ETOP5/tour/data/tour_info_24data_add.jsp?report_date=<%=report_date %>&tour_info_id=<%=tour_info_id %>&menu_id=<%=menu_id %>','TOUR 24小时数据添加');">[&nbsp;+&nbsp;]</span>
						</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>	
		<div class="clearall"></div>
		<div class="widgetbox">
				<div style="margin:5px;">
					<div>
						<div  id="kpi_hour_data"></div>
					</div><!--widgetbox-->			
				</div>
		</div>
		<div class="widgetbox" style="overflow:auto;overflow-x:scroll !important;">
			<div style="margin:5px;">
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
		                                    <th class="head0">HOUR</th>
		                                    <%for(String d:hours.split(",")){ 
		                                    %>
		                                    <th class="head0"><%=d %></th>
		                                    <%} %>
		                                </tr>
		                            </thead>
		                            <tbody>
		                                <tr>
		                                    <td>Data</td>
		                                    <%for(String a:target.split(",")){ 
		                                    	double d = Util.formatDouble1(Double.valueOf(a));
		                                    %>
		                                    <td class="center"><%=(d+(unit.equals("%")?"%":"")) %></td>
		                                    <%} %>
		                                </tr>
		                            </tbody>
		                        </table>
						</div><!--widgetcontent-->	
				</div>	
	</li>
</ul>
<script type="text/javascript">
$("#kpi_hour_table").css("width",(parseInt($("#kpi_hour_table").css('width').replace('px','')))+"px");
$("#kpi_hour_data").css("height",window.screen.availHeight/2-60);
load_kpi_data('kpi_hour_data','h',target,null,null,null,new Array("<%=Global.colors[0]%>","<%=Global.colors[1]%>","<%=Global.colors[2]%>"),'<%=(unit.equals("%")?"%":"")%>');
</script>