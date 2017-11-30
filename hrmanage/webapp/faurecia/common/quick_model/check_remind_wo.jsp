<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.authority.pojo.UserInfo"%>
<%
	Map<Integer, MenuInfo> menuInfoMap = (Map<Integer, MenuInfo>) session.getAttribute("menuRole");
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
	List<ScheduleInfo> sSHList = scheduleInfoService.findWOByCondition(scheduleInfo, null);

	int mi172 = 172;
	MenuInfo mi172Parent = menuInfoMap.get(Integer.parseInt(Util.getMenuAllIdsById(mi172,menuInfoMap).split(",")[0]));
	
%>
<script>
$(function(){
});
function quick_sh_click(menu_url,menu_id,sub_menu_id,params){
	jumpLabelPage(menu_url,menu_id,sub_menu_id,params);
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
					<td><a style="cursor:pointer" onclick="quick_sh_click('<%=mi172Parent.getUrl()%>','<%=mi172Parent.getId()%>','<%=mi172%>','<%="flow_type:"+Global.flow_type[2]%>');"><%=otSHList==null?0:otSHList.size() %></a></td>
					<td><a style="cursor:pointer" onclick="quick_sh_click('<%=mi172Parent.getUrl()%>','<%=mi172Parent.getId()%>','<%=mi172%>','<%="flow_type:"+Global.flow_type[1]%>');"><%=btSHList==null?0:btSHList.size() %></a></td>
					<td><a style="cursor:pointer" onclick="quick_sh_click('<%=mi172Parent.getUrl()%>','<%=mi172Parent.getId()%>','<%=mi172%>','<%="flow_type:"+Global.flow_type[0]%>');"><%=sSHList==null?0:sSHList.size() %></a></td>
				</tr>
			</tbody>
		</table>
	</div>
	<!--widgetcontent-->
</div>
<!--widgetbox-->