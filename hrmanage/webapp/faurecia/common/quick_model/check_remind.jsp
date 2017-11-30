<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.authority.pojo.UserInfo"%>
<%
	Map<Integer, MenuInfo> menuInfoMap = (Map<Integer, MenuInfo>) session
			.getAttribute("menuRole");
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	
		ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils
			.getRequiredWebApplicationContext(st);
	int emp_id = Integer.parseInt(StringUtils.defaultIfEmpty(request.getParameter("emp_id"), "0"));
	OverTimeInfoService overTimeInfoService = (OverTimeInfoService) ctx.getBean("overTimeInfoService");
	OverTimeInfo overTimeInfo = new OverTimeInfo();
	overTimeInfo.setNext_check_emp_id(emp_id);
	overTimeInfo.setAvailable(1);
	overTimeInfo.setCheck_states(Global.flow_check_state[0]+","+Global.flow_check_state[1]);
	List<OverTimeInfo> otSHList = overTimeInfoService.findByCondition(overTimeInfo, null);
	
	BreakTimeInfoService breakTimeInfoService = (BreakTimeInfoService) ctx.getBean("breakTimeInfoService");
	BreakTimeInfo breakTimeInfo = new BreakTimeInfo();
	breakTimeInfo.setNext_check_emp_id(emp_id);
	breakTimeInfo.setAvailable(1);
	breakTimeInfo.setCheck_states(Global.flow_check_state[0]+","+Global.flow_check_state[1]);
	List<BreakTimeInfo> btSHList = breakTimeInfoService.findByCondition(breakTimeInfo, null);
	
	ScheduleInfoService scheduleInfoService = (ScheduleInfoService) ctx.getBean("scheduleInfoService");
	ScheduleInfo scheduleInfo = new ScheduleInfo();
	scheduleInfo.setNext_check_emp_id(emp_id);
	scheduleInfo.setAvailable(1);
	scheduleInfo.setCheck_states(Global.flow_check_state[0]+","+Global.flow_check_state[1]);
	List<ScheduleInfo> sSHList = scheduleInfoService.findByCondition(scheduleInfo, null);

	int mi133 = 133;
	int mi142 = 142;
	int mi149 = 149;

	MenuInfo mi133Parent = menuInfoMap.get(Integer.parseInt(Util.getMenuAllIdsById(mi133,menuInfoMap).split(",")[0]));
	MenuInfo mi142Parent = menuInfoMap.get(Integer.parseInt(Util.getMenuAllIdsById(mi142,menuInfoMap).split(",")[0]));
	MenuInfo mi149Parent = menuInfoMap.get(Integer.parseInt(Util.getMenuAllIdsById(mi149,menuInfoMap).split(",")[0]));
	
%>
<script>
$(function(){
});
function quick_sh_click(menu_url,menu_id,sub_menu_id){
	jumpLabelPage(menu_url,menu_id,sub_menu_id,'');
}
</script>
<div class="widgetbox">
	<div class="title">
		<h3>审批提醒</h3>
	</div>
	<div class="widgetcontent padding0 statement">
		<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
			<colgroup>
				<col class="con0" />
				<col class="con1" />
				<col class="con0" />
			</colgroup>
			<thead>
				<tr>
					<th class="head0">加班</th>
					<th class="head1">休假</th>
					<th class="head0">排班</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td><a style="cursor:pointer" onclick="quick_sh_click('<%=mi133Parent.getUrl()%>','<%=mi133Parent.getId()%>','<%=mi133%>');"><%=otSHList==null?0:otSHList.size() %></a></td>
					<td><a style="cursor:pointer" onclick="quick_sh_click('<%=mi142Parent.getUrl()%>','<%=mi142Parent.getId()%>','<%=mi142%>');"><%=btSHList==null?0:btSHList.size() %></a></td>
					<td><a style="cursor:pointer" onclick="quick_sh_click('<%=mi149Parent.getUrl()%>','<%=mi149Parent.getId()%>','<%=mi149%>');"><%=sSHList==null?0:sSHList.size() %></a></td>
				</tr>
			</tbody>
		</table>
	</div>
	<!--widgetcontent-->
</div>
<!--widgetbox-->