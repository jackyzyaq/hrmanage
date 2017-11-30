		$(function(){
			$('#searchUser #searchBtn').click(function(){
				queryResult();
			});
			//$('#searchUser #exportBtn').click(function(){
			//	var param = getParams("searchUser");
			//	click_href(ctx+"/common/kpiTypeKPI/exportCsv.do?"+param);
			//});
			queryResult();
		});
		function queryResult(){
			var param = getParams("searchUser");
			_dataGridFn("kpiType_data_datagrid",ctx+'/common/kpiType/queryResult.do?'+param,kpiType_columns,kpiType_toolbar);
		}
