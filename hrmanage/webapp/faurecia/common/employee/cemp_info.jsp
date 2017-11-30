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
	ProjectInfoService projectInfoService = (ProjectInfoService) ctx.getBean("projectInfoService");
	
	PositionInfo tmpPi = new PositionInfo();
	tmpPi.setState(1);
	List<PositionInfo> pis = positionInfoService.findByCondition(tmpPi, null);
	
	ProjectInfo tmpPro = new ProjectInfo();
	tmpPro.setState(1);
	List<ProjectInfo> pros = projectInfoService.findByCondition(tmpPro, null);
	
	EmployeeInfo employeeInfo = employeeInfoService.queryById(emp_id,null);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<meta name="description" content="" />
<meta name="keywords" content="" />
<meta name="robots" content="all" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<link rel="stylesheet" href="${ctx }/share/css/view.css" type="text/css" />
</head>
<body bgcolor="#FFFFFF">
	<table width="778" border="0" cellpadding="0" align="center">
		<tr>
			<td>
				<table
					style="BORDER-TOP-WIDTH: 0px; BORDER-LEFT-WIDTH: 0px; BORDER-BOTTOM-WIDTH: 0px; MARGIN: 0px auto; BORDER-RIGHT-WIDTH: 0px"
					cellspacing="0" cellpadding="0" width="760" align="center"
					border="0">
					<tbody>
						<tr>
							<td style="BORDER: #93B0ED 2px solid;" valign="top">
								<table cellSpacing="0" cellpadding="0" width="760"
									align="center" border="0">
									<tbody>
										<tr>
											<td valign="top">
												<table
													style="BORDER: #3076BC 1px solid; PADDING-RIGHT: 0px; PADDING-LEFT: 8px; BACKGROUND: #F5FAFE; PADDING-BOTTOM: 0px; MARGIN: 8px auto;  LINE-HEIGHT: 22px; PADDING-TOP: 8px; "
													cellspacing="0" cellPadding="0" width="97%" align="center"
													border="0">
													<tbody>
														<tr>
															<td style="BORDER-BOTTOM: #88b4e0 1px dashed" height="30">
																<span style="FLOAT: right"> 
																<img height="1" src="${ctx }/images/space.gif" width="12" border="0" /> 
																</span>
																<span style="FONT-SIZE: 25px; LINE-HEIGHT: 30px; HEIGHT: 30px">
																	<strong><%=StringUtils.defaultIfEmpty(employeeInfo.getZh_name(), "") %></strong> 
																</span>
																<img height="1" src="${ctx }/images/space.gif" width="15" border="0" />
															</td>
														</tr>
														<tr>
															<td valign="top">
																<table width="100%" border="0" cellspacing="0"
																	cellpadding="0">
																	<tr>
																		<td height="26" colspan="4">
																			<span class="blue1">
																				<b>
																				<%=StringUtils.defaultIfEmpty(employeeInfo.getEn_name(), "") %>&nbsp;|&nbsp;
																				<%=StringUtils.defaultIfEmpty(employeeInfo.getType(), "") %>&nbsp;|&nbsp;
																				<%=Util.getAge(employeeInfo.getBirthday()) %>岁(<%=sdf.format(employeeInfo.getBirthday()) %>) &nbsp;|&nbsp;
																				<%=Util.getEmpStateName(employeeInfo.getState())%>
																				</b> 
																			</span>
																		</td>
																		<td width="20%" rowspan="6" align="center"
																			valign="middle"><img
																			src="${ctx }/images/photo_match_pic.gif"
																			width="90" height="110" />
																			<p>(ID:<%=Util.alternateZero(employeeInfo.getId()) %>)</p></td>
																	</tr>
																	<tr>
																		<td width="10%" height="20">GV Code：</td>
																		<td width="42%" height="20"><%=StringUtils.defaultIfEmpty(employeeInfo.getEmp_code(), "") %></td>
																		<td width="11%" height="20">部门：</td>
																		<td width="20%" height="20"><%=StringUtils.defaultIfEmpty(employeeInfo.getDept_name(), "") %></td>
																	</tr>
																	<tr>
																		<td height="20">职位：</td>
																		<td height="20"><%=StringUtils.defaultIfEmpty(employeeInfo.getPosition_name(), "") %></td>
																		<td height="20">项目：</td>
																		<td height="20"><%=StringUtils.defaultIfEmpty(employeeInfo.getProject_name(), "") %></td>
																	</tr>
																	<tr>
																		<td height="20">电 话：</td>
																		<td height="20"><%=StringUtils.defaultIfEmpty(employeeInfo.getMobile(), "") %>（手机） <img
																			src="${ctx }/images/phone_icon.png"
																			border="0" /></td>
																		<td height="20">GAP：</td>
																		<td height="20"><%=StringUtils.defaultIfEmpty(employeeInfo.getGap_name(), "") %></td>
																	</tr>
																	<tr>
																		<td height="20">E-mail：</td>
																		<td height="20" colspan="3">
																			<a href="mailto:tonny_nj@163.com" class="blue1"></a>
																		</td>
																	</tr>
																</table>
															</td>
														</tr>
													</tbody>
												</table>
												<table width="97%" border="0" align="center" cellpadding="0" cellspacing="0">
													<tr>
														<th width="90" align="left">
															<div class="titleLineB">紧急联络人</div></th>
														<th width="279" align="left">
															<div class="titleLineR"></div></th>
														<th width="90" align="left">
															<div class="titleLineB">学历</div></th>
														<th align="left" width="279">
															<div class="titleLineR">&nbsp;</div></th>
													</tr>
													<tr>
														<td width="50%" colspan="2">
															<table width="99%" border="0" cellpadding="0"
																cellspacing="0">
																<tr>
																	<td width="90">紧急联络人：</td>
																	<td><%=StringUtils.defaultIfEmpty(employeeInfo.getEmp11(), "") %></td>
																</tr>
																<tr>
																	<td>关系：</td>
																	<td><%=StringUtils.defaultIfEmpty(employeeInfo.getEmp12(), "") %></td>
																</tr>
																<tr>
																	<td>手机号码：</td>
																	<td><%=StringUtils.defaultIfEmpty(employeeInfo.getEmp12(), "") %></td>
																</tr>
															</table></td>
														<td width="50%" colspan="2">
															<table width="99%" border="0" cellpadding="0"
																cellspacing="0">
																<tr>
																	<td width="90">学 历：</td>
																	<td><%=StringUtils.defaultIfEmpty(employeeInfo.getEducation(), "") %></td>
																</tr>
																<tr>
																	<td>专 业：</td>
																	<td><%=StringUtils.defaultIfEmpty(employeeInfo.getProfession(), "") %></td>
																</tr>
																<tr>
																	<td height="22">学 校：</td>
																	<td><%=StringUtils.defaultIfEmpty(employeeInfo.getCollege(), "") %></td>
																</tr>
															</table></td>
													</tr>
												</table>
												</td>
										</tr>
									</tbody>
								</table></td>
						</tr>
						<tr style="HEIGHT: 10px">
							<td style="HEIGHT: 10px" />
						</tr>
						<tr>
							<td style="WIDTH: 100%; HEIGHT: 10px" align="middle" />
						</tr>
					</tbody>
				</table></td>
		</tr>
	</table>

</body>
</html>