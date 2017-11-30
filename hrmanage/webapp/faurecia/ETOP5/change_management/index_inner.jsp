<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String begin_date = StringUtils.defaultIfEmpty(request.getParameter("begin_date"), "");
	String end_date = StringUtils.defaultIfEmpty(request.getParameter("end_date"), "");
	int emp_id = Integer.parseInt(StringUtils.defaultIfEmpty(request.getParameter("emp_id"), "0"));
	int dept_id = Integer.parseInt(StringUtils.defaultIfEmpty(request.getParameter("dept_id"), "0"));
	
	String dept_name = (Global.departmentInfoMap.containsKey(dept_id)?Global.departmentInfoMap.get(dept_id).getDept_name():"");
	String emp_name = (Global.employeeInfoMap.containsKey(emp_id)?Global.employeeInfoMap.get(emp_id).getZh_name():"");
	
	SimpleDateFormat sdfA = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	SimpleDateFormat sdfE = new SimpleDateFormat(Global.DATE_FORMAT_STR_E);
	if(StringUtils.isEmpty(begin_date)||StringUtils.isEmpty(end_date)){
		return ;
	}
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	ChangeManagementService change_managementService = (ChangeManagementService) ctx.getBean("changeManagementService");
	ChangeManagement cm = new ChangeManagement(1);
	cm.setStart_date(begin_date);
	cm.setOver_date(end_date);
	cm.setDept_id(dept_id);
	cm.setEmp_id(emp_id);
	List<ChangeManagement> change_managementList = change_managementService.findByCondition(cm, null);
	
%>
	<div class="widgetbox">
		<div  class="shadowdiv" style="margin:5px;">
			<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
				<colgroup>
					<col class="con0" />
					<col class="con0" />
					<col class="con0" />
					<col class="con0" />
				</colgroup>
				<thead>
					<tr>
		            	<th class="head0" colspan="4">
		            		<div  style="padding:5px;">
			               		<a style="cursor:pointer" >GAP：<%=dept_name %></a>
		               		</div>
		            	</th>
		               	<th class="head0" colspan="4">
		               		<div  style="padding:5px;">
			               		<a style="cursor:pointer" >GAP Leader：<%=emp_name %></a>
		               		</div>
		               	</th>
		               	<th class="head0" colspan="4">
		               		<div  style="padding:5px;">
		               			<a style="cursor:pointer" >日期：</a><%=begin_date %>~<%=end_date %>
		               		</div>
		               	</th>
					</tr>
					<tr>
		        		<th class="head0" rowspan="2" style="width:7%;text-align: center;"><a style="cursor:pointer" >日期</a></th>
		            	<th class="head0" colspan="6" style="width:37%;text-align: center;"><a style="cursor:pointer" >变化分类</a></th>
		               	<th class="head0" rowspan="2" style="width:13%;text-align: center;"><a style="cursor:pointer" >变化点内容</a></th>
		               	<th class="head0" rowspan="2" style="width:13%;text-align: center;"><a style="cursor:pointer" >变更可能产生的风险</a></th>
		               	<th class="head0" rowspan="2" style="width:13%;text-align: center;"><a style="cursor:pointer" >变更的确认内容及方案</a></th>
		               	<th class="head0" rowspan="2" style="width:9%;text-align: center;"><a style="cursor:pointer" >文件更新</a></th>
		               	<th class="head0" rowspan="2" style="width:8%;text-align: center;"><a style="cursor:pointer" >团队验证确认</a></th>
					</tr>
					<tr>
		               	<th class="head0" style="text-align: center;"><a style="cursor:pointer;" >&nbsp;&nbsp;<%=Global.change_management_type[0] %>&nbsp;&nbsp;</a></th>
		               	<th class="head0" style="text-align: center;"><a style="cursor:pointer;" ><%=Global.change_management_type[1] %></a></th>
		               	<th class="head0" style="text-align: center;"><a style="cursor:pointer;" >&nbsp;&nbsp;<%=Global.change_management_type[2] %>&nbsp;&nbsp;</a></th>
		               	<th class="head0" style="text-align: center;"><a style="cursor:pointer;" >&nbsp;&nbsp;<%=Global.change_management_type[3] %>&nbsp;&nbsp;</a></th>
		               	<th class="head0" style="text-align: center;"><a style="cursor:pointer;" >&nbsp;&nbsp;<%=Global.change_management_type[4] %>&nbsp;&nbsp;</a></th>
		               	<th class="head0" style="text-align: center;"><a style="cursor:pointer;" >&nbsp;&nbsp;<%=Global.change_management_type[5] %>&nbsp;&nbsp;</a></th>
					</tr>
				</thead>
				<tbody>
				<%if(change_managementList!=null&&!change_managementList.isEmpty()){ 
					for(ChangeManagement change_management:change_managementList){
				%>
		        	<tr>
		              	<td class="center" style="height: 26px;text-align: left;"><%=Util.convertToString(change_management.getReport_date()).replace(" 00:00:00","") %></td>
		              	
		              	<td class="center" style="text-align: center;"><%=(Global.change_management_type[0].equals(Util.convertToString(change_management.getType()))?"√":"") %></td>
		              	<td class="center" style="text-align: center;"><%=(Global.change_management_type[1].equals(Util.convertToString(change_management.getType()))?"√":"") %></td>
		              	<td class="center" style="text-align: center;"><%=(Global.change_management_type[2].equals(Util.convertToString(change_management.getType()))?"√":"") %></td>
		              	<td class="center" style="text-align: center;"><%=(Global.change_management_type[3].equals(Util.convertToString(change_management.getType()))?"√":"")%></td>
		              	<td class="center" style="text-align: center;"><%=(Global.change_management_type[4].equals(Util.convertToString(change_management.getType()))?"√":"") %></td>
		              	<td class="center" style="text-align: center;"><%=(Global.change_management_type[5].equals(Util.convertToString(change_management.getType()))?"√":"") %></td>
		              	
		              	<td class="center" style="text-align: left;"><%=Util.convertToString(change_management.getExt_1()) %></td>
		              	<td class="center" style="text-align: left;"><%=Util.convertToString(change_management.getExt_2()) %></td>
		              	<td class="center" style="text-align: left;"><%=Util.convertToString(change_management.getExt_3()) %></td>
		              	<td class="center" style="text-align: left;"><%=Util.convertToString(change_management.getExt_4()) %></td>
		              	<td class="center" style="text-align: left;">
		              		<%=Util.subStr(Util.convertToString(change_management.getExt_5_1()), "(") %><br/>
		              		<%=Util.subStr(Util.convertToString(change_management.getExt_5_2()), "(") %><br/>
		              		<%=Util.subStr(Util.convertToString(change_management.getExt_5_3()), "(") %><br/>
		              		<%=Util.subStr(Util.convertToString(change_management.getExt_5_4()), "(") %><br/>
		              		<%=Util.subStr(Util.convertToString(change_management.getExt_5_5()), "(") %>
		              	</td>
		     		</tr>
		     	<%}
		     	}else{ %>
		     		<tr><td colspan='12'>无数据</td></tr>
		     	<%} %>
		   		</tbody>
			</table>
		</div><!--widgetcontent-->	
	</div><!--widgetbox-->
<script type="text/javascript">
//$(".stdtable").css("width",(_window_width+_window_width)+"px");
</script>