<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.authority.pojo.UserInfo" %>
<%
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	SimpleDateFormat sdf1 = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	String roleCodes = StringUtils.defaultIfEmpty((String)session.getAttribute("roleCodes"), "");
	int id = Integer.parseInt(StringUtils.defaultIfEmpty(request.getParameter("id"), "0"));
	UserInfo user = (UserInfo)session.getAttribute("user");
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	BreakTimeInfoService breakTimeInfoService = (BreakTimeInfoService) ctx.getBean("breakTimeInfoService");
	EmployeeInfoService employeeInfoService = (EmployeeInfoService) ctx.getBean("employeeInfoService");
	ClassInfoService classInfoService = (ClassInfoService) ctx.getBean("classInfoService");
	BreakTimeInfo oti = breakTimeInfoService.queryById(id, null);
	EmployeeInfo employeeInfo = employeeInfoService.queryById(oti.getEmp_id(), null);
	
	String flow_type = Global.flow_type[1];
	ClassInfo classInfo = classInfoService.queryById(oti.getClass_id(),null);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript">
$(function(){
	$("#file").attr("accept","<%=Global.UPLOAD_ACCEPT_2%>");
});
function editFile(upload_uuid){
	//$("#breaktime_upload_id").attr("src",ctx+"/share/jsp/showImage.jsp?file="+upload_uuid);
}
</script>
<script type="text/javascript" src="${ctx }/faurecia/common/service/breaktime/js/breaktime.js"></script>
<script type="text/javascript" src="${ctx }/faurecia/common/service/breaktime/js/breaktime_common.js"></script>
</head>
<body>
	<div id="contentwrapper" class="contentwrapper" style="width:90%;">
		<form class="stdform stdform2" onSubmit="return false;">
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
					        	<td style="font-weight:bold;" align="center">部门</td>
					        	<td>
					        		<%=Global.departmentInfoMap.get(oti.getDept_id()).getDept_name().toString() %>
					        	</td>
					        	<td style="font-weight:bold" align="center">员工</td>
					        	<td>
					        		<%=employeeInfo.getZh_name() %>
					        	</td>
					        	<td style="font-weight:bold" align="center">类型</td>
					        	<td>
					        		<select id="type" name="type">
					        			<%for(int i=0;i<Global.breaktime_type.length;i++){ 
					        			String type = Global.breaktime_type[i].split("\\|")[0];
					        			String hour = Global.breaktime_type[i].split("\\|")[1];
					        			%>
					        			<option value="<%=type%>" lowest_hour="<%=hour %>" <%=type.equals(oti.getType())?"selected":"" %>><%=type%></option>
					        			<%} %>
					        		</select>
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold;" align="center">开始时间</td>
					        	<td>
					        		<input type="hidden" id="day_or_hour" name="day_or_hour" value="hour"/>
					        		<input class="Wdate" type="text" title="开始时间" readonly="readonly" id="start_date" name="start_date" value="<%=sdf1.format(oti.getBegin_date()) %>"/>
					        	</td>
					        	<td style="font-weight:bold" align="center">休假时数</td>
					        	<td>
					        		<input type="text" title="休假时数" name="break_hour" id="break_hour" class="smallinput" value="<%=oti.getBreak_hour() %>" onblur="replaceForHalf(this);"  onafterpaste="replaceForHalf(this);"/>&nbsp; 小时
					        	</td>
					        	<td style="font-weight:bold" align="center">结束时间</td>
					        	<td>
					        		<%=sdf1.format(oti.getEnd_date()) %>
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold" align="center">工作流</td>
					        	<td>
					        		<%=Global.flow_check_status_name[oti.getStatus()] %>
					        	</td>
					        	<td colspan="4"></td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold;" align="center">休假事由</td>
					        	<td colspan="5">
					        		<textarea rows="4" class="longinput" name="remark" id="remark" ><%=StringUtils.defaultIfEmpty(oti.getRemark(), "") %></textarea>
					        	</td>
					        </tr>
					        <tr>
								<td style="font-weight:bold" colspan="6">
									<div>
							        	<jsp:include page="/share/jsp/upload_file.jsp">
											<jsp:param value="<%=oti.getUpload_uuid() %>" name="upload_uuid"/>
										</jsp:include>
							    	</div>
							    	<div>
						       			<%
										if(!StringUtils.isEmpty(oti.getUpload_uuid())){
										%>
										<a href="javascript:click_href('${ctx }/share/jsp/showUploadFile.jsp?upload_uuid=<%=oti.getUpload_uuid()%>');"><img id="breaktime_upload_id" src="${ctx }/images/download.png" alt="" width="18" height="18" /></a>
										<%} %>
										仅支持<%=Global.UPLOAD_ACCEPT_2 %>图片文件，且文件小于<%=Global.UPLOAD_SIZE_2/1000 %>KB
						    		</div>
								</td>
							</tr>					        
			         		</tbody>
			       		</table>
			     	</div>
			   </div>				
			</div>
			<div>
            <input type="hidden" id="id" name="id" value="<%=oti.getId()%>"/>
            <input type="hidden" id="user_id" name="user_id" value="<%=user.getId()%>"/>
            <input type="hidden" id="user_name" name="user_name" value="<%=user.getZh_name()%>"/>
            <input type="hidden" id="emp_id" name="emp_id" value="<%=employeeInfo.getId()%>" title="员工"/>
            <input type="hidden" id="emp_name" name="emp_name" value="<%=employeeInfo.getZh_name()%>" title="员工"/>
            
            <input type="hidden" id="flow_type" value="<%=flow_type%>"/>
            <%if(oti.getStatus().intValue()!=Global.flow_check_status[2]||Util.contains(roleCodes, Global.default_role[1],",")){ %>
			<button id="ok" class="submit radius2">确认</button>
			<button id="closeSubmit" class="submit radius2">关单</button>
			<%} %>
			</div>
			<jsp:include page="/share/jsp/flow_step.jsp">
				<jsp:param value="<%=oti.getId() %>" name="handle_id"/>
				<jsp:param value="<%=oti.getStatus() %>" name="status"/>
				<jsp:param value="<%=oti.getNext_check_emp_id() %>" name="next_check_emp_id"/>
				<jsp:param value="<%=oti.getFlow_id() %>" name="flow_id"/>
			</jsp:include>
		</form>
	</div>
</body>
</html>