<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	String type = StringUtils.defaultIfEmpty(request.getParameter("type"), "");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	SimpleDateFormat sdf1 = new SimpleDateFormat(Global.DATE_FORMAT_STR_D);
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	PipdPrioritiesManagementService pipdPrioritiesManagementService = (PipdPrioritiesManagementService) ctx.getBean("pipdPrioritiesManagementService");
	
	PipdPrioritiesManagement pipdPrioritiesManagement = new PipdPrioritiesManagement();
	pipdPrioritiesManagement.setState(1);
	pipdPrioritiesManagement.setType(type);
	List<PipdPrioritiesManagement> list = pipdPrioritiesManagementService.findByCondition(pipdPrioritiesManagement,null);
%>
		<div class="widgetbox">
			<div>
			    <div class="widgetcontent padding0 statement">
			       <table cellpadding="0" cellspacing="0" border="0" class="stdtable">
			            <colgroup>
			                <col class="con0" />
			                <col class="con1" />
			                <col class="con0" />
			            </colgroup>
			            <thead>
			                <tr>
			                    <th class="head0">开始<br/>月份</th>
			                    <th class="head0">结束<br/>月份</th>
			                    <th class="head0">数据<br/>类型</th>
			                    <th class="head0">Breakthrough</th>
			                    <th class="head0">Daily<br/>Management</th>
			                    <th class="head0">Macro<br/>Activities</th>
			                    <th class="head0">Responsible</th>
			                    <th class="head0">Support</th>
			                    <th class="head0">Output<br/>KPI</th>
			                    <th class="head0">Initial<br/>16.6</th>
			                    <th class="head0">Actual<br/>16.6</th>
			                    <th class="head0">Tgt<br/>6m<br/>16.12</th>
			                    <th class="head0">Tgt<br/>12m<br/>17.6</th>
			                    <th class="head0">Tgt<br/>18m<br/>17.12</th>
			                    <th class="head1">操作者</th>
			                    <th class="head0">录入<br/>时间</th>
			                </tr>
			            </thead>
			            <tbody>
			            	<%
			            	if(list!=null&&list.size()>0){ 
			            		for(int i=0;i<list.size();i++){
			            			PipdPrioritiesManagement pd = list.get(i);
			            	%>
			            	<tr>
			                    <td><%=sdf1.format(pd.getBegin_month()) %></td>
			                    <td><%=sdf1.format(pd.getEnd_month()) %></td>
			                    <td><%=pd.getType() %></td>
			                    <td><%=StringUtils.defaultIfEmpty(pd.getKpi_v1(), "") %></td>
			                    <td><%=StringUtils.defaultIfEmpty(pd.getKpi_v2(), "") %></td>
			                    <td><%=StringUtils.defaultIfEmpty(pd.getKpi_v3(), "") %></td>
			                    <td><%=StringUtils.defaultIfEmpty(pd.getKpi_v4(), "") %></td>
			                    <td><%=StringUtils.defaultIfEmpty(pd.getKpi_v5(), "") %></td>
			                    <td><%=StringUtils.defaultIfEmpty(pd.getKpi_v6(), "") %></td>
			                    <td><%=StringUtils.defaultIfEmpty(pd.getKpi_v7(), "") %></td>
			                    <td><%=StringUtils.defaultIfEmpty(pd.getKpi_v8(), "") %></td>
			                    <td><%=StringUtils.defaultIfEmpty(pd.getKpi_v9(), "") %></td>
			                    <td><%=StringUtils.defaultIfEmpty(pd.getKpi_v10(), "") %></td>
			                    <td><%=StringUtils.defaultIfEmpty(pd.getKpi_v11(), "") %></td>
			                    <td><%=pd.getOperater() %></td>
			                    <td><%=sdf.format(pd.getUpdate_date()) %></td>
			                </tr>
			            	<%} 
			            	}else{%>
			            	<tr>
			                    <td colspan="16">无数据</td>
			                </tr>
			            	<%} %>
			            </tbody>
			        </table>
			    </div><!--widgetcontent-->			
			</div>
		</div>
		<!--widgetbox-->