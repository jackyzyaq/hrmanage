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
		begin_month = sdf1.format(Util.addDate(cal.getTime(),"m", -2))+"";
	}
	begin_month = begin_month+"-01 00:00:00";
	end_month = end_month+"-01 00:00:00";
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	AuditRankingService auditRankingService = (AuditRankingService) ctx.getBean("auditRankingService");
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
	
	tmpSR.setType(Global.audit_ranking_type[0]);
	tmpSR = auditRankingService.queryByHeaderType(tmpSR.getBegin_month(),tmpSR.getEnd_month());
	
%>
		<script type="text/javascript">
		function stdRanking(obj){
			//alert($("body table #fes_tbody tr td:nth-child(7)").html());
			var stdOverAll = obj.value;
			if(stdOverAll.Trim().length>0&&isNumeric(stdOverAll)){
				var valForm = $("body table #fes_tbody tr").find("*");
				$.each(valForm,function(i,v){
					if($(this).attr('id')=='over_all_value'){
					
						if(parseFloat($(this).text())>parseFloat(stdOverAll)){
							$(this).next().html("<div class=\"green_circle\"></div>");
						}else if(parseFloat($(this).text())==parseFloat(stdOverAll)){
							$(this).next().html("<div class=\"yellow_circle\"></div>");
						}else if(parseFloat($(this).text())<parseFloat(stdOverAll)){
							$(this).next().html("<div class=\"red_circle\"></div>");
						}
						
						
					}
				});
				$("#std_over_all").click(function(){
					//alert($(this).val());
				});
			}
		}
		</script>	
		<script type="text/javascript" src="${ctx }/faurecia/ETOP5/js/etop5.js"></script>
		<div class="two_third left">
			<div class="widgetbox">
				<div class="title"><h4>月审核分数及排名&nbsp;|&nbsp;<%=(begin_month.split("-")[1]+"~"+end_month.split("-")[1])%>&nbsp;月&nbsp;[<a id="add_data" style="cursor:pointer;font-size:20px;" onclick="validateEtopPwd('${ctx}/faurecia/ETOP5/number/data/audit_ranking_add.jsp?menu_id=<%=menu_id %>','月审核分数及排名添加');">&nbsp;+&nbsp;</a>]</h4></div>
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
						</colgroup>
						<thead>
                                <tr>
                                    <th class="head0" >GAP</th>
                                    <th class="head0" >GL班长</th>
                                    <th class="head0"><%=(tmpSR!=null&&!StringUtils.isEmpty(tmpSR.getHeader_1())?tmpSR.getHeader_1():" ") %></th>
									<th class="head0"><%=(tmpSR!=null&&!StringUtils.isEmpty(tmpSR.getHeader_2())?tmpSR.getHeader_2():" ") %></th>
									<th class="head0"><%=(tmpSR!=null&&!StringUtils.isEmpty(tmpSR.getHeader_3())?tmpSR.getHeader_3():" ") %></th>
									<th class="head0"><%=(tmpSR!=null&&!StringUtils.isEmpty(tmpSR.getHeader_4())?tmpSR.getHeader_4():" ") %></th>
								 	<th class="head0" >Overall</th>
                                    <th class="head0" >
                                    	Status<br/>
                                    	<input style="width: 40px;" type="text" id="std_over_all" name="std_over_all" value="" onblur="stdRanking(this);"/>
                                    </th>
                                </tr>
                            </thead>
                            <tbody id="fes_tbody">
                            	<%if(result1!=null&&!result1.isEmpty()){ 
                            		for(int i=0;i<result1.size();i++){
                            			AuditRanking ar = result1.get(i);
                            	%>
                                <tr>
                                    <td><%=ar.getDept_name() %></td>
                                    <td><%=ar.getGl() %></td>
                                    <td><%=ar.getKpi_1() %></td>
                                    <td><%=ar.getKpi_2() %></td>
                                    <td><%=ar.getKpi_3() %></td>
                                    <td><%=ar.getKpi_4() %></td>
                                    <td id="over_all_value"><%=ar.getOver_all() %></td>
                                    <td><div class="green_circle"></div></td>
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
			<jsp:include page="/faurecia/ETOP5/number/fes_inner_right.jsp" flush="true">
				<jsp:param value="<%=begin_month %>" name="begin_month"/>
				<jsp:param value="<%=end_month %>" name="end_month"/>
			</jsp:include>			
		</div>