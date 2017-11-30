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
										for(var i=0;i<emp_ids.length;i++){
											param["emp_id"] = emp_ids[i].split('|')[0];
											param["emp_name"] = emp_ids[i].split('|')[1];
											ajaxUrlFalse(ctx+'/common/scheduleInfoPool/schedulePoolAdd.do',param,function(json){
												if(json.flag=='1'){
												}else{
													showMsgInfo(json.msg+'');
												}
											});
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
								ajaxUrl(ctx+'/common/scheduleInfoPool/schedulePoolEdit.do',param,'_schedule_');
							}
						}
					}
				});
				
				$('#contentwrapper #closeSubmit').click(function(){
					if(validateForm()){
						if (confirm('是否提交？')) {
							var param = getParamsJson("contentwrapper");
							ajaxUrl(ctx+'/common/scheduleInfoPool/scheduleInvalid.do',param,'_schedule_');
						}
					}
				});
				
				$('#search #searchBtn').click(function(){
					queryResult();
				});	
		});
		function queryResult(){
			if($('#requestParam_dept_ids').val()==''){
				$('#requestParam_dept_ids').val('0');
			}
			var param = getParams("search");
			_dataGridFn("schedule_pool_datagrid",ctx+'/common/scheduleInfoPool/queryResult.do?'+param,schedule_pool_columns,schedule_pool_toolbar);
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
		
		
//		function innerFlow(poolIds){
//			for(var i=0;i<poolIds.split(',').length;i++){
//				var poolId = poolIds.split(',')[i];
//				var param={};
//				param['id']=poolId;
//				parent.ajaxUrlFalse(ctx+'/common/scheduleInfoPool/queryResult.do',param,function(json){
//					$.each(json.rows, function (n, value) {
//						if(value.available==1){
//							param = {};
//							$.each(value,function(name,value) {
//								param[name] = value;
//							});
//							param['id'] = param['0'];
//							param['emp_ids'] = param['emp_id'];
//							param['end_date'] = param['begin_date'];
//							parent.ajaxUrlFalse(ctx+'/common/scheduleInfo/scheduleAdd.do',param,function(json){
//								if(json.flag=='1'){
//									param = {};
//									param['id']=poolId;
//									parent.ajaxUrlFalse(ctx+'/common/scheduleInfoPool/schedulePoolInvalid.do',param,function(json){
//									    if(json.flag=='1'){
//										}else{
//											parent.showMsgInfo(json.msg);
//										}
//									});
//								}else{
//									parent.showMsgInfo(json.msg+'');
//								}
//							});
//						}
//			        });
//				});
//			}
//			queryResult();
//		}
//		
//		function innerFlow1(poolIds){
//			for(var i=0;i<poolIds.split(',').length;i++){
//				var poolId = poolIds.split(',')[i];
//				var param={};
//				param['id']=poolId;
//				ajaxUrlFalse(ctx+'/common/scheduleInfoPool/queryResult.do',param,function(json){
//					$.each(json.rows, function (n, value) {
//						if(value.available==1){
//							param = {};
//							$.each(value,function(name,value) {
//								param[name] = value;
//							});
//							param['id'] = param['0'];
//							param['emp_ids'] = param['emp_id'];
//							param['end_date'] = param['begin_date'];
//							ajaxUrlFalse(ctx+'/common/scheduleInfo/scheduleAdd.do',param,function(json){
//								if(json.flag=='1'){
//									param = {};
//									param['id']=poolId;
//									ajaxUrlFalse(ctx+'/common/scheduleInfoPool/schedulePoolInvalid.do',param,function(json){
//									    if(json.flag=='1'){
//										}else{
//											parent.showMsgInfo(json.msg);
//										}
//									});
//								}else{
//									parent.showMsgInfo(json.msg+'');
//								}
//							});
//						}
//			        });
//				});
//			}
//			parent.jClose();
//		}
		
		function addBatchToSchedule(poolIds){
			var msg = '';
			for(var i=0;i<poolIds.split(',').length;i++){
				var poolId = poolIds.split(',')[i];
				msg +=addToSchedule(poolId);
			}
			return msg;
		}
		
		function addToSchedule(poolId){
			var msg = '';
			if(poolId.Trim().length>0){
				var param={};
				param['id']=poolId;
				ajaxUrlFalse(ctx+'/common/scheduleInfoPool/queryResult.do',param,function(json){
					$.each(json.rows, function (n, value) {
						if(value.available==1){
							param = {};
							$.each(value,function(name,value) {
								param[name] = value;
							});
							param['id'] = param['0'];
							param['emp_ids'] = param['emp_id'];
							param['end_date'] = param['begin_date'];
							ajaxUrlFalse(ctx+'/common/scheduleInfo/scheduleAdd.do',param,function(json){
								if(json.flag=='1'){
									param = {};
									param['id']=poolId;
									ajaxUrlFalse(ctx+'/common/scheduleInfoPool/schedulePoolInvalid.do',param,function(json){
									    if(json.flag=='1'){
										}else{
											msg +=json.msg+"<br/>";
										}
									});
								}else{
									msg +=json.msg+"<br/>";
								}
							});
						}
			        });
				});
			}else{
				msg +="请先选择一条记录<br/>";
			}
			return msg;
		}
