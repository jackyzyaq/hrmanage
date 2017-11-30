<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String report_date = StringUtils.defaultIfEmpty(request.getParameter("report_date"), "");
	int dept_id = Integer.parseInt(StringUtils.defaultIfEmpty(request.getParameter("dept_id"), "0"));
	SimpleDateFormat sdfA = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	SimpleDateFormat sdfE = new SimpleDateFormat(Global.DATE_FORMAT_STR_E);
	if(StringUtils.isEmpty(report_date)){
		return ;
	}
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	TourService tourService = (TourService) ctx.getBean("tourService");
	TourRecordService tourRecordService = (TourRecordService) ctx.getBean("tourRecordService");
	//tmpTour.setSpecialStr(" (dept_id_1="+dept_id+" or "+" dept_id_2="+dept_id+" or "+" dept_id_3="+dept_id+") ");
	List<Tour> tourList = tourService.findByCondition(new Tour(1,dept_id), null);
	//List<TourRecord> trList = tourRecordService.findByCondition(new TourRecord(null,Integer.parseInt(tour_info_id),sdfA.parse(report_date)), p);
%>
<script type="text/javascript">
$(function(){
	});
</script>
	<div class="widgetbox">
		<div  class="shadowdiv" style="margin:5px;">
			<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
				<colgroup>
					<col class="con0" />
					<col class="con0" />
					<col class="con0" />
					<col class="con0" />
				</colgroup>
				<thead>
					<tr style="font-size:18px;">
		            	<th class="head0" colspan="3">
		            		<div style="margin: 5px;">Face To face board</div>
		            	</th>
		               	<th class="head0" ><a style="cursor:pointer" >N/N-1</a></th>
					</tr>
					<tr>
		            	<td class="head0" colspan="4">
		            		<div style="margin: 5px 35px 5px 5px;float: right"><span style="font-size:16px;font-weight: bold;">Date</span>&nbsp;&nbsp;<%=report_date %></div>
		            		<div style="margin: 5px 35px 5px 5px;float: right"><span style="font-size:16px;font-weight: bold;">Department</span>&nbsp;&nbsp;<%=Global.departmentInfoMap.get(dept_id).getDept_code() %></div>
		            	</td>
					</tr>
					<tr>
		            	<th class="head0" style="width:25%"><a style="cursor:pointer" >Stop</a></th>
		               	<th class="head0" style="width:25%"><a style="cursor:pointer" >Situation</a></th>
		               	<th class="head0" style="width:25%"><a style="cursor:pointer" >Action</a></th>
		               	<th class="head0" style="width:25%"><a style="cursor:pointer" >Status</a></th>
					</tr>
				</thead>
				<tbody>
				<%if(tourList!=null&&!tourList.isEmpty()){ 
					for(Tour tour:tourList){
						int emp_id_u = 0,emp_id_d = 0;
						TourRecord tourRecordU = null,tourRecordD = null;
						emp_id_u = tour.getEmp_id_1();
						emp_id_d = tour.getEmp_id_2(); 
						tourRecordU = tourRecordService.queryObject(sdfA.parse(report_date), 1, tour.getId());
						tourRecordD = tourRecordService.queryObject(sdfA.parse(report_date), 2, tour.getId());
				%>
		        	<tr>
		              	<td class="center" style="" rowspan='3'><%=StringUtils.defaultIfEmpty(tour.getExt_4(), "-") %></td>
		              	<td class="center" style=""><%=(emp_id_u==0?"N/A":Global.employeeInfoMap.get(emp_id_u).getZh_name()) %></td>
		              	<td class="center" style=""><%=tourRecordU==null?"N/A":StringUtils.defaultIfEmpty(tourRecordU.getExt_3(),"N/A") %></td>
		              	<td class="center" style="">
		              		<%if(tourRecordU==null){ %>
		              		N/A
		              		<%}else{ 
		              		if(tourRecordU.getStatus()==1){
		              		%>
							<img id="ext_1_photo" src="${ctx }/share/jsp/showImage.jsp?file=<%=StringUtils.defaultIfEmpty(tour.getExt_1(), "0")  %>" alt="" width="80" height="80" />
							<%} else { %>
			            	<img id="ext_2_photo" src="${ctx }/share/jsp/showImage.jsp?file=<%=StringUtils.defaultIfEmpty(tour.getExt_2(), "0")  %>" alt="" width="80" height="80" />
			            	<%}} %>
		              	</td>
		     		</tr>
		     		<tr>
		              	<td class="center" style=""><%=(emp_id_d==0?"N/A":Global.employeeInfoMap.get(emp_id_d).getZh_name()) %></td>
		              	<td class="center" style=""><%=tourRecordD==null?"N/A":StringUtils.defaultIfEmpty(tourRecordD.getExt_3(),"N/A") %></td>
		              	<td class="center" style="">
		              		<%if(tourRecordD==null){ %>
		              		N/A
		              		<%}else{ 
		              		if(tourRecordD.getStatus()==1){
		              		%>
							<img id="ext_1_photo" src="${ctx }/share/jsp/showImage.jsp?file=<%=StringUtils.defaultIfEmpty(tour.getExt_1(), "0")  %>" alt="" width="80" height="80" />
							<%} else { %>
			            	<img id="ext_2_photo" src="${ctx }/share/jsp/showImage.jsp?file=<%=StringUtils.defaultIfEmpty(tour.getExt_2(), "0")  %>" alt="" width="80" height="80" />
			            	<%}} %>
		              	</td>
		     		</tr>
		     	<%}
		     	}else{ %>
		     	<tr>
		     		<td colspan="4">无数据</td>
		     	</tr>
		     	<%} %>
		   		</tbody>
			</table>
		</div><!--widgetcontent-->	
	</div><!--widgetbox-->
	
	<div class="widgetbox">
		<div  class="shadowdiv" style="margin:5px;">
			<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
				<colgroup>
					<col class="con0" />
					<col class="con0" />
					<col class="con0" />
					<col class="con0" />
				</colgroup>
				<thead>
					<tr style="font-size:18px;">
		            	<th class="head0" colspan="3">
		            		<div style="margin: 5px;">Face To face board</div>
		            	</th>
		               	<th class="head0" ><a style="cursor:pointer" >N-1/N-2</a></th>
					</tr>
					<tr>
		            	<td class="head0" colspan="4">
		            		<div style="margin: 5px 35px 5px 5px;float: right"><span style="font-size:16px;font-weight: bold;">Date</span>&nbsp;&nbsp;<%=report_date %></div>
		            		<div style="margin: 5px 35px 5px 5px;float: right"><span style="font-size:16px;font-weight: bold;">Department</span>&nbsp;&nbsp;<%=Global.departmentInfoMap.get(dept_id).getDept_code() %></div>
		            	</td>
					</tr>
					<tr>
		            	<th class="head0" style="width:25%"><a style="cursor:pointer" >Stop</a></th>
		               	<th class="head0" style="width:25%"><a style="cursor:pointer" >Situation</a></th>
		               	<th class="head0" style="width:25%"><a style="cursor:pointer" >Action</a></th>
		               	<th class="head0" style="width:25%"><a style="cursor:pointer" >Status</a></th>
					</tr>
				</thead>
				<tbody>
				<%if(tourList!=null&&!tourList.isEmpty()){ 
					for(Tour tour:tourList){
						int emp_id_u = 0,emp_id_d = 0;
						TourRecord tourRecordU = null,tourRecordD = null;
						emp_id_u = tour.getEmp_id_2();
						emp_id_d = tour.getEmp_id_3(); 
						tourRecordU = tourRecordService.queryObject(sdfA.parse(report_date), 2, tour.getId());
						tourRecordD = tourRecordService.queryObject(sdfA.parse(report_date), 3, tour.getId());
				%>
		        	<tr>
		              	<td class="center" style="" rowspan='3'><%=StringUtils.defaultIfEmpty(tour.getExt_4(), "-") %></td>
		              	<td class="center" style=""><%=(emp_id_u==0?"N/A":Global.employeeInfoMap.get(emp_id_u).getZh_name()) %></td>
		              	<td class="center" style=""><%=tourRecordU==null?"N/A":StringUtils.defaultIfEmpty(tourRecordU.getExt_3(),"N/A") %></td>
		              	<td class="center" style="">
		              		<%if(tourRecordU==null){ %>
		              		N/A
		              		<%}else{ 
		              		if(tourRecordU.getStatus()==1){
		              		%>
							<img id="ext_1_photo" src="${ctx }/share/jsp/showImage.jsp?file=<%=StringUtils.defaultIfEmpty(tour.getExt_1(), "0")  %>" alt="" width="80" height="80" />
							<%} else { %>
			            	<img id="ext_2_photo" src="${ctx }/share/jsp/showImage.jsp?file=<%=StringUtils.defaultIfEmpty(tour.getExt_2(), "0")  %>" alt="" width="80" height="80" />
			            	<%}} %>
		              	</td>
		     		</tr>
		     		<tr>
		              	<td class="center" style=""><%=(emp_id_d==0?"N/A":Global.employeeInfoMap.get(emp_id_d).getZh_name()) %></td>
		              	<td class="center" style=""><%=tourRecordD==null?"N/A":StringUtils.defaultIfEmpty(tourRecordD.getExt_3(),"N/A") %></td>
		              	<td class="center" style="">
		              		<%if(tourRecordD==null){ %>
		              		N/A
		              		<%}else{ 
		              		if(tourRecordD.getStatus()==1){
		              		%>
							<img id="ext_1_photo" src="${ctx }/share/jsp/showImage.jsp?file=<%=StringUtils.defaultIfEmpty(tour.getExt_1(), "0")  %>" alt="" width="80" height="80" />
							<%} else { %>
			            	<img id="ext_2_photo" src="${ctx }/share/jsp/showImage.jsp?file=<%=StringUtils.defaultIfEmpty(tour.getExt_2(), "0")  %>" alt="" width="80" height="80" />
			            	<%}} %>
		              	</td>
		     		</tr>
		     	<%}
		     	}else{ %>
		     	<tr>
		     		<td colspan="4">无数据</td>
		     	</tr>
		     	<%} %>
		   		</tbody>
			</table>
		</div><!--widgetcontent-->	
	</div><!--widgetbox-->	