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
<jsp:include page="/faurecia/ETOP5/pipd/contrl_pip_inner_plant_vision.jsp" flush="true">
	<jsp:param value="<%=Global.plant_type[1] %>" name="type"/>
	<jsp:param value="<%=year %>" name="begin_year"/>
</jsp:include>
