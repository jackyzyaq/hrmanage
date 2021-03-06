<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.authority.pojo.UserInfo"%>
<%
	Map<Integer,MenuInfo> menuInfoMap = (Map<Integer,MenuInfo>)session.getAttribute("menuRole");
	String roleCodes = StringUtils.defaultIfEmpty((String)session.getAttribute("roleCodes"),"");
    String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
    
    EmployeeInfo employeeInfo = (EmployeeInfo)session.getAttribute("employeeInfo");
    
	UserInfo user = (UserInfo) session.getAttribute("user");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	
	
	ServletContext st = request.getSession().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(st);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript">
$(function(){
	var params = {};
	params['emp_id']='<%=employeeInfo.getId()%>';
	params['zh_name']='<%=employeeInfo.getZh_name()%>';
	inner_html(ctx+'/faurecia/common/quick_model/leave_use.jsp',params,'leave_use',null);
	inner_html(ctx+'/faurecia/common/quick_model/other_leave_use.jsp',params,'other_leave_use',null);
	inner_html(ctx+'/faurecia/common/quick_model/over_use.jsp',params,'over_use',null);
	inner_html(ctx+'/faurecia/common/quick_model/sub_emp_list.jsp',params,'sub_emp_list',null);
});
</script>
</head>
<body>
	<%if (employeeInfo != null&&employeeInfo.getId()!=null){ %>
	        <div class="widgetbox">
				<div class="title">
					<h3>
						<Strong>所属部门</Strong>：<%=Util.getDeptAllNameById(employeeInfo.getDept_id(), Global.departmentInfoMap) %>
						&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
						<Strong>直属主管</Strong>：
						<jsp:include page="/share/jsp/leaderAll.jsp">
									<jsp:param value="<%=employeeInfo.getDept_id() %>" name="dept_id"/>
									<jsp:param value="<%=employeeInfo.getZh_name() %>" name="zh_name"/>
								</jsp:include>
					</h3>
				</div>
			</div>
			<jsp:include page="/faurecia/common/quick_model/notice.jsp">
				<jsp:param value="<%=employeeInfo.getId() %>" name="emp_id"/>
			</jsp:include>			
            <%if(Util.contains(roleCodes, Global.default_role[3],",")){ %>
            <jsp:include page="/faurecia/common/quick_model/check_remind_wo.jsp">
                <jsp:param value="<%=employeeInfo.getId() %>" name="emp_id"/>
            </jsp:include>
            <%} %>
            
            <div id="sub_emp_list"></div>
            
            <div class="one_half">
				<div id="leave_use"></div>
				<div id="other_leave_use"></div>
			</div><!--one_half-->
			<div class="one_half last">
				<div id="over_use"></div>
			</div>

            <%if(Util.contains(roleCodes, Global.default_role[1],",")){ %>
            <jsp:include page="/faurecia/common/quick_model/other_remind.jsp">
                <jsp:param value="<%=employeeInfo.getId() %>" name="emp_id"/>
            </jsp:include>
            <%} %>
	<%}%>
</body>
</html>