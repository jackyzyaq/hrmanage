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
	
	String qrci_type = StringUtils.defaultIfEmpty(request.getParameter("qrci_type"), "");
	List<QRCIData> list = qrciDataService.findHistory(qrci_type);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
</head>
<body>
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
			                    <th class="head0">QRCI TYPE</th>
			                    <th class="head0">YesterdayTaskTo Be Checked</th>
			                </tr>
			            </thead>
			            <tbody>
			            	<%
			            	if(list!=null&&list.size()>0){ 
			            		for(int i=0;i<list.size();i++){
			            			QRCIData pd = list.get(i);
			            	%>
			            	<tr id="qrci_data_<%=pd.getId() %>" onclick="qrci_data_click_select(this);" title="点击可修改">
			                    <td id="qrci_type"><%=StringUtils.defaultIfEmpty(pd.getQrci_type(), "") %></td>
			                    <td id="yesterday_task_to_be_checked">
			                    	<%=StringUtils.defaultIfEmpty(pd.getYesterday_task_to_be_checked(), "") %>
			                    </td>
			                </tr>
			            	<%} 
			            	}else{%>
			            	<tr>
			                    <td colspan="2">无数据</td>
			                </tr>
			            	<%} %>
			            </tbody>
			        </table>
			    </div><!--widgetcontent-->			
			</div>
		</div>
		<!--widgetbox-->
</body>
</html>