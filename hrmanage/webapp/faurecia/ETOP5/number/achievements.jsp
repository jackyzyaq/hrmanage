<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String begin_month = StringUtils.defaultIfEmpty(request.getParameter("begin_month"), "");
	String end_month = StringUtils.defaultIfEmpty(request.getParameter("end_month"), "");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	SimpleDateFormat sdf1 = new SimpleDateFormat(Global.DATE_FORMAT_STR_D);
	Calendar cal = Calendar.getInstance();
	if(StringUtils.isEmpty(begin_month)||StringUtils.isEmpty(end_month)){
		end_month = sdf1.format(cal.getTime())+"";
		begin_month = sdf1.format(Util.addDate(cal.getTime(),"m", -2))+"";
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
			achievements_inner('<%=begin_month%>','<%=end_month%>');
		});
		function achievements_inner(begin_month,end_month){
			var params = {};
			params['begin_month']=begin_month;
			params['end_month']=end_month;
			params['menu_id']=<%=menu_id%>;
			inner_html(ctx+'/faurecia/ETOP5/number/achievements_inner.jsp',params,'contentwrapper #achievements_inner',null);
		}
		</script>
		<div class="widgetbox">
			<div class="title" style="float: right">
				<h4>
				<input style="width: 60px;" title="月份" type="text" readonly="readonly" id="begin_month" name="begin_month" value="<%=begin_month %>"  onclick="wdateYearMonthInstance('begin_month',function(){if($('#begin_month').val().Trim()==''){return false;}getEndMonthFn1();achievements_inner($('#begin_month').val(),$('#end_month').val());});"/>
				~
				<input style="width: 60px;" title="月份" type="text" readonly="readonly" id="end_month" name="end_month" value="<%=end_month %>"/>
				&nbsp;|&nbsp;
				<jsp:include page="/share/jsp/screen_full_open.jsp" />
				</h4>
			</div>
		</div>
		<div id="achievements_inner"></div>		
	</div>
</body>
</html>