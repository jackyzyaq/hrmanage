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
			_dataGridFn("plant_data_datagrid",ctx+'/common/plant/queryResult.do?'+param,plant_columns,plant_toolbar);
		}
