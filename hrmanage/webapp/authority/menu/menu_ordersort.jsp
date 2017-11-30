<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/authority/menu/js/menu.js"></script>
</head>
<body>
	<div id="contentwrapper" class="contentwrapper">
		<form class="yqstdform" onSubmit="return false;">
			<div>
				<label><button id="orderSortSubmit" class="submit radius2">提交</button></label>
				<span class="field">
					<jsp:include page="/share/jsp/menu_drag.jsp"></jsp:include>
				</span>
			</div>
			<br clear="all" />
		</form>
	</div>
</body>
</html>   
