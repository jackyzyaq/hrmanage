<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	PositionInfoService positionInfoService = (PositionInfoService) ctx.getBean("positionInfoService");
	EmployeeInfoService employeeInfoService = (EmployeeInfoService) ctx.getBean("employeeInfoService");
	ProjectInfoService projectInfoService = (ProjectInfoService) ctx.getBean("projectInfoService");
	GapInfoService gapInfoService = (GapInfoService) ctx.getBean("gapInfoService");
	PositionInfo tmpPi = new PositionInfo();
	tmpPi.setState(1);
	List<PositionInfo> pis = positionInfoService.findByCondition(tmpPi, null);
	
	ProjectInfo tmpPro = new ProjectInfo();
	tmpPro.setState(1);
	List<ProjectInfo> pros = projectInfoService.findByCondition(tmpPro, null);
	
	GapInfo tmpGap = new GapInfo();
	tmpGap.setState(1);
	List<GapInfo> gaps = gapInfoService.findByCondition(tmpGap, null);
	
	int maxId = employeeInfoService.getMaxId();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/js/ama/js/plugins/jquery.smartWizard-2.0.min.js"></script>
<script type="text/javascript" src="${ctx }/faurecia/common/employee/js/emp.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
			$("#id").spinner({min: 0, max: 100000, increment: 2});
			$('select, input:checkbox').uniform();
			$("#file").attr("accept","<%=Global.UPLOAD_ACCEPT_1%>");
			$('#wizard').smartWizard({
				// transitionEffect:'slideleft',
				onLeaveStep : leaveStepCallback,
				onFinish : onFinishCallback,
				enableFinishButton : true
			});

			function leaveStepCallback(obj) {
				var step_num = obj.attr('rel');
				return validateSteps(step_num);
			}

			function onFinishCallback() {
				if(validateSteps("0")){
					if($("#hr_status_id").val().Trim()=='0'||$("#hr_status_id").val().Trim()==''){
						showMsgInfo('请选择HR Status!');
						return ;
					}
					$("#dept_id").val($("#requestParam_parent_id").val());
					if(dateJudge()){
						if(!isNum($("#card").val())){
							showMsgInfo('IC卡必须是数字！');
							return ;
						}
						if (confirm('是否提交？')) {
							ajaxFormUrl('emp_form',ctx+'/common/employeeInfo/empAdd.do',{},'_emp_');
						}
					}
				}
			}		
	});
