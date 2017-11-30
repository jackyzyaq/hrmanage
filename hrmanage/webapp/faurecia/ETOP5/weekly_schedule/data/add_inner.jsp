<%@page import="com.yq.faurecia.service.DepartmentInfoService"%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%
	int menu_id = Integer.valueOf(StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0"));
	Calendar cal = Calendar.getInstance();
	SimpleDateFormat sdfA = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	ManagementScheduleService managementScheduleService = (ManagementScheduleService) ctx.getBean("managementScheduleService");
	List<ManagementSchedule> nameList = managementScheduleService.queryNameByCondition();
	
	String nameStr = "";
	if(nameList!=null&&!nameList.isEmpty()){
		for(ManagementSchedule pk : nameList){
			nameStr += pk.getTb_name()+"|";
		}
		nameStr.substring(0,nameStr.length()-1);
	}
	
%>
<script type="text/javascript">
	$(function(){
		$("#management_schedule_form #managementScheduleSubmit").click(function(){
			if(validateForm("management_schedule_form")){
				if (confirm('是否提交？')) {
					var param = getParamsJson("management_schedule_form");
					param['tb_schedule_date']=param['tb_schedule_date']+' 00:00:00';
					ajaxUrl(ctx+'/common/managementSchedule/managementScheduleAdd.do',param,function(json){
						showMsgInfo(json.msg+'');
						parent.document.getElementById('iframe_menu_<%=menu_id%>').contentWindow.location.reload(true);
					});
				}
			}
		});
	});
</script>
<form id="management_schedule_form" class="stdform" onSubmit="return false;">
<div class="widgetcontent padding0 statement">
   <table cellpadding="0" cellspacing="0" border="0" class="stdtable">
        <thead>
            <tr>
                <th class="head1" style="width: 25%"></th>
                <th class="head1" style="width: 25%"></th>
                <th class="head1" style="width: 25%"></th>
                <th class="head1" style="width: 25%"></th>
            </tr>
        </thead>
        <tbody>
			<tr>
				<td style="font-weight:bold" align="center">姓名</td>
				<td>
					<jsp:include page="/share/jsp/input_select.jsp">
			 			<jsp:param value="management_schedule_form" name="parent_div"/>
			 			<jsp:param value="tb_name" name="input_div"/>
			 			<jsp:param value="tb_name_select" name="select_div"/>
			 			<jsp:param value="<%=nameStr %>" name="data"/>
			 		</jsp:include>
				</td>
				<td style="font-weight:bold" align="center">日期</td>
				<td>
					<input class="Wdate" type="text" title="日期" readonly="readonly" id="tb_schedule_date" name="tb_schedule_date" value="<%=sdfA.format(cal.getTime()) %>"  onclick="wdateInstance2();"/>
				</td>
			</tr>
			<tr>								
				<td style="font-weight:bold" align="center">
					AM
				</td>
				<td>
					<input class="longinput" type="text" title="AM" id="tb_status_am" name="tb_status_am" value="Anting Plant"/>
				</td>
				<td style="font-weight:bold" align="center">
					PM
				</td>
				<td>
					<input class="longinput" type="text" title="PM" id="tb_status_pm" name="tb_status_pm" value="Anting Plant"/>
				</td>
			</tr>
			<tr>								
				<td style="font-weight:bold" align="center">
					状态
				</td>
				<td>
					<select id="state" name="state" title="状态">
						<option value="1" selected>有效</option>
						<option value="0" >无效</option>
					</select>
				</td>
				<td style="font-weight:bold" align="center">
					BackUp
				</td>
				<td>
				<input class="longinput" type="text" title="BackUp" id="tb_backup" name="tb_backup" value="-"/>
				</td>
			</tr>			
            <tr>
				<td colspan="4">
	            	<div class="stdformbutton">
	            	<input type="hidden" id="id" name="id" value="0">
					<button id="managementScheduleSubmit" class="submit radius2">Submit</button>
					</div>
				</td>
            </tr>
        </tbody>
    </table>
</div><!--widgetcontent-->
</form>