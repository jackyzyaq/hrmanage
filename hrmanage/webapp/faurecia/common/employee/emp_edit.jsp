<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	int emp_id = StringUtils.isEmpty(request.getParameter("emp_id"))?-1:Integer.parseInt(request.getParameter("emp_id"));
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	PositionInfoService positionInfoService = (PositionInfoService) ctx.getBean("positionInfoService");
	EmployeeInfoService employeeInfoService = (EmployeeInfoService) ctx.getBean("employeeInfoService");
	EmployeeCardService employeeCardService = (EmployeeCardService) ctx.getBean("employeeCardService");
	EmployeeLeaveService employeeLeaveService = (EmployeeLeaveService) ctx.getBean("employeeLeaveService");
	ProjectInfoService projectInfoService = (ProjectInfoService) ctx.getBean("projectInfoService");
	GapInfoService gapInfoService = (GapInfoService) ctx.getBean("gapInfoService");
	AnnualLeaveService annualLeaveService = (AnnualLeaveService) ctx.getBean("annualLeaveService");
	
	PositionInfo tmpPi = new PositionInfo();
	tmpPi.setState(1);
	List<PositionInfo> pis = positionInfoService.findByCondition(tmpPi, null);
	
	ProjectInfo tmpPro = new ProjectInfo();
	tmpPro.setState(1);
	List<ProjectInfo> pros = projectInfoService.findByCondition(tmpPro, null);
	
	GapInfo tmpGap = new GapInfo();
	tmpGap.setState(1);
	List<GapInfo> gaps = gapInfoService.findByCondition(tmpGap, null);
	
	EmployeeInfo employeeInfo = employeeInfoService.queryById(emp_id,null);
	
	String upload_uuid = StringUtils.defaultIfEmpty(employeeInfo.getPhoto_upload_uuid(),"0");
	
	List<EmployeeCard> cardList = employeeCardService.findByEmpId(emp_id,null);
	String card = "",old_card = "";
	if(cardList!=null&&!cardList.isEmpty()){
		for(EmployeeCard ec:cardList){
			if(ec.getState().intValue()==1)
				card=ec.getCard();
			else
				old_card +=ec.getCard()+",";
		}
	}
	
	Calendar c = Calendar.getInstance();
	int year = c.get(Calendar.YEAR);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/js/ama/js/plugins/jquery.smartWizard-2.0.min.js"></script>
<script type="text/javascript">
	var _emp_dept_id = '<%=employeeInfo.getDept_id()%>';
	var _emp_position_id = '<%=employeeInfo.getPosition_id()%>';
	
	var _emp_begin_end = '<%=sdf.format(employeeInfo.getBegin_date())%>'+"|"+'<%=sdf.format(employeeInfo.getEnd_date())%>';

	var _emp_emp01 = '<%=StringUtils.defaultIfEmpty(employeeInfo.getEmp01(),"")%>';
	var _emp_hr_status_id = '<%=employeeInfo.getHr_status_id()%>';
	var _emp_labor_type = '<%=StringUtils.defaultIfEmpty(employeeInfo.getLabor_type(),"")%>';
	var _emp_contract_type = '<%=StringUtils.defaultIfEmpty(employeeInfo.getContract_type(),"")%>';
	
	$(document).ready(function(){
		$("#file").attr("accept","<%=Global.UPLOAD_ACCEPT_1%>");
		$('select, input:checkbox').uniform();
		loadTab6(<%=emp_id%>,<%=year%>);
	});