</script>
</head>
<body>
		<div id="contentwrapper" class="contentwrapper" style="padding:5px">
            <div id="tabbed" class="">
                    <!-- START OF TABBED WIZARD -->
                    <form id="emp_form" class="stdform" onSubmit="return false;">
                    <div id="wizard" class="wizard">
                        <ul class="tabbedmenu">
                            <li>
                            	<a href="#wiz1step2_1">
                                	<span class="h2">部门</span>
                                </a>
                            </li>
                            <li>
                            	<a href="#wiz1step2_2">
                                	<span class="h2">员工信息</span>
                                </a>
                            </li>
                            <li>
                            	<a href="#wiz1step2_3">
                                	<span class="h2">状态</span>
                                </a>
                            </li>
                        </ul>
                        <div id="wiz1step2_1" class="formwiz">
							<div>
								<div class="widgetbox">
									<div class="widgetcontent padding0 statement">
								   		<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
									        <thead>
									            <tr>
									                <th class="head1" style="width: 30%"></th>
									                <th class="head1" style="width: 30%"></th>
									                <th class="head1" style="width: 40%"></th>
									            </tr>
									        </thead>
									        <tbody>
									        <tr>
									        	<td align="center" rowspan="6">
			        								<div class="status_thumb">
							                          	<img id="emp_photo" src="${ctx }/share/jsp/showImage.jsp?file=0" alt="" width="100" height="130" />
							                        </div>
									        	</td>
									        </tr>
									        <tr>
									        	<td style="font-weight:bold" align="center">编号</td>
									        	<td>
									        		<input type="text" id="id" name="id" class="width50 noradiusright" title="编号" value="<%=Util.alternateZero(maxId+1) %>"/>
									        	</td>
									        </tr>
									        <tr>
									        	<td style="font-weight:bold" align="center">GV code</td>
									        	<td>
									        		<input type="text" name="emp_code" id="emp_code"  class="mediuminput" title="GV code" value=""/>
									        	</td>
									        </tr>
									        <tr>
									        	<td style="font-weight:bold" align="center">所属部门</td>
									        	<td>
			        								<jsp:include page="/share/jsp/dept_ztree.jsp"></jsp:include>
									        	</td>
									        </tr>
									        <tr>
									        	<td style="font-weight:bold" align="center">所属职位</td>
									        	<td>
			        								<select name="position_id" id="position_id" title="所属职位">
							                            	<option value="">---请选择---</option>
							                            	<%for(PositionInfo pi:pis){ %>
							                                <option value="<%=pi.getId()%>" ><%=pi.getPos_name()%></option>
							                                <%} %>
							                            </select>
									        	</td>
									        </tr>
									        <tr>
									        	<td style="font-weight:bold" align="center">IC卡</td>
									        	<td>
			        								<input type="text" title="IC卡" name="card" id="card" class="mediuminput" value=""/>
									        	</td>
									        </tr>
									        <tr>
									        	<td style="font-weight:bold" colspan="4">
			        								<div>
							                        	<jsp:include page="/share/jsp/upload_file.jsp"></jsp:include>
							                        </div>
							                        <div>
						       							仅支持<%=Global.UPLOAD_ACCEPT_1 %>图片文件，且文件小于<%=Global.UPLOAD_SIZE_1/1000 %>KB
						    						</div>
									        	</td>
									        </tr>
							         		</tbody>
							       		</table>
							     	</div>
							   </div>				
							</div>                        	
                        </div><!--#wiz1step2_1-->
                        <div id="wiz1step2_2" class="formwiz">
                        	<h4>编号：<%=Util.alternateZero(maxId+1) %></h4>
							<div>
								<div class="widgetbox">
									<div class="widgetcontent padding0 statement">
								   		<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
									        <thead>
									            <tr>
									                <th class="head1"></th>
									                <th class="head1"></th>
									                <th class="head1"></th>
									                <th class="head1"></th>
									                <th class="head1"></th>
									                <th class="head1"></th>
									            </tr>
									        </thead>
									        <tbody>
									        <tr>
									        	<td style="font-weight:bold;" align="center">中文姓名</td>
									        	<td>
									        		<input type="text" title="中文姓名" name="zh_name" id="zh_name" class="longinput" value="" />
									        	</td>
									        	<td style="font-weight:bold" align="center">英文姓名</td>
									        	<td>
									        		<input type="text" title="英文姓名" name="en_name" id="en_name" class="longinput" value="" />
									        	</td>
									        	<td style="font-weight:bold;" align="center">出生年月</td>
									        	<td>
									        		<input class="Wdate" type="text" title="出生年月" readonly="readonly" id="birthday" name="birthday" value=""  onfocus="wdateInstance();"/>
									        	</td>
									        </tr>
											<tr>
											  	<td style="font-weight:bold;" align="center">性别</td>
											   	<td>
													<select name="emp14" id="emp14" title="性别" >
										             	<option value="">---请选择---</option>
										                	<%for(String s:Global.sex){ %>
										                    	<option value="<%=s%>"><%=s %></option>
										                      <%} %>
										          	</select>
												</td>
												<td style="font-weight:bold" align="center">身份证</td>
												<td>
													<input type="text" title="身份证" name="emp15" id="emp15" class="longinput" value="" onblur="if(!isCardNo(this.value)){showMsgInfo('身份证格式不正确！');this.value='';};"/>
												</td>
												<td style="font-weight:bold;" align="center">籍贯</td>
												<td>
													<input type="text" name="residence" id="residence" class="longinput" title="籍贯" value="" />
												</td>
											</tr>									        
									        <tr>
												<td style="font-weight:bold;" align="center">学历</td>
									        	<td>
									        		<select name="education" id="education" title="学历" >
														<option value="">---请选择---</option>
														<%for(String ed:Global.education){ %>
														<option value="<%=ed%>"><%=ed %></option>
														<%} %>
													</select>
									        	</td>
									        	<td style="font-weight:bold" align="center">详细地址</td>
									        	<td>
									        		<input type="text" name="address" id="address" class="longinput" title="详细地址" value="" />
									        		<input type="hidden" name="project_id" id="project_id" value="0"/>
									        	</td>
									        	<td style="font-weight:bold" align="center">婚否</td>
												<td>
													<select name="marry_state" id="marry_state" title="婚否" >
														<option value="">---请选择---</option>
														<%for(String ms:Global.marry_state){ %>
														<option value="<%=ms%>"><%=ms %></option>
														<%} %>
													</select>
													<input type="hidden" name="gap_id" id="gap_id" value="0"/>
												</td>
									        </tr>
									        <tr>
									        	<td style="font-weight:bold;" align="center">毕业日期</td>
									        	<td>
									        		<input class="Wdate" title="毕业日期" type="text" readonly="readonly" id="graduation_date" name="graduation_date" value=""  onfocus="wdateInstance();"/>
									        	</td>
									        	<td style="font-weight:bold" align="center">毕业院校</td>
									        	<td>
									        		<input type="text" title="毕业院校" name="college" id="college"  norequired class="longinput" value="" />
									        	</td>
									        	<td style="font-weight:bold" align="center">专业</td>
									        	<td>
									        		<input type="text" title="专业" name="profession"  norequired id="profession" class="longinput" value="" />
									        	</td>
									        </tr>
									        <tr>
												<td style="font-weight:bold;" align="center">紧急联络人</td>
												<td>
													<input class="longinput" title="紧急联络人" type="text" id="emp11" norequired name="emp11" value=""/>
												</td>
												<td style="font-weight:bold" align="center">紧急联络人关系</td>
												<td>
													<input class="longinput" title="紧急联络人关系" type="text" id="emp12" norequired name="emp12" value=""/>
												</td>
												<td style="font-weight:bold" align="center">紧急联络人手机</td>
												<td>
													<input class="longinput" title="紧急联络人手机" type="text" id="emp13" norequired name="emp13" value=""/>
												</td>
											</tr>
									        <tr>
									        	<td style="font-weight:bold" align="center">固定电话</td>
									        	<td>
									        		<input type="text" title="固定电话" name="phone"  norequired id="phone" class="longinput" value="" onblur="validateNum(this);"/>
									        	</td>
									        	<td style="font-weight:bold" align="center">手机</td>
									        	<td>
									        		<input type="text" title="手机" name="mobile" id="mobile"  class="longinput" value="" onblur="validateNum(this);"/>
									        	</td>
									        	<td style="font-weight:bold;" align="center">车牌号</td>
												<td>
													<input type="text" title="车牌号" name="emp09" id="emp09" norequired class="longinput" value=""/>
												</td>
									        </tr>
							         		</tbody>
							       		</table>
							     	</div>
							   </div>				
							</div>
                        </div><!--#wiz1step2_2-->
                        
                        <div id="wiz1step2_3">
                        	<h4>编号：<%=Util.alternateZero(maxId+1) %></h4>
							<div>
								<div class="widgetbox">
									<div class="widgetcontent padding0 statement">
								   		<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
									        <thead>
									            <tr>
									                <th class="head1"></th>
									                <th class="head1"></th>
									                <th class="head1"></th>
									                <th class="head1"></th>
									                <th class="head1"></th>
									                <th class="head1"></th>
									            </tr>
									        </thead>
									        <tbody>
									        <tr>
									        	<td style="font-weight:bold;" align="center">试用期</td>
									        	<td>
									        		<input type="text" title="试用期" name="try_month" id="try_month" class="mediuminput" value=""  onblur="validateNum(this);"/> &nbsp;个月
									        	</td>
									        	<td style="font-weight:bold" align="center">合同开始</td>
									        	<td>
									        		<input class="Wdate" type="text" title="合同开始" readonly="readonly" id="begin_date" name="begin_date" value=""  onfocus="wdateBeginInstance('end_date');"/>
									        	</td>
									        	<td style="font-weight:bold" align="center">合同结束</td>
									        	<td>
									        		<input class="Wdate" type="text" title="合同结束" readonly="readonly" id="end_date" name="end_date" value=""  onfocus="wdateEndInstance('begin_date');"/>
									        	</td>
									        </tr>
									        <tr>
									        	<td style="font-weight:bold;" align="center">社会工作日</td>
									        	<td>
									        		<input class="Wdate" type="text" title="社会工作日" readonly="readonly" id="emp06" name="emp06" value=""  onfocus="wdateBeginInstance('emp07');"/>
									        	</td>
									        	<td style="font-weight:bold" align="center">集团工作日</td>
									        	<td>
									        		<input class="Wdate" type="text" title="集团工作日" readonly="readonly" id="emp07" name="emp07" value=""  onfocus="wdateEndInstance('emp06');"/>
									        	</td>
									        	<td style="font-weight:bold" align="center">入职日期</td>
									        	<td>
									        		<input class="Wdate" type="text" title="入职日期" readonly="readonly" id="emp08" name="emp08" value=""  onfocus="wdateEndInstance('emp07');"/>
									        	</td>
									        </tr>
									        <tr>
									        	<td style="font-weight:bold;" align="center">合同归属</td>
									        	<td>
									        		<input type="text" name="emp01" id="emp01" title="合同归属"  class="longinput" value=""/>
									        	</td>
									        	<td style="font-weight:bold" align="center">转正状态</td>
									        	<td>
									        		<%for(int i=1;i<=Global.try_state.length;i++){ String s=Global.try_state[i-1];%>
					                            	<input type="radio" name="try_state" id="try_state<%=i %>" value="<%=s %>" <%=(i==1?"checked":"") %>/><%=s %> &nbsp;
					                            	<%} %>
									        	</td>
									        	<td style="font-weight:bold" align="center">状态</td>
									        	<td>
									        		<input type="hidden" name="state" value="1"/>
									        		在职 &nbsp
									        	</td>
									        </tr>
									        <tr>
									        	<td style="font-weight:bold;" align="center">是否登录</td>
									        	<td>
									        		<input type="radio" name="is_login" id="is_login1" value="0" checked/>否 &nbsp;
							               			<input type="radio" name="is_login" id="is_login2" value="1"/>是 &nbsp;
									        	</td>
									        	<td style="font-weight:bold" align="center">考勤方式</td>
									        	<td>
									        		<input type="radio" name="type" id="type1" value="<%=Global.employee_type[0] %>" checked/><%=Global.employee_type[0] %> &nbsp;
							               			<input type="radio" name="type" id="type2" value="<%=Global.employee_type[1] %>"/><%=Global.employee_type[1] %> &nbsp;
									        	</td>
									        	<td style="font-weight:bold" align="center">HR Status</td>
									        	<td>
									        		<jsp:include page="/faurecia/common/employee/emp_hr_status.jsp" ></jsp:include>
									        	</td>
									        </tr>
									        <tr>
									        	<td style="font-weight:bold;" align="center">MOD/MOI</td>
									        	<td>
									        		<input type="text" name="labor_type" id="labor_type" value="" class="longinput"/>&nbsp;
									        	</td>
									        	<td style="font-weight:bold;" align="center">ContractType</td>
									        	<td>
									        		<input type="text" name="contract_type" id="contract_type" value="" class="longinput"/>&nbsp;
									        	</td>
												<td colspan="2">
													<div class="stdformbutton">
							                            <input type="hidden" value="0" id="dept_id" name="dept_id"/>
							                            <input type="hidden" value="0" id="photo_upload_uuid" name="photo_upload_uuid"/>
							                        </div>
												</td>
											</tr>
							         		</tbody>
							       		</table>
							     	</div>
							   </div>				
							</div>
                        </div><!--#wiz1step2_3-->
                    </div><!--#wizard-->
                    </form>
                    <!-- END OF TABBED WIZARD -->
            </div><!-- #tabbed -->
        </div>
</body>
</html>