<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
</head>
<body>
	<div id="contentwrapper" class="contentwrapper">
		<script type="text/javascript">
		$(function(){
			qrci_index_inner();
		});
		function qrci_index_inner(){
			var params = {};
			params['menu_id']=<%=menu_id%>;
			inner_html(ctx+'/faurecia/ETOP5/qrci/qrci_index_inner.jsp',params,'contentwrapper #qrci_index_inner',null);
		}
		</script>
		<div class="widgetbox">
			<div class="title" style="float: right">
				<h4>
				<jsp:include page="/share/jsp/screen_full.jsp" />
				</h4>
			</div>
		</div>
		<div id="qrci_index_inner"></div>
	</div>
</body>
</html>