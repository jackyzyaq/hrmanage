		$(function(){
			$('#contentwrapper #actionSubmit').click(function(){
				if(validateMenu()){
					if (confirm('是否提交？')) {
						var param = getParamsJson("contentwrapper");
						ajaxUrl(ctx+'/authority/actionInfo/actionAdd.do',param,'_action_');
					}
				}
			});
			
			$('#contentwrapper #editSubmit').click(function(){
				if(validateMenu()){
					if (confirm('是否提交？')) {
						var param = getParamsJson("contentwrapper");
						ajaxUrl(ctx+'/authority/actionInfo/actionEdit.do',param,'_action_');
					}
				}
			});			
		});
		function _action_(json){
		    if(json.msg!=''){
		    	showInfo(json.msg);
			}else{
			}
		    parent.document.getElementById('iframe_menu_'+_parent_menu_id).contentWindow.location.reload(true);
		}
		function validateMenu(){
			var isTrue = true;
			$("#action_menu_id").val($("#requestParam_parent_id").val());
			if($('#action_menu_id').val().Trim()==''){
				alert('请选择菜单！');
				isTrue =  false;
			}else
			if($('#action_code').val().Trim()==''){
				alert('请输入动作代码！');
				isTrue =  false;
			}else
			if($('#action_name').val().Trim()==''){
				alert('请动作名称！');
				isTrue =  false;
			}
			return isTrue;
		}
