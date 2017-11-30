<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	SimpleDateFormat sdf1 = new SimpleDateFormat(Global.DATE_FORMAT_STR_D);
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	QRCIDataService qrciDataService = (QRCIDataService) ctx.getBean("qrciDataService");
	
	QRCIData qrciData = new QRCIData();
	qrciData.setState(1);
	List<QRCIData> list = qrciDataService.findByCondition(qrciData,null);
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
			                	<%for(String s:Global.qrci_head){ %>
			                    <th class="head0"><%=s %></th>
			                    <%} %>
			                    <th class="head0">Lls1<br/>pic</th>
			                    <th class="head0">Lls<br/>transversalization<br/>pic</th>
			                    <th class="head0">Lls<br/>daily<br/>tracking<br/>30<br/>days<br/>pic</th>
			                    <th class="head0">操作者</th>
			                    <th class="head0">更新时间</th>
			                </tr>
			            </thead>
			            <tbody>
			            	<%
			            	if(list!=null&&list.size()>0){ 
			            		for(int i=0;i<list.size();i++){
			            			QRCIData pd = list.get(i);
			            	%>
			            	<tr id="qrci_data_<%=pd.getId() %>" onclick="qrci_data_click_select(this);" title="点击可修改">
			            		<td id="id" style="display: none"><%=pd.getId() %></td>
			                    <td id="qrci_type"><%=StringUtils.defaultIfEmpty(pd.getQrci_type(), "") %></td>
			                    <td id="open_date"><%=StringUtils.defaultIfEmpty(pd.getOpen_date(), "") %></td>
			                    <td id="problem_descripion"><%=StringUtils.defaultIfEmpty(pd.getProblem_descripion(), "") %></td>
			                    <td id="respensible"><%=StringUtils.defaultIfEmpty(pd.getRespensible(), "") %></td>
			                    
			                    <td id="yesterday_task_to_be_checked">
			                    	<%
			                    	if(!StringUtils.isEmpty(pd.getYesterday_task_to_be_checked())){
			                    	for(String s:pd.getYesterday_task_to_be_checked().split("\\|")){
			                    		if(StringUtils.isEmpty(s))continue;
			                    	%>
			                    	<%=StringUtils.defaultIfEmpty(s, "")+"<br/>" %>
			                    	<%}} %>
			                    </td>
			                    <td id="task_for_next_day_future">
			                    	<%
			                    	if(!StringUtils.isEmpty(pd.getTask_for_next_day_future())){
			                    	for(String s:pd.getTask_for_next_day_future().split("\\|")){
			                    		if(StringUtils.isEmpty(s))continue;
			                    	%>
			                    	<%=StringUtils.defaultIfEmpty(s, "")+"<br/>" %>
			                    	<%}} %>
			                    </td>
			                    <td id="d3_24_hour">
			                    	<%
			                    	if(!StringUtils.isEmpty(pd.getD3_24_hour())){
			                    	for(String s:pd.getD3_24_hour().split("\\|")){
			                    		if(StringUtils.isEmpty(s))continue;
			                    	%>
			                    	<%=StringUtils.defaultIfEmpty(s, "")+"<br/>" %>
			                    	<%}} %>	
			                    </td>
			                    <td id="d6_10_day">
			                    	<%
			                    	if(!StringUtils.isEmpty(pd.getD6_10_day())){
			                    	for(String s:pd.getD6_10_day().split("\\|")){
			                    		if(StringUtils.isEmpty(s))continue;
			                    	%>
			                    	<%=StringUtils.defaultIfEmpty(s, "")+"<br/>" %>
			                    	<%}} %>	
			                    </td>
			                    <td id="d8_60_day">
			                    	<%
			                    	if(!StringUtils.isEmpty(pd.getD8_60_day())){
			                    	for(String s:pd.getD8_60_day().split("\\|")){
			                    		if(StringUtils.isEmpty(s))continue;
			                    	%>
			                    	<%=StringUtils.defaultIfEmpty(s, "")+"<br/>" %>
			                    	<%}} %>
			                    </td>
			                    
			                    <td id="pfmea"><%=StringUtils.defaultIfEmpty(pd.getPfmea(), "") %></td>
			                    <td id="cp"><%=StringUtils.defaultIfEmpty(pd.getCp(), "") %></td>
			                    <td id="lls"><%=StringUtils.defaultIfEmpty(pd.getLls(), "") %></td>
			                    <td id="plant_manager"><%=StringUtils.defaultIfEmpty(pd.getPlant_manager(), "") %></td>
			                    
			                    
			                    <td id="lls1" style="display: none"><%=StringUtils.defaultIfEmpty(pd.getLls1(), "") %></td>
			                    <td id="lls_transversalization" style="display: none"><%=StringUtils.defaultIfEmpty(pd.getLls_transversalization(), "") %></td>
			                    <td id="lls_daily_tracking_30_days" style="display: none"><%=StringUtils.defaultIfEmpty(pd.getLls_daily_tracking_30_days(), "") %></td>
			                    <td id="lls1_pic" style="display: none"><%=StringUtils.defaultIfEmpty(pd.getLls1_pic(), "") %></td>
			                    <td id="lls_transversalization_pic" style="display: none"><%=StringUtils.defaultIfEmpty(pd.getLls_transversalization_pic(), "") %></td>
			                    <td id="lls_daily_tracking_30_days_pic" style="display: none"><%=StringUtils.defaultIfEmpty(pd.getLls_daily_tracking_30_days_pic(), "") %></td>
			                    
			                    <td><%if(!StringUtils.isEmpty(pd.getLls1())){ %><a href="javascript:click_href('${ctx }/share/jsp/showUploadFile.jsp?upload_uuid=<%=pd.getLls1()%>');"><img src="${ctx }/images/download.png" alt="" width="18" height="18" /></a><%} %></td>
			                    <td><%if(!StringUtils.isEmpty(pd.getLls_transversalization())){ %><a href="javascript:click_href('${ctx }/share/jsp/showUploadFile.jsp?upload_uuid=<%=pd.getLls_transversalization()%>');"><img src="${ctx }/images/download.png" alt="" width="18" height="18" /></a><%} %></td>
			                    <td><%if(!StringUtils.isEmpty(pd.getLls_daily_tracking_30_days())){ %><a href="javascript:click_href('${ctx }/share/jsp/showUploadFile.jsp?upload_uuid=<%=pd.getLls_daily_tracking_30_days()%>');"><img src="${ctx }/images/download.png" alt="" width="18" height="18" /></a><%} %></td>
			                    <td><img src="${ctx }/share/jsp/showImage.jsp?file=<%=StringUtils.defaultIfEmpty(pd.getLls1_pic(), "0") %>" width="18" height="18"/></td>
			                    <td><img src="${ctx }/share/jsp/showImage.jsp?file=<%=StringUtils.defaultIfEmpty(pd.getLls_transversalization_pic(), "0") %>" width="18" height="18"/></td>
			                    <td><img src="${ctx }/share/jsp/showImage.jsp?file=<%=StringUtils.defaultIfEmpty(pd.getLls_daily_tracking_30_days_pic(), "0") %>" width="18" height="18"/></td>
			                    
			                    <td><%=pd.getOperater() %></td>
			                    <td><%=sdf.format(pd.getUpdate_date()) %></td>
			                </tr>
			            	<%} 
			            	}else{%>
			            	<tr>
			                    <td colspan="21">无数据</td>
			                </tr>
			            	<%} %>
			            </tbody>
			        </table>
			    </div><!--widgetcontent-->			
			</div>
		</div>
		<!--widgetbox-->
		<script>
		function qrci_data_click_select(obj){
			var valForm = $("#"+obj.id).find("*");
			$.each(valForm,function(i,v){
				if(v.id.length>0){
					var formVal = $(this).html().Trim();
					if(formVal.indexOf('<br')>-1){
						$("#qrci_data_form input[name='"+v.id+"']").each(function(index,value){
							//$(this).val(formVal.split("<br>")[index].Trim());
						});
					}else{
						//$("#qrci_data_form #"+v.id).val($(this).text().Trim());
					}
				}
			});
		}
		</script>		