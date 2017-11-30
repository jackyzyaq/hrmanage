<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.authority.pojo.UserInfo" %>
<%
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	int id = Integer.parseInt(StringUtils.defaultIfEmpty(request.getParameter("id"), "0"));
	UserInfo user = (UserInfo)session.getAttribute("user");
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	ScheduleInfoPoolService scheduleInfoPoolService = (ScheduleInfoPoolService) ctx.getBean("scheduleInfoPoolService");
	EmployeeInfoService employeeInfoService = (EmployeeInfoService) ctx.getBean("employeeInfoService");
	ScheduleInfoPool oti = scheduleInfoPoolService.queryPoolById(id, null);
	EmployeeInfo employeeInfo = employeeInfoService.queryById(oti.getEmp_id(), null);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript">
$(function(){
	inner_html('${ctx}/faurecia/common/class_info/class_info_add_inner.jsp',
				null,
				'schedule_div',
				function(html_str){
					$("#schedule_div").html(html_str);
					$("#class_code").val("无");
					$("#class_code").attr("disabled","disabled");
					$("#class_info_table table tr:eq(1)").remove();
					clickMealses();
					$("#type").change(function(){
						if($(this).val()=='<%=Global.schedule_type[0]%>'){
							planIn();
						}else{
							$("#type_sub").empty();
							$("#class_id").val(0);
							planOut('<%=oti.getId()%>');
						}
					});
					$("#type").val('<%=oti.getType()%>');
					$("#type").trigger("change");
					//$("#schedule_div input[name='mealses']").each(function(){
					//	$(this).attr("onclick","return false");
					//});
					clickMealses();
				});
	

});

function planIn(){
	var _url = ctx+'/common/classInfo/queryResult.do';
	var param = {};
	param['pageIndex']=1;
	param['pageSize']=1000;
	param['state']='1';
	ajaxUrl(_url,param,function(json){
		var select_type= "标准班次<br /><select id=\"class_select\">";
		var flag = 0;
		$.each(json.rows, function (n, value) {  
        	select_type +="<option value=\""+value.id+"\" "+('<%=oti.getClass_id()%>'==value.id||flag==0?"selected":"")+">"+value.class_name+"</option>";
        	flag++;
        });
        select_type+="</select>";
		$("#type_sub").append(select_type);
		select_type="";
		$("#class_select").change(function(){
			if($(this).val().Trim()!=''){
				planInSub($(this));
			}
		});
		$("#class_select").trigger("change");
	});
}
function planOut(obj_id){
	var _url = ctx+'/common/scheduleInfoPool/queryResult.do';
	var param = {};
	param['id']=obj_id;
	ajaxUrl(_url,param,function(json){
		$.each(json.rows, function (n, value) {
        	$.each(value,function(name,value) {
				$("#schedule_div #"+name).val(value);
			});
			$("#schedule_div input[name='mealses']").each(function(){
				if(value.meals.indexOf($(this).attr("value"))>-1){
					$(this).attr("checked","checked");
				}else{
					$(this).removeAttr("checked");
				}
			});
        });
        disabledOperat('schedule_div','');
	});
}
function planInSub(obj){
	var _url = ctx+'/common/classInfo/queryResult.do';
	var param = {};
	param['pageIndex']=1;
	param['pageSize']=1000;
	param['state']='1';
	param['id']=obj.val();
	ajaxUrl(_url,param,function(json){
		$.each(json.rows, function (n, value) {
        	$.each(value,function(name,value) {
				$("#schedule_div #"+name).val(value);
			});
			$("#schedule_div input[name='mealses']").each(function(){
				if(value.meals.indexOf($(this).attr("value"))>-1)
					$(this).attr("checked","checked");
				else
					$(this).removeAttr("checked");
			});
			$("#class_id").val(value.id);
			$("#class_name").val(obj.find("option:selected").text());
        });
        disabledOperat('schedule_div','disabled');
	});
}
</script>
<script type="text/javascript" src="${ctx }/faurecia/common/service/schedule/pool/js/schedule_pool.js"></script>
<script type="text/javascript" src="${ctx }/faurecia/common/class_info/js/class_info_ext.js"></script>
</head>
<body>
	<div id="contentwrapper" class="contentwrapper" style="width:90%;">
		<form class="stdform stdform2" onSubmit="return false;">
			<div>
				<div class="widgetbox">
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
					        	<td style="font-weight:bold;" align="center">员工</td>
					        	<td>
					        		<%=StringUtils.defaultIfEmpty(employeeInfo.getZh_name(), "") %>
					        	</td>
					        	<td style="font-weight:bold" align="center">所属职位</td>
					        	<td>
					        		<%=StringUtils.defaultIfEmpty(employeeInfo.getPosition_name(), "") %>
					        	</td>
					        	<td style="font-weight:bold" align="center">部门</td>
					        	<td>
					        		<%=StringUtils.defaultIfEmpty(employeeInfo.getDept_name(), "") %>
					        	</td>
					        </tr>					        
					        <tr>
					        	<td style="font-weight:bold;" align="center">班次开始日期</td>
					        	<td>
					        		<input class="Wdate" type="text" title="班次开始日期" readonly="readonly" id="begin_date" name="begin_date" value="<%=sdf.format(oti.getBegin_date()) %>"  onclick="wdateInstance2();" onblur="getScheduleEndDate();"/>
					        	</td>
					        	<td style="font-weight:bold" align="center">班次结束日期</td>
					        	<td>
					        		<div id="end_date_div"><%=sdf.format(oti.getEnd_date())+" "+oti.getEnd_time() %></div>
					        		<input type="hidden" id="end_date" name="end_date" value="<%=sdf.format(oti.getEnd_date()) %>"/>
					        	</td>
					        	<td style="font-weight:bold" align="center">类型</td>
					        	<td>
					        		<select id="type" name="type">
					        			<%for(int i=0;i<Global.schedule_type.length;i++){ 
					        			String type=Global.schedule_type[i];
					        			%>
					        			<option value="<%=type%>" <%=oti.getType().equals(type)?"selected":"" %>><%=type%></option>
					        			<%} %>
					        		</select>
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold;" align="center" id="type_sub"></td>
					        	<td colspan="5" id="schedule_div"></td>
					        </tr>
			         		</tbody>
			       		</table>
			     	</div>
			   </div>				
			</div>
			<div>
			<input type="hidden" id="available" name="available" value="<%=oti.getAvailable()%>"/>
            <input type="hidden" id="class_id" name="class_id" value="0"/>
            <input type="hidden" id="id" name="id" value="<%=oti.getId()%>"/>
            <input type="hidden" id="class_name" name="class_name" value="<%=oti.getClass_name()%>"/>
            <input type="hidden" id="emp_name" name="emp_name" value="<%=employeeInfo.getZh_name()%>"/>
            <input type="hidden" id="user_id" name="user_id" value="<%=user.getId()%>"/>
            <input type="hidden" id="user_name" name="user_name" value="<%=user.getZh_name()%>"/>
			</div>
		</form>
	</div>
</body>
</html>