		$(function(){
			$('#contentwrapper #submit').click(function(){
				if(validateMenu()){
					if (confirm('是否提交？')) {
						var param = getParamsJson("contentwrapper");
						ajaxUrl(ctx+'/authority/menuInfo/menuAdd.do',param,'_menu_');
					}
				}
			});
			
			$('#contentwrapper #editSubmit').click(function(){
				if(validateMenu()){
					if (confirm('是否提交？')) {
						var param = getParamsJson("contentwrapper");
						ajaxUrl(ctx+'/authority/menuInfo/menuEdit.do',param,'_menu_');
					}
				}
			});
			
			$('#contentwrapper #orderSortSubmit').click(function(){
				if (confirm('是否提交？')) {
					var param = getDragNodesJson();
					ajaxUrl(ctx+'/authority/menuInfo/menuOrderSort.do',param,'_menu_');
				}
			});
			
			$('#searchUser #searchBtn').click(function(){
				queryResult();
			});			
			
	});
	function queryResult(){
		var param = getParams("searchUser");
		_dataGridFn("menu_datagrid",ctx+'/authority/menuInfo/queryResult.do?'+param,menu_columns,menu_toolbar);
	}
		function _menu_(json){
		    if(json.msg!=''){
		    	showInfo(json.msg);
			}else{
			}
		    parent.document.getElementById('iframe_menu_'+_parent_menu_id).contentWindow.location.reload(true);
		}
		function validateMenu(){
			var isTrue = true;
			if($('#menu_code').val().Trim()==''){
				alert('请输入菜单代码！');
				isTrue =  false;
			}else
			if($('#menu_name').val().Trim()==''){
				alert('请菜单名称！');
				isTrue =  false;
			}else
			if($('#url').val().Trim()==''){
				alert('请输入URL地址！');
				isTrue =  false;
			}else
			if($('#description').val().Trim()==''){
				alert('请输入描述！');
				isTrue =  false;
			}
			return isTrue;
		}
