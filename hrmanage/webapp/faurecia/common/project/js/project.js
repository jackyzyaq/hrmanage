		$(function(){
				$('#contentwrapper #submit').click(function(){
					if(validateRole()){
						if (confirm('是否提交？')) {
							var param = getParamsJson("contentwrapper");
							ajaxUrl(ctx+'/common/projectInfo/projectAdd.do',param,'_project_');
						}
					}
				});
				
				$('#contentwrapper #editSubmit').click(function(){
					if(validateRole()){
						if (confirm('是否提交？')) {
							var param = getParamsJson("contentwrapper");
							ajaxUrl(ctx+'/common/projectInfo/projectEdit.do',param,'_project_');
						}
					}
				});
				
				$('#searchUser #searchBtn').click(function(){
					queryResult();
				});			
		});
		function queryResult(){
			var param = getParams("searchUser");
			_dataGridFn("project_datagrid",ctx+'/common/projectInfo/queryResult.do?'+param,project_columns,project_toolbar);
		}
		function _project_(json){
		    if(json.msg!=''){
		    	showInfo(json.msg);
			}else{
			}
		    parent.document.getElementById('iframe_menu_'+_parent_menu_id).contentWindow.location.reload(true);
		}
		function validateRole(){
			var isTrue = true;
			if($('#project_code').val().Trim()==''){
				alert('请输入编码！');
				isTrue =  false;
			}else
			if($('#project_name').val().Trim()==''){
				alert('请输入名称！');
				isTrue =  false;
			}
			return isTrue;
		}
		
