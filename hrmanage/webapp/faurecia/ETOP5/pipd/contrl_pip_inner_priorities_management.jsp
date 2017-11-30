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
				<div class="title">
					<h4>
						Plant Top Priorities Management
						&nbsp;|&nbsp;
						<%=(begin_month+"~"+end_month)%>&nbsp;月	
						&nbsp;&nbsp;&nbsp;
						[<a style="cursor:pointer;font-size:20px;" onclick="parent.showHtml('${ctx}/faurecia/ETOP5/pipd/data/pipd_priorities_management_add.jsp?menu_id=<%=menu_id %>&begin_month=<%=begin_month %>&end_month=<%=end_month %>','添加',1024);">&nbsp;+&nbsp;</a>]
					</h4>
				</div>
				<div class="widgetcontent">
					<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
						<colgroup>
							<col class="con0" width="33%" />
							<col class="con0" width="33%" />
							<col class="con0" width="34%" />
						</colgroup>
						<thead>
                                <tr>
                                    <th class="head0">Plant Top Priorities<br />(18 months)</th>
                                    <th class="head0">Breakthrough</th>
                                    <th class="head0">Daily Management</th>
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
                                    <td class="center"><%=StringUtils.defaultIfEmpty(pd.getKpi_v1(), "") %></td>
                                    <td class="center"><%=StringUtils.defaultIfEmpty(pd.getKpi_v2(), "") %></td>
                                </tr>
                                <%} 
				            	}else{%>
				            	<tr>
				                    <td colspan="3">无数据</td>
				                </tr>
				            	<%} %>                                                                
                            </tbody>
                        </table>
				</div><!--widgetcontent-->
			</div><!--widgetbox--> 