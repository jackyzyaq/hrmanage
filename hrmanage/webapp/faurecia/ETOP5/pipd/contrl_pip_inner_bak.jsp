<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	String begin_month = StringUtils.defaultIfEmpty(request.getParameter("begin_month"), "");
	String end_month = StringUtils.defaultIfEmpty(request.getParameter("end_month"), "");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	SimpleDateFormat sdf1 = new SimpleDateFormat(Global.DATE_FORMAT_STR_D);
	Calendar cal = Calendar.getInstance();
	if(StringUtils.isEmpty(begin_month)||StringUtils.isEmpty(end_month)){
		end_month = sdf1.format(cal.getTime())+"";
		begin_month = sdf1.format(Util.addDate(cal.getTime(),"m", -1))+"";
	}
	int begin_year = cal.get(Calendar.YEAR);
%>
		<jsp:include page="/faurecia/ETOP5/pipd/contrl_pip_inner_plant_vision.jsp" flush="true">
			<jsp:param value="<%=Global.plant_type[2] %>" name="type"/>
			<jsp:param value="<%=begin_year %>" name="begin_year"/>
		</jsp:include>	
		<div class="one_half left">
			<jsp:include page="/faurecia/ETOP5/pipd/contrl_pip_inner_chart.jsp">
				<jsp:param value="<%=begin_month %>" name="begin_month"/>
				<jsp:param value="<%=end_month %>" name="end_month"/>
			</jsp:include>
		</div><!--one_half last--> 
		                       
		<div class="one_half last">
			<jsp:include page="/faurecia/ETOP5/pipd/contrl_pip_inner_priorities_management.jsp" flush="true" >
				<jsp:param value="<%=begin_month %>" name="begin_month"/>
				<jsp:param value="<%=end_month %>" name="end_month"/>
			</jsp:include>
		</div><!--one_half last-->
		<div class="">
			<jsp:include page="/faurecia/ETOP5/pipd/contrl_pip_inner_priorities_management2.jsp" flush="true" >
				<jsp:param value="<%=begin_month %>" name="begin_month"/>
				<jsp:param value="<%=end_month %>" name="end_month"/>
			</jsp:include>
		</div>
