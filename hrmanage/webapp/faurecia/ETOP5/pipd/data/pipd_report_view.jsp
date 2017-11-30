<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	String type = StringUtils.defaultIfEmpty(request.getParameter("type"), "");
	String sub_type = StringUtils.defaultIfEmpty(request.getParameter("sub_type"), "");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	SimpleDateFormat sdf1 = new SimpleDateFormat(Global.DATE_FORMAT_STR_D);
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	PipdReportService pipdReportService = (PipdReportService) ctx.getBean("pipdReportService");
	
	PipdReport pipdReport = new PipdReport();
	pipdReport.setState(1);
	pipdReport.setType(type);
	pipdReport.setSub_type(sub_type);
	List<PipdReport> list = pipdReportService.findByCondition(pipdReport,null);
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
			                    <th class="head0">开始月份</th>
			                    <th class="head0">结束月份</th>
			                    <th class="head0">数据类型</th>
			                    <th class="head0">类型2</th>
			                    <th class="head0">UPLOAD_PIC</th>
			                    <th class="head0">UPLOAD_FILE</th>
			                    <th class="head1">操作者</th>
			                    <th class="head0">录入时间</th>
			                </tr>
			            </thead>
			            <tbody>
			            	<%
			            	if(list!=null&&list.size()>0){ 
			            		for(int i=0;i<list.size();i++){
			            			PipdReport pd = list.get(i);
			            	%>
			            	<tr>
			                    <td><%=sdf1.format(pd.getBegin_month()) %></td>
			                    <td><%=sdf1.format(pd.getEnd_month()) %></td>
			                    <td><%=pd.getType() %></td>
			                    <td><%=pd.getSub_type() %></td>
			                    <td><img src="${ctx }/share/jsp/showImage.jsp?file=<%=pd.getUpload_uuid_pic() %>" width="18" height="18"/></td>
			                    <td><a href="javascript:click_href('${ctx }/share/jsp/showUploadFile.jsp?upload_uuid=<%=pd.getUpload_uuid()%>');"><img src="${ctx }/images/download.png" alt="" width="18" height="18" /></a></td>
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