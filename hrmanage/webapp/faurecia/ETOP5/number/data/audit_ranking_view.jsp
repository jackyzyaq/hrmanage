<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	String type = StringUtils.defaultIfEmpty(request.getParameter("type"), "");
	String sub_type = StringUtils.defaultIfEmpty(request.getParameter("sub_type"), "");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	SimpleDateFormat sdf1 = new SimpleDateFormat(Global.DATE_FORMAT_STR_D);
	String begin_month = StringUtils.defaultIfEmpty(request.getParameter("begin_month"),"");
	String end_month = StringUtils.defaultIfEmpty(request.getParameter("end_month"),"");
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	AuditRankingService auditRankingService = (AuditRankingService) ctx.getBean("auditRankingService");
	
	AuditRanking sr = new AuditRanking();
	sr.setType(Global.audit_ranking_type[0]);
	sr.setBegin_month(sdf.parse(begin_month));
	sr.setEnd_month(sdf.parse(end_month));
	List<AuditRanking> list = auditRankingService.findByCondition(sr,null);
	
	sr = auditRankingService.queryByHeaderType(sr.getBegin_month(),sr.getEnd_month());
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
			                    <th class="head0">序号</th>
			                    <th class="head0">GAP</th>
			                    <th class="head0">班长</th>
			                    <th class="head0">月份</th>
			                    <th class="head1"><%=(sr!=null&&!StringUtils.isEmpty(sr.getHeader_1())?sr.getHeader_1():" ") %></th>
								<th class="head1"><%=(sr!=null&&!StringUtils.isEmpty(sr.getHeader_2())?sr.getHeader_2():" ") %></th>
								<th class="head1"><%=(sr!=null&&!StringUtils.isEmpty(sr.getHeader_3())?sr.getHeader_3():" ") %></th>
								<th class="head1"><%=(sr!=null&&!StringUtils.isEmpty(sr.getHeader_4())?sr.getHeader_4():" ") %></th>
								<th class="head1">总分</th>
								<th class="head0">操作者</th>
			                    <th class="head0">录入时间</th>
			                </tr>
			            </thead>
			            <tbody>
			            	<%
			            	if(list!=null&&list.size()>0){ 
			            		for(int i=0;i<list.size();i++){
			            			AuditRanking pd = list.get(i);
			            	%>
			            	<tr>
			                    <td><%=(i+1) %></td>
			                    <td><%=StringUtils.defaultIfEmpty(pd.getDept_name(), "") %></td>
			                    <td><%=StringUtils.defaultIfEmpty(pd.getGl(), "") %></td>
			                    <td><%=sdf1.format(pd.getBegin_month())+"~"+sdf1.format(pd.getEnd_month()) %></td>
			                    <td><%=pd.getKpi_1() %></td>
			                    <td><%=pd.getKpi_2() %></td>
			                    <td><%=pd.getKpi_3()%></td>
			                    <td><%=pd.getKpi_4()%></td>
			                    <td><%=pd.getOver_all()%></td>
			                    <td><%=pd.getOperater() %></td>
			                    <td><%=sdf.format(pd.getUpdate_date()) %></td>
			                </tr>
			            	<%} 
			            	}else{%>
			            	<tr>
			                    <td colspan="11">无数据</td>
			                </tr>
			            	<%} %>
			            </tbody>
			        </table>
			    </div><!--widgetcontent-->			
			</div>
		</div>
		<!--widgetbox-->