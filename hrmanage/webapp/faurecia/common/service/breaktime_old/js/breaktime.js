		$(function(){
			$("#upload_uuid").attr("norequired","norequired");
				$('#contentwrapper #submit').click(function(){
					if(validateForm("contentwrapper")){
						if($('form #breaktime_list').length>0){
							if (confirm(($("#upload_uuid").val()==''?"需要上传的相关证明文件为空，":"")+'是否提交？')) {
								//先获取工单号
								ajaxUrl(ctx+'/main/getNumber.do',{},function(json){
									if(json.number!=''){
										var param = getParamsJson("contentwrapper");
										param['wo_number']=json.number;
										param['class_date'] = param['class_date']+' 00:00:00';
										$('form #breaktime_list #breaktime_table_tbody tr').each(function(index,element){
											var a = $(element).children();
											param['begin_date'] = a.eq(0).text();
											param['end_date'] = a.eq(1).text();
											param['break_hour'] = a.eq(2).text();
											param['class_date'] = a.eq(3).text();
											ajaxUrlFalse(ctx+'/common/breakTimeInfo/breakTimeAdd.do',param,function(json){
												if(json.flag=='1'){
												}else{
													parent.showMsgInfo(json.msg+'');
												}
											});
										});
										parent.document.getElementById('iframe_menu_'+_parent_menu_id).contentWindow.location.reload(true);
									    parent.jClose();
									}else{
										parent.showMsgInfo(json.msg+'');
									}
								});
							}
						}
					}
				});
				$('#contentwrapper #editSubmit').click(function(){
					if(validateForm("contentwrapper")){
						var begin_date = parseDate($('#begin_date').val());//请假开始时间
						var b_hour = parseFloat($('#hours').val())+parseFloat(parseInt($('#have_meals').val())/60);//标准时长
						var b_begin_time = $("#begin_time").val();
						var break_hour = parseFloat($('#break_hour').val())+parseFloat(parseInt($('#have_meals').val())/60);//请假时数
						var b_begin_date = parseDate($('#class_date').val()+" "+b_begin_time);//标准上班时间
						var b_end_date = new Date(b_begin_date.getTime()+getTimeInMillis(b_hour, 'h'));//标准下班时间
						if((begin_date.getTime()+getTimeInMillis(break_hour, 'h'))>b_end_date.getTime()){
							showMsgInfo('超过标准下班时间！');
						}else{
							if (confirm(($("#upload_uuid").val()==''?"需要上传的相关证明文件为空，":"")+'是否提交？')) {
								var param = getParamsJson("contentwrapper");
								param['class_date'] = param['class_date']+' 00:00:00';
								ajaxUrl(ctx+'/common/breakTimeInfo/breakTimeEdit.do',param,'_breakTime_');
							}
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
			if($('#search input[name="search_type"]:checked ').attr('value')=='1'){
				_dataGridFn("breaktime_datagrid",ctx+'/common/breakTimeInfo/queryResult.do?'+param,breaktime_columns,breaktime_toolbar);
			}else{
				_dataGridFn("breaktime_datagrid",ctx+'/common/breakTimeInfo/queryWOResult.do?'+param,total_columns,'');
			}
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