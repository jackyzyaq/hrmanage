		$(function(){
				$('#contentwrapper #submit').click(function(){
					if(validateRole()){
						if (confirm('是否提交？')) {
							var param = getParamsJson("contentwrapper");
							ajaxUrl(ctx+'/common/leaveType/typeAdd.do',param,'_leave_type_');
						}
					}
				});
				
				$('#contentwrapper #editSubmit').click(function(){
					if(validateRole()){
						if (confirm('是否提交？')) {
							var param = getParamsJson("contentwrapper");
							ajaxUrl(ctx+'/common/leaveType/typeEdit.do',param,'_leave_type_');
						}
					}
				});
				
				$('#searchUser #searchBtn').click(function(){
					queryResult();
				});			
		});
		function queryResult(){
			var param = getParams("searchUser");
			_dataGridFn("leave_type_datagrid",ctx+'/common/leaveType/queryResult.do?'+param,leave_type_columns,leave_type_toolbar);
		}
		function _leave_type_(json){
		    if(json.msg!=''){
		    	showInfo(json.msg);
			}else{
			}
		    parent.document.getElementById('iframe_menu_'+_parent_menu_id).contentWindow.location.reload(true);
		}
		function validateRole(){
			var isTrue = true;
			if($('#type_code').val().Trim()==''){
				alert('请输入编码！');
				isTrue =  false;
			}else
			if($('#type_name').val().Trim()==''){
				alert('请输入名称！');
				isTrue =  false;
			}
			return isTrue;
		}
		
