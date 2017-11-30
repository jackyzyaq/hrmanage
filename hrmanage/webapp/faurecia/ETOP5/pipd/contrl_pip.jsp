<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String year = StringUtils.defaultIfEmpty(request.getParameter("year"), "");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	SimpleDateFormat sdf1 = new SimpleDateFormat(Global.DATE_FORMAT_STR_D);
	Calendar cal = Calendar.getInstance();
	if(StringUtils.isEmpty(year)||StringUtils.isEmpty(year)){
		year = cal.get(Calendar.YEAR)+"";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/pipd/js/pipd.js"></script>
</head>
<body>
	<div id="contentwrapper" class="contentwrapper">
		<script type="text/javascript">
		$(function(){
			contrl_pipd_inner('<%=year%>');
		});
		function contrl_pipd_inner(year){
			var params = {};
			params['year']=year;
			params['type']='<%=Global.plant_type[1] %>';
			params['menu_id']=<%=menu_id%>;
			inner_html(ctx+'/faurecia/ETOP5/pipd/contrl_pip_inner.jsp',params,'contentwrapper #contrl_pipd_inner',null);
		}
		</script>
		<div class="widgetbox">
			<div class="title" style="float: right">
				<h4>
				<input style="width: 60px;" type="text" readonly="readonly" id="year" name="year" value="<%=year %>"  onclick="wdateYearInstance('year',function(){if($('#year').val().Trim()==''){return false;}contrl_plan_inner($('#year').val());});"/>&nbsp;|&nbsp;
				<jsp:include page="/share/jsp/screen_full.jsp" />
				</h4>
			</div>
		</div>
		<div id="contrl_pipd_inner"></div>
	</div>
</body>
</html>
