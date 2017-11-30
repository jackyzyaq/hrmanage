<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	
	String begin_year = StringUtils.defaultIfEmpty(request.getParameter("begin_year"), "");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	Calendar cal = Calendar.getInstance();
	if(StringUtils.isEmpty(begin_year)){
		begin_year = String.valueOf(cal.get(Calendar.YEAR));
	}
%>
	<script>
	var year = <%=begin_year%>;
	var _url = "${ctx}/common/plantSchedule/queryResult.do";
	</script>
	<script type='text/javascript' src='${ctx }/js/ama/js/plugins/fullcalendar.min.js'></script>
	<script type="text/javascript" src="${ctx }/faurecia/ETOP5/plant/js/calendar.js"></script>
	<script type="text/javascript" src="${ctx }/faurecia/ETOP5/js/etop5.js"></script>
	<div class="widgetbox">
		<div class="title"><h4>&nbsp;<%=(begin_year)%>&nbsp;年&nbsp;&nbsp;&nbsp;[<a id="add_data" style="cursor:pointer;font-size:20px;" onclick="validateEtopPwd('${ctx}/faurecia/ETOP5/plant/data/plant_schedule_add.jsp?menu_id=<%=menu_id %>&begin_year=<%=begin_year %>','<%=begin_year%>添加');">&nbsp;+&nbsp;</a>]</h4></div>
		<div class="widgetcontent">
			<div class="two_third last">
				<div id="calendar"></div>
			</div>
		</div><!--widgetcontent-->
	</div>