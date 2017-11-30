<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String begin_month = StringUtils.defaultIfEmpty(request.getParameter("begin_month"), "");
	String end_month = StringUtils.defaultIfEmpty(request.getParameter("end_month"), "");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	SimpleDateFormat sdf1 = new SimpleDateFormat(Global.DATE_FORMAT_STR_D);
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	AuditRankingService auditRankingService = (AuditRankingService) ctx.getBean("auditRankingService");
	Calendar cal = Calendar.getInstance();
	
	int begin_month_first = 0,end_month_first = 0;
	int begin_month_second = 0,end_month_second = 0;
	int begin_month_third = 0,end_month_third = 0;
	Date begin_date_first = null,end_date_first = null;
	Date begin_date_second = null,end_date_second = null;
	Date begin_date_third = null,end_date_third = null;
	if(!StringUtils.isEmpty(begin_month)&&!StringUtils.isEmpty(end_month)){
		begin_date_third = sdf.parse(begin_month);
		end_date_third = sdf.parse(end_month);
		begin_month_third = Util.getYearOrMonthOrDay(begin_date_third,"m");
		end_month_third = Util.getYearOrMonthOrDay(end_date_third,"m");
		
		begin_date_second = Util.addDate(begin_date_third,"m", -2);
		end_date_second = Util.addDate(end_date_third,"m", -2);
		begin_month_second = Util.getYearOrMonthOrDay(begin_date_second,"m");
		end_month_second = Util.getYearOrMonthOrDay(end_date_second,"m");
		
		begin_date_first = Util.addDate(begin_date_second,"m", -2);
		end_date_first = Util.addDate(end_date_second,"m", -2);
		begin_month_first = Util.getYearOrMonthOrDay(begin_date_first,"m");
		end_month_first = Util.getYearOrMonthOrDay(end_date_first,"m");
	}
	
	
	Page page1 = new Page();
	page1.setPageIndex(1);
	page1.setPageSize(1000);
	page1.setTotalCount(1000);
	page1.setSidx("over_all");
	page1.setSord("desc");
	AuditRanking tmpSR = new AuditRanking();
	tmpSR.setBegin_month(sdf1.parse(begin_month));
	tmpSR.setEnd_month(sdf1.parse(end_month));
	List<AuditRanking> result1 = auditRankingService.findByCondition(tmpSR,page1);	
%>
			<div class="widgetbox">
				<div class="title"><h4>主管团队绩效历史排行榜</h4></div>
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
                                    <th class="head0" rowspan="2" >GL班长<br/>Supervisor</th>
                                    <th class="head0" rowspan="2" ><%=begin_month_first+"-"+end_month_first %>月<br/><%=Global.month_en[begin_month_first-1]+"-"+Global.month_en[end_month_first-1] %></th>
                                    <th class="head0" rowspan="2" ><%=begin_month_second+"-"+end_month_second %>月<br/><%=Global.month_en[begin_month_second-1]+"-"+Global.month_en[end_month_second-1] %></th>
                                    <th class="head0" rowspan="2" ><%=begin_month_third+"-"+end_month_third %>月<br/><%=Global.month_en[begin_month_third-1]+"-"+Global.month_en[end_month_third-1] %></th>
                                    <th class="head0" rowspan="2" >趋势<br/>Trend</th>
                                </tr>
                            </thead>
                            <tbody>
                            	
                                <%
                                if(result1!=null&&!result1.isEmpty()){
                                for(int i=0;i<result1.size();i++){ 
                            		AuditRanking sr = result1.get(i);
                            		AuditRanking firstSR = auditRankingService.queryByReportDate(sr.getDept_id(),begin_date_first , end_date_first);
                            		AuditRanking secondSR = auditRankingService.queryByReportDate(sr.getDept_id(),begin_date_second , end_date_second);
                            		double first_data = (firstSR==null?0:firstSR.getOver_all());
                            		double second_data = (secondSR==null?0:secondSR.getOver_all());
                            	%>
                                <tr>
                                    <td><%=sr.getGl() %></td>
                                    <td><%=first_data %></td>
                                    <td><%=second_data %></td>
                                    <td><%=sr.getOver_all() %></td>
                                    <td><div class="<%=sr.getOver_all()>second_data?"green_circle":(sr.getOver_all()==second_data?"yellow_circle":(sr.getOver_all()<second_data?"red_circle":""))%>"></div></td>
                                </tr>
                                <%}}else{ %>
                                <tr>
                                    <td colspan="5">无数据</td>
                                </tr>
                                <%} %>
                            </tbody>
                        </table>
				</div><!--widgetcontent-->
			</div>