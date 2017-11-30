		$(function(){
			$('#searchUser #searchBtn').click(function(){
					queryResult();
			});
			$('#searchUser #exportBtn').click(function(){
				var param = getParams("searchUser");
				click_href(ctx+"/common/departmentKPI/exportCsv.do?"+param);
			});
			queryResult();
		});
		function queryResult(){
			var param = getParams("searchUser");
			_dataGridFn("kpi_data_datagrid",ctx+'/common/departmentKPI/queryResult.do?'+param,kpi_columns,kpi_toolbar);
		}
