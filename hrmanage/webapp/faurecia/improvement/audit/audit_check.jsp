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
<script type="text/javascript" src="${ctx}/faurecia/improvement/audit/js/improve_audit_.js?v=1022"></script>
<script type="text/javascript">
	$(function(){
		var params = {};
		params['id']='<%=formId%>';
		var url  = '${improve}'+'/fhrapi/audit/edit'
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
				initAuditTable(data);
				fileView(data);
			},
			error:function(data){
				showMsgInfo(data.msg);
			}
		});	
	});
	
	function doSubmit() {
		setAuditStatus($('#status').val());
		if (setNextStepInfo()) {
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
			       		<jsp:include page="/faurecia/improvement/audit/audit_nodes.jsp">
							<jsp:param value="<%=formId %>" name="formId"/>
						</jsp:include>
				        	<div class="title"><h3>审批</h3></div>
			       		<table cellpadding="0" cellspacing="0" border="0" class="stdtable" id="s1_linmgr">
			       		 <thead>
					            <tr>
					                <th class="head1" colspan="6"><span style="color: #32415A;">Step-1 部门领导</span><span id="s1_linmgr_name"></span></th>
					            </tr>
					        </thead>
			       			<tbody>
			       				<tr>
									<td style="font-weight:bold;width: 20%" align="center">采纳 </td>
						        	<td colspan="3">
						        			由其他部门实施<input onclick="setAuditStatus(2)" id="status2" type="checkbox" name="status" value="2" /> 
							       			&nbsp;&nbsp;
							       			由建议人实施 <input onclick="setAuditStatus(3)" id="status3" type="checkbox" name="status" value="3" /> 
									</td>
									<td style="font-weight:bold;width: 20%" align="center"> 不采纳</td>
						        	<td>
							       			<input onclick="setAuditStatus(4)" type="checkbox" id="status4" name="status" value="4" /> 
									</td>
								</tr>
								<tr id="s1_linmgr_dept">
									<td style="font-weight:bold;" align="center">执行部门 </td>
						        	<td colspan="5">
							       			<jsp:include page="/share/jsp/dept_ztree.jsp"></jsp:include>
									</td>
								</tr>
								<tr id="s1_linmgr_exer">
									<td style="font-weight:bold;" align="center">实施人 </td>
						        	<td colspan="5">
							       		<span id="specifyExe_span"></span>
									</td>
								</tr>										
						        <tr>
									<td style="font-weight:bold;" align="center">备注</td>
						        	<td colspan="5">
						        		<textarea  rows="4" class="longinput" name="lineMgrComment" id="lineMgrComment" title="备注"></textarea>
						        	</td>
								</tr>					        
			         		</tbody>
			       		</table>
			       		<table cellpadding="0" cellspacing="0" border="0" class="stdtable" id="s2_exemgr">
			       		 <thead >
					            <tr >
					                <th class="head1" colspan="6"><span style="color: #32415A;">Step-2 实施部门领导</span></th>
					            </tr>
					        </thead>
			       			<tbody>
			       				<tr>
			       					<td style="font-weight:bold;width: 20%" align="center">采纳</td>
						        	<td colspan="3">
							       			<input onclick="setAuditStatus(5)" type="checkbox" id="status5" name="status" value="5" /> 
									</td>
									
									<td style="font-weight:bold;width: 20%" align="center">不采纳</td>
						        	<td>
							       			<input onclick="setAuditStatus(6)" type="checkbox" id="status6" name="status" value="6" /> 
									</td>
								</tr>
								<tr id = "s2_exe_emp">
									<td style="font-weight:bold;" align="center">实施人 </td>
						        	<td colspan="2">
							       			<jsp:include page="/share/jsp/employee_ztree.jsp">
							       				<jsp:param value="<%=employeeInfo.getDept_id()%>" name="dept_id"/>
							       			</jsp:include>
									</td>
									<td style="font-weight:bold;" align="center">完成期限</td>
						        	<td colspan="2">
										<input class="Wdate" onclick="wdateInstance1();" type="text" title="完成期限" readonly="readonly" id="executeDeadline" name="executeDeadline" value=""/>
									</td>
								</tr>						
						        <tr>
									<td style="font-weight:bold;" align="center">备注</td>
						        	<td colspan="5">
						        		<textarea  rows="4" class="longinput" name="exeMgrComment" id="exeMgrComment" title="备注"></textarea>
						        	</td>
								</tr>					        
			         		</tbody>
			       		</table>
			       		<table cellpadding="0" cellspacing="0" border="0" class="stdtable" id="s3_exer">
			       		 <thead >
					            <tr >
					                <th class="head1" colspan="6"><span style="color: #32415A;">Step-3 实施人确认</span></th>
					            </tr>
					        </thead>
			       			<tbody>
			       				<tr>
									<td style="font-weight:bold;width: 20%" align="center">已实施 </td>
						        	<td colspan="2">
							       			<input onclick="setAuditStatus(7)" id="status7"  type="checkbox" name="status" value="7" /> 
									</td>
									<td style="font-weight:bold;" align="center">实施日期</td>
						        	<td colspan="2">
										<input class="Wdate" onclick="wdateInstance1();" type="text" title="完成期限" readonly="readonly" id="executeDate" name="executeDate" value=""/>
									</td>
								</tr>					
						        <tr>
									<td style="font-weight:bold;" align="center">备注</td>
						        	<td colspan="5">
						        		<textarea  rows="4" class="longinput" name="exeComment" id="exeComment" title="备注"></textarea>
						        	</td>
								</tr>					        
			         		</tbody>
			       		</table>
			       		<table cellpadding="0" cellspacing="0" border="0" class="stdtable" id="s4_sub_conf">
			       		 <thead >
					            <tr >
					                <th class="head1" colspan="6"><span style="color: #32415A;">Step-4 建议人确认</span></th>
					            </tr>
					        </thead>
			       			<tbody>
			       				<tr>
									<td style="font-weight:bold;width: 20%" align="center">确认已实施 </td>
						        	<td colspan="2">
							       			<input onclick="setAuditStatus(8)" id="status8" type="checkbox" name="status" value="8" /> 
									</td>
									<td style="font-weight:bold;" align="center">确认日期</td>
						        	<td colspan="2">
							       		<input class="Wdate" onclick="wdateInstance1();" type="text" title="确认日期" readonly="readonly" id="confirmDate" name="confirmDate" value=""/>
									</td>
								</tr>		
						        <tr>
									<td style="font-weight:bold;" align="center">备注</td>
						        	<td colspan="5">
						        		<textarea  rows="4" class="longinput" name="submitterComment" id="submitterComment" title="备注"></textarea>
						        	</td>
								</tr>					        
			         		</tbody>
			       		</table>
			       		<table cellpadding="0" cellspacing="0" border="0" class="stdtable" id="s5_genera">
			       		 <thead >
					            <tr >
					                <th class="head1" colspan="6"><span style="color: #32415A;">Step-5 是否推广</span></th>
					            </tr>
					        </thead>
			       			<tbody>
			       				<tr>
									<td style="font-weight:bold;width: 20%" align="center">建议推广 </td>
						        	<td colspan="2">
							       			<input onclick="setAuditStatus(9)" type="checkbox" id="status9" name="status" value="9" /> 
									</td>
									<td style="font-weight:bold;" align="center">推广编号</td>
						        	<td colspan="2">
						        		<input type="text" name="generalizeNum" id="generalizeNum" />
									</td>
								</tr>		
						        <tr>
									<td style="font-weight:bold;" align="center">备注</td>
						        	<td colspan="5">
						        		<textarea  rows="4" class="longinput" name="generalizerComment" id="generalizerComment" title="备注"></textarea>
						        	</td>
								</tr>					        
			         		</tbody>
			       		</table>
            <input type="hidden" id="id" name="id" value=""/>
            <input type="hidden" id="submitUserId" name="submitUserId" value="<%=employeeInfo.getId()%>"/>
            <input type="hidden" id="submitterDeptId" name="submitterDeptId" value="<%=employeeInfo.getDept_id()%>"/>
            <input type="hidden" id="latestAuditName" name="latestAuditName" value="<%=employeeInfo.getZh_name()%>"/>
            <input type="hidden" id="nextAuditEMPId" name="nextAuditEMPId" value=""/>
            <input type="hidden" id="nextAuditEMPName" name="nextAuditEMPName" value=""/>
            <input type="hidden" id="nextAuditDept" name="nextAuditDept" value=""/>
            <input type="hidden" id="nextAuditDeptName" name="nextAuditDeptName" value=""/>
            <input type="hidden" id="generalizaterName" name="generalizaterName" value=""/>
            <input type="hidden" id="generalizaterDeptId" name="generalizaterDeptId" value=""/>
            <input type="hidden" id="generalizaterDept" name="generalizaterDept" value=""/>
            <input type="hidden" id="generalizaterId" name="generalizaterId" value=""/>
            <input type="hidden" id="status" name="status" value=""/>
            <div style="padding-top: 20px;">
				<button type="button" id="ok" onclick="javascript:doSubmit();">确认</button>
			</div>
			</div>
		</form>
		</div>
		<script type="text/javascript">
		function setAuditStatus(vstutas){
			var obj =  $("#status"+vstutas);
			 if (vstutas == 2 &&  obj.attr('checked')) {
				 $("#s1_linmgr_dept").show();
				 $("#s1_linmgr_exer").hide();
				 obj.prop('checked',true);
			 }
			 if (vstutas == 3 &&  obj.attr('checked')) {
				 $("#s1_linmgr_exer").show();
				 $("#s1_linmgr_dept").hide();
				 $(this).prop('checked',true);
			 }	 //return false;
			 
			 if (vstutas == 4 &&  obj.attr('checked')) {
				 $("#s1_linmgr_exer").hide();
				 $("#s1_linmgr_dept").hide();
				 $(this).prop('checked',true);
	         }
			 if (vstutas == 5 &&  obj.attr('checked')) {
				 $("#s2_exe_emp").show();
				 $(this).prop('checked',true);
				 //return false;
	           } 
			 if (vstutas == 6 && obj.attr('checked')) {
				 $("#s2_exe_emp").hide();
				 $(this).prop('checked',true);
				 //return false;
	         }
			 if (vstutas == 7 && obj.attr('checked')) {
				 $(this).prop('checked',true);
				 //return false;
	         }
			 if (vstutas == 8 && obj.attr('checked')) {
				 $(this).prop('checked',true);
				 //return false;
	         }
			 
			 if (vstutas == 9 && obj.attr('checked')) {
				 $(this).prop('checked',true);
				 //return false;
	         } 
			 $("input[name='status']").each(function(){
				 //alert($(this).parent().attr('class'));
				 if($(this).val() != vstutas && $(this).parent().attr('class') == 'checked' ){
					 $(this).parent().removeClass();
		             $(this).prop('checked',false);
				 }
			 });
			$("#status").val(vstutas);
		}

		function setNextStepInfo(){
			var status = parseInt($("#status").val());
			var step = $("#auditStep").val();
			var formdata2 = "";
			var params = {};
			params['id']= '<%=formId%>';
			var url= '${improve}' + '/fhrapi/audit/edit';
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
					formdata2 = data;
				},
				error:function(data){
					showMsgInfo(data.msg);
				}
			});
			if(formdata2.status == status ||  
					$("#status"+status).parent().attr('class') != 'checked') {
				showMsgInfo("请勾选相关审核状态后再提交！");
         		return false;
			}
			
			switch (status) {
		              case 2: //采纳，并指定实施部门
						  var params = {};
			         		params['deptid']=$("#requestParam_parent_id").val();
			         		if(params['deptid'] == '' || params['deptid'] == 'undefined' || params['deptid'] == '根目录' || params['deptid'] == '0'){
			         			showMsgInfo("请选择实施部门！");
			         			return false;
			         		}
			         		$.ajax({
			         			url :"${ctx}/faurecia/improvement/data.jsp", // 请求链接
			         			data: params,
			         			type:"POST",     // 数据提交方式
			         			cache: false,
			         			timeout: 5000,
			         			async:false,
			         			dataType: 'json',
			         			success:function(data){
			         				$("#nextAuditDept").val(data.deptinfo.id);
			         				$("#nextAuditDeptName").val(data.deptinfo.dept_name);
			         				if(null == data.empinfo || 'null' == data.empinfo){
			         					showMsgInfo("无法获取到【"+data.deptinfo.dept_name+"】部门的领导信息，请联系管理员！");
			         					
			         					return false;
			         				}else {
			         					$("#nextAuditEMPId").val(data.empinfo.id);
				         				$("#nextAuditEMPName").val(data.empinfo.zh_name);
			         				}
			         			},
			         			error:function(data){
			         				showMsgInfo(data.msg);
			         			}
			         		});	
		                break;
		             case 3: //采纳，由提交人实施
		            	 setNextEMPData(formdata2.submitEMId);
		                 break;
		             case 4: //不采纳
		            	 
		                 break;
	 				case 5: //实施部门领导采纳，并指定实施人
	 					
	 					if($("#emp_id").val() == '' || $("#emp_id").val() == 'undefined' || $("#emp_id").val() == '根目录' || $("#emp_id").val() == '0'){
	 						showMsgInfo("请选择实施人！");
		         			return false;
		         		}
	 					
	 					if($("#executeDeadline").val() == '' || $("#executeDeadline").val() == 'undefined' || $("#executeDeadline").val() == 'null'){
	 						showMsgInfo("请指定完成期限！");
		         			return false;
		         		}
	 					 setNextEMPData($("#emp_id").val());
		                 break;
	 				case 6://实施部门领导不采纳
	 					$("#executeDeadline").val("");
	 				
		                 break;
	 				case 7: //实施人确认实施，并交由提交人确认
	 					if($("#executeDate").val() == '' || $("#executeDate").val() == 'undefined' || $("#executeDate").val() == 'null'){
	 						showMsgInfo("请选择实施时间！");
		         			return false;
		         		}
	 					 if(formdata2.submitEMId == formdata2.nextAuditEMPId) {
	 						$("#status").val(8);
	 					 }else {
	 						setNextEMPData(formdata2.submitEMId);
	 					 }
		                 break;
	 				case 8://提交人确认
	 					if($("#confirmDate").val() == '' || $("#confirmDate").val() == 'undefined' || $("#confirmDate").val() == 'null'){
	 						showMsgInfo("请选择确认日期！");
		         			return false;
		         		}
	 					break;
	 				case 9://提交人确认
	 					if($("#generalizeNum").val() == '' || $("#generalizeNum").val() == 'undefined' || $("#generalizeNum").val() == 'null'){
	 						showMsgInfo("请填写推广编号！");
		         			return false;
		         		}
	 					$("#generalizaterName").val('<%=employeeInfo.getZh_name()%>');
	 					$("#generalizaterId").val('<%=employeeInfo.getId()%>');
	 					$("#generalizaterDept").val('<%=employeeInfo.getDept_name()%>');
	 					$("#generalizaterDeptId").val('<%=employeeInfo.getDept_id()%>');
	 					
	 					 break;
		             default:
		            	showMsgInfo("勾选相关审核状态后再提交！");
		         		return false;
		             	break;
	        		}
				  return true;
		}

		function setNextEMPData(empid){
			var params = {};
			params['empid']= empid ;
			$.ajax({
				url : ctx+"/faurecia/improvement/data.jsp", // 请求链接
				data: params,
				type:"POST",     // 数据提交方式
				cache: false,
				timeout: 5000,
				async:false,
				dataType: 'json',
				success:function(data){
					$("#nextAuditDept").val(data.deptinfo.id);
	 				$("#nextAuditDeptName").val(data.deptinfo.dept_name);
	 				$("#nextAuditEMPId").val(data.empinfo.id);
	 				$("#nextAuditEMPName").val(data.empinfo.zh_name);
				},
				error:function(data){
					showMsgInfo(data.msg);
				}
			});	
		}
		</script>
</body>
</html>