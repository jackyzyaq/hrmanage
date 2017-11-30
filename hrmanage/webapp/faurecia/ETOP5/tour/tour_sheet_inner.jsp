<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String report_date = StringUtils.defaultIfEmpty(request.getParameter("report_date"), "");
	SimpleDateFormat sdfA = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	SimpleDateFormat sdfE = new SimpleDateFormat(Global.DATE_FORMAT_STR_E);
	if(StringUtils.isEmpty(report_date)){
		return ;
	}
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	TourService tourService = (TourService) ctx.getBean("tourService");
	TourRecordService tourRecordService = (TourRecordService) ctx.getBean("tourRecordService");
	List<Tour> tourList = tourService.findByCondition(new Tour(1), null);
	//List<TourRecord> trList = tourRecordService.findByCondition(new TourRecord(null,Integer.parseInt(tour_info_id),sdfA.parse(report_date)), p);
%>
<script type="text/javascript">
$(function(){
	});
</script>
	<div class="widgetbox">
		<div  class="shadowdiv" style="margin:5px;">
			<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
				<colgroup>
					<col class="con0" />
					<col class="con0" />
					<col class="con0" />
					<col class="con0" />
				</colgroup>
				<thead>
					<tr>
		        		<th class="head0" rowspan='2'><a style="cursor:pointer" >Time</a></th>
		            	<th class="head0" rowspan='2'><a style="cursor:pointer" >Stop</a></th>
		               	<th class="head0" rowspan='2'><a style="cursor:pointer" >Zone</a></th>
		               	<th class="head0" rowspan='2'><a style="cursor:pointer" >Input KPI</a></th>
		               	<th class="head0" rowspan='2'><a style="cursor:pointer" >Criteria/Standard Situation</a></th>
		               	<th class="head0" rowspan='2'><a style="cursor:pointer" >Linked Output KPI</a></th>
		               	<th class="head0" rowspan='2'><a style="cursor:pointer" >Visual Tools</a></th>
		               	<th class="head0" rowspan='2'><a style="cursor:pointer" >Check Current Situation</a></th>
		               	<th class="head0" colspan='3'><a style="cursor:pointer" >Reaction Rule</a></th>
					</tr>
					<tr>
		               	<th class="head0"><a style="cursor:pointer" >Yellow</a></th>
		               	<th class="head0"><a style="cursor:pointer" >Orange</a></th>
		               	<th class="head0"><a style="cursor:pointer" >Red</a></th>
					</tr>
				</thead>
				<tbody>
				<%if(tourList!=null&&!tourList.isEmpty()){ 
					for(Tour tour:tourList){
				%>
		        	<tr>
		              	<td class="center" style="" rowspan='2'><%=StringUtils.defaultIfEmpty(tour.getTime(), "") %></td>
		              	<td class="center" style=""><%=StringUtils.defaultIfEmpty(tour.getExt_4(), "-") %></td>
		              	<td class="center" style=""><%=StringUtils.defaultIfEmpty(tour.getZone(), "") %></td>
		              	<td class="center" style=""><%=StringUtils.defaultIfEmpty(tour.getInput_kpi(), "") %></td>
		              	<td class="center" style=""><%=StringUtils.defaultIfEmpty(tour.getCriteria_standard_situation(), "") %></td>
		              	<td class="center" style=""><%=StringUtils.defaultIfEmpty(tour.getLinked_output_kpi(), "") %></td>
		              	<td class="center" style=""><%=StringUtils.defaultIfEmpty(tour.getVisual_tools(), "") %></td>
		              	<td class="center" style=""><%=StringUtils.defaultIfEmpty(tour.getCheck_current_situation(), "") %></td>
		              	<td class="center" style=""><%=StringUtils.defaultIfEmpty(tour.getReaction_rule_y(), "").replace("\r","<br/>").replace("\n","<br/>") %></td>
		              	<td class="center" style=""><%=StringUtils.defaultIfEmpty(tour.getReaction_rule_o(), "").replace("\r", "<br/>").replace("\n", "<br/>") %></td>
		              	<td class="center" style=""><%=StringUtils.defaultIfEmpty(tour.getReaction_rule_r(), "").replace("\r", "<br/>").replace("\n", "<br/>") %></td>
		     		</tr>
		     		<tr>
		     			<td colspan="10">
		     				<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
		     					<thead>
									<tr>
										<th class="center">CheckTime</th>
										<th class="center">Status</th>
										<th class="center">Reaction</th>
									</tr>
								</thead>
		     					<tbody>
		     						<%
		     							List<TourRecord> list = tourRecordService.findByCondition(new TourRecord(null,tour.getId(),sdfA.parse(report_date)), null);
										if(list!=null&&!list.isEmpty()){
										int dept_id = 0,emp_id = 0,number = 0;
										for(TourRecord tourRecord:list){
		     						%>
									<tr>
										<td class="center"><%=sdfE.format(tourRecord.getStatus_date()) %></td>
										<td class="center">
											<%if(tourRecord.getStatus()==1){ %>
											<img id="ext_1_photo" src="${ctx }/share/jsp/showImage.jsp?file=<%=StringUtils.defaultIfEmpty(tour.getExt_1(), "0")  %>" alt="" width="40" height="40" />
											<%} else { %>
							            	<img id="ext_2_photo" src="${ctx }/share/jsp/showImage.jsp?file=<%=StringUtils.defaultIfEmpty(tour.getExt_2(), "0")  %>" alt="" width="40" height="40" />
							            	<%} %></td>
										<td class="center"><%=StringUtils.defaultIfEmpty(tourRecord.getExt_3(),"-") %></td>
									</tr>
									<%}}else{ %>
									<tr>
										<td>-</td><td>-</td><td>-</td>
									</tr>
									<%} %>
								</tbody>
		     				</table>
		     			</td>
		     		</tr>
		     	<%}
		     	}else{ %>
		     	
		     	<%} %>
		   		</tbody>
			</table>
		</div><!--widgetcontent-->	
	</div><!--widgetbox-->
<script type="text/javascript">
//$(".stdtable").css("width",(_window_width+_window_width)+"px");
</script>