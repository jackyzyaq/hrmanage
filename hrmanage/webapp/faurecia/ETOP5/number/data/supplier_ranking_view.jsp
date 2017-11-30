<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	String begin_month = StringUtils.defaultIfEmpty(request.getParameter("begin_month"), "1900-01-01 00:00:00");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	SimpleDateFormat sdf1 = new SimpleDateFormat(Global.DATE_FORMAT_STR_D);
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	SupplierRankingService supplierRankingService = (SupplierRankingService) ctx.getBean("supplierRankingService");
	
	SupplierRanking sr = new SupplierRanking();
	sr.setBegin_month(sdf.parse(begin_month));
	List<SupplierRanking> list = supplierRankingService.findByCondition(sr,null);
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
			                    <th class="head0">供应商</th>
			                    <th class="head0">月份</th>
								<th class="head1">数据</th>
								<th class="head0">操作者</th>
			                    <th class="head0">录入时间</th>
			                </tr>
			            </thead>
			            <tbody>
			            	<%
			            	if(list!=null&&list.size()>0){ 
			            		for(int i=0;i<list.size();i++){
			            			SupplierRanking pd = list.get(i);
			            	%>
			            	<tr>
			                    <td><%=(i+1) %></td>
			                    <td><%=StringUtils.defaultIfEmpty(pd.getSupplier(), "") %></td>
			                    <td><%=sdf1.format(pd.getBegin_month()) %></td>
			                    <td><%=pd.getKpi_1() %></td>
			                    <td><%=pd.getOperater() %></td>
			                    <td><%=sdf.format(pd.getUpdate_date()) %></td>
			                </tr>
			            	<%} 
			            	}else{%>
			            	<tr>
			                    <td colspan="6">无数据</td>
			                </tr>
			            	<%} %>
			            </tbody>
			        </table>
			    </div><!--widgetcontent-->			
			</div>
		</div>
		<!--widgetbox-->