</script>
<script type="text/javascript" src="${ctx }/faurecia/common/employee/js/emp.js"></script>
</head>
<body>
	<div class="bodywrapper">
    	<div class="" style="margin-left: 3px !important;">        
        	<div id="contentwrapper" class="contentwrapper"  style="padding:0px">
						<div class="widgetbox">
							<div class="title"><h3><%=Util.alternateZero(employeeInfo.getId()) %> 
								<jsp:include page="/share/jsp/leaderAll.jsp">
									<jsp:param value="<%=employeeInfo.getDept_id() %>" name="dept_id"/>
									<jsp:param value="<%=employeeInfo.getZh_name() %>" name="zh_name"/>
								</jsp:include>
							</h3></div>
                            <div class="widgetcontent">
                                <div id="tabs">
                                    <ul>
                                        <li><a href="#tabs-1">部门</a></li>
                                        <li><a href="#tabs-2">员工信息</a></li>
                                        <li><a href="#tabs-3">状态</a></li>
                                        <li><a href="#tabs-4">IC卡变更</a></li>
                                        <li><a href="#tabs-5">离职状态</a></li>
                                        <li><a href="#tabs-6">享有年假</a></li>
                                    </ul>
                                    <div id="tabs-1">
                                    	<form id="tabs-1-form" class="yqstdform" onSubmit="return false;">
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
													        	<td align="center" rowspan="4">
														        	<div class="status_thumb">
											                          	<img id="emp_photo" src="${ctx }/share/jsp/showImage.jsp?file=<%=upload_uuid %>" alt="" width="100" height="130" />
											                        </div>
													        	</td>
													        </tr>
													        <tr>
													        	<td style="font-weight:bold" align="center">GV code</td>
													        	<td>
													        		<input type="text" name="emp_code" id="emp_code"  class="mediuminput" title="GV code" value="<%=StringUtils.defaultIfEmpty(employeeInfo.getEmp_code(), "") %>"/>
													        	</td>
													        </tr>
													        <tr>
													        	<td style="font-weight:bold" align="center">所属部门</td>
													        	<td id="dept_td">
													        		<div>
														        	<jsp:include page="/share/jsp/dept_ztree.jsp">
										                        		<jsp:param value="<%=employeeInfo.getDept_id() %>" name="parent_dept_id"/>
										                        		<jsp:param value="<%=employeeInfo.getDept_name() %>" name="parent_dept_name"/>
										                        	</jsp:include>
										                        	</div>
										                        	<div style="margin-top: 3px;font-weight:bold;color:<%=Global.colors[1]%>;"><%=employeeInfo.getEmp21()==null?"":"生效日期("+sdf.format(employeeInfo.getEmp21())+")" %></div>
													        	</td>
													        </tr>
													        <tr>
													        	<td style="font-weight:bold" align="center">所属职位</td>
													        	<td id="position_td">
													        		<div>
															        	<select name="position_id" id="position_id"  title="所属职位">
										                            	<option value="">---请选择---</option>
										                            	<%for(PositionInfo pi:pis){ %>
										                                <option value="<%=pi.getId()%>" <%=employeeInfo.getPosition_id()!=null&&employeeInfo.getPosition_id().intValue()==pi.getId().intValue()?"selected":"" %>><%=pi.getPos_name()%></option>
										                                <%} %>
										                            </select>
										                            </div>
										                        	<div style="margin-top: 3px;font-weight:bold;color:<%=Global.colors[1]%>;"><%=employeeInfo.getEmp16()==null?"":"生效日期("+sdf.format(employeeInfo.getEmp16())+")" %></div>
													        	</td>
													        </tr>
													        
													        <tr>
													        	<td style="font-weight:bold" colspan="3">
														        	<div>
											                        	<jsp:include page="/share/jsp/upload_file.jsp">
											                        		<jsp:param value="<%=upload_uuid %>" name="upload_uuid"/>
											                        	</jsp:include>
											                        </div>
											                        <div>
																	       	仅支持<%=Global.UPLOAD_ACCEPT_1 %>图片文件，且文件小于<%=Global.UPLOAD_SIZE_1/1000 %>KB
																	    </div>
													        	</td>
													        </tr>
													        <tr>
													        	<td style="font-weight:bold;" align="center" colspan="3">
													        		<div class="stdformbutton">
											                        	<button id="editSubmit" class="submit radius2">提交</button>
											                            <input type="reset" class="reset radius2" value="Reset" />
											                            <input type="hidden" name="dept_id" value="<%=employeeInfo.getDept_id()%>" id="dept_id"/>
											                            <input type="hidden" name="id" value="<%=employeeInfo.getId()%>"/>
											                            <input type="hidden" value="<%=upload_uuid%>" id="photo_upload_uuid" name="photo_upload_uuid"/>
											                        </div>
													        	</td>
													        </tr>
											         		</tbody>
											       		</table>
											     	</div>
											   </div>				
											</div>                                    	
					                    </form>
                                    </div>
                                    <div id="tabs-2">
					                    <form id="tabs-2-form" class="stdform" onSubmit="return false;">
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
													        		<input type="text" title="中文姓名" name="zh_name" id="zh_name" class="longinput" value="<%=StringUtils.defaultIfEmpty(employeeInfo.getZh_name(), "") %>" />
													        	</td>
													        	<td style="font-weight:bold" align="center">英文姓名</td>
													        	<td>
													        		<input type="text" title="英文姓名" name="en_name" id="en_name" class="longinput" value="<%=StringUtils.defaultIfEmpty(employeeInfo.getEn_name(), "") %>" />
													        	</td>
													        	<td style="font-weight:bold;" align="center">出生年月</td>
													        	<td>
													        		<input class="Wdate" type="text" title="出生年月" readonly="readonly" id="birthday" name="birthday" value="<%=employeeInfo.getBirthday()==null?"":sdf.format(employeeInfo.getBirthday()) %>"  onfocus="wdateInstance();"/>
													        	</td>
													        </tr>
													        <tr>
													        	<td style="font-weight:bold;" align="center">性别</td>
													        	<td>
													        		<select name="emp14" id="emp14" title="性别" >
										                            	<option value="">---请选择---</option>
										                            	<%for(String s:Global.sex){ %>
										                            	<option value="<%=s%>" <%=(!StringUtils.isEmpty(employeeInfo.getEmp14())&&employeeInfo.getEmp14().trim().equals(s))?"selected":"" %>><%=s %></option>
										                            	<%} %>
										                            </select>
													        	</td>
													        	<td style="font-weight:bold" align="center">身份证</td>
													        	<td>
													        		<input type="text" title="身份证" name="emp15" id="emp15" class="longinput" value="<%=StringUtils.defaultIfEmpty(employeeInfo.getEmp15(), "") %>" onblur="if(!isCardNo(this.value)){showMsgInfo('请重新输入');this.value='';};"/>
													        	</td>
													        	<td style="font-weight:bold;" align="center">籍贯</td>
																<td>
																	<input type="text" name="residence" id="residence" class="longinput" title="籍贯" value="<%=StringUtils.defaultIfEmpty(employeeInfo.getResidence(), "") %>" />
																</td>
													        </tr>													        
													        <tr>
													        	<td style="font-weight:bold;" align="center">学历</td>
													        	<td>
													        		<select name="education" id="education" title="学历" >
										                            	<option value="">---请选择---</option>
										                            	<%for(String ed:Global.education){ %>
										                            	<option value="<%=ed%>" <%=(!StringUtils.isEmpty(employeeInfo.getEducation())&&employeeInfo.getEducation().trim().equals(ed))?"selected":"" %>><%=ed %></option>
										                            	<%} %>
										                            </select>
													        	</td>
													        	<td style="font-weight:bold" align="center">详细地址</td>
													        	<td>
													        		<input type="text" name="address" id="address" class="longinput" title="详细地址" value="<%=StringUtils.defaultIfEmpty(employeeInfo.getAddress(), "") %>" />
													        	</td>
													        	<td style="font-weight:bold" align="center">婚否</td>
																<td>
																	<select name="marry_state" id="marry_state" title="婚否" >
																		<option value="">---请选择---</option>
																		<%for(String ms:Global.marry_state){ %>
																		<option value="<%=ms%>" <%=(!StringUtils.isEmpty(employeeInfo.getMarry_state())&&employeeInfo.getMarry_state().trim().equals(ms))?"selected":"" %>><%=ms %></option>
																		<%} %>
																	</select>
																</td>
													        </tr>
													        
													        <tr>
													        	<td style="font-weight:bold;" align="center">毕业日期</td>
													        	<td>
													        		<input class="Wdate" title="毕业日期" type="text" readonly="readonly" id="graduation_date" name="graduation_date" value="<%=employeeInfo.getGraduation_date()==null?"":sdf.format(employeeInfo.getGraduation_date()) %>"  onfocus="wdateInstance();"/>
													        	</td>
													        	<td style="font-weight:bold" align="center">毕业院校</td>
													        	<td>
													        		<input type="text" title="毕业院校" name="college" id="college"  norequired class="longinput" value="<%=StringUtils.defaultIfEmpty(employeeInfo.getCollege(),"") %>" />
													        	</td>
													        	<td style="font-weight:bold" align="center">专业</td>
													        	<td>
													        		<input type="text" title="专业" name="profession"  norequired id="profession" class="longinput" value="<%=StringUtils.defaultIfEmpty(employeeInfo.getProfession(),"") %>" />
													        	</td>
													        </tr>
													        <tr>
													        	<td style="font-weight:bold;" align="center">紧急联络人</td>
													        	<td>
													        		<input class="longinput" title="紧急联络人" type="text" id="emp11" norequired name="emp11" value="<%=StringUtils.defaultIfEmpty(employeeInfo.getEmp11(), "") %>"/>
													        	</td>
													        	<td style="font-weight:bold" align="center">紧急联络人关系</td>
													        	<td>
													        		<input class="longinput" title="紧急联络人关系" type="text" id="emp12" norequired name="emp12" value="<%=StringUtils.defaultIfEmpty(employeeInfo.getEmp12(), "") %>"/>
													        	</td>
													        	<td style="font-weight:bold" align="center">紧急联络人手机</td>
													        	<td>
													        		<input class="longinput" title="紧急联络人手机" type="text" id="emp13" norequired name="emp13" value="<%=StringUtils.defaultIfEmpty(employeeInfo.getEmp13(), "") %>"/>
													        	</td>
													        </tr>
													        <tr>
													        	<td style="font-weight:bold" align="center">固定电话</td>
													        	<td>
													        		<input type="text" title="固定电话" name="phone"  norequired id="phone" class="longinput" value="<%=employeeInfo.getPhone()==null?"":employeeInfo.getPhone() %>" onblur="validateNum(this);"/>
													        	</td>
													        	<td style="font-weight:bold" align="center">手机</td>
													        	<td>
													        		<input type="text" title="手机" name="mobile" id="mobile"  class="longinput" value="<%=employeeInfo.getMobile()==null?"":employeeInfo.getMobile() %>" onblur="validateNum(this);"/>
													        	</td>
													        	<td style="font-weight:bold;" align="center">车牌号</td>
													        	<td>
													        		<input type="text" title="车牌号" name="emp09" id="emp09" norequired class="longinput" value="<%=employeeInfo.getEmp09()==null?"":employeeInfo.getEmp09() %>"/>
													        	</td>
													        </tr>
													        <tr>
													        	<td style="font-weight:bold;" align="center" colspan="6">
													        		<div class="stdformbutton">
											                        	<button id="editSubmit" class="submit radius2">提交</button>
											                            <input type="reset" class="reset radius2" value="Reset" />
											                            <input type="hidden" name="id" value="<%=employeeInfo.getId()%>"/>
											                            <input type="hidden" name="emp_code" value="<%=employeeInfo.getEmp_code()%>"/>
											                        </div>
													        	</td>
													        </tr>
											         		</tbody>
											       		</table>
											     	</div>
											   </div>				
											</div>
					                    </form>
                                    </div>
                                    <div id="tabs-3">
					                    <form id="tabs-3-form" class="stdform" onSubmit="return false;">
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
													        		<input type="text" title="试用期" name="try_month" id="try_month" class="mediuminput" value="<%=employeeInfo.getTry_month()==null?"":employeeInfo.getTry_month() %>"  onblur="validateNum(this);"/> &nbsp;个月
													        	</td>
													        	<td style="font-weight:bold" align="center">合同开始</td>
													        	<td>
													        		<input class="Wdate" type="text" title="合同开始" readonly="readonly" id="begin_date" name="begin_date" value="<%=employeeInfo.getBegin_date()==null?"":sdf.format(employeeInfo.getBegin_date()) %>"  onfocus="wdateBeginInstance('end_date');"/>
													        	</td>
													        	<td style="font-weight:bold" align="center">合同结束</td>
													        	<td id="begin_end_td">
													        		<div>
													        		<input class="Wdate" type="text" title="合同结束" readonly="readonly" id="end_date" name="end_date" value="<%=employeeInfo.getEnd_date()==null?"":sdf.format(employeeInfo.getEnd_date()) %>"  onfocus="wdateEndInstance('begin_date');"/>
													        		</div>
										                        	<div style="margin-top: 3px;font-weight:bold;color:<%=Global.colors[1]%>;"><%=employeeInfo.getEmp22()==null?"":"生效日期("+sdf.format(employeeInfo.getEmp22())+")" %></div>
													        	</td>
													        </tr>
													        <tr>
													        	<td style="font-weight:bold;" align="center">社会工作日</td>
													        	<td>
													        		<input class="Wdate" type="text" title="社会工作日" readonly="readonly" id="emp06" name="emp06" value="<%=employeeInfo.getEmp06()==null?"":sdf.format(employeeInfo.getEmp06()) %>"  onfocus="wdateBeginInstance('emp07');"/>
													        	</td>
													        	<td style="font-weight:bold" align="center">集团工作日</td>
													        	<td>
													        		<input class="Wdate" type="text" title="集团工作日" readonly="readonly" id="emp07" name="emp07" value="<%=employeeInfo.getEmp07()==null?"":sdf.format(employeeInfo.getEmp07()) %>"  onfocus="wdateEndInstance('emp06');"/>
													        	</td>
													        	<td style="font-weight:bold" align="center">入职日期</td>
													        	<td>
													        		<input class="Wdate" type="text" title="入职日期" readonly="readonly" id="emp08" name="emp08" value="<%=employeeInfo.getEmp08()==null?"":sdf.format(employeeInfo.getEmp08()) %>"  onfocus="wdateEndInstance('emp07');"/>
													        	</td>
													        </tr>
													        <tr>
													        	<td style="font-weight:bold;" align="center">合同归属</td>
													        	<td id="emp01_td">
													        		<div>
													        		<input type="text" name="emp01" id="emp01" title="合同归属"  class="longinput" value="<%=StringUtils.defaultIfEmpty(employeeInfo.getEmp01(), "")%>"/>
													        		</div>
										                        	<div style="margin-top: 3px;font-weight:bold;color:<%=Global.colors[1]%>;"><%=employeeInfo.getEmp18()==null?"":"生效日期("+sdf.format(employeeInfo.getEmp18())+")" %></div>
													        	</td>
													        	<td style="font-weight:bold" align="center">转正状态</td>
													        	<td>
													        		<%for(int i=1;i<=Global.try_state.length;i++){ String s=Global.try_state[i-1];%>
									                            	<input type="radio" name="try_state" id="try_state<%=i %>" value="<%=s %>" <%=!StringUtils.isEmpty(employeeInfo.getTry_state())&&employeeInfo.getTry_state().equals(s)?"checked":"" %>/><%=s %> &nbsp;
									                            	<%} %>
													        	</td>
													        	<td style="font-weight:bold" align="center">转正日期</td>
													        	<td>
													        		<input class="Wdate" type="text" title="转正日期" readonly="readonly" id="emp23" name="emp23" norequired value="<%=employeeInfo.getEmp23()==null?"":sdf.format(employeeInfo.getEmp23()) %>"  onfocus="wdateInstance2();"/>
													        	</td>
													        </tr>
													        <tr>
													        	<td style="font-weight:bold;" align="center">是否登录</td>
													        	<td>
													        		<input type="radio" name="is_login" id="is_login1" value="0" <%=employeeInfo.getIs_login().intValue()==0?"checked":"" %>/>否 &nbsp;
							                            			<input type="radio" name="is_login" id="is_login2" value="1" <%=employeeInfo.getIs_login().intValue()==1?"checked":"" %>/>是 &nbsp;
													        	</td>
													        	<td style="font-weight:bold" align="center">考勤方式</td>
													        	<td>
													        		<input type="radio" name="type" id="type1" value="<%=Global.employee_type[0] %>" <%=employeeInfo.getType().trim().equals(Global.employee_type[0])?"checked":"" %>/><%=Global.employee_type[0] %> &nbsp;
							                            			<input type="radio" name="type" id="type2" value="<%=Global.employee_type[1] %>" <%=employeeInfo.getType().trim().equals(Global.employee_type[1])?"checked":"" %>/><%=Global.employee_type[1] %> &nbsp;
													        	</td>
													        	<td style="font-weight:bold" align="center">HR Status</td>
													        	<td id="hr_status_td">
													        		<div>
													        		<jsp:include page="/faurecia/common/employee/emp_hr_status.jsp" >
																		<jsp:param value="<%=employeeInfo.getHr_status_id() %>" name="hr_status_id"/>
																	</jsp:include>
																	</div>
										                        	<div style="margin-top: 3px;font-weight:bold;color:<%=Global.colors[1]%>;"><%=employeeInfo.getEmp17()==null?"":"生效日期("+sdf.format(employeeInfo.getEmp17())+")" %></div>
													        	</td>
													        </tr>
													        <tr>
													        	<td style="font-weight:bold;" align="center">MOD/MOI</td>
													        	<td id="labor_type_td">
													        		<div>
													        		<input type="text" name="labor_type" id="labor_type" value="<%=StringUtils.defaultIfEmpty(employeeInfo.getLabor_type(),"") %>" class="longinput"/>&nbsp;
													        		</div>
										                        	<div style="margin-top: 3px;font-weight:bold;color:<%=Global.colors[1]%>;"><%=employeeInfo.getEmp19()==null?"":"生效日期("+sdf.format(employeeInfo.getEmp19())+")" %></div>
													        	</td>
													        	<td style="font-weight:bold;" align="center">ContractType</td>
													        	<td id="contract_type_td">
													        		<div>
													        		<input type="text" name="contract_type" id="contract_type" value="<%=StringUtils.defaultIfEmpty(employeeInfo.getContract_type(),"") %>" class="longinput"/>&nbsp;
													        		</div>
										                        	<div style="margin-top: 3px;font-weight:bold;color:<%=Global.colors[1]%>;"><%=employeeInfo.getEmp20()==null?"":"生效日期("+sdf.format(employeeInfo.getEmp20())+")" %></div>
													        	</td>
																<td style="font-weight:bold" align="center">状态</td>
													        	<td>
													        		<input type="radio" disabled="disabled" <%=employeeInfo.getState().intValue()==1?"checked":"" %>/>在职 &nbsp;
									                            	<input type="radio" disabled="disabled" <%=employeeInfo.getState().intValue()==2?"checked":"" %>/>辞职 &nbsp;
									                            	<input type="radio" disabled="disabled" <%=employeeInfo.getState().intValue()==3?"checked":"" %>/>解雇 &nbsp;
													        	</td>
															</tr>
															<tr>
													        	<td style="font-weight:bold;" align="center">PIMS</td>
													        	<td>
													        		<input type="text" name="pims" id="pims" norequired value="<%=StringUtils.defaultIfEmpty(employeeInfo.getPims(),"") %>" class="longinput"/>&nbsp;
													        	</td>
													        	<td style="font-weight:bold;" align="center"></td>
													        	<td>
													        	</td>
																<td style="font-weight:bold" align="center"></td>
													        	<td>
													        	</td>
															</tr>															
													        
													        <tr>
													        	<td style="font-weight:bold;" align="center" colspan="6">
													        		<div class="stdformbutton">
											                        	<button id="editSubmit" class="submit radius2">提交</button>
											                            <input type="reset" class="reset radius2" value="Reset" />
											                            <input type="hidden" name="id" value="<%=employeeInfo.getId()%>"/>
											                            <input type="hidden" name="emp_code" value="<%=employeeInfo.getEmp_code()%>"/>
											                        </div>
													        	</td>
													        </tr>
											         		</tbody>
											       		</table>
											     	</div>
											   </div>				
											</div>
					                    </form>
                                    </div>
                                    <div id="tabs-4">
					                    <form id="tabs-4-form" class="stdform" onSubmit="return false;">
				                            <table>
				                            	<%if(!StringUtils.isEmpty(card)){ %>
												<tr>
													<td>
													<p>
							                        	<label>原IC卡</label>
							                            <span class="field"><input type="text" readonly="readonly" class="longinput" value="<%=card %>" /> &nbsp;</span>
							                        </p>
													</td>
												</tr>
												<%} %>
												<tr>
													<td>
													<p>
							                        	<label>IC卡</label>
							                            <span class="field"><input type="text" title="IC卡" name="card" id="card" class="longinput" value=""/> &nbsp;</span>
							                        </p>
													</td>
												</tr>
												<%if(!StringUtils.isEmpty(old_card)){ %>
												<tr>
													<td>
													<p>
							                        	<label>旧IC卡</label>
							                            <span class="field"><%=old_card.substring(0,old_card.length()-1) %> &nbsp;</span>
							                        </p>
													</td>
												</tr>
												<%} %>
												<tr>
				                        			<td>
					                        			<div class="stdformbutton">
								                        	<button id="editSubmit" class="submit radius2">提交</button>
								                            <input type="reset" class="reset radius2" value="Reset" />
								                            <input type="hidden" name="emp_id" value="<%=employeeInfo.getId()%>"/>
								                            <input type="hidden" name="emp_code" value="<%=employeeInfo.getEmp_code()%>"/>
								                        </div>
				                        			</td>
				                        		</tr>																
											</table>					                    
					                    </form>                                    
                                    </div>
                                    <div id="tabs-5">
					                    <form id="tabs-5-form" class="stdform" onSubmit="return false;">
					                    	<div>
												<div class="widgetbox">
													<div class="widgetcontent padding0 statement">
												   		<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
													        <thead>
													            <tr>
													                <th class="head1" style="width:25%"></th>
													                <th class="head1" style="width:75%"></th>
													            </tr>
													        </thead>
													        <tbody>
													        <tr>
													        	<td style="font-weight:bold" align="center">离职业型</td>
													        	<td >
													        		<select id="state" name="state">
													        			<option value="1" <%=employeeInfo.getState().intValue()==1?"selected":"" %>>在职</option>
													        			<option value="2" <%=employeeInfo.getState().intValue()==2?"selected":"" %>>辞职</option>
													        			<option value="3" <%=employeeInfo.getState().intValue()==3?"selected":"" %>>解雇</option>
													        		</select>
													        	</td>
													        </tr>
													        <tr>
													        	<td style="font-weight:bold" align="center">离职日期</td>
													        	<td >
									                            	<input class="smallinput" type="text" title="离职日期" readonly="readonly" id="emp03" name="emp03" value="<%=employeeInfo.getEmp03()==null?"":sdf.format(employeeInfo.getEmp03()) %>"  onfocus="wdateInstance2();"/>
													        	</td>
													        </tr>
													        <tr>
													        	<td style="font-weight:bold" align="center">离职薪资月</td>
													        	<td >
													        		<input class="smallinput" type="text" title="离职薪资月" readonly="readonly" id="emp04" name="emp04" value="<%=employeeInfo.getEmp04()==null?"":sdf.format(employeeInfo.getEmp04()) %>"  onfocus="wdateInstance2();"/>
													        	</td>
													        </tr>
													        <tr>
													        	<td style="font-weight:bold" align="center">离职原因</td>
													        	<td>
									                            	<input type="text" id="emp05" name="emp05" class="longinput" value="<%=StringUtils.defaultIfEmpty(employeeInfo.getEmp05(), "")%>"/>
													        	</td>
													        </tr>
													        <tr>
													        	<td style="font-weight:bold;" align="center" colspan="6">
													        		<div class="stdformbutton">
											                        	<button id="editSubmit" class="submit radius2">提交</button>
											                            <input type="reset" class="reset radius2" value="Reset" />
											                            <input type="hidden" name="id" value="<%=employeeInfo.getId()%>"/>
											                            <input type="hidden" name="emp_code" value="<%=employeeInfo.getEmp_code()%>"/>
											                        </div>
													        	</td>
													        </tr>
											         		</tbody>
											       		</table>
											     	</div>
											   </div>				
											</div>
					                    </form>
                                    </div>
									<div id="tabs-6"></div>                                    
                                </div><!--#tabs-->
                            </div><!--widgetcontent-->
                        </div><!--widgetbox-->
        	</div><!--contentwrapper-->
		</div><!-- centercontent -->
	</div>
</body>
</html>