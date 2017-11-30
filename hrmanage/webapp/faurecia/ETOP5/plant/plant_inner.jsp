<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String level = StringUtils.defaultIfEmpty(request.getParameter("level"), "");
	String begin_year = StringUtils.defaultIfEmpty(request.getParameter("begin_year"), "");
	String type = StringUtils.defaultIfEmpty(request.getParameter("type"), "");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	SimpleDateFormat sdfD = new SimpleDateFormat(Global.DATE_FORMAT_STR_D);
	Calendar cal = Calendar.getInstance();
	if(StringUtils.isEmpty(begin_year)){
		begin_year = sdfD.format(cal.getTime());
	}
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	PlantService plantService = (PlantService) ctx.getBean("plantService");
	Page page1 = new Page();
	page1.setPageIndex(1);
	page1.setPageSize(1000);
	page1.setTotalCount(1000);
	//page1.setSidx("CHARINDEX(ext_1,'高,中,低')");
	page1.setSidx("id");
	page1.setSord("asc");
	Plant tmpSR = new Plant();
	tmpSR.setBegin_year(sdf.parse(begin_year+"-01"));
	tmpSR.setType(type);
	tmpSR.setState(1);
	tmpSR.setLevel1(level);
	List<Plant> result1 = plantService.findByCondition(tmpSR,page1);
	
%>
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/js/etop5.js"></script>
<script>
function down_file_plant(upload_uuid){
	click_href(ctx+'/share/jsp/showUploadFile.jsp?upload_uuid='+upload_uuid);
}
</script>
		<div class="widgetbox">
			<div class="title"><h4><%=level %> &nbsp;|&nbsp;[<a id="add_data" style="cursor:pointer;font-size:20px;" onclick="validateEtopPwd('${ctx}/faurecia/ETOP5/plant/data/plant_add.jsp?level=<%=level %>&menu_id=<%=menu_id %>&type=<%=type %>&begin_year=<%=begin_year %>','<%=type%>添加');">&nbsp;+&nbsp;</a>]</h4></div>
			<div class="widgetcontent">
				<div class="shadowdiv" style='margin:5px 5px 5px 5px;'>
					<table cellpadding='0' cellspacing='0' border='0' class='stdtable'>
							<thead>
								<tr>
								</tr>
							</thead>
						<tbody>
						<tr><td colspan='2'>
							<div class='widgetcontent userlistwidget nopadding'  style='cursor:pointer;'>
								<ul>
									<%
									if(result1!=null&&!result1.isEmpty()){
									for(int i=0;i<result1.size();i++){ 
										Plant p=result1.get(i);
									%>
									<li>
										<div class="info">
											<p style="text-indent:2em"><%=(i+1)%>.&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(p.getPlant(), "-") %>
											【<%=StringUtils.defaultIfEmpty(p.getHandler(), "-") %>】
											<%=p.getDatepoint()==null?"":"【"+sdf.format(p.getDatepoint())+"】" %>
											<%if(!StringUtils.isEmpty(p.getUpload_uuid())){ %>
											【<a style="cursor:pointer;" onclick="down_file_plant('<%=p.getUpload_uuid()%>')">下载</a>】
											<%} %>
											</p>
										</div><!--info-->
									</li>
									<%}}else{ %>
									<li>
										<div class="info">
											<p style="text-indent:2em">无数据</p>
										</div><!--info-->
									</li>
									<%} %>
								</ul>
							</div><!--widgetcontent-->
						</td></tr>
						</tbody>
					</table>
				</div>				
				
			</div><!--widgetcontent-->
		</div><!--widgetbox-->