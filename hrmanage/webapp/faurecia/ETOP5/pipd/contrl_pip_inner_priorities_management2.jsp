<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String begin_month = StringUtils.defaultIfEmpty(request.getParameter("begin_month"), "");
	String end_month = StringUtils.defaultIfEmpty(request.getParameter("end_month"), "");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	SimpleDateFormat sdf1 = new SimpleDateFormat(Global.DATE_FORMAT_STR_D);
	Calendar cal = Calendar.getInstance();
	if(StringUtils.isEmpty(begin_month)||StringUtils.isEmpty(end_month)){
		end_month = sdf1.format(cal.getTime())+"";
		begin_month = sdf1.format(Util.addDate(cal.getTime(),"m", -1))+"";
	}
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	PipdPrioritiesManagementService pipdPrioritiesManagementService = (PipdPrioritiesManagementService) ctx.getBean("pipdPrioritiesManagementService");
	
	PipdPrioritiesManagement pipdPrioritiesManagement = new PipdPrioritiesManagement();
	pipdPrioritiesManagement.setState(1);
	pipdPrioritiesManagement.setBegin_month(sdf.parse(begin_month+"-01 00:00:00"));
	pipdPrioritiesManagement.setEnd_month(sdf.parse(end_month+"-01 00:00:00"));
	List<PipdPrioritiesManagement> list = pipdPrioritiesManagementService.findByCondition(pipdPrioritiesManagement,null);
%>
			<div class="widgetbox">
				<div class="widgetcontent">
					<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
						<colgroup>
							<col class="con0" width="10%" />
							<col class="con0" width="27%" />
							<col class="con0" width="11%" />
							<col class="con0" width="11%" />
							<col class="con0" width="11%" />
							<col class="con0" width="6%" />
							<col class="con0" width="6%" />
							<col class="con0" width="6%" />
							<col class="con0" width="6%" />
							<col class="con0" width="6%" />
						</colgroup>
						<thead>
                                <tr>
                                    <th class="head0">Top<br />Priorities</th>
                                    <th class="head0">Macro<br />Activities</th>
                                    <th class="head0">Responsible</th>
                                    <th class="head0">Support</th>
                                    <th class="head0">Output<br />KPI</th>
                                    <th class="head0">Initial<br />16.6</th>
                                    <th class="head0">Actual<br />16.6</th>
                                    <th class="head0">Tgt 6m<br />16.12</th>
                                    <th class="head0">Tgt 12m<br />17.6</th>
                                    <th class="head0">Tgt 18m<br />17.12</th>
                                </tr>
                            </thead>
                            <tbody>
                            	<%
				            	if(list!=null&&list.size()>0){ 
				            		for(int i=0;i<list.size();i++){
				            			PipdPrioritiesManagement pd = list.get(i);
				            	%>
                                <tr>
                                    <td><%=pd.getType() %></td>
                                    <td class="center"><%=StringUtils.defaultIfEmpty(pd.getKpi_v3(), "") %></td>
                                    <td class="center"><%=StringUtils.defaultIfEmpty(pd.getKpi_v4(), "") %></td>
                                    <td class="center"><%=StringUtils.defaultIfEmpty(pd.getKpi_v5(), "") %></td>
                                    <td class="center"><%=StringUtils.defaultIfEmpty(pd.getKpi_v6(), "") %></td>
                                    <td class="center"><%=StringUtils.defaultIfEmpty(pd.getKpi_v7(), "") %></td>
                                    <td class="center"><%=StringUtils.defaultIfEmpty(pd.getKpi_v8(), "") %></td>
                                    <td class="center"><%=StringUtils.defaultIfEmpty(pd.getKpi_v9(), "") %></td>
                                    <td class="center"><%=StringUtils.defaultIfEmpty(pd.getKpi_v10(), "") %></td>
                                	<td class="center"><%=StringUtils.defaultIfEmpty(pd.getKpi_v11(), "") %></td>
                                </tr>
                                <%} 
				            	}else{%>
				            	<tr>
				                    <td colspan="10">无数据</td>
				                </tr>
				            	<%} %>
                            </tbody>
                        </table>
				</div><!--widgetcontent-->
			</div><!--widgetbox-->
