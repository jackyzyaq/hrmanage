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
			_dataGridFn("tour_data_datagrid",ctx+'/common/tour/queryResult.do?'+param,tour_columns,tour_toolbar);
		}
