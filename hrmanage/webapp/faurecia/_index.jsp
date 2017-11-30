<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.authority.pojo.UserInfo" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript">
$(function(){
	showHtml("http://www.baidu.com","tst",900);
});
</script>
<script type="text/javascript" src="${ctx }/faurecia/common/service/overtime/js/overtime.js"></script>
</head>
<body>
	<div id="contentwrapper" class="contentwrapper" style="width:90%;">
		<form class="stdform stdform2" onSubmit="return false;">
			<div>
				<div class="widgetbox">
					<div class="widgetcontent padding0 statement">
				   		<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
					        <tbody>
					        <tr>
					        	<td style="font-weight:bold;" align="center">开始时间</td>
					        	<td>
					        		<input class="Wdate" type="text" title="开始时间" readonly="readonly" id="begin_date" name="begin_date" value=""  onclick="wdateBeginInstance('end_date');"/>
					        	</td>
					        	<td style="font-weight:bold" align="center">结束时间</td>
					        	<td>
					        		<input class="Wdate" type="text" title="结束时间" readonly="readonly" id="end_date" name="end_date" value=""  onclick="wdateEndInstance('begin_date');"/>
					        	</td>
					        	<td style="font-weight:bold" align="center"></td>
					        	<td>
					        	</td>
					        </tr>
			         		</tbody>
			       		</table>
			     	</div>
			   </div>				
			</div>
		</form>
	</div>
</body>
</html>