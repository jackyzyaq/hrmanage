<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	SimpleDateFormat sdf1 = new SimpleDateFormat(Global.DATE_FORMAT_STR_D);
	
	String begin_month = StringUtils.defaultIfEmpty(request.getParameter("begin_month"),"");
	String end_month = StringUtils.defaultIfEmpty(request.getParameter("end_month"),"");
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	SupervisorRankingService supervisorRankingService = (SupervisorRankingService) ctx.getBean("supervisorRankingService");
	
	SupervisorRanking sr = new SupervisorRanking();
	sr.setType(Global.supervisor_ranking_type[0]);
	sr.setBegin_month(sdf.parse(begin_month));
	sr.setEnd_month(sdf.parse(end_month));
	List<SupervisorRanking> list = supervisorRankingService.findByCondition(sr,null);
	
	sr = supervisorRankingService.queryByHeaderType(sr.getBegin_month(),sr.getEnd_month());
%>
		<div id="data_view" class="widgetbox">
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
			                    <th class="head0">部门</th>
			                    <th class="head0">主管</th>
			                    <th class="head0">月份</th>
			                    <th class="head1"><%=(sr!=null&&!StringUtils.isEmpty(sr.getHeader_1())?sr.getHeader_1():" ") %></th>
								<th class="head1"><%=(sr!=null&&!StringUtils.isEmpty(sr.getHeader_2())?sr.getHeader_2():" ") %></th>
								<th class="head1"><%=(sr!=null&&!StringUtils.isEmpty(sr.getHeader_3())?sr.getHeader_3():" ") %></th>
								<th class="head1"><%=(sr!=null&&!StringUtils.isEmpty(sr.getHeader_4())?sr.getHeader_4():" ") %></th>
								<th class="head1"><%=(sr!=null&&!StringUtils.isEmpty(sr.getHeader_5())?sr.getHeader_5():" ") %></th>
								<th class="head1"><%=(sr!=null&&!StringUtils.isEmpty(sr.getHeader_6())?sr.getHeader_6():" ") %></th>
								<th class="head1">总分</th>
								<th class="head0">操作者</th>
			                    <th class="head0">录入时间</th>
			                </tr>
			            </thead>
			            <tbody>
			            	<%
			            	if(list!=null&&list.size()>0){ 
			            		for(int i=0;i<list.size();i++){
			            			SupervisorRanking pd = list.get(i);
			            	%>
			            	<tr>
			                    <td><%=StringUtils.defaultIfEmpty(pd.getDept_name(), "") %></td>
			                    <td><%=StringUtils.defaultIfEmpty(pd.getSupervisor(), "") %></td>
			                    <td><%=sdf1.format(pd.getBegin_month())+"~"+sdf1.format(pd.getEnd_month()) %></td>
			                    <td><%=pd.getKpi_1() %></td>
			                    <td><%=pd.getKpi_2() %></td>
			                    <td><%=pd.getKpi_3()%></td>
			                    <td><%=pd.getKpi_4()%></td>
			                    <td><%=pd.getKpi_5()%></td>
			                    <td><%=pd.getKpi_6()%></td>
			                    <td><%=pd.getOver_all()%></td>
			                    <td><%=pd.getOperater() %></td>
			                    <td><%=sdf.format(pd.getUpdate_date()).replace(" ", "<br/>") %></td>
			                </tr>
			            	<%} 
			            	}else{%>
			            	<tr>
			                    <td colspan="12">无数据</td>
			                </tr>
			            	<%} %>
			            </tbody>
			        </table>
			    </div><!--widgetcontent-->			
			</div>
		</div>
		<!--widgetbox-->