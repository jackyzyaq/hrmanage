		$(function(){
				$('#contentwrapper #submit').click(function(){
					if(validateRole()){
						if (confirm('是否提交？')) {
							var param = getParamsJson("contentwrapper");
							ajaxUrl(ctx+'/authority/roleInfo/roleAdd.do',param,'_role_');
						}
					}
				});
				
				$('#contentwrapper #editSubmit').click(function(){
					if(validateRole()){
						if (confirm('是否提交？')) {
							var param = getParamsJson("contentwrapper");
							ajaxUrl(ctx+'/authority/roleInfo/roleEdit.do',param,'_role_');
						}
					}
				});
				
				$('#contentwrapper #menuAuthoritySubmit').click(function(){
					if (confirm('是否提交？')) {
						var param = getParamsJson("contentwrapper");
						ajaxUrl(ctx+'/authority/roleInfo/roleAuthorityMenu.do',param,'_role_');
					}
				});	
				
				$('#contentwrapper #userAuthoritySubmit').click(function(){
					if (confirm('是否提交？')) {
						var param = getParamsJson("contentwrapper");
						ajaxUrl(ctx+'/authority/roleInfo/roleAuthorityUser.do',param,'_role_');
					}
				});		
				
				$('#contentwrapper #deptAuthoritySubmit').click(function(){
					if (confirm('是否提交？')) {
						var param = getParamsJson("contentwrapper");
						ajaxUrl(ctx+'/authority/roleInfo/roleAuthorityDept.do',param,'_role_');
					}
				});					
				
				$('#searchUser #searchBtn').click(function(){
					queryResult();
				});			
		});
		function queryResult(){
			var param = getParams("searchUser");
			_dataGridFn("role_datagrid",ctx+'/authority/roleInfo/queryResult.do?'+param,role_columns,role_toolbar);
		}
		function _role_(json){
		    if(json.msg!=''){
		    	showInfo(json.msg);
			}else{
			}
		    parent.document.getElementById('iframe_menu_'+_parent_menu_id).contentWindow.location.reload(true);
		}
		function validateRole(){
			var isTrue = true;
			if($('#role_code').val().Trim()==''){
				alert('请输入角色代码！');
				isTrue =  false;
			}else
			if($('#role_name').val().Trim()==''){
				alert('请角色名称！');
				isTrue =  false;
			}else
			if($('#description').val().Trim()==''){
				alert('请输入描述！');
				isTrue =  false;
			}
			return isTrue;
		}
		
