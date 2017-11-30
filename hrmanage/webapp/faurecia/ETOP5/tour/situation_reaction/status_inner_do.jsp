<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String report_date = StringUtils.defaultIfEmpty(request.getParameter("report_date"), "");
	String tour_info_id = StringUtils.defaultIfEmpty(request.getParameter("tour_info_id"), "0");
	String number = StringUtils.defaultIfEmpty(request.getParameter("number"), "0");
	SimpleDateFormat sdfA = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	SimpleDateFormat sdfE = new SimpleDateFormat(Global.DATE_FORMAT_STR_E);
	if(StringUtils.isEmpty(report_date)){
		return ;
	}
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	TourService tourService = (TourService) ctx.getBean("tourService");
	TourRecordService tourRecordService = (TourRecordService) ctx.getBean("tourRecordService");
	Tour tour = tourService.queryById(Integer.parseInt(tour_info_id),null);
	
%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript">
	$(function(){
		$("#tour_record_form #tourInfoSubmit").click(function(){
			if(validateForm("tour_record_form")){
				if (confirm('是否提交？')) {
					var param = getParamsJson("tour_record_form");
					param['tour_info_id']='<%=tour_info_id%>';
					param['report_date']='<%=report_date%> 00:00:00';
					param['number']='<%=number%>';
					ajaxUrl(ctx+'/common/tour/doCheck.do',param,function(json){
						if(json.flag=='1'){
							parent.document.location.reload();
							//parent.jClose();
						}else{
							showMsgInfo(json.msg+'');
						}
						
					});
				}
			}
		});
	});
</script>
</head>
<body>
<form id="tour_record_form" class="stdform" onSubmit="return false;">
<div class="widgetcontent padding0 statement" style="margin: 5px;">
   <table cellpadding="0" cellspacing="0" border="0" class="stdtable">
        <thead>
            <tr>
                <th class="head1" style="width: 10%"></th>
                <th class="head1" style="width: 40%"></th>
                <th class="head1" style="width: 10%"></th>
                <th class="head1" style="width: 40%"></th>
            </tr>
        </thead>
        <tbody>
			<tr>
				<td style="font-weight:bold" align="center">Status</td>
				<td>
					<select id="status" name="status">
						<option value="1" selected>OK</option>
						<option value="2">NOK</option>
					</select>
				</td>
				<td style="font-weight:bold" align="center">Level</td>
				<td>
					<select id="ext_1" name="ext_1">
						<option value="<%=Global.tour_level[0] %>" selected><%=Global.tour_level_name[0] %></option>
						<option value="<%=Global.tour_level[1] %>"><%=Global.tour_level_name[1] %></option>
						<option value="<%=Global.tour_level[2] %>"><%=Global.tour_level_name[2] %></option>
					</select>
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold" align="center">Respones</td>
				<td>
					<textarea rows="6" class="longinput" name="respones" id="respones" title="Respones"></textarea>
				</td>
				<td style="font-weight:bold" align="center">Reaction</td>
				<td>
					<textarea rows="6" class="longinput" name="ext_3" id="ext_3" title="Reaction"></textarea>
				</td>
			</tr>
            <tr>
				<td colspan="6">
	            	<div class="stdformbutton">
					<button id="tourInfoSubmit" class="submit radius2">Submit</button>
					</div>
				</td>
            </tr>
        </tbody>
    </table>
</div><!--widgetcontent-->
</form>
</body>
</html>