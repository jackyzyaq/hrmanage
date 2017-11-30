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
<script>
	$(function(){
		$("#begin_date").click(function(){
			wdateBeginInstance('end_date');
		});	
		$("#end_date").click(function(){
			wdateEndInstance('begin_date');
		});	
		$("#plantScheduleAddSubmit").click(function(){
			if(validateForm("plantSchedule_form")){
				if (confirm('是否提交？')) {
					var param = getParamsJson("plantSchedule_form");
					param['begin_date'] = param['begin_date']+" 00:00:00";
					param['end_date'] = param['end_date']+" 00:00:00";
					ajaxUrl(ctx+'/common/plantSchedule/plantScheduleAdd.do',param,function(json){
						if(json.flag=='1'){
						}else{
							showMsgInfo(json.msg+'');
							plantSchedule_view_inner();
							parent.document.getElementById('iframe_menu_<%=menu_id%>').contentWindow.location.reload(true);
						}
					});
				}
			}
		});
		$("#plantScheduleEditSubmit").click(function(){
			if(validateForm("plantSchedule_form")){
				if (confirm('是否提交？')) {
					var param = getParamsJson("plantSchedule_form");
					param['begin_date'] = param['begin_date']+" 00:00:00";
					param['end_date'] = param['end_date']+" 00:00:00";
					ajaxUrl(ctx+'/common/plantSchedule/plantScheduleEdit.do',param,function(json){
						if(json.flag=='1'){
						}else{
							showMsgInfo(json.msg+'');
							plantSchedule_view_inner();
							parent.document.getElementById('iframe_menu_<%=menu_id%>').contentWindow.location.reload(true);
						}
					});
				}
			}
		});
		plantSchedule_view_inner();
	});
	function plantSchedule_view_inner(){
		var params = {};
		inner_html(ctx+'/faurecia/ETOP5/plant/data/plant_schedule_view.jsp',
					params,'plantSchedule_view',null);
	}
</script>
</head>
<body>
	<div id="contentwrapper" class="contentwrapper widgetpage">
		<div class="widgetbox">
			<form id="plantSchedule_form" class="stdform" onSubmit="return false;">
				<div class="title">
					<h4>PLANT SCHEDULE</h4>
				</div>
			    <div class="widgetcontent padding0 statement">
			       <table cellpadding="0" cellspacing="0" border="0" class="stdtable">
			            <thead>
			                <tr>
			                    <th class="head1"></th>
			                    <th class="head1"></th>
			                    <th class="head1"></th>
			                    <th class="head1"></th>
			                    <th class="head1"></th>
			                    <th class="head1"></th>
			                </tr>
			            </thead>
			            <tbody>
			            	<tr>
			                    <td>开始时间</td>
			                    <td>
			                    	<input class="smallinput" title="开始时间" type="text" readonly="readonly" id="begin_date" name="begin_date" value=""/>
			                    </td>
			                    <td>结束时间</td>
			                    <td>
			                    	<input class="smallinput" title="结束时间" type="text" readonly="readonly" id="end_date" name="end_date" value=""/>
			                    </td>
			                    <td>状态</td>
			                    <td>
			                    	<select id="state" name="state">
			                    		<option value="1" selected>有效</option>
			                    		<option value="0">无效</option>
			                    	</select>
			                    </td>
			                </tr>
							<tr>
			                    <td>标题</td>
			                    <td colspan="5">
			                    	<input class="longinput" title="标题" type="text" id="title" name="title" value=""/>
			                    </td>
			                </tr>
			                <tr>
			                	<td colspan="6">
				                	<div class="stdformbutton">
				                	<input type="hidden" id="id" name="id" value="0"/>
									<button id="plantScheduleAddSubmit" class="submit radius2">提交</button>
									<button id="plantScheduleEditSubmit" class="submit radius2">更新</button>
									</div>
			                	</td>
			                </tr>
			            </tbody>
			        </table>
			    </div><!--widgetcontent-->
			</form>
		</div>
		<!--widgetbox-->
		<div id="plantSchedule_view"></div>
	</div>
</body>
</html>
