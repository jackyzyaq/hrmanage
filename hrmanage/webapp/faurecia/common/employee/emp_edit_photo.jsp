<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	int emp_id = StringUtils.isEmpty(request.getParameter("emp_id"))?-1:Integer.parseInt(request.getParameter("emp_id"));
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils
			.getRequiredWebApplicationContext(st);
	EmployeeInfoService employeeInfoService = (EmployeeInfoService) ctx.getBean("employeeInfoService");
	
	EmployeeInfo employeeInfo = employeeInfoService.queryById(emp_id,null);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<script type="text/javascript" src="${ctx }/js/ama/js/plugins/jquery-1.7.min.js"></script>
<script type="text/javascript">
	$(function(){
		$("#file").attr("accept","<%=Global.UPLOAD_ACCEPT_1%>");
	});
	function editFile(upload_uuid){
		parent.editFile(upload_uuid,'<%=emp_id%>');
	}
</script>
<style>
.photo{
margin-left:0 auto;
text-align:center;
vertical-align:middle;
}
.remark {
margin-top:10px;
FONT-SIZE: 14px; 
FONT-FAMILY: Arial, Helvetica, sans-serif,'宋体',tahoma, Srial, helvetica, sans-serif;
}
</style>
</head>
<body>
	<div class="photo">
		<div>
			<img src="${ctx }/share/jsp/showImage.jsp?file=<%=StringUtils.defaultIfEmpty(employeeInfo.getPhoto_upload_uuid(),"0") %>" alt="" width="150" height="180"/>
        </div>
        <div>
        	<div class="remark">
        	仅支持JPG、GIF、PNG图片文件，且文件小于<%=Global.UPLOAD_SIZE_1/1000 %>kb
        	</div>
        	<jsp:include page="/share/jsp/upload_file.jsp" />
        </div>
	</div>
</body>
</html>