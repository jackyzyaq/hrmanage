<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	QRCILineDataService qrciLineDataService = (QRCILineDataService) ctx.getBean("qrciLineDataService");
	SimpleDateFormat sdfA = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	String begin_date = StringUtils.defaultIfEmpty(request.getParameter("begin_date"), "");
	String end_date = StringUtils.defaultIfEmpty(request.getParameter("end_date"), "");
	String number = StringUtils.defaultIfEmpty(request.getParameter("number"), "");
	int emp_id = Integer.parseInt(StringUtils.defaultIfEmpty(request.getParameter("emp_id"), "0"));
	int dept_id = Integer.parseInt(StringUtils.defaultIfEmpty(request.getParameter("dept_id"), "0"));
	
	
	String dept_name = (Global.departmentInfoMap.containsKey(dept_id)?Global.departmentInfoMap.get(dept_id).getDept_name():"");
	String emp_name = (Global.employeeInfoMap.containsKey(emp_id)?Global.employeeInfoMap.get(emp_id).getZh_name():"");
	
	SimpleDateFormat sdfB = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	SimpleDateFormat sdfE = new SimpleDateFormat(Global.DATE_FORMAT_STR_E);
	if(StringUtils.isEmpty(begin_date)||StringUtils.isEmpty(end_date)){
		return ;
	}
	
	QRCILineData cm = new QRCILineData();
	cm.setStart_date(begin_date);
	cm.setOver_date(end_date);
	cm.setDept_id(dept_id==0?null:dept_id);
	cm.setNumber(number);
	//cm.setEmp_id(emp_id);
	List<QRCILineData> list = qrciLineDataService.findByCondition(cm, null);
	
