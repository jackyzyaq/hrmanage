		$(function(){
			$('#searchUser #searchBtn').click(function(){
				queryResult();
			});
			$('#searchUser #searchExportBtn').click(function(){
				var param = getParams("searchUser");
				var u = ctx+"/common/timeSheet/exportCsv.do"; //请求链接
				downFile(u,param);
			});
			$('#searchUser #searchExportBtn').click(function(){
				if($('#begin_date').val().Trim()==''||$('#end_date').val().Trim()==''){
					showMsgInfo('日期选项不能为空！');
					return false;
				}
				var param = getParams("searchUser");
				var u = ctx+"/common/timeSheet/exportCsv.do"; //请求链接
				downFile(u,param);
			});
			queryResult();
		});
		function queryResult(){
			if($('#requestParam_dept_ids').val()==''){
				$('#requestParam_dept_ids').val('0');
			}
			var param = getParams("searchUser");
			_dataGridFn("ts_datagrid",ctx+'/common/timeSheet/queryResult.do?'+param,ts_columns,ts_toolbar);
		}
		function _ts_(json){
		    if(json.msg!=''){
		    	if(json.id!=''){
		    		$("#NO").text(json.id);
		    	}
		    	showInfo(json.msg);
			}else{
			}
		    document.location.reload(true);
		    parent.document.getElementById('iframe_menu_'+_parent_menu_id).contentWindow.location.reload(true);
		}
		function delTS(ids){
			var param={};
			param['ids']=ids;
			parent.ajaxUrlFalse(ctx+'/common/timeSheet/delEmpTimeSheet.do',param,function(json){
				if(json.flag=='1'){
				}else{
					parent.showMsgInfo(json.msg+'');
				}
			});
			queryResult();
		}		