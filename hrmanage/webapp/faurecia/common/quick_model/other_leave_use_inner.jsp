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
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	int emp_id = Integer.parseInt(StringUtils.defaultIfEmpty(request.getParameter("emp_id"), "0"));
	
//查询主数据的其它请假记录
	Calendar c = Calendar.getInstance();
	int year = c.get(Calendar.YEAR);
	String break_type1 = Global.breaktime_type[1].split("\\|")[0];
	String break_type8 = Global.breaktime_type[5].split("\\|")[0];
	BreakTimeInfoService breakTimeInfoService = (BreakTimeInfoService) ctx.getBean("breakTimeInfoService");
	Map<String,String> params = new HashMap<String,String>();
	params.put("emp_id", emp_id+"");
	params.put("year", year+"");
	params.put("type", break_type1);
	double break_type1_hours = breakTimeInfoService.getBreakHours(params);
	
	params.put("type", break_type8);
	double break_type8_hours = breakTimeInfoService.getBreakHours(params);	
%>
	
    <%if(break_type1_hours+break_type8_hours>0){ %>
    	<jsp:include page="/share/jsp/notibar_msg.jsp">
    		<jsp:param value="info" name="msg_type"/>
    		<jsp:param value="根据中国区的奖金政策，您的病事假累计到一定天数将会影响到您当年的13薪和奖金发放。" name="text"/>
    	</jsp:include>
	<%} %>
		<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
			<colgroup>
				<col class="con0" />
				<col class="con1" />
				<col class="con0" />
			</colgroup>
			<thead>
				<tr>
					<th class="head0">年份</th>
					<th class="head1">类型</th>
					<th class="head0">已休小时数(h)</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td><%=year %></td><td><%=break_type8 %></td><td><%=break_type8_hours %></td>
				</tr>
				<tr>
					<td><%=year %></td><td><%=break_type1 %></td><td><%=break_type1_hours %></td>
				</tr>
			</tbody>
		</table>