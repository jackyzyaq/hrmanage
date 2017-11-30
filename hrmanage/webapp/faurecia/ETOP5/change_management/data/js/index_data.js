		$(function(){
			$('#searchUser #searchBtn').click(function(){
					queryResult();
			});
			//$('#searchUser #exportBtn').click(function(){
			//	var param = getParams("searchUser");
			//	click_href(ctx+"/common/plantKPI/exportCsv.do?"+param);
			//});
			queryResult();
		});
		function queryResult(){
			var param = getParams("searchUser");
			_dataGridFn("change_management_data_datagrid",ctx+'/common/change_management/queryResult.do?'+param,change_management_columns,change_management_toolbar);
		}
