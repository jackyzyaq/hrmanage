		$(function(){
				$('#contentwrapper #submit').click(function(){
					if(validateForm("contentwrapper")){
						if (confirm('是否提交？')) {
							var param = getParamsJson("contentwrapper");
							ajaxUrl(ctx+'/common/flowInfo/flowAdd.do',param,'_flow_');
						}
					}
				});
				
				$('#contentwrapper #editSubmit').click(function(){
					if(validateForm()){
						if (confirm('是否提交？')) {
							var param = getParamsJson("contentwrapper");
							ajaxUrl(ctx+'/common/flowInfo/flowEdit.do',param,'_flow_');
						}
					}
				});
				
				$('#searchUser #searchBtn').click(function(){
					queryResult();
				});			
		});
		function queryResult(){
			var param = getParams("searchUser");
			_dataGridFn("flow_datagrid",ctx+'/common/flowInfo/queryResult.do?'+param,flow_columns,flow_toolbar);
		}
		function _flow_(json){
		    if(json.msg!=''){
		    	showInfo(json.msg);
			}else{
			}
		    parent.document.getElementById('iframe_menu_'+_parent_menu_id).contentWindow.location.reload(true);
		}
		function validateRole(){
			var isTrue = true;
			if($('#flow_code').val().Trim()==''){
				alert('请输入编码！');
				isTrue =  false;
			}else
			if($('#flow_name').val().Trim()==''){
				alert('请选择名称！');
				isTrue =  false;
			}
			return isTrue;
		}
		
