<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.authority.pojo.UserInfo"%>
<%@ page import="net.sf.json.JSONObject"%>
<%
	Map<Integer,MenuInfo> menuInfoMap = (Map<Integer,MenuInfo>)session.getAttribute("menuRole");
	String roleCodes = StringUtils.defaultIfEmpty((String)session.getAttribute("roleCodes"),"");
    String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
    
    EmployeeInfo employeeInfo = (EmployeeInfo)session.getAttribute("employeeInfo");
    
    JSONObject jsonObj = JSONObject.fromObject(employeeInfo);
    
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
var emParams = '<%= jsonObj.toString() %>';
//alert(emParams);
$(function(){
	var params = {};
	params['emp_id']='<%=employeeInfo.getId()%>';
	params['zh_name']='<%=employeeInfo.getZh_name()%>';
	/* inner_html(ctx+'/faurecia/common/quick_model/leave_use.jsp',params,'leave_use',null);
	inner_html(ctx+'/faurecia/common/quick_model/other_leave_use.jsp',params,'other_leave_use',null);
	inner_html(ctx+'/faurecia/common/quick_model/over_use.jsp',params,'over_use',null);
	inner_html(ctx+'/faurecia/common/quick_model/sub_emp_list.jsp',params,'sub_emp_list',null); */
	var url='http://localhost:18180/fhr/mlogon/in';
	var fn = "";
	params['loginvalue'] = 'admin';
	params['passvalue'] = '888888';
	params['emParams'] = emParams;
	$.ajax({
		url : url, // 请求链接
		data: params,
		type:"POST",     // 数据提交方式
		cache: false,
		timeout: 300000,
		async:false,
		dataType: 'jsonp',
        crossDomain: true,
		jsonp: "callback",//传递给请求处理程序或页面的，用以获得jsonp回调函数名的参数名(一般默认为:callback)
        jsonpCallback:"handleCallBackData",//自定义的jsonp回调函数名称，默认为jQuery自动生成的随机函数名，也可以写"?"，jQuery会自动为你处理数据
		success:function(json){
			alert(json.fromId);
		},
		beforeSend:function(){

		},
		complete:function(){

		},
		error:function(json){
			alert(json.fromId);
		}
	});	
});

</script>
</head>
<body>
<br />
<center><h1>合理化建议</h1></center>
<!-- <dir style="display: none;"> -->
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
	<%}%><!-- </dir> -->
</body>
</html>