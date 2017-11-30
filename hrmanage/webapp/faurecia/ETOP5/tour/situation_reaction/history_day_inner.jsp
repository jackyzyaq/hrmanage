<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String report_date = StringUtils.defaultIfEmpty(request.getParameter("report_date"), "");
	String tour_info_id = StringUtils.defaultIfEmpty(request.getParameter("tour_info_id"), "0");
	if(StringUtils.isEmpty(report_date)){
		return ;
	}
	SimpleDateFormat sdfA = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	SimpleDateFormat sdfE = new SimpleDateFormat(Global.DATE_FORMAT_STR_E);
	SimpleDateFormat sdfB = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	TourRecordService tourRecordService = (TourRecordService) ctx.getBean("tourRecordService");
	
	int year = Integer.parseInt(report_date.split("-")[0]);
	int month = Integer.parseInt(report_date.split("-")[1]);
	
	TourRecord tr = new TourRecord();
	tr.setTour_info_id(Integer.parseInt(tour_info_id));
	Map<String,Map<Integer,Object>> colorMap = new HashMap<String,Map<Integer,Object>>();
	for(String color:Global.tour_level){
		if(!colorMap.containsKey(color)){
			colorMap.put(color, Util.getDayObject(null,sdfA.parse(report_date)));
		}
		tr.setExt_1(color);
		for(Integer day:colorMap.get(color).keySet()){
			tr.setStart_date(year+"-"+month+"-"+day);
			tr.setOver_date(year+"-"+month+"-"+day);
			colorMap.get(color).put(day, tourRecordService.findMonthOrDayForList(tr));
		}
	}
%>
<script type="text/javascript">
var day_red = [],day_orange = [],day_yellow = [],days = [];
<%
	String day_red = "",day_orange = "",day_yellow = "",days = "";
	for(String color:colorMap.keySet()){
		for(Integer day:colorMap.get(color).keySet()){
			Object obj = colorMap.get(color).get(day);
			List<TourRecord> trlist = null;tr = null;
			if(obj instanceof List){
				trlist = (List<TourRecord>)obj;
				if(trlist!=null&&!trlist.isEmpty())
					tr = trlist.get(0);
			}
			out.print("day_"+color.toLowerCase()+".push(["+day+", "+(tr==null?"0":tr.getCount())+"]),");
			if(color.equals(Global.tour_level[0]))
				day_yellow += (tr==null?"0":tr.getCount())+",";
			else if(color.equals(Global.tour_level[1]))
				day_orange += (tr==null?"0":tr.getCount())+",";
			else if(color.equals(Global.tour_level[2]))
				day_red += (tr==null?"0":tr.getCount())+",";
		}
	}
	out.print("days.push([1, 0]);");
	day_red = day_red.substring(0,day_red.length()-1);
	day_orange = day_orange.substring(0,day_orange.length()-1);
	day_yellow = day_yellow.substring(0,day_yellow.length()-1);
%>
</script>
<ul id="history_day_table" class="toplist">
	<li>
		<div style="height:24px;margin: 5px 0px 0px 5px;"></div>		
			<div class="widgetbox">
				<div style="margin:5px;">
					<div id="history_day_data"></div>		
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
		                                    <th class="head0">DATE</th>
		                                    <%for(Integer d:Util.getDayObject(null,sdfA.parse(report_date)).keySet()){ 
		                                    %>
		                                    <th class="head0" style="cursor:pointer;"><%=d %></th>
		                                    <%} %>
		                                </tr>
		                            </thead>
		                       	<tbody>
		                                <tr>
		                                    <td><%=Global.tour_level_name[2].replace("报警", "") %></td>
		                                    <%for(String t:day_red.split(",")){ 
		                                    double d = Util.formatDouble1(Double.valueOf(t));
		                                    %>
		                                    <td class="center"><%=(d) %></td>
		                                    <%} %>
		                                </tr>
		                                <tr>
		                                    <td><%=Global.tour_level_name[1].replace("报警", "") %></td>
		                                    <%
		                                    for(String a:day_orange.split(",")){ 
		                                    double d = Util.formatDouble1(Double.valueOf(a));
		                                    %>
		                                    <td class="center"><%=(d) %></td>
		                                    <%} %>
		                                </tr>
		                                 <tr>
		                                    <td><%=Global.tour_level_name[0].replace("报警", "") %></td>
		                                    <%
		                                    for(String a:day_yellow.split(",")){ 
		                                    double d = Util.formatDouble1(Double.valueOf(a));
		                                    %>
		                                    <td class="center"><%=(d) %></td>
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
$("#history_day_table").css("width",(parseInt($("#history_day_inner").css('width').replace('px',''))-7)+"px");
$("#history_day_data").css("height",window.screen.availHeight/2-60);
load_kpi_data('history_day_data','d',day_red,day_orange,day_yellow,'',new Array("<%=OperaColor.toHex(Global.tour_level_color[2][0], Global.tour_level_color[2][1], Global.tour_level_color[2][2])%>","<%=OperaColor.toHex(Global.tour_level_color[1][0], Global.tour_level_color[1][1], Global.tour_level_color[1][2])%>","<%=OperaColor.toHex(Global.tour_level_color[0][0], Global.tour_level_color[0][1], Global.tour_level_color[0][2])%>"),'');
</script>