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
	begin_month = begin_month+"-01 00:00:00";
	end_month = end_month+"-01 00:00:00";
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	SupervisorRankingService supervisorRankingService = (SupervisorRankingService) ctx.getBean("supervisorRankingService");
	Page page1 = new Page();
	page1.setPageIndex(1);
	page1.setPageSize(1000);
	page1.setTotalCount(1000);
	page1.setSidx("over_all");
	page1.setSord("desc");
	SupervisorRanking tmpSR = new SupervisorRanking();
	tmpSR.setBegin_month(sdf1.parse(begin_month));
	tmpSR.setEnd_month(sdf1.parse(end_month));
	List<SupervisorRanking> result1 = supervisorRankingService.findByCondition(tmpSR,page1);
	
	tmpSR.setType(Global.supervisor_ranking_type[0]);
	tmpSR = supervisorRankingService.queryByHeaderType(tmpSR.getBegin_month(),tmpSR.getEnd_month());
	
%>
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/js/etop5.js"></script>
<div class="two_third left">
			<div class="widgetbox">
				<div class="title"><h4>团队绩效月排行榜 &nbsp;|&nbsp;<%=(begin_month.split("-")[1]+"~"+end_month.split("-")[1])%>&nbsp;月&nbsp;[<a id="add_data" style="cursor:pointer;font-size:20px;" onclick="validateEtopPwd('${ctx}/faurecia/ETOP5/number/data/supervisor_ranking_add.jsp?menu_id=<%=menu_id %>','主管团队绩效添加');">&nbsp;+&nbsp;</a>]</h4></div>
				<div class="widgetcontent">
					<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
						<colgroup>
							<col class="con0" width="4%" />
							<col class="con0" width="10%" />
							<col class="con0" width="10%" />
							<col class="con0" width="4%" />
							<col class="con0" width="12%" />
							<col class="con0" width="4%" />
							<col class="con0" width="14%" />
							<col class="con0" width="17%" />
							<col class="con0" width="18%" />
							<col class="con0" width="7%" />
						</colgroup>
						<thead>
                        	<tr>
                                    <th class="head0" rowspan="2" >名次<br/>Rank</th>
                                    <th class="head0" rowspan="2" >部门<br/>Department</th>
                                    <th class="head0" rowspan="2" >主管<br/>Supervisor</th>
                                    <th class="head0" colspan="6" >KPI</th>
                                    <th class="head0" rowspan="2" >总分<br/>Overall</th>
                                </tr>
                                <tr>
                                    <th class="head0"><%=(tmpSR!=null&&!StringUtils.isEmpty(tmpSR.getHeader_1())?tmpSR.getHeader_1():" ") %></th>
									<th class="head0"><%=(tmpSR!=null&&!StringUtils.isEmpty(tmpSR.getHeader_2())?tmpSR.getHeader_2():" ") %></th>
									<th class="head0"><%=(tmpSR!=null&&!StringUtils.isEmpty(tmpSR.getHeader_3())?tmpSR.getHeader_3():" ") %></th>
									<th class="head0"><%=(tmpSR!=null&&!StringUtils.isEmpty(tmpSR.getHeader_4())?tmpSR.getHeader_4():" ") %></th>
									<th class="head0"><%=(tmpSR!=null&&!StringUtils.isEmpty(tmpSR.getHeader_5())?tmpSR.getHeader_5():" ") %></th>
									<th class="head0"><%=(tmpSR!=null&&!StringUtils.isEmpty(tmpSR.getHeader_6())?tmpSR.getHeader_6():" ") %></th>
								
                                </tr>
                            </thead>
                            <tbody>
                            	<%if(result1!=null&&!result1.isEmpty()){ 
                            		for(int i=0;i<result1.size();i++){
                            			SupervisorRanking sr = result1.get(i);
                            	%>
                                <tr>
                                    <td><%=i+1 %></td>
                                    <td><%=sr.getDept_name() %></td>
                                    <td><%=sr.getSupervisor() %></td>
                                    <td><%=sr.getKpi_1() %></td>
                                    <td><%=sr.getKpi_2() %></td>
                                    <td><%=sr.getKpi_3() %></td>
                                    <td><%=sr.getKpi_4() %></td>
                                    <td><%=sr.getKpi_5() %></td>
                                    <td><%=sr.getKpi_6() %></td>
                                    <td><%=sr.getOver_all() %></td>
                                </tr>
                                <%}}else{ %>
                                <tr>
                                    <td colspan="10">无数据</td>
                                </tr>
                                <%} %>
                            </tbody>
                        </table>
				</div><!--widgetcontent-->
			</div><!--widgetbox-->	
		</div>
		<div class="one_third last">
			<jsp:include page="/faurecia/ETOP5/number/achievements_inner_right.jsp" flush="true">
				<jsp:param value="<%=begin_month %>" name="begin_month"/>
				<jsp:param value="<%=end_month %>" name="end_month"/>
			</jsp:include>
		</div>