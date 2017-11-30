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
	SimpleDateFormat sdfE = new SimpleDateFormat(Global.DATE_FORMAT_STR_E);
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	ChangeManagementService changeManagementService = (ChangeManagementService) ctx.getBean("changeManagementService");
	
	String ext4Str = "";
	List<ChangeManagement> ext4List = changeManagementService.queryExt4();
	if(ext4List!=null&&!ext4List.isEmpty()){
		for(ChangeManagement cm : ext4List){
			ext4Str += cm.getExt_4()+"|";
		}
		ext4Str.substring(0,ext4Str.length()-1);
	}
%>
<script type="text/javascript">
	$(function(){
		$("#dept_name").focus(function(){
			if($("#requestParam_dept_id").val()!=''){
				deptEmployee();
			}
		});
		$("#change_management_info_form #change_managementInfoSubmit").click(function(){
			if(validateForm("change_management_info_form")){
				if (confirm('是否提交？')) {
					var param = getParamsJson("change_management_info_form");
					param['report_date']=param['report_date']+' 00:00:00';
					param['emp_ids']=param['emp_id'];
					ajaxUrl(ctx+'/common/change_management/change_managementAdd.do',param,function(json){
						showMsgInfo(json.msg+'');
						parent.document.getElementById('iframe_menu_<%=menu_id%>').contentWindow.location.reload(true);
					});
				}
			}
		});
	});
function deptEmployee(){
	var _url = ctx+'/common/employeeInfo/queryResult.do';
	var param = {};
	param['state']='1';
	param['pageIndex']=1;
	param['pageSize']=1000;
	//param['type']='<%=Global.employee_type[0]%>';
	param['dept_id']=$("#requestParam_dept_id").val();
	ajaxUrl(_url,param,function(json){
		$("#emp_id").empty();
		var count=0;
		var select_emp= "<option value=\"\" selected>---请选择---</option>";
		$.each(json.rows, function (n, value) { 
        	if(value.position_name.indexOf("GAP Leader")>-1){
				if(count==0)select_emp.replace("selected", "");
				select_emp +="<option value=\""+value.id+"\" "+(count==0?"selected":"")+">"+value.zh_name+"</option>";
				count++;
			}
        });
		$("#emp_id").append(select_emp);
		select_emp="";
	});
}	
</script>
<form id="change_management_info_form" class="stdform" onSubmit="return false;">
<div class="widgetcontent padding0 statement">
   <table cellpadding="0" cellspacing="0" border="0" class="stdtable">
        <thead>
            <tr>
                <th class="head1" style="width: 10%"></th>
                <th class="head1" style="width: 25%"></th>
                <th class="head1" style="width: 10%"></th>
                <th class="head1" style="width: 25%"></th>
                <th class="head1" style="width: 10%"></th>
                <th class="head1" style="width: 20%"></th>
            </tr>
        </thead>
        <tbody>
			<tr>
				<td style="font-weight:bold" align="center">日期</td>
				<td>
					<input class="longinput" type="text" readonly="readonly" id="report_date" title="日期" name="report_date" value="<%=sdfA.format(cal.getTime()) %>" onclick="wdateInstance2()"/>
				</td>
				<td style="font-weight:bold" align="center">GAP</td>
				<td>
					<jsp:include page="/share/jsp/dept_role_ztree.jsp">
						<jsp:param value="true" name="noRequireParentNode"/>
					</jsp:include>
				</td>
				<td style="font-weight:bold" align="center">
					GAP Leader				
				</td>
				<td>
					<select id="emp_id" name="emp_id" class="longinput"></select>
				</td>
			</tr>
			<tr>								
				<td style="font-weight:bold" align="center">变化点分类</td>
				<td>
					<select id="type" name="type" class="longinput">
						<option value="" selected>---请选择---</option>
						<%for(String type:Global.change_management_type){ 
						%>
						<option value="<%=type%>"><%=type%></option>
						<%} %>
					</select>
				</td>
				<td style="font-weight:bold" align="center">文件更新</td>
				<td>
					<jsp:include page="/share/jsp/input_select.jsp">
			 			<jsp:param value="change_management_info_form" name="parent_div"/>
			 			<jsp:param value="ext_4" name="input_div"/>
			 			<jsp:param value="ext_4_select" name="select_div"/>
			 			<jsp:param value="<%=ext4Str %>" name="data"/>
			 		</jsp:include>
				</td>
				<td style="font-weight:bold" align="center"></td>
				<td>
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold" align="center">变化点内容</td>
				<td colspan="5">
					<textarea rows="3" class="longinput" name="ext_1" id="ext_1" title="变化点内容"></textarea>
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold" align="center">变更可能产生的风险</td>
				<td colspan="5">
					<textarea rows="3" class="longinput" name="ext_2" id="ext_2" title="变更可能产生的风险"></textarea>
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold" align="center">变更的确认内容及方法</td>
				<td colspan="5">
					<textarea rows="3" class="longinput" name="ext_3" id="ext_3" title="变更的确认内容及方法"></textarea>
				</td>
			</tr>
            <tr>
				<td colspan="6">
	            	<div class="stdformbutton">
	            	<input type="hidden" id="id" name="id" value="0">
					<button id="change_managementInfoSubmit" class="submit radius2">Submit</button>
					</div>
				</td>
            </tr>
        </tbody>
    </table>
</div><!--widgetcontent-->
</form>