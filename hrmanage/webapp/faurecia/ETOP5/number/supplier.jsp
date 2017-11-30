<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	SimpleDateFormat sdf1 = new SimpleDateFormat(Global.DATE_FORMAT_STR_D);
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	SupplierRankingService supplierRankingService = (SupplierRankingService) ctx.getBean("supplierRankingService");
	SupplierRanking sr = supplierRankingService.queryMaxBeginMonth();
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String year = StringUtils.defaultIfEmpty(request.getParameter("year"), "");
	Calendar cal = Calendar.getInstance();
	if(StringUtils.isEmpty(year)){
		year = String.valueOf(cal.get(Calendar.YEAR));
	}
	String begin_month = null;
	if(sr!=null&&sr.getBegin_month()!=null){
		begin_month = sdf.format(sr.getBegin_month());
	}else{
		begin_month = year+"-01-01 00:00:00";
	}
	
%>
<!DOCTYPE html> 
<html>
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/number/js/ranking.js"></script>
<link rel="stylesheet" href="${ctx }/faurecia/ETOP5/css/style.css" type="text/css" />
</head>
<body>
	<div id="contentwrapper" class="contentwrapper">
		<script type="text/javascript">
		$(function(){
			supplier_inner('<%=year%>');
		});
		function supplier_inner(year){
			var params = {};
			params['year']=year;
			params['menu_id']=<%=menu_id%>;
			inner_html(ctx+'/faurecia/ETOP5/number/supplier_inner.jsp',params,'contentwrapper #supplier_inner',function(data){
				$("#contentwrapper #supplier_inner").html(data);
				supplier_status('<%=begin_month%>');
			});
		}
		function supplier_status(begin_month){
			var params = {};
			params['begin_month']=begin_month;
			params['menu_id']=<%=menu_id%>;
			inner_html(ctx+'/faurecia/ETOP5/number/supplier_inner_right.jsp',params,'contentwrapper #supplier_inner_right',null);
		}
		</script>
		<div class="widgetbox">
			<div class="title" style="float: right">
				<h4>
				<input style="width: 60px;" type="text" readonly="readonly" id="year" name="year" value="<%=year %>"  onclick="wdateYearInstance('year',function(){if($('#year').val().Trim()==''){return false;}supplier_inner($('#year').val());});"/>
				&nbsp;|&nbsp;
				<jsp:include page="/share/jsp/screen_full_open.jsp" />
				</h4>
			</div>
		</div>
		<div id="supplier_inner"></div>
	</div>
</body>
</html>