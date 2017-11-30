<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	
	String begin_year = StringUtils.defaultIfEmpty(request.getParameter("begin_year"), "");
	String type = StringUtils.defaultIfEmpty(request.getParameter("type"), "");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	Calendar cal = Calendar.getInstance();
	if(StringUtils.isEmpty(begin_year)){
		begin_year = String.valueOf(cal.get(Calendar.YEAR));
	}
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	PlantService plantService = (PlantService) ctx.getBean("plantService");
	Page page1 = new Page();
	page1.setPageIndex(1);
	page1.setPageSize(1000);
	page1.setTotalCount(1000);
	page1.setSidx("id");
	page1.setSord("desc");
	Plant tmpSR = new Plant();
	tmpSR.setBegin_year(sdf.parse(begin_year+"-01-01"));
	tmpSR.setType(type);
	tmpSR.setState(1);
	List<Plant> result1 = plantService.findByCondition(tmpSR,page1);
	
%>
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/js/etop5.js"></script>
		<div class="widgetbox">
			<div class="title"><h4><%=type %> &nbsp;|&nbsp;[<a id="add_data" style="cursor:pointer;font-size:20px;" onclick="validateEtopPwd('${ctx}/faurecia/ETOP5/plant/data/plant_add.jsp?menu_id=<%=menu_id %>&type=<%=type %>&begin_year=<%=begin_year %>','<%=type%>添加');">&nbsp;+&nbsp;</a>]</h4></div>
			<div class="widgetcontent">
				<ul class="listthumb">
					<%for(Plant p:result1){ %>
                	<li style="font-size: medium;"><img src="${ctx }/js/ama/images/blacktrans.png" alt="" /> <a href=""><%=p.getPlant() %></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                		<%if(!StringUtils.isEmpty(p.getUpload_uuid())){%>
                			<a style="cursor:pointer;" onclick="down_file('<%=p.getUpload_uuid()%>');">【下载】</a>
                		<%} %>
                	</li>
                	<%} %>
               	</ul>
			</div><!--widgetcontent-->
		</div><!--widgetbox-->