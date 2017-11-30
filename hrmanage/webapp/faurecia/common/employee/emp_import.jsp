<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
    Map<Integer,MenuInfo> menuInfoMap = (Map<Integer,MenuInfo>)session.getAttribute("menuRole");
    String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/faurecia/common/employee/js/emp.js"></script>
<script type="text/javascript">
	$(function(){
		$("#file").attr("accept","<%=Global.UPLOAD_ACCEPT_3%>");
		$('#searchModelBtn').click(function(){
			var u = ctx+"/common/employeeInfo/exportModelCsv.do"; //请求链接
			parent.downFile(u,'');
		});
	});
	function editFile(upload_uuid){
		var param = {};
		param['upload_uuid'] = upload_uuid;
		ajaxUrl(ctx+'/common/employeeInfo/importEmp.do',param,function(json){
			showMsgInfo(json.msg);
		});
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
	<table>
		<tr>
			<td>
			<jsp:include page="/share/jsp/upload_file.jsp" />
			</td>
		</tr>
		<tr>
			<td>
			<input type="button" id="searchModelBtn" value="模板" style="margin: 5px;height:34px;"/>
			</td>
		</tr>
	</table>
</body>
</html>