<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%
	int hr_status_id=Integer.parseInt(StringUtils.defaultIfEmpty(request.getParameter("hr_status_id"), "0"));
%>
<select name="hr_status_id" id="hr_status_id">
	<%
	int i=0;
	for(Integer key:Global.hrStatusMap.keySet()) {
		String status_code =(String) Global.hrStatusMap.get(key);
	%>
	<option value="<%=key.intValue()%>" <%=i==0||hr_status_id==key.intValue()?"selected":"" %>><%=status_code %>
	<%i++;} %>
</select>