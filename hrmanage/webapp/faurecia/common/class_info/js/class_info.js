		$(function(){
				$('#contentwrapper #submit').click(function(){
					if(validateForm("contentwrapper")){
						if(checkClassInfo("contentwrapper")){
							if (confirm('是否提交？')) {
								var param = getParamsJson("contentwrapper");
								ajaxUrl(ctx+'/common/classInfo/classInfoAdd.do',param,'_class_info_');
							}
						}
					}
				});
				
				$('#contentwrapper #editSubmit').click(function(){
					if(validateForm("contentwrapper")){
						if(checkClassInfo("contentwrapper")){
							if (confirm('是否提交？')) {
								var param = getParamsJson("contentwrapper");
								ajaxUrl(ctx+'/common/classInfo/classInfoEdit.do',param,'_class_info_');
							}
						}
					}
				});
				
				$('#searchUser #searchBtn').click(function(){
					queryResult();
				});			
		});
		function queryResult(){
			var param = getParams("searchUser");
			_dataGridFn("class_info_datagrid",ctx+'/common/classInfo/queryResult.do?'+param,class_info_columns,class_info_toolbar);
		}
		function _class_info_(json){
		    if(json.msg!=''){
		    	showInfo(json.msg);
			}else{
			}
		    parent.document.getElementById('iframe_menu_'+_parent_menu_id).contentWindow.location.reload(true);
		}
		function checkClassInfo(obj){
			var isTrue = false;
			var mealses = '';
			$("#"+obj+" input[name='mealses']:checked").each(function(){
				mealses+=$(this).val()+",";
				isTrue = true;
			});
			if(mealses.Trim() == ''){
				showMsgInfo("请至少选择一个工作餐！");
			}else{
				$("#meals").val(mealses.substring(0, mealses.length-1));
			}
			return isTrue;
		}
		function checkTime(){
			var t1 = $('#begin_time').val();
			var t2 = $('#over_hour').val();
			var t3 = $('#have_meals').val();
			var t4 = $('#hours').val();
			if(t1!=''&&t2!=''&&t3!=''&&t4!=''){
				var begin_time_hour = parseInt(t1.split(":")[0]);
				var begin_time_minute = parseInt(t1.split(":")[1]);	
				
				var over_hour = parseInt(t2.indexOf('.')>-1?t2.split(".")[0]:t2);
				var over_minute = parseInt(t2.indexOf('.5')>-1?30:0);
				
				var have_meals_minute = parseInt(t3);
				var hour = parseInt(t4);
				
				var total_hour = begin_time_hour+(parseInt((begin_time_minute+over_minute+have_meals_minute)/60)+over_hour+hour);
				var total_minute = (begin_time_minute+over_minute+have_meals_minute)%60;
				
				var end_time = (total_hour%24)+":"+(total_minute<10?"0"+total_minute:total_minute)+":00";
				$('#end_time').val(end_time);
			}
		}