<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	ManagementScheduleService managementScheduleService = (ManagementScheduleService) ctx.getBean("managementScheduleService");
	SimpleDateFormat sdfA = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
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
				<div class="title"><h4>Management Team &nbsp;|&nbsp;Week:<%=cal.get(Calendar.WEEK_OF_YEAR) %></h4></div>
				<div class="widgetcontent">
					<table cellpadding="0" cellspacing="0" border="0" class="stdtable" style="border-collapse:collapse;">
						<colgroup>
							<col class="con0" width="10%" />
							<col class="con0" width="5%" />
							<col class="con0" width="13%" />
							<col class="con0" width="5%" />
							<col class="con0" width="13%" />
							<col class="con0" width="5%" />
							<col class="con0" width="13%" />
							<col class="con0" width="5%" />
							<col class="con0" width="13%" />
							<col class="con0" width="5%" />
							<col class="con0" width="13%" />
						</colgroup>
						<thead>
                        	<tr>
                                    <th class="head0" rowspan="2" >Name/Week</th>
                                    <th class="head0" colspan="2" >Monday</th>
                                    <th class="head0" colspan="2" >Tuesday</th>
                                    <th class="head0" colspan="2" >Wednesday</th>
                                    <th class="head0" colspan="2" >Thursday</th>
                                    <th class="head0" colspan="2" >Friday</th>
                                </tr>
                                <tr>
                                    <th class="head0" colspan="2" ><%=weekDays.get(0) %></th>
                                    <th class="head0" colspan="2" ><%=weekDays.get(1) %></th>
                                    <th class="head0" colspan="2" ><%=weekDays.get(2) %></th>
                                    <th class="head0" colspan="2" ><%=weekDays.get(3) %></th>
                                    <th class="head0" colspan="2" ><%=weekDays.get(4) %></th>
                                </tr>
                            </thead>
                            <tbody>
                            	<%
                            	if(nameList!=null&&!nameList.isEmpty()){
                            	for(ManagementSchedule ei:nameList) {
                            		String am1="Anting Plant",am2="Anting Plant",am3="Anting Plant",am4="Anting Plant",am5="Anting Plant";
                            		String pm1="Anting Plant",pm2="Anting Plant",pm3="Anting Plant",pm4="Anting Plant",pm5="Anting Plant";
                            		String backup1="-",backup2="-",backup3="-",backup4="-",backup5="-";
                            		for(int i=0;i<weekDays.size();i++){
                                    	String weekDay = weekDays.get(i);
                                    	if(i>4)continue;
                                    	ManagementSchedule tTmp = managementScheduleService.queryByNameAndDate(ei.getTb_name(),sdfA.parse(weekDay));
                                    	if(tTmp!=null){
                                    		if(i==0){
                                    			am1=StringUtils.defaultIfEmpty(tTmp.getTb_status_am(), "Anting Plant");
                                    			pm1=StringUtils.defaultIfEmpty(tTmp.getTb_status_pm(), "Anting Plant");
                                    			backup1=StringUtils.defaultIfEmpty(tTmp.getTb_backup(), "-");
                                    		}else if(i==1){
                                    			am2=StringUtils.defaultIfEmpty(tTmp.getTb_status_am(), "Anting Plant");
                                    			pm2=StringUtils.defaultIfEmpty(tTmp.getTb_status_pm(), "Anting Plant");
                                    			backup2=StringUtils.defaultIfEmpty(tTmp.getTb_backup(), "-");
                                    		}else if(i==2){
                                    			am3=StringUtils.defaultIfEmpty(tTmp.getTb_status_am(), "Anting Plant");
                                    			pm3=StringUtils.defaultIfEmpty(tTmp.getTb_status_pm(), "Anting Plant");
                                    			backup3=StringUtils.defaultIfEmpty(tTmp.getTb_backup(), "-");
                                    		}else if(i==3){
                                    			am4=StringUtils.defaultIfEmpty(tTmp.getTb_status_am(), "Anting Plant");
                                    			pm4=StringUtils.defaultIfEmpty(tTmp.getTb_status_pm(), "Anting Plant");
                                    			backup4=StringUtils.defaultIfEmpty(tTmp.getTb_backup(), "-");
                                    		}else if(i==4){
                                    			am5=StringUtils.defaultIfEmpty(tTmp.getTb_status_am(), "Anting Plant");
                                    			pm5=StringUtils.defaultIfEmpty(tTmp.getTb_status_pm(), "Anting Plant");
                                    			backup5=StringUtils.defaultIfEmpty(tTmp.getTb_backup(), "-");
                                    		}
                                    	}
                                    }
                                    
                            	%>
                                <tr>
                                    <td rowspan="3" style="font-weight: bold;"><%=ei.getTb_name() %></td>
                                    <td style="font-weight: bold;">AM</td>
                                    <td style="background-color: <%=!am1.equals("Anting Plant")?"#FFFFB9":"" %>"><%=am1 %></td>
                                    <td style="font-weight: bold;">AM</td>
                                    <td style="background-color: <%=!am2.equals("Anting Plant")?"#FFFFB9":"" %>"><%=am2 %></td>
                                    <td style="font-weight: bold;">AM</td>
                                    <td style="background-color: <%=!am3.equals("Anting Plant")?"#FFFFB9":"" %>"><%=am3 %></td>
                                    <td style="font-weight: bold;">AM</td>
                                    <td style="background-color: <%=!am4.equals("Anting Plant")?"#FFFFB9":"" %>"><%=am4 %></td>
                                    <td style="font-weight: bold;">AM</td>
                                    <td style="background-color: <%=!am5.equals("Anting Plant")?"#FFFFB9":"" %>"><%=am5 %></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">PM</td>
                                    <td style="background-color: <%=!pm1.equals("Anting Plant")?"#FFFFB9":"" %>"><%=pm1 %></td>
                                    <td style="font-weight: bold;">PM</td>
                                    <td style="background-color: <%=!pm2.equals("Anting Plant")?"#FFFFB9":"" %>"><%=pm2 %></td>
                                    <td style="font-weight: bold;">PM</td>
                                    <td style="background-color: <%=!pm3.equals("Anting Plant")?"#FFFFB9":"" %>"><%=pm3 %></td>
                                    <td style="font-weight: bold;">PM</td>
                                    <td style="background-color: <%=!pm4.equals("Anting Plant")?"#FFFFB9":"" %>"><%=pm4 %></td>
                                    <td style="font-weight: bold;">PM</td>
                                    <td style="background-color: <%=!pm5.equals("Anting Plant")?"#FFFFB9":"" %>"><%=pm5 %></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Backup</td>
                                    <td><%=backup1 %></td>
                                    <td style="font-weight: bold;">Backup</td>
                                    <td><%=backup2 %></td>
                                    <td style="font-weight: bold;">Backup</td>
                                    <td><%=backup3 %></td>
                                    <td style="font-weight: bold;">Backup</td>
                                    <td><%=backup4 %></td>
                                    <td style="font-weight: bold;">Backup</td>
                                    <td><%=backup5 %></td>
                                </tr>   
                                <%}} %>
                            </tbody>
                        </table>
				</div><!--widgetcontent-->
			</div><!--widgetbox-->