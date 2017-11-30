<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.authority.pojo.UserInfo" %>
<%
	UserInfo user = (UserInfo)session.getAttribute("user");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	EmployeeInfoService employeeInfoService = (EmployeeInfoService) ctx.getBean("employeeInfoService");
	DepartmentInfoService departmentInfoService = (DepartmentInfoService) ctx.getBean("departmentInfoService");
	
	int emp_id=0;
	try{
		emp_id = Integer.parseInt(user.getName());
	}catch(Exception e){
		
	}
	EmployeeInfo employeeInfo = employeeInfoService.queryById(emp_id);
	if(employeeInfo==null)
		return ;
	String flow_type = Global.flow_type[1];
	Calendar c = Calendar.getInstance();
	String leader = employeeInfoService.getLeaderIdByDeptId(employeeInfo.getDept_id());
	EmployeeInfo leaderEMP = new EmployeeInfo();
	if(StringUtils.isNotEmpty(leader)){
		String ld[] = leader.split(",");
		if(leader.split(",").length > 0) {
			leaderEMP = employeeInfoService.queryById(Integer.parseInt(ld[0]));
		}
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript">
	function doSubmit() {
		if (validateForm()) {
			//alert($("#targetMonthly").val());
			if(confirm('是否提交？')){
				  $('#basic_validate').ajaxSubmit({
				success : function(data) {
					if (data) {
						if (data.code == 'S') {
						showMsgInfo("操作成功！");
						window.setTimeout(
							function() {
								parent.document.getElementById('iframe_menu_'+_parent_menu_id).contentWindow.location.reload(true);
								parent.jClose();
							}, 1500);
						}
					} else {
					  window.setTimeout(
						function() {
									$.alerts._hide();
						}, 1500);
					}
				}
			});
		  }
	    }
		return false;
	}
	
	function validateForm() {
		var deptid = $("#requestParam_parent_id").val();
		if(deptid == '' || deptid == 'undefined' || deptid == '根目录' || deptid == '0'){
 			showMsgInfo("请选择目标部门！");
 			return false;
 		} else {
 			$("#targetDeptId").val(deptid);
 			$("#targetDeptName").val($("#parent").val());
 		}
		
		var monthly = $("#targetMonthly").val();targetValue
		if(monthly == '' || monthly == 'undefined' || monthly == '0'){
 			showMsgInfo("请选择目标设定月份！");
 			return false;
 		} else {
 			$("#targetMonthly").val($("#targetMonthly").val()+'-01 00:00:00');
 		}
		
		var targetValue = $("#targetValue").val();
		if(targetValue == '' || targetValue == 'undefined' || targetValue == '0'){
 			showMsgInfo("请填写目标值！");
 			return false;
 		}
		
		return true;
	}
	
	function wdateInstanceforImp(){
		WdatePicker({dateFmt:'yyyy-MM',alwaysUseStartDate:false});
	}
</script>
</head>
<body>
	<div id="contentwrapper" class="contentwrapper" style="width:90%;">
		<form class="form-horizontal cascde-forms" method="post"
				action="${improve}/fhrapi/itarget/save" name="basic_validate"
				id="basic_validate" >
			<div>
				<div class="widgetbox">
					<div class="widgetcontent padding0 statement">
				   		<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
					        <thead>
					            <tr>
					                <th class="head1" style="width:15%"></th>
					                <th class="head1" style="width:20%"></th>
					                <th class="head1" style="width:15%"></th>
					                <th class="head1" style="width:20%"></th>
					               <!--  <th class="head1" style="width:10%"></th>
					                <th class="head1" style="width:20%"></th> -->
					            </tr>
					        </thead>
					        <tbody>
					        <tr>
					        	<td style="font-weight:bold" align="center">设定人</td>
					        	<td>
					        		<%=employeeInfo.getZh_name() %>
					        	</td>
					        	<td style="font-weight:bold;" align="center">部门</td>
					        	<td>
					        		<%=StringUtils.defaultIfEmpty(employeeInfo.getDept_name(), "") %>
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold;" align="center">月份</td>
					        	<td>
					        		<input class="Wdate" onclick="wdateInstanceforImp();" type="text" readonly="readonly" id="targetMonthly" name="targetMonthly" value=""/>
					        	</td>
					        	<td style="font-weight:bold" align="center">目标部门</td>
					        	<td>
					        		<jsp:include page="/share/jsp/dept_ztree.jsp">
					        			<jsp:param value="<%=employeeInfo.getDept_id() %>" name="parent_dept_id"/>
					        		</jsp:include>
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold;" align="center">目标值</td>
					        	<td colspan="3">
					        		<input class="Wdate" name="targetValue" id="targetValue" type="text" title="目标值"  value=""/>
					        	</td>
					        </tr>
			         		</tbody>
			       		</table>
			     	</div>
			   </div>				
			</div>
            <div>
            <input type="hidden" id="empId" name="empId" value="<%=employeeInfo.getId()%>"/>
             <input type="hidden" id="empName" name="empName" value="<%=employeeInfo.getZh_name()%>"/>
             <input type="hidden" id="targetDeptId" name="targetDeptId" value=""/>
             <input type="hidden" id="targetDeptName" name="targetDeptName" value=""/>
             <input type="hidden" id="gotoaction" name="gotoaction" value="add"/>
             
			 <button type="button" onclick="javascript:doSubmit();">确认</button>
			</div>
		</form>
	</div>
</body>
</html>