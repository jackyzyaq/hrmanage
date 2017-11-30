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
		if($('#start_date').val()==''||$('#over_date').val()==''){
			showMsgInfo('请选择考勤日期！');
			return ;
		}else if(parseDate($('#over_date').val()).getTime()-parseDate($('#start_date').val()).getTime()>=getTimeInMillis(7,"d")){
			showMsgInfo('最大周期是7天！');
			return ;
		}
		if($('#emp_id').val()==''||$('#emp_id').val()=='0'){
			showMsgInfo('请选择员工！');
			return ;
		}
		var param = {};
		param['start_date']=$('#start_date').val();
		param['over_date']=$('#over_date').val();
		param['emp_ids']=$("#emp_id").val();
		ajaxUrl(ctx+'/common/timeSheet/runEmpTimeSheet.do',param,function(json){
			if(json.msg!=''){
			    parent.showMsgInfo(json.msg);
			}else{
			}
			parent.document.getElementById('iframe_menu_'+_parent_menu_id).contentWindow.location.reload(true);
			parent.jClose();
		});
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
	        				<td style="font-weight:bold;" align="center">考勤起始日期</td>
	        				<td><input style="width:35%" type="text" readonly="readonly" id="start_date" name="start_date" value=""  onfocus="wdateBeginInstance('over_date');"/></td>
	        			</tr>
	        			<tr>
	        				<td style="font-weight:bold;" align="center">考勤结束日期</td>
	        				<td><input style="width:35%" type="text" readonly="readonly" id="over_date" name="over_date" value=""  onfocus="wdateEndInstance('start_date');"/></td>
	        			</tr>
	        			<tr>
	        				<td style="font-weight:bold;" align="center">员工</td>
	        				<td><jsp:include page="/share/jsp/employee_ztree_checkbod_nodepart.jsp" /></td>
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