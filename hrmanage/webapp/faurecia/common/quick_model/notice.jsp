<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.authority.pojo.UserInfo"%>
<%
	Map<Integer, MenuInfo> menuInfoMap = (Map<Integer, MenuInfo>) session.getAttribute("menuRole");
	UserInfo user = (UserInfo) session.getAttribute("user");
	
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils
			.getRequiredWebApplicationContext(st);
	int emp_id = Integer.parseInt(StringUtils.defaultIfEmpty(request.getParameter("emp_id"), "0"));
	OverTimeInfoService overTimeInfoService = (OverTimeInfoService) ctx.getBean("overTimeInfoService");
	OverTimeInfo overTimeInfo = new OverTimeInfo();
	overTimeInfo.setUser_id(user.getId());
	overTimeInfo.setAvailable(1);
	overTimeInfo.setCheck_states(Global.flow_check_state[2]+"");
	List<OverTimeInfo> otSHList = overTimeInfoService.findByCondition(overTimeInfo, null);
	
	BreakTimeInfoService breakTimeInfoService = (BreakTimeInfoService) ctx.getBean("breakTimeInfoService");
	BreakTimeInfo breakTimeInfo = new BreakTimeInfo();
	breakTimeInfo.setUser_id(user.getId());
	breakTimeInfo.setAvailable(1);
	breakTimeInfo.setCheck_states(Global.flow_check_state[2]+"");
	List<BreakTimeInfo> btSHList = breakTimeInfoService.findByCondition(breakTimeInfo, null);
	
	ScheduleInfoService scheduleInfoService = (ScheduleInfoService) ctx.getBean("scheduleInfoService");
	ScheduleInfo scheduleInfo = new ScheduleInfo();
	scheduleInfo.setUser_id(user.getId());
	scheduleInfo.setAvailable(1);
	scheduleInfo.setCheck_states(Global.flow_check_state[2]+"");
	List<ScheduleInfo> sSHList = scheduleInfoService.findWOByCondition(scheduleInfo, null);


	//138	休假列表
	//145	排班列表
	//125	加班列表
	int mi138 = 138;
	MenuInfo mi138Parent = null;
	if(!StringUtils.isEmpty(Util.getMenuAllIdsById(mi138,menuInfoMap).split(",")[0])){
		mi138Parent = menuInfoMap.get(Integer.parseInt(Util.getMenuAllIdsById(mi138,menuInfoMap).split(",")[0]));
	}
	
	
	
	int mi145 = 145;
	MenuInfo mi145Parent = null;
	if(!StringUtils.isEmpty(Util.getMenuAllIdsById(mi145,menuInfoMap).split(",")[0])){
		mi145Parent = menuInfoMap.get(Integer.parseInt(Util.getMenuAllIdsById(mi145,menuInfoMap).split(",")[0]));
	}
	
	int mi125 = 125;
	MenuInfo mi125Parent = null;
	if(!StringUtils.isEmpty(Util.getMenuAllIdsById(mi125,menuInfoMap).split(",")[0])){
		mi125Parent = menuInfoMap.get(Integer.parseInt(Util.getMenuAllIdsById(mi125,menuInfoMap).split(",")[0]));
	}
%>
<script>
$(function(){
	$('.notibar .close').click(function(){
		$(this).parent().fadeOut(function(){
			$(this).remove();
		});
	});
});
function quick_bh_click(menu_url,menu_id,sub_menu_id,params){
	jumpLabelPage(menu_url,menu_id,sub_menu_id,params);
}
</script>
<%if(otSHList!=null&&!otSHList.isEmpty()||btSHList!=null&&!btSHList.isEmpty()||sSHList!=null&&!sSHList.isEmpty()){ %>
<div class="notibar announcement">
	<a class="close"></a>
    <h3>Notice</h3>
    <p>
    <%if(otSHList!=null&&!otSHList.isEmpty()&&mi125Parent!=null){ %>
    <a style="cursor:pointer" onclick="quick_bh_click('<%=mi125Parent.getUrl()%>','<%=mi125Parent.getId()%>','<%=mi125%>','<%="check_state:"+Global.flow_check_state[2]%>');">加班驳回【<%=otSHList.size() %>】.</a>
    <%} %>
    <%if(btSHList!=null&&!btSHList.isEmpty()&&mi138Parent!=null){ %>
    <a style="cursor:pointer" onclick="quick_bh_click('<%=mi138Parent.getUrl()%>','<%=mi138Parent.getId()%>','<%=mi138%>','<%="check_state:"+Global.flow_check_state[2]%>');">休假驳回【<%=btSHList.size() %>】.</a>
    <%} %>
    <%if(sSHList!=null&&!sSHList.isEmpty()&&mi145Parent!=null){ %>
    <a style="cursor:pointer" onclick="quick_bh_click('<%=mi145Parent.getUrl()%>','<%=mi145Parent.getId()%>','<%=mi145%>','<%="check_state:"+Global.flow_check_state[2]%>');"> 排班驳回【<%=sSHList.size() %>】.</a>
    <%} %>
    </p>
</div>
<%}%>