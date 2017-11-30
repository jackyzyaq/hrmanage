<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.authority.pojo.UserInfo"%>
<%
	Map<Integer, MenuInfo> menuInfoMap = (Map<Integer, MenuInfo>) session.getAttribute("menuRole");
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	int emp_id = Integer.parseInt(StringUtils.defaultIfEmpty(request.getParameter("emp_id"), "0"));
	
	EmployeeInfoService employeeInfoService = (EmployeeInfoService) ctx.getBean("employeeInfoService");
	EmployeeInfo employeeInfo = employeeInfoService.queryById(emp_id);
	
	ProjectInfoService projectInfoService = (ProjectInfoService) ctx.getBean("projectInfoService");
	GapInfoService gapInfoService = (GapInfoService) ctx.getBean("gapInfoService");
	
	ProjectInfo tmpPro = new ProjectInfo();
	tmpPro.setState(1);
	List<ProjectInfo> pros = projectInfoService.findByCondition(tmpPro, null);
	
	GapInfo tmpGap = new GapInfo();
	tmpGap.setState(1);
	List<GapInfo> gaps = gapInfoService.findByCondition(tmpGap, null);
%>
<script type="text/javascript">
$(function(){
	$("#sub_emp_list_inner #sub_emp_info_id").click(function(){
		showHtml(ctx+"/faurecia/common/employee/cemp_info.jsp?emp_id="+$("#sub_emp_list_inner #sub_emp_info_id #id").val()+"&menu_id=<%=menu_id%>","员工信息",900);
	});
	$("#sub_emp_list_inner #editSubmit").click(function(){
		var param = getParamsJson("sub_emp_list_inner #sub_emp_info");
		ajaxUrl(ctx+'/common/employeeInfo/empEdit.do',param,function(json){
			if(json.msg!=''){
		    	showMsgInfo(json.msg);
			}else{
			}
		});
	});	
	
});
</script>
	<form class="stdform" onSubmit="return false;">
		<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
			<colgroup>
				<col class="con0" />
				<col class="con1" />
				<col class="con0" />
			</colgroup>
			<thead>
				<tr>
					<th class="head0" style="width:8%">GV Code</th>
					<th class="head1" style="width:6%">姓名</th>
					<th class="head0" style="width:5%">职位</th>
					<th class="head0" style="width:9%">部门</th>
					<th class="head0" style="width:8%">项目</th>
					<th class="head0" style="width:11%">GAP</th>
					<th class="head0" style="width:12%">固定电话</th>
					<th class="head0" style="width:12%">手机号</th>
					<th class="head0" style="width:9%">紧急联络人</th>
					<th class="head0" style="width:8%">紧急联络人<br/>关系</th>
					<th class="head0" style="width:12%">紧急联络人<br/>手机</th>
				</tr>
			</thead>
			<tbody>
				<%
					if(employeeInfo!=null){
					String[] allDetpName = Util.getDeptAllNameById(employeeInfo.getDept_id(), Global.departmentInfoMap).split(">>");
				%>
				<tr id="sub_emp_info">
					<td id="sub_emp_info_id">
						<a style="cursor: pointer"><%=StringUtils.defaultIfEmpty(employeeInfo.getEmp_code(),"") %></a>
						<input type="hidden" id="id" name="id" value="<%=employeeInfo.getId() %>"/>
						<input type="hidden" name="emp_code" value="<%=employeeInfo.getEmp_code() %>"/>
					</td>
					<td><%=StringUtils.defaultIfEmpty(employeeInfo.getZh_name(),"") %></td>
					<td><%=StringUtils.defaultIfEmpty(employeeInfo.getPosition_name(),"") %></td>
					<td><%=StringUtils.defaultString((allDetpName.length<=3?allDetpName[allDetpName.length-1]:allDetpName[allDetpName.length-3]), "") %></td>
					<td><%=StringUtils.defaultString((allDetpName.length<=3?allDetpName[allDetpName.length-1]:allDetpName[allDetpName.length-2]), "") %></td>
<!-- 					<td><%=StringUtils.defaultString((allDetpName[allDetpName.length-1]), "") %></td> -->
					<td>
						<jsp:include page="/share/jsp/dept_role_ztree.jsp">
							<jsp:param value="<%=employeeInfo.getDept_id() %>" name="dept_id"/>
							<jsp:param value="<%=employeeInfo.getDept_name() %>" name="dept_name"/>
						</jsp:include>
					</td>
					<td>
						<input type="text" title="固定电话" name="phone"  norequired id="phone" class="longinput" value="<%=employeeInfo.getPhone()==null?"":employeeInfo.getPhone() %>" onblur="validateNum(this);"/>
					</td>
					<td>
						<input type="text" title="手机" name="mobile" id="mobile"  class="longinput" value="<%=employeeInfo.getMobile()==null?"":employeeInfo.getMobile() %>" onblur="validateNum(this);"/>
					</td>
					<td>
						<input class="longinput" title="紧急联络人" type="text" id="emp11" norequired name="emp11" value="<%=StringUtils.defaultIfEmpty(employeeInfo.getEmp11(), "") %>"/>
					</td>
					<td>
						<input class="longinput" title="紧急联络人关系" type="text" id="emp12" norequired name="emp12" value="<%=StringUtils.defaultIfEmpty(employeeInfo.getEmp12(), "") %>"/>
					</td>
					<td>
						<input class="longinput" title="紧急联络人手机" type="text" id="emp13" norequired name="emp13" value="<%=StringUtils.defaultIfEmpty(employeeInfo.getEmp13(), "") %>"/>
					</td>
				</tr>
				<tr>
					<td style="font-weight:bold;" align="right" colspan="11">
						<div class="stdformbutton">
							<button id="editSubmit" class="submit radius2">提交</button>
						</div>
					</td>
				</tr>
				<%}else{%>
				<tr>
					<td colspan="11">无数据</td>
				</tr>
				<%} %>
			</tbody>
		</table>
	</form>