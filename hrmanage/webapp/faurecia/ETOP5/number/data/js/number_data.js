$(function(){
	$("#dept_name").focus(function(){
		if($("#requestParam_dept_id").val()!=''){
			deptEmployee();
		}
	});
	$("#begin_month").click(function(){
		wdateYearMonthInstance('begin_month',function(){
			getEndMonthFn();
		});
	});
	getEndMonthFn();
	//$("#begin_month").trigger("click");	
});
function ranking_inner(url,params,obj_id){
	inner_html(url,params,obj_id,null);
}
function deptEmployee(){
	var _url = ctx+'/common/employeeInfo/queryResult.do';
	var param = {};
	param['state']='1';
	param['pageIndex']=1;
	param['pageSize']=1000;
	param['type']=_employee_type;
	param['dept_id']=$("#requestParam_dept_id").val();
	ajaxUrl(_url,param,function(json){
		$("#dept_employee_id").empty();
		var select_emp= "";
		$.each(json.rows, function (n, value) { 
        	select_emp +="<option value=\""+value.zh_name+"\" selected>"+value.zh_name+"</option>";
        });
		$("#dept_employee_id").append(select_emp);
		select_emp="";
	});
}

function getEndMonthFn(){
	if($("#begin_month").val().Trim().length>0){
		var newDate = DateAdd("m ", 1, parseDate($("#begin_month").val()+"-01"));
		$("#end_month").val(newDate.format("yyyy-MM"));
	}
}