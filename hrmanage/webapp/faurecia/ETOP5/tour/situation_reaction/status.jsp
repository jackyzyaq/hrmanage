<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String report_date = StringUtils.defaultIfEmpty(request.getParameter("report_date"), "");
	String tour_info_id = StringUtils.defaultIfEmpty(request.getParameter("tour_info_id"), "0");
	SimpleDateFormat sdfA = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	SimpleDateFormat sdfE = new SimpleDateFormat(Global.DATE_FORMAT_STR_E);
	SimpleDateFormat sdfB = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	if(StringUtils.isEmpty(report_date)){
		return ;
	}
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	TourService tourService = (TourService) ctx.getBean("tourService");
	Tour tour = tourService.queryById(Integer.parseInt(tour_info_id),null);
%>
<script type="text/javascript">
	$(function(){
		//line('status');
		status_24hour();
	});
	function status_24hour(){
		var _url = ctx+'/faurecia/ETOP5/tour/situation_reaction/status_24hour.jsp';
		var params = {};
		params['report_date']='<%=report_date%>';
		params['tour_info_id']='<%=tour_info_id%>';
		inner_html(_url,params,'tour_24hour',function(data){
			$("#tour_24hour").html(data);
		});
	}
	function status_inner_do(report_date,number,tour_info_id){
		showHtml('${ctx}/faurecia/ETOP5/tour/situation_reaction/status_inner_do.jsp?number='+number+'&tour_info_id='+tour_info_id+'&report_date='+report_date,
			'Status_Reply',600,200);
	}
</script>
<div style="margin-top:0px;background-color:#FDFFFF;margin-bottom: 5px;">
	<div id="tour_24hour" class="one_half"></div>
	<div class="one_half last">
		<div class="widgetbox" style="margin-top:5px;">
			<div>
				<div  class="shadowdiv"  style="margin:5px;">
					<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
						<colgroup>
							<col class="con0" style="width: 25%"/>
							<col class="con0" style="width: 25%"/>
							<col class="con0" style="width: 25%"/>
							<col class="con0" style="width: 25%"/>
						</colgroup>
						<thead>																									
							<tr>
								<th class="head0" colspan="4"><label class="td_t">Management Control Status Display</label><br/><label class="td_s">管理控制状态展示</label></th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td class="center"><label class="td_t">Control Point</label><br/><label class="td_s">控制点</label></td>
				        		<td class="center" colspan="3"><a style="cursor:pointer" ><%=StringUtils.defaultIfEmpty(tour.getZone(), "") %></a></td>
							</tr>
				        	<tr>
				           		<td class="center" rowspan="2"><label class="td_t">Criteria</label><br/><label class="td_s">标准</label></td>
				              	<td class="center" ><label class="td_s">描述</label></td>
				              	<td class="center" ><label class="td_s">OK</label></td>
				              	<td class="center" ><label class="td_s">NOK</label></td>
				     		</tr>
				     		<tr>
				              	<td class="center" style="height:50px;"><%=StringUtils.defaultIfEmpty(tour.getExt_3(), "") %></td>
				              	<td class="center" style="height:50px;"><img id="ext_1_photo" src="${ctx }/share/jsp/showImage.jsp?file=<%=StringUtils.defaultIfEmpty(tour.getExt_1(), "0")  %>" alt="" width="80" height="80" /></td>
				              	<td class="center" style="height:50px;"><img id="ext_2_photo" src="${ctx }/share/jsp/showImage.jsp?file=<%=StringUtils.defaultIfEmpty(tour.getExt_2(), "0")  %>" alt="" width="80" height="80" /></td>
				     		</tr>
				     		<%
				     		UserInfo user = (UserInfo)request.getSession().getAttribute("user");
							TourRecordService tourRecordService = (TourRecordService) ctx.getBean("tourRecordService");
							int dept_id = 0,emp_id = 0,number = 0;
							for(int i=1;i<=3;i++){
								if(i==1) {dept_id = tour.getDept_id_1();emp_id = tour.getEmp_id_1();number = 1;} else 
								if(i==2) {dept_id = tour.getDept_id_2();emp_id = tour.getEmp_id_2();number = 2;} else 
								if(i==3) {dept_id = tour.getDept_id_3();emp_id = tour.getEmp_id_3();number = 3;} 
								TourRecord tourRecord = tourRecordService.queryObject(sdfA.parse(report_date), i, Integer.parseInt(tour_info_id));
								if(tourRecord!=null){
						%>
						<tr>
							<td class="center" rowspan="2"><label class="td_t"><%=Global.departmentInfoMap.get(dept_id).getDept_code() %></label><br/><label class="td_s"><%=Global.employeeInfoMap.get(emp_id).getZh_name() %></label></td>
							<td class="center"><label class="td_s">CheckTime</label></td>
							<td class="center"><label class="td_s">Status</label></td>
							<td class="center"><label class="td_s">Reaction</label></td>
						</tr>
						<tr>
							<td class="center" style="height:50px;"><%=sdfB.format(tourRecord.getStatus_date()) %></td>
							<td class="center" style="height:50px;">
								<%if(tourRecord.getStatus()==1){ %>
								<img id="ext_1_photo" src="${ctx }/share/jsp/showImage.jsp?file=<%=StringUtils.defaultIfEmpty(tour.getExt_1(), "0")  %>" alt="" width="80" height="80" />
								<%} else { %>
				            	<img id="ext_2_photo" src="${ctx }/share/jsp/showImage.jsp?file=<%=StringUtils.defaultIfEmpty(tour.getExt_2(), "0")  %>" alt="" width="80" height="80" />
				            	<%} %>
				            </td>
							<td class="center" style="height:50px;"><%=StringUtils.defaultIfEmpty(tourRecord.getExt_3(),"-") %></td>
						</tr>
						<%}else{%>
						<tr>
							<td class="center" rowspan="2"><label class="td_s"><%=Global.departmentInfoMap.get(dept_id).getDept_code() %></label></td>
							<td class="center"><label class="td_s">CheckTime</label></td>
							<td class="center"><label class="td_s">Status</label></td>
							<td class="center"><label class="td_s">Reaction</label></td>
						</tr>
						<tr <%if(Integer.parseInt(user.getName())==emp_id){%>style="cursor:pointer;" onclick="status_inner_do('<%=report_date %>','<%=i %>','<%=tour_info_id%>');"<%} %>>
							<td class="center" style="height:50px;">-</td>
							<td class="center" style="height:50px;">-</td>
							<td class="center" style="height:50px;">-</td>
						</tr>
						<%}}%>
				   		</tbody>
					</table>
				</div><!--widgetcontent-->
			</div>
		</div><!--widgetbox-->	
	</div>
	<div class="clearall"></div>
</div>