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
	String flow_type = Global.flow_type[0];
	String employee_type = Global.employee_type[1];
	
	Calendar c = Calendar.getInstance();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/faurecia/common/service/schedule/pool/js/schedule_pool.js"></script>
<script type="text/javascript">
var class_info_url = ctx+'/common/classInfo/queryResult.do';
$(function(){
	///// DUAL BOX /////
	var db = $('#dualselect').find('.ds_arrow .arrow');	//get arrows of dual select
	var sel1 = $('#dualselect select:first-child');		//get first select element
	var sel2 = $('#dualselect select:last-child');			//get second select element
	
	sel2.empty(); //empty it first from dom.
	
	db.click(function(){
		var t = ($(this).hasClass('ds_prev'))? 0 : 1;	// 0 if arrow prev otherwise arrow next
		if(t) {
			sel1.find('option').each(function(){
				if($(this).is(':selected')) {
					$(this).attr('selected',false);
					var op = sel2.find('option:first-child');
					sel2.append($(this));
				}
			});	
		} else {
			sel2.find('option').each(function(){
				if($(this).is(':selected')) {
					$(this).attr('selected',false);
					sel1.append($(this));
				}
			});		
		}
	});
	
	inner_html(ctx+'/faurecia/common/class_info/class_info_add_inner.jsp',
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
								disabledOperat('schedule_div','');
							}
						});
						$("#type").val('<%=Global.schedule_type[0]%>');
						$("#type").trigger("change");
						
						$("#dept_name").focus(function(){
							if($("#requestParam_dept_id").val()!=''){
								deptEmployee();
							}
						});
						//$("#schedule_div input[name='mealses']").each(function(){
							//$(this).attr("onclick","return false");
						//});
						clickMealses();
					});	
	

});

function planIn(){
	var _url = class_info_url;
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
function planInSub(obj){
	var _url = class_info_url;
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
				if(value.meals.indexOf($(this).attr("value"))>-1){
					$(this).attr("checked","checked");
				}else{
					$(this).removeAttr("checked");
				}
			});
			$("#class_id").val(value.id);
			$("#class_name").val(obj.find("option:selected").text());
        });
        disabledOperat('schedule_div','disabled');
        $("#remark").removeAttr("disabled");
	});
}
function deptEmployee(){
	var _url = ctx+'/common/employeeInfo/queryResult.do';
	var param = {};
	param['state']='1';
	param['pageIndex']=1;
	param['pageSize']=1000;
	param['type']='<%=Global.employee_type[0]%>';
	param['dept_id']=$("#requestParam_dept_id").val();
	ajaxUrl(_url,param,function(json){
		$("#select3").empty();
		$("#select4").empty();
		var select_emp= "";
		$.each(json.rows, function (n, value) { 
        	select_emp +="<option value=\""+value.id+"\" selected>"+value.zh_name+"</option>";
        });
		$("#select3").append(select_emp);
		select_emp="";
	});
}
</script>
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
					        	<td style="font-weight:bold;" align="center">排班人员</td>
					        	<td>
					        		<%=StringUtils.defaultIfEmpty(employeeInfo.getZh_name(), "") %>
					        	</td>
					        	<td style="font-weight:bold" align="center">所属职位</td>
					        	<td>
					        		<%=StringUtils.defaultIfEmpty(employeeInfo.getPosition_name(), "") %>
					        	</td>
					        	<td style="font-weight:bold" align="center">部门</td>
					        	<td>
					        		<jsp:include page="/share/jsp/dept_role_ztree.jsp"></jsp:include>
					        	</td>
					        </tr>					        
					        <tr>
					        	<td style="font-weight:bold;" align="center">起始排班日期</td>
					        	<td>
					        		<input class="Wdate" type="text" title="起始排班日期" readonly="readonly" id="begin_date" name="begin_date" value="<%=sdf.format(c.getTime()) %>"  onclick="wdateBeginInstance('end_date');"/>
					        	</td>
					        	<td style="font-weight:bold" align="center">截止排班日期</td>
					        	<td>
					        		<input class="Wdate" type="text" title="截止排班日期" readonly="readonly" id="end_date" name="end_date" value="<%=sdf.format(c.getTime()) %>"  onclick="wdateEndInstance('begin_date');"/>
					        	</td>
					        	<td style="font-weight:bold" align="center">类型</td>
					        	<td>
					        		<select id="type" name="type">
					        			<%for(int i=0;i<Global.schedule_type.length;i++){ 
					        			String type=Global.schedule_type[i];
					        			%>
					        			<option value="<%=type%>" <%=i==0?"selected":"" %>><%=type%></option>
					        			<%} %>
					        		</select>
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold;" align="center" id="type_sub"></td>
					        	<td colspan="5" id="schedule_div"></td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold;" align="center">员工</td>
					        	<td colspan="5">
		                            <span id="dualselect" class="dualselect" style="margin-left:0px">
		                            	<select class="uniformselect" title="待选员工" id="select3" name="select3" multiple="multiple" size="10" style="min-width:20px;width:180px;">
		                                </select>
		                                <span class="ds_arrow">
		                                	<span class="arrow ds_prev">&laquo;</span>
		                                    <span class="arrow ds_next">&raquo;</span>
		                                </span>
		                                <select id="select4" name="select4" title="已选员工" multiple="multiple" size="10">
		                                </select>
		                            </span>
					        	</td>
					        </tr>	
			         		</tbody>
			       		</table>
			     	</div>
			   </div>				
			</div>
            <div>
            <input type="hidden" id="available" name="available" value="1"/>
            <input type="hidden" id="emp_ids" name="emp_ids" value="0" title="已选员工"/>
            <input type="hidden" id="class_id" name="class_id" value="0"/>
            <input type="hidden" id="class_name" name="class_name" value=""/>
            <input type="hidden" id="user_id" name="user_id" value="<%=user.getId()%>"/>
            <input type="hidden" id="user_name" name="user_name" value="<%=user.getZh_name()%>"/>
			<button id="submit" class="submit radius2">提交</button>
			</div>
		</form>
	</div>
</body>
</html>