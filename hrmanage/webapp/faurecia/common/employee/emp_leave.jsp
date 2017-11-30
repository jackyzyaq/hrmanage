<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	int emp_id = StringUtils.isEmpty(request.getParameter("emp_id"))?-1:Integer.parseInt(request.getParameter("emp_id"));
	int year = StringUtils.isEmpty(request.getParameter("year"))?-1:Integer.parseInt(request.getParameter("year"));
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	EmployeeLeaveService employeeLeaveService = (EmployeeLeaveService) ctx.getBean("employeeLeaveService");
	
	EmployeeLeave employeeLeave = employeeLeaveService.findByEmpIdAnyYear(emp_id, year);
%>
<script type="text/javascript">
	$(document).ready(function(){
		$('#contentwrapper #tabs-6 #editSubmit').click(function(){
				if(validateForm('contentwrapper #tabs-6')){
					if (confirm('是否提交？')) {
						var param = getParamsJson("contentwrapper #tabs-6");
						ajaxUrl(ctx+'/common/employeeInfo/editLeave.do',param,'_emp_');
					}
				}
			});
	});
	function totalSum(){
		var t1 = $('#annualDays').val();
		var t2 = $('#companyDays').val();
		$("#totalDays").val(parseFloat(t1)+parseFloat(t2));
	}
	function selectYear(){
		var year = $("#year").val();
		loadTab6(<%=emp_id%>,(year==''?0:year));
	}
</script>
<div>
	<form id="tabs-6-form" class="stdform" onSubmit="return false;">
		<div class="widgetbox">
			<div class="widgetcontent padding0 statement">
		   		<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
			        <thead>
			            <tr>
			                <th class="head1" style="width:20%"></th>
			                <th class="head1" style="width:15%"></th>
			                <th class="head1" style="width:20%"></th>
			                <th class="head1" style="width:15%"></th>
			                <th class="head1" style="width:15%"></th>
			                <th class="head1" style="width:15%"></th>
			            </tr>
			        </thead>
			        <tbody>
			        <tr>
			        	<td style="font-weight:bold" align="center">年份</td>
			        	<td >
							<input class="Wdate" type="text" title="年份" readonly="readonly" id="year" name="year" value="<%=year %>"  onfocus="wYearInstance(function(){selectYear();});"/>
			        	</td>
			        	<td colspan="4">
			        	</td>
			        </tr>
			        <tr>
			        	<td style="font-weight:bold" align="center">国定年假</td>
			        	<td>
							<input type="text" id="annualDays" name="annualDays" class="smallinput" value="<%=employeeLeave==null?0:employeeLeave.getAnnualDays()%>" onblur="replaceForHalf(this);totalSum();" onafterpaste="replaceForHalf(this);"/>&nbsp;天
			        	</td>
			        	<td style="font-weight:bold" align="center">公司年假</td>
			        	<td>
							<input type="text" id="companyDays" name="companyDays" class="smallinput" value="<%=employeeLeave==null?0:employeeLeave.getCompanyDays()%>" onblur="replaceForHalf(this);totalSum();" onafterpaste="replaceForHalf(this);"/>&nbsp;天
			        	</td>
			        	<td style="font-weight:bold" align="center">Total</td>
			        	<td>
							<input type="text" readonly="readonly" id="totalDays" name="totalDays" class="smallinput" value="<%=employeeLeave==null?0:employeeLeave.getTotalDays()%>"/>&nbsp;天
			        	</td>
			        </tr>
			        <tr>
			        	<td style="font-weight:bold;" align="center" colspan="6">
			        		<div class="stdformbutton">
	                        	<button id="editSubmit" class="submit radius2">提交</button>
	                            <input type="reset" class="reset radius2" value="Reset" />
	                            <input type="hidden" name="emp_id" value="<%=emp_id%>"/>
	                        </div>
			        	</td>
			        </tr>
	         		</tbody>
	       		</table>
	     	</div>
	   </div>				
	</form>
</div>