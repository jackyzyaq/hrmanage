<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%@page import="com.yq.company.etop5.service.PipdReportService"%>
<%@page import="com.yq.company.etop5.pojo.PipdReport"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String begin_month = StringUtils.defaultIfEmpty(request.getParameter("begin_month"), "");
	String end_month = StringUtils.defaultIfEmpty(request.getParameter("end_month"), "");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	SimpleDateFormat sdf1 = new SimpleDateFormat(Global.DATE_FORMAT_STR_D);
	Calendar cal = Calendar.getInstance();
	if(StringUtils.isEmpty(begin_month)||StringUtils.isEmpty(end_month)){
		ServletContext st = this.getServletConfig().getServletContext();
		ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
		PipdReportService pipdReportService = (PipdReportService) ctx.getBean("pipdReportService");
		PipdReport pipdReport = pipdReportService.queryBest();
		if(pipdReport!=null){
			end_month = sdf1.format(pipdReport.getEnd_month())+"";
			begin_month = sdf1.format(pipdReport.getBegin_month())+"";
		}else{
			end_month = sdf1.format(cal.getTime())+"";
			begin_month = sdf1.format(Util.addDate(cal.getTime(),"m", -6))+"";
		}
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
</head>
<body>
	<div id="contentwrapper" class="contentwrapper">
		<script type="text/javascript">
		$(function(){
			pipd_index_inner('<%=begin_month%>','<%=end_month%>');
		});
		function pipd_index_inner(begin_month,end_month){
			var params = {};
			params['begin_month']=begin_month;
			params['end_month']=end_month;
			params['menu_id']=<%=menu_id%>;
			inner_html(ctx+'/faurecia/ETOP5/pipd/pipd_index_inner.jsp',params,'contentwrapper #pipd_index_inner',null);
		}
		</script>
		<div class="widgetbox">
			<div class="title" style="float: right">
				<h4>
				<input style="width: 60px;" title="月份" type="text" readonly="readonly" id="begin_month" name="begin_month" value="<%=begin_month %>"  onclick="wdateYearMonthInstance('begin_month',function(){if($('#begin_month').val().Trim()==''){return false;}pipd_index_inner($('#begin_month').val(),$('#end_month').val());});"/>
				~
				<input style="width: 60px;" title="月份" type="text" readonly="readonly" id="end_month" name="end_month" value="<%=end_month %>"  onclick="wdateYearMonthInstance('end_month',function(){if($('#end_month').val().Trim()==''){return false;}pipd_index_inner($('#begin_month').val(),$('#end_month').val());});"/>
				&nbsp;|&nbsp;
				<jsp:include page="/share/jsp/screen_full.jsp" />
				</h4>
			</div>
		</div>
		<div id="pipd_index_inner"></div>
	</div>
</body>
</html>