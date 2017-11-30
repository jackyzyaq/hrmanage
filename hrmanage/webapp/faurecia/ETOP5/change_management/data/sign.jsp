<%@page import="com.yq.faurecia.service.DepartmentInfoService"%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	Map<Integer, MenuInfo> menuInfoMap = (Map<Integer, MenuInfo>) session.getAttribute("menuRole");
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String id = StringUtils.defaultIfEmpty(request.getParameter("id"), "0");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	Calendar cal = Calendar.getInstance();
	String end_date = sdf.format(cal.getTime());
	cal.add(Calendar.DAY_OF_MONTH, -6);
	String begin_date = sdf.format(cal.getTime());
	
%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript">
	$(function(){
		$('#contentwrapper #submit').click(function(){
			var str_=getDragNodesJson();
			if(str_.Trim().length>0){
				var step = str_.split('][');
				var emp_names = '';
				var emp_ids = '';
				for(var i=0;i<step.length;i++){
					emp_names+=step[i].split(",")[1].split('|')[3]+':'+step[i].split(",")[1].split('|')[5]+'|';
				}
				emp_names=emp_names.substr(0,emp_names.length-1);
				if(emp_names.split("|").length!=5){
					showMsgInfo("人数必须是5人！");
					return ;
				}
				var param = {};
				param['id']='<%=id%>';
				param['emp_names']=emp_names;
				ajaxUrl( ctx+'/common/change_management/doChangeManagementSign.do',param,function(json){
					parent.showMsgInfo(json.msg);
					parent.queryResult();
					parent.jClose();
				});
			}
		});
	});
</script>
</head>
<body >
	<div id="contentwrapper" style="width:100%;">
		<form class="stdform stdform2" onSubmit="return false;">
			<jsp:include page="/share/jsp/dept_emp_selecte.jsp"></jsp:include>
            <div>
			<button id="submit" class="submit radius2">提交</button>
			</div>
		</form>
	</div>	
</body>
</html>