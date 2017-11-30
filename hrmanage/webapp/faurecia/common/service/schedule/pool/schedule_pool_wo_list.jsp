<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.authority.pojo.UserInfo" %>
<%
	UserInfo user = (UserInfo)session.getAttribute("user");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	
	String params = "";
	if (request.getQueryString() != null) {
		params = request.getQueryString();
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/faurecia/common/service/schedule/pool/js/schedule_pool.js"></script>
<script type="text/javascript">
		$(function(){
			var _url = ctx+'/faurecia/common/service/schedule/pool/schedule_pool_wo_list_inner.jsp?<%=params%>';
			var param = {};
			param['pageIndex']=1;
			param['pageSize']=1000;	
			inner_html(_url,param,'schedule_id',function(data){
				$("#schedule_id").html(data);
				$('#contentwrapper #batch_submit').click(function(){
		       		var wo_numbers = getCheckBoxVals().join(",");
		       		if(wo_numbers!=''&&wo_numbers.length>0){
		       			var tmp_param = {};
						tmp_param['wo_number']=wo_numbers;
						tmp_param['pageIndex']=1;
						tmp_param['pageSize']=1000000;	
						tmp_param['available']='1';
						var ids = '0,';
						ajaxUrlFalse(ctx+'/common/scheduleInfoPool/queryResult.do?',tmp_param,function(json){
							$.each(json.rows, function (n, value) {  
								ids += value.id+",";
					        });
					        ids = ids.substr(0,ids.length-1);
						});
						var msg = addBatchToSchedule(ids).split("<br/>")[0];
						if(msg.Trim().length>0){
							parent.showMsgInfo(msg);
						}else{
							
						}
						parent.document.getElementById('iframe_menu_'+_parent_menu_id).contentWindow.location.reload(true);
		    			parent.jClose();
		       		}
				});
			});
		});
</script>

</head>
<body>
	<div id="contentwrapper" class="contentwrapper" style="width:90%;">
		<form class="stdform stdform2" onSubmit="return false;">
			<div id="schedule_id"></div>
		</form>
	</div>
</body>
</html>