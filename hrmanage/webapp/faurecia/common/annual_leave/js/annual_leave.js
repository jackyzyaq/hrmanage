		$(function(){
				$('#contentwrapper #submit').click(function(){
					if(validateRole()){
						if (confirm('是否提交？')) {
							var param = getParamsJson("contentwrapper");
							ajaxUrl(ctx+'/common/annualLeave/leaveAdd.do',param,'_annual_leave_');
						}
					}
				});
				
				$('#contentwrapper #editSubmit').click(function(){
					if(validateRole()){
						if (confirm('是否提交？')) {
							var param = getParamsJson("contentwrapper");
							ajaxUrl(ctx+'/common/annualLeave/leaveEdit.do',param,'_annual_leave_');
						}
					}
				});
				
				$('#searchUser #searchBtn').click(function(){
					queryResult();
				});			
		});
		function queryResult(){
			var param = getParams("searchUser");
			_dataGridFn("annual_leave_datagrid",ctx+'/common/annualLeave/queryResult.do?'+param,leave_columns,leave_toolbar);
		}
		function _annual_leave_(json){
		    if(json.msg!=''){
		    	showInfo(json.msg);
			}else{
			}
		    parent.document.getElementById('iframe_menu_'+_parent_menu_id).contentWindow.location.reload(true);
		}
		function validateRole(){
			var isTrue = true;
			if($('#status_code').val().Trim()==''){
				alert('请输入编码！');
				isTrue =  false;
			}else
			if($('#work_down').val().Trim()==''||$('#work_up').val().Trim()==''||!isNum($('#work_down').val().Trim())||!isNum($('#work_up').val().Trim())){
				alert('请正确输入社会工龄！');
				isTrue =  false;
			}else
			if($('#leave01').val().Trim()==''||!isNum($('#leave01').val().Trim())){
				alert('请正确输入法定年假！');
				isTrue =  false;
			}else
			if($('#leave02').val().Trim()==''||!isNum($('#leave02').val().Trim())){
				alert('请正确输入公司年假！');
				isTrue =  false;
			}				
			return isTrue;
		}
		
