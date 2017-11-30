		$(function(){
				$('#contentwrapper #submit').click(function(){
					if(validateForm("contentwrapper")){
						if(checkScheduleInfo("contentwrapper")){
							if (confirm('是否提交？')) {
								//先获取工单号
								ajaxUrl(ctx+'/main/getNumber.do',{},function(json){
									if(json.number!=''){
										var param = getParamsJson("contentwrapper");
										
										if(typeof(param['mealses']) == "undefined"){
											param['meals']='-';
										}else{
											param['meals'] = param['mealses'];
										}
										param['wo_number']=json.number;
										var emp_ids = $("#emp_ids").val().split(",");
										var date_str = getAll(param['begin_date'],param['end_date']);
										if(date_str.Trim()!=''){
											var msg = '';
											var date_arry = date_str.split(',');
											for(var date_index=0;date_index<date_arry.length;date_index++){
												param["begin_date"] = date_arry[date_index];
												param["end_date"] = date_arry[date_index];
												for(var i=0;i<emp_ids.length;i++){
													param["emp_id"] = emp_ids[i].split('|')[0];
													param["emp_name"] = emp_ids[i].split('|')[1];
													ajaxUrlFalse(ctx+'/common/scheduleInfo/scheduleAdd.do',param,function(json){
														if(json.flag=='1'){
														}else{
															msg = json.msg;
														}
													});
												}
											}
											if(msg.Trim().length>0){
												showMsgInfo(msg.Trim());
											}
										}
										parent.document.getElementById('iframe_menu_'+_parent_menu_id).contentWindow.location.reload(true);
									    //parent.jClose();
										deptEmployee();
									}else{
										showMsgInfo(json.msg);
									}
								});
							}
						}
					}
				});
				
				$('#contentwrapper #editSubmit').click(function(){
					getScheduleEndDate();
					if(validateForm("contentwrapper")){
						if(checkScheduleInfo("contentwrapper")){
							if (confirm('是否提交？')) {
								var param = getParamsJson("contentwrapper");
								if(typeof(param['mealses']) == "undefined"){
									param['meals']='-';
								}else{
									param['meals'] = param['mealses'];
								}
								ajaxUrl(ctx+'/common/scheduleInfo/scheduleEdit.do',param,'_schedule_');
							}
						}
					}
				});
				
				$('#contentwrapper #closeSubmit').click(function(){
					if(validateForm()){
						if (confirm('是否提交？')) {
							var param = getParamsJson("contentwrapper");
							ajaxUrl(ctx+'/common/scheduleInfo/scheduleInvalid.do',param,'_schedule_');
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
					var u = ctx+"/common/scheduleInfo/exportCsv.do"; //请求链接
					downFile(u,param);
				});
		});
		function queryResult(){
			if($('#requestParam_dept_ids').val()==''){
				$('#requestParam_dept_ids').val('0');
			}
			var param = getParams("search");
			if($('#search input[name="search_type"]:checked ').attr('value')=='1'){
				_dataGridFn("schedule_datagrid",ctx+'/common/scheduleInfo/queryResult.do?'+param,schedule_columns,schedule_toolbar);
			}else{
				_dataGridFn("schedule_datagrid",ctx+'/common/scheduleInfo/queryWOResult.do?'+param,total_columns,'');
			}
		}
		function _schedule_(json){
		    if(json.msg!=''){
		    	parent.showMsgInfo(json.msg);
			}else{
			}
		    parent.document.getElementById('iframe_menu_'+_parent_menu_id).contentWindow.location.reload(true);
		    parent.jClose();
		}
		function checkScheduleInfo(obj){
			var isTrue = false;
			if (typeof($("#select4").val()) != "undefined") {
				var emp_ids = '';
				$("#select4 option").each(function(){
					emp_ids+=$(this).val()+"|"+$(this).text()+",";
					isTrue = true;
		        });
				if(emp_ids.Trim() == ''){
					showMsgInfo("请至少选择一个员工！");
				}else{
					$("#emp_ids").val(emp_ids.substring(0, emp_ids.length-1));
				}
			}else{
				isTrue = true;
			}
			$("#available").val($("#state").val());
			return isTrue;
		}
		function getScheduleEndDate(){
			var begin_date = $('#begin_date').val();
			var begin_time = $('#begin_time').val();
			var over_hour = $('#over_hour').val(),
				hours = $('#hours').val(),
				have_meals = $('#have_meals').val();
			var b_begin_date = parseDate(begin_date+" "+begin_time);//标准上班时间
			var b_end_date = new Date(b_begin_date.getTime()+
										getTimeInMillis(over_hour,'h')+
										getTimeInMillis(hours,'h')+
										getTimeInMillis(have_meals,'m'));//标准下班时间
			$('#end_date').val(b_end_date.format("yyyy-MM-dd"));
			$('#end_date_div').text(b_end_date.format("yyyy-MM-dd hh:mm:ss"));
		}
