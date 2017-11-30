		$(function(){
				$('#contentwrapper #submit').click(function(){
					if(validateForm("contentwrapper")){
						checkTime();
						if (confirm('是否提交？')) {
							//先获取工单号
							ajaxUrl(ctx+'/main/getNumber.do',{},function(json){
								if(json.number!=''){
									var param = getParamsJson("contentwrapper");
									param['wo_number']=json.number;
									$('form #overtime_list #overtime_table_tbody tr').each(function(index,element){
										var a = $(element).children();
										param['begin_date'] = a.eq(0).text();
										param['end_date'] = a.eq(1).text();
										param['over_hour'] = a.eq(2).text();
										ajaxUrlFalse(ctx+'/common/overTimeInfo/overTimeAdd.do',param,function(json){
											if(json.flag=='1'){
											}else{
												parent.showMsgInfo(json.msg+'');
											}
										});
									});
									//ajaxUrl(ctx+'/common/overTimeInfo/overTimeAdd.do',param,'_overTime_');
									parent.document.getElementById('iframe_menu_'+_parent_menu_id).contentWindow.location.reload(true);
								    parent.jClose();
								}else{
									showMsgInfo(json.msg);
								}
							});			
						}
					}
				});
				$('#contentwrapper #editSubmit').click(function(){
					if(validateForm("contentwrapper")){
						checkTime();
						if (confirm('是否提交？')) {
							var param = getParamsJson("contentwrapper");
							ajaxUrl(ctx+'/common/overTimeInfo/overTimeEdit.do',param,'_overTime_');
						}
					}
				});
				
				$('#contentwrapper #closeSubmit').click(function(){
					if(validateForm("contentwrapper")){
						if (confirm('是否提交？')) {
							var param = getParamsJson("contentwrapper");
							ajaxUrl(ctx+'/common/overTimeInfo/overTimeInvalid.do',param,'_overTime_');
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
					var u = ctx+"/common/overTimeInfo/exportCsv.do"; //请求链接
					downFile(u,param);
				});
				
				$("#day_or_hour").change(function(){
					$("#begin_date").val('');
					$("#end_date").val('');
				});
				$("#begin_date").click(function(){
					if($("#day_or_hour").val().indexOf('day')>-1){
						WdatePicker({startDate:'%y-%M-%d',dateFmt:'yyyy-MM-dd',alwaysUseStartDate:true});
						$("#over_hour").val('8');
					}else{
						WdatePicker({startDate:'%y-%M-%d 16:30:00',dateFmt:'yyyy-MM-dd HH:mm:00',alwaysUseStartDate:true});
						$("#over_hour").val('0.5');
					}
				});
		});
		function queryResult(){
			if($('#requestParam_dept_ids').val()==''){
				$('#requestParam_dept_ids').val('0');
			}
			var param = getParams("search");
			if($('#search input[name="search_type"]:checked ').attr('value')=='1'){
				_dataGridFn("overtime_datagrid",ctx+'/common/overTimeInfo/queryResult.do?'+param,overtime_columns,overtime_toolbar);
			}else{
				_dataGridFn("overtime_datagrid",ctx+'/common/overTimeInfo/queryWOResult.do?'+param,total_columns,'');
			}
		}
		function _overTime_(json){
		    if(json.msg!=''){
		    	parent.showMsgInfo(json.msg);
			}else{
			}
		    parent.document.getElementById('iframe_menu_'+_parent_menu_id).contentWindow.location.reload(true);
		    parent.jClose();
		}
