		$(function(){
			$("#upload_uuid").attr("norequired","norequired");
				$('#contentwrapper #batchSubmit').click(function(){
					if(validateForm("contentwrapper")){
						if($('form #breaktime_list').length>0){
							if (confirm(($("#upload_uuid").val()==''?"需要上传的相关证明文件为空，":"")+'是否提交？')) {
								//先获取工单号
								ajaxUrl(ctx+'/main/getNumber.do',{},function(json){
									if(json.number!=''){
										var msg = '';
										var param = getParamsJson("contentwrapper");
										param['wo_number']=json.number;
										param['class_date'] = param['class_date']+' 00:00:00';
										var emp_id = $("#emp_id").val().split(",");
										var emp_name = $("#emp_name").val().split(",");
										for(var i=0;i<emp_id.length;i++){
											param["emp_id"] = emp_id[i];
											param["emp_name"] = emp_name[i];
											$('form #breaktime_list #breaktime_table_tbody tr').each(function(index,element){
												var a = $(element).children();
												param['begin_date'] = a.eq(0).text();
												param['end_date'] = a.eq(1).text();
												param['break_hour'] = a.eq(2).text();
												param['class_date'] = a.eq(3).text();
												ajaxUrlFalse(ctx+'/common/breakTimeInfo/breakTimeAdd.do',param,function(json){
													if(json.flag=='1'){
													}else{
														msg = json.msg;
													}
												});
											});
										}
										if(msg.Trim().length>0){
											parent.showMsgInfo(msg.Trim());
										}
										parent.document.getElementById('iframe_menu_'+_parent_menu_id).contentWindow.location.reload(true);
									    parent.jClose();
									}else{
										showMsgInfo(json.msg);
									}
								});		
							}
						}
					}
				});
		});