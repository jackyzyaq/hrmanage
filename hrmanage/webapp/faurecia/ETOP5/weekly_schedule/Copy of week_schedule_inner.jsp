<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	ManagementScheduleService managementScheduleService = (ManagementScheduleService) ctx.getBean("managementScheduleService");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	Calendar cal = Calendar.getInstance();
	String week = StringUtils.defaultIfEmpty(request.getParameter("week"), "");
	if(StringUtils.isEmpty(week)){
		week = String.valueOf(cal.get(Calendar.WEEK_OF_YEAR));
	}
	List<ManagementSchedule> nameList = managementScheduleService.queryNameByCondition();
	
	cal.set(Calendar.WEEK_OF_YEAR, Integer.parseInt(week));
	List<String> weekDays = Util.getWeekDays(cal.getTime());
%>
<div class="widgetbox">
				<div class="title"><h4>ManageMent team Weekly Schedule &nbsp;|&nbsp;Week:<%=cal.get(Calendar.WEEK_OF_YEAR) %></h4></div>
				<div class="widgetcontent">
					<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
						<colgroup>
							<col class="con0" width="10%" />
							<col class="con0" width="8%" />
							<col class="con0" width="8%" />
							<col class="con0" width="8%" />
							<col class="con0" width="8%" />
							<col class="con0" width="8%" />
							<col class="con0" width="8%" />
							<col class="con0" width="8%" />
							<col class="con0" width="8%" />
							<col class="con0" width="8%" />
							<col class="con0" width="8%" />
							<col class="con0" width="10%" />
						</colgroup>
						<thead>
                        	<tr>
                                    <th class="head0" rowspan="2" >Member</th>
                                    <th class="head0" colspan="2" >Mon</th>
                                    <th class="head0" colspan="2" >Tue</th>
                                    <th class="head0" colspan="2" >Wed</th>
                                    <th class="head0" colspan="2" >Thu</th>
                                    <th class="head0" colspan="2" >Fri</th>
                                    <th class="head0" rowspan="2" >Backup</th>
                                </tr>
                                <tr>
                                    <th class="head0" >AM</th>
                                    <th class="head0" >PM</th>
                                    <th class="head0" >AM</th>
                                    <th class="head0" >PM</th>
                                    <th class="head0" >AM</th>
                                    <th class="head0" >PM</th>
                                    <th class="head0" >AM</th>
                                    <th class="head0" >PM</th>
                                    <th class="head0" >AM</th>
                                    <th class="head0" >PM</th>
                                </tr>
                            </thead>
                            <tbody>
                            	<%
                            	if(nameList!=null&&!nameList.isEmpty()){
                            	for(ManagementSchedule ei:nameList) {
                            	%>
                                <tr>
                                    <td><%=ei.getTb_name() %></td>
                                    <%for(int i=0;i<weekDays.size();i++){
                                    	String weekDay = weekDays.get(i);
                                    	if(i>4)continue;
                                    	ManagementSchedule tTmp = managementScheduleService.queryByNameAndDate(ei.getTb_name(),sdf.parse(weekDay));
                                    	if(tTmp!=null){
                                    		String am = tTmp.getTb_status_am();
                                    		String pm = tTmp.getTb_status_pm();
                                    %>
                                    	<td><div class=<%=
                                    				am.equals(Global.management_schedule[0])?"green_circle":
	 												am.equals(Global.management_schedule[1])?"blue_circle":
	 												am.equals(Global.management_schedule[2])?"red_circle":"blue_circle"
                                    				%>></div></td>
                                    	<td><div class=<%=
                                    				pm.equals(Global.management_schedule[0])?"green_circle":
	 												pm.equals(Global.management_schedule[1])?"blue_circle":
	 												pm.equals(Global.management_schedule[2])?"red_circle":"blue_circle"
                                    				%>></div></td>
                                    <%	}else{ 
                                    %>
                                    	<td><div class="blue_circle"></div></td>
                                    	<td><div class="blue_circle"></div></td>	
                                    <%	} %>
                                    <%} %>
                                    <td></td>
                                </tr>
                                <%}} %>
                                <tr>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td><h4>On Duty</h4></td>
                                    <td><div class=green_circle></div></td>
                                    <td><h4>Travel</h4></td>
                                    <td><div class=blue_circle></div></td>
                                    <td><h4>Vacation</h4></td>
                                    <td><div class=red_circle></div></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>                                
                            </tbody>
                        </table>
				</div><!--widgetcontent-->
			</div><!--widgetbox-->