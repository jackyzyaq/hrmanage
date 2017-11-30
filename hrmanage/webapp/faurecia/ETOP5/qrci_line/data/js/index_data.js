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
			_dataGridFn("qrci_line_data_datagrid",ctx+'/common/qrci_line/queryResult.do?'+param,qrci_line_columns,qrci_line_toolbar);
		}
