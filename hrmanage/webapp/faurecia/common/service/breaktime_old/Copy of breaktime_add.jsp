<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.authority.pojo.UserInfo" %>
<%
	UserInfo user = (UserInfo)session.getAttribute("user");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	EmployeeInfoService employeeInfoService = (EmployeeInfoService) ctx.getBean("employeeInfoService");
	int emp_id=0;
	try{
		emp_id = Integer.parseInt(user.getName());
	}catch(Exception e){
	}
	EmployeeInfo employeeInfo = employeeInfoService.queryById(emp_id);
	if(employeeInfo==null)
		return ;
	String flow_type = Global.flow_type[1];
	String employee_type = Global.employee_type[1];
	
	Calendar c = Calendar.getInstance();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript">
$(function(){
	$("#file").attr("accept","<%=Global.UPLOAD_ACCEPT_2%>");
	loadFlowStep('1');
	
	//var params = {};
	//params['emp_name']='test';
	//params['emp_id_str']='emp_id';
	//params['parent_div']='#contentwrapper';
	//inner_html(ctx+'/share/jsp/auto_employee.jsp',params,'contentwrapper #auto_emp',null);
	
	classIn();
});
function classIn(){
	var _url = ctx+'/common/classInfo/queryResult.do';
	var param = {};
	param['pageIndex']=1;
	param['pageSize']=1000;
	param['state']='1';
	ajaxUrl(_url,param,function(json){
		var select_type= "标准班次<br /><select id=\"class_select\">";
		var flag = 0;
		$.each(json.rows, function (n, value) {  
        	select_type +="<option value=\""+value.id+"\" "+(flag==0?"selected":"")+">"+value.class_name+"</option>";
        	flag++;
        });
        select_type+="</select>";
		$("#class_div").append(select_type);
		select_type="";
		$("#class_select").change(function(){
			if($(this).val().Trim()!=''){
				classInSub($(this));
			}
		});
		$("#class_select").trigger("change");
	});
}
function classInSub(obj){
	var _url = ctx+'/common/classInfo/queryResult.do';
	var param = {};
	param['pageIndex']=1;
	param['pageSize']=1000;
	param['state']='1';
	param['id']=obj.val();
	ajaxUrl(_url,param,function(json){
		$.each(json.rows, function (n, value) {
        	$("#class_info_div").html("<Strong>班次日期：</Strong><input style=\"width:80px;height:6px !important;;\" type=\"text\" title=\"班次日期\" readonly=\"readonly\" id=\"class_date\" name=\"class_date\" value=\"<%=sdf.format(c.getTime())%>\"  onclick=\"wdateInstance2(function(){checkTime();});\"/><br/>"+
        							  "<Strong>上班时间："+value.begin_time+"</Strong>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;"+
        							  "<Strong>下班时间："+value.end_time+"</Strong>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;"+
        							  "<Strong>时长Hour："+value.hours+"</Strong>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;"+
        							  "<Strong>用餐Hour："+parseFloat(parseInt(value.have_meals)/60)+"</Strong>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;"+
        							  "<Strong>（运算时系统已扣除用餐时间）</Strong>");
			$("#class_id").val(value.id);
			$("#begin_time").val(value.begin_time);
			$("#end_time").val(value.end_time);
			$("#have_meals").val(value.have_meals);
			$("#hours").val(value.hours);
			$("#over_hour").val(value.over_hour);
			$("#begin_date").val($("#class_date").val()+" "+value.begin_time);
			checkTime();
        });
	});
}
</script>
<script type="text/javascript" src="${ctx }/faurecia/common/service/breaktime/js/breaktime.js"></script>
</head>
<body>
	<div id="contentwrapper" class="contentwrapper" style="width:90%;">
		<form class="stdform stdform2" onSubmit="return false;">
			<div id="flow_step"></div>
			<div>
				<div class="widgetbox">
					<div class="widgetcontent padding0 statement">
				   		<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
					        <thead>
					            <tr>
					                <th class="head1" style="width:15%"></th>
					                <th class="head1" style="width:20%"></th>
					                <th class="head1" style="width:15%"></th>
					                <th class="head1" style="width:20%"></th>
					                <th class="head1" style="width:10%"></th>
					                <th class="head1" style="width:20%"></th>
					            </tr>
					        </thead>
					        <tbody>
					        <tr>
					        	<td style="font-weight:bold;" align="center">部门</td>
					        	<td>
					        		<%=StringUtils.defaultIfEmpty(employeeInfo.getDept_name(), "") %>
					        	</td>
					        	<td style="font-weight:bold" align="center">员工</td>
					        	<td>
					        		<%=employeeInfo.getZh_name() %>
					        	</td>
					        	<td style="font-weight:bold" align="center">类型</td>
					        	<td>
					        		<select id="type" name="type">
					        			<%for(int i=0;i<Global.breaktime_type.length;i++){ 
					        			String type = Global.breaktime_type[i].split("\\|")[0];
					        			String hour = Global.breaktime_type[i].split("\\|")[1];
					        			%>
					        			<option value="<%=type%>" lowest_hour="<%=hour %>" <%=i==0?"selected":"" %>><%=type%></option>
					        			<%} %>
					        		</select>
					        	</td>
					        </tr>
					        <tr id="year_tr"></tr>
					        <tr>
					        	<td style="font-weight:bold;" align="center" id="class_div"></td>
					        	<td colspan="5" id="class_info_div"></td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold;" align="center">开始时间</td>
					        	<td>
					        		<input class="Wdate" type="text" title="开始时间" readonly="readonly" id="begin_date" name="begin_date" value=""  onclick="wdateTimeInstance();" onblur="checkTime();"/>
					        	</td>
					        	<td style="font-weight:bold" align="center">休假时数</td>
					        	<td>
					        		<input type="text" title="休假时数" name="break_hour" id="break_hour" class="smallinput" value="0" onblur="replaceForHalf(this);checkTime();"  onafterpaste="replaceForHalf(this);"/>&nbsp; 小时
					        	</td>
					        	<td style="font-weight:bold" align="center">结束时间</td>
					        	<td>
					        		<input class="Wdate" type="text" title="结束时间" readonly="readonly" id="end_date" name="end_date" value="" />
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold;" align="center">休假事由</td>
					        	<td colspan="5">
					        		<textarea rows="4" class="longinput" name="remark" id="remark" title="休假事由"></textarea>
					        	</td>
					        </tr>
					        <tr>
								<td style="font-weight:bold" colspan="6">
									<div>
							        	<jsp:include page="/share/jsp/upload_file.jsp"></jsp:include>
							    	</div>
							    	<div>
						       			仅支持<%=Global.UPLOAD_ACCEPT_2 %>图片文件，且文件小于<%=Global.UPLOAD_SIZE_2/1000 %>KB
						    		</div>
								</td>
							</tr>					        
			         		</tbody>
			       		</table>
			     	</div>
			   </div>				
			</div>
            <div>
            <input type="hidden" id="status" name="status" value="<%=Global.flow_check_status[0]%>"/>
            <input type="hidden" id="check_state" name="check_state" value="<%=Global.flow_check_state[0]%>"/>
            <input type="hidden" id="user_id" name="user_id" value="<%=user.getId()%>"/>
            <input type="hidden" id="user_name" name="user_name" value="<%=user.getZh_name()%>"/>
            <input type="hidden" id="dept_id" name="dept_id" value="<%=employeeInfo.getDept_id()%>"/>
            <input type="hidden" id="emp_id" name="emp_id" value="<%=employeeInfo.getId()%>" title="员工"/>
            <input type="hidden" id="emp_name" name="emp_name" value="<%=employeeInfo.getZh_name()%>" title="员工"/>
            <input type="hidden" id="class_id" name="class_id" value="0"/>
            <input type="hidden" id="begin_time" name="begin_time" value=""/>
            <input type="hidden" id="end_time" name="end_time" value=""/>
            <input type="hidden" id="have_meals" name="have_meals" value=""/>
            <input type="hidden" id="hours" name="hours" value=""/>
            <input type="hidden" id="over_hour" name="over_hour" value=""/>
            <input type="hidden" id="tmpyear" value="0"/>
            <input type="hidden" id="flow_type" value="<%=flow_type%>"/>
            <input type="hidden" id="employee_type" value="<%=employee_type%>"/>
			<button id="submit" class="submit radius2">提交</button>
			</div>
		</form>
	</div>
</body>
</html>