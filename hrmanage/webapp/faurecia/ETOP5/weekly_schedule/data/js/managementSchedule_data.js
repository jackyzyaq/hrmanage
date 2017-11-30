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
			_dataGridFn("managementSchedule_data_datagrid",ctx+'/common/managementSchedule/queryResult.do?'+param,managementSchedule_columns,managementSchedule_toolbar);
		}