%>
<div class="clearall"></div>
<div class="widgetbox" style="width: 100%">
				<div class="widgetcontent" style="overflow:auto;overflow-x:scroll !important;">
					<table id="qrci_line_index_inner_table" cellpadding="0" cellspacing="0" border="0" class="stdtable" style="border-collapse:collapse;">
						<thead>
                        	<tr>
                                    <th class="head0" rowspan="2" style="text-align: center;width:2%;">序号</th>
                                    <th class="head0" rowspan="2" style="text-align: center;width:3%;" >LINE QRCI NO.</th>
                                    <th class="head0" rowspan="2" style="text-align: center;width:3%;" >召开日期<br/>Opening Date</th>
                                    <th class="head0" rowspan="2" style="text-align: center;width:5%;" >GAP</th>
                                    <th class="head0" rowspan="2" style="text-align: center;width:12%;" >问题描述<br/>Problem Description</th>
                                    <th class="head0" rowspan="2" style="text-align: center;width:5%;" >标准检查<br/>Standards Check</th>
                                    <th class="head0" rowspan="2" style="text-align: center;width:10%;" >原因分析<br/>Cause Analysis</th>
                                    <th class="head0" rowspan="2" style="text-align: center;width:5%;" >行动措施<br/>Action</th>
                                    <th class="head0" style="text-align: center;width:5%;">责任人<br/>Res.</th>
                                    <th class="head0" rowspan="2" style="text-align: center;width:7%;" >验证结果<br/>Validation（日期 班次/OK NOK）</th>
                                    <th class="head0" rowspan="2" style="text-align: center;width:8%;" >是否更新了文件/是否培训员工<br/>Documents Update/Employees Trainup</th>
                                    <th class="head0" rowspan="2" style="text-align: center;width:5%;" >回顾问题时所有员工签字<br/>Signed by Employees</th>
                                    <th class="head0" rowspan="2" style="text-align: center;width:5%;" >备注<br/>Remarks</th>
                                    <th class="head0" rowspan="2" style="text-align: center;width:5%;" >是否关闭<br/>(YES/NO)</th>
                                    <th class="head0" rowspan="2" style="text-align: center;width:5%;" >是否重复发生<br/>(YES/NO)</th>
                                    <th class="head0" rowspan="2" style="text-align: center;width:5%;" >是否上升<br/>(YES/NO)</th>
                                    <th class="head0" rowspan="2" style="text-align: center;width:5%;" >上升的UAPQRCI编号</th>
                                </tr>
                                <tr>
                                    <th class="head0" style="text-align: center;" >日期<br/>Deadline</th>
                                </tr>
                            </thead>
                            <tbody>
                            	<%
                            	if(list!=null&&!list.isEmpty()){
                            		for(int i=0;i<list.size();i++){
	                            		QRCILineData qrciLineData = list.get(i);
	                            		List<QRCILineData> extList = qrciLineDataService.queryExtByQrciLineId(qrciLineData.getId(),emp_name);
                            			int extCount = (extList==null?0:extList.size());
                            	%>
                                <tr>
                                    <td rowspan="<%=extCount %>" style="font-weight: bold;text-align: center;"><%=(i+1) %></td>
                                    <td rowspan="<%=extCount %>" style="font-weight: bold;text-align: center;"><%=(StringUtils.defaultIfEmpty(qrciLineData.getNumber(), "-")).replace("|","-") %></td>
                                    <td rowspan="<%=extCount %>" style="font-weight: bold;text-align: center;"><%=(Util.convertToString(qrciLineData.getOpening_date())).replace(" 00:00:00", "") %></td>
                                    <td rowspan="<%=extCount %>" style="font-weight: bold;text-align: center;"><%=(Global.departmentInfoMap.get(qrciLineData.getDept_id())).getDept_code() %></td>
                                    <td rowspan="<%=extCount %>" style="font-weight: bold;">
                                    	问题是什么：<br/>&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(qrciLineData.getProblem_discription(), "-").split("\\|")[0] %><br/>
										为什么是问题：<br/>&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(qrciLineData.getProblem_discription(), "-").split("\\|")[1] %><br/>
										什么时间发现：<br/>&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(qrciLineData.getProblem_discription(), "-").split("\\|")[2] %><br/>
										什么时间产生：<br/>&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(qrciLineData.getProblem_discription(), "-").split("\\|")[3] %><br/>
										谁发现：<br/>&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(qrciLineData.getProblem_discription(), "-").split("\\|")[4] %><br/>
										谁制造：<br/>&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(qrciLineData.getProblem_discription(), "-").split("\\|")[5] %><br/>
										哪里发现：<br/>&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(qrciLineData.getProblem_discription(), "-").split("\\|")[6] %><br/>
										哪里产生：<br/>&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(qrciLineData.getProblem_discription(), "-").split("\\|")[7] %><br/>
										怎样发现：<br/>&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(qrciLineData.getProblem_discription(), "-").split("\\|")[8] %><br/>
										多少：<br/>&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(qrciLineData.getProblem_discription(), "-").split("\\|")[9] %><br/>
                                    </td>
                                    <td rowspan="<%=extCount %>" style="font-weight: bold;">
                                    1.是否按WI操作<br/>&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(qrciLineData.getStandards_check(), "-").split("\\|")[0] %><br/>
									2.首件是否符合<br/>&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(qrciLineData.getStandards_check(), "-").split("\\|")[1] %><br/>
									3.PY是否符合<br/>&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(qrciLineData.getStandards_check(), "-").split("\\|")[2] %><br/>
									4.CP是否符合<br/>&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(qrciLineData.getStandards_check(), "-").split("\\|")[3] %><br/>
									5.多岗位是否符合<br/>&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(qrciLineData.getStandards_check(), "-").split("\\|")[4] %><br/>
									6.是否有变化点<br/>&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(qrciLineData.getStandards_check(), "-").split("\\|")[5] %><br/>
									7.5S是否符合<br/>&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(qrciLineData.getStandards_check(), "-").split("\\|")[6] %><br/>
									8.维修保养是否符合<br/>&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(qrciLineData.getStandards_check(), "-").split("\\|")[7] %><br/>
									9.其它<br/>&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(qrciLineData.getStandards_check(), "-").split("\\|")[8] %>
                                    
                                    </td>
                                    <td rowspan="<%=extCount %>" style="font-weight: bold;"><%=(StringUtils.defaultIfEmpty(qrciLineData.getCause_analysis(), "-")) %></td>
                                    <%if(extCount==0){ %>
                                    <td style="font-weight: bold;">-</td>
                                    <td style="font-weight: bold;">-</td>
                                    <td style="font-weight: bold;">-</td>
                                    <%}else{ 
                                    %>
                                    <td style="font-weight: bold;"><%=(StringUtils.defaultIfEmpty(extList.get(0).getAction(), "-")) %></td>
                                    <td style="font-weight: bold;"><%=(StringUtils.defaultIfEmpty(extList.get(0).getHandler(), "-")) %><br/><%=(Util.convertToString(extList.get(0).getDeadline())).replace(" 00:00:00", "") %></td>
                                    <td style="font-weight: bold;"><%=(Util.convertToString(extList.get(0).getVal_date())).replace(" 00:00:00", "") %><br/><%=(StringUtils.defaultIfEmpty(extList.get(0).getClass_name(),"-")) %><br/><%=(StringUtils.defaultIfEmpty(extList.get(0).getIs_ok(),"-")) %></td>
                                    <%} %>
                                    <td rowspan="<%=extCount %>" style="font-weight: bold;">
										A）PFMEA更新<br/>&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(qrciLineData.getUpdates(), "-").split("\\|")[0] %><br/>
										B）CP更新<br/>&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(qrciLineData.getUpdates(), "-").split("\\|")[1] %><br/>
										C）首件表更新<br/>&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(qrciLineData.getUpdates(), "-").split("\\|")[2] %><br/>
										D）WI更新<br/>&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(qrciLineData.getUpdates(), "-").split("\\|")[3] %><br/>
										E）5S指导书更新<br/>&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(qrciLineData.getUpdates(), "-").split("\\|")[4] %><br/>
										F）一级维护操作指导书更新<br/>&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(qrciLineData.getUpdates(), "-").split("\\|")[5] %><br/>
										G）二级维护操作指导书更新<br/>&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(qrciLineData.getUpdates(), "-").split("\\|")[6]%><br/>
										H）防错指导书更新<br/>&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(qrciLineData.getUpdates(), "-").split("\\|")[7] %><br/>
										I）培训记录<br/>&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(qrciLineData.getUpdates(), "-").split("\\|")[8] %><br/>
										J）其它更新<br/>&nbsp;&nbsp;&nbsp;<%=StringUtils.defaultIfEmpty(qrciLineData.getUpdates(), "-").split("\\|")[9] %>                                    
                                    </td>
                                    <td rowspan="<%=extCount %>" style="font-weight: bold;"><%=(StringUtils.defaultIfEmpty(qrciLineData.getSigned_by_employee(), "-")) %></td>
                                    <td rowspan="<%=extCount %>" style="font-weight: bold;"><%=(StringUtils.defaultIfEmpty(qrciLineData.getRemark(), "-")) %></td>
                                    <td rowspan="<%=extCount %>" style="font-weight: bold;text-align: center;"><%=(StringUtils.defaultIfEmpty(qrciLineData.getIs_close(), "-")) %></td>
                                    <td rowspan="<%=extCount %>" style="font-weight: bold;text-align: center;"><%=(StringUtils.defaultIfEmpty(qrciLineData.getIs_re_happend(), "-")) %></td>
                                    <td rowspan="<%=extCount %>" style="font-weight: bold;text-align: center;"><%=(StringUtils.defaultIfEmpty(qrciLineData.getIs_up(), "-")) %></td>
                                    <td rowspan="<%=extCount %>" style="font-weight: bold;text-align: center;"><%=(StringUtils.defaultIfEmpty(qrciLineData.getUp_number(), "-")) %></td>
                                </tr>
                                <%for(int j=1;j<extCount;j++){
                            		QRCILineData extData = extList.get(j); %>
								<tr>
                                    <td style="font-weight: bold;"><%=(StringUtils.defaultIfEmpty(extData.getAction(), "-")) %></td>
                                    <td style="font-weight: bold;"><%=(StringUtils.defaultIfEmpty(extData.getHandler(), "-")) %><br/><%=(Util.convertToString(extData.getDeadline()).replace(" 00:00:00", "")) %></td>
                                    <td style="font-weight: bold;"><%=(Util.convertToString(extData.getVal_date()).replace(" 00:00:00", "")) %><br/><%=(StringUtils.defaultIfEmpty(extData.getClass_name(),"-")) %><br/><%=(StringUtils.defaultIfEmpty(extData.getIs_ok(),"-")) %></td>
                                </tr>                           		
                                <%}}}else{ %>
                                <tr><td colspan="17" style="font-weight: bold;">无数据</td></tr>
                                <%} %>
                            </tbody>
                        </table>
				</div><!--widgetcontent-->
			</div><!--widgetbox-->
			<script>
			$(function(){
				_width_qrci=parseInt($("#qrci_line_index_inner_table").css("width").replace("px",""));
				if(_width_qrci<3100){
					$("#qrci_line_index_inner_table").css("width","3100");
				}
			});
			</script>