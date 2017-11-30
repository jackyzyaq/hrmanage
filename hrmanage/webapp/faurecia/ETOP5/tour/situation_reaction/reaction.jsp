<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String report_date = StringUtils.defaultIfEmpty(request.getParameter("report_date"), "");
	String tour_info_id = StringUtils.defaultIfEmpty(request.getParameter("tour_info_id"), "0");
	String dept_id 	= StringUtils.defaultIfEmpty(request.getParameter("dept_id"), "0");
	String number = StringUtils.defaultIfEmpty(request.getParameter("number"), "0");
	SimpleDateFormat sdfA = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	SimpleDateFormat sdfE = new SimpleDateFormat(Global.DATE_FORMAT_STR_E);
	if(StringUtils.isEmpty(report_date)){
		return ;
	}
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	TourService tourService = (TourService) ctx.getBean("tourService");
	TourRecordService tourRecordService = (TourRecordService) ctx.getBean("tourRecordService");
	Tour tour = tourService.queryById(Integer.parseInt(tour_info_id),null);
	Page p = new Page();
	p.setTotalCount(10);
	p.setSidx("number");
	p.setSord("asc");
	List<TourRecord> trList = tourRecordService.findByCondition(new TourRecord(null,Integer.parseInt(tour_info_id),sdfA.parse(report_date)), p);
%>
<script type="text/javascript">
$(function(){
	});
</script>
<div style="margin-top:0px;">
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
		        		<th class="head0" style="width:20%"><a style="cursor:pointer" >级别</a></th>
		            	<th class="head0" style="width:40%"><a style="cursor:pointer" >上升规则</a></th>
		               	<th class="head0" style="width:40%"><a style="cursor:pointer" >反应规则</a></th>
					</tr>
				</thead>
				<tbody>
		        	<tr style="background-color: <%=OperaColor.toHex(Global.tour_level_color[2][0], Global.tour_level_color[2][1], Global.tour_level_color[2][2])%>;">
		              	<td class="center" style="">级别3<br/><%=Global.tour_level_name[2] %></td>
		              	<td class="center" style=""><%=StringUtils.defaultIfEmpty(tour.getUp_rule_r(),"") %></td>
		              	<td style="text-align:left;"><%=StringUtils.defaultIfEmpty(tour.getReaction_rule_r(), "").replace("\r","<br/>").replace("\n","<br/>") %></td>
		     		</tr>
		     		<tr style="background-color: <%=OperaColor.toHex(Global.tour_level_color[1][0], Global.tour_level_color[1][1], Global.tour_level_color[1][2])%>;">
		              	<td class="center" style="">级别2<br/><%=Global.tour_level_name[1] %></td>
		              	<td class="center" style=""><%=StringUtils.defaultIfEmpty(tour.getUp_rule_o(),"") %></td>
		              	<td style="text-align:left;"><%=StringUtils.defaultIfEmpty(tour.getReaction_rule_o(), "").replace("\r","<br/>").replace("\n","<br/>") %></td>
		     		</tr>
		     		<tr style="background-color: <%=OperaColor.toHex(Global.tour_level_color[0][0], Global.tour_level_color[0][1], Global.tour_level_color[0][2])%>;">
		              	<td class="center" style="">级别1<br/><%=Global.tour_level_name[0] %></td>
		              	<td class="center" style=""><%=StringUtils.defaultIfEmpty(tour.getUp_rule_y(),"") %></td>
		              	<td style="text-align:left;"><%=StringUtils.defaultIfEmpty(tour.getReaction_rule_y(), "").replace("\r","<br/>").replace("\n","<br/>") %></td>
		     		</tr>
		   		</tbody>
			</table>
		</div><!--widgetcontent-->	
	</div><!--widgetbox-->
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
		        		<th class="head0" style="width:10%"><a style="cursor:pointer" >Alert</a></th>
		            	<th class="head0" style="width:25%"><a style="cursor:pointer" >描述</a></th>
		               	<th class="head0" style="width:25%"><a style="cursor:pointer" >行动计划</a></th>
		               	<th class="head0" style="width:10%"><a style="cursor:pointer" >责任人</a></th>
		               	<th class="head0" style="width:10%"><a style="cursor:pointer" >预计时间</a></th>
		               	<th class="head0" style="width:10%"><a style="cursor:pointer" >实际时间</a></th>
		               	<th class="head0" style="width:10%"><a style="cursor:pointer" >状态</a></th>
					</tr>
				</thead>
				<tbody>
					<%
					if(trList!=null&&!trList.isEmpty()){
					for(TourRecord tr:trList){ %>
					<tr>
		              	<td class="center" style="">Stop<%=StringUtils.defaultIfEmpty(tr.getExt_4(), "-") %></td>
		              	<td style="text-align:left;"><%=StringUtils.defaultIfEmpty(tr.getRespones(),"-") %></td>
		              	<td style="text-align:left;"><%=StringUtils.defaultIfEmpty(tr.getExt_3(), "-").replace("\r","<br/>").replace("\n","<br/>") %></td>
		              	<td class="center" style=""><%=StringUtils.defaultIfEmpty(tr.getEmp_name(),"-") %></td>
		              	<td class="center" style="">
		              		<%
		              		if(tr.getNumber().intValue()==1){
		              			out.print(StringUtils.defaultIfEmpty(tour.getExpect_time_1(),"-"));
		              		} else if(tr.getNumber().intValue()==2){
		              			out.print(StringUtils.defaultIfEmpty(tour.getExpect_time_2(),"-"));
		              		} else if(tr.getNumber().intValue()==3){
		              			out.print(StringUtils.defaultIfEmpty(tour.getExpect_time_3(),"-"));
		              		} 
		              		%>
		              	</td>
		              	<td class="center" style=""><%=tr.getStatus_date()==null?"-":sdfE.format(tr.getStatus_date()) %></td>
		              	<td class="center" style=""><%=tr.getStatus().intValue()==1?"OK":"NOK" %></td>
		     		</tr>
					<%}}else{ %>
					<tr>
		              	<td class="center" style="text-align:left;" colspan="7">无数据</td>
		              </tr>
					<%} %>
		   		</tbody>
			</table>
		</div><!--widgetcontent-->	
	</div><!--widgetbox-->			
</div>