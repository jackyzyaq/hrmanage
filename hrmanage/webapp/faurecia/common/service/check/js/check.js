		$(function(){
				$('#search #searchBtn').click(function(){
					queryResult();
				});	
		});
		function queryResult(){
			if($('#requestParam_dept_ids').val()==''){
				$('#requestParam_dept_ids').val('0');
			}
			var param = getParams("search");
			var check_url_=$('#search input[name="flow_type"]:checked ').attr('flow_type_url');
			var check_column_=$('#search input[name="flow_type"]:checked ').attr('flow_type_column');
			_dataGridFn("check_datagrid",ctx+check_url_+param,eval(check_column_),check_toolbar);
		}
		function _check_(json){
		    if(json.msg!=''){
		    	parent.showMsgInfo(json.msg);
			}else{
			}
		    parent.document.getElementById('iframe_menu_'+_parent_menu_id).contentWindow.location.reload(true);
		    parent.jClose();
		}