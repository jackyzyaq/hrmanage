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
<script type="text/javascript" src="${ctx}/faurecia/improvement/audit/js/improve_audit_.js?v=1001"></script>
<script type="text/javascript">
	function doSubmit() {
		$("#files").val($("#upload_uuid").val());
		if (validateForm()) {
			if(confirm(($("#upload_uuid").val()==''?"合理化建议附件没有上传，":"")+'是否提交？')){
				  $('#basic_validate').ajaxSubmit({
				success : function(data) {
					if (data) {
						if (data.code == 'S') {
						  showMsgInfo(data.msg);
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
						}, 800);
					}
				}
			});
		  }
	    }
		return false;
	}
</script>
</head>
<body>
	<div id="contentwrapper" class="contentwrapper" style="width:90%;">
		<form class="form-horizontal cascde-forms" method="post"
				action="${improve}/fhrapi/audit/save" name="basic_validate"
				id="basic_validate" >
			<div id="flow_step"></div>
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
					                <th class="head1" style="width:10%"></th>
					                <th class="head1" style="width:20%"></th>
					            </tr>
					        </thead>
					        <tbody>
					        <tr>
					        	<td style="font-weight:bold" align="center">员工</td>
					        	<td>
					        		<%=employeeInfo.getZh_name() %>
					        	</td>
					        	<td style="font-weight:bold;" align="center">部门</td>
					        	<td>
					        		<%=StringUtils.defaultIfEmpty(employeeInfo.getDept_name(), "") %>
					        	</td>
					        	<td style="font-weight:bold" align="center">工号</td>
					        	<td>
					        		<%=employeeInfo.getEmp_code()%>
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold;" align="center">GAP小组</td>
					        	<td>
					        		<%=StringUtils.defaultIfEmpty(employeeInfo.getGap_name(), "") %>
					        	</td>
					        	<td colspan="2"></td>
					        	<!-- <td>
					        	</td> -->
					        	<td style="font-weight:bold" align="center">填表时间</td>
					        	<td>
					        		<%=new Date().toLocaleString()%>
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold;" align="center">状况来源</td>
					        	<td colspan="5">
					        		<input type="checkbox" name="improveSourcesList" value="s_qrci" />Improve:qrci
					        		<input type="checkbox" name="improveSourcesList" value="s_hse" />HSE问题
					        		<input type="checkbox" name="improveSourcesList" value="s_5s" />5S审核
					        		<input type="checkbox" name="improveSourcesList" value="s_workshop" />车间活动
					        		<br />
					        		<br />
					        		<input type="checkbox" name="improveSourcesList" value="s_quality" />质量问题
					        		<input type="checkbox" name="improveSourcesList" value="s_sw" />标准化作业审核
					        		<input type="checkbox" name="improveSourcesList" value="s_common" />日常工作
					        		<input type="checkbox" name="improveSourcesList" value="s_others" />其他
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold;" align="center">目前状况</td>
					        	<td colspan="5">
					        		<textarea rows="4" class="longinput" name="currentSituation" id="currentSituation" title="目前状况"></textarea>
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold;" align="center">改进方向</td>
					        	<td colspan="5">
					        		<input type="checkbox" name="improveTargetList" value="t_pp" />产品/工艺
					        		<input type="checkbox" name="improveTargetList" value="t_cost" />成本
					        		<input type="checkbox" name="improveTargetList" value="t_quality" />质量
					        		<input type="checkbox" name="improveTargetList" value="t_saety" />安全
					        		<br /><br />
					        		<input type="checkbox" name="improveTargetList" value="t_ww" />工位/工作区域
					        		<input type="checkbox" name="improveTargetList" value="t_env" />环境
					        		<input type="checkbox" name="improveTargetList" value="t_admin" />行政管理渠道/组织
					        		<input type="checkbox" name="improveTargetList" value="t_others" />其他
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold;" align="center">建议方案</td>
					        	<td colspan="5">
					        		<textarea rows="4" class="longinput" name="proposedSolution" id="proposedSolution" title="建议方案"></textarea>
					        	</td>
					        </tr>
					        <tr>
								<td style="font-weight:bold" colspan="6">
									<div>
							        	<jsp:include page="/share/jsp/upload_file.jsp"></jsp:include>
							    	</div>
							    	<div>
						       			仅支持<%=Global.UPLOAD_ACCEPT_2 %>图片文件，且文件小于<%=Global.UPLOAD_SIZE_2/1024 %>KB
						    		</div>
								</td>
							</tr>					        
			         		</tbody>
			       		</table>
			     	</div>
			   </div>				
			</div>
            <div>
            <input type="hidden" id="latestAuditName" name="latestAuditName" value="<%=employeeInfo.getZh_name()%>"/>
            <input type="hidden" id="submitUserId" name="submitUserId" value="<%=user.getId()%>"/>
            <input type="hidden" id="submitUserName" name="submitUserName" value="<%=user.getZh_name()%>"/>
            <input type="hidden" id="submitterDeptId" name="submitterDeptId" value="<%=employeeInfo.getDept_id()%>"/>
            <input type="hidden" id="submitterDept" name="submitterDept" value="<%=employeeInfo.getDept_name() %>"/>
            <input type="hidden" id="submitEMId" name="submitEMId" value="<%=employeeInfo.getId()%>"/>
            <input type="hidden" id="EMName" name="EMName" value="<%=employeeInfo.getZh_name()%>"/>
            <input type="hidden" id="EMPNmber" name="EMPNmber" value="<%=employeeInfo.getEmp_code()%>"/>
             <input type="hidden" id="nextAuditEMPId" name="nextAuditEMPId" value="<%=leaderEMP.getId()%>"/>
             <input type="hidden" id="nextAuditEMPName" name="nextAuditEMPName" value="<%=leaderEMP.getZh_name()%>"/>
             <input type="hidden" id="nextAuditDept" name="nextAuditDept" value="<%=leaderEMP.getDept_id()%>"/>
             <input type="hidden" id="nextAuditDeptName" name="nextAuditDeptName" value="<%=leaderEMP.getDept_name()%>"/>
             <input type="hidden" id="gotoaction" name="gotoaction" value="add"/>
             <input type="hidden" id="files" name="files" value=""/>
             
			<button type="button" id="ok" onclick="javascript:doSubmit();">确认</button>
			</div>
		</form>
	</div>
</body>
</html>