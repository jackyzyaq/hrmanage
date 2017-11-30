		$(function(){
				$('#contentwrapper #submit').click(function(){
					if(validateRole()){
						if (confirm('是否提交？')) {
							var param = getParamsJson("contentwrapper");
							ajaxUrl(ctx+'/common/positionInfo/posAdd.do',param,'_pos_');
						}
					}
				});
				
				$('#contentwrapper #editSubmit').click(function(){
					if(validateRole()){
						if (confirm('是否提交？')) {
							var param = getParamsJson("contentwrapper");
							ajaxUrl(ctx+'/common/positionInfo/posEdit.do',param,'_pos_');
						}
					}
				});
				
				$('#searchUser #searchBtn').click(function(){
					queryResult();
				});			
		});
		function queryResult(){
			var param = getParams("searchUser");
			_dataGridFn("pos_datagrid",ctx+'/common/positionInfo/queryResult.do?'+param,pos_columns,pos_toolbar);
		}
		function _pos_(json){
		    if(json.msg!=''){
		    	showInfo(json.msg);
			}else{
			}
		    parent.document.getElementById('iframe_menu_'+_parent_menu_id).contentWindow.location.reload(true);
		}
		function validateRole(){
			var isTrue = true;
			if($('#pos_code').val().Trim()==''){
				alert('请输入职位代码！');
				isTrue =  false;
			}else
			if($('#pos_name').val().Trim()==''){
				alert('请输入名称！');
				isTrue =  false;
			}
			return isTrue;
		}
		
