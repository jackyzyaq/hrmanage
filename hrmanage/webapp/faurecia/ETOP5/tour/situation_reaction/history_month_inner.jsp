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
	//int month = Integer.parseInt(report_date.split("-")[1]);
	
	TourRecord tr = new TourRecord();
	tr.setTour_info_id(Integer.parseInt(tour_info_id));
	Map<String,Map<Integer,Object>> colorMap = new HashMap<String,Map<Integer,Object>>();
	for(String color:Global.tour_level){
		if(!colorMap.containsKey(color)){
			colorMap.put(color, Util.getMonthObject(null));
		}
		tr.setExt_1(color);
		for(Integer month:colorMap.get(color).keySet()){
			tr.setStart_date(year+"-"+month+"-01");
			tr.setOver_date(year+"-"+month+"-"+Util.getMaxDay(year, month));
			colorMap.get(color).put(month, tourRecordService.findMonthOrDayForList(tr));
		}
	}
%>
<script type="text/javascript">
var month_red = [],month_orange = [],month_yellow = [],months = [];
<%
	String month_red = "",month_orange = "",month_yellow = "";
	for(String color:colorMap.keySet()){
		for(Integer month:colorMap.get(color).keySet()){
			Object obj = colorMap.get(color).get(month);
			List<TourRecord> trlist = null;tr = null;
			if(obj instanceof List){
				trlist = (List<TourRecord>)obj;
				if(trlist!=null&&!trlist.isEmpty())
					tr = trlist.get(0);
			}
			out.print("month_"+color.toLowerCase()+".push(["+month+", "+(tr==null?"0":tr.getCount())+"]),");
			if(color.equals(Global.tour_level[0]))
				month_yellow += (tr==null?"0":tr.getCount())+",";
			else if(color.equals(Global.tour_level[1]))
				month_orange += (tr==null?"0":tr.getCount())+",";
			else if(color.equals(Global.tour_level[2]))
				month_red += (tr==null?"0":tr.getCount())+",";
		}
	}
	out.print("months.push([1, 0]);");
	month_red = month_red.substring(0,month_red.length()-1);
	month_orange = month_orange.substring(0,month_orange.length()-1);
	month_yellow = month_yellow.substring(0,month_yellow.length()-1);
%>
</script>
<ul id="kpi_month_table" class="toplist">
	<li>
		<div style="height:24px;margin: 5px 0px 0px 5px;"></div>		
			<div class="widgetbox">
				<div style="margin:5px;">
					<div id="history_month_data"></div>		
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
		                                    <th class="head0"><a style="cursor:pointer" onclick="history_day_inner(<%=tour_info_id%>,'<%=year+"-0"%>1<%="-01"%>');">Jan</a></th>
		                                    <th class="head0"><a style="cursor:pointer" onclick="history_day_inner(<%=tour_info_id%>,'<%=year+"-0"%>2<%="-01"%>');">Feb</a></th>
		                                    <th class="head0"><a style="cursor:pointer" onclick="history_day_inner(<%=tour_info_id%>,'<%=year+"-0"%>3<%="-01"%>');">Mar</a></th>
		                                    <th class="head0"><a style="cursor:pointer" onclick="history_day_inner(<%=tour_info_id%>,'<%=year+"-0"%>4<%="-01"%>');">Apr</a></th>
		                                    <th class="head0"><a style="cursor:pointer" onclick="history_day_inner(<%=tour_info_id%>,'<%=year+"-0"%>5<%="-01"%>');">May</a></th>
		                                    <th class="head0"><a style="cursor:pointer" onclick="history_day_inner(<%=tour_info_id%>,'<%=year+"-0"%>6<%="-01"%>');">Jun</a></th>
		                                    <th class="head0"><a style="cursor:pointer" onclick="history_day_inner(<%=tour_info_id%>,'<%=year+"-0"%>7<%="-01"%>');">Jul</a></th>
		                                    <th class="head0"><a style="cursor:pointer" onclick="history_day_inner(<%=tour_info_id%>,'<%=year+"-0"%>8<%="-01"%>');">Aug</a></th>
		                                    <th class="head0"><a style="cursor:pointer" onclick="history_day_inner(<%=tour_info_id%>,'<%=year+"-0"%>9<%="-01"%>');">Sep</a></th>
		                                    <th class="head0"><a style="cursor:pointer" onclick="history_day_inner(<%=tour_info_id%>,'<%=year+"-"%>10<%="-01"%>');">Oct</a></th>
		                                    <th class="head0"><a style="cursor:pointer" onclick="history_day_inner(<%=tour_info_id%>,'<%=year+"-"%>11<%="-01"%>');">Nov</a></th>
		                                    <th class="head0"><a style="cursor:pointer" onclick="history_day_inner(<%=tour_info_id%>,'<%=year+"-"%>12<%="-01"%>');">Dec</a></th>
		                                </tr>
		                        </thead>
		                       	<tbody>
		                                <tr>
		                                    <td><%=Global.tour_level_name[2].replace("报警", "") %></td>
		                                    <%for(String t:month_red.split(",")){ 
		                                    double d = Util.formatDouble1(Double.valueOf(t));
		                                    %>
		                                    <td class="center"><%=(d) %></td>
		                                    <%} %>
		                                </tr>
		                                <tr>
		                                    <td><%=Global.tour_level_name[1].replace("报警", "") %></td>
		                                    <%
		                                    for(String a:month_orange.split(",")){ 
		                                    double d = Util.formatDouble1(Double.valueOf(a));
		                                    %>
		                                    <td class="center"><%=(d) %></td>
		                                    <%} %>
		                                </tr>
		                                 <tr>
		                                    <td><%=Global.tour_level_name[0].replace("报警", "") %></td>
		                                    <%
		                                    for(String a:month_yellow.split(",")){ 
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
$("#history_month_table").css("width",(parseInt($("#history_month_inner").css('width').replace('px',''))-7)+"px");
$("#history_month_data").css("height",window.screen.availHeight/2-60);
load_kpi_data('history_month_data','m',month_red,month_orange,month_yellow,'',new Array("<%=OperaColor.toHex(Global.tour_level_color[2][0], Global.tour_level_color[2][1], Global.tour_level_color[2][2])%>","<%=OperaColor.toHex(Global.tour_level_color[1][0], Global.tour_level_color[1][1], Global.tour_level_color[1][2])%>","<%=OperaColor.toHex(Global.tour_level_color[0][0], Global.tour_level_color[0][1], Global.tour_level_color[0][2])%>"),'');
</script>