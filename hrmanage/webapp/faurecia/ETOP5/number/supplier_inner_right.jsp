<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String begin_month = StringUtils.defaultIfEmpty(request.getParameter("begin_month"), "1900-01-01 00:00:00");
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	SupplierRankingService supplierRankingService = (SupplierRankingService) ctx.getBean("supplierRankingService");
	List<SupplierRanking> sr0 = supplierRankingService.queryStatusListByType(Global.supplier_ranking_type[0], sdf.parse(begin_month));
	List<SupplierRanking> sr1 = supplierRankingService.queryStatusListByType(Global.supplier_ranking_type[1], sdf.parse(begin_month));
	List<SupplierRanking> sr2 = supplierRankingService.queryStatusListByType(Global.supplier_ranking_type[2], sdf.parse(begin_month));
	List<SupplierRanking> sr3 = supplierRankingService.queryStatusListByType(Global.supplier_ranking_type[3], sdf.parse(begin_month));	
%>
			<div class="widgetbox">
				<div class="title"><h4>质量最佳供应商</h4></div>
				<div class="widgetcontent">
					<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
						<colgroup>
							<col class="con0" width="20%" />
							<col class="con0" width="20%" />
							<col class="con0" width="20%" />
							<col class="con0" width="20%" />
							<col class="con0" width="20%" />
						</colgroup>
						<thead>
                        	<tr>
                                    <th class="head0" rowspan="2" ></th>
                                    <th class="head0" rowspan="2" ></th>
                                </tr>
                            </thead>
                            <tbody>
                            	<%
                            	if(sr0!=null&&sr0.size()>0){
                            	for(SupplierRanking sr:sr0){ %>
                                <tr>
                                    <td><%=sr==null?"":sr.getSupplier() %></td>
                                    <td><%=sr==null?"":sr.getKpi_1() %></td>
                                </tr>
                                <%}} %>
                            </tbody>
                        </table>
				</div><!--widgetcontent-->
			</div>
			
			<div class="widgetbox">
				<div class="title"><h4>质量最差供应商</h4></div>
				<div class="widgetcontent">
					<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
						<colgroup>
							<col class="con0" width="20%" />
							<col class="con0" width="20%" />
							<col class="con0" width="20%" />
							<col class="con0" width="20%" />
							<col class="con0" width="20%" />
						</colgroup>
						<thead>
                        	<tr>
                                    <th class="head0" rowspan="2" ></th>
                                    <th class="head0" rowspan="2" ></th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                            	if(sr1!=null&&sr1.size()>0){
                            	for(SupplierRanking sr:sr1){ %>
                                <tr>
                                    <td><%=sr==null?"":sr.getSupplier() %></td>
                                    <td><%=sr==null?"":sr.getKpi_1() %></td>
                                </tr>
                                <%}} %>
                            </tbody>
                        </table>
				</div><!--widgetcontent-->
			</div>
			
			<div class="widgetbox">
				<div class="title"><h4>交付最佳供应商</h4></div>
				<div class="widgetcontent">
					<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
						<colgroup>
							<col class="con0" width="20%" />
							<col class="con0" width="20%" />
							<col class="con0" width="20%" />
							<col class="con0" width="20%" />
							<col class="con0" width="20%" />
						</colgroup>
						<thead>
                        	<tr>
                                    <th class="head0" rowspan="2" ></th>
                                    <th class="head0" rowspan="2" ></th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                            	if(sr2!=null&&sr2.size()>0){
                            	for(SupplierRanking sr:sr2){ %>
                                <tr>
                                    <td><%=sr==null?"":sr.getSupplier() %></td>
                                    <td><%=sr==null?"":sr.getKpi_1() %></td>
                                </tr>
                                <%}} %>
                            </tbody>
                        </table>
				</div><!--widgetcontent-->
			</div>
			
			<div class="widgetbox">
				<div class="title"><h4>交付最差供应商</h4></div>
				<div class="widgetcontent">
					<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
						<colgroup>
							<col class="con0" width="20%" />
							<col class="con0" width="20%" />
							<col class="con0" width="20%" />
							<col class="con0" width="20%" />
							<col class="con0" width="20%" />
						</colgroup>
						<thead>
                        	<tr>
                                    <th class="head0" rowspan="2" ></th>
                                    <th class="head0" rowspan="2" ></th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                            	if(sr3!=null&&sr3.size()>0){
                            	for(SupplierRanking sr:sr3){ %>
                                <tr>
                                    <td><%=sr==null?"":sr.getSupplier() %></td>
                                    <td><%=sr==null?"":sr.getKpi_1() %></td>
                                </tr>
                                <%}} %>
                            </tbody>
                        </table>
				</div><!--widgetcontent-->
			</div>