<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.authority.pojo.UserInfo" %>
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
	String flow_type = Global.flow_type[1];
	Calendar c = Calendar.getInstance();
	
	//获取部门信息
	String leader = employeeInfoService.getLeaderIdByDeptId(employeeInfo.getDept_id());
	EmployeeInfo leaderEMP = new EmployeeInfo();
	if(StringUtils.isNotEmpty(leader)){
		String ld[] = leader.split(",");
		if(leader.split(",").length > 1) {
			leaderEMP = employeeInfoService.queryById(Integer.parseInt(ld[0]));
		}
	}
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
		var url=${improve}+'/fhr/fhrapi/audit/edit';
		var fn = "";
		$.ajax({
			url : url, // 请求链接
			data: params,
			type:"POST",     // 数据提交方式
			cache: false,
			timeout: 5000,
			async:false,
			dataType: 'json',
	        //crossDomain: true,
			//jsonp: "callback",//传递给请求处理程序或页面的，用以获得jsonp回调函数名的参数名(一般默认为:callback)
	        //jsonpCallback:"handleCallBackData",//自定义的jsonp回调函数名称，默认为jQuery自动生成的随机函数名，也可以写"?"，jQuery会自动为你处理数据
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
				action="${improve}/fhrapi/audit/audit" name="basic_validate"
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
		</form>
	</div>
</body>
</html>