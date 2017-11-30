		$(function(){
			$('#searchUser #searchBtn').click(function(){
				queryResult();
			});
			queryResult();
		});
		function queryResult(){
			var param = getParams("searchUser");
			_dataGridFn("ts_meals_datagrid",ctx+'/common/timeSheet/queryMealsResult.do?'+param,ts_meals_columns,'');
		}
