		$(function(){
			$("#upload_uuid").attr("norequired","norequired");
				$('#contentwrapper #submit').click(function(){
					if(validateForm("contentwrapper")){
						if (confirm('是否提交？')) {
							var param = getParamsJson("contentwrapper");
							param['class_date'] = param['class_date']+' 00:00:00';
							ajaxUrl(ctx+'/common/breakTimeInfo/breakTimeAdd.do',param,'_breakTime_');
						}
					}
				});
				$('#contentwrapper #editSubmit').click(function(){
					if(validateForm("contentwrapper")){
						if (confirm('是否提交？')) {
							var param = getParamsJson("contentwrapper");
							param['class_date'] = param['class_date']+' 00:00:00';
							ajaxUrl(ctx+'/common/breakTimeInfo/breakTimeEdit.do',param,'_breakTime_');
						}
					}
				});
				
				$('#contentwrapper #closeSubmit').click(function(){
					if(validateForm("contentwrapper")){
						if (confirm('是否提交？')) {
							var param = getParamsJson("contentwrapper");
							param['class_date'] = param['class_date']+' 00:00:00';
							ajaxUrl(ctx+'/common/breakTimeInfo/breakTimeInvalid.do',param,'_breakTime_');
						}
					}
				});
				
				$('#search #searchBtn').click(function(){
					queryResult();
				});
				
				$('#search #searchExportBtn').click(function(){
					if($('#requestParam_dept_ids').val()==''){
						$('#requestParam_dept_ids').val('0');
					}
					var param = getParams("search");
					var u = ctx+"/common/breakTimeInfo/exportCsv.do"; //请求链接
					downFile(u,param);
				});
				
				$("#type").change(function(){
					$("#year_tr").empty();
					var params = {};
					params['emp_id']=$("#emp_id").val();
					var url = '';
					if($(this).val().indexOf('年假')>-1){
						url = ctx+'/common/employeeInfo/empLeaveYear.do';
						ajaxUrl(url,params,function(json){
							leave(json);
							checkTime();
							});
					}else if($(this).val().indexOf('调休')>-1){
						url = ctx+'/common/employeeInfo/empOverYear.do';
						ajaxUrl(url,params,function(json){
							over(json);
							checkTime();
							});
					}
				});
				$("#type").trigger("change");
		});
		function queryResult(){
			if($('#requestParam_dept_ids').val()==''){
				$('#requestParam_dept_ids').val('0');
			}
			var param = getParams("search");
			_dataGridFn("breaktime_datagrid",ctx+'/common/breakTimeInfo/queryResult.do?'+param,breaktime_columns,breaktime_toolbar);
		}
		function _breakTime_(json){
		    if(json.msg!=''){
		    	parent.showMsgInfo(json.msg);
			}else{
			}
		    parent.document.getElementById('iframe_menu_'+_parent_menu_id).contentWindow.location.reload(true);
		    parent.jClose();
		}
		function loadFlowStep(days){
			var params = {};
			params['emp_id']=$("#emp_id").val();
			params['flow_type']=$("#flow_type").val();
			params['days'] = days;//默认1
			inner_html(ctx+'/share/jsp/flow.jsp',params,'flow_step',null);
		}
		function checkTime(){
			var t = $('#class_date').val();//班次日期
			var t1 = $('#begin_date').val();//休假开始时间
			var t2 = $('#break_hour').val();//休假小时数
			var t3 = $('#begin_time').val();//上班时间
			var t4 = $('#end_time').val();//下班时间
			var t5 = $('#have_meals').val();//用餐时间 分钟
			var t6 = $('#hours').val();//标准上班时长
			var t8 = $('#over_hour').val();//标准上班时长
			var t7 = $("#type").find("option:selected").attr("lowest_hour");
			if(t!=''&&t1!=''&&t2!=''&&t3!=''&&t4!=''&&t5!=''&&t6!=''&&t8!=''){
				var begin_date = parseDate(t1);
				var break_hour = parseFloat(t2)+parseFloat(parseInt(t5)/60);
				var b_hour = parseFloat(t6)+parseFloat(t8)+parseFloat(parseInt(t5)/60);//标准时长
				var b_begin_date = parseDate(t+" "+t3);//标准上班时间
				var b_end_date = new Date(b_begin_date.getTime()+getTimeInMillis(b_hour,'h'));//标准下班时间
				
				var lowest_hour = parseFloat(t7);
				
				if(begin_date.getTime()%getTimeInMillis(0.5,'h')!=0){
					showMsgInfo('开始时间格式不符！<br/>必须“hh:00:00”或“hh:30:00”');
					$("#end_date").val('');
				}else if(getTimeInMillis(break_hour,'h')%getTimeInMillis(lowest_hour,'h')!=0){
					showMsgInfo('休假时长最小单位'+lowest_hour+'小时');
					$("#end_date").val('');
				}else{
					if(b_begin_date.getTime()<=begin_date.getTime()&&begin_date.getTime()<b_end_date.getTime()){
						if(break_hour>0){
							var mod = break_hour%b_hour;
							var days = parseInt(break_hour/b_hour);
							var end_date;
							if(begin_date.getTime()+getTimeInMillis(mod,'h')<=b_end_date.getTime()){
								end_date = new Date(begin_date.getTime()+getTimeInMillis(days,'d')+getTimeInMillis(mod,'h'));
							}else{
								var diff_hour = mod-parseFloat((b_end_date.getTime()-begin_date.getTime())/60/60/1000);
								end_date = new Date(b_begin_date.getTime()+getTimeInMillis(days+1,'d')+getTimeInMillis(diff_hour,'h'));
							}
							$("#end_date").val(end_date.format("yyyy-MM-dd hh:mm:ss"));
							if($("#end_date").val()!=''&&$("#end_date").val().split(" ")[1]==t3){
								$("#end_date").val($("#end_date").val().split(" ")[0]+' '+t4);
							}
						}
					}else{
						showMsgInfo('不符合标准班次时间');
						$("#end_date").val('');
					}
				}
			}
		}
		
		function leave(json){
			var select_year= "<td style='font-weight:bold;' align='center'>年份<br /><select id='year' name='year'>";
			var flag = 0;
			$.each(json.rows, function (n, value) {  
	        	select_year +="<option value='"+value.year+"' " +
	        						   "standard_annual_leave='"+value.standard_annual_leave+"' " +
	        						   "annual_leave='"+value.annual_leave+"' " +
	        						   "surplus_annual_leave='"+value.surplus_annual_leave+"' " +
	        						   "standard_company_leave='"+value.standard_company_leave+"' " +
	        						   "company_leave='"+value.company_leave+"' " +
	        						   "surplus_company_leave='"+value.surplus_company_leave+"' " +
	        						   ""+($("#tmpyear").val()==value.year||flag==0?"selected":"")+">"+value.year+"</option>";
	        	flag++;
	        });
			if(flag==0){
				var year = new Date().format("yyyy-MM-dd hh:mm:ss").substr(0,4);
				select_year += "<option value='"+year+"' " +
				   "standard_annual_leave='0' " +
				   "annual_leave='0' " +
				   "surplus_annual_leave='0' " +
				   "standard_company_leave='0' " +
				   "company_leave='0' " +
				   "surplus_company_leave='0' " +
				   "selected>"+year+"</option>";
			}
	        select_year+="</select></td><td colspan='5' id='year_td_2'></td>";
			$("#year_tr").append(select_year);
			select_year="";
			$("#year").change(function(){
				$("#year_td_2").empty();
				var standard_annual_leave = parseFloat($(this).find("option:selected").attr("standard_annual_leave"));
				var surplus_annual_leave = parseFloat($(this).find("option:selected").attr('surplus_annual_leave'));
				var standard_company_leave = parseFloat($(this).find("option:selected").attr('standard_company_leave'));
				var surplus_company_leave = parseFloat($(this).find("option:selected").attr('surplus_company_leave'));
				$("#year_td_2").html(""+
							"<Strong>实际法定年假："+standard_annual_leave+"</Strong>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;"+
							"<Strong>剩余法定年假："+(surplus_annual_leave)+"</Strong>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;"+
							"<Strong>实际公司年假："+standard_company_leave+"</Strong>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;"+
							"<Strong>剩余公司年假："+(surplus_company_leave)+"</Strong>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;"+
						  	"");
			});
			$("#year").trigger("change");
		}
		function over(json){
			var select_year= "<td style='font-weight:bold;' align='center'>年份<br /><select id='year' name='year'>";
			var flag = 0;
			$.each(json.rows, function (n, value) {  
	        	select_year +="<option value='"+value.year+"' " +
	        						   "standard_over_hour='"+value.standard_over_hour+"' " +
	        						   "surplus_over_hour='"+value.surplus_over_hour+"' " +
	        						   ""+($("#tmpyear").val()==value.year||flag==0?"selected":"")+">"+value.year+"</option>";
	        	flag++;
	        });
			if(flag==0){
				var year = new Date().format("yyyy-MM-dd hh:mm:ss").substr(0,4);
				select_year += "<option value='"+year+"' " +
				   "standard_over_hour='0' " +
				   "surplus_over_hour='0' " +
				   "selected>"+year+"</option>";
			}
	        select_year+="</select></td><td colspan='5' id='year_td_2'></td>";
			$("#year_tr").append(select_year);
			select_year="";
			$("#year").change(function(){
				$("#year_td_2").empty();
				var standard_over_hour = parseFloat($(this).find("option:selected").attr("standard_over_hour"));
				var surplus_over_hour = parseFloat($(this).find("option:selected").attr("surplus_over_hour"));
				$("#year_td_2").html(""+
							"<Strong>实际加班时数："+standard_over_hour+"</Strong>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;"+
							"<Strong>剩余加班时数："+(surplus_over_hour)+"</Strong>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;"+
						  	"");
			});
			$("#year").trigger("change");
		}		