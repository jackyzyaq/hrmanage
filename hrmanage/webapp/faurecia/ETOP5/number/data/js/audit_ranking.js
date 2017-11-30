$(function(){
	$("#dept_name").focus(function(){
		if($("#requestParam_dept_id").val()!=''){
			//deptEmployee();
			var params = {};
			params['dept_id']=$("#requestParam_dept_id").val();
			inner_html(ctx+'/share/jsp/employee_ztree.jsp',params,'dept_employee_td_id',function(data){
				$("#dept_employee_td_id").html(data);
				$("#emp_name").focus(function(){
					if($("#emp_id").val()!='0'&&$("#emp_id").val()!=''){
						$("#dept_employee_id").val($("#emp_name").val());
					}
				});
			});
		}
	});
	$("#begin_month").click(function(){
		wdateYearMonthInstance('begin_month',function(){
			getEndMonthFn();
		});
	});
	//$("#begin_month").trigger("click");	
});
function ranking_inner(url,params,obj_id){
	inner_html(url,params,obj_id,null);
}
function getHeader(begin_month,end_month){
	var _url = ctx+'/common/auditranking/queryHeaderResult.do';
	var param = {};
	param['state']='1';
	param['pageIndex']=1;
	param['pageSize']=1;
	param['type']=audit_header;
	param['begin_month']=begin_month+"-01 00:00:00";
	param['end_month']=end_month+"-01 00:00:00";
	ajaxUrl(_url,param,function(json){
		$("#audit_header").empty();
		$("#audit_header").append("<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" class=\"stdtable\"><thead><tr><th class=\"head1\"></th><th class=\"head1\"></th><th class=\"head1\"></th><th class=\"head1\"></th></tr></thead><tbody></tbody></table>");
		if(json.rows.length>0){
			var _td = "<tr>";
			$.each(json.rows, function (n, value) { 
				_td +="<td>"+value.header_1+"</td>"+
				"<td>"+value.header_2+"</td>"+
				"<td>"+value.header_3+"</td>"+
				"<td>"+value.header_4+"</td>";
	        });
			$("#audit_header table tbody").append(_td+"</tr>");
			$("#audit_header table tbody").append("<tr>"+
					"<td><input class='longinput' title=\"kpi_1\" type=\"text\" id='kpi_1' name='kpi_1' value=''/></td>"+
					"<td><input class='longinput' title=\"kpi_2\" type=\"text\" id='kpi_2' name='kpi_2' value=''/></td>"+
					"<td><input class='longinput' title=\"kpi_3\" type=\"text\" id='kpi_3' name='kpi_3' value=''/></td>"+
					"<td><input class='longinput' title=\"kpi_4\" type=\"text\" id='kpi_4' name='kpi_4' value=''/></td>"+
					"</tr>");
			$("#audit_header table tbody").append("<tr><td colspan=\"4\">"+
					"	<div class=\"stdformbutton\">"+
					"		<input type=\"hidden\" id=\"over_all\" name=\"over_all\" value=\"0\"/>"+
					"		<button id=\"auditRankingSubmit\" class=\"submit radius2\" onclick=\"addKPIData();\">提交</button>"+
					"		<span id=\"over_all_value\"></span>"+
					"	</div>"+
					"</td></tr>");
		}else{
			$("#audit_header table tbody").append("<tr>"+
					"<td><input class='longinput' title=\"header_1\" type=\"text\" id='header_1' name='header_1' value=''/></td>"+
					"<td><input class='longinput' title=\"header_2\" type=\"text\" id='header_2' name='header_2' value=''/></td>"+
					"<td><input class='longinput' title=\"header_3\" type=\"text\" id='header_3' name='header_3' value=''/></td>"+
					"<td><input class='longinput' title=\"header_4\" type=\"text\" id='header_4' name='header_4' value=''/></td>"+
					"</tr>");
			$("#audit_header table tbody").append("<tr><td colspan=\"4\">"+
					"	<div class=\"stdformbutton\">"+
					"		<button id=\"auditRankingHeaderSubmit\" class=\"submit radius2\" onclick=\"addHeader();\">提交</button>"+
					"	</div>"+
					"</td></tr>");
		}
	});
}

function addHeader(){
	if(validateForm("audit_header")){
		if (confirm('是否提交？')) {
			var param = getParamsJson("audit_header");
			param['begin_month'] = $("#begin_month").val().Trim()+"-01 00:00:00";
			param['end_month'] = $("#end_month").val().Trim()+"-01 00:00:00";
			ajaxUrl(ctx+'/common/auditranking/auditRankingAddHeader.do',param,function(json){
				if(json.flag=='1'){
				}else{
					showMsgInfo(json.msg+'');
					getEndMonthFn();
				}
			});
		}
	}
}

function addKPIData(){
	if(validateForm("audit_ranking_form")){
		if(overAll().Trim().length>0){
			showMsgInfo('数据格式不对！');
		}else{
			if (confirm('是否提交？')) {
				var param = getParamsJson("audit_ranking_form");
				param['begin_month'] = param['begin_month']+"-01 00:00:00";
				param['end_month'] = param['end_month']+"-01 00:00:00";
				ajaxUrl(ctx+'/common/auditranking/auditRankingAdd.do',param,function(json){
					if(json.flag=='1'){
					}else{
						showMsgInfo(json.msg+'');
						parent.document.getElementById('iframe_menu_'+_menu_id).contentWindow.location.reload(true);
						getEndMonthFn();
					}
				});
			}
		}
	}
}

function getEndMonthFn(){
	if($("#begin_month").val().Trim().length>0){
		var newDate = DateAdd("m ", 2, parseDate($("#begin_month").val()+"-01"));
		$("#end_month").val(newDate.format("yyyy-MM"));
		getHeader($("#begin_month").val().Trim(),$("#end_month").val().Trim());
		audit_ranking_view_inner();
	}
}

function audit_ranking_view_inner(){
	var params = {};
	params['begin_month'] = $("#begin_month").val().Trim()+"-01 00:00:00";
	params['end_month'] = $("#end_month").val().Trim()+"-01 00:00:00";
	ranking_inner(ctx+'/faurecia/ETOP5/number/data/audit_ranking_view.jsp',params,'audit_ranking_view');
}
function overAll(){
	var msg = '';
	if(!isNumeric($("#kpi_1").val())||
				!isNumeric($("#kpi_2").val())||
				!isNumeric($("#kpi_3").val())||
				!isNumeric($("#kpi_4").val())){
		msg = '数据格式不对！';
	}else{
		var overall  = 	((parseFloat($("#kpi_1").val())+
						parseFloat($("#kpi_2").val())+
						parseFloat($("#kpi_3").val())+
						parseFloat($("#kpi_4").val()))/4).toFixed(2);
		$("#over_all").val(overall);
		$("#over_all_value").html("总分（<font >"+(overall)+"</font>）");
	}
	return msg;
}