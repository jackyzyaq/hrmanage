		$(function(){
			$('#contentwrapper #ok').click(function(){
				if(validateForm("contentwrapper")){
					checkTime();
				}
			});
			
			$('#contentwrapper #closeSubmit').click(function(){
				if(validateForm("contentwrapper")){
					if (confirm('是否提交？')) {
						var param = getParamsJson("contentwrapper");
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
		});
		
		function submitClick(){
			if(validateForm("contentwrapper")){
				if($('form #breaktime_list').length>0){
					if (confirm(($("#upload_uuid").val()==''?"需要上传的相关证明文件为空，":"")+'是否提交？')) {
						//先获取工单号
						ajaxUrl(ctx+'/main/getNumber.do',{},function(json){
							if(json.number!=''){
								var param = getParamsJson("contentwrapper");
								param['wo_number']=json.number;
								$('form #breaktime_list #breaktime_table_tbody tr').each(function(index,element){
									var a = $(element).children();
									if(typeof(a.eq(0).attr("colspan")) == "undefined"){
										param['class_id'] = a.eq(0).text();
										param['schedule_id'] = a.eq(1).text();
										param['emp_id'] = a.eq(2).text();
										param['begin_date'] = a.eq(4).text();
										param['end_date'] = a.eq(5).text();
										param['break_hour'] = a.eq(6).text();
										param['class_date'] = a.eq(7).text()+' 00:00:00';
										ajaxUrlFalse(ctx+'/common/breakTimeInfo/breakTimeAdd.do',param,function(json){
											if(json.flag=='1'){
											}else{
												parent.showMsgInfo(json.msg+'');
											}
										});
									}
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
		}
		
		function editSubmitClick(){
			if(validateForm("contentwrapper")){
				if($('form #breaktime_list').length>0){
					if (confirm(($("#upload_uuid").val()==''?"需要上传的相关证明文件为空，":"")+'是否提交？')) {
						var param = getParamsJson("contentwrapper");
						$('form #breaktime_list #breaktime_table_tbody tr').each(function(index,element){
							var a = $(element).children();
							if(typeof(a.eq(0).attr("colspan")) == "undefined"){
								if(index==0){
									param['class_id'] = a.eq(0).text();
									param['schedule_id'] = a.eq(1).text();
									param['emp_id'] = a.eq(2).text();
									param['begin_date'] = a.eq(4).text();
									param['end_date'] = a.eq(5).text();
									param['break_hour'] = a.eq(6).text();
									param['class_date'] = a.eq(7).text()+' 00:00:00';
									//param['b_begin_date'] = a.eq(8).text();
									//param['b_end_date'] = a.eq(9).text();
									ajaxUrl(ctx+'/common/breakTimeInfo/breakTimeEdit.do',param,'_breakTime_');
								}
							}
						});
					}
				}
			}
		}		
		
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
