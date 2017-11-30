<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String year = StringUtils.defaultIfEmpty(request.getParameter("year"), "");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	SimpleDateFormat sdf1 = new SimpleDateFormat(Global.DATE_FORMAT_STR_D);
	Calendar cal = Calendar.getInstance();
	if(StringUtils.isEmpty(year)){
		year = String.valueOf(cal.get(Calendar.YEAR));
	}
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	SupplierRankingService supplierRankingService = (SupplierRankingService) ctx.getBean("supplierRankingService");
	List<SupplierRanking> list = supplierRankingService.findSupplierMaxMonthSum();
%>
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/js/etop5.js"></script>
<div class="two_third left">
			<div class="widgetbox">
				<div class="title"><h4>&nbsp;供应商绩效管理&nbsp;|&nbsp;[<a id="add_data" style="cursor:pointer;font-size:20px;" onclick="validateEtopPwd('${ctx}/faurecia/ETOP5/number/data/supplier_ranking_add.jsp?menu_id=<%=menu_id %>','供应商绩效添加');">&nbsp;+&nbsp;</a>]</h4></div>
				<div class="widgetcontent">
					<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
						<colgroup>
							<col class="con0" width="20%" />
							<col class="con0" width="10%" />
							<col class="con0" width="10%" />
							<col class="con0" width="10%" />
							<col class="con0" width="10%" />
							<col class="con0" width="10%" />
							<col class="con0" width="10%" />
							<col class="con0" width="10%" />
							<col class="con0" width="10%" />
							<col class="con0" width="10%" />
							<col class="con0" width="10%" />
							<col class="con0" width="10%" />
							<col class="con0" width="10%" />
							<col class="con0" width="10%" />
						</colgroup>
						<thead>
                                <tr>
                                    <th class="head0" >Supplier</th>
                                    <%for(int i=0;i<Global.month_en.length;i++){ 
                                    	String en = Global.month_en[i];
                                    %>
                                    <th class="head0" ><a style="cursor:pointer;text-decoration:underline;" onclick="supplier_status('<%=year+"-"+(i+1)+"-01 00:00:00"%>');"><%=en %></a></th>
                                    <%} %>
                                    <th class="head0" >YTD Ranking</th>
                                </tr>
                            </thead>
                            <tbody>
                            	<%for(int i=0;i<list.size();i++){ 
                            		String supplier = StringUtils.defaultIfEmpty(list.get(i).getSupplier(), "");
                            		//double over_all = Util.formatDouble1(list.get(i).getKpi_1());
                            	%>
                                <tr>
                                    <td><%=supplier %></td>
                                    <%for(int month:Global.month){ 
										SupplierRanking sr = supplierRankingService.queryByReportDate(supplier, sdf1.parse(year+"-"+month+"-01"));
                                    %>
                                    <td><%=(sr==null?0.0:sr.getKpi_1()) %></td>
                                    <%} %>
                                    <td><%=(i+1) %></td>
                                </tr>
                                <%
                                } %>
                            </tbody>
                        </table>
				</div><!--widgetcontent-->
			</div><!--widgetbox-->	
		</div>
		<div class="one_third last" id="supplier_inner_right">
		</div>