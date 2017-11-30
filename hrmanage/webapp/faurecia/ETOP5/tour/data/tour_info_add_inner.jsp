<%@page import="com.yq.faurecia.service.DepartmentInfoService"%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%
	int menu_id = Integer.valueOf(StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0"));
	Calendar cal = Calendar.getInstance();
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	DepartmentInfoService departmentInfoService = (DepartmentInfoService) ctx.getBean("departmentInfoService");
	DepartmentInfo dept = departmentInfoService.queryById(1,null);
	List<DepartmentInfo> deptList = departmentInfoService.findByParentId(1);
	
	String deptStr = "";
%>
<script type="text/javascript">
	$(function(){
		timeDrop('time1');
		timeDrop('time2');
		$("#tour_info_form #tourInfoSubmit").click(function(){
			if(validateForm("tour_info_form")){
				if($("#emp_id_1").length==0||$("#emp_id_1").val()==''){
					showMsgInfo('请编辑步骤！');
					return ;
				}
				if (confirm('是否提交？')) {
					var param = getParamsJson("tour_info_form");
					param['time']=param['time1']+'~'+param['time2'];
					param['emp_ids']=param['emp_id'];
					ajaxUrl(ctx+'/common/tour/tourAdd.do',param,function(json){
						showMsgInfo(json.msg+'');
						parent.document.getElementById('iframe_menu_<%=menu_id%>').contentWindow.location.reload(true);
					});
				}
			}
		});
	});
	function addFlowStep(){
		showHtml('${ctx}/faurecia/ETOP5/tour/data/tour_info_add_user_step.jsp','流程步骤',850,400);
	}
</script>
<form id="tour_info_form" class="stdform" onSubmit="return false;">
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
				<td style="font-weight:bold" align="center">Time</td>
				<td>
					<input class="longinput" style="width:40px;" type="text" readonly="readonly" id="time1" title="Time" name="time1" value=""/>
					~
					<input class="longinput" style="width:40px;" type="text" readonly="readonly" id="time2" title="Time" name="time2" value=""/>
				</td>
				<td style="font-weight:bold" align="center">Department</td>
				<td>
					<select id="dept_id" name="dept_id">
						<option value="<%=dept.getId()%>" selected><%=dept.getDept_code()%></option>
						<%
							for(DepartmentInfo di:deptList){ 
											if(!Util.containsIndexOf(Global.tour_depts, di.getDept_code())) continue;
						%>
						<option value="<%=di.getId()%>"><%=di.getDept_code()%></option>
						<%} %>
					</select>
				</td>
				<td style="font-weight:bold" align="center">
					Stop NO.				
				</td>
				<td>
					<input type="text" name="ext_4" id="ext_4" class="longinput" title="Stop NO." value=""/>
				</td>
			</tr>
			<tr>								
				<td style="font-weight:bold" align="center">Zone</td>
				<td>
			    	<input type="text" name="zone" id="zone" class="longinput" title="Zone" value=""/>
				</td>
				<td style="font-weight:bold" align="center">InputKPI</td>
				<td>
					<input type="text" name="input_kpi" id="input_kpi" class="longinput" title="InputKPI" value=""/>
				</td>
				<td style="font-weight:bold" align="center">CriteriaStandardSituation</td>
				<td>
					<input type="text" name="criteria_standard_situation" id="criteria_standard_situation" class="longinput" title="CriteriaStandardSituation" value=""/>
				</td>
			</tr>
			<tr>				
				<td style="font-weight:bold" align="center">LinkedOutputKPI</td>
				<td>
					<input type="text" name="linked_output_kpi" id="linked_output_kpi" class="longinput" title="LinkedOutputKPI" value=""/>
				</td>
				<td style="font-weight:bold" align="center">visualTools</td>
				<td>
					<input type="text" name="visual_tools" id="visual_tools" class="longinput" title="visualTools" value=""/>
				</td>
				<td style="font-weight:bold" align="center">CheckCurrentSituation</td>
				<td>
					<input type="text" name="check_current_situation" id="check_current_situation" class="longinput" title="CheckCurrentSituation" value=""/>
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold" align="center">UpRuleYellow</td>
				<td>
					<input type="text" class="longinput"  name="up_rule_y" id="up_rule_y" title="UpRuleYellow"/>
				</td>
				<td style="font-weight:bold" align="center">UpRuleOrange</td>
				<td>
					<input type="text" class="longinput"  name="up_rule_o" id="up_rule_o" title="UpRuleOrange"/>
				</td>
				<td style="font-weight:bold" align="center">UpRuleRed</td>
				<td>
					<input type="text" class="longinput"  name="up_rule_r" id="up_rule_r" title="UpRuleRed"/>
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold" align="center">ReactionRuleYellow</td>
				<td>
					<textarea rows="6" class="longinput" name="reaction_rule_y" id="reaction_rule_y" title="ReactionRuleYellow"></textarea>
				</td>
				<td style="font-weight:bold" align="center">ReactionRuleOrange</td>
				<td>
					<textarea rows="6" class="longinput" name="reaction_rule_o" id="reaction_rule_o" title="ReactionRuleOrange"></textarea>
				</td>
				<td style="font-weight:bold" align="center">ReactionRuleRed</td>
				<td>
					<textarea rows="6" class="longinput" name="reaction_rule_r" id="reaction_rule_r" title="ReactionRuleRed"></textarea>
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold" align="center">Description</td>
				<td>
					<textarea rows="6" class="longinput" name="ext_3" id="ext_3" title="Description"></textarea>
				</td>
				<td style="font-weight:bold" align="center"><a style="cursor:pointer;" onclick="addFlowStep();">编辑步骤...</a></td>
				<td>
				</td>
				<td style="font-weight:bold" align="center"></td>
				<td>
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold" align="center">OK上传</td>
				<td>
			    	<jsp:include page="/share/jsp/upload_file_more.jsp">
			        	<jsp:param value="ext_1" name="input_name"/>
			        	<jsp:param value="<%=Global.UPLOAD_ACCEPT_1 %>" name="accept"/>
			   		</jsp:include>
				</td>
				<td style="font-weight:bold" align="center">NOK上传</td>
				<td>
			    	<jsp:include page="/share/jsp/upload_file_more.jsp">
			        	<jsp:param value="ext_2" name="input_name"/>
			        	<jsp:param value="<%=Global.UPLOAD_ACCEPT_1 %>" name="accept"/>
			   		</jsp:include>
				</td>
				<td style="font-weight:bold" align="center"></td>
				<td>
				</td>
			</tr>
			<tr>
				<td colspan="6">
					<div id="step_t"></div>
				</td>
			</tr>
            <tr>
				<td colspan="6">
	            	<div class="stdformbutton">
	            	<input type="hidden" id="id" name="id" value="0">
					<button id="tourInfoSubmit" class="submit radius2">Submit</button>
					</div>
				</td>
            </tr>
        </tbody>
    </table>
</div><!--widgetcontent-->
</form>