<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	int menu_id = Integer.valueOf(StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0"));
	Calendar cal = Calendar.getInstance();
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<link rel="stylesheet" href="${ctx }/faurecia/ETOP5/css/style.css" type="text/css" />
<script>
	var supervisor_header = '<%=Global.supervisor_ranking_type[0]%>';
	$(function(){
		$("#begin_month").val("<%=cal.get(Calendar.YEAR)+"-"+(cal.get(Calendar.MONTH)+1) %>");
		getEndMonthFn();
	});
</script>
<script type="" src="${ctx }/faurecia/ETOP5/number/data/js/supervisoer_ranking.js"></script>
</head>
<body>
	<div id="contentwrapper" class="contentwrapper widgetpage">
		<div class="widgetbox">
			<form id="supervisor_ranking_form" class="stdform" onSubmit="return false;">
				<div class="title">
					<h4>团队绩效月考核</h4>
				</div>
			    <div>
			       <table cellpadding="0" cellspacing="0" border="0" class="stdtable">
			            <thead>
			                <tr>
			                    <th class="head1" style="width: 5%"></th>
			                    <th class="head1" style="width: 25%"></th>
			                    <th class="head1" style="width: 10%"></th>
			                    <th class="head1" style="width: 25%"></th>
			                    <th class="head1" style="width: 10%"></th>
			                    <th class="head1" style="width: 25%"></th>
			                </tr>
			            </thead>
			            <tbody>
			            	<tr>
			            		<td>月份</td>
			                    <td>
			                    	<input class="smallinput" title="月份" type="text" readonly="readonly" id="begin_month" name="begin_month" value=""/>
			                    	~
			                    	<input class="smallinput" title="月份" type="text" readonly="readonly" id="end_month" name="end_month" value="" />
			                    </td>
					        	<td style="font-weight:bold" align="center">部门</td>
					        	<td>
					        		<jsp:include page="/share/jsp/dept_role_ztree.jsp"></jsp:include>
					        		<input type="hidden" id="dept_employee_id"  name="supervisor"/>
					        	</td>
					        	<td>主管</td>
					        	<td id="dept_employee_td_id">
					        	</td>
			                </tr>
			            </tbody>
			        </table>
				</div>
				<div id="supervisor_header"></div>
				<!--widgetcontent-->
			</form>
		</div>
		<!--widgetbox-->
		<div id="supervisor_ranking_view"></div>
	</div>
</body>
</html>
