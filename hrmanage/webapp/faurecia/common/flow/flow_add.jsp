<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.service.*"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />

<script type="text/javascript" src="${ctx }/faurecia/common/flow/js/flow.js"></script>
<script type="text/javascript">
$(function(){
	$("#flow_name").change(function(){
		if($(this).val()=='<%=Global.flow_type[1]%>'){
			$("#breaktime_tr").show();
		}else{
			$("#days_down").val('0');
			$("#days_up").val('0');
			$("#breaktime_tr").hide();
		}
	});
	$('#flow_name').trigger('change');
});

function addFlowStep(){
	showHtml('${ctx}/faurecia/common/flow/flow_step.jsp','流程步骤',850,400);
}
</script>
</head>
<body>
	<div id="contentwrapper" class="contentwrapper" style="width:756px;">
		<jsp:include page="/share/jsp/menuAll.jsp" />
	    <br />
		<div>
		<form class="stdform stdform2" onSubmit="return false;">
			<div class="widgetbox">
				<div class="widgetcontent padding0 statement">
			   		<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
				        <thead>
				            <tr>
				                <th class="head1" style="width:15%"></th>
				                <th class="head1" style="width:35%"></th>
				                <th class="head1" style="width:15%"></th>
				                <th class="head1" style="width:35%"></th>
				            </tr>
				        </thead>
			        	<tbody>
		        			<tr>
					        	<td style="font-weight:bold;" align="center">编码</td>
						       	<td>
						       		<input type="text" name="flow_code" id="flow_code"  class="smallinput" title="流程编码" value=""/>
						       	</td>
						       	<td style="font-weight:bold" align="center">流程名称</td>
						       	<td>
							       	<select name="flow_name" id="flow_name" title="流程名称" class="uniformselect">
				                    	<option value="">---请选择---</option>
				                     	<%for(String s:Global.flow_type){ %>
				                      	<option value="<%=s%>"><%=s%></option>
				                      	<%} %>
				                 	</select>
						       	</td>
					       	</tr>
					       	<tr id="breaktime_tr">
					        	<td style="font-weight:bold" align="center">休假&nbsp;&gt;=&nbsp;</td>
					        	<td>
					        		<input type="text" name="days_down" id="days_down" class="smallinput" value="" onkeyup="replaceForNum(this);" onafterpaste="replaceForNum(this);"/>&nbsp;天
					        	</td>
					        	<td style="font-weight:bold;" align="center">休假&nbsp;&lt;&nbsp;</td>
					        	<td>
					        		<input type="text" name="days_up" id="days_up" class="smallinput" value="" onkeyup="replaceForNum(this);" onafterpaste="replaceForNum(this);"/>&nbsp;天
					        	</td>
					        </tr>
					       	<tr>
					        	<td style="font-weight:bold;" align="center">有效</td>
						       	<td>
						       		<select name="state" id="state" class="uniformselect">
				                    	<option value="1">是</option>
				                    	<option value="0">否</option>
				                	</select>
						       	</td>
						       	<td style="font-weight:bold" align="center">流程</td>
						       	<td>
							       	<a style="cursor:pointer;" onclick="addFlowStep();">编辑步骤...</a>
						       	</td>
					       	</tr>
					    </tbody>
					</table>
				</div>
			</div>
			<div id="step_t"></div>
         	<input type="hidden" name="step_info" id="step_info" title="流程步骤" value=""/>
            <button id="submit" class="submit radius2">提交</button>
	    </form>
	    </div>
	</div>
</body>
</html>