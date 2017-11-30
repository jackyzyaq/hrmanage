<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String report_date = StringUtils.defaultIfEmpty(request.getParameter("report_date"), "");
	String dept_id 	= StringUtils.defaultIfEmpty(request.getParameter("dept_id"), "0");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	SimpleDateFormat sdfE = new SimpleDateFormat(Global.DATE_FORMAT_STR_E);
	if(StringUtils.isEmpty(report_date)){
		return ;
	}
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	TourService tourService = (TourService) ctx.getBean("tourService");
	TourRecordService tourRecordService = (TourRecordService) ctx.getBean("tourRecordService");
	List<Tour> listTour = tourService.findByCondition(new Tour(1,Integer.parseInt(dept_id)), null);
	
%>
<script type="text/javascript" src="${ctx }/share/js/circle.js"></script>
<style type="">
#index .stdtable thead th, .stdtable thead td {padding: 2px 5px; border-left: 0; color: #000;  }
#index .stdtable tbody tr td { padding: 2px 5px; color: #666; }
#index .stdtable th, .stdtable td { height:24px; vertical-align: middle;font-size: 14px;}
</style>
<script type="text/javascript">
	function detail(obj){
		if(typeof(obj.id) != "undefined"&&obj.id.length>0){
			var kpi_data = obj.id.split('|');
			click_href('${ctx}/faurecia/ETOP5/tour/situation_reaction/index_inner_detail.jsp?tour_info_id='+kpi_data[0]+'&report_date='+kpi_data[1]+'&dept_id='+kpi_data[2]);
		}
	}
</script>
<div style="margin-top:0px;">
	<%for(int i=0;i<listTour.size();i++){ 
		Tour tour = listTour.get(i);
		TourRecord tourRecord1 = tourRecordService.queryObject(sdf.parse(report_date), 1, tour.getId());
		TourRecord tourRecord2 = tourRecordService.queryObject(sdf.parse(report_date), 2, tour.getId());
		TourRecord tourRecord3 = tourRecordService.queryObject(sdf.parse(report_date), 3, tour.getId());
	%>
	<script type="text/javascript">
		$(function(){
			circleProgress('c<%=i %>_1', '<%=tourRecord1==null?"-":sdfE.format(tourRecord1.getStatus_date()) %>','<%=tourRecord1==null?Global.colors[2]:tourRecord1.getStatus().intValue()==1?Global.colors[0]:Global.colors[1]%>');
			circleProgress('c<%=i %>_2', '<%=tourRecord2==null?"-":sdfE.format(tourRecord2.getStatus_date()) %>','<%=tourRecord2==null?Global.colors[2]:tourRecord2.getStatus().intValue()==1?Global.colors[0]:Global.colors[1]%>');
			circleProgress('c<%=i %>_3', '<%=tourRecord3==null?"-":sdfE.format(tourRecord3.getStatus_date()) %>','<%=tourRecord3==null?Global.colors[2]:tourRecord3.getStatus().intValue()==1?Global.colors[0]:Global.colors[1]%>');
		});
	</script>	
<div class="one_third">
	<div class="shadowdiv" style='margin:5px 5px 5px 5px;'>
		<table cellpadding='0' cellspacing='0' border='0' class='stdtable'><thead><tr><th colspan='2' class='head0'>
		<font style='font-size: 16px;'>Stop<%=StringUtils.defaultIfEmpty(tour.getExt_4(), "-") %></font>
		</th></tr></thead>
		<tbody>
		<tr><td colspan='2'>
			<div class='widgetcontent userlistwidget nopadding'  id='<%=tour.getId()+"|"+report_date+"|"+dept_id %>' onclick='detail(this);' style='cursor:pointer;'>
				<ul>
					<li>
						<div class="info">
							<a href="">Time</a> <br />
							<p style="text-indent:2em"><%=StringUtils.defaultIfEmpty(tour.getTime(), "-") %></p>
						</div><!--info-->
					</li>
					<li>
						<div class="info">
							<a href="">Zone</a> <br />
							<p style="text-indent:2em"><%=StringUtils.defaultIfEmpty(tour.getZone(), "-") %></p>
						</div><!--info-->
					</li>
					<li>
						<div class="info">
							<a href="">KPI</a> <br />
							<p style="text-indent:2em"><%=StringUtils.defaultIfEmpty(tour.getInput_kpi(), "-") %></p>
						</div><!--info-->
					</li>
					<li>
						<div class="info">
							<a href="">Link Output</a> <br />
							<p style="text-indent:2em"><%=StringUtils.defaultIfEmpty(tour.getLinked_output_kpi(), "-") %></p>
						</div><!--info-->
					</li>	
					<li>
						<div class="info">
							<a href="">Visual Tools</a> <br />
							<p style="text-indent:2em"><%=StringUtils.defaultIfEmpty(tour.getVisual_tools(), "-") %></p>
						</div><!--info-->
					</li>
					<li>
						<div class="info">
							<div class="clearall"></div>														
							<div style='text-align:center;'>
								<div class="one_third">
									<canvas id='c<%=i %>_1' width='64' height='64' ></canvas>
								</div>
								<div class="one_third">
									<canvas id='c<%=i %>_2' width='64' height='64'></canvas>
								</div>
								<div class="one_third">
									<canvas id='c<%=i %>_3' width='64' height='64'></canvas>
								</div>
							<div class="clearall"></div>														
							</div>
						</div><!--info-->
					</li>					
				</ul>
			</div><!--widgetcontent-->
		</td></tr>
		</tbody>
		</table>
	</div>
	</div>
	<%} %>
</div>