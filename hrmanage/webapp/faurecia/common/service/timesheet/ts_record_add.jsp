<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
    Map<Integer,MenuInfo> menuInfoMap = (Map<Integer,MenuInfo>)session.getAttribute("menuRole");
    String roleCodes = (String)session.getAttribute("roleCodes");
    String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript">
$(function(){
	$('#submitBtn').click(function(){
		var emp_ids = $('#emp_id').val().split(',');
		if($('#emp_id').val()=='0'||$('#emp_id').val()==''){
			showMsgInfo('请选择员工！');
			return ;
		}
		if($('#class_date').val()==''){
			showMsgInfo('请选择考勤日期！');
			return ;
		}
		var param = {};
		var msg = '';
		for(var i=0;i<emp_ids.length;i++){
			param['emp_id']=emp_ids[i];
			param['class_date']=$('#class_date').val();
			param['type']=$('#type').val();
			ajaxUrlFalse(ctx+'/common/timeSheet/addEmpTimeSheet.do',param,function(json){
				if(json.msg!=''){
			    	msg = json.msg;
				}else{
				}
			});
		}
		if(msg.Trim().length>0){
			parent.showMsgInfo(msg.Trim());
		}
		parent.document.getElementById('iframe_menu_'+_parent_menu_id).contentWindow.location.reload(true);
		parent.jClose();
	});
});
</script>
</head>
<body>
	<div>
        <div id="contentwrapper" style="margin: 10px;">
        	<form  class="stdform stdform2" onSubmit="return false;">
        		<div>
	        		<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
	        			<tr>
	        				<td style="font-weight:bold;" align="center">员工</td>
	        				<td><jsp:include page="/share/jsp/employee_ztree_checkbod_nodepart.jsp" /></td>
	        			</tr>
	        			<tr>
	        				<td style="font-weight:bold;" align="center">考勤日期</td>
	        				<td><input style="width:45%" type="text" readonly="readonly" id="class_date" name="class_date" value=""  onfocus="wdateTimeInstance();"/></td>
	        			</tr>
	        			<tr>
	        				<td style="font-weight:bold;" align="center">考勤类型</td>
	        				<td>
								<select id="type" name="type">
									<option value="<%=Global.timesheet_type[0]%>" selected><%=Global.timesheet_type[0]%></option>
									<option value="<%=Global.timesheet_type[1]%>"><%=Global.timesheet_type[1]%></option>
									<option value="<%=Global.timesheet_type[2]%>"><%=Global.timesheet_type[2]%></option>
								</select>        				
	        				</td>
	        			</tr>
	        		</table>        		
        		</div>
				<br/>
				<div>
					<a id="submitBtn" style="cursor:pointer;" class="btn btn_search radius50"><span>提交</span></a>&nbsp;&nbsp;&nbsp;
				</div>	
			</form>	
        </div>
	</div>
</body>
</html>