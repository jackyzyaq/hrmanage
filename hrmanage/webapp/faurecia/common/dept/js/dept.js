		$(function(){
				$('#contentwrapper #submit').click(function(){
					if(validateRole()){
						if (confirm('是否提交？')) {
							var param = getParamsJson("contentwrapper");
							ajaxUrl(ctx+'/common/departmentInfo/deptAdd.do',param,'_dept_');
						}
					}
				});
				
				$('#contentwrapper #editSubmit').click(function(){
					if(validateRole()){
						if (confirm('是否提交？')) {
							var param = getParamsJson("contentwrapper");
							ajaxUrl(ctx+'/common/departmentInfo/deptEdit.do',param,'_dept_');
						}
					}
				});
				
				$('#searchUser #searchBtn').click(function(){
					queryResult();
				});			
		});
		function queryResult(){
			var param = getParams("searchUser");
			_dataGridFn("dept_datagrid",ctx+'/common/departmentInfo/queryResult.do?'+param,dept_columns,dept_toolbar);
		}
		function _dept_(json){
		    if(json.msg!=''){
		    	showInfo(json.msg);
			}else{
			}
		    parent.document.getElementById('iframe_menu_'+_parent_menu_id).contentWindow.location.reload(true);
		}
		function validateRole(){
			var isTrue = true;
			if($('#dept_code').val().Trim()==''){
				alert('请输入角色代码！');
				isTrue =  false;
			}else
			if($('#dept_name').val().Trim()==''){
				alert('请角色名称！');
				isTrue =  false;
			}else
			if($('#description').val().Trim()==''){
				alert('请输入描述！');
				isTrue =  false;
			}
			return isTrue;
		}
		
