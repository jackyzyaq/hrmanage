<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.authority.pojo.UserInfo" %>
<%@ include file="/faurecia/improvement/connector.jsp"%>
<%
	String formId=request.getParameter("id");
	UserInfo user = (UserInfo)session.getAttribute("user");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	EmployeeInfoService employeeInfoService = (EmployeeInfoService) ctx.getBean("employeeInfoService");
	int emp_id=0;
	try{
		emp_id = Integer.parseInt(user.getName());
	}catch(Exception e){
		
	}
	EmployeeInfo employeeInfo = employeeInfoService.queryById(emp_id);
	if(employeeInfo==null)
		return ;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx}/faurecia/improvement/audit/js/improve_audit_.js?v=1003"></script>
<script type="text/javascript">
	$(function(){
		var params = {};
		params['id']='<%=formId%>';
		var url='${improve}'+'/fhrapi/audit/edit';
		var fn = "";
		$.ajax({
			url : url, // 请求链接
			data: params,
			type:"POST",     // 数据提交方式
			cache: false,
			timeout: 5000,
			async:false,
			dataType: 'json',
			success:function(data){
				initFormData(data);
				fileView(data);
			},
			error:function(data){
				showMsgInfo(data.msg);
			}
		});	
	});
</script>
</head>
<body>
	<div id="contentwrapper" class="contentwrapper" style="width:90%;">
		<form class="form-horizontal cascde-forms" method="post"
				action="${improve}/fhrapi/rewardset/save" name="basic_validate"
				id="basic_validate" >
			<div id="flow_step"></div>
				<div class="widgetbox">
					<div class="widgetcontent padding0 statement">
					<div class="title" >
								        	<h3>内容</h3>
					</div>
				   		<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
					        <thead>
					            <tr>
					                <th class="head1" style="width:15%"></th>
					                <th class="head1" style="width:20%"></th>
					                <th class="head1" style="width:15%"></th>
					                <th class="head1" style="width:20%"></th>
					                <th class="head1" style="width:10%"></th>
					                <th class="head1" style="width:20%"></th>
					            </tr>
					        </thead>
					        <tbody>
					        <tr>
					        	<td style="font-weight:bold" align="center">员工</td>
					        	<td>
					        		<span id="empname"></span>
					        	</td>
					        	<td style="font-weight:bold;" align="center">部门</td>
					        	<td>
					        		<span id="dept_name"></span>
					        	</td>
					        	<td style="font-weight:bold" align="center">工号</td>
					        	<td>
					        		<span id="emp_code"></span>
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold;" align="center">GAP小组</td>
					        	<td>
					        		<span id="emp_gap"></span>
					        	</td>
					        	<td colspan="2"></td>
					        	<!-- <td>
					        	</td> -->
					        	<td style="font-weight:bold" align="center">填表时间</td>
					        	<td>
					        		<span id="formCreatetime"></span>
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold;" align="center">状况来源</td>
					        	<td colspan="5">
					        		<input onchange="changeMark()" type="checkbox" name="improveSourcesList" value="s_qrci"/>Improve:qrci
					        		<input onchange="changeMark()" type="checkbox" name="improveSourcesList" value="s_hse" />HSE问题
					        		<input onchange="changeMark()" type="checkbox" name="improveSourcesList" value="s_5s" />5S审核
					        		<input onchange="changeMark()" type="checkbox" name="improveSourcesList" value="s_workshop" />车间活动
					        		<br />
					        		<br />
					        		<input onchange="changeMark()" type="checkbox" name="improveSourcesList" value="s_quality" />质量问题
					        		<input onchange="changeMark()" type="checkbox" name="improveSourcesList" value="s_sw" />标准化作业审核
					        		<input onchange="changeMark()" type="checkbox" name="improveSourcesList" value="s_common" />日常工作
					        		<input onchange="changeMark()" type="checkbox" name="improveSourcesList" value="s_others" />其他 
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold;" align="center">目前状况</td>
					        	<td colspan="5">
					        		<textarea onchange="changeMark()" rows="4" class="longinput" name="currentSituation" id="currentSituation" title="目前状况"></textarea>
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold;" align="center">改进方向</td>
					        	<td colspan="5">
					        		<input onchange="changeMark()" type="checkbox" name="improveTargetList" value="t_pp" />产品/工艺
					        		<input onchange="changeMark()" type="checkbox" name="improveTargetList" value="t_cost" />成本
					        		<input onchange="changeMark()" type="checkbox" name="improveTargetList" value="t_quality" />质量
					        		<input onchange="changeMark()" type="checkbox" name="improveTargetList" value="t_saety" />安全
					        		<br/><br />
					        		<input onchange="changeMark()" type="checkbox" name="improveTargetList" value="t_ww" />工位/工作区域
					        		<input onchange="changeMark()" type="checkbox" name="improveTargetList" value="t_env" />环境
					        		<input onchange="changeMark()" type="checkbox" name="improveTargetList" value="t_admin" />行政管理渠道/组织
					        		<input onchange="changeMark()" type="checkbox" name="improveTargetList" value="t_others" />其他
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold;" align="center">建议方案</td>
					        	<td colspan="5">
					        		<textarea  rows="4" class="longinput" name="proposedSolution" id="proposedSolution" title="建议方案"></textarea>
					        	</td>
					        </tr>
					         <tr>
								<td style="font-weight:bold" colspan="6">
									<div id="file_view">
						    		</div>
								</td>
							</tr>	
					        </tbody>
			       		</table></div>
			</div>
			<jsp:include page="/faurecia/improvement/audit/audit_nodes.jsp">
				<jsp:param value="<%=formId %>" name="formId"/>
			</jsp:include>
			<jsp:include page="/faurecia/improvement/rewardsetting/reward_edit.jsp"/>
			<div>
	            <input type="hidden" id="empid" name="empid" value="<%=employeeInfo.getId()%>"/>
	            <input type="hidden" id="dept_id" name="dept_id" value="<%=employeeInfo.getDept_id()%>"/>
	             <input type="hidden" id="dept_name" name="dept_name" value="<%=employeeInfo.getDept_name()%>"/>
	             <input type="hidden" id="setting_emp_name" name="setting_emp_name" value="<%=employeeInfo.getZh_name()%>"/>
	             <input type="hidden" id="improve_id" name="improve_id" value="<%=formId%>"/>
	             <input type="hidden" id="type" value=""/>
			<button type="button" id="ok" onclick="javascript:doSubmit();">设为最佳</button>
			</div>
		</form>
	</div>
	<script type="text/javascript">
	function doSubmit() {
		if (validateForm()) {
		if(confirm('是否提交？')){
			$('#basic_validate').ajaxSubmit({
				success : function(data) {
				if (data) {
				  if (data.code == 'S') {
					showMsgInfo(data.msg);
						window.setTimeout(
						function() {
							parent.document.getElementById('iframe_menu_'+_parent_menu_id).contentWindow.location.reload(true);
							//$.alerts._hide();
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
	
	function validateForm(){
		var type_id = $("#type_id").val();
		if(type_id == '' || type_id == 'undefined'){
 			showMsgInfo("请勾选设置类型！");
 			return false;
 		}
		
		var reword_value = $("#reword_value").val();
		if(reword_value == '' || reword_value == 'undefined'){
 			showMsgInfo("请选择最佳的月度或年度值！");
 			return false;
 		}
		
		return true;
	}
	</script>
</body>
</html>