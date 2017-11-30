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
	TourService tourService = (TourService) ctx.getBean("tourService");
	Tour tour = tourService.queryById(Integer.parseInt(tour_info_id),null);
%>
<script type="text/javascript">
	$(function(){
		history_month_inner();
	});
	function history_month_inner(){
		var _url = ctx+'/faurecia/ETOP5/tour/situation_reaction/history_month_inner.jsp';
		var params = {};
		params['menu_id']='<%=menu_id%>';
		params['report_date']='<%=report_date%>';
		params['tour_info_id']='<%=tour_info_id%>';
		inner_html(_url,params,'contentwrapper #history_month_inner',function(data){
			$("#contentwrapper #history_month_inner").html(data);
			history_day_inner('<%=tour_info_id%>','<%=report_date%>');
		});
	}
	function history_day_inner(tour_info_id,report_date){
		if(typeof(report_date)=='undefined'||report_date == ''){
			report_date = '';
		}
		inner_html(ctx+'/faurecia/ETOP5/tour/situation_reaction/history_day_inner.jsp?report_date='+report_date+'&tour_info_id='+tour_info_id
					,null,'history_day_inner',null);
	}
	
</script>
<div id="contentwrapper" style='margin-top: 10px;'>
	<div class="two_fifth">
		<div id="history_month_inner" class="shadowdiv" style="background-color:#FDFFFF;margin-bottom: 5px;"></div>
	</div>
	<div class="three_fifth last">
		<div id="history_day_inner" class="shadowdiv" style="background-color:#FDFFFF;margin-bottom: 5px;"></div>
	</div>
</div>