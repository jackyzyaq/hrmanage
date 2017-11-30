<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	UserInfo user = (UserInfo)request.getSession().getAttribute("user");
	String report_date = StringUtils.defaultIfEmpty(request.getParameter("report_date"), "");
	String tour_info_id = StringUtils.defaultIfEmpty(request.getParameter("tour_info_id"), "0");
	SimpleDateFormat sdfA = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	SimpleDateFormat sdfE = new SimpleDateFormat(Global.DATE_FORMAT_STR_E);
	if(StringUtils.isEmpty(report_date)){
		return ;
	}
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	TourService tourService = (TourService) ctx.getBean("tourService");
	TourRecordService tourRecordService = (TourRecordService) ctx.getBean("tourRecordService");
	Tour tour = tourService.queryById(Integer.parseInt(tour_info_id),null);
	int dept_id = 0,emp_id = 0;
	for(int i=1;i<=3;i++){ 
		if(i==1) {dept_id = tour.getDept_id_1();emp_id = tour.getEmp_id_1();} else 
		if(i==2) {dept_id = tour.getDept_id_2();emp_id = tour.getEmp_id_2();} else 
		if(i==3) {dept_id = tour.getDept_id_3();emp_id = tour.getEmp_id_3();} 
		TourRecord tourRecord = tourRecordService.queryObject(sdfA.parse(report_date), i, Integer.parseInt(tour_info_id));
		if(tourRecord!=null){
%>
<tr>
	<td class="center" colspan="2"><%=Global.departmentInfoMap.get(dept_id).getDept_name() %></td>
	<td class="center">CheckTime</td>
	<td class="center">Status</td>
	<td class="center">Reaction</td>
</tr>
<tr>
	<td class="center"><%=sdfE.format(tourRecord.getStatus_date()) %></td>
	<td class="center"><%=tourRecord.getStatus()==1?"OK":"NOK" %></td>
	<td class="center"><%=StringUtils.defaultIfEmpty(tourRecord.getRespones(),"") %></td>
</tr>
<%}else{%>
<tr <%if(Integer.parseInt(user.getName())==emp_id){%>style="cursor:pointer;" onclick="status_inner_do('<%=report_date %>','<%=i %>','<%=tour_info_id%>');"<%} %>>
	<td class="center" colspan="2"><%=Global.departmentInfoMap.get(dept_id).getDept_name() %></td>
	<td class="center">CheckTime</td>
	<td class="center">Status</td>
	<td class="center">Reaction</td>
</tr>
<tr>
	<td class="center">-</td>
	<td class="center">-</td>
	<td class="center">-</td>
</tr>
<%}}%>