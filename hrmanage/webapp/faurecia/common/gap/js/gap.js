		$(function(){
				$('#contentwrapper #submit').click(function(){
					if(validateRole()){
						if (confirm('是否提交？')) {
							var param = getParamsJson("contentwrapper");
							ajaxUrl(ctx+'/common/gapInfo/gapAdd.do',param,'_gap_');
						}
					}
				});
				
				$('#contentwrapper #editSubmit').click(function(){
					if(validateRole()){
						if (confirm('是否提交？')) {
							var param = getParamsJson("contentwrapper");
							ajaxUrl(ctx+'/common/gapInfo/gapEdit.do',param,'_gap_');
						}
					}
				});
				
				$('#searchUser #searchBtn').click(function(){
					queryResult();
				});			
		});
		function queryResult(){
			var param = getParams("searchUser");
			_dataGridFn("gap_datagrid",ctx+'/common/gapInfo/queryResult.do?'+param,gap_columns,gap_toolbar);
		}
		function _gap_(json){
		    if(json.msg!=''){
		    	showInfo(json.msg);
			}else{
			}
		    parent.document.getElementById('iframe_menu_'+_parent_menu_id).contentWindow.location.reload(true);
		}
		function validateRole(){
			var isTrue = true;
			if($('#gap_code').val().Trim()==''){
				alert('请输入编码！');
				isTrue =  false;
			}else
			if($('#gap_name').val().Trim()==''){
				alert('请输入名称！');
				isTrue =  false;
			}
			return isTrue;
		}
		
