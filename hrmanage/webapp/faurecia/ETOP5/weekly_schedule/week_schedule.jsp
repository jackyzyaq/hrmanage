<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%
	Calendar cal = Calendar.getInstance();
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String week = StringUtils.defaultIfEmpty(request.getParameter("week"), "");
	if(StringUtils.isEmpty(week)){
		week = String.valueOf(cal.get(Calendar.WEEK_OF_YEAR));
	}
%>
<!DOCTYPE html> 
<html>
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<link rel="stylesheet" href="${ctx }/faurecia/ETOP5/css/style.css" type="text/css" />
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/js/etop5.js"></script>
</head>
<body>
	<div id="contentwrapper" class="contentwrapper">
		<script type="text/javascript">
		$(function(){
			$("#week").spinner({min: 1, max: 53, increment: 1});
			weekly_schedule_inner('<%=week%>');
		});
		function weekly_schedule_inner(week){
			var params = {};
			params['week']=week;
			inner_html(ctx+'/faurecia/ETOP5/weekly_schedule/week_schedule_inner.jsp',params,'contentwrapper #weekly_schedule_inner',null);
		}
		</script>
		<div class="widgetbox">
			<div class="title" style="float: right">
				<h4>
				<input style="width: 60px;height:24px;"  type="text" readonly="readonly" id="week" name="week" value="<%=week %>"  onblur="if($('#week').val().Trim()==''){return false;}weekly_schedule_inner($('#week').val());"/>
				&nbsp;|&nbsp;
				[<a id="add_data" style="cursor:pointer;font-size:20px;" onclick="validateEtopPwd('${ctx}/faurecia/ETOP5/weekly_schedule/data/data_add.jsp?menu_id=<%=menu_id %>','ManagementSchedule 数据添加');">&nbsp;+&nbsp;</a>]
				&nbsp;|&nbsp;
				<jsp:include page="/share/jsp/screen_full.jsp" />
				</h4>
			</div>
		</div>
		<div id="weekly_schedule_inner"></div>		
	</div>
</body>
</html>